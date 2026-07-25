{ stdenv, lib, fetchFromGitHub, nushell }:

stdenv.mkDerivation rec {
  pname = "alter";
  version = "0.0.2";

  src = ./.;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}}
    cp -r * $out/share/${pname}
    bin=$out/bin/${pname}
    cat > $bin <<EOF
      #!/bin/sh -e
      exec $out/share/${pname}/${pname} "\$@"
    EOF
    chmod +x $bin
  '';

  propagatedBuildInputs = [ nushell ];

  meta = with lib; {
    description = "A cli interface to Alter tracker.";
    homepage = "https://github.com/kaizen4dev/alter-cli";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
