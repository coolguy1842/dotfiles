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
    
    citraholdUI = let
        name = "Citrahold UI";
        pname = "citraholdUI";
        version = "1.1.0";

        desktopFile = pkgs.makeDesktopItem {
            name = "${pname}";
            desktopName = "${name}";

            exec = "${pname}";
            icon = "${pname}";

            categories = [ "Utility" ];
        };   
    in pkgs.stdenv.mkDerivation {
        inherit pname version;

        src = pkgs.fetchFromGitHub {
            owner = "regimensocial";
            repo = "citraholdUI";

            rev = "v1.1.0";
            sha256 = "sha256-CWWw9T51LpusauyfURouU/Tss8Fi1i5hk5bGragyA2Q=";
        };

        nativeBuildInputs = [ pkgs.qt6.full ];

        configurePhase = "qmake";
        buildPhase = "make";
        installPhase = ''
            mkdir -p $out/{bin,share/{applications,icons/hicolor/scalable/apps}}
            
            cp ./Citrahold $out/bin/${pname}
            cp $src/icon.png $out/share/icons/hicolor/scalable/apps/${pname}.png

            cp ${desktopFile}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
        '';
    };

    WiiUDownloader = let
        name = "WiiU Downloader";
        pname = "WiiUDownloader";
        version = "2.65";

        src = pkgs.fetchFromGitHub {
            owner = "Xpl0itU";
            repo = "WiiUDownloader";
            rev = "v${version}";
            sha256 = "sha256-shzwvWOIYG6B5yDBbouxY9ThvIHM8/yEBzHPYxyYYqg=";
        };
        
        db = pkgs.fetchurl {
            url = "https://napi.v10lator.de/db?t=go";
            sha256 = "sha256-+sb1tCQgre95aElNy3+UrYy5G/z3c9VGT1Do2ID0CB0=";

            name = "db.go";
            curlOpts = "--user-agent NUSspliBuilder/2.1";
        }; 

        srcWithDb = pkgs.runCommand "WiiUDownloader-src" { inherit db; } ''
            mkdir -p $out
            cp -r ${src}/* $out/
            cp ${db} $out/db.go
        '';

        desktopFile = pkgs.makeDesktopItem {
            name = "${pname}";
            desktopName = "${name}";

            exec = "${pname}";
            icon = "${pname}";

            categories = [ "Utility" ];
        };
    in pkgs.buildGoModule {
        inherit pname name version;

        src = srcWithDb;
        vendorHash = "sha256-Cqk8lcj1Oh5MCZs5FvNKnq+QF924B8ZoGaDg7jvgT/U=";

        nativeBuildInputs = with pkgs; [ pkg-config xorg.libX11 zlib ];
        buildInputs = with pkgs; [ glib gtk3 ];

        buildPhase = ''
            go build ./cmd/WiiUDownloader
        '';

        installPhase = ''
            mkdir -p $out/{bin,share/{applications,icons/hicolor/scalable/apps}}
            cp ./WiiUDownloader $out/bin/${pname}

            cp $src/data/WiiUDownloader.png $out/share/icons/hicolor/scalable/apps/${pname}.png
            cp ${desktopFile}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
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
        mesen
        (GPUOffloadApp snes9x-gtk "snes9x-gtk")
        (GPUOffloadApp ares "ares")
        (GPUOffloadApp mgba "io.mgba.mGBA")
        (GPUOffloadApp melonDS "net.kuribo64.melonDS")
        (GPUOffloadApp azahar "org.azahar_emu.Azahar")
        (GPUOffloadApp dolphin-emu "dolphin-emu")
        (GPUOffloadApp cemu "info.cemu.Cemu")
        (GPUOffloadApp ryujinx "Ryujinx")
        (GPUOffloadApp chiaki-ng "chiaking")
        citraholdUI

        WiiUDownloader
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
