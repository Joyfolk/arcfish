function fish_arc_prompt --description 'Prompt function for Arc'
    if not command -sq arc
        return 1
    end
    set -l repo_info (command arc rev-parse --arc-dir --is-inside-arc-dir --is-bare-repository --is-inside-work-tree HEAD 2>/dev/null)
    test -n "$repo_info"
    or return

    set -l branch (command arc info|grep branch|sed 's/^.*: //')
    set -l staged (command arc diff --staged --name-only|wc -l)
    set -l modified (command arc diff --name-only|wc -l)

    set -l branch_color $___fish_git_prompt_color_branch
    set -l branch_done $___fish_git_prompt_color_branch_done

    set -l space "$___fish_git_prompt_color$___fish_git_prompt_char_stateseparator$___fish_git_prompt_color_done"
    set -l stashed (command arc stash list|wc -l)
    if test $stashed -gt 0
        set sts "..."
    end
    set -l b "$branch_color$branch$branch_done"

    if test $modified -gt 0 || test $staged -gt 0
        printf " (%s|%s+%s%s)" $b $modified $staged $sts
    else
        printf " (%s%s)" $b $sts
    end
end

