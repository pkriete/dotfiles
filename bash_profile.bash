## LS Colors
export CLICOLOR=1
export LSCOLORS=cxfxcxdxbxegedabagacad


DEV_PATH="${HOME}/dev"

CYAN="\[\033[0;36m\]"
YELLOW="\[\033[0;33m\]"
WHITE="\[\033[0;37m\]"
RESET="\[\033[0;37;00m\]"


## Login Message
echo -e "Kernel\t : "`uname -smr`;
echo -ne "Uptime\t : "; uptime | awk /'up/ {print $3, $4, $6 " users"}';
echo -e "Now\t : "`date "+%Y-%m-%d | %H:%M:%S"`
echo -e
echo -e "Logged into MBPr as \033[0;36m$USER\033[0;37;00m."
echo -e


## Completions
source "${DEV_PATH}/ruby/dobby/etc/dobby-prompt.sh"
source `brew --prefix`/etc/bash_completion.d/git-prompt.sh
source `brew --prefix`/etc/bash_completion.d/git-completion.bash
source `brew --prefix`/Library/Contributions/brew_bash_completion.sh


## Exports
export PS1="# ${WHITE}[\$(running)]${RESET} \u${CYAN}\$(__git_ps1 \" (%s)\")${WHITE} \w${RESET} $\n"
export EDITOR='subl -w'
export PATH="/usr/local/bin:/usr/local/share/python:$PATH"
export HISTCONTROL=ignoreboth # ignorespace, ignoredups

## Aliases
alias b='brew'
alias g='git'
alias s='subl'


# Fix alias autocompletes
complete -o default -F _brew b
complete -o default -o nospace -F _git g


# Disable case sensitive autocomplete, fix bell behavior, and slash symlink dirs
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set mark-directories on'
bind 'set mark-symlinked-directories on'


## Functions

# dev path helper (autocompleted below)
_()
{
	cd ${DEV_PATH}/$1
}

mcd()
{
	test -e $1 || mkdir -p $1; cd $1;
}

# trace <pid> <filename>
trace()
{
	dtruss -t stat -p $1 > $2 2>&1
}

finder()
{
	[ "$#" -eq 1 ] && open -a Finder $1 || open -a Finder ./
}

safari()
{
	if [ -t 0 ]; then
		open -a Safari $1
	else
		open -a Safari $(cat)
	fi
}

# Sniff incoming traffic
sniff()
{
	local device="en0"
	local port=80

	case "$#" in
		1) device="$1";;
		2) device="$1"
		   port="$2";;
		*) ;;
	esac

	sudo ngrep -d ${device} -t '^(GET|POST) ' "tcp and port ${port}"
}

# Create a data URL from a file
dataurl() {
	local mimeType=`file -b --mime-type "$1"`

	if [[ $mimeType == text/* ]];
	then
		mimeType="${mimeType};charset=utf-8"
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Gitweb
# Takes a commit hash and returns the proper commit url
gw()
{
	local url

	url=`git remote -v | pick 1 2`
	url=`echo $url | sed -e "s|^git@|https://|"`
	url=`echo $url | sed -e "s|.git$||"`

	# Github does /commit, beanstalk has /changeset
	url=`echo $url | sed -e "s|\(github.com\):\(.*\)|\\1/\\2/commit|"`
	url=`echo $url | sed -e "s|\(.*beanstalk.com\):\(.*\)|\\1/\\2/changeset|"`

	if [ -t 0 ]; then
		echo "${url}/$1"
	else
		echo "${url}/$(cat)" # $(cat) instead of read so it can be used without input
	fi
}

# takes 2 parameters, line number and word number
# returns that word for piped in data
# usecases:
# open 2nd commit today in safari: g ltd | pick 2 1 | gw | safari
pick()
{
	local i=0 data
	while read data
	do
		((i = i + 1))

		if [ "$i" -eq "$1" ];
		then
			echo $data | cut -d' ' -f $2
		fi

		[ "$i" -lt "$1" ] || break;
	done
}


## Utility

# Show what's running in the prompt
running()
{
	# Apache Mysql Mongo Memcache Varnish
	mysqladmin ping > /dev/null 2>&1
	mysql=$?

	pgrep httpd > /dev/null 2>&1
	apache=$?

	res=' '
	[ $apache -eq 0 ] && res="${res}A"
	[ $mysql -eq 0 ] && res="${res}M"

	[ "${res}" = ' ' ] && echo "${res}" || echo "${res}" | tr -d ' '
}

# Autocomplete for _
__()
{
	local cur="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=( $(compgen -G "${DEV_PATH}/${cur}*" | xargs ls -Fd | sed -e "s|${DEV_PATH}/||" | sed -e "s|@$|/|") )
}

complete -o nospace -o filenames -F __ _
