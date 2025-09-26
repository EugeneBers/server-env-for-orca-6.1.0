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

echo "Запускаю обновление системы... Лог можно найти в about-installation-1.log"

sudo apt update -y > about-installation-1.log 2>&1 && echo "SUCCESS! sudo apt update" || echo "FAILED! Не получился sudo apt update"
sudo apt upgrade -y >> about-installation-1.log 2>&1 && echo "SUCCESS! sudo apt update" || echo "FAILED! Не получился sudo apt update"


#создаем папки для софта

echo "Создаю папки для софта... Лог можно найти в about-installation-2.log"

mkdir ../software > about-installation-2.log && echo "SUCCESS! (1/3)" || echo "FAILED! Не получилось создать папку ../software"
mkdir ../software/mpi >> about-installation-2.log && echo "SUCCESS! (2/3)" || echo "FAILED! Не получилось создать папку ../software/mpi"
mkdir ../software/orca >> about-installation-2.log && echo "SUCCESS! (3/3)" || echo "FAILED! Не получилось создать папку ../software/orca"

#копируем папку с молекулами

echo "Копирую папку с молекулами... Лог можно найти в about-installation-2.log"

cp -r molecules ../molecules >> about-installation-2.log && echo "SUCCESS! Папка с молекулами скопирована" || echo "FAILED! Не получилось скопировать папку в ../molecules"

#разархивируем софт

echo "Распаковываю orca_6_1_0_linux_x86-64_shared_openmpi418.tar.xz... Лог можно найти в about-installation-3.log"
sudo tar -xf ../orca_6_1_0_linux_x86-64_shared_openmpi418.tar.xz -C ../software/orca --strip-components=1 > about-installation-3.log 2>&1 && echo "SUCCESS! Орка распакована" || echo "FAILED! Не получилось распаковать Орку"

echo "Распаковываю openmpi-4.1.8.tar.gz... Лог можно найти в about-installation-4.log"
sudo tar -xf openmpi-4.1.8.tar.gz -C ../software/mpi --strip-components=1 > about-installation-4.log 2>&1 && echo "SUCCESS! MPI распакован" || echo "FAILED! Не получилось распаковать MPI"

echo "ИТОГО: все что смог я сделал. Тебе остается: 1) задать PATH для всех; 2) создать tmp директорию; 3) проверить работу orca и mpiexec через --version. Удачной работы!"
