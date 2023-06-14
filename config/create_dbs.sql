#Cloudera Manager Server        scm     scm
CREATE DATABASE IF NOT EXISTS scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON scm.* TO 'scm'@'%' IDENTIFIED BY 'Scm@132qj';

#Activity Monitor	amon	amon
CREATE DATABASE IF NOT EXISTS amon DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON amon.* TO 'amon'@'%' IDENTIFIED BY 'a@aMo132qj';

#Reports Manager	rman	rman
CREATE DATABASE IF NOT EXISTS rman DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON rman.* TO 'rman'@'%' IDENTIFIED BY 'rMa@n132qj';

#Hue	hue	hue
CREATE DATABASE IF NOT EXISTS hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON hue.* TO 'hue'@'%' IDENTIFIED BY 'hu@En132qj';

#Hive Metastore Server	metastore	hive
CREATE DATABASE IF NOT EXISTS metastore DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON metastore.* TO 'hive'@'%' IDENTIFIED BY 'h@Ivn1e32qj';

#Sentry Server	sentry	sentry
CREATE DATABASE IF NOT EXISTS sentry DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON sentry.* TO 'sentry'@'%' IDENTIFIED BY 'h@senIe3t2qj';

#Cloudera Navigator Audit Server	nav	nav
CREATE DATABASE IF NOT EXISTS nav DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON nav.* TO 'nav'@'%' IDENTIFIED BY 'v@Ivan1e32qj';

#Cloudera Navigator Metadata Server	navms	navms
CREATE DATABASE IF NOT EXISTS navms DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON navms.* TO 'navms'@'%' IDENTIFIED BY 'hS@Ivm1e32qj';

#Oozie	oozie	oozie
CREATE DATABASE IF NOT EXISTS oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL ON oozie.* TO 'oozie'@'%' IDENTIFIED BY 'ih@oIvzn32qj';

flush privileges;
