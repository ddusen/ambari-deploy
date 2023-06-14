# CDH 离线安装部署

先在一台机器安装 CM，然后通过 CM Web界面安装 CDH。

- CM 版本：6.3.1
- CDH 版本：6.3.2
- MySQL 版本：5.6
- Java 版本：1.8
- 系统版本：Centos 7.6

*****

## 前提

1. 从公司云盘下载软件包 cloudera-parcels.6.3.1.20230420.tar.gz 到脚本执行机器中。
- http://119.254.145.21:12225/owncloud/index.php/s/wR6tBJApQoCu8qH
- 如果网盘链接失效，去网盘目录下找该包：03-大数据/01-CDH/cloudera-parcels.6.3.1.20230420.tar.gz
```bash
wget -O /opt/cloudera-parcels.6.3.1.20230420.tar.gz http://119.254.145.21:12225/owncloud/index.php/s/wR6tBJApQoCu8qH/download
```

2. 把压缩包解压到 /var/www/html 目录下
```bash
mkdir -p /var/www/html
tar -zxvf /opt/cloudera-parcels.6.3.1.20230420.tar.gz -C /var/www/html/
```

## 一、CM 安装

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

### 6. 安装 ntp
- 需要修改 `config/ntp_clients` 中的 ntp server ip `10.0.2.63`
- [./06_ntp.sh](./06_ntp.sh)

### 7. 安装 mysql
- [./07_mysql.sh](./07_mysql.sh)

### 8. 安装 cloudera manager agent
- 需要 `config/cm_agent` 中的 `server_host` 变量
- [./08_cm_agent.sh](./08_cm_agent.sh)

### 9. 安装 cloudera manager server
- 需要 `config/cm_server` 中的 `*.host` 变量
- [./09_cm_server.sh](./09_cm_server.sh)

*****

## 二、CDH 安装

- ![cdh-00](./images/cdh-00.png)
- ![cdh-01](./images/cdh-01.png)
- ![cdh-02](./images/cdh-02.png)
- ![cdh-03](./images/cdh-03.png)
- ![cdh-04](./images/cdh-04.png)
- ![cdh-05](./images/cdh-05.png)
- ![cdh-06](./images/cdh-06.png)
- ![cdh-07](./images/cdh-07.png)


## 三、其它
- cloudera-parcels.6.3.1466458.tar.gz

```bash
[root@cdh-cm-01 html]# tree /var/www/html/cloudera-parcels

/var/www/html/cloudera-parcels
|-- cdh6
|   `-- 6.3.2
|       |-- parcels
|       |   |-- CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel
|       |   |-- CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha
|       |   |-- CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha1
|       |   |-- CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent
|       |   |-- CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent.sha
|       |   |-- CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent.sha1
|       |   `-- manifest.json
|       `-- repodata
|           |-- 3a35421df8da570216fafda251a8cd1a4c2fc37155d1d18010b5f5a46bdc0a5d-primary.xml.gz
|           |-- 710c575c5de134cb3c6ea77351f88d00023989fede649d86e3c9e8ff50cb682d-primary.sqlite.bz2
|           |-- 8167eea778b6a0b03ead6727b79688abbc73e60039a8b13b1bae0a4733859101-filelists.sqlite.bz2
|           |-- bfdce844b7bda72ee4ce3112b02ee6f4f197064fe1a431596d80a6c35a615e43-filelists.xml.gz
|           |-- d127523a2c5208b48b95b77c8dc84ac96c977f9a0ed62277b6c121940f4df9c8-other.sqlite.bz2
|           |-- e73de49a28463ac284f0ed931d8628a5f6d2cee86f219c4a23e53d6c2a0516af-other.xml.gz
|           `-- repomd.xml
|-- cm6
|   `-- 6.3.1
|       |-- allkeys.asc
|       |-- cloudera-manager-agent-6.3.1-1466458.el7.x86_64.rpm
|       |-- cloudera-manager-daemons-6.3.1-1466458.el7.x86_64.rpm
|       |-- cloudera-manager-server-6.3.1-1466458.el7.x86_64.rpm
|       |-- manifest.json
|       |-- repodata
|       |   |-- 3a35421df8da570216fafda251a8cd1a4c2fc37155d1d18010b5f5a46bdc0a5d-primary.xml.gz
|       |   |-- 710c575c5de134cb3c6ea77351f88d00023989fede649d86e3c9e8ff50cb682d-primary.sqlite.bz2
|       |   |-- 8167eea778b6a0b03ead6727b79688abbc73e60039a8b13b1bae0a4733859101-filelists.sqlite.bz2
|       |   |-- bfdce844b7bda72ee4ce3112b02ee6f4f197064fe1a431596d80a6c35a615e43-filelists.xml.gz
|       |   |-- d127523a2c5208b48b95b77c8dc84ac96c977f9a0ed62277b6c121940f4df9c8-other.sqlite.bz2
|       |   |-- e73de49a28463ac284f0ed931d8628a5f6d2cee86f219c4a23e53d6c2a0516af-other.xml.gz
|       |   `-- repomd.xml
|       |-- RPM-GPG-KEY-cloudera
|       `-- RPMS
|           `-- x86_64
|               `-- oracle-j2sdk1.8-1.8.0+update181-1.x86_64.rpm
`-- others
    |-- commons-httpclient-3.1.jar.tar.gz
    |-- elasticsearch-hadoop-6.3.0.jar.tar.gz
    |-- jdk-8u202-linux-x64.tar.gz
    |-- mysql5.6.tar.gz
    `-- mysql-connector-java.jar.tar.gz

10 directories, 33 files
```
