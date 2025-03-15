#!/bin/bash

# Linux Sunucuda Log Analizi ve Güvenlik Açığı Tespiti Yapacak Script
# Bu script, sistem loglarını tarar, kritik hataları raporlar ve güvenlik açıklarını tespit eder.

# Syslog üzerinden kritik hataları tarama
echo "Sistem logları taranıyor..."
if [ -f "/var/log/syslog" ]; then
    grep -i "error\|fail\|critical" /var/log/syslog | tail -20
else
    journalctl -p 3 -n 20 --no-pager
fi

echo "\nAuth logları kontrol ediliyor..."
if [ -f "/var/log/auth.log" ]; then
    grep -i "failed password" /var/log/auth.log | tail -10
else
    journalctl -u ssh --no-pager -n 10 | grep -i "failed password"
fi

# Son başarısız SSH giriş denemelerini listeleme
echo "SSH başarısız giriş denemeleri kontrol ediliyor..."
if [ -f "/var/log/auth.log" ]; then
    awk '$9 == "Failed" && $11 == "from" {print $1, $2, $3, $13}' /var/log/auth.log | tail -10
else
    journalctl -u ssh --no-pager -n 10 | grep -i "Failed"
fi

# Güvenlik açığına sahip paketleri kontrol etme
echo "Potansiyel güvenlik açıkları içeren paketler kontrol ediliyor..."
apt list --upgradable 2>/dev/null | grep -i security

# Son başarılı kullanıcı girişlerini listeleme
echo "Son başarılı kullanıcı girişleri kontrol ediliyor..."
last -a | head -10

echo "Log analizi ve güvenlik denetimi tamamlandı."
