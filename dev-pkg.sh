#!/usr/bin/env bash

# Build a dev version of a package

set -e

TERM=${TERM:-xterm}

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
