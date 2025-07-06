#!/bin/bash

COMMANDS_F|ILE="commands.txt"

show_menu() {
  clear
  cat <<'EOF'

         .--.
        |o_o |
        |:_/ |
       //   \ \
      (|     | ) Shell Command Library
     /'\_   _/`\
     \___)=(___/

   ===========================
   |        МЕНЮ             |
   | 1 - Поиск команды       |
   | 2 - Выйти               |
   ===========================

EOF
}

search_command() {
  read -p "Введите имя команды для поиска: " cmd
  clear
  echo "Результаты поиска для команды: $cmd"
  echo "------------------------------------------------------------"

  # Проверяем, существует ли файл с командами
  if [[ ! -f "$COMMANDS_FILE" ]]; then
    echo "Файл с командами '$COMMANDS_FILE' не найден."
    echo "------------------------------------------------------------"
    read -p "Нажмите Enter для возврата в меню..."
    return
  fi

  # Ищем команду и выводим блок с описанием
  awk -v cmd="$cmd" '
    BEGIN {found=0}
    /^Команда: / {
      if (found) exit
      if ($0 == "Команда: " cmd) found=1
    }
    found {print}
    /^------------------------------------------------------------/ && found {exit}
  ' "$COMMANDS_FILE"

  # Проверяем, была ли команда найдена
  if ! grep -q "^Команда: $cmd" "$COMMANDS_FILE"; then
    echo "Команда '$cmd' не найдена в базе."
  fi

  echo "------------------------------------------------------------"
  read -p "Нажмите Enter для возврата в меню..."
}

while true; do
  show_menu
  read -p "Выберите опцию (1 или 2): " choice
  case $choice in
    1) search_command ;;
    2)
      clear
      echo "Выход из программы. До свидания!"
      exit 0
      ;;
    *)
      echo "Неверный ввод. Пожалуйста, выберите 1 или 2."
      sleep 1
      ;;
  esac
done
