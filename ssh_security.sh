#!/bin/bash

# Log ve Rapor Dosya Konumu
LOG_FILE="/var/log/ssh_security.log"
REPORT_FILE="/tmp/ssh_security_report.txt"
EMAIL_RECIPIENT="admin@example.com"

# Log yazma fonksiyonu
write_log() {
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Rapor dosyasını temizle
> "$REPORT_FILE"

# SSH Konfigürasyon Kontrolleri
write_log "SSH Konfigürasyonu Kontrol Ediliyor..."
echo "### SSH Konfigürasyon Ayarları ###" | tee -a "$REPORT_FILE"
grep -E "^PermitRootLogin|^PasswordAuthentication|^AllowUsers" /etc/ssh/sshd_config | tee -a "$REPORT_FILE"

# SSH Brute-Force Girişimleri Kontrolü
write_log "SSH Brute-Force Girişimleri Analiz Ediliyor..."
echo "### SSH Başarısız Giriş Denemeleri ###" | tee -a "$REPORT_FILE"
awk '($3 == "Failed" && $6 == "invalid") {print $1, $2, $3, $11}' /var/log/auth.log | sort | uniq -c | sort -nr | head -10 | tee -a "$REPORT_FILE"

# Şüpheli IP'leri Engelleme
write_log "Şüpheli IP'ler Analiz Ediliyor..."
echo "### Şüpheli IP'ler ###" | tee -a "$REPORT_FILE"
awk '($3 == "Failed" && $6 == "invalid") {print $11}' /var/log/auth.log | sort | uniq -c | sort -nr | head -10 | awk '{print $2}' | while read IP; do
    echo "Engellenen IP: $IP" | tee -a "$REPORT_FILE"
    sudo ufw deny from "$IP"
done

# SSH Servisinin Durumu
write_log "SSH Servisi Kontrol Ediliyor..."
echo "### SSH Servis Durumu ###" | tee -a "$REPORT_FILE"
systemctl status ssh | grep "Active:" | tee -a "$REPORT_FILE"

# Raporu E-posta ile Gönderme
echo "SSH Güvenlik Raporu e-posta ile gönderiliyor..."
mail -s "Linux SSH Güvenlik Raporu - $(date "+%Y-%m-%d")" "$EMAIL_RECIPIENT" < "$REPORT_FILE"
write_log "Rapor e-posta ile gönderildi: $EMAIL_RECIPIENT"

write_log "SSH Güvenlik Analizi Tamamlandı."
exit 0
