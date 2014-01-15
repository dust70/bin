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
git_repos["dotfiles/git"]="git:dotfiles/git github github:dust70/git"
git_repos["dotfiles/gnupg"]="git:dotfiles/gnupg"
git_repos["dotfiles/local"]="git:dotfiles/local github github:dust70/local"
git_repos["dotfiles/mutt"]="git:dotfiles/mutt"
git_repos["dotfiles/pass"]="git:dotfiles/pass"
git_repos["dotfiles/shell"]="git:dotfiles/shell github github:dust70/shell"
git_repos["dotfiles/Skype"]="git:dotfiles/Skype"
git_repos["dotfiles/ssh"]="git:dotfiles/ssh"
git_repos["dotfiles/task"]="git:dotfiles/task"
git_repos["dotfiles/vim"]="git:dotfiles/vim github github:dust70/vim"
git_repos["dotfiles/zsh"]="git:dotfiles/zsh github github:dust70/zsh"

git_repos["dotfiles/bash/LiquidPrompt"]="git://github.com/nojhan/liquidprompt.git"
git_repos["dotfiles/git/GitIgnoreRepo"]="git://github.com/github/gitignore.git"

git_repos["dotfiles/vim/bundle/ActivityLog"]="git://github.com/AD7six/vim-activity-log.git"
git_repos["dotfiles/vim/bundle/Airline"]="git://github.com/bling/vim-airline.git"
git_repos["dotfiles/vim/bundle/Align"]="git://github.com/vim-scripts/Align.git"
git_repos["dotfiles/vim/bundle/AutoPairs"]="git://github.com/jiangmiao/auto-pairs.git"
git_repos["dotfiles/vim/bundle/BashSupport"]="git://github.com/vim-scripts/bash-support.vim.git"
git_repos["dotfiles/vim/bundle/CSS3Syntax"]="git://github.com/hail2u/vim-css3-syntax.git"
git_repos["dotfiles/vim/bundle/CSV"]="git://github.com/chrisbra/csv.vim.git"
git_repos["dotfiles/vim/bundle/CSupport"]="git://github.com/vim-scripts/c.vim.git"
git_repos["dotfiles/vim/bundle/Calendar"]="git://github.com/mattn/calendar-vim.git"
git_repos["dotfiles/vim/bundle/Changes"]="git://github.com/chrisbra/changesPlugin.git"
git_repos["dotfiles/vim/bundle/CloseTag"]="git://github.com/vim-scripts/closetag.vim.git"
git_repos["dotfiles/vim/bundle/ColorSchemes"]="git://github.com/flazz/vim-colorschemes"
git_repos["dotfiles/vim/bundle/ColorV"]="git://github.com/Rykka/colorv.vim.git"
git_repos["dotfiles/vim/bundle/Conque"]="git://github.com/Rykka/colorv.vim.git"
git_repos["dotfiles/vim/bundle/CtrlP"]="git://github.com/kien/ctrlp.vim.git"
git_repos["dotfiles/vim/bundle/CtrlPFunky"]="git://github.com/tacahiroy/ctrlp-funky.git"
git_repos["dotfiles/vim/bundle/CtrlPModified"]="git://github.com/jasoncodes/ctrlp-modified.vim.git"
git_repos["dotfiles/vim/bundle/CtrlPSSH"]="git://github.com/tacahiroy/ctrlp-ssh.git"
git_repos["dotfiles/vim/bundle/DBExt"]="git://github.com/vim-scripts/dbext.vim.git"
git_repos["dotfiles/vim/bundle/Detailed"]="git://github.com/vim-scripts/detailed.git"
git_repos["dotfiles/vim/bundle/EnhancedCommentify"]="git://github.com/vim-scripts/EnhCommentify.vim.git"
git_repos["dotfiles/vim/bundle/Eunuch"]="git://github.com/tpope/vim-eunuch.git"
git_repos["dotfiles/vim/bundle/FuGITive"]="git://github.com/tpope/vim-pathogen.git"
git_repos["dotfiles/vim/bundle/GitRebaseHelper"]="git://github.com/pix/git-rebase-helper.git"
git_repos["dotfiles/vim/bundle/GnuPG"]="git://github.com/jamessan/vim-gnupg.git"
git_repos["dotfiles/vim/bundle/GoogleVim"]="git://github.com/vim-scripts/google.vim.git"
git_repos["dotfiles/vim/bundle/HTML5"]="git://github.com/othree/html5.vim.git"
git_repos["dotfiles/vim/bundle/LaTeX"]="git://git.code.sf.net/p/vim-latex/vim-latex"
git_repos["dotfiles/vim/bundle/Neocomplcache"]="git://github.com/Shougo/neocomplcache.vim.git"
git_repos["dotfiles/vim/bundle/NerdTree"]="git://github.com/scrooloose/nerdtree.git"
git_repos["dotfiles/vim/bundle/Obsession"]="git://github.com/tpope/vim-obsession.git"
git_repos["dotfiles/vim/bundle/Outliner"]="git://github.com/vimoutliner/vimoutliner.git"
git_repos["dotfiles/vim/bundle/PHPAnnotationsSyntax"]="git://github.com/vim-scripts/php-annotations-syntax.git"
git_repos["dotfiles/vim/bundle/PHPComplete"]="git://github.com/shawncplus/phpcomplete.vim.git"
git_repos["dotfiles/vim/bundle/PHPDictionary"]="git://github.com/nishigori/vim-php-dictionary.git"
git_repos["dotfiles/vim/bundle/PHPDoc"]="git://github.com/tobyS/pdv.git"
git_repos["dotfiles/vim/bundle/Pager"]="git://github.com/rkitover/vimpager.git"
git_repos["dotfiles/vim/bundle/Pastie"]="git://github.com/tpope/vim-pastie.git"
git_repos["dotfiles/vim/bundle/PathOGen"]="git://github.com/tpope/vim-pathogen.git"
git_repos["dotfiles/vim/bundle/PerlSupport"]="git://github.com/vim-scripts/perl-support.vim.git"
git_repos["dotfiles/vim/bundle/RagTag"]="git://github.com/tpope/vim-ragtag.git"
git_repos["dotfiles/vim/bundle/SecureModelines"]="git://github.com/ciaranm/securemodelines.git"
git_repos["dotfiles/vim/bundle/ShowMarks"]="git://github.com/vim-scripts/ShowMarks.git"
git_repos["dotfiles/vim/bundle/Signify"]="git://github.com/mhinz/vim-signify.git"
git_repos["dotfiles/vim/bundle/Snipmate"]="git://github.com/msanders/snipmate.vim.git"
git_repos["dotfiles/vim/bundle/Startify"]="git://github.com/mhinz/vim-startify.git"
git_repos["dotfiles/vim/bundle/Supertab"]="git://github.com/ervandew/supertab.git"
git_repos["dotfiles/vim/bundle/Surround"]="git://github.com/tpope/vim-surround.git"
git_repos["dotfiles/vim/bundle/Syntastic"]="git://github.com/scrooloose/syntastic.git"
git_repos["dotfiles/vim/bundle/Tagbar"]="git://github.com/majutsushi/tagbar.git"
git_repos["dotfiles/vim/bundle/TagbarPHPCTags"]="git://github.com/vim-php/tagbar-phpctags.vim.git"
git_repos["dotfiles/vim/bundle/TaskWarrior"]="git://github.com/farseer90718/vim-taskwarrior.git"
git_repos["dotfiles/vim/bundle/UnImpaired"]="git://github.com/tpope/vim-unimpaired.git"
git_repos["dotfiles/vim/bundle/Unite"]="git://github.com/Shougo/unite.vim.git"
git_repos["dotfiles/vim/bundle/YankRing"]="git://github.com/vim-scripts/YankRing.vim.git"
git_repos["dotfiles/vim/PHPCTags"]="git://github.com/vim-php/phpctags.git"

git_repos["bin"]="git:bin github github:dust70/bin"

git_repos["etc"]="git:etc"

git_repos["gitolite-admin"]="git:gitolite-admin"

git_repos["html/www.rene-six.de"]="git:html/www.rene-six.de"

git_repos["latex/invoice"]="git:latex/invoice"

git_repos["work/docs"]="git:work/docs"
git_repos["work/scripts"]="git:work/scripts"

git_repos["stauzebach/documents"]="stauzebach.git:documents"

git_repos["distributions/catalyst"]="git:distributions/catalyst"

git_repos["php/contao"]="git://github.com/contao/core.git"
git_repos["php/contao-check"]="git://github.com/contao/check.git"
git_repos["php/zendframework"]="git://github.com/zendframework/zf2.git"

#git_repos["arch/aur"]="git://pkgbuild.com/aur-mirror.git"

git_repos["software/git"]="git://github.com/git/git"
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

branches["dotfiles/vim/bundle/PythonMode"]="master"

branches["etc"]="amalthea desktop europa ganymed himalia io server"

branches["php/contao"]="develop"

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
