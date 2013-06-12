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
git_repos["dotfiles/vim"]="git:dotfiles/vim github github:dust70/vim"
git_repos["dotfiles/zsh"]="git:dotfiles/zsh github github:dust70/zsh"

git_repos["dotfiles/git/GitIgnoreRepo"]="git://github.com/github/gitignore.git"

git_repos["dotfiles/vim/PHP-CTags"]="git://github.com/techlivezheng/phpctags.git"

git_repos["dotfiles/vim/bundle/Align"]="git://github.com/tsaleh/vim-align.git"
git_repos["dotfiles/vim/bundle/AutoClose"]="git://github.com/Townk/vim-autoclose.git"
git_repos["dotfiles/vim/bundle/AutoPairs"]="git://github.com/jiangmiao/auto-pairs.git"
git_repos["dotfiles/vim/bundle/Bash-Support"]="git://github.com/vim-scripts/bash-support.vim.git"
git_repos["dotfiles/vim/bundle/Calendar"]="git://github.com/mattn/calendar-vim.git"
git_repos["dotfiles/vim/bundle/ColorSchemes"]="git://github.com/flazz/vim-colorschemes.git"
git_repos["dotfiles/vim/bundle/Conque"]="git://github.com/vim-scripts/Conque-Shell.git"
git_repos["dotfiles/vim/bundle/CSV"]="git://github.com/chrisbra/csv.vim.git"
git_repos["dotfiles/vim/bundle/CtrlP"]="git://github.com/dust70/ctrlp.vim.git"
git_repos["dotfiles/vim/bundle/DBExt"]="git://github.com/vim-scripts/dbext.vim.git"
git_repos["dotfiles/vim/bundle/Detailed"]="git://github.com/rking/vim-detailed.git"
git_repos["dotfiles/vim/bundle/EnhancedCommentify"]="git://github.com/hrp/EnhancedCommentify.git"
git_repos["dotfiles/vim/bundle/Eunuch"]="git://github.com/tpope/vim-eunuch.git"
git_repos["dotfiles/vim/bundle/FuGITive"]="git://github.com/tpope/vim-fugitive.git"
git_repos["dotfiles/vim/bundle/GitRebaseHelper"]="git://github.com/pix/git-rebase-helper.git"
git_repos["dotfiles/vim/bundle/GitSupport"]="git://github.com/vim-scripts/Git-Support.git"
git_repos["dotfiles/vim/bundle/GitTimeLapse"]="http://www.tidraso.co.uk/repository/vim-plugin/"
git_repos["dotfiles/vim/bundle/GitV"]="git://github.com/gregsexton/gitv.git"
git_repos["dotfiles/vim/bundle/GnuPG"]="git://gitorious.org/vim-gnupg/vim-gnupg.git"
git_repos["dotfiles/vim/bundle/GoogleVim"]="git://github.com/vim-scripts/google.vim.git"
git_repos["dotfiles/vim/bundle/HTML5"]="git://github.com/othree/html5.vim.git"
git_repos["dotfiles/vim/bundle/LaTeX"]="git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex"
git_repos["dotfiles/vim/bundle/Neocomplcache"]="git://github.com/Shougo/neocomplcache.vim.git"
git_repos["dotfiles/vim/bundle/NerdTree"]="git://github.com/scrooloose/nerdtree.git"
git_repos["dotfiles/vim/bundle/Obsession"]="git://github.com/tpope/vim-obsession.git"
git_repos["dotfiles/vim/bundle/Outliner"]="git://github.com/vimoutliner/vimoutliner.git"
git_repos["dotfiles/vim/bundle/PathOGen"]="git://github.com/tpope/vim-pathogen.git"
git_repos["dotfiles/vim/bundle/PDV"]="git://github.com/vim-scripts/PDV--phpDocumentor-for-Vim.git"
git_repos["dotfiles/vim/bundle/PHP-Complete"]="git://github.com/shawncplus/phpcomplete.vim.git"
git_repos["dotfiles/vim/bundle/PHP-Dictionary"]="git://github.com/vim-scripts/PHP-dictionary.git"
git_repos["dotfiles/vim/bundle/PHPDoc"]="git://github.com/stephpy/vim-phpdoc.git"
git_repos["dotfiles/vim/bundle/Project"]="git://github.com/amiorin/vim-project.git"
git_repos["dotfiles/vim/bundle/PythonMode"]="git://github.com/klen/python-mode.git"
git_repos["dotfiles/vim/bundle/RagTag"]="git://github.com/tpope/vim-ragtag.git"
git_repos["dotfiles/vim/bundle/Screen"]="git://github.com/ervandew/screen.git"
git_repos["dotfiles/vim/bundle/SecureModelines"]="git://github.com/ciaranm/securemodelines.git"
git_repos["dotfiles/vim/bundle/ShowMarks"]="git://github.com/vim-scripts/ShowMarks.git"
git_repos["dotfiles/vim/bundle/SingleCompile"]="git://github.com/xuhdev/SingleCompile.git"
git_repos["dotfiles/vim/bundle/Smarty"]="git://github.com/vim-scripts/smarty-syntax.git"
git_repos["dotfiles/vim/bundle/Snipmate"]="git://github.com/msanders/snipmate.vim.git"
git_repos["dotfiles/vim/bundle/Startify"]="git://github.com/vim-scripts/vim-startify.git"
git_repos["dotfiles/vim/bundle/Supertab"]="git://github.com/ervandew/supertab.git"
git_repos["dotfiles/vim/bundle/Surround"]="git://github.com/tpope/vim-surround.git"
git_repos["dotfiles/vim/bundle/Syntastic"]="git://github.com/scrooloose/syntastic.git"
git_repos["dotfiles/vim/bundle/Tagbar"]="git://github.com/majutsushi/tagbar.git"
git_repos["dotfiles/vim/bundle/Tagbar-PHP-CTags"]="git://github.com/techlivezheng/tagbar-phpctags.git"
git_repos["dotfiles/vim/bundle/TBone"]="git://github.com/tpope/vim-tbone.git"
git_repos["dotfiles/vim/bundle/Templator"]="git://github.com/tomtom/templator_vim.git"
git_repos["dotfiles/vim/bundle/Thesaurus"]="git://github.com/beloglazov/vim-online-thesaurus.git"
git_repos["dotfiles/vim/bundle/TimeKeeper"]="git://github.com/PAntoine/TimeKeeper.git"
git_repos["dotfiles/vim/bundle/TLib"]="git://github.com/tomtom/tlib_vim.git"
git_repos["dotfiles/vim/bundle/TSkeleton"]="git://github.com/tomtom/tskeleton_vim.git"
git_repos["dotfiles/vim/bundle/UnImpaired"]="git://github.com/tpope/vim-unimpaired.git"
git_repos["dotfiles/vim/bundle/VCSCommand"]="git://repo.or.cz/vcscommand.git"
git_repos["dotfiles/vim/bundle/VimPager"]="git://github.com/rkitover/vimpager.git"
git_repos["dotfiles/vim/bundle/VimPanel"]="git://github.com/mihaifm/vimpanel.git"
git_repos["dotfiles/vim/bundle/YankRing"]="git://github.com/vim-scripts/YankRing.vim.git"

