module Utils where

-- Разработать информационную систему "Информационные ресурсы кафедры".
-- Таблицы БД содержат такую информацию:
-- Название ресурса, автор (....), текст аннотации, вид, назначение,
-- дата открытия для использования, срок использования, условия использования,
-- адреса в сети, информация о пользователях, статистике использования.
-- Поиск по БД. Предусмотреть возможность введения и корректирования информации.
-- Количество таблиц должно быть больше 5.

-- DROP TABLE IF EXISTS authors;
-- CREATE TABLE authors (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(20) NOT NULL,
--     surname VARCHAR(20) NOT NULL
-- );

-- DROP TABLE IF EXISTS catalogs;
-- CREATE TABLE catalogs (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(20) NOT NULL
-- );

-- DROP TABLE IF EXISTS resources;
-- CREATE TABLE resources (
--     id SERIAL PRIMARY KEY,
--     author_id INT(11) NOT NULL,
--     catalog_id INT(11) NOT NULL,
--     title VARCHAR(20) NOT NULL,
--     annotation VARCHAR(50) DEFAULT '',
--     kind VARCHAR(20) DEFAULT '',
--     usage_cond VARCHAR(100) DEFAULT '',
--     link VARCHAR(100) DEFAULT ''
-- );

-- DROP TABLE IF EXISTS users;
-- CREATE TABLE users (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(20) NOT NULL,
--     surname VARCHAR(20) NOT NULL,
--     date_of_birth DATETIME DEFAULT CURRENT_TIMESTAMP
-- );

-- DROP TABLE IF EXISTS activities;
-- CREATE TABLE activities (
--     id SERIAL PRIMARY KEY,
--     user_id INT(11) NOT NULL,
--     resource_id INT(11) NOT NULL
-- );

tableNames = ["activities", "users", "resources", "catalogs", "authors"]

data TableName = Activities | Users | Resources | Catalogs | Authors

toNum str = fromInteger (read (str) :: Integer)

checkTableName :: [Char] -> Bool
checkTableName name = if name `elem` tableNames then True else False

tableColumns :: TableName -> [[Char]]
tableColumns Activities = ["user_id", "resource_id"]
tableColumns Users      = ["name", "surname", "date_of_birth"]
tableColumns Resources  = ["author_id", "catalog_id", "title", "annotation", "kind", "usage_cond", "link"]
tableColumns Catalogs   = ["name"]
tableColumns Authors    = ["name", "surname"]

updatableTableColumns :: [Char] -> [[Char]]
-- updatableTableColumns "accounts"                = ["fullname", "phone", "email"]
-- updatableTableColumns "sport_sections"          = ["name", "description", "trainer"]
-- updatableTableColumns "competitions"            = ["name", "description", "prize"]
-- updatableTableColumns "sport_section_schedules" = ["day", "time"]
-- updatableTableColumns "competition_schedules"   = ["day", "time"]
-- updatableTableColumns "affiliations"            = ["note"]
-- updatableTableColumns "participations"          = ["note"]
updatableTableColumns x                         = []

checkUpdatableColumns :: [Char] -> [Char] -> Bool
checkUpdatableColumns tableName columnName = if columnName `elem` (updatableTableColumns tableName) then True else False

getTableName :: [Char] -> TableName
getTableName  "activities" = Activities
getTableName  "users"      = Users
getTableName  "resources"  = Resources
getTableName  "catalogs"   = Catalogs
getTableName  "authors"    = Authors