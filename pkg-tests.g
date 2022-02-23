pkgname:=GAPInfo.SystemEnvironment.PKG_NAME;
SetInfoLevel(InfoPackageLoading, PACKAGE_WARNING);
res:=TestPackage(pkgname);
if res = true then
    FORCE_QUIT_GAP(0);
else
    FORCE_QUIT_GAP(1);
fi;
