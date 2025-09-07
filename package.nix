{
  lib,
  pkg-config,
  buildGoModule,
  rev ? "dirty",
}:

buildGoModule {
  pname = "deej";
  version = rev;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ./.)) (
      lib.fileset.unions [
        ./pkg
        ./config.yaml
        ./go.mod
        ./go.sum
      ]
    );
  };

  nativeBuildInputs = [
    pkg-config
  ];

  vendorHash = "sha256-wG35pcXLkzGyD7U6k3A68wYr4WN0bhTMr7wjsVNbzxo=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/deej
    cp $src/config.yaml $out/bin/config.yaml
  '';

  meta = {
    description = "Set app volumes with real sliders! deej is an Arduino & Go project to let you build your own hardware mixer for Windows and Linux";
    homepage = "https://github.com/yanek/deej-linux";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yanek ];
    mainProgram = "deej";
  };
}
