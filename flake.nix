{
	description = "gtimelog as an app on macOS";

	inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

	outputs = { nixpkgs, ... }: let
		system = "aarch64-darwin";
		pkgs = nixpkgs.legacyPackages.${system};
	in {
		packages.${system}.default = pkgs.stdenvNoCC.mkDerivation {
			pname = "gtimelog-mac";
			version = pkgs.gtimelog.version;

			dontUnpack = true;

			installPhase = ''
				runHook preInstall

				mkdir -p "$out/Applications/gtimelog.app/Contents/MacOS"
				mkdir -p "$out/Applications/gtimelog.app/Contents/Resources"

				cat > "$out/Applications/gtimelog.app/Contents/MacOS/gtimelog" <<EOF
#!/bin/bash
exec ${pkgs.gtimelog}/bin/gtimelog "\$@"
EOF

				chmod +x "$out/Applications/gtimelog.app/Contents/MacOS/gtimelog"

				cat > "$out/Applications/gtimelog.app/Contents/Info.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>English</string>

	<key>CFBundleExecutable</key>
	<string>gtimelog</string>

	<key>CFBundleIconFile</key>
	<string>gtimelog.icns</string>

	<key>CFBundleIdentifier</key>
	<string>gtimelog</string>

	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>

	<key>CFBundleName</key>
	<string>gtimelog</string>

	<key>CFBundlePackageType</key>
	<string>APPL</string>
</dict>
</plist>
EOF

				cp ${./gtimelog.icns} "$out/Applications/gtimelog.app/Contents/Resources/gtimelog.icns"

				runHook postInstall
			'';
		};
	};
}
