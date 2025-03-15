#!/bin/bash

# Log ve Rapor Dosya Konumu
LOG_FILE="/var/log/log_cleanup.log"
REPORT_FILE="/tmp/log_cleanup_report.txt"
EMAIL_RECIPIENT="admin@example.com"
LOG_DIR="/var/log"
DAYS_OLD=30
ARCHIVE_DIR="/var/log/archive"

# Log yazma fonksiyonu
write_log() {
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Rapor dosyasını temizle
> "$REPORT_FILE"

# Log temizleme işlemi başlatılıyor
write_log "Log Temizleme Başlatıldı..."
echo "### Log Temizleme İşlemi ###" | tee -a "$REPORT_FILE"

# Arşiv dizinini oluştur
if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir -p "$ARCHIVE_DIR"
    write_log "Arşiv dizini oluşturuldu: $ARCHIVE_DIR"
fi

# Eski logları arşivle
write_log "$DAYS_OLD günden eski loglar arşivleniyor..."
find "$LOG_DIR" -type f -name "*.log" -mtime +$DAYS_OLD -exec gzip {} \;
find "$LOG_DIR" -type f -name "*.log.gz" -mtime +$DAYS_OLD -exec mv {} "$ARCHIVE_DIR" \;
write_log "Eski loglar arşivlendi."

# Büyük log dosyalarını temizleme
write_log "500MB'den büyük log dosyaları inceleniyor..."
find "$LOG_DIR" -type f -name "*.log" -size +500M | tee -a "$REPORT_FILE"
find "$LOG_DIR" -type f -name "*.log" -size +500M -exec truncate -s 0 {} \;
write_log "Büyük log dosyaları sıfırlandı."

# Raporu E-posta ile Gönderme
echo "Log Temizleme Raporu e-posta ile gönderiliyor..."
mail -s "Linux Log Temizleme Raporu - $(date "+%Y-%m-%d")" "$EMAIL_RECIPIENT" < "$REPORT_FILE"
write_log "Rapor e-posta ile gönderildi: $EMAIL_RECIPIENT"

write_log "Log Temizleme İşlemi Tamamlandı."
exit 0
