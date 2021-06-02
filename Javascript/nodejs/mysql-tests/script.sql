DROP DATABASE IF EXISTS sitepoint; 
CREATE DATABASE sitepoint CHARACTER SET utf8 COLLATE utf8_general_ci;

USE sitepoint; 

CREATE TABLE authors(
    id int(11) NOT NULL AUTO_INCREMENT, 
    name varchar(50),
    city varchar(50), 
    PRIMARY KEY(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=5; 

INSERT INTO authors (id, name, city) VALUES (1, 'Julio', 'Brasilia');
INSERT INTO authors (id, name, city) VALUES (2, 'Edjara', 'Quebec');
INSERT INTO authors (id, name, city) VALUES (3, 'Bidao', 'Washington');