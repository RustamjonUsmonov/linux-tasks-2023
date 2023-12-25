#!/bin/bash

while getopts "d:n:" opt; do
    case $opt in
        d) directory_path=$OPTARG ;;
        n) archive_name=$OPTARG ;;
        *) echo "Использование: $0 -d <directory_path> -n <archive_name>"; exit 1 ;;
    esac
done

if [ -z "$directory_path" ] || [ -z "$archive_name" ]; then
    echo "Пожалуйста, укажите путь к каталогу и имя архива"
    exit 1
fi

# Создание bash-скрипта
cat > "$archive_name" <<'EOF'
#!/bin/bash

unpack_directory=""

while getopts "o:" opt; do
    case $opt in
        o) unpack_directory=$OPTARG ;;
        *) echo "Использование: $0 [-o unpack_directory]"; exit 1 ;;
    esac
done

if [ -z "$unpack_directory" ]; then
    echo "Распаковка в текущий каталог..."
    tar -xzf "$0"
else
    echo "Распаковка в $unpack_directory..."
    tar -xzf "$0" -C "$unpack_directory"
fi
EOF

# Упаковка каталога в tar-архив и сжатие
tar -czf - "$directory_path" | cat - > "$archive_name"
chmod +x "$archive_name"

echo "Архивация и создание скрипта $archive_name завершены."
