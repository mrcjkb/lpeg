self: (final: prev: let 
  fetchurl = final.fetchurl;

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
  in {
  
  lua51Packages.lpeg = mkLPeg final.pkgs.lua5_1;

  luajitPackages.lpeg = mkLPeg final.pkgs.luajit;
})
