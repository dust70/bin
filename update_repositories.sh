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
git_repos["dotfiles/bash"]="git:dotfiles/bash"
git_repos["dotfiles/config"]="git:dotfiles/config"
git_repos["dotfiles/dotmail"]="git:dotfiles/dotmail"
git_repos["dotfiles/eclipse"]="git:dotfiles/eclipse"
git_repos["dotfiles/git"]="git:dotfiles/git"
git_repos["dotfiles/gnupg"]="git:dotfiles/gnupg"
git_repos["dotfiles/local"]="git:dotfiles/local"
git_repos["dotfiles/mutt"]="git:dotfiles/mutt"
git_repos["dotfiles/shell"]="git:dotfiles/shell"
git_repos["dotfiles/Skype"]="git:dotfiles/Skype"
git_repos["dotfiles/ssh"]="git:dotfiles/ssh"
git_repos["dotfiles/vim"]="git:dotfiles/vim"
git_repos["dotfiles/zsh"]="git:dotfiles/zsh"

git_repos["dotfiles/git/GitIgnoreRepo"]="git://github.com/github/gitignore.git"

git_repos["dotfiles/vim/bundle/Align"]="git://github.com/tsaleh/vim-align.git"
git_repos["dotfiles/vim/bundle/AutoClose"]="git://github.com/Townk/vim-autoclose.git"
git_repos["dotfiles/vim/bundle/Calendar"]="git://github.com/mattn/calendar-vim.git"
git_repos["dotfiles/vim/bundle/ColorSchemes"]="git://github.com/flazz/vim-colorschemes.git"
git_repos["dotfiles/vim/bundle/CSV"]="git://github.com/chrisbra/csv.vim.git"
git_repos["dotfiles/vim/bundle/DBExt"]="git://github.com/vim-scripts/dbext.vim.git"
git_repos["dotfiles/vim/bundle/EnhancedCommentify"]="git://github.com/hrp/EnhancedCommentify.git"
git_repos["dotfiles/vim/bundle/Eunuch"]="git://github.com/tpope/vim-eunuch.git"
git_repos["dotfiles/vim/bundle/FuGITive"]="git://github.com/tpope/vim-fugitive.git"
git_repos["dotfiles/vim/bundle/GitRebaseHelper"]="git://github.com/pix/git-rebase-helper.git"
git_repos["dotfiles/vim/bundle/GitV"]="git://github.com/gregsexton/gitv.git"
git_repos["dotfiles/vim/bundle/GnuPG"]="git://gitorious.org/vim-gnupg/vim-gnupg.git"
git_repos["dotfiles/vim/bundle/GoogleVim"]="git://github.com/vim-scripts/google.vim.git"
git_repos["dotfiles/vim/bundle/LaTeX"]="git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex"
git_repos["dotfiles/vim/bundle/NerdTree"]="git://github.com/scrooloose/nerdtree.git"
git_repos["dotfiles/vim/bundle/PathOGen"]="git://github.com/tpope/vim-pathogen.git"
git_repos["dotfiles/vim/bundle/PDV"]="git://github.com/vim-scripts/PDV--phpDocumentor-for-Vim.git"
git_repos["dotfiles/vim/bundle/PHP-Dictionary"]="git://github.com/vim-scripts/PHP-dictionary.git"
git_repos["dotfiles/vim/bundle/PythonMode"]="git://github.com/klen/python-mode.git"
git_repos["dotfiles/vim/bundle/RagTag"]="git://github.com/tpope/vim-ragtag.git"
git_repos["dotfiles/vim/bundle/SecureModelines"]="git://github.com/ciaranm/securemodelines.git"
git_repos["dotfiles/vim/bundle/Session"]="git://github.com/xolox/vim-session.git"
git_repos["dotfiles/vim/bundle/ShowMarks"]="git://github.com/vim-scripts/ShowMarks.git"
git_repos["dotfiles/vim/bundle/Snipmate"]="git://github.com/msanders/snipmate.vim.git"
git_repos["dotfiles/vim/bundle/Supertab"]="git://github.com/ervandew/supertab.git"
git_repos["dotfiles/vim/bundle/Surround"]="git://github.com/tpope/vim-surround.git"
git_repos["dotfiles/vim/bundle/Syntastic"]="git://github.com/scrooloose/syntastic.git"
git_repos["dotfiles/vim/bundle/Tagbar"]="git://github.com/majutsushi/tagbar.git"
git_repos["dotfiles/vim/bundle/UnImpaired"]="git://github.com/tpope/vim-unimpaired.git"
git_repos["dotfiles/vim/bundle/VCSCommand"]="git://repo.or.cz/vcscommand.git"
git_repos["dotfiles/vim/bundle/VimPager"]="git://github.com/rkitover/vimpager.git"
git_repos["dotfiles/vim/bundle/YankRing"]="git://github.com/vim-scripts/YankRing.vim.git"

