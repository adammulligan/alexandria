# Set the working application directory
working_directory "/var/www/alexandria/current"

# Unicorn PID file location
pid "/var/www/alexandria/current/tmp/pids/unicorn.pid"

# Path to logs
stderr_path "/var/www/alexandria/current/log/unicorn.log"
stdout_path "/var/www/alexandria/current/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.alexandria.sock"

# Number of processes
worker_processes 2

# Time-out
timeout 30
