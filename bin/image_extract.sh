#!/bin/bash
TARGETDIR=out

partition_name="
system
vendor
product
system_ext
"
rm -rf $TARGETDIR
mkdir -p $TARGETDIR

for partition in $partition_name ;do
    if [[ -e $partition.img ]];then
        clear
        echo
        echo "正在尝试以 ext 格式查看 $partition.img..."
        if ! python3 ../bin/imgextractor.py $partition.img $TARGETDIR >/dev/null 2>&1 ;then
            echo "正在尝试以 erofs 格式查看 $partition.img..."
            if ! ../bin/erofsUnpackKt $partition.img $TARGETDIR >/dev/null 2>&1 ;then
                clear
                echo 
                echo "不支持解压 $partition.img"
                echo "原因: 未知格式"
                read -p ""
                exit
            else
                mv out/$partition . >/dev/null 2>&1
            fi  
        else
            mv out/$partition . >/dev/null 2>&1
        fi
    fi
done
mv out/config . >/dev/null 2>&1