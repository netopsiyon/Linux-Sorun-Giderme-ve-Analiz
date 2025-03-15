#!/bin/bash

# Linux Sunucuda Disk Dolu Problemini Çözme Scripti
# Bu script, disk kullanımını analiz eder ve gereksiz büyük dosyaları temizler.

# Disk kullanım eşiği (yüzde)
THRESHOLD=90

# Disk kullanımını kontrol et
echo "Disk kullanım analizi yapılıyor..."
df -h | grep '^/dev/'

# Dolu olan disk bölümlerini tespit et
disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if (( disk_usage > THRESHOLD )); then
    echo "Uyarı: Disk doluluk oranı $disk_usage%. Gereksiz dosyaları temizlemeniz önerilir."
else
    echo "Disk kullanım oranı $disk_usage%, şu anda müdahale gerekmiyor."
fi

# Büyük dosyaları listeleme
echo "En büyük 10 dosya bulunuyor..."
find / -type f -size +100M -exec du -h {} + 2>/dev/null | sort -rh | head -10

echo "\nBüyük boyutlu log dosyalarını temizlemek ister misiniz? (E/H)"
read user_input
if [[ "$user_input" == "E" || "$user_input" == "e" ]]; then
    find /var/log -type f -name "*.log" -size +50M -exec truncate -s 0 {} \;
    echo "Büyük log dosyaları temizlendi."
else
    echo "Log dosyaları temizlenmedi."
fi

# Gereksiz önbellek temizliği
echo "Önbellek temizleniyor..."
apt-get clean && rm -rf /var/cache/apt/archives/*.deb

echo "Disk temizleme işlemi tamamlandı."
