# nix-gtimelog-mac

Creates a MacOS app wrapper for [gtimelog](https://gtimelog.org/), an open-source minimalist time-tracker.

Add to your home-manager/nix-darwin config like so:
```nix
inputs.gtimelog-mac = {
	url = "github:i-am-karan-singh/nix-gtimelog-mac";
	inputs.nixpkgs.follows = "nixpkgs";
};
# OR for flakehub
inputs.gtimelog-mac = {
	url = "https://flakehub.com/f/karan/nix-gtimelog-mac/0.1";
	inputs.nixpkgs.follows = "nixpkgs";
};
...
# AND
home.packages = [ 
	inputs.gtimelog-mac.packages.${pkgs.stdenv.hostPlatform.system}.default 
];
```

## Why does this flake exist?
While gtimelog [exists](https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/by-name/gt/gtimelog/package.nix#L67) in nixpkgs, it does not create a MacOS app. This flake takes the MacOS wrapper app from this [repo](https://github.com/minddistrict/gtimelog-macosx), which otherwise requires manual installation of gtimelog and gtk, and patches it so that it uses the nixpkg version of gtimelog. 

Essentially, all we do is `exec gtimelog` to open the app. Hence this repo is always up-to-date in the sense that the version of gtimelog used derives from *your* nixpkgs.

## Other tips
iCloud works well for cross-device syncing.
```nix
let
	gtimelogDir = "/Users/username/Documents/.gtimelog";
	link = config.lib.file.mkOutOfStoreSymlink;
in {
	home.file.".local/share/gtimelog".source = link gtimelogDir;
};
```
