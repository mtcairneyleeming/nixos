{ config, pkgs, options, ... }:

{
  # as well as the basic stuff (including a patched vscode) in desktop.nix
  environment.systemPackages = with pkgs; [ 
	jetbrains.rider
	jetbrains.idea-ultimate
	dotnet-sdk_5
	python39Full
	nodejs
	jetbrains.pycharm-professional
	postgresql_11
	postgresql11Packages.postgis
	# ... more?? maybe ros in the future
  ];
  
}
