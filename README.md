# Ambari && HDP 离线自动化安装

先在一台机器安装 Ambari，然后通过 Ambari Web 界面安装 HDP。

- Ambari 版本: 2.7.6.0-22
- HDP 版本: 3.3.2.0-002
- MySQL 版本: 8.0.33
- Java 版本: 1.8
- 系统版本: Centos 7* / Rocky 8*

*****

## 前提

1. 从公司云盘下载软件包 ambari-parcels.20230831.tar.gz 到脚本执行机器中。
- http://127.0.0.1:80/owncloud/index.php/s/TSgLjsyB54ciyzh
- 如果网盘链接失效，去网盘目录下找该包：03-大数据/04-HDP/ambari-parcels.20230831.tar.gz
```bash
wget -O /opt/ambari-parcels.20230831.tar.gz http://127.0.0.1:80/owncloud/index.php/s/TSgLjsyB54ciyzh/download
```

2. 把压缩包解压到 /var/www/html 目录下
```bash
mkdir -p /var/www/html
tar -zxvf /opt/ambari-parcels.20230831.tar.gz -C /var/www/html/
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

### 4. 安装/配置 httpd
- [./04_httpd.sh](./04_httpd.sh)

### 5. 安装/配置 java
- [./05_java.sh](./05_java.sh)

### 6. 安装/配置 chrony
- [./06_chrony.sh](./06_chrony.sh)

### 7. 安装/配置 mysql
- [./07_mysql.sh](./07_mysql.sh)

### 8. 安装/配置 ambari agent
- [./08_ambari_agent.sh](./08_ambari_agent.sh)

### 09. 安/配置装 ambari server
- [./09_ambari_server.sh](./09_ambari_server.sh)

### 10. 配置 hdp
- [./10_hdp.sh](./10_hdp.sh)

*****

## 二、HDP 安装
- ![hdp-01](./images/hdp-01.png)
- ![hdp-02](./images/hdp-02.png)
- ![hdp-03](./images/hdp-03.png)
- ![hdp-04](./images/hdp-04.png)
- ![hdp-05](./images/hdp-05.png)
- ![hdp-06](./images/hdp-06.png)
- ![hdp-07](./images/hdp-07.png)
- ![hdp-08](./images/hdp-08.png)
- ![hdp-09](./images/hdp-09.png)
- ![hdp-10](./images/hdp-10.png)

## 三、其它
1. hue 缺少 MySQL-python
```bash
yum install -y mysql-devel

