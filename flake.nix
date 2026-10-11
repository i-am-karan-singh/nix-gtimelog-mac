{
	description = "gtimelog as an app on macOS";

	inputs = {
		nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
		gtimelog-macosx = {
			url = "github:minddistrict/gtimelog-macosx";
			flake = false;
		};
	};

	outputs = { nixpkgs, gtimelog-macosx, ... }: let
		system = "aarch64-darwin";
		pkgs = nixpkgs.legacyPackages.${system};
	in {
		packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
			pname = "gtimelog-mac";
			version = pkgs.gtimelog.version;

			dontUnpack = true;

			installPhase = ''
				runHook preInstall

				mkdir -p "$out/Applications"
				cp -R ${gtimelog-macosx}/gtimelog.app "$out/Applications/gtimelog.app"
				chmod -R u+w "$out/Applications/gtimelog.app"

cat > "$out/Applications/gtimelog.app/Contents/MacOS/gtimelog" <<EOF
#!/bin/bash
exec ${pkgs.gtimelog}/bin/gtimelog "\$@"
EOF

				chmod +x "$out/Applications/gtimelog.app/Contents/MacOS/gtimelog"

				runHook postInstall
			'';
		};
	};
}
