{ config, pkgs, options, ... }:

let hostname="max-testvm";
in
{
  networking.hostName = hostname;

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/systems/hardware/testvm-hardware.nix
      /etc/nixos/bundles/base.nix
      /etc/nixos/bundles/locale.nix
      /etc/nixos/bundles/desktop.nix
    ];

  # boot
  boot.loader.systemd-boot.enable = true;
  # turn off checks as they always fail in a VM
  boot.initrd.checkJournalingFS = false;

  #  allow me to use the virtualbox share (don't worry, it merges this list with the one in base.nix)
  users.users.max.extraGroups = [ "vboxsf"];

  # networking 
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
}