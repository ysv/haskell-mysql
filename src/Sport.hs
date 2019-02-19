module Sport where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.ByteString.Char8 as BS

type Id = Integer
type Name = String
type Surname = String
-- type DBTime = LocalTime

createUser :: IConnection a => Name -> Surname -> Id -> a -> IO Bool
createUser name surname sectionId conn =
    withTransaction conn (create' name surname sectionId)

create' name surname sectionId conn = do
    changed <- run conn query [SqlString name, SqlString surname, SqlInteger sectionId]
    return $ changed == 1
    where
        query = "insert into lab1_student (name, surname, sectionId)" ++
            " values (?, ?, ?)"

readUser :: IConnection a => a -> Id -> IO [(Id, Name, Surname, Id)]
readUser conn id = do
  rslt <- quickQuery' conn query [SqlInteger id]
  return $ map unpack rslt
  where
      query = "select * from lab1_student where id = ?"
      unpack [SqlInteger uid, SqlByteString name, SqlByteString surname, SqlInteger sid] =
        (uid, BS.unpack name, BS.unpack surname, sid)
      unpack x = error $ "Unexpected result: " ++ show x


readAll :: IConnection a => a -> IO [(Id, Name, Surname, Id)]
readAll conn = do
  rslt <- quickQuery' conn query []
  return $ map unpack rslt
  where
    query = "select * from lab1_student order by id"
    unpack [SqlInteger uid, SqlByteString name, SqlByteString surname, SqlInteger sid] =
       (uid, BS.unpack name, BS.unpack surname, sid)
    unpack x = error $ "Unexpected result: " ++ show x

updateUser :: IConnection a => Id -> Name -> Surname -> Id -> a -> IO Bool
updateUser uid name surname sid conn =
    withTransaction conn (update' uid name surname sid)

update' uid name surname sid conn = do
  changed <- run conn query
                 [SqlString name, SqlString surname, SqlInteger sid, SqlInteger uid]
  return $ changed == 1
  where
    query = "update lab1_student set name = ?, surname = ?," ++
            " sectionId = ? where id = ?"