source /usr/hdp/current/hue/build/env/bin/activate
pip uninstall mysqlclient
pip uninstall mysql-python
pip install mysql-python
```

2. ambari-parcels.6.3.1466458.tar.gz
```bash
/var/www/html/ambari-parcels
|-- ambari
|   `-- 2.7.6.0-22
|       |-- ambari
|       |   |-- ambari-agent-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-infra-manager-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-infra-solr-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-infra-solr-client-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-logsearch-logfeeder-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-logsearch-portal-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-metrics-collector-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-metrics-common-2.7.6.0-22.noarch.rpm
|       |   |-- ambari-metrics-grafana-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-metrics-hadoop-sink-2.7.6.0-22.x86_64.rpm
|       |   |-- ambari-metrics-monitor-2.7.6.0-22.x86_64.rpm
|       |   `-- ambari-server-2.7.6.0-22.x86_64.rpm
|       |-- ambari.repo
|       |-- repodata
|       |   |-- 4d38958a349ed790a806167fe455b1089afb9b7cbbde38d3c1f741a3f3df7ac1-filelists.sqlite.bz2
|       |   |-- 4ecfcec536aca6847e6f566e349f45305e3472062ad9cf2073d443db7104af42-filelists.xml.gz
|       |   |-- 80fa976a237c77bace278a8bdf25c6e06593f0d15116f7da87bd52f006f1d810-other.sqlite.bz2
|       |   |-- aa7c6efcb599f94e67d59a3d314af171db7468f9c2d1530ca0fcbdf62438a561-primary.sqlite.bz2
|       |   |-- bfbeb4a9134eb86fdaf4271e7c9e9924d8ff7beee102501afb9ec74318c42662-primary.xml.gz
|       |   |-- f6bb518f714608643604ece4a63019f317592be9bfd838f414ca73d1c3439f99-other.xml.gz
|       |   `-- repomd.xml
|       `-- RPM-GPG-KEY
|           `-- RPM-GPG-KEY-Jenkins
|-- hdp
|   `-- 3.3.2.0-002
|       |-- atlas-metadata
|       |   |-- atlas-metadata_3_3_2_0_002-2.3.0.3.3.2.0-002.x86_64.rpm
|       |   |-- atlas-metadata_3_3_2_0_002-hbase-plugin-2.3.0.3.3.2.0-002.x86_64.rpm
|       |   |-- atlas-metadata_3_3_2_0_002-hive-plugin-2.3.0.3.3.2.0-002.x86_64.rpm
|       |   |-- atlas-metadata_3_3_2_0_002-kafka-plugin-2.3.0.3.3.2.0-002.x86_64.rpm
|       |   |-- atlas-metadata_3_3_2_0_002-sqoop-plugin-2.3.0.3.3.2.0-002.x86_64.rpm
|       |   `-- atlas-metadata_3_3_2_0_002-storm-plugin-2.3.0.3.3.2.0-002.x86_64.rpm
|       |-- bigtop-jsvc
|       |   `-- bigtop-jsvc-1.0.15-002.x86_64.rpm
|       |-- dolphinscheduler
|       |   `-- dolphinscheduler_3_3_2_0_002-3.1.7.3.3.2.0-002.x86_64.rpm
|       |-- doris
|       |   |-- doris_3_3_2_0_002-be-1.2.6.3.3.2.0-002.x86_64.rpm
|       |   |-- doris_3_3_2_0_002-client-1.2.6.3.3.2.0-002.x86_64.rpm
|       |   |-- doris_3_3_2_0_002-fe-1.2.6.3.3.2.0-002.x86_64.rpm
|       |   `-- doris_3_3_2_0_002-hdfs_broker-1.2.6.3.3.2.0-002.x86_64.rpm
|       |-- flink
|       |   `-- flink_3_3_2_0_002-1.16.2.3.3.2.0-002.x86_64.rpm
|       |-- hadoop
|       |   |-- hadoop_3_3_2_0_002-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-client-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-hdfs-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-hdfs-datanode-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-hdfs-fuse-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-hdfs-journalnode-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-hdfs-namenode-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-hdfs-secondarynamenode-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-hdfs-zkfc-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-httpfs-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-httpfs-server-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-libhdfs-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-mapreduce-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-mapreduce-historyserver-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-yarn-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-yarn-nodemanager-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-yarn-proxyserver-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-yarn-registrydns-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-yarn-resourcemanager-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   |-- hadoop_3_3_2_0_002-yarn-timelinereader-3.3.6.3.3.2.0-002.x86_64.rpm
|       |   `-- hadoop_3_3_2_0_002-yarn-timelineserver-3.3.6.3.3.2.0-002.x86_64.rpm
|       |-- hbase
|       |   |-- hbase_3_3_2_0_002-2.5.5.3.3.2.0-002.x86_64.rpm
|       |   |-- hbase_3_3_2_0_002-doc-2.5.5.3.3.2.0-002.x86_64.rpm
|       |   |-- hbase_3_3_2_0_002-master-2.5.5.3.3.2.0-002.x86_64.rpm
|       |   |-- hbase_3_3_2_0_002-regionserver-2.5.5.3.3.2.0-002.x86_64.rpm
|       |   |-- hbase_3_3_2_0_002-rest-2.5.5.3.3.2.0-002.x86_64.rpm
|       |   |-- hbase_3_3_2_0_002-thrift2-2.5.5.3.3.2.0-002.x86_64.rpm
|       |   `-- hbase_3_3_2_0_002-thrift-2.5.5.3.3.2.0-002.x86_64.rpm
|       |-- HDP-3.3.2.0-001-PATCH.xml
|       |-- HDP-3.3.2.0-001.xml
|       |-- hdp.repo
|       |-- hdp-select
|       |   `-- hdp-select-3.3.2.0-002.x86_64.rpm
|       |-- hive
|       |   |-- hive_3_3_2_0_002-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   |-- hive_3_3_2_0_002-hcatalog-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   |-- hive_3_3_2_0_002-hcatalog-server-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   |-- hive_3_3_2_0_002-jdbc-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   |-- hive_3_3_2_0_002-metastore-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   |-- hive_3_3_2_0_002-server2-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   |-- hive_3_3_2_0_002-server-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   |-- hive_3_3_2_0_002-webhcat-3.1.3.3.3.2.0-002.x86_64.rpm
|       |   `-- hive_3_3_2_0_002-webhcat-server-3.1.3.3.3.2.0-002.x86_64.rpm
|       |-- hue
|       |   `-- hue_3_3_2_0_002-4.11.0.3.3.2.0-002.x86_64.rpm
|       |-- impala
|       |   |-- impala_3_3_2_0_002-4.1.2.3.3.2.0-002.x86_64.rpm
|       |   `-- impala_3_3_2_0_002-shell-4.1.2.3.3.2.0-002.x86_64.rpm
|       |-- kafka
|       |   `-- kafka_3_3_2_0_002-3.5.1.3.3.2.0-002.x86_64.rpm
|       |-- knox
|       |   `-- knox_3_3_2_0_002-2.0.0.3.3.2.0-002.x86_64.rpm
|       |-- kudu
|       |   `-- kudu_3_3_2_0_002-1.16.0.3.3.2.0-002.x86_64.rpm
|       |-- kyuubi
|       |   `-- kyuubi_3_3_2_0_002-1.7.1.3.3.2.0-002.x86_64.rpm
|       |-- livy2
|       |   `-- livy2_3_3_2_0_002-0.8.0.3.3.2.0-002.x86_64.rpm
|       |-- ozone
|       |   `-- ozone_3_3_2_0_002-1.3.0.3.3.2.0-002.x86_64.rpm
|       |-- phoenix
|       |   `-- phoenix_3_3_2_0_002-5.1.3.3.3.2.0-002.x86_64.rpm
|       |-- ranger
|       |   |-- ranger_3_3_2_0_002-admin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-atlas-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-hbase-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-hdfs-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-hive-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-kafka-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-kms-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-knox-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-ozone-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-solr-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-spark3-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-storm-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-tagsync-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   |-- ranger_3_3_2_0_002-usersync-2.4.0.3.3.2.0-002.x86_64.rpm
|       |   `-- ranger_3_3_2_0_002-yarn-plugin-2.4.0.3.3.2.0-002.x86_64.rpm
|       |-- repodata
|       |   |-- 280033bd2242c3aa32363393e9dfd496891fbb93f5bf3f45eb6ad14901af29f0-other.xml.gz
|       |   |-- 3558b8d59c8d6fb67b92b00a40bbd5d42b190d09096a938501ebf2af0313f2c3-primary.xml.gz
|       |   |-- 470e1bdcb9ce5e9012903395f2676c5e840e490e2de087718c0b0c0798307e1a-other.sqlite.bz2
|       |   |-- 9e4bb5de077f681cf6bab57cdb29b1a824d2095ef166859f45143fa220a11fd6-filelists.xml.gz
|       |   |-- a5dc22675309b04a2759313d03eff6f633a39112b87ecf49d0e99b48f7ba9188-filelists.sqlite.bz2
|       |   |-- bf1bdfd71cad4d81e589e8d100da1268ffb8f6b9c489a4cffe8f405719e74ceb-primary.sqlite.bz2
|       |   `-- repomd.xml
|       |-- seatunnel
|       |   `-- seatunnel_3_3_2_0_002-2.3.2.3.3.2.0-002.x86_64.rpm
|       |-- spark2
|       |   |-- spark2_3_3_2_0_002-2.4.8.3.3.2.0-002.x86_64.rpm
|       |   |-- spark2_3_3_2_0_002-master-2.4.8.3.3.2.0-002.x86_64.rpm
|       |   |-- spark2_3_3_2_0_002-python-2.4.8.3.3.2.0-002.x86_64.rpm
|       |   |-- spark2_3_3_2_0_002-worker-2.4.8.3.3.2.0-002.x86_64.rpm
|       |   `-- spark2_3_3_2_0_002-yarn-shuffle-2.4.8.3.3.2.0-002.x86_64.rpm
|       |-- spark3
|       |   |-- spark3_3_3_2_0_002-3.3.2.3.3.2.0-002.x86_64.rpm
|       |   |-- spark3_3_3_2_0_002-master-3.3.2.3.3.2.0-002.x86_64.rpm
|       |   |-- spark3_3_3_2_0_002-python-3.3.2.3.3.2.0-002.x86_64.rpm
|       |   |-- spark3_3_3_2_0_002-worker-3.3.2.3.3.2.0-002.x86_64.rpm
|       |   `-- spark3_3_3_2_0_002-yarn-shuffle-3.3.2.3.3.2.0-002.x86_64.rpm
|       |-- spark-atlas-connector
|       |   `-- spark-atlas-connector_3_3_2_0_002-0.1.0.3.3.2.0-002.x86_64.rpm
|       |-- sqoop
|       |   |-- sqoop_3_3_2_0_002-1.4.7.3.3.2.0-002.x86_64.rpm
|       |   `-- sqoop_3_3_2_0_002-metastore-1.4.7.3.3.2.0-002.x86_64.rpm
|       |-- tez
|       |   `-- tez_3_3_2_0_002-0.10.2.3.3.2.0-002.x86_64.rpm
|       `-- zookeeper
|           |-- zookeeper_3_3_2_0_002-3.8.1.3.3.2.0-002.x86_64.rpm
|           `-- zookeeper_3_3_2_0_002-server-3.8.1.3.3.2.0-002.x86_64.rpm
|-- hdp-utils
|   `-- 1.1.0.22
|       |-- hdp-utils.repo
|       |-- openblas
|       |   |-- openblas-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-devel-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-openmp-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-openmp64-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-openmp64_-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-Rblas-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-serial64-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-serial64_-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-static-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-threads-0.2.19-4.el7.x86_64.rpm
|       |   |-- openblas-threads64-0.2.19-4.el7.x86_64.rpm
|       |   `-- openblas-threads64_-0.2.19-4.el7.x86_64.rpm
|       |-- repodata
|       |   |-- 03caa5dc00c5e38c9d3a33abe86589986f1efb825d982b73dd377889fc70ae2b-filelists.sqlite.bz2
|       |   |-- 392f74ff6f3c9e0e8ef0b933efd5f9d5b08977dd3396772336ee7d71051d460a-filelists.xml.gz
|       |   |-- 395136b97d8b1d5ec9cc5c77ff7de68568d3865675840b3305f6aa42796ac663-other.sqlite.bz2
|       |   |-- 5e1eca162a63e4ea0ecf2bf7cdc394ad97f8ec9966810f18b764e98c3f8bc6e0-primary.xml.gz
|       |   |-- b129db4961099c4fee5efb06e88f9918f2087e524b14de83925efc376027fe36-primary.sqlite.bz2
|       |   |-- b4f6be336c4deaf2eddd958c6dab1d975d6b0274f2b336e58f9075190cc09a5f-other.xml.gz
|       |   `-- repomd.xml
|       |-- RPM-GPG-KEY
|       |   `-- RPM-GPG-KEY-Jenkins
|       `-- snappy
|           |-- snappy-1.1.0-3.el7.i686.rpm
|           |-- snappy-1.1.0-3.el7.x86_64.rpm
|           |-- snappy-devel-1.1.0-3.el7.i686.rpm
|           `-- snappy-devel-1.1.0-3.el7.x86_64.rpm
`-- others
    |-- jdk-8u202-linux-x64.tar.gz
    |-- mysql-8.0-el7-bundle-rpms.tar.gz
    `-- mysql-8.0-el8-bundle-rpms.tar.gz

41 directories, 152 files
```

## 四、Refs
1. HDP3.3.1.0-004版本: https://mp.weixin.qq.com/s/FrktFj2qgjsldxHlRgszDg
2. Ambari-2.7.6和HDP-3.3.1安装: http://mp.weixin.qq.com/s?__biz=MzkwODM4NTc4Mw==&mid=2247483799&idx=2&sn=0152829912f367e40aff1d9867ae8f19&chksm=c0cb8d0ff7bc0419bad2649b7d682b43acf0e86e19bb064e92fbda46412ff309a1e8ae7294c2&scene=21#wechat_redirect
3. HDP3.3.1 安装指南（1）: http://mp.weixin.qq.com/s?__biz=MzkwODM4NTc4Mw==&mid=2247483867&idx=1&sn=0270ea5e84002fa42fa5f541380808f3&chksm=c0cb8d43f7bc045503870fbe3114661924f3954c219cc3f018ce7c12af6f21c856efd7f55097&scene=21#wechat_redirect
4. Centos7/8 RPMS: https://centos.pkgs.org/
