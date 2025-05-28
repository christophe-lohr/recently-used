#!/bin/bash
#
# Play with the list of 'recent files' you used with some desktop applications
# and stored in your ~/.local/share/recently-used.xbel
# 
# e.g. type:  $ gio tree recent:///
#
# Here, we rearrange this xml file with xmlstarlet
#
#
# C.Lohr 2025  GPL v3+
#

RECENTFILES="$HOME/.local/share/recently-used.xbel"


function show_recents() {
  xmlstarlet sel -T -t -m "/xbel/bookmark" -s D:N:- "@*" -v "concat(@visited,' ',@href)" -n "$1"
}


function get_file() {
  xmlstarlet sel -t -m "/xbel/bookmark[@href='$2']" -v '@href' "$1"
}


function update_file() {
  echo "Update '$2'"
  xmlstarlet ed -L -u "/xbel/bookmark[@href='$2']/@visited" -v "$(date -u +%FT%T.000000Z)" "$1"
}


function delete_file() {
  echo "Delete '$2'"
  xmlstarlet ed -P -L -d "/xbel/bookmark[@href='$2']" "$1"
}


function add_file() {
  echo "Add '$2'"
  DATE="$(date -u +%FT%T.000000Z)"
  MIME="$(mimetype -b \"$2\" 2>/dev/null)"
  xmlstarlet ed -L -s '/xbel' -t elem -n 'bookmark' \
  	--var 'newbmk' '$prev' \
  	-s '$newbmk' -t attr -n 'href' -v "$2" \
	-s '$newbmk' -t attr -n 'added' -v "$DATE" \
	-s '$newbmk' -t attr -n 'modified' -v "$DATE" \
	-s '$newbmk' -t attr -n 'visited' -v "$DATE" \
	-s '$newbmk' -t elem -n 'info' \
	-s '$prev' -t elem -n 'metadata' \
	--var 'newmdt' '$prev' \
	-s '$newmdt' -t attr -n 'owner' -v 'http://freedesktop.org' \
	-s '$newmdt' -t elem -n 'mime:mime-type' \
	-s '$prev' -t attr -n 'type' -v  "${MIME:-application/octet-stream}" \
	-s '$newmdt' -t elem -n 'bookmark:applications' \
	-s '$prev' -t elem -n 'bookmark:application' \
	--var 'newapp' '$prev' \
	-s '$newapp' -t attr -n 'name' -v 'Dummy App' \
	-s '$newapp' -t attr -n 'exec' -v "'echo %u'" \
	-s '$newapp' -t attr -n 'modified' -v "$DATE" \
	-s '$newapp' -t attr -n 'count' -v '1' \
	"$1"
}



case "$1" in
  "-h")
  	echo "View or add file(s) in the list of Recently Used Files"
  	echo "Usage: $0 [-h] [file] ..."
  	exit -1
  	;;
  "")
  	show_recents "$RECENTFILES"
  	;;
  "-u")
  	shift
  	for FILE ; do
  		URI="file://`realpath -q \"$FILE\"`"
  		if [ "`get_file \"$RECENTFILES\" \"$URI\"`" ]; then
  		  update_file "$RECENTFILES" "$URI"
  		else
  		  add_file "$RECENTFILES" "$URI"
  		fi 
  	done
  	;;
  *)
  	for FILE ; do
  		URI="file://`realpath -q \"$FILE\"`"
  		delete_file "$RECENTFILES" "$URI"
  		add_file "$RECENTFILES" "$URI"
  	done
  	;;
esac

exit 0

# Misc
# xmlstarlet sel -t -v '//xbel/bookmark/@href' recently-used.xbel
# xmlstarlet el -a  recently-used.xbel
# xmlstarlet el -v  recently-used.xbel
# function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
