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
git_repos["dotfiles/bash"]="git:dotfiles/bash github github:dust70/bash"
git_repos["dotfiles/config"]="git:dotfiles/config"
git_repos["dotfiles/dotmail"]="git:dotfiles/dotmail"
git_repos["dotfiles/eclipse"]="git:dotfiles/eclipse github github:dust70/eclipse"
git_repos["dotfiles/git"]="git:dotfiles/git github github:dust70/git"
git_repos["dotfiles/gnupg"]="git:dotfiles/gnupg"
git_repos["dotfiles/local"]="git:dotfiles/local github github:dust70/local"
git_repos["dotfiles/mutt"]="git:dotfiles/mutt"
git_repos["dotfiles/shell"]="git:dotfiles/shell github github:dust70/shell"
git_repos["dotfiles/Skype"]="git:dotfiles/Skype"
git_repos["dotfiles/ssh"]="git:dotfiles/ssh"
git_repos["dotfiles/task"]="git:dotfiles/task"
git_repos["dotfiles/vim"]="git:dotfiles/vim github github:dust70/vim"
git_repos["dotfiles/zsh"]="git:dotfiles/zsh github github:dust70/zsh"

git_repos["dotfiles/bash/LiquidPrompt"]="git://github.com/nojhan/liquidprompt.git"
git_repos["dotfiles/git/GitIgnoreRepo"]="git://github.com/github/gitignore.git"

git_repos["dotfiles/vim/PHPCTags"]="git://github.com/dust70/PHPCTags.git"

git_repos["dotfiles/vim/bundle/Align"]="git://github.com/dust70/Align.git"
git_repos["dotfiles/vim/bundle/AutoPairs"]="git://github.com/dust70/AutoPairs.git"
git_repos["dotfiles/vim/bundle/BashSupport"]="git://github.com/dust70/BashSupport.git"
git_repos["dotfiles/vim/bundle/Calendar"]="git://github.com/dust70/Calendar.git"
git_repos["dotfiles/vim/bundle/ColorSchemes"]="git://github.com/dust70/Colorschemes.git"
git_repos["dotfiles/vim/bundle/ColorV"]="git://github.com/dust70/ColorV.git"
git_repos["dotfiles/vim/bundle/Commander"]="git://github.com/dust70/Commander.git"
git_repos["dotfiles/vim/bundle/Conque"]="git://github.com/dust70/Conque.git"
git_repos["dotfiles/vim/bundle/CSS3Syntax"]="git://github.com/dust70/CSS3Syntax.git"
git_repos["dotfiles/vim/bundle/CSSSyntax"]="git://github.com/dust70/CSSSyntax.git"
git_repos["dotfiles/vim/bundle/CSV"]="git://github.com/dust70/CSV.git"
git_repos["dotfiles/vim/bundle/CtrlP"]="git://github.com/dust70/CtrlP.vim.git"
git_repos["dotfiles/vim/bundle/CtrlPFunky"]="git://github.com/dust70/CtrlPFunky.git"
git_repos["dotfiles/vim/bundle/DBExt"]="git://github.com/dust70/DBExt.git"
git_repos["dotfiles/vim/bundle/Detailed"]="git://github.com/dust70/Detailed.git"
git_repos["dotfiles/vim/bundle/EnhancedCommentify"]="git://github.com/dust70/EnhancedCommentify.git"
git_repos["dotfiles/vim/bundle/Eunuch"]="git://github.com/dust70/Eunuch.git"
git_repos["dotfiles/vim/bundle/FuGITive"]="git://github.com/dust70/FuGITive.git"
git_repos["dotfiles/vim/bundle/GitRebaseHelper"]="git://github.com/dust70/GitRebaseHelper.git"
git_repos["dotfiles/vim/bundle/GnuPG"]="git://github.com/dust70/GnuPG.git"
git_repos["dotfiles/vim/bundle/GoogleVim"]="git://github.com/dust70/GoogleVim.git"
git_repos["dotfiles/vim/bundle/HTML5"]="git://github.com/dust70/HTML5.git"
git_repos["dotfiles/vim/bundle/LaTeX"]="git://git.code.sf.net/p/vim-latex/vim-latex"
git_repos["dotfiles/vim/bundle/Neocomplcache"]="git://github.com/dust70/Neocomplcache.git"
git_repos["dotfiles/vim/bundle/NerdTree"]="git://github.com/scrooloose/nerdtree.git"
git_repos["dotfiles/vim/bundle/Obsession"]="git://github.com/dust70/Obsession.git"
git_repos["dotfiles/vim/bundle/Outliner"]="git://github.com/dust70/Outliner.git"
git_repos["dotfiles/vim/bundle/Pager"]="git://github.com/dust70/Pager.git"
git_repos["dotfiles/vim/bundle/PathOGen"]="git://github.com/dust70/PathOGen.git"
git_repos["dotfiles/vim/bundle/PHPAnnotationsSyntax"]="git://github.com/dust70/PHPAnnotationsSyntax.git"
git_repos["dotfiles/vim/bundle/PHPComplete"]="git://github.com/dust70/PHPComplete.git"
git_repos["dotfiles/vim/bundle/PHPDictionary"]="git://github.com/dust70/PHPDictionary.git"
git_repos["dotfiles/vim/bundle/PHPDoc"]="git://github.com/dust70/PHPDoc.git"
git_repos["dotfiles/vim/bundle/PHPGetterSetter"]="git://github.com/dust70/PHPGetterSetter.git"
git_repos["dotfiles/vim/bundle/RagTag"]="git://github.com/dust70/RagTag.git"
git_repos["dotfiles/vim/bundle/SecureModelines"]="git://github.com/dust70/SecureModelines.git"
git_repos["dotfiles/vim/bundle/ShowMarks"]="git://github.com/dust70/ShowMarks.git"
git_repos["dotfiles/vim/bundle/Smarty"]="git://github.com/dust70/Smarty.git"
git_repos["dotfiles/vim/bundle/Snipmate"]="git://github.com/dust70/Snipmate.git"
git_repos["dotfiles/vim/bundle/Startify"]="git://github.com/dust70/Startify.git"
git_repos["dotfiles/vim/bundle/Supertab"]="git://github.com/dust70/Supertab.git"
git_repos["dotfiles/vim/bundle/Surround"]="git://github.com/dust70/Surround.git"
git_repos["dotfiles/vim/bundle/Syntastic"]="git://github.com/dust70/Syntastic.git"
git_repos["dotfiles/vim/bundle/Tagbar"]="git://github.com/dust70/Tagbar.git"
git_repos["dotfiles/vim/bundle/TagbarPHPCTags"]="git://github.com/dust70/TagbarPHPCTags.git"
git_repos["dotfiles/vim/bundle/TaskList"]="git://github.com/dust70/TaskList.git"
git_repos["dotfiles/vim/bundle/Thesaurus"]="git://github.com/dust70/Thesaurus.git"
git_repos["dotfiles/vim/bundle/TLib"]="git://github.com/dust70/TLib.git"
git_repos["dotfiles/vim/bundle/TSkeleton"]="git://github.com/dust70/TSkeleton.git"
git_repos["dotfiles/vim/bundle/UnImpaired"]="git://github.com/dust70/UnImpaired.git"
git_repos["dotfiles/vim/bundle/YankRing"]="git://github.com/dust70/YankRing.git"

