{ config, ... }:

{
  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };
  i18n = {
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # set a keyboard layout if x11 is enabled
  #services.xserver = if config.services.xserver.enable then {layout= "gb";} else {};
  services.xserver.layout = "gb";
  
}