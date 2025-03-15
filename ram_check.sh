#!/bin/bash

# Linux Sunucuda Yüksek RAM Kullanımını Tespit ve Çözüm Scripti
# Bu script, bellek kullanımını analiz eder, yüksek RAM tüketen işlemleri tespit eder ve isteğe bağlı olarak sonlandırır.

# RAM kullanım eşiği (MB)
THRESHOLD=500

# RAM kullanımını listele
echo "Yüksek RAM kullanımı analiz ediliyor..."
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -10

echo "\nYüksek RAM tüketen işlemler kontrol ediliyor..."

top_process=$(ps -eo pid,%mem --sort=-%mem | awk -v threshold=$THRESHOLD '$2 > threshold {print $1}' | head -1)

if [[ -n "$top_process" ]]; then
    echo "Uyarı: PID $top_process çok fazla RAM tüketiyor."
    echo "Bu işlemi sonlandırmak ister misiniz? (E/H)"
    read user_input
    if [[ "$user_input" == "E" || "$user_input" == "e" ]]; then
        kill -9 $top_process
        echo "İşlem $top_process sonlandırıldı."
    else
        echo "İşlem çalışmaya devam edecek."
    fi
else
    echo "Şu anda yüksek RAM tüketen bir işlem bulunmuyor."
fi

# Boş bellek miktarını kontrol etme
free_mem=$(free -m | awk '/Mem:/ {print $4}')

echo "Boş RAM miktarı: $free_mem MB"
if (( free_mem < 200 )); then
    echo "Uyarı: Bellek düşük! Gereksiz işlemleri sonlandırmanız önerilir."
fi

# Cache temizleme işlemi
echo "Bellek önbelleği temizleniyor..."
sync; echo 3 > /proc/sys/vm/drop_caches

echo "RAM analizi ve optimizasyon işlemi tamamlandı."
