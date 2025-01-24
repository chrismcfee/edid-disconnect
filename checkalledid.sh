#!/bin/bash

for bus in {1..8}; do
    echo "Testing bus $bus"
    if i2cdump -y $bus 0x50 2>/dev/null | grep -qv "XX XX XX XX"; then
        echo "Found EDID data on bus $bus"
        i2cdump -y $bus 0x50
    fi
done
