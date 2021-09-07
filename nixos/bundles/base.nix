{ config, pkgs, options, lib,... }:

{
  # Allow software with an unfree license
  nixpkgs.config.allowUnfree = true;

  # Enable the OpenSSH server.
  services.sshd.enable = true;

  # Enable garbage collection
  nix.gc.automatic = true;
  nix.gc.dates = "06:15";

  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    home = "/home/max";
    description = "Max Cairney-Leeming";
    extraGroups = [ "wheel" "networkmanager" ];
    uid = 1000;
  };

  # TODO force user changes to be made above - change if something fails to install!!
  users.mutableUsers = true;

  # really basic packages that are necessary on any system
  environment.systemPackages = with pkgs; [
    nano
    wget
    git
  ];


  # add a list of all packages to a file
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
      formatted;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}