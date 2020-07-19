# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <nixpkgs/nixos/modules/virtualisation/qemu-guest-agent.nix>
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  swapDevices = [ { device = "/dev/rootvg/lv_swap"; } ];
  
  networking.hostName = "kvm-base-nixos"; # Define your hostname.
  networking.nameservers = [ "172.24.28.11" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.defaultGateway = { address = "172.24.28.1"; interface = "ens18"; };
  networking.interfaces = {
    ens18 = {
      ipv4 = {
        addresses = [ { address = "172.24.28.201"; prefixLength = 24; } ];
      };
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "UTC";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    iftop
    iotop
    git
    mkpasswd
    ncdu
    nmon
    tmux
    vim
    wget
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the quemu guest agent
  services.qemuGuest.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.phil = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDtcThnBns0T0wtgPKuhZjGzXyX/5lkyZuRsjuQOfsNq44lQLvvKQWgRJEK9d7rQVTePyK+4F/3WbvKeKPKmgZtGWnn1RHRUgUTev+4SEkeakI8P5FOlwQ3riKy8o51obj5GtOPVVyee28/gD2JXr0hAcp71ovs/1I3ppo5w5ai+bSr2fxajX6FdSzpV32j4ZORgfK5sjLSYfIcKq5cjSqjoC+EC/Mxsj0l+xFcmtUN7NKggnRJaqbry66TBXhG396VPMIC8buiGW2CV4Xx0VoIFOSXyYZugD88ZhUXfQCikv0MuqzQpewuHqJ88z7y5UXJAr0XvPcNEIO4Bv5Prcv phil@theseus" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}
