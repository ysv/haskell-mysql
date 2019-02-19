module Section where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import qualified Data.ByteString.Char8 as BS

type Id = Integer
type Name = String
-- type DBTime = LocalTime

createSection :: IConnection a => Name -> Id -> a -> IO Bool
createSection name tid conn =
    withTransaction conn (createS' name tid)

createS' name tid conn = do
    changed <- run conn query [SqlString name, SqlInteger tid]
    return $ changed == 1
    where
        query = "insert into lab1_section (name, teacherId) " ++
            " values (?, ?)"


readSection :: IConnection a => a -> Id -> IO [(Id, Name, Id)]
readSection conn id = do
  rslt <- quickQuery' conn query [SqlInteger id]
  return $ map unpack rslt
  where
      query = "select * from lab1_section where id = ?"
      unpack [SqlInteger uid, SqlByteString name, SqlInteger tid] =
        (uid, BS.unpack name, tid)
      unpack x = error $ "Unexpected result: " ++ show x


readAllSections :: IConnection a => a -> IO [(Id, Name, Id)]
readAllSections conn = do
  rslt <- quickQuery' conn query []
  return $ map unpack rslt
  where
    query = "select * from lab1_section order by id"
    unpack [SqlInteger uid, SqlByteString name, SqlInteger tid] =
       (uid, BS.unpack name, tid)
    unpack x = error $ "Unexpected result: " ++ show x

updateSection :: IConnection a => Id -> Name -> Id -> a -> IO Bool
updateSection uid name tid conn =
    withTransaction conn (updateSec' uid name tid)

updateSec' uid name tid conn = do
  changed <- run conn query
    [SqlString name, SqlInteger tid, SqlInteger uid]
  return $ changed == 1
  where
    query = "update lab1_section set name = ?, teacherId = ? " ++
            " where id = ?"