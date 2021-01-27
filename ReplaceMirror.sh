#!/bin/bash
#Author:SuperManito

#当前系统判定：
function SystemJudgment() {
  ls /etc | grep redhat-release -qw
  if [ $? -eq 0 ];then
    SYSTEM="RedHat"
  else
    SYSTEM="Debian"
  fi

  if [ $SYSTEM = "Debian" ];then
    SYSTEM_NAME=`lsb_release -is`
    SYSTEM_VERSION=`lsb_release -cs`
    SYSTEM_VERSION_NUMBER=`lsb_release -rs`
  elif [ $SYSTEM = "RedHat" ];then
    SYSTEM_NAME=`cat /etc/redhat-release | cut -c1-6`
    if [ $SYSTEM_NAME = "CentOS" ];then
      SYSTEM_VERSION_NUMBER=`cat /etc/redhat-release | cut -c22-24`
    elif [ $SYSTEM_NAME = "Fedora" ];then
      SYSTEM_VERSION_NUMBER=`cat /etc/redhat-release | cut -c16-18`
    fi
  fi
}

#更换国内源
function ReplaceMirror() {
  echo -e '\033[37m+---------------------------------------------------+ \033[0m'
  echo -e '\033[37m|                                                   | \033[0m'
  echo -e '\033[37m|   =============================================   | \033[0m'
  echo -e '\033[37m|                                                   | \033[0m'
  echo -e '\033[37m|         欢迎使用 Linux 一键更换国内源脚本         | \033[0m'
  echo -e '\033[37m|                                                   | \033[0m'
  echo -e '\033[37m|   =============================================   | \033[0m'
  echo -e '\033[37m|                                                   | \033[0m'
  echo -e '\033[37m+---------------------------------------------------+ \033[0m'
  echo -e ''
  echo -e '\033[37m##################################################### \033[0m'
  echo -e ''
  echo -e '\033[37m           提供以下六种国内更新源可供选择： \033[0m'
  echo -e ''
  echo -e '\033[37m##################################################### \033[0m'
  echo -e ''
  echo -e '\033[37m*    1) 中科大 \033[0m'
  echo -e ''
  echo -e '\033[37m*    2) 华为云 \033[0m'
  echo -e ''
  echo -e '\033[37m*    3) 阿里云 \033[0m'
  echo -e ''
  echo -e '\033[37m*    4) 网易 \033[0m'
  echo -e ''
  echo -e '\033[37m*    5) 清华大学 \033[0m'
  echo -e ''
  echo -e '\033[37m*    6) 浙江大学 \033[0m'
  echo -e ''
  echo -e '\033[37m##################################################### \033[0m'
  echo -e ''
  echo -e "\033[37m           当前操作系统  $SYSTEM_NAME $SYSTEM_VERSION_NUMBER \033[0m"
  echo -e "\033[37m           当前系统时间  `date +%Y-%m-%d` `date +%H:%M` \033[0m"
  echo -e ''
  echo -e '\033[37m##################################################### \033[0m'
  echo -e ''
  CHOICE=`echo -e '\033[32m请输入你想使用的国内更新源[1~6]： \033[0m'`
  read -p "$CHOICE" INPUT
  case $INPUT in
  1)
    SOURCE="mirrors.ustc.edu.cn"
    ;;
  2)
    SOURCE="mirrors.huaweicloud.com"
    ;;
  3)
    SOURCE="mirrors.aliyun.com"
    ;;
  4)
    SOURCE="mirrors.163.com"
    ;;
  5)
    SOURCE="mirrors.tuna.tsinghua.edu.cn"
    ;;
  6)
    SOURCE="mirrors.zju.edu.cn"
    ;;
  *)
    SOURCE="mirrors.ustc.edu.cn"
    echo -e ''
    echo -e '\033[33m----------输入错误，更新源将默认使用中科大源---------- \033[0m'
    sleep 3s
    ;;
  esac
  
  if [ $SYSTEM = "Debian" ];then
    DebianSource
  elif [ $SYSTEM = "RedHat" ];then
    RedHatSource
  fi
}

