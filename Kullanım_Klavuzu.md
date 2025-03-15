Bu dökümantasyon, **Linux sunucularında yaygın sistem sorunlarını** tespit eden ve çözen orijinal scriptlerin açıklamalarını içermektedir. Her scriptin amacı, kullanımı ve teknik detayları aşağıda verilmiştir. Sorularınız veya geliştirme önerileriniz varsa **GitHub issue açarak** katkıda bulunabilirsiniz!

## 📌 İçindekiler

1. [Kurulum ve Çalıştırma](#kurulum-ve-çalıştırma)
2. [Script Açıklamaları](#script-açıklamaları)
   - [CPU Kullanımı Kontrolü (`cpu_check.sh`)](#cpu-kullanımı-kontrolü-cpu_checksh)
   - [RAM Kullanımı ve Optimizasyon (`ram_check.sh`)](#ram-kullanımı-ve-optimizasyon-ram_checksh)
   - [Disk Temizleme (`disk_cleanup.sh`)](#disk-temizleme-disk_cleanupsh)
   - [Ağ Sorunları Teşhisi (`network_diagnosis.sh`)](#ağ-sorunları-teşhisi-network_diagnosissh)
   - [SSH Sorun Giderme (`ssh_fix.sh`)](#ssh-sorun-giderme-ssh_fixsh)
   - [Güvenlik Güncellemeleri (`update_security.sh`)](#güvenlik-güncellemeleri-update_securitysh)
   - [Log Analizi ve Güvenlik (`log_security_check.sh`)](#log-analizi-ve-güvenlik-log_security_checksh)
   - [Firewall Denetimi (`linux_firewall_audit.sh`)](#firewall-denetimi-linux_firewall_auditsh)
   - [Otomatik Yedekleme (`backup_script.sh`)](#otomatik-yedekleme-backup_scriptsh)
   - [Performans Optimizasyonu (`performance_tuning.sh`)](#performans-optimizasyonu-performance_tuningsh)
   - [Sistem Log Analizi (`log.sh`)](#sistem-log-analizi-logsh)
   - [Log Temizleme (`log_cleanup.sh`)](#log-temizleme-log_cleanupsh)
   - [SSH Güvenlik Denetimi (`ssh_security.sh`)](#ssh-güvenlik-denetimi-ssh_securitysh)
   - [Sistem Sağlık Kontrolü (`linux_system_health.sh`)](#sistem-sağlık-kontrolü-linux_system_healthsh)
3. [Hata Ayıklama ve Log İnceleme](#hata-ayıklama-ve-log-i̇nceleme)

---

## 🔹Kurulum ve Çalıştırma

Scriptleri çalıştırmadan önce **çalıştırılabilir izinleri** vermelisiniz:

```bash
chmod +x script_adi.sh
```

Ardından şu komutla çalıştırabilirsiniz:

```bash
./script_adi.sh
```

Bazı scriptler için **root yetkisi gerekebilir**. Eğer yetki hatası alırsanız:

```bash
sudo ./script_adi.sh
```

---

## 🔹Script Açıklamaları

### **CPU Kullanımı Kontrolü (`cpu_check.sh`)**
✅ **Yüksek CPU tüketen işlemleri tespit eder.**  
✅ **Belirtilen eşiği aşan işlemleri kullanıcıya sorarak sonlandırabilir.**  

📌 **Kullanım:**
```bash
./cpu_check.sh
```

---

### **RAM Kullanımı ve Optimizasyon (`ram_check.sh`)**
✅ **Sistemdeki RAM kullanımını analiz eder.**  
✅ **Önbellek temizleme işlemini gerçekleştirir.**  

📌 **Kullanım:**
```bash
./ram_check.sh
```

---

### **Disk Temizleme (`disk_cleanup.sh`)**
✅ **Disk kullanım oranlarını kontrol eder.**  
✅ **Büyük dosyaları listeleyerek temizleme seçeneği sunar.**  

📌 **Kullanım:**
```bash
./disk_cleanup.sh
```

---

### **Ağ Sorunları Teşhisi (`network_diagnosis.sh`)**
✅ **İnternet bağlantısını ve DNS çözümlemeyi test eder.**  
✅ **Varsayılan ağ geçidini kontrol eder.**  

📌 **Kullanım:**
```bash
./network_diagnosis.sh
```

---

### **SSH Sorun Giderme (`ssh_fix.sh`)**
✅ **SSH bağlantısının çalışıp çalışmadığını test eder.**  
✅ **SSH servisini yeniden başlatma ve port kontrolü yapar.**  

📌 **Kullanım:**
```bash
./ssh_fix.sh
```

---

### **Güvenlik Güncellemeleri (`update_security.sh`)**
✅ **Sistem güncellemelerini otomatik olarak yapar.**  
✅ **Kernel ve güvenlik yamalarını kontrol eder.**  

📌 **Kullanım:**
```bash
./update_security.sh
```

---

### **Log Analizi ve Güvenlik (`log_security_check.sh`)**
✅ **Sistem loglarını tarar ve kritik hataları listeler.**  
✅ **SSH başarısız giriş denemelerini analiz eder.**  

📌 **Kullanım:**
```bash
./log_security_check.sh
```

---

### **Firewall Denetimi (`linux_firewall_audit.sh`)**
✅ **UFW veya iptables güvenlik ayarlarını kontrol eder.**  
✅ **Açık portları listeler ve güvenlik analizi yapar.**  

📌 **Kullanım:**
```bash
./linux_firewall_audit.sh
```

---

### **Otomatik Yedekleme (`backup_script.sh`)**
✅ **Belirtilen dizinleri sıkıştırarak yedekler.**  
✅ **Uzak sunucuya yedekleri aktarır.**  

📌 **Kullanım:**
```bash
./backup_script.sh
```

---

### **Performans Optimizasyonu (`performance_tuning.sh`)**
✅ **Sistem performansını artırmak için önbellek temizleme işlemleri yapar.**  
✅ **CPU ve RAM kullanımını optimize eder.**  

📌 **Kullanım:**
```bash
./performance_tuning.sh
```

---

### **Sistem Log Analizi (`log.sh`)**
✅ **Sistem loglarını detaylı olarak analiz eder.**  
✅ **Kritik hataları ve uyarıları listeler.**  

📌 **Kullanım:**
```bash
./log.sh
```

---

### **Log Temizleme (`log_cleanup.sh`)**
✅ **Eski ve büyük log dosyalarını temizler.**  
✅ **Logları sıkıştırarak arşivler.**  

📌 **Kullanım:**
```bash
./log_cleanup.sh
```

---

### **SSH Güvenlik Denetimi (`ssh_security.sh`)**
✅ **SSH yapılandırmasını kontrol eder ve güvenlik risklerini tespit eder.**  
✅ **Şüpheli IP’leri analiz eder ve engelleyebilir.**  

📌 **Kullanım:**
```bash
./ssh_security.sh
```

---

### **Sistem Sağlık Kontrolü (`linux_system_health.sh`)**
✅ **CPU, RAM, disk kullanımı ve sistem yükünü analiz eder.**  
✅ **Ağ bağlantısı ve kritik servislerin durumunu kontrol eder.**  
✅ **Sistemin güncel olup olmadığını denetler.**  

📌 **Kullanım:**
```bash
./linux_system_health.sh
```

## 🔹Hata Ayıklama ve Log İnceleme

**Hata yaşarsanız**, aşağıdaki yöntemlerle logları kontrol edebilirsiniz:

```bash
tail -f /var/log/script_adi.log
```

Örneğin:

```bash
tail -f /var/log/system_optimization.log
```

Bu komut, script çalıştırıldığında oluşturulan log dosyasını **canlı olarak takip etmenizi** sağlar.

Eğer bir script çalışmazsa, hata mesajlarını görmek için şunu deneyin:

```bash
./script_adi.sh 2>&1 | tee hata_logu.txt
```

**Gelişmiş hata ayıklama için:**

```bash
bash -x script_adi.sh
```

---