git_repos["bin"]="git:bin github github:dust70/bin"

git_repos["etc"]="git:etc"

git_repos["gitolite-admin"]="git:gitolite-admin"

git_repos["html/www.rene-six.de"]="git:html/www.rene-six.de"

git_repos["latex/application"]="git:latex/application"
git_repos["latex/invoice"]="git:latex/invoice"

git_repos["pass"]="git:pass"

git_repos["work/self/docs"]="git:work/self/docs"
git_repos["work/self/scripts"]="git:work/self/scripts"
git_repos["work/self/todo"]="git:work/self/todo"

git_repos["work/stauzebach/autowaschpark-marburg.de"]="git:work/stauzebach/autowaschpark-marburg.de"
git_repos["work/stauzebach/documents"]="git:work/stauzebach/documents"
git_repos["work/stauzebach/rechnungssystem"]="git:work/stauzebach/rechnungssystem"
git_repos["work/stauzebach/truckwash-remsfeld.de"]="git:work/stauzebach/truckwash-remsfeld.de"

git_repos["ajax/css-pie"]="git://github.com/lojjic/PIE.git"
git_repos["ajax/jquery"]="git://github.com/jquery/jquery.git"
git_repos["ajax/mootools-core"]="git://github.com/mootools/mootools-core.git"
git_repos["ajax/mootools-more"]="git://github.com/mootools/mootools-more.git"
git_repos["ajax/node.js"]="git://github.com/joyent/node.git"

