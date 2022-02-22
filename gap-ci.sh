#!/usr/bin/env bash

# running GAP tests suite

set -ex

SRCDIR=${SRCDIR:-$PWD}
TERM=${TERM:-dumb}

# --quitonbreak makes sure any Error() immediately exits GAP with exit code 1.
GAP="bin/gap.sh --quitonbreak -q -A -x 80 -r -m 100m -o 1g -K 2g"
GAPAuto="bin/gap.sh --quitonbreak -q -x 80 -r -m 100m -o 1g -K 2g"

echo SRCDIR    : $SRCDIR
echo TEST_SUITE: $TEST_SUITE
echo GAPPKG    : $GAPPKG
echo CONTAINER : $CONTAINER

cd /home/gap/inst/gap-${CONTAINER}/

case $TEST_SUITE in

testpackagesload)

    case ${GAPPKG} in
    single|singleonlyneeded)

        cd pkg
        # skip PolymakeInterface: no polymake installed (TODO: is there a polymake package we can use)
        rm -rf PolymakeInterface*
        # skip xgap: no X11 headers, and no means to test it
        rm -rf xgap*
        # also skip itc because it requires xgap
        rm -rf itc*
        cd ..

        # loading each package in an individual GAP session, with all needed
        # and suggested packages, or only with needed packages

        if [[ "$GAPPKG" = singleonlyneeded ]]
        then
            GAPOPTION=":OnlyNeeded"
        else
            GAPOPTION=""
        fi

        # Load GAP (without packages) and save workspace to speed up test
        # save names of all packages into a file to be able to iterate over them
        $GAP -b <<GAPInput
        SaveWorkspace("testpackagesload.wsp");
        PrintTo("packagenames", JoinStringsWithSeparator( SortedList(RecNames( GAPInfo.PackagesInfo )),"\n") );
        QUIT_GAP(0);
GAPInput
        for pkg in $(cat packagenames)
        do
            $GAP -b -L testpackagesload.wsp <<GAPInput
            Print("*** Loading $pkg ... \n");
            if LoadPackage("$pkg",false $GAPOPTION) = true then
              Print("OK\n");
            else
              Print("failed \n");
              AppendTo("fail.log", "Loading failed : ", "$pkg", "\n");
            fi;
GAPInput

        done

        if [[ -f fail.log ]]
        then
            echo "Some packages failed to load:"
            cat fail.log
            exit 1
        fi
        ;;

    all|allreversed)

        cd pkg
        # skip PolymakeInterface: no polymake installed (TODO: is there a polymake package we can use)
        rm -rf PolymakeInterface*
        # skip xgap: no X11 headers, and no means to test it
        rm -rf xgap*
        # also skip itc because it requires xgap
        rm -rf itc*
        cd ..

        # Test of `LoadAllPackages()` and `LoadAllPackages(:reversed)`

        if [[ "$GAPPKG" = allreversed ]]
        then
            GAPOPTION=":reversed"
        else
            GAPOPTION=""
        fi

        $GAP <<GAPInput
            SetInfoLevel(InfoPackageLoading,4);
            LoadAllPackages($GAPOPTION);
            SetInfoLevel(InfoPackageLoading,0);
            unloads:= Filtered( SortedList(RecNames( GAPInfo.PackagesInfo ) ), s -> LoadPackage(s) = fail );;
            if Length(unloads)=0 then
              Print("*** Packages loading tests completed!\n");
              QUIT_GAP(0);
            else
              Print("*** Packages loading tests failed because of:\n", unloads, "\n");
              QUIT_GAP(1);
            fi;
GAPInput
        ;;
    esac
    ;;

*)

    case ${GAPPKG} in
    no)
    $GAP <<GAPInput
        TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
        FORCE_QUIT_GAP(1);
GAPInput
    ;;
    auto)
    $GAPAuto <<GAPInput
        TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
        FORCE_QUIT_GAP(1);
GAPInput
    ;;
    all)
    $GAP <<GAPInput
        LoadAllPackages();
        TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
        FORCE_QUIT_GAP(1);
GAPInput
    ;;    
    esac;

esac;
