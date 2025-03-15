#!/bin/bash

# Log ve Rapor Dosya Konumu
LOG_FILE="/var/log/firewall_audit.log"
REPORT_FILE="/tmp/firewall_audit_report.txt"
EMAIL_RECIPIENT="admin@example.com"

# Log yazma fonksiyonu
write_log() {
    local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$TIMESTAMP - $1" | tee -a "$LOG_FILE"
}

# Rapor dosyasını temizle
> "$REPORT_FILE"

# Firewall Durumu Kontrolü
write_log "Firewall Durumu Kontrol Ediliyor..."
echo "### Firewall Durumu ###" | tee -a "$REPORT_FILE"
if command -v ufw &> /dev/null; then
    UFW_STATUS=$(ufw status | grep "Status")
    echo "$UFW_STATUS" | tee -a "$REPORT_FILE"
elif command -v iptables &> /dev/null; then
    IPTABLES_RULES=$(iptables -L)
    echo "$IPTABLES_RULES" | tee -a "$REPORT_FILE"
else
    echo "UFW veya iptables bulunamadı!" | tee -a "$REPORT_FILE"
fi

# Açık Portları Listeleme
write_log "Açık Portlar Kontrol Ediliyor..."
echo "### Açık Portlar ###" | tee -a "$REPORT_FILE"
nmap -p- localhost | grep open | tee -a "$REPORT_FILE"

# Varsayılan Politikaları Kontrol Etme
write_log "Varsayılan Politikalar Kontrol Ediliyor..."
echo "### Varsayılan Politikalar ###" | tee -a "$REPORT_FILE"
if command -v ufw &> /dev/null; then
    UFW_DEFAULT=$(ufw show raw)
    echo "$UFW_DEFAULT" | tee -a "$REPORT_FILE"
elif command -v iptables &> /dev/null; then
    IPTABLES_POLICY=$(iptables -S)
    echo "$IPTABLES_POLICY" | tee -a "$REPORT_FILE"
fi

# Firewall Loglarını Analiz Etme
write_log "Firewall Logları Analiz Ediliyor..."
echo "### Firewall Logları ###" | tee -a "$REPORT_FILE"
if [ -f "/var/log/syslog" ]; then
    tail -n 50 /var/log/syslog | grep -i "ufw" | tee -a "$REPORT_FILE"
else
    journalctl -u ufw --no-pager -n 50 | tee -a "$REPORT_FILE"
fi

# Raporu E-posta ile Gönderme
echo "Firewall Denetim Raporu e-posta ile gönderiliyor..."
mail -s "Linux Firewall Denetim Raporu - $(date "+%Y-%m-%d")" "$EMAIL_RECIPIENT" < "$REPORT_FILE"
write_log "Rapor e-posta ile gönderildi: $EMAIL_RECIPIENT"

write_log "Firewall Denetimi Tamamlandı."
exit 0
