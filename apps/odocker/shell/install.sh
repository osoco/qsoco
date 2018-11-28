#!/bin/bash
#
#Install: beta

# Global variables
ODOCKER_VERSION="0.1"
ODOCKER_PLATFORM=$(uname)

if [ -z "$ODOCKER_DIR" ]; then
    ODOCKER_DIR="$HOME/.odocker"
fi

# Local variables
odocker_bin="${ODOCKER_DIR}/bin"
odocker_bin_destination="${odocker_bin}/odocker.sh"
odocker_bin_source="https://osoco.github.io/odocker.sh"
odocker_bash_profile="${HOME}/.bash_profile"
odocker_profile="${HOME}/.profile"
odocker_bashrc="${HOME}/.bashrc"
odocker_zshrc="${HOME}/.zshrc"

odocker_init_snippet=$( cat << EOF
# Created odocker alias
alias odocker="${odocker_bin_destination}"
EOF
)

# OS specific support (must be 'true' or 'false').
cygwin=false;
darwin=false;
solaris=false;
freebsd=false;
case "$(uname)" in
    CYGWIN*)
        cygwin=true
        ;;
    Darwin*)
        darwin=true
        ;;
    SunOS*)
        solaris=true
        ;;
    FreeBSD*)
        freebsd=true
esac


echo ''
echo '                                   Attempting odocker installation...'
echo ''

# Sanity checks

echo "Looking for curl..."
if [ -z $(which curl) ]; then
	echo "Not found."
	echo ""
	echo "======================================================================================================"
	echo " Please install curl on your system using your favourite package manager."
	echo ""
	echo " Restart after installing curl."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

# Create directory structure
mkdir -p "$odocker_bin"

echo "Download odocker bash..."
curl --location --progress-bar "${odocker_bin_source}" > "$odocker_bin_destination"

if [[ $darwin == true ]]; then
  if [[ -z $(grep 'odocker.sh' "$odocker_bash_profile") ]]; then
    touch "$odocker_bash_profile"
    echo "Attempt update of login bash profile on OSX..."
    echo -e "\n$odocker_init_snippet" >> "$odocker_bash_profile"
    echo "Added odocker init snippet to $odocker_bash_profile"
  fi
else
  if [[ -z $(grep 'odocker.sh' "$odocker_bashrc") ]]; then
      echo "Attempt update of interactive bash profile on regular UNIX..."
      touch "${odocker_bashrc}"
      echo -e "\n$odocker_init_snippet" >> "$odocker_bashrc"
      echo "Added odocker init snippet to $odocker_bashrc"
  fi
fi

if [[ -z $(grep 'odocker.sh' "$odocker_zshrc") ]]; then
    echo "Attempt update of zsh profile..."
    touch "$odocker_zshrc"
    echo -e "\n$odocker_init_snippet" >> "$odocker_zshrc"
    echo "Updated existing ${odocker_zshrc}"
fi

echo -e "\n\nAll done, odocker version ${ODOCKER_VERSION} installed!\n"
echo "Get info with:"
echo ""
echo "    odocker help"
echo ""
echo "Enjoy!!!"