git_repos["bin"]="git:bin"

git_repos["etc"]="git:etc"

git_repos["gitolite-admin"]="git:gitolite-admin"

git_repos["html/www.rene-six.de"]="git:html/www.rene-six.de"

git_repos["latex/application"]="git:latex/application"
git_repos["latex/invoice"]="git:latex/invoice"

git_repos["pass"]="git:pass"

git_repos["task"]="git:task"

git_repos["work/self/tectum.de"]="git:work/self/tectum.de"

git_repos["work/stauzebach/autowaschpark-marburg.de"]="git:work/stauzebach/autowaschpark-marburg.de"
git_repos["work/stauzebach/documents"]="git:work/stauzebach/documents"
git_repos["work/stauzebach/rechnungssystem"]="git:work/stauzebach/rechnungssystem"
git_repos["work/stauzebach/truckwash-remsfeld.de"]="git:work/stauzebach/truckwash-remsfeld.de"

git_repos["ajax/css-pie"]="git://github.com/lojjic/PIE.git"
git_repos["ajax/jquery"]="git://github.com/jquery/jquery.git"

git_repos["debian/kernel-handbook"]="git://anonscm.debian.org/kernel-handbook/kernel-handbook.git"

git_repos["grml/grml-etc-core"]="git://git.grml.org/grml-etc-core.git"
git_repos["grml/grml-gen-zshrefcard"]="git://git.grml.org/grml-gen-zshrefcard.git"
git_repos["grml/grml-git-doc"]="git://git.grml.org/grml-git-doc.git"
git_repos["grml/grml-kernel"]="git://git.grml.org/grml-kernel.git"
git_repos["grml/grml-vpn"]="git://git.grml.org/grml-vpn.git"
git_repos["grml/zsh-lovers"]="git://git.grml.org/zsh-lovers.git"

git_repos["linux/git"]="git://git.kernel.org/pub/scm/git/git.git"

git_repos["php/contao"]="git://github.com/contao/core.git"
git_repos["php/contao-docs"]="git://github.com/contao/docs.git"

git_repos["php/zend_framework"]="git://github.com/zendframework/zf2.git"
git_repos["php/zend_framework-docs"]="git://github.com/zendframework/zf2-documentation.git"
#}}}

# {{{ subversion repositories
svn_repos["debian/kernel"]="svn://svn.debian.org/kernel"

svn_repos["php/magento"]="http://svn.magentocommerce.com/source/branches/1.7"
svn_repos["php/wordpress"]="http://core.svn.wordpress.org"
#}}}
#}}}

# {{{ branches to use
branches["dotfiles"]="desktop himalia pasiphae"
branches["dotfiles/config"]="desktop"
branches["dotfiles/local"]="desktop"
branches["dotfiles/ssh"]="desktop"
branches["etc"]="amalthea desktop debian/desktop ganymed himalia io"
#}}}