#基Debian系Linux发行版的Source更新源
function DebianMirrors() {
ls /etc/apt | grep sources.list.bak -qw
if [ $? -eq 0 ];then
  echo -e '\033[32m检测到已备份的 source.list源 文件，跳过备份操作...... \033[0m'
else
  cp -rf /etc/apt/sources.list /etc/apt/sources.list.bak
  echo -e '\033[32m已备份原有 source.list 更新源文件...... \033[0m'
fi
sleep 2s
sed -i '1,$d' /etc/apt/sources.list
if [ $SYSTEM_NAME = "Ubuntu" ];then
  echo "deb https://$SOURCE/ubuntu/ $SYSTEM_VERSION main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/ubuntu/ $SYSTEM_VERSION main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb https://$SOURCE/ubuntu/ $SYSTEM_VERSION-security main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/ubuntu/ $SYSTEM_VERSION-security main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb https://$SOURCE/ubuntu/ $SYSTEM_VERSION-updates main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/ubuntu/ $SYSTEM_VERSION-updates main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb https://$SOURCE/ubuntu/ $SYSTEM_VERSION-proposed main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/ubuntu/ $SYSTEM_VERSION-proposed main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb https://$SOURCE/ubuntu/ $SYSTEM_VERSION-backports main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/ubuntu/ $SYSTEM_VERSION-backports main restricted universe multiverse" >> /etc/apt/sources.list
elif [ $SYSTEM_NAME = "Debian" ];then
  echo "deb https://$SOURCE/debian/ $SYSTEM_VERSION main contrib non-free" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/debian/ $SYSTEM_VERSION main contrib non-free" >> /etc/apt/sources.list
  echo "deb https://$SOURCE/debian/ $SYSTEM_VERSION-updates main contrib non-free" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/debian/ $SYSTEM_VERSION-updates main contrib non-free" >> /etc/apt/sources.list
  echo "deb https://$SOURCE/debian/ $SYSTEM_VERSION-backports main contrib non-free" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/debian/ $SYSTEM_VERSION-backports main contrib non-free" >> /etc/apt/sources.list
  echo "deb https://$SOURCE/debian-security $SYSTEM_VERSION/updates main contrib non-free" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/debian-security $SYSTEM_VERSION/updates main contrib non-free" >> /etc/apt/sources.list
elif [ $SYSTEM_NAME = "Kali" ];then
  echo "deb https://$SOURCE/kali $SYSTEM_VERSION main non-free contrib" >> /etc/apt/sources.list
  echo "deb-src https://$SOURCE/kali $SYSTEM_VERSION main non-free contrib" >> /etc/apt/sources.list
fi
apt update
}

#基于RedHat系Linux发行版的repo更新源
function RedHatMirrors() {
  bash <(curl -sL https://github.com/SuperManito/LinuxMirrors/raw/main/RedHat-Official-Source-Generation.sh)
  if [ $SYSTEM_NAME = "CentOS" ];then
    sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/*
    sed -i 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirror.centos.org/centos|g' /etc/yum.repos.d/*
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://mirror.centos.org|g' /etc/yum.repos.d/*
    sed -i "s|mirror.centos.org|$SOURCE|g" /etc/yum.repos.d/*
  elif [ $SYSTEM_NAME = "Fedora" ];then
    sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/*
    /etc/yum.repos.d/fedora.repo \
    /etc/yum.repos.d/fedora-updates.repo \
    /etc/yum.repos.d/fedora-modular.repo \
    /etc/yum.repos.d/fedora-updates-modular.repo \
    fedora-updates-testing.repo \
    fedora-updates-testing-modular.repo
    sed -i 's|^#baseurl=|baseurl=|g' \
    /etc/yum.repos.d/fedora.repo \
    /etc/yum.repos.d/fedora-updates.repo \
    /etc/yum.repos.d/fedora-modular.repo \
    /etc/yum.repos.d/fedora-updates-modular.repo \
    fedora-updates-testing.repo \
    fedora-updates-testing-modular.repo
    sed -i "s|http://download.example/pub/fedora/linux|https://$SOURCE/fedora|g" \
    /etc/yum.repos.d/fedora.repo \
    /etc/yum.repos.d/fedora-updates.repo \
    /etc/yum.repos.d/fedora-modular.repo \
    /etc/yum.repos.d/fedora-updates-modular.repo \
    fedora-updates-testing.repo \
    fedora-updates-testing-modular.repo
  fi
  yum makecache
}

SystemJudgment
ReplaceMirror
