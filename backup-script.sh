#!/bin/sh

DB_HOST=${DB_HOST:-mysql}
DB_PORT=${DB_PORT:-3306}
DB_USERNAME=${DB_USERNAME:-root}
DB_PASSWORD=${DB_PASSWORD:-rootpassword}
DB_DATABASE=${DB_DATABASE:-locatto}
BACKUP_INTERVAL=${BACKUP_INTERVAL:-900} 
BACKUP_DIR="/backups"
BACKUP_RETENTION_DAYS=7

mkdir -p $BACKUP_DIR

create_backup() {
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/${DB_DATABASE}_backup_$TIMESTAMP.sql"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Creating backup: $BACKUP_FILE"
    
    mysqldump -h$DB_HOST -P$DB_PORT -u$DB_USERNAME -p$DB_PASSWORD \
        --single-transaction \
        --routines \
        --triggers \
        --events \
        --add-drop-database \
        --databases $DB_DATABASE > $BACKUP_FILE
    
    if [ $? -eq 0 ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup completed successfully: $BACKUP_FILE"
        
        gzip $BACKUP_FILE
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup compressed: ${BACKUP_FILE}.gz"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup failed!"
        rm -f $BACKUP_FILE
    fi
}

cleanup_old_backups() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Cleaning up backups older than $BACKUP_RETENTION_DAYS days"
    find $BACKUP_DIR -name "${DB_DATABASE}_backup_*.sql.gz" -type f -mtime +$BACKUP_RETENTION_DAYS -delete
    
    BACKUP_COUNT=$(find $BACKUP_DIR -name "${DB_DATABASE}_backup_*.sql.gz" -type f | wc -l)
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Total backups: $BACKUP_COUNT"
}

echo "$(date '+%Y-%m-%d %H:%M:%S') - Waiting for database to be ready..."
while ! mysqladmin ping -h$DB_HOST -P$DB_PORT -u$DB_USERNAME -p$DB_PASSWORD --silent; do
    sleep 2
done
echo "$(date '+%Y-%m-%d %H:%M:%S') - Database is ready, starting backup service"

create_backup
cleanup_old_backups

while true; do
    sleep $BACKUP_INTERVAL
    create_backup
    cleanup_old_backups
done 