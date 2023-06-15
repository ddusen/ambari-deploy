# Ambari && HDP 离线自动化安装

先在一台机器安装 Ambari，然后通过 Ambari Web 界面安装 HDP。

- Ambari 版本: 2.7.6
- HDP 版本: 3.3.1.0-004
- MySQL 版本: 5.6
- Java 版本: 1.8
- 系统版本: Rocky 8.7

*****

## 前提

1. 从公司云盘下载软件包 hdp-parcels.3.3.1.0-004.20230618.tar.gz 到脚本执行机器中。
- http://119.254.145.21:12225/owncloud/index.php/s/wR6tBJApQoCu8qH
- 如果网盘链接失效，去网盘目录下找该包：03-大数据/05-HDP/hdp-parcels.3.3.1.0-004.20230618.tar.gz
```bash
wget -O /opt/hdp-parcels.3.3.1.0-004.20230618.tar.gz http://119.254.145.21:12225/owncloud/index.php/s/wR6tBJApQoCu8qH/download
```

2. 把压缩包解压到 /var/www/html 目录下
```bash
mkdir -p /var/www/html
tar -zxvf /opt/hdp-parcels.3.3.1.0-004.20230618.tar.gz -C /var/www/html/
```

## 一、Ambari 安装

### 0. 配置环境变量
- 需要手动补充该文件中的配置项
- [./00_env](./00_env)

### 1. 配置集群间ssh免密
- 需要修改 `config/vm_info` 文件
- [./01_sshpass.sh](./01_sshpass.sh)

### 2. 配置所有节点的 hosts
- 需要修改 `config/hosts` 文件
- [./02_hosts.sh](./02_hosts.sh)

### 3. 初始化系统环境
- [./03_init.sh](./03_init.sh)

### 4. 安装 httpd
- [./04_httpd.sh](./04_httpd.sh)

### 5. 安装 java
- [./05_java.sh](./05_java.sh)

### 6. 安装 chrony
- [./06_chrony.sh](./06_chrony.sh)

### 7. 安装 mysql
- [./07_mysql.sh](./07_mysql.sh)


*****

## 二、HDP 安装


## 三、其它
- ambari-parcels.6.3.1466458.tar.gz

```bash
[root@HDP-Ambari-01 html]# tree /var/www/html/ambari-parcels

/var/www/html/ambari-parcels
```

## 四、Refs
1. HDP3.3.1.0-004版本: https://mp.weixin.qq.com/s/FrktFj2qgjsldxHlRgszDg
2. Ambari-2.7.6和HDP-3.3.1安装: http://mp.weixin.qq.com/s?__biz=MzkwODM4NTc4Mw==&mid=2247483799&idx=2&sn=0152829912f367e40aff1d9867ae8f19&chksm=c0cb8d0ff7bc0419bad2649b7d682b43acf0e86e19bb064e92fbda46412ff309a1e8ae7294c2&scene=21#wechat_redirect
3. HDP3.3.1 安装指南（1）: http://mp.weixin.qq.com/s?__biz=MzkwODM4NTc4Mw==&mid=2247483867&idx=1&sn=0270ea5e84002fa42fa5f541380808f3&chksm=c0cb8d43f7bc045503870fbe3114661924f3954c219cc3f018ce7c12af6f21c856efd7f55097&scene=21#wechat_redirect
