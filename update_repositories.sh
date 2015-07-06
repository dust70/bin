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

# {{{ repositories to check for
# {{{ dotfiles
git_repos["dotfiles"]="git@git.renatius.net:dotfiles"
git_repos["dotfiles/Skype"]="git@git.renatius.net:dotfiles/Skype"
git_repos["dotfiles/bash"]="git@git.renatius.net:dotfiles/bash github git@github.com:renatius-de/bash"
git_repos["dotfiles/config"]="git@git.renatius.net:dotfiles/config"
git_repos["dotfiles/dotmail"]="git@git.renatius.net:dotfiles/dotmail"
git_repos["dotfiles/git"]="git@git.renatius.net:dotfiles/git github git@github.com:renatius-de/git"
git_repos["dotfiles/gnupg"]="git@git.renatius.net:dotfiles/gnupg"
# git_repos["dotfiles/local"]="git@git.renatius.net:dotfiles/local github git@github.com:renatius-de/local"
git_repos["dotfiles/mutt"]="git@git.renatius.net:dotfiles/mutt"
git_repos["dotfiles/pass"]="git@git.renatius.net:dotfiles/pass"
git_repos["dotfiles/shell"]="git@git.renatius.net:dotfiles/shell github git@github.com:renatius-de/shell"
git_repos["dotfiles/ssh"]="git@git.renatius.net:dotfiles/ssh"
# git_repos["dotfiles/subversion"]="git@git.renatius.net:dotfiles/subversion github git@github.com:renatius-de/subversion"
# git_repos["dotfiles/task"]="git@git.renatius.net:dotfiles/task"
git_repos["dotfiles/tmux"]="git@git.renatius.net:dotfiles/tmux github git@github.com:renatius-de/tmux"
git_repos["dotfiles/vim"]="git@git.renatius.net:dotfiles/vim github git@github.com:renatius-de/vim"
git_repos["dotfiles/zsh"]="git@git.renatius.net:dotfiles/zsh github git@github.com:renatius-de/zsh"
#}}}

# {{{ misc
git_repos["bin"]="git@git.renatius.net:bin github git@github.com:renatius-de/bin"

git_repos["etc"]="git@git.renatius.net:etc"

git_repos["gitolite-admin"]="git@git.renatius.net:gitolite-admin"

# git_repos["html/www.rene-six.de"]="git@git.renatius.net:html/www.rene-six.de"
#}}}

# {{{ projects
git_repos["projects/invoicing"]="git@bitbucket.org:renatius_de/invoicing.git"
#}}}

# {{{ work
git_repos["latex/invoice"]="git@git.renatius.net:latex/invoice"

# git_repos["work/docs"]="git@git.renatius.net:work/docs"
# git_repos["work/scripts"]="git@git.renatius.net:work/scripts"

git_repos["work/vagrant"]="git@bitbucket.org:renatius_de/vagrant"

#git_repos["stauzebach/documents"]="stauzebach.git@git.renatius.net:documents"
#}}}

# {{{ cbn
git_repos["cbn/preisvergleich-backend"]="git@bitbucket.org:ostec/preisvergleich-backend.git"
git_repos["cbn/preisvergleich-behat"]="git@bitbucket.org:ostec/preisvergleich-behat.git"
git_repos["cbn/preisvergleich-frontend"]="git@bitbucket.org:ostec/preisvergleich-frontend.git"
git_repos["cbn/preisvergleich-library"]="git@bitbucket.org:ostec/preisvergleich-library.git"
git_repos["cbn/preisvergleich-update"]="git@bitbucket.org:ostec/preisvergleich-update.git"
git_repos["cbn/shoprocket"]="git@bitbucket.org:ostec/shoprocket.git"
#}}}

# {{{ software
#git_repos["distributions/catalyst"]="git@git.renatius.net:distributions/catalyst"

#git_repos["php/contao"]="git://github.com/contao/core.git"
#git_repos["php/contao-check"]="git://github.com/contao/check.git"
# git_repos["php/opcache-gui"]="git://github.com/amnuts/opcache-gui.git"
git_repos["php/zendframework_1"]="git://github.com/zendframework/zf1.git"
git_repos["php/zendframework_2"]="git://github.com/zendframework/zf2.git"

git_repos["php/phpunit"]="git://github.com/sebastianbergmann/phpunit.git"
# git_repos["php/phpcpd"]="git://github.com/sebastianbergmann/phpcpd.git"

git_repos["software/git"]="git://github.com/git/git"
#git_repos["software/pro-git"]="git://github.com/progit/progit.git"
# git_repos["software/python-guide"]="git://github.com/kennethreitz/python-guide.git"

svn_repos["php/magento"]="http://svn.magentocommerce.com/source/branches/1.8"
#}}}
#}}}

# {{{ branches to use
# {{{ dotfiles
branches["dotfiles"]="desktop himalia"
branches["dotfiles/config"]="desktop"
branches["dotfiles/local"]="desktop"
branches["dotfiles/ssh"]="desktop"
#}}}

# {{{ misc
branches["etc"]="desktop europa ganymed himalia io server"
#}}}

# {{{ projects
branches["projects/invoicing"]="development"
#}}}

# {{{ cbn
branches["cbn/preisvergleich-backend"]="development"
branches["cbn/preisvergleich-frontend"]="development"
branches["cbn/preisvergleich-library"]="development"
branches["cbn/preisvergleich-update"]="development"
branches["cbn/shoprocket"]="development"
#}}}
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

        pushd "${1}" >> /dev/null

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
        popd >> /dev/null
    else
        pushd "${1}" >> /dev/null
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
        popd >> /dev/null
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

    mkdir -p "$(dirname "${1}")" >> /dev/null 2>&1 || (
        echo "Couldn't create parent directories for ${1}"
        return 1
    )

    if [ ! -d "${1}"/.svn ]; then
        local -r tmpdir=/tmp/"${1}"

        [ -f "${1}" ] && rm "${1}" >> /dev/null

        if [ -d "${1}" ]; then
            rmdir "${1}" >> /dev/null || return 1
        fi

        mkdir -p "$(dirname ${tmpdir})"

        svn checkout "${2}" "${tmpdir}" >> /dev/null || return 1

        mv "${tmpdir}" "${1}" >> /dev/null

        pushd "${1}" >> /dev/null

        rmdir -p "$(dirname ${tmpdir})" >> /dev/null 2>&1 || true

        popd >> /dev/null
    else
        pushd "${1}" >> /dev/null

        svn update --force &> /dev/null || return 1

        popd >> /dev/null
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
    sync
    echo " done!"
done

for key in $(echo -e "${!svn_repos[@]}" | tr " " "\n" | sort -u | tr "\n" " "); do
    declare repo=${repo_path}/${key}
    echo -n "${repo}..."
    svn_run "${repo}" "${svn_repos[${key}]}" || exit 1
    unset repo
    sync
    echo " done!"
done

#echo "# CVS repositories:" ${#cvs_repos[@]}
echo "# GIT reposituries:" ${#git_repos[@]}
echo "# SVN repositories:" ${#svn_repos[@]}
unset branches cvs_repos git_repos svn_repos

cd ${oldpwd} >> /dev/null
cd ${pwd} >> /dev/null

# vim: foldmethod=marker textwidth=80 filetype=sh
