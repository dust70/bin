#!/bin/bash
#set -x

# {{{ PATH to search for executables
export PATH="/bin:/usr/bin:/usr/local/bin:/opt/bin"
#}}}

# {{{ global variables to use
declare -r oldpwd="${OLDPWD}"
declare -r pwd="${PWD}"
declare -r repo_path=${repo_path:-~/repositories}

declare -A branches
declare -A cvs_repos
declare -A git_repos
declare -A svn_repos
#}}}

# {{{ trap function
trap "(cd ${oldpwd}; cd ${pwd}) >> /dev/null || return 1" EXIT KILL SIGINT SIGTERM
#}}}

# {{{ repositories to check for
# {{{ git repositories
git_repos["dotfiles"]="git:dotfiles"
git_repos["dotfiles/Skype"]="git:dotfiles/Skype"
git_repos["dotfiles/bash"]="git:dotfiles/bash github github:renatius-de/bash"
git_repos["dotfiles/config"]="git:dotfiles/config"
git_repos["dotfiles/dotmail"]="git:dotfiles/dotmail"
git_repos["dotfiles/git"]="git:dotfiles/git github github:renatius-de/git"
git_repos["dotfiles/gnupg"]="git:dotfiles/gnupg"
git_repos["dotfiles/local"]="git:dotfiles/local github github:renatius-de/local"
git_repos["dotfiles/mutt"]="git:dotfiles/mutt"
git_repos["dotfiles/pass"]="git:dotfiles/pass"
git_repos["dotfiles/shell"]="git:dotfiles/shell github github:renatius-de/shell"
git_repos["dotfiles/ssh"]="git:dotfiles/ssh"
git_repos["dotfiles/subversion"]="git:dotfiles/subversion github github:renatius-de/subversion"
git_repos["dotfiles/task"]="git:dotfiles/task"
git_repos["dotfiles/vim"]="git:dotfiles/vim github github:renatius-de/vim"
git_repos["dotfiles/zsh"]="git:dotfiles/zsh github github:renatius-de/zsh"

git_repos["bin"]="git:bin github github:renatius-de/bin"

git_repos["etc"]="git:etc"

git_repos["gitolite-admin"]="git:gitolite-admin"

git_repos["html/www.rene-six.de"]="git:html/www.rene-six.de"

git_repos["latex/invoice"]="git:latex/invoice"

git_repos["work/docs"]="git:work/docs"
git_repos["work/scripts"]="git:work/scripts"

git_repos["work/vagrant"]="git:work/vagrant"

git_repos["stauzebach/documents"]="stauzebach.git:documents"

git_repos["distributions/catalyst"]="git:distributions/catalyst"

git_repos["php/contao"]="git://github.com/contao/core.git"
git_repos["php/contao-check"]="git://github.com/contao/check.git"
git_repos["php/zendframework_1"]="git://github.com/zendframework/zf1.git"
git_repos["php/zendframework_2"]="git://github.com/zendframework/zf2.git"

#git_repos["arch/aur"]="git://pkgbuild.com/aur-mirror.git"

git_repos["software/git"]="git://github.com/git/git"
git_repos["software/pro-git"]="git://github.com/progit/progit.git"
#}}}

# {{{ subversion repositories
svn_repos["php/magento"]="http://svn.magentocommerce.com/source/branches/1.8"
#}}}
#}}}

# {{{ branches to use
branches["Documents"]="desktop"

branches["dotfiles"]="desktop himalia"
branches["dotfiles/config"]="desktop"
branches["dotfiles/dotmail"]="desktop"
branches["dotfiles/local"]="desktop"
branches["dotfiles/ssh"]="desktop"

branches["etc"]="amalthea callisto desktop europa ganymed himalia io server raspi"

branches["php/zend_framework"]="develop"
#}}}

# {{{ function git_clean
function git_clean () {
    git reflog expire --all &> /dev/null
    git fsck --unreachable --full &> /dev/null
    git prune &> /dev/null
    git gc --aggressive --quiet &> /dev/null
    git repack -Adq &> /dev/null
    git prune-packed --quiet &> /dev/null
}
#}}}

