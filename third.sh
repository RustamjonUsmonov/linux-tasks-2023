#!/bin/bash

# Инициализация игрового поля
declare -a board=(
    [0]="1" "2" "3" "4"
    "5" "6" "7" "8"
    "9" "10" "11" "12"
    "13" "14" "15" " "
)
empty_row=3
empty_col=3
moves=0

# Перемешивание игрового поля
shuffle_board() {
    local i j n temp
    for ((n = 0; n < 1000; n++)); do
        i=$((RANDOM % 4))
        j=$((RANDOM % 4))
        temp=${board[$i*4+$j]}
        board[$i*4+$j]=${board[$empty_row*4+$empty_col]}
        board[$empty_row*4+$empty_col]=$temp
        empty_row=$i
        empty_col=$j
    done
}

# Вывод игрового поля
print_board() {
    clear
    echo "Ход: $moves"
    echo "--------------------------"
    for ((i = 0; i < 4; i++)); do
        for ((j = 0; j < 4; j++)); do
            printf "| %3s " "${board[$i*4+$j]}"
        done
        echo "|"
        echo "--------------------------"
    done
}

# Проверка на завершение игры
check_win() {
    local win="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 "
    local current_board=""
    for ((i = 0; i < 4; i++)); do
        for ((j = 0; j < 4; j++)); do
            current_board+=" ${board[$i*4+$j]}"
        done
    done
    if [ "$current_board" == "$win" ]; then
        echo "Вы выиграли за $moves ходов."
        exit 0
    fi
}

# Перемещение ячейки
move() {
    local row=$1
    local col=$2

    local row_diff=$((empty_row - row))
    local col_diff=$((empty_col - col))
    local abs_row_diff=${row_diff#-}
    local abs_col_diff=${col_diff#-}

    if (( (abs_row_diff == 1 && col_diff == 0) || (abs_col_diff == 1 && row_diff == 0) )); then
        board[$empty_row*4+$empty_col]=${board[$row*4+$col]}
        board[$row*4+$col]=" "
        empty_row=$row
        empty_col=$col
        ((moves++))
    fi
}

shuffle_board

while true; do
    print_board
    check_win

    read -p "Для перемещения введите число от 1 до 15 (q для выхода): " input

    if [ "$input" == "q" ]; then
        echo "Игра завершена."
        exit 0
    fi

    if ! [[ "$input" =~ ^[1-9]|1[0-5]$ ]]; then
        echo "Введите число от 1 до 15 (q для выхода)."
        continue
    fi

    row=$(( ($input - 1) / 4 ))
    col=$(( ($input - 1) % 4 ))

    move "$row" "$col"
done
