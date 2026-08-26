function laws --description 'Pick an aws CLI alias with fzf and run it, logging in to SSO first if needed'
    set -l selection (aws list | fzf -q "daft $argv" | string trim)

    test -n "$selection"
    or return 1

    if not __laws_authenticated $selection
        echo "laws: AWS credentials missing or expired, running 'aws login'" >&2
        aws login
        or return 1
    end

    aws $selection
end

function __laws_authenticated --description 'Check that the profile behind an aws CLI alias has usable credentials'
    set -l profile (__laws_alias_profile $argv[1])

    test -n "$profile"
    or return 0

    aws sts get-caller-identity --profile $profile >/dev/null 2>&1
end

function __laws_alias_profile --description 'Print the --profile value used by an aws CLI alias'
    set -l alias_file $HOME/.aws/cli/alias

    test -f $alias_file
    or return 1

    awk -v name="$argv[1]" '
        {
            if (!found) {
                if ($1 == name && $2 == "=") { found = 1 } else { next }
            } else if ($2 == "=") { exit }
            for (i = 1; i < NF; i++) if ($i == "--profile") { print $(i + 1); exit }
        }
    ' $alias_file
end