# {{{ function git_run
function git_run() {
    if ! $(which git > /dev/null 2>&1); then
        # quit silently
        return 0
    fi

    if [ ${#@} -ne 3 ]; then
        echo "wrong number of parameter"
        return 1
    fi

    mkdir -p "$(dirname ${1})" &> /dev/null || (
        echo "Couldn't create parent directories for" ${1}
        return 1
    )

    local -a orig_remotes=(${2})
    local -A local_remotes=()

    if [ ${#orig_remotes[*]} -lt 1 ]; then
        echo "no remotes"
        return 1
    elif [ ${#orig_remotes[*]} -eq 1 ]; then
        local_remotes["origin"]="${orig_remotes[0]}"
    elif (( ${#orig_remotes[*]} % 2 == 0 )); then
        echo "number of remotes must be odd"
        return 1
    else
        for (( i=0; i < ${#orig_remotes[*]}; i++ )); do
            if [ ${i} -eq 0 ]; then
                local key="origin"
            else
                local key=${orig_remotes[${i}]}
                ((i++))
            fi
            local_remotes["${key}"]="${orig_remotes[${i}]}"
        done
    fi

    if [ ! -d "${1}"/.git ]; then
        local -r tmpdir=/tmp/${1}

        [ -f "${1}" ] && rm "${1}" >> /dev/null

        if [ -d "${1}" ]; then
            rmdir "${1}" >> /dev/null || return 1
        fi

        mkdir -p "$(dirname ${tmpdir})"

        git clone -o origin "${local_remotes["origin"]}" "${tmpdir}" >> /dev/null || return 1
        mv "${tmpdir}" "${1}" >> /dev/null

        cd "${1}" >> /dev/null

        local -a local_branches=("$(git name-rev --name-only origin/HEAD)" ${3})
        for branch in "${local_branches[@]}"; do
            git checkout -q "${branch}" &> /dev/null || return 1
            git checkout -q -f >> /dev/null || return 1
            git submodule -q init
        done

        for key in ${!local_remotes[@]}; do
            git remote add -f "${key}" "${local_remotes[${key}]}" &> /dev/null
        done

        git checkout -q "${local_branches[0]}" >> /dev/null || return 1
        git submodule -q foreach --recursive "git checkout -q \"${local_branches[0]}\"" >> /dev/null || return 1

        rmdir -p "$(dirname ${tmpdir})" &> /dev/null || true
    else
        cd "${1}" >> /dev/null
        local -a local_branches=("$(git name-rev --name-only origin/HEAD)" ${3})

        for key in ${!local_remotes[@]}; do
            git remote add -f "${key}" "${local_remotes[${key}]}" &> /dev/null

            git remote update -p "${key}" &> /dev/null || return 1
            git remote prune "${key}" &> /dev/null || return 1

            git fetch "${key}" &> /dev/null || return 1
            git fetch -q -t "${key}" &> /dev/null || return 1
        done

        for branch in ${local_branches[@]}; do
            git stash save -q >> /dev/null || true
            git checkout -q "${branch}" &> /dev/null || return 1
            git reset --hard -q &> /dev/null || return 1
            git merge -q origin/"${branch}" &>/dev/null || true
            git rebase -n -q origin/"${branch}" &> /dev/null || return 1
            git stash pop -q &> /dev/null || true

            git submodule -q init
        done

        find "${1}" \( -iname '*.orig' -o -name '*.BASE.*' -o -name '*.LOCAL.*' -o -name '*.REMOTE.*' -o -name '*.BACKUP.*' \) -delete

        git checkout -q "${local_branches[0]}" >> /dev/null || return 1

        while ! $(git_clean >> /dev/null); do true; done
    fi
}
#}}}

# {{{ function svn_run
function svn_run() {
    if ! $(which svn > /dev/null 2>&1); then
        # quit silently
        return 0
    fi

    if [ ${#@} -ne 2 ]; then
        echo "wrong number of parameter"
        return 1
    fi

    mkdir -p "$(dirname ${1})" >> /dev/null 2>&1 || (
        echo "Couldn't create parent directories for" ${1}
        return 1
    )

    if [ ! -d "${1}"/.svn ]; then
        local -r tmpdir=/tmp/${1}

        [ -f "${1}" ] && rm "${1}" >> /dev/null

        if [ -d "${1}" ]; then
            rmdir "${1}" >> /dev/null || return 1
        fi

        mkdir -p "$(dirname ${tmpdir})"

        svn checkout "${2}" "${tmpdir}" >> /dev/null || return 1

        mv "${tmpdir}" "${1}" >> /dev/null

        cd "${1}" >> /dev/null

        rmdir -p "$(dirname ${tmpdir})" >> /dev/null 2>&1 || true
    else
        cd "${1}" >> /dev/null

        svn update --force &> /dev/null || return 1
    fi
}
#}}}

mkdir -p "${repo_path}" >> /dev/null 2>&1 || (
    echo "can't create directory" ${repo_path}
    return 1
)

for key in $(echo -e "${!git_repos[@]}" | tr " " "\n" | sort -u | tr "\n" " "); do
    declare repo=${repo_path}/${key}
    echo -n "${repo}..."
    git_run "${repo}" "${git_repos[${key}]}" "${branches[${key}]}" || exit 1
    unset repo
    echo " done!"
done

for key in $(echo -e "${!svn_repos[@]}" | tr " " "\n" | sort -u | tr "\n" " "); do
    declare repo=${repo_path}/${key}
    echo -n "${repo}..."
    svn_run "${repo}" "${svn_repos[${key}]}" || exit 1
    unset repo
    echo " done!"
done

#echo "# CVS repositories:" ${#cvs_repos[@]}
echo "# GIT reposituries:" ${#git_repos[@]}
echo "# SVN repositories:" ${#svn_repos[@]}
unset branches cvs_repos git_repos svn_repos

cd ${oldpwd} >> /dev/null
cd ${pwd} >> /dev/null

# vim: foldmethod=marker textwidth=80 filetype=sh
