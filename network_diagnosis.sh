#!/bin/bash

# Linux Sunucuda Ağ Bağlantı ve DNS Sorunlarını Tespit ve Çözüm Scripti
# Bu script, ağ bağlantılarını kontrol eder, DNS sorunlarını teşhis eder ve temel düzeltmeleri uygular.

# Ağ bağlantısını kontrol et
echo "Ağ bağlantısı test ediliyor..."
ping -c 4 8.8.8.8 &> /dev/null
if [[ $? -eq 0 ]]; then
    echo "İnternet bağlantısı aktif."
else
    echo "Bağlantı yok! Ağ ayarlarınızı kontrol edin."
fi

# Varsayılan ağ geçidini kontrol et
echo "Varsayılan ağ geçidi kontrol ediliyor..."
route -n | grep 'UG' | awk '{print $2}'

# DNS çözümlemesini test et
echo "DNS çözümleme test ediliyor..."
nslookup google.com &> /dev/null
if [[ $? -eq 0 ]]; then
    echo "DNS çalışıyor."
else
    echo "DNS çözümlenemiyor! Önbellek temizleniyor..."
    systemctl restart systemd-resolved
fi

# Ağ arayüzlerini listele
echo "Ağ adaptörleri ve IP adresleri kontrol ediliyor..."
ip -4 addr show | grep "inet"

echo "Ağ bağlantı analizi tamamlandı."
