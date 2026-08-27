#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")";

IGNORE_FILE=".gatherignore";

shopt -s nullglob dotglob;

function isIgnoredEntry() {
	local path="$1";
	local base="${path##*/}";
	local pattern;
	local stripped;

	while IFS= read -r pattern || [ -n "$pattern" ]; do
		case "$pattern" in
			""|"#"*|"!"*)
				continue;
				;;
			"/"*)
				stripped="${pattern#/}";
				stripped="${stripped%/}";
				if [ "$path" == "$stripped" ]; then
					return 0;
				fi;
				;;
			*)
				stripped="${pattern%/}";
				case "$stripped" in
					*/*)
						continue;
						;;
					*)
						if [[ "$base" == $stripped ]]; then
							return 0;
						fi;
						;;
				esac;
				;;
		esac;
	done < "$IGNORE_FILE";

	return 1;
}

function hasDirectFiles() {
	local dir="$1";
	local entry;
	local rel;

	for entry in "./${dir}"/*; do
		if [ -f "$entry" ] || [ -L "$entry" ]; then
			rel="${entry#./}";
			if ! isIgnoredEntry "$rel"; then
				return 0;
			fi;
		fi;
	done;

	return 1;
}

function collectRoots() {
	local dir="$1";
	local entry;
	local rel;

	if hasDirectFiles "$dir"; then
		echo "$dir";
		return;
	fi;

	for entry in "./${dir}"/*; do
		if [ -d "$entry" ]; then
			rel="${entry#./}";
			if ! isIgnoredEntry "$rel"; then
				collectRoots "$rel";
			fi;
		fi;
	done;
}

function buildSyncList() {
	local entry;
	local rel;

	for entry in ./*; do
		rel="${entry#./}";

		if isIgnoredEntry "$rel"; then
			continue;
		fi;

		if [ -d "$entry" ]; then
			collectRoots "$rel";
		elif [ -f "$entry" ] || [ -L "$entry" ]; then
			echo "$rel";
		fi;
	done;
}

function doIt() {
	local syncList=();
	local present=();
	local missing=0;
	local new=0;
	local updated=0;
	local entry;
	local listFile;
	local dryFlag="";
	local line;
	local flags;
	local path;

	while IFS= read -r entry; do
		syncList+=("$entry");
	done < <(buildSyncList);

	for entry in "${syncList[@]}"; do
		if [ -e "${HOME}/${entry}" ]; then
			present+=("$entry");
		else
			echo "  missing    ${entry}";
			missing=$((missing + 1));
		fi;
	done;

	if [ "${#present[@]}" -gt 0 ]; then
		listFile="$(mktemp)";
		trap 'rm -f "$listFile"' EXIT;
		printf '%s\n' "${present[@]}" > "$listFile";

		if [ "$dryRun" == "1" ]; then
			dryFlag="-n";
		fi;

		while IFS= read -r line; do
			case "$line" in
				">"*)
					flags="${line%% *}";
					path="${line#* }";
					if [ "${flags:1:1}" != "f" ]; then
						continue;
					fi;
					if [[ "$flags" == *"+"* ]]; then
						echo "  new        ${path}";
						new=$((new + 1));
					else
						echo "  updated    ${path}";
						updated=$((updated + 1));
					fi;
					;;
				[.ch\<]*)
					continue;
					;;
				*)
					echo "$line" >&2;
					;;
			esac;
		done < <(rsync -rlpDic --files-from="$listFile" --exclude-from="$IGNORE_FILE" ${dryFlag} "${HOME}/" "./");
	fi;

	echo "";
	echo "new: ${new}, updated: ${updated}, missing: ${missing}";
	echo "";
	git status --short;
}

dryRun=0;
force=0;

while [ "$#" -gt 0 ]; do
	case "$1" in
		-n|--dry-run)
			dryRun=1;
			;;
		-f|--force)
			force=1;
			;;
		*)
			echo "Usage: gather.sh [-n|--dry-run] [-f|--force]" >&2;
			exit 1;
			;;
	esac;
	shift;
done;

if [ "$dryRun" == "1" ]; then
	echo "Dry run - no files will be written";
	doIt;
elif [ "$force" == "1" ]; then
	doIt;
else
	read -p "This will overwrite repo files with the versions from ${HOME}. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
unset buildSyncList;
unset collectRoots;
unset hasDirectFiles;
unset isIgnoredEntry;
