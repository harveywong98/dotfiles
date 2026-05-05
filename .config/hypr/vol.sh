#!/bin/bash

# 1. 精确获取 SPlayer/Chromium 的流 ID
STREAM_ID=$(wpctl status | sed -n '/Streams:/,$p' | grep -iE "Chromium|SPlayer" | grep -oE "[0-9]+" | head -n 1)

# 2. 执行动作
case $1 in
    up)
        # 调节系统总音量
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
        # 同步调节播放器流音量
        if [ -n "$STREAM_ID" ]; then
            wpctl set-volume -l 1.5 "$STREAM_ID" 5%+
        fi
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        if [ -n "$STREAM_ID" ]; then
            wpctl set-volume "$STREAM_ID" 5%-
        fi
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        if [ -n "$STREAM_ID" ]; then
            wpctl set-mute "$STREAM_ID" toggle
        fi
        ;;
esac
