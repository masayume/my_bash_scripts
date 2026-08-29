#!/bin/bash


set -uo pipefail

#########################################
# Configuration
#########################################

DEVICE="/dev/sda2"
MOUNTPOINT="/media/$USER/external"
LOGDIR="$HOME/log"
LOGFILE="$LOGDIR/external_hdd_backup_$(date +%F_%H-%M-%S).log"

BACKUPS=(
"$HOME/DATA/E/INSPIRE|$MOUNTPOINT/BACKUP/E/INSPIRE"
"$HOME/DATA/E/LOCALE|$MOUNTPOINT/BACKUP/E/LOCALE"
"$HOME/DATA/E/VIRTUALBOXES|$MOUNTPOINT/BACKUP/E/VIRTUALBOXES"
"$HOME/INFO|$MOUNTPOINT/BACKUP/HOME/"
)

#########################################

mkdir -p "$LOGDIR"

# check if mounted


log() {
    echo "[$(date '+%F %T')] $*" | tee -a "$LOGFILE"
}

fail() {
    log "ERROR: $*"
    exit 1
}

#########################################
# Preliminary checks
#########################################

log "===================================="
log "Backup started"

command -v rsync >/dev/null || fail "rsync not installed"
command -v mount >/dev/null || fail "mount not found"
command -v findmnt >/dev/null || fail "findmnt not found"

[[ -b "$DEVICE" ]] || fail "$DEVICE does not exist"

sudo mkdir -p "$MOUNTPOINT" || fail "Cannot create mountpoint"

#########################################
# Mount drive
#########################################

if findmnt -rn "$MOUNTPOINT" >/dev/null; then
    log "Drive already mounted"
else
    log "Mounting $DEVICE"

    sudo mount "$DEVICE" "$MOUNTPOINT" \
        || fail "Mount failed"
fi

findmnt "$MOUNTPOINT" >/dev/null \
    || fail "Mount verification failed"


#########################################
# Check destination
#########################################

touch "$MOUNTPOINT/.backup_test" \
    || fail "Destination is not writable"

rm "$MOUNTPOINT/.backup_test"

#########################################
# Compute required space
#########################################

required=0

for pair in "${BACKUPS[@]}"
do
    SRC="${pair%%|*}"

    [[ -d "$SRC" ]] || fail "Missing source directory $SRC"

    size=$(du -sb "$SRC" | awk '{print $1}')
    required=$((required + size))
done

available=$(df --output=avail -B1 "$MOUNTPOINT" | tail -1)

log "Required bytes : $required"
log "Available bytes: $available"

if (( available < required )); then
    fail "Not enough free space"
fi


#########################################
# Backup
#########################################

for pair in "${BACKUPS[@]}"
do
    SRC="${pair%%|*}"
    DEST="${pair##*|}"

    mkdir -p "$DEST" \
        || fail "Cannot create $DEST"

    log "Backing up $SRC"

    rsync \
        -a \
        -v \
        --delete \
        --stats \
        --human-readable \
        "$SRC/" \
        "$DEST/" \
        >>"$LOGFILE" 2>&1

    rc=$?

    if [[ $rc -ne 0 ]]; then
        fail "rsync failed for $SRC (exit code $rc)"
    fi

    log "Completed $SRC"

done

#########################################

#########################################
# Flush buffers
#########################################

sync

#########################################
# Unmount
#########################################

log "Unmounting"

sudo umount "$MOUNTPOINT" \
    || fail "Cannot unmount"

log "Backup completed successfully"
log "===================================="

exit 0