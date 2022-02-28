#!/usr/bin/env bash

# Build a dev version of a package

set -e

TERM=${TERM:-xterm}

SRCDIR=$PWD

echo SRCDIR   : $SRCDIR
echo PKG_NAME : $PKG_NAME
echo REPO_URL : $REPO_URL

# set up a custom GAP root containing only this package, so that
# we can force GAP to load the correct version of this package
mkdir -p gaproot/pkg/
cd gaproot/pkg/

git clone ${REPO_URL} ${PKG_NAME}

cd ${PKG_NAME}

# show head commit for debugging
git log -n 1

###############################################################################
#

# for Semigroups package
if [[ -f prerequisites.sh ]]
then
  ./prerequisites.sh
fi

# build the package
cd ..
${GAP_HOME}/bin/BuildPackages.sh --with-gaproot=${GAP_HOME} --strict ${PKG_NAME}

# TODO: Skip trying to test packages without tests
# TODO: Validate PackageInfo.g? (see dev-pkg.g?)
# TODO: These tests should ideally take place within separate CI steps

GAP="${GAP_HOME}/bin/gap.sh -l ${SRCDIR}/gaproot; --quitonbreak -r"

# Test with default packages
$GAP /home/workspace/pkg-tests.g

# Test with minimal packages
$GAP -A /home/workspace/pkg-tests.g
