pid=$(hyprctl activewindow -j | $(jqBin) -r '.pid')
if ! [ $(ps q $pid o uid=) -eq $(id -u) ]; then
    exit 1
elif [[ ! -w /run/user/$(id -u) ]]; then
    exit 2
fi

frozen=$(expr $(ps q "$pid" o stat=) : T)
if [[ $frozen == 0 ]]; then
    kill -s STOP $pid
else
    kill -s CONT $pid
fi
