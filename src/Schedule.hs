module Schedule where

import Prelude hiding (read)
import Database.HDBC
import Database.HDBC.PostgreSQL
import Data.Time.LocalTime
import qualified Data.ByteString.Char8 as BS

type Id = Integer
type Day = String
type DBTime = LocalTime

createSchedule :: IConnection a => Id -> Day -> DBTime -> DBTime -> a -> IO Bool
createSchedule secId day beg end conn =
    withTransaction conn (createSc' secId day beg end)

createSc' secId day beg end conn = do
    changed <- run conn query [SqlInteger secId, SqlString day, SqlString beg, SqlString end]
    return $ changed == 1
    where
        query = "insert into lab1_schedule (sectionId, beginday, begintime, endtime)" ++
            " values (?, ?, ?, ?)"

readSchedule :: IConnection a => a -> Id -> IO [(Id, Id, Day, DBTime, DBTime)]
readSchedule conn id = do
  rslt <- quickQuery' conn query [SqlInteger id]
  return $ map unpack rslt
  where
      query = "select * from lab1_schedule where id = ?"
      unpack [SqlInteger uid, SqlInteger secId, SqlByteString day, SqlLocalTimeOfDay beg, SqlLocalTimeOfDay end] =
        (uid, secId, BS.unpack day, BS.unpack beg, BS.unpack end)
      unpack x = error $ "Unexpected result: " ++ show x


readAllSchedule :: IConnection a => a -> IO [(Id, Id, Day, DBTime, DBTime)]
readAllSchedule conn = do
  rslt <- quickQuery' conn query []
  return $ map unpack rslt
  where
    query = "select * from lab1_schedule order by id"
    unpack [SqlInteger uid, SqlInteger secId, SqlByteString day, SqlLocalTimeOfDay beg, SqlLocalTimeOfDay end] =
       (uid, secId, BS.unpack day, BS.unpack beg, BS.unpack end)
    unpack x = error $ "Unexpected result: " ++ show x

updateSchedule :: IConnection a => Id -> Id -> Day -> DBTime -> DBTime -> a -> IO Bool
updateSchedule uid secId day beg end conn =
    withTransaction conn (updateSd' uid secId day beg end)

updateSd' uid secId day beg end conn = do
  changed <- run conn query
                 [SqlInteger secId, SqlString day, SqlString beg, SqlString end, SqlInteger uid]
  return $ changed == 1
  where
    query = "update lab1_schedule set sectionId = ?, beginday = ?, " ++
            " begintime = ?, endtime = ? where id = ?"