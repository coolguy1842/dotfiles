LOG_DIR=~/.cache/prime-run/
if [ ! -d $LOG_DIR ]; then
    mkdir $LOG_DIR
fi

LOG_FILE=$LOG_DIR/prime-run.log
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
USE_GPU=$(prime-run-base)

printf "" > $LOG_FILE

ENV_VARS=""

case $USE_GPU in
dGPU)
    unset VK_LOADER_DRIVERS_DISABLE

    export __VK_LAYER_NV_optimus=NVIDIA_only
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __EGL_VENDOR_LIBRARY_FILENAMES=$(nvidiaPath)/share/glvnd/egl_vendor.d/10_nvidia.json
    export VK_DRIVER_FILES=$(nvidiaPath)/share/vulkan/icd.d/nvidia_icd.x86_64.json

    export DXVK_STATE_CACHE_PATH=~/.cache/dxvk
    export DXVK_FILTER_DEVICE_NAME="RTX 3060"

    export __GL_SHADER_DISK_CACHE_PATH=~/.cache/glshaders
    export __GL_SHADER_DISK_CACHE=1
    export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

    export GBM_BACKEND=nvidia-drm
    export VDPAU_DRIVER=nvidia
    export LIBVA_DRIVER_NAME=nvidia

    export VKD3D_CONFIG=dxr11,dxr
    export PROTON_ENABLE_NVAPI=1
    export PROTON_ENABLE_NGX_UPDATER=1
    export VKD3D_FEATURE_LEVEL=12_2
    export VKD3D_FEATURE_LEVEL=6_6

    export OBS_VKCAPTURE=1

    export VKD3D_DISABLE_EXTENSIONS=VK_KHR_present_wait

    ;;
iGPU) ;;& *)
    dunstify -u crit "Prime Run" "dGPU is unavailable, running with IGPU." --timeout=5000
    echo -e "dGPU unavailable\n" >> $LOG_FILE 

    ;;
esac

run_game() {
    exec "$@"
}

echo -e "running on $USE_GPU with command:\n$@" >> $LOG_FILE
exec "$@" |& tee $LOG_FILE