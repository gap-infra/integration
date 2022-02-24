# modified version of GAP's TestPackage, working the same
# across multiple GAP branches
TestPackageModified := function(pkgname)
local testfile, str;
pkgname := LowercaseString(pkgname);
if not IsBound( GAPInfo.PackagesInfo.(pkgname) ) then
    Print("#I  No package with the name ", pkgname, " is available\n");
    return fail;
elif LoadPackage( pkgname ) = fail then
    Print( "#I ", pkgname, " package cannot be loaded\n" );
    return fail;
elif not IsBound( GAPInfo.PackagesInfo.(pkgname)[1].TestFile ) then
    Print("#I No standard tests specified in ", pkgname, " package, version ",
          GAPInfo.PackagesInfo.(pkgname)[1].Version,  "\n");
    # Since a TestFile is not required, technically we passed "all" tests
    return true;
else
    testfile := Filename( DirectoriesPackageLibrary( pkgname, "" ),
                          GAPInfo.PackagesInfo.(pkgname)[1].TestFile );
    str:= StringFile( testfile );
    if not IsString( str ) then
        Print( "#I Test file `", testfile, "' for package `", pkgname,
        " version ", GAPInfo.PackagesInfo.(pkgname)[1].Version, " is not readable\n" );
        return fail;
    fi;
    if EndsWith(testfile,".tst") then
        if Test( testfile, rec(compareFunction := "uptowhitespace") ) then
            Print( "#I  No errors detected while testing package ", pkgname,
                   " version ", GAPInfo.PackagesInfo.(pkgname)[1].Version,
                   "\n#I  using the test file `", testfile, "'\n");
            return true;
        else
            Print( "#I  Errors detected while testing package ", pkgname,
                   " version ", GAPInfo.PackagesInfo.(pkgname)[1].Version,
                   "\n#I  using the test file `", testfile, "'\n");
            return false;
        fi;
    elif not READ( testfile ) then
        Print( "#I Test file `", testfile, "' for package `", pkgname,
        " version ", GAPInfo.PackagesInfo.(pkgname)[1].Version, " is not readable\n" );
        return fail;
    else
        # At this point, the READ succeeded, but we have no idea what the
        # outcome of that test was. Hopefully, that file printed a message of
        # its own and then terminated GAP with a suitable error code (e.g. by
        # using TestDirectory with exitGAP:=true); in that case we never get
        # here and all is fine.
        return fail;
    fi;
fi;
end;


pkgname:=GAPInfo.SystemEnvironment.PKG_NAME;
SetInfoLevel(InfoPackageLoading, PACKAGE_WARNING);
res:=TestPackageModified(pkgname);
if res = true then
    FORCE_QUIT_GAP(0);
else
    FORCE_QUIT_GAP(1);
fi;
