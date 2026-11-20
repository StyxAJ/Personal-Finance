#!/bin/bash
# backup.sh: save the finance database to a dated file

TODAY=$(date +%Y-%m-%d)
mkdir -p backups

if pg_dump -U arsha -d finance -f "backups/finance_$TODAY.sql"; then
    echo "Backup saved: backups/finance_$TODAY.sql"
else
    echo "Backup FAILED"
fi