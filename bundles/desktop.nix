{ config, pkgs, options, ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  
  # Enable the desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;


   # Enable CUPS to print documents.
  services.printing.enable = true;

  # add me to the audio group (don't worry, it merges this list with the one in base.nix)
  users.users.max.extraGroups = [ "audio"];

  # Enable pulseaudio sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  nixpkgs.config.pulseaudio = true;

#   # Enable sound, using pipewire
#   sound.enable = false; # see https://nixos.wiki/wiki/PipeWire
#   security.rtkit.enable = true;
#   services.pipewire = {
#     enable = true;
#     alsa.enable = true;
#     alsa.support32Bit = true;
#     pulse.enable = true;
#   };
#   # to be sure:
#   hardware.pulseaudio.enable = false;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # overlay to fix vscode
  nixpkgs.overlays = [
      (import /etc/nixos/overlays/vscode-overlay.nix)
  ];
  # vs code patching
  environment.systemPackages = with pkgs; [ # packages useful on desktop, but not including coding stuff
      firefox
      google-chrome
      #zoom-us
      #teams
    
      mullvad-vpn
      xournalpp
      typora
      vscode-with-extensions # just a nice editor
      quodlibet-full
      # ...
  ];
  
}
