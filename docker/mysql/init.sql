-- Village Tree - Initial Database Setup
-- This file runs automatically when the MySQL container is first created.

-- The database is already created via MYSQL_DATABASE env var,
-- so we just ensure proper charset and add any initial setup here.

ALTER DATABASE village_tree CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Test database for PHPUnit/Symfony functional tests
CREATE DATABASE IF NOT EXISTS village_tree_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL PRIVILEGES ON village_tree_test.* TO 'village_tree_user'@'%';
FLUSH PRIVILEGES;
