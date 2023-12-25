#!/bin/bash

dirpath="."
mask="*"
number=$(nproc)

while [[ $# -gt 0 ]]; do
    case "$1" in
        --path)
            dirpath="$2"
            shift 2
            ;;
        --mask)
            mask="$2"
            shift 2
            ;;
        --number)
            number="$2"
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

command="$@"

if [[ ! -d "$dirpath" ]]; then
    echo "Ошибка: Каталог '$dirpath' не существует."
    exit 1
fi

if [[ ! -x "$command" ]]; then
    echo "Ошибка: Не найден исполняемый файл '$command'."
    exit 1
fi

file_count=0
process_count=0

for file in "$dirpath"/$mask; do
    if [[ -f "$file" ]]; then
        ((file_count++))

        if ((process_count < number)); then
            "$command" "$file" &  # Запуск команды обработки в фоновом режиме
            ((process_count++))
        else
            wait -n  # Ожидание завершения одного из процессов
            ((process_count--))
            "$command" "$file" &  # Запуск новой команды обработки в фоновом режиме
            ((process_count++))
        fi
    fi
done

# Ожидание завершения оставшихся процессов
wait
echo "Обработка $file_count файлов завершена."
