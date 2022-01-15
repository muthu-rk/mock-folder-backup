
# General info:
1. create-log-files.sh creates a 1 KB temporary file (in ./logpath folder) for every 1 second.
2. backup-logs.sh runs in a loop for every 30 sec (to simulate cron job) and copies contents of ./logpath to ./bkppath (using cp, not rsync). It uses bkp_status.txt to capture the state of last run. This helps in resuming any failed copies.

# Steps to run:
1. Create ./logpath and ./bkppath
2. Make both scripts as executable. chmod +x filename
3. Open a terminal window and run ./create-log-files.sh to start creating log files.
4. Open another terminal window and run ./backup-logs.sh to initiate backup files.
