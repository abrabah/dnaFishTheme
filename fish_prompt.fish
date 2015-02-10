# name: DNA

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _is_git_staged
    echo (command git diff --cached --no-ext-diff --quiet --exit-code; or echo -n '~')
end

function _is_git_stashed
    echo (command git rev-parse --verify --quiet refs/stash >/dev/null; and echo -n '$')
end


function fish_prompt
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)
  set -l yellow (set_color yellow)
  set -l red (set_color red) 


  set -l arrow "𐤇"

  set -l cwd $blue(basename (prompt_pwd))

  set -l git_branch_name (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
  

  if [ "$git_branch_name" ]
    set -l diff_status (command git rev-list --left-right '@{upstream}...HEAD' ^/dev/null | awk '/>/ {a += 1} /</ {b += 1} END {if (a > 0) printf("%s%d","↑",a); if (b > 0) printf("%s%d","↓",b) }')

    
    if [ (_is_git_stashed) ]
        set git_branch_name "|$git_branch_name|"
    end

    set git_info "$green$git_branch_name"

    if [ (_is_git_dirty) ]
        set git_info "$red$git_branch_name"
    end

    
    if [ (_is_git_staged) ]
        set git_info "$yellow$git_branch_name"
    end


    set git_info ":$git_info$normal $diff_status"

  end

  echo -n -s $cwd $git_info $normal ' ' $arrow ' '
end
