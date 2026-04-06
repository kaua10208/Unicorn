#!/bin/bash
source scripts/utils.sh

echo "==== Projeto Unicorn ===="
echo "1 - Instalar Apps"
echo "2 - Debloat"
echo "3 - Instalar + Debloat"
echo "4 - Ativar DNS (AdGuard)"
echo "5 - Remover DNS"

read -p "Escolha: " opt

case $opt in

    1)
        bash scripts/install.sh
        ;;

    2)
        bash scripts/debloat.sh
        ;;

    3)
        bash scripts/install.sh
        bash scripts/debloat.sh
        ;;

    4)
        set_dns "dns.adguard-dns.com"
        echo "DNS ativado"
        ;;

    5)
        remove_dns
        echo "DNS removido"
        ;;

    *)
        echo "Opção inválida"
        ;;

esac