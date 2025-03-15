#!/bin/bash

# Log dosyası konumu
LOG_FILE="/var/log/script_log.log"
EMAIL_RECIPIENT="email@domain.com"

# Log yazma fonksiyonu
write_log() {
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - $1" >> "$LOG_FILE"
}

# E-posta gönderme fonksiyonu
email_gonder() {
    SUBJECT="Sistem Raporu: $(date "+%Y-%m-%d")"
    cat "$LOG_FILE" | mail -s "$SUBJECT" "$EMAIL_RECIPIENT"
    write_log "Log dosyası e-posta ile gönderildi: $EMAIL_RECIPIENT"
}

# Log kaydını başlat
write_log "Sistem Güncelleme ve Güvenlik Kontrolü Başlatıldı."
echo "Sistem Güncelleme ve Güvenlik Kontrolü Başlatıldı..."

# Sistem Güncellemelerini Kontrol Et
write_log "Paket yöneticisi güncelleniyor..."
echo "Paket yöneticisi güncelleniyor..."
apt-get update -y && apt-get upgrade -y
if [[ $? -eq 0 ]]; then
    write_log "Sistem başarıyla güncellendi."
else
    write_log "Güncelleme sırasında hata oluştu!"
fi

# Kernel güncellemelerini kontrol et
write_log "Kernel güncellemeleri kontrol ediliyor."
apt-get dist-upgrade -y

# Eski ve gereksiz paketleri kaldır
write_log "Eski ve gereksiz paketler temizleniyor..."
autoremove_output=$(apt-get autoremove -y)
if [[ -n "$autoremove_output" ]]; then
    write_log "Gereksiz paketler kaldırıldı."\else
    write_log "Kaldırılacak gereksiz paket bulunamadı."
fi

# CPU Kullanımını Kontrol Et
write_log "CPU Kullanımı Analiz Ediliyor..."
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    write_log "Uyarı: CPU Kullanımı yüksek! ($CPU_USAGE%)"
else
    write_log "CPU Kullanımı normal seviyede: $CPU_USAGE%"
fi

# RAM Kullanımını Kontrol Et
write_log "RAM Kullanımı Analiz Ediliyor..."
RAM_USAGE=$(free | awk '/Mem:/ {print $3/$2 * 100.0}')
if (( $(echo "$RAM_USAGE > 80" | bc -l) )); then
    write_log "Uyarı: RAM Kullanımı yüksek! ($RAM_USAGE%)"
else
    write_log "RAM Kullanımı normal seviyede: $RAM_USAGE%"
fi

# Disk Kullanımını Kontrol Et
write_log "Disk Kullanımı Analiz Ediliyor..."
df -h | awk '$6 == "/" {print "Root Disk Kullanımı: "$5}' | while read line; do
    write_log "$line"
done

write_log "Sistem Analizi Tamamlandı."
echo "Sistem Analizi Tamamlandı."

# Logları e-posta ile gönder
write_log "E-posta gönderme işlemi başlatıldı..."
email_gonder

exit 0
