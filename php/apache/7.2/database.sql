-- Create primary CakePHP database.
CREATE DATABASE cakephp_live CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER cakephp_live_user@'localhost' IDENTIFIED BY 'b5uF95fstJmhABD4is';
GRANT SELECT, INSERT, UPDATE ON cakephp_live.* TO 'cakephp_live_user'@'localhost';
-- Create test CakePHP database.
CREATE DATABASE cakephp_test CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER cakephp_test_user@'localhost' IDENTIFIED BY '4hiEKuzgFr54fyPVQJ';
GRANT SELECT, INSERT, UPDATE ON cakephp_test.* TO 'cakephp_test_user'@'localhost';
