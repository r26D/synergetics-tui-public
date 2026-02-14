#!/bin/bash

echo "Terminal Diagnostics"
echo "===================="
echo ""

echo "1. TTY device:"
tty
echo ""

echo "2. Terminal type:"
echo $TERM
echo ""

echo "3. Current shell:"
echo $SHELL
ps -p $$
echo ""

echo "4. /dev/tty status:"
ls -l /dev/tty
echo ""

echo "5. Can we read /dev/tty?"
if [ -r /dev/tty ]; then
    echo "✅ /dev/tty is readable"
else
    echo "❌ /dev/tty is NOT readable"
fi
echo ""

echo "6. Can we write to /dev/tty?"
if [ -w /dev/tty ]; then
    echo "✅ /dev/tty is writable"
else
    echo "❌ /dev/tty is NOT writable"
fi
echo ""

echo "7. Current stty settings:"
stty -a
echo ""

echo "8. Try to set raw mode:"
TTY_DEVICE=$(tty)
echo "TTY device: $TTY_DEVICE"

if [ "$TTY_DEVICE" != "not a tty" ]; then
    echo "Trying: stty -f $TTY_DEVICE -icanon -echo"
    if stty -f $TTY_DEVICE -icanon -echo 2>&1; then
        echo "✅ stty -f succeeded"
        stty -f $TTY_DEVICE icanon echo  # Restore
    else
        echo "❌ stty -f failed, trying redirect..."
        if stty -icanon -echo < $TTY_DEVICE 2>&1; then
            echo "✅ stty with redirect succeeded"
            stty icanon echo < $TTY_DEVICE  # Restore
        else
            echo "❌ stty with redirect also failed"
        fi
    fi
else
    echo "❌ Not running in a TTY"
fi

echo ""
echo "9. Process tree:"
ps -f
echo ""

echo "Diagnostics complete!"

