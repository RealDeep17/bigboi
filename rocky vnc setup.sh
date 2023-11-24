
#!/bin/bash
#cc
# Function to log messages to a file
log_file="/var/log/my_script.log"
log() {
    local log_message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $log_message" >> "$log_file"
}

# Function to show progress
show_progress() {
    local completed="$1"
    local total="$2"
    local percentage=$((completed * 100 / total))
    local elapsed_time="$3"
    local estimated_time="$4"
    echo "Progress: $percentage% (Elapsed: $elapsed_time seconds, Remaining: $estimated_time seconds)"
}

# Function to calculate the estimated time for a task
calculate_estimated_time() {
    local start_time="$1"
    local completed_tasks="$2"
    local total_tasks="$3"
    local average_time_per_task="$4"
    local current_time="$(date +%s)"
    local elapsed_time=$((current_time - start_time))
    local remaining_tasks=$((total_tasks - completed_tasks))
    local estimated_time=$((remaining_tasks * average_time_per_task - elapsed_time))
    echo "$estimated_time"
}

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    log "This script must be run as root."
    echo "This script must be run as root."
    exit 1
fi

log "--------------------------------------- Run as root"

# Initialize variables for total tasks
total_tasks=17  # Adjust based on the total number of tasks in your script
completed_tasks=0

# Initialize variables for tracking time
start_time="$(date +%s)"
elapsed_time=0
average_time_per_task=3  # Adjust this based on your expectations

# Task 1: Update system
task1_description="Updating system"
log "Task 1: $task1_description..."
{
    echo "$task1_description"
    time sudo dnf clean all && sudo dnf update -y
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time "$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task")
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 2: Install GUI packages
task2_description="Installing GUI packages"
log "Task 2: $task2_description..."
{
    echo "$task2_description"
    time sudo dnf groupinstall 'Server with GUI' -y
    sudo systemctl set-default graphical.target
    time sudo dnf install tigervnc-server nano htop cockpit epel-release -y
    time sudo dnf copr enable castor/remmina -y
    time sudo dnf install 'remmina*' -y
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time "$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task")
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 3: Change passwords
task3_description="Change passwords"
log "Task 3: $task3_description..."
{
    echo "$task3_description"
    sudo chpasswd <<< 'root:@#TaylorSwift1989'
    sudo chpasswd <<< 'rocky:@#TaylorSwift1989'
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time "$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task")
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 4: Configure VNC users
task4_description="Configure VNC users"
log "Task 4: $task4_description..."
{
    echo "$task4_description"
    sudo echo ' :1=rocky\n :2=root' >> /etc/tigervnc/vncserver.users
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time "$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task")
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 5: Configure VNC server settings
task5_description="Configure VNC server settings"
log "Task 5: $task5_description..."
{
    echo "$task5_description"
    sudo echo ' geometry=3000x1650' >> /etc/tigervnc/vncserver-config-mandatory
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time "$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task")
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 6: Start VNC server for Rocky
task6_description="Start VNC server for Rocky"
log "Task 6: $task6_description..."
{
    echo "$task6_description"
    sudo systemctl start vncserver@:2.service
    sudo systemctl enable vncserver@:2.service
    sudo systemctl status vncserver@:2.service
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time("$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task"))
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 7: Start the firewall
task7_description="Start the firewall"
log "Task 7: $task7_description..."
{
    echo "$task7_description"
    sudo systemctl start firewalld
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time("$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task"))
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 8: Configure firewall rules
task8_description="Configure firewall rules"
log "Task 8: $task8_description..."
{
    echo "$task8_description"
    sudo firewall-cmd --zone=public --permanent --add-service=vnc-server
    sudo firewall-cmd --permanent --zone=public --add-service=cockpit
    sudo firewall-cmd --reload
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time("$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task"))
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 9: Create an RDP configuration file
task9_description="Create an RDP configuration file"
log "Task 9: $task9_description..."
{
    echo "$task9_description"

} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time("$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task"))
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 10: Enabling root login with ssh key
task10_description="Enabling root login with ssh key"
log "Task 10: $task10_description..."
{
    echo "$task10_description"
    sudo -u rocky cp ~/.ssh/authorized_keys /root/.ssh/
    chown -R root:root /root/.ssh
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time("$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task"))
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 11: Add more tasks here as needed
task11_description="Add more tasks here as needed"
log "Task 11: $task11_description..."
{
    echo "$task11_description"
    # Add your custom tasks here
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time("$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task"))
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"

# Task 12: Reboot the system
task12_description="Rebooting the system"
log "Task 12: $task12_description..."
{
    echo "$task12_description"
    time sudo reboot
} > >(while read -r line; do log "$line"; echo "$line"; done)
completed_tasks=$((completed_tasks + 1))
elapsed_time=$((elapsed_time + $(date +%s) - start_time))
estimated_time=$(calculate_estimated_time("$start_time" "$completed_tasks" "$total_tasks" "$average_time_per_task"))
show_progress "$completed_tasks" "$total_tasks" "$elapsed_time" "$estimated_time"