# {{{ function git_run
function git_run() {
    if [ ${#@} -ne 3 ]; then
        echo "wrong number of parameter"
        return 1
    fi

    mkdir -p "$(dirname ${1})" >> /dev/null 2>&1 || (
        echo "Couldn't create parent directories for" ${1}
        return 1
    )

    function git-clean () {
        git reflog expire --all
        git fsck --unreachable --full
        git prune
        git gc --aggressive --quiet
        git repack -Adq
        git prune-packed --quiet
    }

    if [ ! -d "${1}"/.git ]; then
        local -r tmpdir=/tmp${1}

        [ -f "${1}" ] && rm "${1}" >> /dev/null
        if [ -d "${1}" ]; then
            rmdir "${1}" >> /dev/null || return 1
        fi

        mkdir -p "$(dirname ${tmpdir})"

        git clone -q -o origin "${2}" "${tmpdir}" >> /dev/null || return 1
        mv "${tmpdir}" "${1}" >> /dev/null

        cd "${1}" >> /dev/null

        local -a local_branches=("$(git name-rev --name-only origin/HEAD)" ${3})
        for branch in "${local_branches[@]}"; do
            git checkout -q "${branch}" >> /dev/null || return 1
            git checkout -q -f >> /dev/null || return 1
            git submodule -q init
        done

        git checkout -q "${local_branches[0]}" >> /dev/null || return 1
        git submodule -q foreach --recursive "git checkout -q \"${local_branches[0]}\"" >> /dev/null || return 1

        rmdir -p "$(dirname ${tmpdir})" >> /dev/null 2>&1 || true
    else
        cd "${1}" >> /dev/null
        local -a local_branches=("$(git name-rev --name-only origin/HEAD)" ${3})

        git remote update -p origin >> /dev/null || return 1

        git fetch -q origin >> /dev/null || return 1
        git fetch -q -t origin >> /dev/null || return 1

        for branch in ${local_branches[@]}; do
            git stash save -q >> /dev/null || true
            git checkout -q "${branch}" >> /dev/null || return 1
            git rebase -n -q origin/"${branch}" >> /dev/null || return 1
            git stash pop -q >> /dev/null || true
        done

        find "${1}" \( -iname '*.orig' -o -name '*.BASE.*' -o -name '*.LOCAL.*' -o -name '*.REMOTE.*' -o -name '*.BACKUP.*' \) -delete

        git checkout -q "${local_branches[0]}" >> /dev/null || return 1

        while ! $(git-clean >> /dev/null); do true; done
    fi
}
#}}}

# {{{ fcuntion svn_run
function svn_run() {
    if [ ${#@} -ne 3 ]; then
        echo "wrong number of parameter"
        return 1
    fi

    mkdir -p "$(dirname ${1})" >> /dev/null 2>&1 || (
        echo "Couldn't create parent directories for" ${1}
        return 1
    )

    local -a local_branches=("master" ${3})

    if [ ! -d "${1}"/.git ]; then
        local -r tmpdir=/tmp${1}

        [ -f "${1}" ] && rm "${1}" >> /dev/null
        if [ -d "${1}" ]; then
            rmdir "${1}" >> /dev/null || return 1
        fi

        mkdir -p "$(dirname ${tmpdir})"

        git svn clone -q "${2}" "${tmpdir}" >> /dev/null || return 1
        mv "${tmpdir}" "${1}" >> /dev/null

        cd "${1}" >> /dev/null

        for branch in "${local_branches[@]}"; do
            git checkout -q "${branch}" >> /dev/null || return 1
            git checkout -q -f >> /dev/null || return 1
        done

        rmdir -p "$(dirname ${tmpdir})" >> /dev/null 2>&1 || true
    else
        cd "${1}" >> /dev/null

        git remote update -p >> /dev/null || return 1

        git svn fetch -p -q >> /dev/null || return 1

        for branch in ${local_branches[@]}; do
            git stash save -q >> /dev/null || true
            git checkout -q "${branch}" >> /dev/null || return 1
            git svn rebase -n -q origin/"${branch}" >> /dev/null || return 1
            git stash pop -q >> /dev/null || true
        done

        find "${1}" \( -iname '*.orig' -o -name '*.BASE.*' -o -name '*.LOCAL.*' -o -name '*.REMOTE.*' -o -name '*.BACKUP.*' \) -delete

        git reflog expire --all
        git fsck --unreachable --full
        git prune
        git gc --aggressive --quiet
        git repack -Adq
        git prune-packed --quiet

        git checkout -q "${local_branches[0]}" >> /dev/null || return 1
    fi
}
#}}}

mkdir -p "${repo_path}" >> /dev/null 2>&1 || (
    echo "can't create directory" ${repo_path}
    return 1
)

for key in $(echo -e "${!git_repos[@]}" | tr " " "\n" | sort -u | tr "\n" " "); do
    declare repo=${repo_path}/${key}
    echo -n "${repo}"
    git_run "${repo}" "${git_repos[${key}]}" "${branches[${key}]}" || exit 1
    unset repo
    echo "... done"
done

for key in $(echo -e "${!svn_repos[@]}" | tr " " "\n" | sort -u | tr "\n" " "); do
    declare repo=${repo_path}/${key}
    echo -n "${repo}"
    svn_run "${repo}" "${svn_repos[${key}]}" "${branches[${key}]}" || exit 1
    unset repo
    echo "... done"
done

echo "# CVS repositories:" ${#cvs_repos[@]}
echo "# GIT reposituries:" ${#git_repos[@]}
echo "# SVN repositories:" ${#svn_repos[@]}
unset branches cvs_repos git_repos svn_repos

cd ${oldpwd} >> /dev/null
cd ${pwd} >> /dev/null

# vim: foldmethod=marker textwidth=80 filetype=sh
