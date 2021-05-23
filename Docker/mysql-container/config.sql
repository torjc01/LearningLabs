CREATE USER 'julio'@'%' IDENTIFIED BY '123456'; 

GRANT ALL PRIVILEGES ON *.* TO 'julio'@'%'; 

FLUSH PRIVILEGES; 

SHOW GRANTS FOR 'julio'@'%'; 

select host, user from mysql.user; 

-- DROP USER 'newuser'@'localhost'; 
