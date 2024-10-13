#!/bin/bash

# Renk Tanımlamaları
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # Renkleri sıfırlama

# Log dosyası
LOGFILE="tool_log.txt"

# Yüklemek istediğiniz paketlerin listesi
paketler=(
    "git"
    "curl"
    "wget"
    "nano"
    "htop"
    "python"
    "vim"
    "openssh"
    "nodejs"
    "clang"
    "ruby"
    "nmap"
    "php"
    "jq"
    "figlet"
)

# Başlık
echo -e "${BLUE}********************************************${NC}" | tee -a "$LOGFILE"
echo -e "${YELLOW}*          Termux Paket Yükleyici         *${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}********************************************${NC}" | tee -a "$LOGFILE"
echo ""

# Kullanıcıya seçenekleri göster
echo -e "${YELLOW}Yüklemek istediğiniz paketleri seçin (birden fazla seçim için virgül kullanarak ayırın):${NC}"
for i in "${!paketler[@]}"; do
    echo -e "${GREEN}$((i + 1)). ${paketler[i]}${NC}"
done

# Kullanıcının seçim yapması
read -p "Seçiminizi yapın (1-${#paketler[@]}): " secim

# Seçim işlemini işleme
IFS=',' read -r -a secim_array <<< "$secim"

# Geçersiz seçim kontrolü
for s in "${secim_array[@]}"; do
    if [[ "$s" -lt 1 || "$s" -gt ${#paketler[@]} ]]; then
        echo -e "${RED}Geçersiz seçim: $s. Çıkılıyor...${NC}" | tee -a "$LOGFILE"
        exit 1
    fi
done

# Yükleme işlemi
echo -e "${YELLOW}Seçilen paketler: ${GREEN}${secim_array[*]}${NC}" | tee -a "$LOGFILE"
for s in "${secim_array[@]}"; do
    paket=${paketler[$((s - 1))]}

    echo -n -e "${YELLOW}Yükleniyor: $paket...${NC}"

    # Paket yükleme ve ilerleme çubuğu
    apt install -y "$paket" &>> "$LOGFILE" & # Arka planda yükleme başlatılır.
    pid=$! # Yükleme işleminin PID'sini al.

    # İlerleme çubuğu
    while kill -0 "$pid" 2>/dev/null; do
        echo -n -e "."
        sleep 1
    done

    # Yükleme tamamlandığında sonuç
    if [ $? -eq 0 ]; then
        echo -e " ${GREEN}[$paket başarıyla yüklendi!]${NC}" | tee -a "$LOGFILE"
    else
        echo -e " ${RED}[$paket yükleme hatası!]${NC}" | tee -a "$LOGFILE"
    fi
done

echo -e "${BLUE}********************************************${NC}" | tee -a "$LOGFILE"
echo -e "${YELLOW}*         Tüm paketler başarıyla yüklendi! *${NC}" | tee -a "$LOGFILE"
echo -e "${BLUE}********************************************${NC}" | tee -a "$LOGFILE"
