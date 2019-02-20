module Utils where

-- Разработать информационную систему "Информационные ресурсы кафедры".
-- Таблицы БД содержат такую информацию:
-- Название ресурса, автор (....), текст аннотации, вид, назначение,
-- дата открытия для использования, срок использования, условия использования,
-- адреса в сети, информация о пользователях, статистике использования.
-- Поиск по БД. Предусмотреть возможность введения и корректирования информации.
-- Количество таблиц должно быть больше 5.

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
updatableTableColumns "activities" = ["user_id", "resource_id"]
updatableTableColumns "users" = ["name", "surname"]
updatableTableColumns "resources" = ["title", "annotation"]
updatableTableColumns "catalogs" = ["name"]
updatableTableColumns "authors" = ["name", "surname"]
updatableTableColumns x = []

checkUpdatableColumns :: [Char] -> [Char] -> Bool
checkUpdatableColumns tableName columnName = if columnName `elem` (updatableTableColumns tableName) then True else False

getTableName :: [Char] -> TableName
getTableName  "activities" = Activities
getTableName  "users"      = Users
getTableName  "resources"  = Resources
getTableName  "catalogs"   = Catalogs
getTableName  "authors"    = Authors