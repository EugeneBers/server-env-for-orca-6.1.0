#!/bin/bash

echo "Создаю директории..."

mkdir B3LYP-acn && echo "SUCCESS! (1/5)" || echo "FAILED! Что-то пошло не так"
mkdir CAM-B3LYP-acn && echo "SUCCESS! (2/5)" || echo "FAILED! Что-то пошло не так"
mkdir B2PLYP-acn && echo "SUCCESS! (3/5)" || echo "FAILED! Что-то пошло не так"
mkdir WPBEPP86-acn && echo "SUCCESS! (4/5)" || echo "FAILED! Что-то пошло не так"
mkdir SOS-PBE-QIDH-acn && echo "SUCCESS! (5/5)" || echo "FAILED! Что-то пошло не так"

echo "Распределяю файл с геометрией по папкам..."

cp OptA2.xyz B3LYP-acn/OptA2.xyz && echo "SUCCESS! (1/5)" || echo "FAILED! Что-то пошло не так"
cp OptA2.xyz CAM-B3LYP-acn/OptA2.xyz && echo "SUCCESS! (2/5)" || echo "FAILED! Что-то пошло не так"
cp OptA2.xyz B2PLYP-acn/OptA2.xyz && echo "SUCCESS! (3/5)" || echo "FAILED! Что-то пошло не так"
cp OptA2.xyz WPBEPP86-acn/OptA2.xyz && echo "SUCCESS! (4/5)" || echo "FAILED! Что-то пошло не так"
cp OptA2.xyz SOS-PBE-QIDH-acn/OptA2.xyz && echo "SUCCESS! (5/5)" || echo "FAILED! Что-то пошло не так"

echo "Распределяю расчетные файлы по папкам..."

cp $HOME/chemuser/server-env-for-orca-6.1.0/compute-templates/B3LYP-acn.inp B3LYP-acn/job.inp && echo "SUCCESS! (1/5)" || echo "FAILED! Что-то пошло не так"
cp $HOME/chemuser/server-env-for-orca-6.1.0/compute-templates/CAM-B3LYP-acn.inp CAM-B3LYP-acn/job.inp && echo "SUCCESS! (2/5)" || echo "FAILED! Что-то пошло не так"
cp $HOME/chemuser/server-env-for-orca-6.1.0/compute-templates/B2PLYP-acn.inp B2PLYP-acn/job.inp && echo "SUCCESS! (3/5)" || echo "FAILED! Что-то пошло не так"
cp $HOME/chemuser/server-env-for-orca-6.1.0/compute-templates/WPBEPP86-acn.inp WPBEPP86-acn/job.inp && echo "SUCCESS! (4/5)" || echo "FAILED! Что-то пошло не так"
cp $HOME/chemuser/server-env-for-orca-6.1.0/compute-templates/SOS-PBE-QIDH-acn.inp SOS-PBE-QIDH-acn/job.inp && echo "SUCCESS! (5/5)" || echo "FAILED! Что-то пошло не так"

#нельзя запускать каждую команду через nohup т.к. они запустятся параллельно!
#нужно будет сам скрипт запустить через nohup!!!

echo "Запускаю расчеты! Это надолго. Отслеживать состояние можно в соответствующий job.out файлах"

$HOME/software/orca/orca B3LYP-acn/job.inp > B3LYP-acn/job.out 2>&1 && echo "out файл B3LYP сформирован" || echo "При расчете B3LYP что-то пошло не так"

$HOME/software/orca/orca CAM-B3LYP-acn/job.inp > CAM-B3LYP-acn/job.out 2>&1 && echo "out файл CAM-B3LYP сформирован" || echo "При расчете CAM-B3LYP что-то пошло не так"

$HOME/software/orca/orca B2PLYP-acn/job.inp > B2PLYP-acn/job.out 2>&1 && echo "out файл B2PLYP сформирован" || echo "При расчете B2PLYP что-то пошло не так"

$HOME/software/orca/orca WPBEPP86-acn/job.inp > WPBEPP86-acn/job.out 2>&1 && echo "out файл WPBEPP86 сформирован" || echo "При расчете WPBEPP86 что-то пошло не так"

$HOME/software/orca/orca SOS-PBE-QIDH-acn/job.inp > SOS-PBE-QIDH-acn/job.out 2>&1 && echo "out файл SOS-PBE-QIDH сформирован" || echo "При расчете SOS-PBE-QIDH что-то пошло не так"

echo "Сеть расчетов завершена!"