LOG_DIR=$HOME/.cache/prime-run/
if [ ! -d $LOG_DIR ]; then
    mkdir $LOG_DIR
fi

LOG_FILE=$LOG_DIR/prime-run-gamescope.log
USE_GPU=$(prime-run-base)

printf "" > $LOG_FILE

if [[ -z $GAMESCOPE_ARGS ]]; then
    export GAMESCOPE_ARGS="-W 1920 -H 1080 -r 165 --expose-wayland"
fi

echo -e "env:\n$(env)\n\n" >> $LOG_FILE
echo -e "running on $USE_GPU with command:\ngamescope $GAMESCOPE_ARGS -- $@" >> $LOG_FILE

gamescope $GAMESCOPE_ARGS -- prime-run "$@" |& tee -a $LOG_FILE