{ config, pkgs, username, ... }: let 
    # from https://github.com/WJKPK/nixation/blob/main/nixos/perun/virt-manager.nix
    hugepage_handler = pkgs.writeShellScript "hugepage_handler.sh" ''
        xml_file="/var/lib/libvirt/qemu/$1.xml"
        
        function has_hugepages() {
            echo $(grep -c "<hugepages/>" $xml_file)
        }

        function extract_number() {
            local xml_file=$1
            local number=$(grep -oPm1 "(?<=<memory unit='KiB'>)[^<]+" $xml_file)
            echo $((number/1024))
        }
        
        function prepare_pages() { 
            # Calculate number of hugepages to allocate from memory (in MB)
            HUGEPAGES="$(($1/$(($(grep Hugepagesize /proc/meminfo | ${pkgs.gawk}/bin/gawk '{print $2}')/1024))))"
        
            echo "Allocating hugepages..."
            echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
            ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
        
            TRIES=0
            while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 )) do
                echo 3 > /proc/sys/vm/drop_caches
                echo 1 > /proc/sys/vm/compact_memory
                ## defrag ram
                echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
                ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
                echo "Successfully allocated $ALLOC_PAGES / $HUGEPAGES"
                let TRIES+=1
            done
        
            if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]; then
                echo "Not able to allocate all hugepages. Reverting..."
                echo 0 > /proc/sys/vm/nr_hugepages
                exit 1
            fi
        }
        
        function release_pages() {
            echo 0 > /proc/sys/vm/nr_hugepages
        }
        
        case $2 in
        prepare)
            if [[ $(has_hugepages) -gt 0 ]]; then
                number=$(extract_number $xml_file)
                prepare_pages $number
            fi

            ;;
        release)
            if [[ $(has_hugepages) -gt 0 ]]; then
                release_pages
            fi

            ;;
        esac
    '';

    gpubind_handler = pkgs.writeShellScript "gpubind_handler.sh" ''
        xml_file="/var/lib/libvirt/qemu/$1.xml"

        function has_gpu() {
            echo $(grep -c "<address domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>" $xml_file)
        }

        function prepare_gpu() {
            udevadm trigger --type=devices --action=remove --subsystem-match=drm --property-match="ID_PATH=pci-0000:01:00.0"
            
            sleep 1

            modprobe -r nvidia_drm
            modprobe -r nvidia_modeset
            modprobe -r nvidia_uvm
            modprobe -r nvidia
            
            sleep 1
        }

        function release_gpu() {
            modprobe nvidia_drm
            modprobe nvidia_modeset
            modprobe nvidia_uvm
            modprobe nvidia

            sleep 2

            udevadm trigger --type=devices --action=remove --subsystem-match=drm --property-match="ID_PATH=pci-0000:01:00.0"
        }

        case $2 in
        prepare)
            if [[ $(has_gpu) -gt 0 ]]; then
                prepare_gpu
            fi

            ;;
        release)
            if [[ $(has_gpu) -gt 0 ]]; then
                release_gpu
            fi

            ;;
        esac
    '';

    notification_handler = pkgs.writeShellScript "notification_handler.sh" ''
        function send_notification() {
            ${pkgs.sudo}/bin/sudo -u ${username} DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ${username})/bus ${pkgs.dunst}/bin/dunstify -u low "Virtual Machine" "$1 $2" --timeout=2500
        }

        case $2 in
        prepare)
            send_notification $1 Starting
            ;;
        start)
            send_notification $1 Started
            ;;
        stopped)
            send_notification $1 Stopped
            ;;
        esac
    '';

    kvmfrRules = pkgs.writeTextFile {
        name        = "90-kvmfr";
        text        = builtins.readFile ../../rules/kvmfr.rules;
        destination = "/etc/udev/rules.d/90-kvmfr.rules";
    };

    patchedLG = pkgs.looking-glass-client.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
            ../../patches/looking-glass-super.patch
        ];
    });
in {
    virtualisation.libvirtd.hooks.qemu = {
        hugepages_handler = "${hugepage_handler}";
        notification_handler = "${notification_handler}";
        gpubind_handler = "${gpubind_handler}";
    };

    environment.systemPackages = with pkgs; [
        patchedLG
    ];

    boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
    boot.kernelModules = [
        "kvmfr"
    ];

    boot.extraModprobeConfig = ''
        options kvmfr static_size_mb=32
    '';

    services.udev.packages = [ kvmfrRules ];

    virtualisation.libvirtd.qemu.verbatimConfig = ''
        cgroup_device_acl = [
          "/dev/null",
          "/dev/full",
          "/dev/zero",
          "/dev/random",
          "/dev/urandom",
          "/dev/ptmx",
          "/dev/kvm",
          "/dev/kqemu",
          "/dev/rtc",
          "/dev/hpet",
          "/dev/kvmfr0"
        ]

        namespaces = []
    '';
}