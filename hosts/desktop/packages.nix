{ lib, inputs, pkgs, ... }: let
    patchDesktop = pkg: appName: from: to: lib.hiPrio (
        pkgs.runCommand "$patched-desktop-entry-for-${appName}" {} ''
            addDir() {
                if [ -d ${pkg}/$1 ]; then
                    ${pkgs.coreutils}/bin/mkdir -p $out/$1
                    ${pkgs.coreutils}/bin/cp -r ${pkg}/$1/* $out/$1
                fi    
            }

            addDir bin
            addDir share/icons
            addDir share/pixmaps
            addDir share/mime

            ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
            ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
        ''
     );

    GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=prime-run ";

    citron-emu = pkgs.stdenv.mkDerivation rec {
        pname = "citron-emu";
        version = "0.6.1";

        src = pkgs.fetchurl {
            url = "https://github.com/pkgforge-dev/Citron-AppImage/releases/download/v${version}/Citron-v${version}-anylinux-x86_64.AppImage";
            hash = "sha256-MDrM4n6s0sPVl0d9pIZ2XLKXYw0AX+5znflAwquZ6o0=";
        };

        nativeBuildInputs = [ pkgs.makeWrapper ];

        # need to copy so can make it executable
        unpackPhase = ''
            cp "$src" "${pname}.AppImage"
        '';

        buildPhase = ''
            chmod +x ${pname}.AppImage
            ./${pname}.AppImage --appimage-extract
        '';

        installPhase = ''
            mkdir -p $out/appimage-output
            cp -a squashfs-root/. $out/appimage-output/

            mkdir -p $out/bin
            ln -s $out/appimage-output/AppRun $out/bin/citron-emu

            mkdir -p $out/share/applications
            cp squashfs-root/org.citron_emu.citron.desktop $out/share/applications/citron-emu.desktop

            substituteInPlace $out/share/applications/citron-emu.desktop \
                --replace 'Exec=citron' "Exec=$out/bin/citron-emu" \
                --replace 'TryExec=citron' "Exec=$out/bin/citron-emu" \
                --replace 'Icon=org.citron_emu.citron' "Icon=citron-emu"

            mkdir -p $out/share/icons/hicolor/scalable/apps
            cp squashfs-root/org.citron_emu.citron.svg $out/share/icons/hicolor/scalable/apps/citron-emu.svg
        '';
    };

    mangohudWrapped = pkgs.mangohud.overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs or [] ++ [ pkgs.makeWrapper ];

        postFixup = ''
            wrapProgram $out/bin/mangohud \
                --set LD_LIBRARY_PATH "/run/opengl-driver/lib:${old.LD_LIBRARY_PATH or ""}" 
        '';
    });
in {
    # TODO: add modules for these
    environment.systemPackages = with pkgs; [
        clang-tools
        networkmanagerapplet
        kitty
        gimp
        vscode.fhs
        smartmontools
        pavucontrol
        fastfetch
        cheese
        vlc
        proton-pass
        ente-auth
        electron-mail
        element-desktop
        signal-desktop
        librewolf
        baobab
        r2modman
        gale
        mesa-demos
        gnome-disk-utility
        gnome-text-editor
        adwaita-icon-theme
        gsettings-desktop-schemas
        kdePackages.ark
        kdePackages.dolphin
        firefox
        waydroid-helper
        unzip
        dopamine
        loupe
        qbittorrent
        openvpn
        networkmanager-openvpn
        motrix
        obs-studio
        bottles
        fuse
        javaPackages.compiler.openjdk25

        (GPUOffloadApp openscad "openscad")
    ] ++
    # games
    [
        mangohudWrapped
        
        vulkan-loader
        vulkan-tools
        libdecor
        winboat

        heroic
        prismlauncher
        (GPUOffloadApp superTuxKart "supertuxkart")
        (GPUOffloadApp lunar-client "lunarclient")
        (GPUOffloadApp osu-lazer "osu")

        mesen
        (GPUOffloadApp snes9x-gtk "snes9x-gtk")
        (GPUOffloadApp ares "ares")
#        (GPUOffloadApp duckstation "org.duckstation.DuckStation")
        (GPUOffloadApp mgba "io.mgba.mGBA")
        (GPUOffloadApp melonDS "net.kuribo64.melonDS")
        (GPUOffloadApp azahar "org.azahar_emu.Azahar")
        (GPUOffloadApp dolphin-emu "dolphin-emu")
        (GPUOffloadApp cemu "info.cemu.Cemu")
        (GPUOffloadApp ryubing "Ryujinx")
#        (GPUOffloadApp citron-emu "citron-emu")
        (GPUOffloadApp chiaki-ng "chiaking")
    ];

    programs.gamemode.enable = true;
    programs.gamescope = {
        enable = true;
        args = [
            "-W 1920"
            "-H 1080"
            "-r 165"
        ];

        capSysNice = false;
    };


    services.ananicy = with pkgs; {
        enable = true;
        package = ananicy-cpp;
        rulesProvider = ananicy-cpp;
        extraRules = [
            {
                "name" = "gamescope";
                "nice" = -20;
            }
        ];
    };

    services.flatpak.packages = [ "io.github.everestapi.Olympus" ];
}
