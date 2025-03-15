#!/bin/bash

# Linux Sunucuda Güncellemeleri ve Güvenlik Kontrollerini Otomatik Yapan Script
# Bu script, sistem güncellemelerini kontrol eder, güvenlik yamalarını uygular ve eski paketleri temizler.

# Güncellemeleri kontrol et ve uygula
echo "Sistem güncellemeleri kontrol ediliyor..."
apt-get update && apt-get upgrade -y
if [[ $? -eq 0 ]]; then
    echo "Sistem başarıyla güncellendi."
else
    echo "Güncelleme sırasında hata oluştu!"
fi

# Kernel güncellemelerini kontrol et
echo "Kernel güncellemeleri kontrol ediliyor..."
apt-get dist-upgrade -y

# Gereksiz eski paketleri kaldır
echo "Eski ve gereksiz paketler temizleniyor..."
autoremove_output=$(apt-get autoremove -y)
if [[ -n "$autoremove_output" ]]; then
    echo "Gereksiz paketler kaldırıldı."
else
    echo "Kaldırılacak gereksiz paket bulunamadı."
fi

# Güvenlik yamalarını uygula
echo "Güvenlik yamaları yükleniyor..."
apt-get install unattended-upgrades -y
unattended-upgrades --dry-run

echo "Sistem güncelleme ve güvenlik kontrolü tamamlandı."
