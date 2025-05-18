DROP USER IF EXISTS 'mayor'@'%';
CREATE USER 'mayor'@'%' IDENTIFIED BY 'Password.1';
GRANT ALL PRIVILEGES ON * . * TO 'mayor'@'%';