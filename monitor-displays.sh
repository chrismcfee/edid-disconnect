#!/bin/bash
#!/bin/bash

# Path for node exporter textfile collector
METRIC_FILE="/var/lib/node_exporter/textfile/display_status.prom"

{
    echo "# HELP display_status Display connection status (1=connected, 0=disconnected)"
    echo "# TYPE display_status gauge"

    # Process nvidia-settings output
    nvidia-settings -q dpys | while read -r line; do
        # Match lines with GPU, DP, and optional "(enabled)"
        if [[ $line =~ \[([0-9]+)\].*GPU-([0-9]+)\.DP-([0-9]+)\).* ]]; then
            display_num="${BASH_REMATCH[1]}"
            gpu_num="${BASH_REMATCH[2]}"
            dp_num="${BASH_REMATCH[3]}"

            # Check if the line contains "(enabled)"
            if [[ $line == *"(enabled)"* ]]; then
                enabled=1
            else
                enabled=0
            fi

            # Only include displays with "(enabled)" or other valid criteria
            if [[ $enabled -eq 1 ]]; then
                echo "display_status{gpu=\"$gpu_num\",dp=\"$dp_num\",display=\"$display_num\"} $enabled"
            fi
        fi
    done

    echo "# HELP total_enabled_displays Total number of enabled displays"
    echo "# TYPE total_enabled_displays gauge"
    echo "total_enabled_displays $(nvidia-settings -q dpys | grep "(enabled)" | wc -l)"
} > "$METRIC_FILE"



# Path for node exporter textfile collector
#METRIC_FILE="/var/lib/node_exporter/textfile/display_status.prom"

# Write metrics in Prometheus format
#{
#    echo "# HELP display_status Display connection status (1=connected, 0=disconnected)"
#    echo "# TYPE display_status gauge"

    # Process nvidia-settings output
#    nvidia-settings -q dpys | while read -r line; do
#        if [[ $line =~ \[([0-9]+)\].*GPU-([0-9]+)\.DP-([0-9]+)\).*(\(enabled\))? ]]; then
#            display_num="${BASH_REMATCH[1]}"
#            gpu_num="${BASH_REMATCH[2]}"
#            dp_num="${BASH_REMATCH[3]}"
#            if [[ ${line} == *"(enabled)"* ]]; then
#                enabled=1
#            else
#                enabled=0
#            fi
#            echo "display_status{gpu=\"$gpu_num\",dp=\"$dp_num\",display=\"$display_num\"} $enabled"
#        fi
#    done
#
#    echo "# HELP total_enabled_displays Total number of enabled displays"
#    echo "# TYPE total_enabled_displays gauge"
#    echo "total_enabled_displays $(nvidia-settings -q dpys | grep -c "(enabled)")"
#} > "$METRIC_FILE"
