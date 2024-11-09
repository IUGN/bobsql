USE MASTER;
GO
DROP DATABASE IF EXISTS bulklogdb;
GO
CREATE DATABASE bulklogdb;
GO
ALTER DATABASE bulklogdb
SET RECOVERY BULK_LOGGED;
GO
ALTER DATABASE bulklogdb
SET QUERY_STORE = OFF;
GO
