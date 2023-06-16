#Ambari
CREATE DATABASE IF NOT EXISTS ambari DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS 'ambari'@'%' IDENTIFIED BY 'ambaripasswd';
GRANT ALL ON ambari.* TO 'ambari'@'%';

#Hue	hue	hue
CREATE DATABASE IF NOT EXISTS hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS 'hue'@'%' IDENTIFIED BY 'hu@En132qj';
GRANT ALL ON hue.* TO 'hue'@'%';

#Hive Metastore Server	metastore	hive
CREATE DATABASE IF NOT EXISTS metastore DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS 'hive'@'%' IDENTIFIED BY 'h@Ivn1e32qj';
GRANT ALL ON metastore.* TO 'hive'@'%';

#Sentry Server	sentry	sentry
CREATE DATABASE IF NOT EXISTS sentry DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS 'sentry'@'%' IDENTIFIED BY 'h@senIe3t2qj';
GRANT ALL ON sentry.* TO 'sentry'@'%';

FLUSH PRIVILEGES;
