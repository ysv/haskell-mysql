class ListAll a where
    listAll :: a -> MySQLConn -> IO ([ColumnDef],(Streams.InputStream [MySQLValue]))
  
  instance ListAll TableName where
    listAll Accounts conn              = query_ conn "SELECT * FROM accounts"
    listAll SportSections conn         = query_ conn "SELECT * FROM sport_sections"
    listAll Competitions conn          = query_ conn "SELECT * FROM competitions"
    listAll SportSectionSchedules conn = query_ conn "SELECT * FROM sport_section_schedules"
    listAll CompetitionSchedules conn  = query_ conn "SELECT * FROM competition_schedules"
    listAll Affiliations conn          = query_ conn "SELECT * FROM affiliations"
    listAll Participations conn        = query_ conn "SELECT * FROM participations"