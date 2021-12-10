#!/bin/bash
#############################
#     内部代码，请勿分享     #
#############################
clear
# 官方包 & 官改包 路径
official=official
output=output

# 设置变量
projects=0
DIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
aversion=1.0.0

# 检测项目 & 新建项目
rm -rf bin/RomMake.txt >/dev/null 2>&1
ls $official | grep "miui" | grep ".zip" | while read line;do
    rm -rf Acme_$(echo $line | cut -d _ -f 2)
    mkdir Acme_$(echo $line | cut -d _ -f 2)
    mv $official/miui_$(echo $line | cut -d _ -f 2)_*_**.zip Acme_$(echo $line | cut -d _ -f 2)
    echo Acme_$(echo $line | cut -d _ -f 2) >>bin/RomMake.txt
done

#检测是否存在项目
if [[ ! -f bin/RomMake.txt ]]; then
    clear
    echo 
    echo "不存在官方包"
    read -p ""
    exit
fi
AllProject=$(awk 'END{print NR}' bin/RomMake.txt)

# 开始制作
start(){
    # 更新项目信息
    AcmeRom=$(awk 'NR==1{print}' bin/RomMake.txt)
    sed -i '1d' bin/RomMake.txt
    if [[ $AcmeRom = "" ]]; then
        clear
        echo 
        echo 成功制作$AllProject个项目
        read -p ""
        exit
    fi

    # 更新信息
    if [[ $projects = "0" ]]; then
        projects=1
    else
        projects=$(($projects+1))
    fi
    echo 
    echo "AcmeMiui_v$aversion 当前项目：$AcmeRom 第$projects/$AllProject个"

    # 解压刷机包
    zip=$(ls $AcmeRom | grep "zip")
    clear
    echo 
    echo "解压文件：$zip"
    unzip $AcmeRom/$zip -d $AcmeRom >/dev/null 2>&1

    # 检测是否为V-ab(Payload)
    if [[ -f $AcmeRom/payload_properties.txt ]]; then
        clear
        vabrom=1
        cp -rf bin/payload/ $AcmeRom/
        cp bin/image_extract.sh $AcmeRom/
        cd $AcmeRom
        echo 
        echo 提取Payload.bin...
        echo 
        python3 payload/payload_dumper.py payload.bin output
        rm -rf payload >/dev/null 2>&1
        cd $DIR
        mv -f $AcmeRom/output/system.img $AcmeRom/ >/dev/null 2>&1
        mv -f $AcmeRom/output/vendor.img $AcmeRom/ >/dev/null 2>&1
        mv -f $AcmeRom/output/product.img $AcmeRom/ >/dev/null 2>&1
        mv -f $AcmeRom/output/system_ext.img $AcmeRom/ >/dev/null 2>&1
        cd $AcmeRom
        sudo bash image_extract.sh
        rm -rf image_extract.sh out/ >/dev/null 2>&1
    fi

    # 普通方式解包
    if [[ ! -f $AcmeRom/payload_properties.txt ]]; then
        cd $AcmeRom
        ls | grep "\.new\.dat" | while read i; do
            line=$(echo "$i" | cut -d"." -f1)
            if [[ $(echo "$i" | grep "\.dat\.br") ]]; then
                clear
                echo 
                echo "将$i转换为$line.new.dat"
                cd $DIR
                brotli -j -d -o $AcmeRom/$line.new.dat $AcmeRom/$i
                rm -f "$AcmeRom/$i" >/dev/null 2>&1
            fi
            clear
            echo 
            echo "转换到$line.img"
            cd $DIR
            python3 bin/sdat2img.py $AcmeRom/$line.transfer.list $AcmeRom/$line.new.dat $AcmeRom/$line.img >/dev/null 2>&1
            rm -rf $AcmeRom/$line.transfer.list $AcmeRom/$line.new.dat >/dev/null 2>&1
            clear
        done
        cp bin/image_extract.sh $AcmeRom/
        cd $AcmeRom
        sudo bash image_extract.sh
        rm -rf image_extract.sh out/ >/dev/null 2>&1
    fi

    # 检测解包完整性
    cd $DIR
    if [[ ! $vabrom = "1" ]]; then
        if [[ ! -f $AcmeRom/boot.img ]]; then
            clear
            echo 
            echo "检测到 $AcmeRom 不存在内核文件"
            read -p ""
            exit
        fi
    fi
    if [[ -f $AcmeRom/system/system/build.prop ]]; then
        system=system/system
    elif [[ -f $AcmeRom/system/build.prop ]]; then
        system=system
    else
        echo 
        echo "检测到 $AcmeRom 解包失败"
        read -p ""
        exit
    fi

    # 删除系统更新
    mv "$AcmeRom/$system/app/Updater/Updater.apk" "$AcmeRom/$system/app/Updater/Updater.apk.bak"

    # 判断是否为 安卓10、11、12
    sdk=$(cat $AcmeRom/$system/build.prop |grep "ro.build.version.sdk"| awk -F "=" '{print $2}')
    ui=$(cat $AcmeRom/$system/build.prop |grep "ro.miui.ui.version.name"| awk -F "=" '{print $2}')
    if [[ $sdk -eq 29 || $sdk -eq 30 || $sdk -eq 31 ]]; then
    device=$(cat $AcmeRom/vendor/build.prop |grep "ro.product.vendor.marketname"| awk -F "=" '{print $2}')
    else
    echo 
    echo "不支持 $AcmeRom 的安卓版本"
    read -p ""
    exit
    fi

    # 提取设备信息
    android=$(cat $AcmeRom/$system/build.prop |grep "ro.build.version.release="| awk -F "=" '{print $2}')
    version=$(cat $AcmeRom/$system/build.prop |grep "ro.build.version.incremental"| awk -F "=" '{print $2}')
    if [[ -f $AcmeRom/vendor/build.prop ]]; then
        model=$(cat $AcmeRom/vendor/build.prop |grep "ro.product.vendor.device"| awk -F "=" '{print $2}')
    else
        model=$(cat $AcmeRom/$system/build.prop |grep "ro.product.system.device"| awk -F "=" '{print $2}')
    fi

    # V-ab 面具补丁patch
    if [[ $vabrom = "1" ]]; then
        if [[ ! -f $AcmeRom/bootdone ]]; then
            cd $DIR
            mv -f $AcmeRom/output/boot.img bin/magiskboot/boot.img
            cd bin/magiskboot
            echo 

            BOOTIMAGE=boot.img
            KEEPVERITY=true
            KEEPFORCEENCRYPT=true
            RECOVERYMODE=false

            chmod +x magiskboot
            export KEEPVERITY
            export KEEPFORCEENCRYPT
            SHA1=`./magiskboot sha1 "$BOOTIMAGE"`
            echo "KEEPVERITY=$KEEPVERITY
            KEEPFORCEENCRYPT=$KEEPFORCEENCRYPT
            RECOVERYMODE=$RECOVERYMODE
            SHA1=$SHA1" > config
            ./magiskboot unpack $BOOTIMAGE
            cp -af ramdisk.cpio ramdisk.cpio.orig
            ./magiskboot compress=xz magisk32 magisk32.xz
            ./magiskboot compress=xz magisk64 magisk64.xz
            ./magiskboot cpio ramdisk.cpio \
                    "add 0750 init magiskinit" \
                    "mkdir 0750 overlay.d" \
                    "mkdir 0750 overlay.d/sbin" \
                    "add 0644 overlay.d/sbin/magisk32.xz magisk32.xz" \
                    "add 0644 overlay.d/sbin/magisk64.xz magisk64.xz" \
                    "patch" \
                    "backup ramdisk.cpio.orig" \
                    "mkdir 000 .backup" \
                    "add 000 .backup/.magisk config"
            for dt in dtb kernel_dtb extra; do
                [ -f $dt ] && ./magiskboot dtb $dt patch
            done
            ./magiskboot hexpatch kernel \
                    736B69705F696E697472616D667300 \
                    77616E745F696E697472616D667300
            ./magiskboot repack $BOOTIMAGE
            ./magiskboot cleanup
            rm -f ramdisk.cpio.orig config boot.img magisk32.xz magisk64.xz
            mv new-boot.img boot.img

            cd $DIR
            mv -f bin/magiskboot/boot.img $AcmeRom/output/boot.img
            touch $AcmeRom/bootdone
            if [[ ! -f $AcmeRom/output/boot.img ]]; then
                echo 
                echo "$AcmeRom 处理boot.img失败"
                read -p ""
                exit
            fi
        fi
    fi

    # 展示设备信息
    clear
    echo 
    echo "以下为当前设备信息:"
    echo 
    echo 项目:$AcmeRom
    echo 
    echo 机型:$device
    echo 
    echo 代号:$model
    echo 
    echo 版本号:$version
    echo 
    echo 安卓版本:$android
    sleep 3

    # 系统精简
    clear
    echo 
    echo 正在精简系统
    rm -rf $AcmeRom/$system/recovery-from-boot.p

    sudo cat bin/DeleteApps.txt |while read line; do
        sudo find $AcmeRom** -type d -name "$line" | xargs rm -rf
    done

    # 检测是否为动态分区
    if [[ -f $AcmeRom/dynamic_partitions_op_list ]]; then
        touch $AcmeRom/brpack
    fi

    # 移除avb
    clear
    echo 
    echo "正在移除avb"
    sleep 2
    if [[ -f $AcmeRom/boot.img ]]; then
        rm -rf bin/boot/ramdisk >/dev/null 2>&1
        rm -rf bin/boot/split_img >/dev/null 2>&1
        rm -rf bin/boot/boot.img >/dev/null 2>&1
        mv $AcmeRom/boot.img bin/boot/
        cd bin/boot
        clear
        ./cleanup.sh
        ./unpackimg.sh
        cd $DIR
        mv bin/boot/boot.img $AcmeRom/
    fi

    if [[ -f $AcmeRom/boot.img ]]; then
        sed -i 's/\x2C\x61\x76\x62/\x00\x00\x00\x00/g' $AcmeRom/boot.img
    fi

    if [[ -f $AcmeRom/output/dtbo.img ]]; then
        sed -i 's/\x2C\x61\x76\x62/\x00\x00\x00\x00/g' $AcmeRom/output/dtbo.img
    fi

    if [[ -f $AcmeRom/firmware-update/dtbo.img ]]; then
        sed -i 's/\x2C\x61\x76\x62/\x00\x00\x00\x00/g' $AcmeRom/firmware-update/dtbo.img
    fi

    if [[ -f $AcmeRom/output/vbmeta_system.img ]]; then
        cp -rf bin/vbmeta.img $AcmeRom/output/vbmeta_system.img >/dev/null 2>&1
    fi

    if [[ -f $AcmeRom/output/vbmeta_vendor.img ]]; then
        cp -rf bin/vbmeta.img $AcmeRom/output/vbmeta_vendor.img >/dev/null 2>&1
    fi

    if [[ -f $AcmeRom/output/vbmeta.img ]]; then
        cp -rf bin/vbmeta.img $AcmeRom/output/vbmeta.img >/dev/null 2>&1
    fi

    if [[ -f $AcmeRom/firmware-update/vbmeta_system.img ]]; then
        cp -rf bin/vbmeta.img $AcmeRom/firmware-update/vbmeta_system.img >/dev/null 2>&1
    fi

    if [[ -f $AcmeRom/firmware-update/vbmeta.img ]]; then
        cp -rf bin/vbmeta.img $AcmeRom/firmware-update/vbmeta.img >/dev/null 2>&1
    fi

    # 移除分区表加密
    clear
    echo 
    echo "移除分区表加密"
    sleep 2
    cd $AcmeRom
    if [ -d "vendor/etc" ]; then
        for line in $(grep "<fs_mgr_flags>" vendor/etc/*.* -rn -l ); do
            chmod 0777 $line
            sed -i 's/ro\,noatime/ro/g' $line
            sed -i 's/=vbmeta_system//g' $line

            for keep in ${keeps}; do
                if [[ $model = $keep ]]; then
                    echo 
                    else
                    sed -i 's/forceencrypt/encryptable/g' $line
                    sed -i 's/fileencryption=ice/encryptable=ice/g' $line
                fi
            done

            sed -i 's/\_keys\=\/avb\/q\-gsi\.avbpubkey\:\/avb\/r-gsi\.avbpubkey\:\/avb\/s\-gsi\.avbpubkey//g' $line
            sed -i 's/,avb_keys=\/avb\/q-gsi.avbpubkey:\/avb\/r-gsi.avbpubkey:\/avb\/s-gsi.avbpubkey//g' $line
            sed -i 's/,avb//g' $line
        done
    fi
    if [[ $android = "12" ]]; then
        sed -i 's/\,fileencryption=aes/\,encryption=aes/g' $line
    fi

    # 创建刷机脚本显示内容
    printa='ui_print("'
    printb='");'
    make='AcmeTeam'
    start_end='*************************'

    if [ `echo $version|grep ^V` ];then
    type='Stable'
    release='sta'
    else
    type='Develop'
    release='dev'
    fi

    device1="$printa Device：$device $printb"
    version1="$printa Version: $version $printb"
    andriod1="$printa Andriod：$android $printb"
    make1="$printa By: $make $printb"
    start_end="$printa$start_end$printb"
    type1="$printa Type: $type $printb"
    pause="$printa $printb"

    echo $pause >new_script
    echo $start_end >>new_script
    echo $pause >>new_script
    echo $device1 >>new_script
    echo $version1 >>new_script
    echo $andriod1 >>new_script
    echo $type1 >>new_script
    echo $make1 >>new_script
    echo $pause >>new_script
    echo $start_end >>new_script
    echo >>new_script

    # 修改刷机脚本
    cd $AcmeRom
    if [ ! -f "brpack" ];then
        sed -i 's/.br//g' META-INF/com/google/android/updater-script
        rm -rf brpack
    fi
    sed -i '3 i\Acme' META-INF/com/google/android/updater-script
    sed -i '/Acme/r new_script' META-INF/com/google/android/updater-script
    sed -i '/Acme/d' META-INF/com/google/android/updater-script
    cd $DIR
    if [[ -f $AcmeRom/dynamic_partitions_op_list ]]; then
        if [[ ! $vabrom = "1" ]]; then
            cp -rf bin/update-binary-product $AcmeRom/META-INF/com/google/android/update-binary >/dev/null 2>&1
        fi
    fi

    # 破解卡米
    if [[ $android = "12" ]]; then
        clear
        echo 
        echo "检测到 $AcmeRom 为 安卓12, 跳过破解卡米"
        sleep 2
    else
        clear
        mkdir -p $AcmeRom/temp/services
        mv $AcmeRom/$system/framework/services.jar $AcmeRom/temp/
        unzip $AcmeRom/temp/services.jar class* -d $AcmeRom/temp/services >/dev/null 2>&1
        echo 
        echo  反编译：services/classes.dex
        java -jar bin/baksmali.jar disassemble $AcmeRom/temp/services/classes.dex -o $AcmeRom/temp/services
        echo 
        echo  反编译：services/classes2.dex
        java -jar bin/baksmali.jar disassemble $AcmeRom/temp/services/classes2.dex -o $AcmeRom/temp/services2
        rm -rf $AcmeRom/temp/services/classes.dex >/dev/null 2>&1
        rm -rf $AcmeRom/temp/services/classes2.dex >/dev/null 2>&1
        mifile=$(find temp/servi*/ -type f -name '*.smali' 2>/dev/null | xargs grep -rl '.method private checkSystemSelfProtection(Z)V' | sed 's/^\.\///' | sort)
        sed -i '/^.method private checkSystemSelfProtection(Z)V/,/^.end method/{//!d}' $mifile
        sed -i -e '/^.method private checkSystemSelfProtection(Z)V/a\    .locals 1\n\n    return-void' $mifile
        mkdir -p $AcmeRom/temp/classes/services
        clear
        echo 
        echo  回编译：services/classes2.dex
        java -jar bin/smali.jar assemble $AcmeRom/temp/services2 -o $AcmeRom/temp/classes/services/classes2.dex
        echo 
        echo  回编译：miuisystem/classes.dex
        java -jar bin/smali.jar assemble $AcmeRom/temp/miuisystem -o $AcmeRom/temp/classes/miuisystem/classes.dex
        if [[ -f $AcmeRom/temp/classes/services/classes2.dex && -f $AcmeRom/temp/classes/services/classes.dex ]]; then
            clear
            echo 
        else
            clear
            echo 
            echo "$AcmeRom 破解卡米失败"
            echo "原因: 回编译失败"
            read -p ""
            exit
        fi
        7z a $AcmeRom/temp/services.jar ./$AcmeRom/temp/classes/services/* >/dev/null 2>&1
        ./bin/zipalign -v -p 4 $AcmeRom/temp/services.jar $AcmeRom/$system/framework/services.jar >/dev/null 2>&1
        if [[ -f $AcmeRom/$system/framework/services.jar ]]; then
            clear
            sleep 2
        else
            clear
            echo 
            echo "$AcmeRom 破解卡米失败"
            echo "原因: zipalign化失败"
            read -p ""
            exit
        fi
        rm -rf $AcmeRom/temp/classes >/dev/null 2>&1
    fi

    # 判断是否需要更换update-binary
    if [[ $android = "11" || $android = "12" ]]; then
    dat=true
    fi
    if [[ -f $AcmeRom/dynamic_partitions_op_list ]]; then
    dat=flase
    fi

    # 更换刷机二进制文件
    if [[ $dat = "true" ]]; then
        cp -rf bin/update-binary-dat $AcmeRom/META-INF/com/google/android/update-binary >/dev/null 2>&1
    fi

    # 准备打包文件
    cd $DIR
    clear
    echo 
    echo 准备打包文件
    mkdir -p PackZip/prebuilt
    mv $AcmeRom/system PackZip/ >/dev/null 2>&1
    mv $AcmeRom/vendor PackZip/ >/dev/null 2>&1
    mv $AcmeRom/product PackZip/ >/dev/null 2>&1
    mv $AcmeRom/system_ext PackZip/ >/dev/null 2>&1
    cp -rf $AcmeRom/config/ PackZip/ >/dev/null 2>&1
    mv $AcmeRom/boot.img PackZip/prebuilt/ >/dev/null 2>&1
    mv $AcmeRom/exaid.img PackZip/prebuilt/ >/dev/null 2>&1
    mv $AcmeRom/firmware-update PackZip/prebuilt/ >/dev/null 2>&1
    cp -rf bin/prebuilt/* PackZip/ >/dev/null 2>&1
    cd $AcmeRom
    clear
    echo 
    echo 获取分区大小
    sleep 2

    # 确定分区大小
    if [[ -e dynamic_partitions_op_list ]]; then
        a=367001600
    else
        a=0
    fi
    if [[ -f config/system_size.txt ]]; then
        var=$(cat ./config/system_size.txt)
        systemr=$((a+var))
    fi

    if [[ -f size/vendor ]]; then
        var1=$(cat ./config/vendor_size.txt)
        vendorr=$((a+var1))
    fi

    if [[ -f size/product ]]; then
        var2=$(cat ./config/product_size.txt)
        productr=$((a+var2))
    fi

    if [[ -f size/system_ext ]]; then
        var3=$(cat ./config/system_ext_size.txt)
        system_extr=$((a+var3))
    fi

    if [[ $a = 367001600 ]]; then
        #普通动态分区处理
        sed -i 's/'$var'/'$systemr'/g' dynamic_partitions_op_list
        sed -i 's/'$var1'/'$vendorr'/g' dynamic_partitions_op_list
        sed -i 's/'$var2'/'$productr'/g' dynamic_partitions_op_list
        sed -i 's/'$var3'/'$system_extr'/g' dynamic_partitions_op_list

        #卡刷格式的虚拟ab分区处理
        sed -i 's/system_extsize/'$system_extr'/g' dynamic_partitions_op_list
        sed -i 's/systemsize/'$systemr'/g' dynamic_partitions_op_list
        sed -i 's/odmsize/'$var3od'/g' dynamic_partitions_op_list
        sed -i 's/productsize/'$productr'/g' dynamic_partitions_op_list
        sed -i 's/vendorsize/'$vendorr'/g' dynamic_partitions_op_list
    fi

    cd $DIR
    mv $AcmeRom/dynamic_partitions_op_list PackZip/prebuilt/ >/dev/null 2>&1
    clear
    echo 

    if [[ $vabrom = "1" ]]; then
        bin/img2simg $AcmeRom/output/odm.img PackZip/prebuilt/odm.img >/dev/null 2>&1
    else
        bin/img2simg $AcmeRom/odm.img PackZip/prebuilt/odm.img >/dev/null 2>&1
    fi

    cd PackZip
    clear

    # 修复权限
    clear
    echo 
    echo 修复文件权限记录
    sed -i 's/\\//g' config/*_file_contexts
    sed -i 's/\\//g' config/*_fs_config
    sleep 2

    # 开始打包img
    if [ -d "system" ]; then
    clear
    echo
    echo 使用e2fsdroid创建system.img \($systemr字节\)
    echo
    sudo bin/mkuserimg_mke2fs.sh -s "system" "prebuilt/system.img" ext4 / $systemr -j 0 -T 1230768000 -C config/system_fs_config -L / config/system_file_contexts >/dev/null 2>&1
    fi

    if [ -d "system_ext" ]; then
    clear
    echo
    echo 使用e2fsdroid创建system_ext.img \($system_extr字节\)
    echo
    sudo bin/mkuserimg_mke2fs.sh -s "system_ext" "prebuilt/system_ext.img" ext4 system_ext $system_extr -j 0 -T 1230768000 -C config/system_ext_fs_config -L system_ext config/system_ext_file_contexts >/dev/null 2>&1
    fi

    if [ -d "vendor" ]; then
    clear
    echo
    echo 使用e2fsdroid创建vendor.img \($vendorr字节\)
    echo
    sudo bin/mkuserimg_mke2fs.sh -s "vendor" "prebuilt/vendor.img" ext4 vendor $vendorr -j 0 -T 1230768000 -C config/vendor_fs_config -L vendor config/vendor_file_contexts >/dev/null 2>&1
    fi

    if [ -d "product" ]; then
    clear
    echo
    echo 使用e2fsdroid创建product.img \($productr字节\)
    echo
    sudo bin/mkuserimg_mke2fs.sh -s "product" "prebuilt/product.img" ext4 product $productr -j 0 -T 1230768000 -C config/product_fs_config -L product config/product_file_contexts >/dev/null 2>&1
    fi

    # 开始打包dat
    clear
    ls prebuilt/*.img | while read i; do
        line=$(echo "$i" | cut -d"/" -f3| cut -d"." -f1| grep -v "boot"| grep -v "exaid")
        clear
        echo
        echo 创建 $line.new.dat
        echo
        "bin/img2sdat.py" -o "prebuilt/" -v 4 -p $line $i >/dev/null 2>&1
    done

    rm -rf "prebuilt/system_ext.img"
    rm -rf "prebuilt/system.img"
    rm -rf "prebuilt/vendor.img"
    rm -rf "prebuilt/product.img"
    rm -rf "prebuilt/odm.img"

    # 智能判断是否需要打包br
    if [[ $dat = "false" ]]; then
        ls prebuilt/*.new.dat | while read i; do
            line=$(echo "$i" | cut -d"/" -f3| cut -d"." -f1)
            clear
            echo
            echo 创建 $line.new.dat.br
            echo
            brotli -q 5 $i >/dev/null 2>&1
            rm -rf $i
        done
    fi

    # 判断是否打包成功
    cd $DIR
    if [[ -f PackZip/prebuilt/dynamic_partitions_op_list ]]; then
        ls $AcmeRom/*.list | while read i; do
            line=$(echo "$i" | cut -d"/" -f2| cut -d"." -f1)
            if [[ ! -f PackZip/prebuilt/$line.new.dat.br ]]; then
                echo "$AcmeRom制作失败"
                echo "原因: $line.new.dat.br打包失败"
                read -p ""
                exit
            fi
        done
    else
        ls $AcmeRom/*.list | while read i; do
            line=$(echo "$i" | cut -d"/" -f2| cut -d"." -f1)
            if [[ ! -f PackZip/prebuilt/$line.new.dat ]]; then
                echo "$AcmeRom制作失败"
                echo "原因: $line.new.dat打包失败"
                read -p ""
                exit
            fi
        done
    fi

    # 准备打包
    clear
    echo 
    echo 准备打包...
    cd $DIR
    rm -rf PackZip/config >/dev/null 2>&1
    rm -rf PackZip/bin >/dev/null 2>&1
    if [[ $vabrom = "1" ]]; then
        mv $AcmeRom/output PackZip/prebuilt/firmware-update >/dev/null 2>&1
    fi
    cd $DIR
    sudo find ./PackZip/prebuilt/** |while read line; do
        sudo chown -hR $myuser:$myuser "$line"
        sudo chmod 777 "$line"
        touch -mt 200901010000 "$line"
    done
    cd $DIR
    cd PackZip/prebuilt
    clear
    echo 
    echo 生成卡刷包
    echo 
    zip -r 1.zip * >/dev/null 2>&1
    echo 
    clear
    echo 
    echo 计算文件md5
    echo 
    md5=$(md5sum 1.zip | cut -c 1-6)
    cd $DIR
    clear
    mv "PackZip/prebuilt/1.zip" . >/dev/null 2>&1
    files="$device"_"$version"_"$md5"_"$release"_"$android.zip"
    rm -rf $AcmeRom >/dev/null 2>&1
    rm -rf PackZip >/dev/null 2>&1
    clear
    echo "正在检查刷机包大小并自动分割"
    if [ $(ls -l "1.zip" | awk '{print $5}') -gt 2147483647 ]; then
        split -d -b 1999m "1.zip" "output/$files"
    else
        mv "1.zip" "output/$files"
    fi
    start
}
start