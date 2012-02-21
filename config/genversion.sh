#!/bin/sh
# Copyright (C) 2011,2012 Olaf Lenz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Shell script to find out the version of ESPResSo 
#
# -d: out dist version (without ...-git)
# -r: output raw (no newline)
# -c: output c constant definition
# -l: output LaTeX \newcommand

for opt in $@; do
    case $opt in
	(-r*) OUT_RAW=1 ;;&
	(-c*) OUT_C=1 ;;&
	(-t*) OUT_TEX=1 ;;&
	(-*d) DIST=1 ;;&
    esac;
done

VERSIONFILE=version.txt

# try to use git describe --dirty
if VERSION=`git describe --dirty --match=?\.?\.? 2> /dev/null`; then
    test ! "$DIST" && VERSION=$VERSION-git

# try to use git without --dirty
elif VERSION=`git describe --match=?\.?\.? 2> /dev/null`-maybedirty; then
    test ! "$DIST" && VERSION=$VERSION-git

# otherwise use the versionfile
elif test -f "$VERSIONFILE"; then
    VERSION=`cat $VERSIONFILE`

# otherwise the version is unknown
else
    echo -n "unknown"
    echo "ERROR: Can't find $VERSIONFILE!" > /dev/stderr
    exit 1
fi

# OUTPUT
if test "$OUT_RAW"; then
    # Raw output
    echo $VERSION | tr -d '\n'
elif test "$OUT_C"; then
    # Output to C-file
    echo "const char* ESPRESSO_VERSION=\"$VERSION\";"
elif test "$OUT_TEX"; then
    # Output TeX command def
    echo "\def\esversion{$VERSION}"
else
    echo $VERSION
fi