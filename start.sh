#!/bin/bash

#следующий код устанавливает обновления на убунту 
# > делает вывод stdout в следующий за ним файл
# 2>&1 направляет вывод ошибок stderr в этот же файл, в который и stdout
# && пишет в терминал об успехе, в случае успешного выполнения команды (return = 0)
# || пишет в терминал о провале, в случае неуспешного выполнения команды (!= 0)
# >> дописывает в файл, а не обновляет его
# -y сам отвечает на все yes в apt команде(мастхэв для скриптов)
# -C изменить директорию (например при распаковке), после -С обязательно должна идти директория
# -r рекурсия (например, при копировании или перемещении папки с содержимым)
# -x экстрагировать (для разархивирования)
# -f файл - что именно будем экстрагировать
# tar - разархивировать

#после запуска он попросит пароль от юзера
#запускать нужно от chemuser

echo "Запускаю обновление системы... Лог можно найти в about-installation-1.log"

sudo apt update -y > about-installation-1.log 2>&1 && echo "SUCCESS! sudo apt update" || echo "FAILED! Не получился sudo apt update"
sudo apt upgrade -y >> about-installation-1.log 2>&1 && echo "SUCCESS! sudo apt upgrade" || echo "FAILED! Не получился sudo apt upgrade"


#создаем папки для софта

echo "Создаю папки для софта... Лог можно найти в about-installation-2.log"

mkdir $HOME/software > about-installation-2.log && echo "SUCCESS! (1/3)" || echo "FAILED! Не получилось создать папку ../software"
mkdir $HOME/software/mpi >> about-installation-2.log && echo "SUCCESS! (2/3)" || echo "FAILED! Не получилось создать папку ../software/mpi"
mkdir $HOME/software/orca >> about-installation-2.log && echo "SUCCESS! (3/3)" || echo "FAILED! Не получилось создать папку ../software/orca"

#копируем папку с молекулами

echo "Копирую папку с молекулами... Лог можно найти в about-installation-2.log"

cp -r molecules $HOME/molecules >> about-installation-2.log && echo "SUCCESS! Папка с молекулами скопирована" || echo "FAILED! Не получилось скопировать папку в ../molecules"

#разархивируем софт

echo "Распаковываю orca_6_1_0_linux_x86-64_shared_openmpi418.tar.xz... Лог можно найти в about-installation-3.log"
sudo tar -xf $HOME/orca_6_1_0_linux_x86-64_shared_openmpi418.tar.xz -C $HOME/software/orca --strip-components=1 > about-installation-3.log 2>&1 && echo "SUCCESS! Орка распакована" || echo "FAILED! Не получилось распаковать Орку"

echo "Распаковываю openmpi-4.1.8.tar.gz... Лог можно найти в about-installation-4.log"
sudo tar -xf openmpi-4.1.8.tar.gz -C $HOME/software/mpi --strip-components=1 > about-installation-4.log 2>&1 && echo "SUCCESS! MPI распакован" || echo "FAILED! Не получилось распаковать MPI"




echo "Приступаю к настройке пути для ORCA..."

# после этого файл орки находится в $HOME/software/orca/orca
# попробуем засунуть в PATH

# ------------------------------------------------------------
# Автоматическая настройка переменных окружения для ORCA
# Добавляет ORCA в PATH и LD_LIBRARY_PATH в ~/.bashrc
# ------------------------------------------------------------

# Путь к папке с ORCA (измени, если нужно)
ORCA_PATH="$HOME/software/orca"

# Проверяем, существует ли папка ORCA
if [ ! -d "$ORCA_PATH" ]; then
    echo "❌ Ошибка: папка ORCA не найдена: $ORCA_PATH"
    echo "Сначала распакуй ORCA в эту папку."
    exit 1
fi

# Файл конфигурации shell
BASHRC="$HOME/.bashrc"

# Строки, которые нужно добавить
PATH_LINE="export PATH=\"$ORCA_PATH:\$PATH\""
LIB_LINE="export LD_LIBRARY_PATH=\"$ORCA_PATH:\$LD_LIBRARY_PATH\""

