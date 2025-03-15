#!/bin/bash

# Log ve Rapor Dosya Konumu
LOG_FILE="/var/log/system_health.log"
REPORT_FILE="/tmp/system_health_report.txt"
EMAIL_RECIPIENT="admin@example.com"

# Log yazma fonksiyonu
write_log() {
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Rapor dosyasını temizle
> "$REPORT_FILE"

# CPU Kullanımı Kontrolü
write_log "CPU Kullanımı Analiz Ediliyor..."
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
echo "CPU Kullanımı: $CPU_USAGE%" | tee -a "$REPORT_FILE"

# RAM Kullanımı Kontrolü
write_log "RAM Kullanımı Analiz Ediliyor..."
RAM_USAGE=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
echo "RAM Kullanımı: $RAM_USAGE%" | tee -a "$REPORT_FILE"

# Disk Kullanımı Kontrolü
write_log "Disk Kullanımı Analiz Ediliyor..."
df -h | awk '$6 == "/" {print "Root Disk Kullanımı: "$5}' | tee -a "$REPORT_FILE"

# Ağ Bağlantısı Kontrolü
write_log "Ağ Bağlantısı Test Ediliyor..."
ping -c 4 8.8.8.8 &> /dev/null && echo "Ağ Bağlantısı: Çalışıyor" || echo "Ağ Bağlantısı: HATA - İnternet Yok" | tee -a "$REPORT_FILE"

# Çalışan Servislerin Kontrolü
write_log "Önemli Servislerin Durumu Kontrol Ediliyor..."
SERVICES=("nginx" "apache2" "mysql" "sshd")
for SERVICE in "${SERVICES[@]}"; do
    systemctl is-active --quiet $SERVICE && echo "$SERVICE: Çalışıyor" || echo "$SERVICE: Çalışmıyor" | tee -a "$REPORT_FILE"
done

# Güncellemeleri Kontrol Et
write_log "Güncellemeler Kontrol Ediliyor..."
apt-get update -y &> /dev/null
UPDATES=$(apt list --upgradable 2>/dev/null | wc -l)
echo "Yüklenebilir Güncellemeler: $UPDATES" | tee -a "$REPORT_FILE"

# Raporu E-posta ile Gönderme
echo "Sistem Sağlık Raporu e-posta ile gönderiliyor..."
mail -s "Linux Sistem Sağlık Raporu - $(date "+%Y-%m-%d")" "$EMAIL_RECIPIENT" < "$REPORT_FILE"
write_log "Rapor e-posta ile gönderildi: $EMAIL_RECIPIENT"

write_log "Sistem Sağlık Analizi Tamamlandı."
exit 0
