{
  description = "InfluxDB 2 server with local patch applied";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    overlay = final: prev: {
      influxdb2-server = prev.influxdb2-server.overrideAttrs (old: {
        patches = (old.patches or []) ++ [ ./patch.diff ];
        meta = (old.meta or {}) // { mainProgram = "influxd"; };
      });
    };

    mkPkgs = system:
      import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
  in {
    overlays.default = overlay;

    packages.x86_64-linux = let pkgs = mkPkgs "x86_64-linux"; in {
      default = pkgs.influxdb2-server;
      influxdb2-server = pkgs.influxdb2-server;
    };

    packages.aarch64-linux = let pkgs = mkPkgs "aarch64-linux"; in {
      default = pkgs.influxdb2-server;
      influxdb2-server = pkgs.influxdb2-server;
    };
  };
}
