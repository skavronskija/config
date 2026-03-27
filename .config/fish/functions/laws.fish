function laws
    aws list | fzf -q "daft " | xargs aws
end
