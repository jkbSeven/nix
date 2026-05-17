{ config, pkgs, hostname, lib, ... }:

{
    system.stateVersion = "25.11";

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.initrd.availableKernelModules = [
        "virtio_pci"
        "virtio_scsi"
        "virtio_blk"
    ];

    boot.loader.systemd-boot.enable = false;
    boot.loader.grub = {
        enable = true;
        device = "/dev/vda";
    };

    services.qemuGuest.enable = true;

    virtualisation.diskSize = 8192;  # in MiB

    proxmox.qemuConf = {
        cores = 4;
        memory = 8192;  # in MiB
    };

    networking.hostName = hostname;
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Warsaw";
    i18n.defaultLocale = "en_US.UTF-8";

    services.openssh.enable = true;

    users.users.jkb = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
        ];
        shell = pkgs.zsh;
        packages = with pkgs; [ ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGUyXopT6n4AgbFY4E2Xgf753xESReel5p45qDYIRaV"
        ];
        initialPassword = "P@ssw0rd";
    };

    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
        bat
        vim
        git
    ];

}
