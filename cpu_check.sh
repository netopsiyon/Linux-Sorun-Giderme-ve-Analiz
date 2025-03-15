#!/bin/bash

# Linux Sunucuda Yüksek CPU Kullanımını Tespit ve Çözüm Scripti
# Bu script, yüksek CPU tüketen süreçleri tespit eder ve belirlenen eşik değeri aşanları sonlandırır.

# CPU kullanım eşiği (yüzde)
THRESHOLD=80

# CPU kullanımı yüksek olan işlemleri listele
echo "Yüksek CPU kullanımı analiz ediliyor..."
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -10

echo "\nYüksek CPU kullanımına neden olan işlemler kontrol ediliyor..."

top_process=$(ps -eo pid,%cpu --sort=-%cpu | awk -v threshold=$THRESHOLD '$2 > threshold {print $1}' | head -1)

if [[ -n "$top_process" ]]; then
    echo "Uyarı: PID $top_process çok fazla CPU tüketiyor."
    echo "Bu işlemi sonlandırmak ister misiniz? (E/H)"
    read user_input
    if [[ "$user_input" == "E" || "$user_input" == "e" ]]; then
        kill -9 $top_process
        echo "İşlem $top_process sonlandırıldı."
    else
        echo "İşlem çalışmaya devam edecek."
    fi
else
    echo "Şu anda yüksek CPU tüketen bir işlem bulunmuyor."
fi

# Sistem genel CPU yükünü kontrol etme
load_avg=$(uptime | awk -F 'load average:' '{print $2}' | cut -d, -f1 | xargs)

if (( $(echo "$load_avg > 2.0" | bc -l) )); then
    echo "Uyarı: Sistem yükü yüksek ($load_avg). Gerekli optimizasyonları yapmalısınız."
fi

# Gereksiz süreçleri temizleme
echo "Gereksiz süreçler ve zombie işlemler kontrol ediliyor..."
ps aux | awk '{if ($8 == "Z") print $2}' | while read zombie_pid; do
    if [[ -n "$zombie_pid" ]]; then
        echo "Zombie işlem $zombie_pid sonlandırılıyor..."
        kill -9 $zombie_pid
    fi
done

echo "CPU analizi ve optimizasyon işlemi tamamlandı."
