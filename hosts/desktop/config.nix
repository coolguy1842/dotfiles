{ lib, config, pkgs, inputs, ... }: let 
    drmPCI = "pci-0000:07:00.0";
in {
    display = {
        nvidia.enable = true;
        nvidia.prime.enable = true;
        nvidia.cuda.enable = true;

        ags.enable = true;
        hyprland = {
            enable = true;
            animation.enable = true;

            drmDevices = [ "${drmPCI}-card" ];

            primaryMonitor = "DP-1";
            monitors = {
                DP-1     = { workspaces = 9; persistentWorkspaces = true; resolution = "1920x1080"; refreshRate = 165; position = "1680x0"; };
                HDMI-A-2 = { workspaces = 1; persistentWorkspaces = true; resolution = "1680x1050"; refreshRate = 60;  position = "0x30"; workspaceBind = "${config.display.hyprland.modifier} ALT"; };
            };

            specialWorkspaces = {
                discord.keybind = "D";
                music.keybind = "S";
                email.keybind = "E";
                windows.keybind = "G";
                capturecard.keybind = "C";
            };
        };
    };

    services = {
        bluetooth.enable = true;
        bluetooth.blueman.enable = true;
        
        sound.pipewire = {
            enable = true;

            rtkit.enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };

        libvirt.enable = true;
        waveeffect.enable = true;
        zerotierone.enable = true;

        sunshine = {
            enable = true;

            autoStart = true;
            capSysAdmin = true;
            openFirewall = true;

            settings = {
                sunshine_name = "desktop-nixos";

                capture = "kms";
                encoder = "vaapi";

                output_name = 1;

                adapter_name = "/dev/dri/by-path/${drmPCI}-render";
                kms_node = "/dev/dri/by-path/${drmPCI}-card";
            };

            applications.apps = [
                {
                    name = "Desktop";

                    exclude-global-prep-cmd = "false";
                    auto-detach = "true";
                }
                {
                    name = "1440p Desktop";
                    prep-cmd = [
                        {
                            do = "${(pkgs.writeShellScriptBin "startSunshine" ''
                                hyprshade off

                                hyprctl keyword monitor HDMI-A-2,2560x1440@100,auto,1.3333
                                hyprctl keyword monitor DP-1,disable
                            '')}/bin/startSunshine";
                            undo = "${(pkgs.writeShellScriptBin "stopSunshine" ''
                                hyprctl reload
                                hyprshade on vibrance
                            '')}/bin/stopSunshine";
                        }
                    ];

                    exclude-global-prep-cmd = "false";
                    auto-detach = "true";
                }
            ];
        };
    };

    applications = {
        defaults = {
            web-browser  = { program = "firefox";     desktopFile = "firefox.desktop"; };
            file-manager = { program = "dolphin"; desktopFile = "dolphin.desktop"; };
            terminal     = { program = "kitty";   desktopFile = "kitty.desktop"; };
        };
        
        discord.enable = true;
        blender.enable = true;
    };

    media = {
        plex.desktop.enable = true;
        youtube-music.enable = true;
    };
    
    games = {
        steam.enable = true;
        sober.enable = true;
    };

    "3dprinting" = {
        orca-slicer.enable = true;
    };

    input = {
        sensitivity = -0.52;
        
        keyboardLayout = "us";
        locale = "en_AU.UTF-8";
    };

    environment.sessionVariables = {
        __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";
        VK_ICD_FILENAMES = lib.mkDefault "${pkgs.mesa}/share/vulkan/icd.d/radeon_icd.x86_64.json:${pkgs.mesa}/share/vulkan/icd.d/intel_icd.x86_64.json";
        SDL_AUDIODRIVER = "pulse";
        ALSOFT_DRIVERS = "pulse";
    };

    hardware.opentabletdriver.enable = true;
    virtualisation.waydroid.enable = true;

    programs = {
        sniffnet.enable = true;
        nix-ld = {
            enable = true;

            # from https://github.com/NixOS/nixpkgs/issues/282680#issuecomment-1905797369
            # "minimum" amount of libraries needed for most games to run without steam-run
            libraries = with pkgs; [
                # common requirement for several games
                stdenv.cc.cc.lib

                # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L72-L79
                xorg.libXcomposite
                xorg.libXtst
                xorg.libXrandr
                xorg.libXext
                xorg.libX11
                xorg.libXfixes
                xorg.libxcb
                libGL
                libva

                # from https://github.com/NixOS/nixpkgs/blob/nixos-23.05/pkgs/games/steam/fhsenv.nix#L124-L136
                fontconfig
                freetype
                xorg.libXt
                xorg.libXmu
                xorg.libXdamage
                libogg
                libvorbis
                SDL
                SDL2_image
                glew110
                libdrm
                libidn
                tbb
                zlib
                fuse
                glib
                nss
                nspr
                atk
                dbus
                gdk-pixbuf
                gtk3
                pango
                cairo
                expat
                libxkbcommon
                libgbm
                alsa-lib
                cups
                icu
            ];
        };
    };

    virtualisation.podman = {
        enable = true;
        dockerCompat = true;
    };

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            vpl-gpu-rt
            intel-media-driver
            ocl-icd
            intel-ocl
        ];
    };

    environment.systemPackages = with pkgs; [ distrobox ];
    system.stateVersion = "25.05";
}
