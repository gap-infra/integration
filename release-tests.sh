#!/bin/sh

cd ${GAP_HOME}

make testpackagesload

NUMPKGLOADSTART=`cat dev/log/testpackagesload* | grep -c "%%% Loading"`
NUMPKGLOADDONE=`cat dev/log/testpackagesload* | grep -c "### Loaded"`
NUMPKGLOADFAIL=`cat dev/log/testpackagesload* | grep -c "### Not loaded"`
export PKGSGONE=$(($NUMPKGLOADSTART-$NUMPKGLOADDONE-$NUMPKGLOADFAIL))
/bin/echo %%% Packages attempted to start: $NUMPKGLOADSTART
/bin/echo %%% Packages loaded: $NUMPKGLOADDONE
/bin/echo %%% Packages not loaded: $NUMPKGLOADFAIL
/bin/echo %%% Packages crashing while loading: $PKGSGONE
#
grep -h "### Not loaded" dev/log/testpackagesload* | sort
#
/bin/echo '==========Packages with warnings ================================'
grep -h "Do not" dev/log/testpackagesload* | sort
/bin/echo 'Total number of warnings during package loading :'
grep -h "Do not" dev/log/testpackagesload* | wc -l
#
/bin/echo '==========LoadAllPackages tests ================================='
grep -h "### all packages loaded" dev/log/testpackagesload* | sort
/bin/echo 'Number of successful LoadAllPackages tests :'
grep -h "### all packages loaded" dev/log/testpackagesload* | wc -l
export NUMALLPKGLOAD=`cat dev/log/testpackagesload* | grep -c "### all packages loaded"`
if [ $NUMALLPKGLOAD = '4' ]
then
/bin/echo 'LoadAllPackages: all tests passed successfully!!!'
else
/bin/echo  LoadAllPackages test failed: $NUMALLPKGLOAD configurations successful out of 4
/bin/echo  Additionally, $PKGSGONE packages crashed during loading
exit 1
fi
#
if [ $PKGSGONE = '0' ]
then
/bin/echo 'Loading individual packages: all tests completed!!!'
else
/bin/echo  Loading individual packages failed: $PKGSGONE packages crashed during loading
exit 1
fi
