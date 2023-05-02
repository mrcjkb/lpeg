self: (final: prev: let 
  fetchurl = final.fetchurl;

  # FIXME: It looks like this ignores the src and uses the rockspec
  # to build the package - and the rockspec does not use make
  mkLPeg = lua: lua.pkgs.buildLuarocksPackage {
    pname = "lpeg";
    version = self.shortRev or "dirty";
    knownRockspec = (fetchurl {
      url    = "mirror://luarocks/lpeg-1.0.2-1.rockspec";
      sha256 = "08a8p5cwlwpjawk8sczb7bq2whdsng4mmhphahyklf1bkvl2li89";
    }).outPath;
    src = self;
    disabled = (lua.pkgs.luaOlder "5.1");
    propagatedBuildInputs = [ lua ];
    meta = {
      homepage = "http://www.inf.puc-rio.br/~roberto/lpeg.html";
      description = "Parsing Expression Grammars For Lua";
      maintainers = [ ];
      license.fullName = "MIT/X11";
    };
  };

  lua51Packages.lpeg = mkLPeg prev.pkgs.lua5_1;

  luajitPackages.lpeg = mkLPeg prev.pkgs.luajit;
  in {

  inherit 
    lua51Packages
    luajitPackages
    ;
})
