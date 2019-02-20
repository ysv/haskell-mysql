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
import Update

manager :: IO ()
manager = do
  conn <- connect defaultConnectInfo {ciUser = "root", ciDatabase = "data_resources"}

  putStrLn "-------------------------------------------------------------------------------"
  putStrLn "Choose table from the list: "
  putStrLn (intercalate "\n" tableNames)
  name <- getLine

  if checkTableName name
    then do
      putStrLn "l - list all, f - find by id, c - create, u - update, d - delete"
      x <- getLine
      case x of
        "l"       -> listAllManager (getTableName name) conn
        "f"       -> findByManager (getTableName name) conn
        "c"       -> createRowManager (getTableName name) conn
        "u"       -> updateRowManager name conn
        "d"       -> deleteRowManager (getTableName name) conn
        otherwise -> putStrLn "Bye"
    else do
      putStrLn "Table doesn't exist :("

  putStrLn "-------------------------------------------------------------------------------"
  close conn
  manager

main :: IO ()
main = manager
