#!/bin/bash

# Copyright 2025 by Redin Matvey
# <redinmatvey11@gmail.com>
# GNU GPLv3 License

COMMANDS_FILE="commands.txt"

show_menu() {
clear
cat <<'EOF'
  ~ Shell commamds Library ~
   Библиотека команд для дистрибутивов GNU/Linux, в которых используется оболочка BASh shell.
   Исходный код: https://github.com/RedInmatvey-triangle/shell-command-library
==============================
| МЕНЮ                       |
| 1 - Поиск команды по имени |
| 2 - Поиск по описанию      |
| 3 - Выйти                  |
==============================
EOF
}

search_command() {
    read -p "Введите имя команды для поиска: " cmd
    clear
    echo "Результаты поиска для команды: $cmd"
    echo "------------------------------------------------------------"
    if [[ ! -f "$COMMANDS_FILE" ]]; then
        echo "Файл с командами '$COMMANDS_FILE' не найден."
        echo "------------------------------------------------------------"
        read -p "Нажмите Enter для возврата в меню..."
        return
    fi
    awk -v cmd="$cmd" '
    BEGIN {found=0}
    /^Команда: / {
        if (found) exit
        if ($0 == "Команда: " cmd) found=1
    }
    found {print}
    /^------------------------------------------------------------/ && found {exit}
    ' "$COMMANDS_FILE"

    if ! grep -q "^Команда: $cmd" "$COMMANDS_FILE"; then
        echo "Команда '$cmd' не найдена в базе."
    fi
    echo "------------------------------------------------------------"
    read -p "Нажмите Enter для возврата в меню..."
}

search_description() {
    read -p "Введите ключевое слово для поиска в описании: " keyword
    clear
    echo "Результаты поиска по описанию: $keyword"
    echo "------------------------------------------------------------"
    if [[ ! -f "$COMMANDS_FILE" ]]; then
        echo "Файл с командами '$COMMANDS_FILE' не найден."
        echo "------------------------------------------------------------"
        read -p "Нажмите Enter для возврата в меню..."
        return
    fi
    awk -v kw="$keyword" 'BEGIN {RS="------------------------------------------------------------\n"; IGNORECASE=1}
    /Описание:/ {if ($0 ~ kw) print $0 "\n------------------------------------------------------------"}' "$COMMANDS_FILE"
    read -p "Нажмите Enter для возврата в меню..."
}

while true; do
    show_menu
    read -p "Выберите опцию (1, 2 или 3): " choice
    case $choice in
        1) search_command ;;
        2) search_description ;;
        3)
            clear
            echo "Выход из программы. До свидания!"
            exit 0
            ;;
        *)
            echo "Неверный ввод. Пожалуйста, выберите 1, 2 или 3."
            sleep 1
            ;;
    esac
done
