-- MySQL script that creates two databases for production and testing purposes.
-- The script also creates two users that are used to make the connection to
-- each database.
--
-- Copyright (c) 2018 Justin Hartman <justin@hartman.me> https://justinhartman.blog
-- Repo: https://github.com/justinhartman/docker-cakephp3.6-php7-mysql-apache2
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- Create primary CakePHP database.
CREATE DATABASE cakephp_live CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER cakephp_live_user@'localhost' IDENTIFIED BY 'b5uF95fstJmhABD4is';
GRANT SELECT, INSERT, UPDATE ON cakephp_live.* TO 'cakephp_live_user'@'localhost';

-- Create test CakePHP database.
CREATE DATABASE cakephp_test CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER cakephp_test_user@'localhost' IDENTIFIED BY '4hiEKuzgFr54fyPVQJ';
GRANT SELECT, INSERT, UPDATE ON cakephp_test.* TO 'cakephp_test_user'@'localhost';
