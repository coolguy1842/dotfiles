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
            hash = "sha256-uT4h0QYjNfK4sBeqjqygcsF1o34xm1CsWCRjPzplqNM=";
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
            cp squashfs-root/citron.desktop $out/share/applications/citron-emu.desktop

            substituteInPlace $out/share/applications/citron-emu.desktop \
                --replace 'Exec=citron' "Exec=$out/bin/citron-emu" \
                --replace 'TryExec=citron' "Exec=$out/bin/citron-emu" \
                --replace 'Icon=org.citron_emu.citron' "Icon=citron-emu"

            mkdir -p $out/share/icons/hicolor/scalable/apps
            cp squashfs-root/citron.svg $out/share/icons/hicolor/scalable/apps/citron-emu.svg
        '';
    };
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
        mesa-demos
        gnome-disk-utility
        gnome-text-editor
        kdePackages.ark
        kdePackages.dolphin
        inputs.zen-browser.packages."${system}".default

        (GPUOffloadApp openscad "openscad")
    ] ++
    # games
    [
        mangohud
        
        vulkan-loader
        vulkan-tools
        libdecor

        heroic
        prismlauncher
        (GPUOffloadApp superTuxKart "supertuxkart")
        (GPUOffloadApp lunar-client "lunarclient")
        (GPUOffloadApp ryujinx "Ryujinx")
        (GPUOffloadApp dolphin-emu "dolphin-emu")
        (GPUOffloadApp citron-emu "citron-emu")
        (GPUOffloadApp retroarchFull "com.libretro.RetroArch")
        (GPUOffloadApp azahar "org.azahar_emu.Azahar")
        (GPUOffloadApp chiaki-ng "chiaking")
    ];

    programs.gamescope = {
        enable = true;
        args = [
            "-W 1920"
            "-H 1080"
            "-r 165"
        ];

        capSysNice = true;
    };

    services.flatpak.packages = [ "io.github.everestapi.Olympus" ];
}
