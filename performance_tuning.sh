#!/bin/bash

# Linux Performans Optimizasyon Scripti
# Bu script, CPU ve RAM kullanımını optimize eder, gereksiz servisleri kontrol eder ve önbelleği temizler.

# Log ve Rapor Dosya Konumu
LOG_FILE="/var/log/performance_tuning.log"
REPORT_FILE="/tmp/performance_tuning_report.txt"
EMAIL_RECIPIENT="admin@example.com"

# Log yazma fonksiyonu
write_log() {
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Rapor dosyasını temizle
> "$REPORT_FILE"

write_log "Performans optimizasyonu başlatıldı..."
echo "### Performans Optimizasyonu ###" | tee -a "$REPORT_FILE"

# CPU Kullanımı Kontrolü
write_log "CPU kullanımı kontrol ediliyor..."
echo "CPU Kullanımı:" | tee -a "$REPORT_FILE"
top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "% Kullanım"}' | tee -a "$REPORT_FILE"

# RAM Kullanımı Kontrolü
write_log "RAM kullanımı kontrol ediliyor..."
echo "RAM Kullanımı:" | tee -a "$REPORT_FILE"
free -h | grep Mem | awk '{print "Toplam: "$2" Kullanılan: "$3" Boş: "$4}' | tee -a "$REPORT_FILE"

# Önbellek Temizleme
write_log "Önbellek temizleniyor..."
echo "Önbellek temizleniyor..." | tee -a "$REPORT_FILE"
sync; echo 3 > /proc/sys/vm/drop_caches
write_log "Önbellek temizlendi."

echo "Gereksiz servisler kontrol ediliyor..." | tee -a "$REPORT_FILE"
write_log "Gereksiz servisler kontrol ediliyor..."
SERVICES=("bluetooth" "cups")
for SERVICE in "${SERVICES[@]}"; do
    systemctl is-active --quiet $SERVICE && echo "$SERVICE çalışıyor, kapatılıyor..." | tee -a "$REPORT_FILE" && systemctl stop $SERVICE && write_log "$SERVICE durduruldu."
done

# Raporu E-posta ile Gönderme
echo "Performans Optimizasyon Raporu e-posta ile gönderiliyor..."
mail -s "Linux Performans Optimizasyon Raporu - $(date "+%Y-%m-%d")" "$EMAIL_RECIPIENT" < "$REPORT_FILE"
write_log "Rapor e-posta ile gönderildi: $EMAIL_RECIPIENT"

write_log "Performans optimizasyonu tamamlandı."
exit 0
