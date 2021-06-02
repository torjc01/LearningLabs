DELIMITER $$ 

CREATE PROCEDURE `sp_get_authors`()
BEGIN
    SELECT id, name, city FROM authors;
END $$ 