git_repos["grml/grml-etc-core"]="git://git.grml.org/grml-etc-core.git"
git_repos["grml/grml-gen-zshrefcard"]="git://git.grml.org/grml-gen-zshrefcard.git"
git_repos["grml/grml-git-doc"]="git://git.grml.org/grml-git-doc.git"
git_repos["grml/grml-kernel"]="git://git.grml.org/grml-kernel.git"
git_repos["grml/grml-vpn"]="git://git.grml.org/grml-vpn.git"
git_repos["grml/grml2usb"]="git://github.com/grml/grml2usb.git"
git_repos["grml/zsh-lovers"]="git://git.grml.org/zsh-lovers.git"

# die beiden hier sind zu gross, die werden nur auf bestimmten hosts geladen und
# manuell uptodate gehalten
#git_repos["linux/linux-stable"]="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
#git_repos["linux/linux-torvalds"]="git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git"

git_repos["php/contao"]="git://github.com/contao/core.git"
git_repos["php/contao-check"]="git://github.com/contao/check.git"
git_repos["php/contao-docs"]="git://github.com/contao/docs.git"

git_repos["php/shopware"]="git://github.com/ShopwareAG/shopware-4.git"

git_repos["php/tcpdf"]="git://git.code.sf.net/p/tcpdf/code"

git_repos["php/zend_framework"]="git://github.com/zendframework/zf2.git"
git_repos["php/zend_framework-docs"]="git://github.com/zendframework/zf2-documentation.git"

git_repos["software/git"]="git://git.kernel.org/pub/scm/git/git.git"
git_repos["software/sysadmin-utils"]="git://github.com/skx/sysadmin-util.git"
#}}}

# {{{ subversion repositories
svn_repos["php/magento"]="http://svn.magentocommerce.com/source/branches/1.7"
svn_repos["php/wordpress"]="http://core.svn.wordpress.org"
#}}}
#}}}

# {{{ branches to use
branches["Documents"]="desktop"

branches["dotfiles"]="desktop himalia pasiphae"
branches["dotfiles/config"]="desktop"
branches["dotfiles/local"]="desktop"
branches["dotfiles/ssh"]="desktop"

branches["dotfiles/vim/bundle/PythonMode"]="master"

branches["etc"]="amalthea desktop ganymed himalia pasiphae server"

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

# function copy_run
function copy_run() {
    [[ -d "${repo_path}/src" ]] || mkdir -p "${repo_path}/src"
    for i in /usr/src/*
    do
        [[ -d "${i}" ]]                                 || continue
        [[ -d "${repo_path}/src/${i//\/usr\/src\//}" ]] && continue
        cp -rs "${i}" "${repo_path}/src/${i//\/usr\/src\//}"
    done
}

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

copy_run

#echo "# CVS repositories:" ${#cvs_repos[@]}
echo "# GIT reposituries:" ${#git_repos[@]}
echo "# SVN repositories:" ${#svn_repos[@]}
unset branches cvs_repos git_repos svn_repos

cd ${oldpwd} >> /dev/null
cd ${pwd} >> /dev/null

# vim: foldmethod=marker textwidth=80 filetype=sh
