#!/bin/sh

cd ${GAP_HOME}

make testpackagesload

NUMPKGLOADSTART=$(cat dev/log/testpackagesload* | grep -c "%%% Loading")
NUMPKGLOADDONE=$(cat dev/log/testpackagesload* | grep -c "### Loaded")
NUMPKGLOADFAIL=$(cat dev/log/testpackagesload* | grep -c "### Not loaded")
PKGSGONE=$(($NUMPKGLOADSTART-$NUMPKGLOADDONE-$NUMPKGLOADFAIL))
echo "%%% Packages attempted to start: $NUMPKGLOADSTART"
echo "%%% Packages loaded: $NUMPKGLOADDONE"
echo "%%% Packages not loaded: $NUMPKGLOADFAIL"
echo "%%% Packages crashing while loading: $PKGSGONE"
#
grep -h "### Not loaded" dev/log/testpackagesload* | sort
#
echo "==========Packages with warnings ================================"
grep -h "Do not" dev/log/testpackagesload* | sort
echo "Total number of warnings during package loading :"
grep -h "Do not" dev/log/testpackagesload* | wc -l
#
echo "==========LoadAllPackages tests ================================="
grep -h "### all packages loaded" dev/log/testpackagesload* | sort
echo "Number of successful LoadAllPackages tests :"
grep -h "### all packages loaded" dev/log/testpackagesload* | wc -l

NUMALLPKGLOAD=$(cat dev/log/testpackagesload* | grep -c "### all packages loaded")
if [ $NUMALLPKGLOAD = '4' ]
then
  echo "LoadAllPackages: all tests passed successfully!!!"
else
  echo "LoadAllPackages test failed: $NUMALLPKGLOAD configurations successful out of 4"
  echo "Additionally, $PKGSGONE packages crashed during loading"
  exit 1
fi
#
if [ $PKGSGONE = '0' ]
then
  echo "Loading individual packages: all tests completed!!!"
else
  echo "Loading individual packages failed: $PKGSGONE packages crashed during loading"
  exit 1
fi