# Проверяем, не добавлены ли уже эти строки (чтобы не дублировать)
if ! grep -qF "$PATH_LINE" "$BASHRC"; then
    echo "$PATH_LINE" >> "$BASHRC"
    echo "Добавлено в PATH: $ORCA_PATH"
else
    echo "PATH уже настроен"
fi

if ! grep -qF "$LIB_LINE" "$BASHRC"; then
    echo "$LIB_LINE" >> "$BASHRC"
    echo "Добавлено в LD_LIBRARY_PATH: $ORCA_PATH"
else
    echo "LD_LIBRARY_PATH уже настроен"
fi

# Применяем изменения в текущей сессии
source "$BASHRC"

echo "SUCCESS! Настройка ORCA завершена! Теперь можно запускать 'orca' из любого места."


# теперь будем устанавливать mpi

echo "Запускаю установку MPI. Она займет около 15 минут. Лог можно найти в about-installation-mpi.log в папке $HOME/software/mpi"

cd $HOME/software/mpi || echo "FAILED! Отсутсвует папка mpi"

sudo ./configure --prefix=$HOME/software/mpi/ > about-installation-mpi.log 2>&1 && echo "SUCCESS! Конфигурация настроена, приступаю к установке mpi (займет около 10 минут)" || echo "FAILED! Не получилось настроить конфигурацию configure"

sudo make all install > about-installation-mpi 2>&1 && echo "SUCCESS! mpi установлен" || echo "FAILED! Произошла ошибка при установке mpi"



echo "Приступаю к настройке пути для MPI..."

# после этого файл орки находится в $HOME/software/mpi/bin и $HOME/software/mpi/lib
# попробуем засунуть в PATH

# ------------------------------------------------------------
# Автоматическая настройка переменных окружения для MPI
# Добавляет MPI в PATH и LD_LIBRARY_PATH в ~/.bashrc
# ------------------------------------------------------------

# Путь к папке с MPI
MPI_PATH_BIN="$HOME/software/mpi/bin"
MPI_PATH_LIB="$HOME/software/mpi/lib"

# Проверяем, существует ли папка MPI BIN
if [ ! -d "$MPI_PATH_BIN" ]; then
    echo "❌ Ошибка: папка MPI не найдена: $MPI_PATH_BIN"
    echo "Сначала распакуй MPI в эту папку."
    exit 1
fi

# Проверяем, существует ли папка MPI LIB
if [ ! -d "$MPI_PATH_LIB" ]; then
    echo "❌ Ошибка: папка MPI не найдена: $MPI_PATH_LIB"
    echo "Сначала распакуй MPI в эту папку."
    exit 1
fi

# Файл конфигурации shell
BASHRC="$HOME/.bashrc"

# Строки, которые нужно добавить
PATH_LINE="export PATH=\"$MPI_PATH_BIN:\$PATH\""
LIB_LINE="export LD_LIBRARY_PATH=\"$MPI_PATH_LIB:\$LD_LIBRARY_PATH\""

# Проверяем, не добавлены ли уже эти строки (чтобы не дублировать)
if ! grep -qF "$PATH_LINE" "$BASHRC"; then
    echo "$PATH_LINE" >> "$BASHRC"
    echo "Добавлено в PATH: $MPI_PATH_BIN"
else
    echo "PATH_BIN уже настроен"
fi

if ! grep -qF "$LIB_LINE" "$BASHRC"; then
    echo "$LIB_LINE" >> "$BASHRC"
    echo "Добавлено в LD_LIBRARY_PATH: $MPI_PATH_LIB"
else
    echo "LD_LIBRARY_PATH уже настроен"
fi

# Применяем изменения в текущей сессии
source "$BASHRC"

echo "SUCCESS! Настройка MPI завершена! Теперь можно запускать 'mpiexec' из любого места."


echo "Настраиваю директорию для временных файлов..."

mkdir -p $HOME/tmp
export TMPDIR=$HOME/tmp && echo "SUCCESS! TMPDIR настроен. Можно проверить с помощью echo $TMPDIR - должно написать ~/tmp" || echo "FAILED! Не получилось настроить временную директорию"


echo "ИТОГО: Настройка завершена. Необходимо проверить работу orca --version и mpiexec --version. Удачной работы!"

