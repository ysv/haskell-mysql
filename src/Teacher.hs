module Teacher where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.ByteString.Char8 as BS

type Id = Integer
type Name = String
type Surname = String
-- type DBTime = LocalTime

createTeacher :: IConnection a => Name -> Surname -> a -> IO Bool
createTeacher name surname conn =
    withTransaction conn (createT' name surname)

createT' name surname conn = do
    changed <- run conn query [SqlString name, SqlString surname]
    return $ changed == 1
    where
        query = "insert into lab1_teacher (name, surname)" ++
            " values (?, ?)"

readTeacher :: IConnection a => a -> Id -> IO [(Id, Name, Surname)]
readTeacher conn id = do
  rslt <- quickQuery' conn query [SqlInteger id]
  return $ map unpack rslt
  where
      query = "select * from lab1_teacher where id = ?"
      unpack [SqlInteger uid, SqlByteString name, SqlByteString surname] =
        (uid, BS.unpack name, BS.unpack surname)
      unpack x = error $ "Unexpected result: " ++ show x


readAllTeachers :: IConnection a => a -> IO [(Id, Name, Surname)]
readAllTeachers conn = do
  rslt <- quickQuery' conn query []
  return $ map unpack rslt
  where
    query = "select * from lab1_teacher order by id"
    unpack [SqlInteger uid, SqlByteString name, SqlByteString surname] =
       (uid, BS.unpack name, BS.unpack surname)
    unpack x = error $ "Unexpected result: " ++ show x

updateTeacher :: IConnection a => Id -> Name -> Surname -> a -> IO Bool
updateTeacher uid name surname conn =
    withTransaction conn (updateT' uid name surname)

updateT' uid name surname conn = do
  changed <- run conn query
    [SqlString name, SqlString surname, SqlInteger uid]
  return $ changed == 1
  where
    query = "update lab1_teacher set name = ?, surname = ? " ++
            "where id = ?"