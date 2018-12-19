#!/bin/bash
#
#Uninstall: beta

ODOCKER_CONTAINER_NAME="odocker"
IMAGE_NAME="jorgeosoco/odocker"
ODOCKER_DIR="$HOME/.odocker"

odocker_bash_profile="${HOME}/.bash_profile"
odocker_profile="${HOME}/.profile"
odocker_bashrc="${HOME}/.bashrc"
odocker_zshrc="${HOME}/.zshrc"

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

echo 'Attempting uninstall odocker ...'

# Sanity checks
if [ -z $(which sed) ]; then
	echo "sed not found."
	echo ""
	echo "======================================================================================================"
	echo " Please install sed on your system using your favourite package manager."
	echo ""
	echo " Restart after installing sed."
	echo "======================================================================================================"
	echo ""
	exit 0
fi

echo '  removing .odocker folder in your home ...'
rm -Rf "$ODOCKER_DIR"

echo '  removing alias from bash startup ...'
if [[ $darwin == true ]] || [[ $freebsd == true ]] ; then
    sed -i '' '/odocker/d' "$odocker_profile" 2> /dev/null
    sed -i '' '/odocker/d' "$odocker_bashrc" 2> /dev/null
    sed -i '' '/odocker/d' "$odocker_zshrc" 2> /dev/null
else
    sed -i '/odocker/d' "$odocker_profile" 2> /dev/null
    sed -i '/odocker/d' "$odocker_bashrc" 2> /dev/null
    sed -i '/odocker/d' "$odocker_zshrc" 2> /dev/null
fi

echo '  removing container and image ...'
docker rm -f $ODOCKER_CONTAINER_NAME 2> /dev/null
docker rmi -f $IMAGE_NAME 2> /dev/null

echo 'Finished! odocker removed from your machine.'
