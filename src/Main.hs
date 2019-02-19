{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

-- Разработать информационную систему "Информационные ресурсы кафедры".
-- Таблицы БД содержат такую информацию:
-- Название ресурса, автор (....), текст аннотации, вид, назначение,
-- дата открытия для использования, срок использования, условия использования,
-- адреса в сети, информация о пользователях, статистике использования.
-- Поиск по БД. Предусмотреть возможность введения и корректирования информации.
-- Количество таблиц должно быть больше 5.

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import Data.Typeable
import Data.Text.Conversions
import Utils
import ListAll
import FindById
import Create
import Delete

-- tableNames = ["accounts", "sport_sections", "competitions", "sport_section_schedules", "competition_schedules", "affiliations", "participations"]

-- data TableName = Accounts | SportSections | Competitions | SportSectionSchedules | CompetitionSchedules | Affiliations | Participations

-- toNum str = fromInteger (read (str) :: Integer)

-- checkTableName :: [Char] -> Bool
-- checkTableName name = if name `elem` tableNames then True else False

-- tableColumns :: TableName -> [[Char]]
-- tableColumns Accounts              = ["fullname", "phone", "email"]
-- tableColumns SportSections         = ["name", "description", "trainer"]
-- tableColumns Competitions          = ["name", "description", "prize"]
-- tableColumns SportSectionSchedules = ["section_id", "day", "time"]
-- tableColumns CompetitionSchedules  = ["competition_id", "day", "time"]
-- tableColumns Affiliations          = ["section_id", "account_id", "note"]
-- tableColumns Participations        = ["competition_id", "account_id", "note"]

-- updatableTableColumns :: [Char] -> [[Char]]
-- updatableTableColumns "accounts"                = ["fullname", "phone", "email"]
-- updatableTableColumns "sport_sections"          = ["name", "description", "trainer"]
-- updatableTableColumns "competitions"            = ["name", "description", "prize"]
-- updatableTableColumns "sport_section_schedules" = ["day", "time"]
-- updatableTableColumns "competition_schedules"   = ["day", "time"]
-- updatableTableColumns "affiliations"            = ["note"]
-- updatableTableColumns "participations"          = ["note"]
-- updatableTableColumns x                         = []

-- checkUpdatableColumns :: [Char] -> [Char] -> Bool
-- checkUpdatableColumns tableName columnName = if columnName `elem` (updatableTableColumns tableName) then True else False

-- getTableName :: [Char] -> TableName
-- getTableName  "accounts"                = Accounts
-- getTableName  "sport_sections"          = SportSections
-- getTableName  "competitions"            = Competitions
-- getTableName  "sport_section_schedules" = SportSectionSchedules
-- getTableName  "competition_schedules"   = CompetitionSchedules
-- getTableName  "affiliations"            = Affiliations
-- getTableName  "participations"          = Participations

-- class ListAll a where
--   listAll :: a -> MySQLConn -> IO ([ColumnDef],(Streams.InputStream [MySQLValue]))

-- instance ListAll TableName where
--   listAll Accounts conn              = query_ conn "SELECT * FROM accounts"
--   listAll SportSections conn         = query_ conn "SELECT * FROM sport_sections"
--   listAll Competitions conn          = query_ conn "SELECT * FROM competitions"
--   listAll SportSectionSchedules conn = query_ conn "SELECT * FROM sport_section_schedules"
--   listAll CompetitionSchedules conn  = query_ conn "SELECT * FROM competition_schedules"
--   listAll Affiliations conn          = query_ conn "SELECT * FROM affiliations"
--   listAll Participations conn        = query_ conn "SELECT * FROM participations"

-- class FindById a where
--   findById :: a -> [Char] -> MySQLConn -> IO ([ColumnDef],(Streams.InputStream [MySQLValue]))

-- instance FindById TableName where
--   findById Accounts index conn              = query conn "SELECT * FROM accounts WHERE id=?" [MySQLInt32 (toNum index)]
--   findById SportSections index conn         = query conn "SELECT * FROM sport_sections WHERE id=?" [MySQLInt32 (toNum index)]
--   findById Competitions index conn          = query conn "SELECT * FROM competitions WHERE id=?" [MySQLInt32 (toNum index)]
--   findById SportSectionSchedules index conn = query conn "SELECT * FROM sport_section_schedules WHERE id=?" [MySQLInt32 (toNum index)]
--   findById CompetitionSchedules index conn  = query conn "SELECT * FROM competition_schedules WHERE id=?" [MySQLInt32 (toNum index)]
--   findById Affiliations index conn          = query conn "SELECT * FROM affiliations WHERE id=?" [MySQLInt32 (toNum index)]
--   findById Participations index conn        = query conn "SELECT * FROM participations WHERE id=?" [MySQLInt32 (toNum index)]

-- class Create a where
--   createRow :: a -> [[Char]] -> MySQLConn -> IO OK

-- instance Create TableName where
--   createRow Accounts params conn              = execute conn "INSERT INTO accounts (fullname,email,phone) VALUES(?,?,?)" [MySQLText (toText (params!!0)),MySQLText (toText (params!!1)),MySQLText (toText (params!!2))]
--   createRow SportSections params conn         = execute conn "INSERT INTO sport_sections (name,description,trainer) VALUES(?,?,?)" [MySQLText (toText (params!!0)),MySQLText (toText (params!!1)),MySQLText (toText (params!!2))]
--   createRow Competitions params conn          = execute conn "INSERT INTO competitions (name,description,prize) VALUES(?,?,?)" [MySQLText (toText (params!!0)),MySQLText (toText (params!!1)),MySQLText (toText (params!!2))]
--   createRow SportSectionSchedules params conn = execute conn "INSERT INTO sport_section_schedules (section_id,day,time) VALUES(?,?,?)" [MySQLInt32 (toNum (params!!0)),MySQLText (toText (params!!1)),MySQLText (toText (params!!2))]
--   createRow CompetitionSchedules params conn  = execute conn "INSERT INTO competition_schedules (competition_id,day,time) VALUES(?,?,?)" [MySQLInt32 (toNum (params!!0)),MySQLText (toText (params!!1)),MySQLText (toText (params!!2))]
--   createRow Affiliations params conn          = execute conn "INSERT INTO affiliations (section_id,account_id,note) VALUES(?,?,?)" [MySQLInt32 (toNum (params!!0)),MySQLInt32 (toNum (params!!1)),MySQLText (toText (params!!2))]
--   createRow Participations params conn        = execute conn "INSERT INTO participations (competition_id,account_id,note) VALUES(?,?,?)" [MySQLInt32 (toNum (params!!0)),MySQLInt32 (toNum (params!!1)),MySQLText (toText (params!!2))]

-- class Delete a where
--   deleteRow :: a -> [Char] -> MySQLConn -> IO OK

-- instance Delete TableName where
--   deleteRow Accounts index conn              = execute conn "DELETE FROM accounts WHERE id=?" [MySQLInt32 (toNum index)]
--   deleteRow SportSections index conn         = execute conn "DELETE FROM sport_sections WHERE id=?" [MySQLInt32 (toNum index)]
--   deleteRow Competitions index conn          = execute conn "DELETE FROM competitions WHERE id=?" [MySQLInt32 (toNum index)]
--   deleteRow SportSectionSchedules index conn = execute conn "DELETE FROM sport_section_schedules WHERE id=?" [MySQLInt32 (toNum index)]
--   deleteRow CompetitionSchedules index conn  = execute conn "DELETE FROM competition_schedules WHERE id=?" [MySQLInt32 (toNum index)]
--   deleteRow Affiliations index conn          = execute conn "DELETE FROM affiliations WHERE id=?" [MySQLInt32 (toNum index)]
--   deleteRow Participations index conn        = execute conn "DELETE FROM participations WHERE id=?" [MySQLInt32 (toNum index)]

-- class Update a where
--   updateRow :: a -> [Char] -> [Char]-> [Char] -> MySQLConn -> IO OK

-- instance Update TableName where
--   updateRow Accounts "fullname" value index conn          = execute conn "UPDATE accounts SET fullname=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow Accounts "phone" value index conn             = execute conn "UPDATE accounts SET phone=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow Accounts "email" value index conn             = execute conn "UPDATE accounts SET email=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow SportSections "name" value index conn         = execute conn "UPDATE sport_sections SET name=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow SportSections "description" value index conn  = execute conn "UPDATE sport_sections SET description=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow SportSections "trainer" value index conn      = execute conn "UPDATE sport_sections SET trainer=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow Competitions "name" value index conn          = execute conn "UPDATE competitions SET name=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow Competitions "description" value index conn   = execute conn "UPDATE competitions SET description=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow Competitions "prize" value index conn         = execute conn "UPDATE competitions SET prize=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow SportSectionSchedules "day" value index conn  = execute conn "UPDATE sport_section_schedules SET day=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow SportSectionSchedules "time" value index conn = execute conn "UPDATE sport_section_schedules SET time=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow CompetitionSchedules "day" value index conn   = execute conn "UPDATE competition_schedules SET day=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow CompetitionSchedules "time" value index conn  = execute conn "UPDATE competition_schedules SET time=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow Affiliations "note" value index conn          = execute conn "UPDATE affiliations SET note=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
--   updateRow Participations "note" value index conn        = execute conn "UPDATE participations SET note=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]

-- listAllManager :: TableName -> MySQLConn -> IO ()
-- listAllManager tableName conn = do
--   (defs, is) <- listAll tableName conn
--   print (["id"] ++ (tableColumns tableName))
--   mapM_ print =<< Streams.toList is

-- findByManager :: TableName -> MySQLConn -> IO ()
-- findByManager tableName conn = do
--   putStrLn "Enter id: "
--   index <- getLine
--   (defs, is) <- findById tableName index conn
--   print (["id"] ++ (tableColumns tableName))
--   print =<< Streams.toList is

-- createRowManager :: TableName -> MySQLConn -> IO ()
-- createRowManager tableName conn = do
--   putStrLn "Enter these values: "
--   print (intercalate ", " (tableColumns tableName))
--   field1 <- getLine
--   field2 <- getLine
--   field3 <- getLine
--   let params = [field1, field2, field3]
--   createRow tableName params conn
--   putStrLn "Created :)"

-- updateRowManager :: [Char] -> MySQLConn -> IO ()
-- updateRowManager name conn = do
--   putStrLn "Enter row id: "
--   index <- getLine
--   putStrLn "Choose field you want to update from the list: "
--   print (intercalate ", " (updatableTableColumns name))
--   field <- getLine
--   if checkUpdatableColumns name field
--     then do
--       putStrLn "Enter new value: "
--       value <- getLine
--       updateRow (getTableName name) field value index conn
--       putStrLn "Updated :)"
--     else
--       putStrLn "Bye"

-- deleteRowManager :: TableName -> MySQLConn -> IO ()
-- deleteRowManager tableName conn = do
--   putStrLn "Enter id: "
--   index <- getLine
--   deleteRow tableName index conn
--   putStrLn "Deleted :)"

manager :: IO ()
manager = do
  conn <- connect defaultConnectInfo {ciUser = "root", ciDatabase = "data_resources"}

  putStrLn "\n\nChoose table from the list: "
  print (intercalate ", " tableNames)
  name <- getLine

  if checkTableName name
    then do
      putStrLn "0 - list all, 1 - find by id, 2 - create, 3 - update, 4 - delete"
      x <- getLine
      case x of
        "0"       -> listAllManager (getTableName name) conn
        "1"       -> findByManager (getTableName name) conn
        "2"       -> createRowManager (getTableName name) conn
        -- "3"       -> updateRowManager name conn
        "4"       -> deleteRowManager (getTableName name) conn
        otherwise -> putStrLn "Bye"
    else do
      putStrLn "Table doesn't exist :("

  close conn
  manager

main :: IO ()
main = manager
