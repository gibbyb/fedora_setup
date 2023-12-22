# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
# Powerline configuration
if [ -f /usr/bin/powerline-daemon ]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    source /usr/share/powerline/bash/powerline.sh
fi

# Emacs path
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="/home/gib/.cargo/bin:$PATH"
# Aliases & Exports
alias emacs="emacsclient -c -a 'emacs'"
alias update="sudo dnf update -y --refresh && flatpak update -y"
alias install="sudo dnf install -y"
alias letscode="cd ~/Documents/Code && nvim "
alias letscode.="cd ~/Documents/Code && nvim ."
alias gtext="gnome-text-editor"
alias :q="exit"

export SUDO_EDITOR=nvim

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
