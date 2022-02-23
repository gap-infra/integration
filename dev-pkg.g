# Functions to test package
#

# Getting package name from its PackageInfo.g file
#
# Borrowed from `ValidatePackageInfo` in GAP's lib/package.gi
GetNameFromPackageInfo := function(info)
local record, pkgdir, i;

if IsString( info ) then
  if IsReadableFile( info ) then
	Unbind( GAPInfo.PackageInfoCurrent );
	Read( info );
	if IsBound( GAPInfo.PackageInfoCurrent ) then
	  record:= GAPInfo.PackageInfoCurrent;
	  Unbind( GAPInfo.PackageInfoCurrent );
	else
	  Error( "the file <info> is not a `PackageInfo.g' file" );
	fi;
	pkgdir:= "./";
	for i in Reversed( [ 1 .. Length( info ) ] ) do
	  if info[i] = '/' then
		pkgdir:= info{ [ 1 .. i ] };
		break;
	  fi;
	od;
  else
	Error( "<info> is not the name of a readable file" );
  fi;
elif IsRecord( info ) then
  pkgdir:= fail;
  record:= info;
else
  Error( "<info> must be either a record or a filename" );
fi;

return record.PackageName;

end;

# Running standard test for the package
#
TestOnePackage := function(pkgname)
local testfile, str;
if not IsBound( GAPInfo.PackagesInfo.(pkgname) ) then
    Print("#I  No package with the name ", pkgname, " is available\n");
    return fail;
elif LoadPackage( pkgname ) = fail then
    Print( "#I ", pkgname, " package can not be loaded\n" );
    return fail;
elif not IsBound( GAPInfo.PackagesInfo.(pkgname)[1].TestFile ) then
    Print("#I No standard tests specified in ", pkgname, " package, version ",
          GAPInfo.PackagesInfo.(pkgname)[1].Version,  "\n");
    return fail;
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
        # here an all is fine.
        return "UNKNOWN";
    fi;
fi;
end;


PreparePackageInDir := function(path)
    local pkg, pkginfo;
    pkg := LowercaseString(GetNameFromPackageInfo("PackageInfo.g"));
    if IsPackageMarkedForLoading(pkg, "") then
        # verify the right version of the package was loaded
        pkginfo := GAPInfo.PackagesInfo.(pkg);
        if Length(pkginfo) > 1 then
            Print("#I  Found ", Length(pkginfo), " copies of package ", pkg, "\n");
        fi;
        if pkginfo[1].InstallationPath <> path then
            Error("Package ", pkg, " already loaded from bad path '",
                   pkginfo[1].InstallationPath, "' instead of the expected path '",
                   path, "'");
        fi;
    else
        # ensure the right version of the package gets loaded later on
        SetPackagePath(pkg, path);
    fi;
    return pkg;
end;