git_repos["bin"]="git:bin github github:dust70/bin"

git_repos["etc"]="git:etc"

git_repos["gitolite-admin"]="git:gitolite-admin"

git_repos["html/www.rene-six.de"]="git:html/www.rene-six.de"

git_repos["latex/invoice"]="git:latex/invoice"

git_repos["pass"]="git:pass"

git_repos["work/self/docs"]="git:work/self/docs"
git_repos["work/self/scripts"]="git:work/self/scripts"
git_repos["work/self/todo"]="git:work/self/todo"

git_repos["work/stauzebach/documents"]="git:work/stauzebach/documents"

git_repos["gentoo/catalyst"]="git:gentoo/catalyst"

git_repos["php/contao"]="git://github.com/contao/core.git"
git_repos["php/contao-check"]="git://github.com/contao/check.git"

git_repos["arch/aur"]="git://pkgbuild.com/aur-mirror.git"
#}}}

# {{{ subversion repositories
svn_repos["php/magento"]="http://svn.magentocommerce.com/source/branches/1.8"
#}}}
#}}}

# {{{ branches to use
branches["Documents"]="desktop"

branches["dotfiles"]="desktop himalia"
branches["dotfiles/config"]="desktop"
branches["dotfiles/local"]="desktop"
branches["dotfiles/ssh"]="desktop"

branches["dotfiles/vim/bundle/PythonMode"]="master"

branches["etc"]="amalthea desktop europa ganymed himalia io server"

branches["php/contao"]="develop lts"

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

        git clone -q -o origin "${local_remotes["origin"]}" "${tmpdir}" >> /dev/null || return 1
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

            git fetch -q "${key}" &> /dev/null || return 1
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
