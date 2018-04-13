-- Drops all databases match the given prefix
-- Also drops collection db user

SET NOCOUNT ON;
DECLARE @dbName varchar(50);
DECLARE dbName_cursor INSENSITIVE CURSOR FOR
SELECT QUOTENAME(name) FROM sys.databases WHERE name LIKE '$(prefix)';

OPEN dbName_cursor

FETCH NEXT FROM dbName_cursor
INTO @dbName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @SQL varchar(max);
    SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';' FROM MASTER..SysProcesses WHERE DBId = DB_ID(@dbName) AND SPId <> @@SPId
    EXEC(@SQL)
    PRINT 'Dropping ' + @dbName
    EXEC('DROP DATABASE ' + @dbName)
    PRINT 'Dropped ' + @dbName

    FETCH NEXT FROM dbName_cursor
    INTO @dbName
END

CLOSE dbName_cursor
DEALLOCATE dbName_cursor

IF EXISTS (SELECT loginname from master.dbo.syslogins WHERE NAME = 'collectionuser')
BEGIN
    PRINT 'Dropping collectionuser'
    DROP LOGIN collectionuser
End
