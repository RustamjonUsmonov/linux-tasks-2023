#!/bin/bash

steps=0
guessed=0
not_guessed=0
total_guesses=0
guessed_numbers=""

declare -a last_10_guesses

while true; do
    ((steps++))

    echo "Шаг $steps"
    read -p "Введите число от 0 до 9 (q для выхода): " user_input

    if [[ $user_input == "q" ]]; then
        echo "Игра завершена."
        break
    fi

    if ! [[ $user_input =~ ^[0-9]$ ]]; then
        echo "Ошибка! Введите одну цифру от 0 до 9 или q для выхода."
        continue
    fi

    number=$((RANDOM % 10))

    if [[ $user_input -eq $number ]]; then
        ((guessed++))
        guessed_numbers+=" $user_input "
        echo "Вы угадали число!"
    else
        ((not_guessed++))
        guessed_numbers+=" $user_input "
        echo "Не угадали. Загаданное число: $number"
    fi

    ((total_guesses++))

    if ((total_guesses > 10)); then
        guessed_numbers=$(echo "$guessed_numbers" | awk '{print $NF; for(i=NF-1;i>=NF-9;i--) printf("%s ",$i)}')
    fi

    last_10_guesses+=("$user_input")

    if (( ${#last_10_guesses[@]} > 10 )); then
        unset 'last_10_guesses[0]'
        last_10_guesses=("${last_10_guesses[@]}")
    fi


    echo -e "Статистика игры:"
    echo "Доля угаданных чисел: $((guessed * 100 / total_guesses))%"
    echo "Доля не угаданных чисел: $((not_guessed * 100 / total_guesses))%"
    # shellcheck disable=SC2145
    echo "Последние 10 чисел: ${last_10_guesses[@]}"
done
