#!/bin/bash
source scripts/utils.sh

CONFIG="config/debloat.json"

jq -c '.apps[]' "$CONFIG" | while read app; do

    name=$(echo "$app" | jq -r '.name')
    package=$(echo "$app" | jq -r '.package')
    type=$(echo "$app" | jq -r '.type')

    if is_installed "$package"; then

        echo "----------------------"
        echo "App encontrado: $name"

        case $type in

            critical)
                echo "App crítico → desativando"
                disable_app "$package"
                ;;

            optional)
                echo "1 - Desinstalar"
                echo "2 - Desativar"
                echo "3 - Manter"
                read -p "Escolha: " choice

                case $choice in
                    1) remove_app "$package" ;;
                    2) disable_app "$package" ;;
                    *) echo "Mantido" ;;
                esac
                ;;

            replace)
                echo "Substituindo $name..."

                remove_app "$package"

                replacement=$(echo "$app" | jq -r '.replacement')

                if [[ -n "$replacement" ]]; then
                    bash scripts/install.sh "$replacement"
                fi
                ;;

        esac
    fi

done

echo "Debloat finalizado 🚀"