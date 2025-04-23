driver=$(lspci -k | grep 3060 -A 3 | grep "driver in use" | grep -Eio ": .*" | grep -Eio "[a-z0-9\_\-]*")

if [[ $driver != "nvidia" ]]; then
    echo "iGPU"
    exit
fi

echo "dGPU"