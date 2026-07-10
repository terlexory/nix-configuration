# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
  ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  networking.hostName = "ideapad"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.enable = true;

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  networking.wireless.iwd.settings = {
    General = {
      # Skip if this causes issues with some networks; it's just a good default
      RoamThreshold = -75;
      RoamThreshold5G = -80;
      EnableNetworkConfiguration = true;
    };
    DriverQuirks = {
      PowerSaveDisable = "*";  # disables power save for all wifi drivers
    };
  };

  services.flatpak.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings = {
    default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  
  virtualisation.libvirtd.enable = true;

  hardware.bluetooth = {
   enable = true;
   powerOnBoot = true;
   settings = {
     General = {
       ControllerMode = "bredr";
       Experimental = true;
       FastConnectable = true;
     };
     Policy = {
       AutoEnable = true;
     };
   };
  };

  nixpkgs.config.allowUnfree = true;

  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true; # broader, unfree firmware included
  hardware.graphics.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true; 

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.victor = {
    isNormalUser = true;
    description = "Victor";
    extraGroups = [ "wheel" "libvirtd" ]; # Enable ‘sudo’ for the user.
  };

  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.noto
    nerd-fonts.droid-sans-mono
    nerd-fonts.hack
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ]; 

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    fastfetch
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vesktop
    alacritty
    vlc
    unzip
    zip
    prismlauncher
    vscode
    btop
    steam
    rustc
    cargo
    gcc
    gnumake
    automake
    autoconf
    libtool
    git
    python3
    python3Packages.pip
    neovim
    vimPlugins.LazyVim
    qemu
    virt-manager
    dnsmasq
    noctalia-shell
    nautilus
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

