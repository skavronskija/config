function request-review
    set -l root_dir "/Users/antonskavronskij/idea/daft"
    set -l reviewers \
        PatrickDuffy1996 \
        cristianmoisa \
        elias-distilled \
        enrique-alvarez \
        jasonblooddistilled \
        marcin-distilled \
        declanlawlor \
        azmirfakkri

    if not test -d $root_dir
        echo "Error: Root directory does not exist: $root_dir" >&2
        return 1
    end

    set -l folder (find $root_dir -mindepth 1 -maxdepth 1 -type d -not -name '.*' -exec basename {} \; | sort | fzf --prompt="Select folder: ")

    if test -z "$folder"
        echo "No folder selected."
        return 1
    end

    set -l working_dir "$root_dir/$folder"
    echo "Selected: $folder"

    set -l prs (cd $working_dir && gh pr list --author @me --state open --json number,title,headRefName,baseRefName --jq '.[] | "#\(.number) \(.title) [\(.headRefName) -> \(.baseRefName)]"')

    if test $status -ne 0
        echo "Error fetching PRs." >&2
        return 1
    end

    if test -z "$prs"
        echo "No open PRs found."
        return 1
    end

    set -l selected_pr (printf '%s\n' $prs | fzf --prompt="Select PR: ")

    if test -z "$selected_pr"
        echo "No PR selected."
        return 1
    end

    set -l pr_number (string match -r '#(\d+)' $selected_pr)[2]
    set -l reviewers_str (string join "," $reviewers)

    echo "Requesting review for PR #$pr_number from: $reviewers_str"

    cd $working_dir && gh pr edit $pr_number --add-reviewer $reviewers_str

    if test $status -eq 0
        echo "Successfully requested reviews"
    end
end

