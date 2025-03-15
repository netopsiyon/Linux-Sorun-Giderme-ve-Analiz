#!/bin/bash

# Linux Sunucuda SSH Erişim Sorunlarını Tespit ve Çözüm Scripti
# Bu script, SSH bağlantısını kontrol eder, yaygın hataları teşhis eder ve düzeltme işlemlerini uygular.

# SSH servisini kontrol et
echo "SSH servisi kontrol ediliyor..."
systemctl is-active --quiet sshd
if [[ $? -eq 0 ]]; then
    echo "SSH servisi çalışıyor."
else
    echo "SSH servisi durdurulmuş! Servisi yeniden başlatıyoruz..."
    systemctl start sshd && echo "SSH servisi başlatıldı."
fi

# SSH bağlantı noktasını kontrol et
echo "SSH bağlantı noktası kontrol ediliyor..."
ss -tln | grep ':22'
if [[ $? -ne 0 ]]; then
    echo "Uyarı: SSH bağlantı noktası açık değil! 22 numaralı portu açıyoruz..."
    firewall-cmd --add-port=22/tcp --permanent
    firewall-cmd --reload
fi

# SSH güvenlik ayarlarını kontrol et
echo "SSH güvenlik ayarları inceleniyor..."
if grep -q "PermitRootLogin no" /etc/ssh/sshd_config; then
    echo "Root kullanıcı girişi devre dışı. Güvenlik açısından uygundur."
else
    echo "Uyarı: Root girişi etkin! Güvenlik için devre dışı bırakmanız önerilir."
fi

# SSH yapılandırma dosyasını kontrol et
echo "SSH yapılandırması kontrol ediliyor..."
sshd -t &> /dev/null
if [[ $? -eq 0 ]]; then
    echo "SSH yapılandırması hatasız."
else
    echo "Hata: SSH yapılandırmasında sorun var! Lütfen /etc/ssh/sshd_config dosyanızı kontrol edin."
fi

echo "SSH bağlantı analizi tamamlandı."
