{ config, pkgs, options, ... }:

{
  networking.hostName = "max-desktop";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware/desktop-hardware.nix
      ../bundles/base.nix
      ../bundles/locale.nix
      ../bundles/desktop.nix
      ../bundles/coding.nix
    ];

  ## boot

  # note !not! systemd-boot because that does not support dual booting properly!
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiInstallAsRemovable = false;
      efiSupport = true;
      useOSProber = true;
      fsIdentifier = "label";
      extraEntries = ''
                      menuentry "Reboot" {
                        reboot
                      }
                      menuentry "Poweroff" {
                        halt
                      }
                      '';
    };
  };

  networking.networkmanager.enable = true;
  networking.wireless.networks = {
    "YoungWhale2"= {
      psk = "penelope1968"; 
    };
  };
  
  time.hardwareClockInLocalTime = true; # to fix windows stupidity  
  
  services.xserver.videoDrivers = ["nvidia"];


  # networking 
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
}
