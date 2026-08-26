#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")";

EXCLUDES=(".DS_Store" ".osx" "LICENSE-MIT.txt" "README.md" "bootstrap.sh" "gather.sh");

function isExcluded() {
	local file="$1";
	local excluded;
	for excluded in "${EXCLUDES[@]}"; do
		if [ "$file" == "$excluded" ]; then
			return 0;
		fi;
	done;
	return 1;
}

function doIt() {
	local missing=0;
	local unchanged=0;
	local updated=0;
	local file;
	local src;

	while IFS= read -r -d '' file; do
		if isExcluded "$file"; then
			continue;
		fi;

		src="${HOME}/${file}";

		if [ ! -f "$src" ]; then
			echo "  missing    ${file}";
			missing=$((missing + 1));
			continue;
		fi;

		if cmp -s "$src" "$file"; then
			echo "  unchanged  ${file}";
			unchanged=$((unchanged + 1));
			continue;
		fi;

		echo "  updated    ${file}";
		updated=$((updated + 1));
		if [ "$dryRun" != "1" ]; then
			cp "$src" "$file";
		fi;
	done < <(git ls-files -z);

	echo "";
	echo "missing: ${missing}, unchanged: ${unchanged}, updated: ${updated}";
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
unset isExcluded;
