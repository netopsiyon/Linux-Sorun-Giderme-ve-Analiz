#!/bin/bash

# Log ve Rapor Dosya Konumu
LOG_FILE="/var/log/backup.log"
REPORT_FILE="/tmp/backup_report.txt"
EMAIL_RECIPIENT="admin@example.com"
BACKUP_DIRS=("/home" "/etc" "/var/www")
BACKUP_DEST="/backup"
REMOTE_SERVER="user@remote-server:/backup"

# Log yazma fonksiyonu
write_log() {
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Rapor dosyasını temizle
> "$REPORT_FILE"

# Yedekleme işlemi başlatılıyor
write_log "Otomatik Yedekleme Başlatıldı..."
echo "### Yedekleme İşlemi ###" | tee -a "$REPORT_FILE"

# Yedekleme dizini kontrol et
if [ ! -d "$BACKUP_DEST" ]; then
    mkdir -p "$BACKUP_DEST"
    write_log "Yedekleme dizini oluşturuldu: $BACKUP_DEST"
fi

# Belirlenen dizinleri sıkıştır ve yedekle
for DIR in "${BACKUP_DIRS[@]}"; do
    ARCHIVE_NAME="$BACKUP_DEST/$(basename $DIR)_backup_$(date +%Y-%m-%d).tar.gz"
    tar -czf "$ARCHIVE_NAME" "$DIR"
    if [ $? -eq 0 ]; then
        write_log "$DIR başarıyla yedeklendi: $ARCHIVE_NAME"
        echo "$DIR başarıyla yedeklendi: $ARCHIVE_NAME" | tee -a "$REPORT_FILE"
    else
        write_log "Hata! $DIR yedeklenirken bir sorun oluştu."
        echo "Hata! $DIR yedeklenirken bir sorun oluştu." | tee -a "$REPORT_FILE"
    fi
done

# Uzak sunucuya yedek yükleme (rsync ile)
write_log "Yedekler uzak sunucuya kopyalanıyor..."
echo "### Uzak Sunucuya Yedekleme ###" | tee -a "$REPORT_FILE"
rsync -avz "$BACKUP_DEST" "$REMOTE_SERVER" &> /dev/null
if [ $? -eq 0 ]; then
    write_log "Yedekler başarıyla uzak sunucuya yüklendi."
    echo "Yedekler başarıyla uzak sunucuya yüklendi." | tee -a "$REPORT_FILE"
else
    write_log "Hata! Yedekler uzak sunucuya yüklenemedi."
    echo "Hata! Yedekler uzak sunucuya yüklenemedi." | tee -a "$REPORT_FILE"
fi

# Raporu E-posta ile Gönderme
echo "Yedekleme Raporu e-posta ile gönderiliyor..."
mail -s "Linux Otomatik Yedekleme Raporu - $(date "+%Y-%m-%d")" "$EMAIL_RECIPIENT" < "$REPORT_FILE"
write_log "Rapor e-posta ile gönderildi: $EMAIL_RECIPIENT"

write_log "Otomatik Yedekleme Tamamlandı."
exit 0
