#!/bin/sh

set -e

SCRIPT=$(realpath $0)
SCRIPTPATH=$(dirname $SCRIPT)
CFG=$SCRIPTPATH/cfg
LOCAL=$SCRIPTPATH/local
ARCHITECTURES="x64 i686 win32"
#ARCHITECTURES="win32"

CONTAINERDIR=$(lxc-config lxc.lxcpath)
if [ -n "$CONTAINERDIR" ] || ! [ -d "$CONTAINERDIR" ]; then
	echo "lxc.lxcpath '$CONTAINERDIR' doesn't exist!"
	exit 1
fi

for arch in $ARCHITECTURES; do
	b=buildslave-$arch
	echo $b
	CONTAINERROOT=$CONTAINERDIR/$b/rootfs
	if ! [ -d "$CONTAINERROOT"]; then
		echo "rootfs '$CONTAINERROOT' doesn't exist!"
		exit 1
	fi
	rsync -av "$CFG"/ "$CONTAINERROOT/"
	rsync -av "$LOCAL"/ "$CONTAINERROOT"/

	case $arch in
		"x64")
		;;
		"i686")
			lxc-attach --name $b -- /install/install-linux.sh
			lxc-attach --name $b -- /install/make_static_libs.sh /home/buildbot/lib
			lxc-attach --name $b -- /install/setup-auth.sh
		break
		;;
		"win32")
			lxc-attach --name $b -- /install/install-win32.sh
			lxc-attach --name $b -- /install/install-mxe.sh /home/buildbot
			lxc-attach --name $b -- /install/setup-auth.sh
		break
		;;
		*)
			echo "Unknown arch: $arch"
			exit 1
		break
		;;
	esac
	
	lxc-attach --name $b -- apt clean
	lxc-attach --name $b -- rm -rf /home/buildbot/lib/tmp /home/buildbot/lib/download /install
	lxc-attach --name $b -- systemctl daemon-reload
	lxc-attach --name $b -- systemctl start autossh
	lxc-attach --name $b -- systemctl start buildslave
	lxc-attach --name $b -- chown -R buildbot:buildbot /home/buildbot
done

