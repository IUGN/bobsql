# Demonstration of internals of log records and blocks

- Show basics of log records with XEvent and sys.fn_dblog()

1. Start this XEvent session and click on watch live databse

CREATE EVENT SESSION [trace_logrecs] ON SERVER 
ADD EVENT sqlserver.transaction_log(
    ACTION(package0.callstack_rva,sqlserver.is_system,sqlserver.session_id)
    WHERE ([database_id]>(5)))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO

1. Create a database but make it simple recovery and turn off ODS

DROP DATABASE IF EXISTS simplerecoverydb;
GO
CREATE DATABASE simplerecoverydb;
GO
ALTER DATABASE simplerecoverydb SET RECOVERY SIMPLE;
GO
ALTER DATABASE simplerecoverydb SET QUERY_STORE = OFF;
GO

2. Create a table first and then use CHECKPOINT to clear the log

USE simplerecoverydb;
GO
DROP TABLE IF EXISTS asimpletable;
GO
CREATE TABLE asimpletable (col1 INT);
GO
CHECKPOINT
GO

3. Use this to see logrecs

SELECT * FROM sys.fn_dblog(NULL);
GO

3. Now show a basic INSERT on a heap

-- Run this and show it doesn't generate a logrec
BEGIN TRAN;

-- Show the logrecs

-- Now run an INSERT and COMMIT
INSERT INTO asimpletable VALUES (1);
COMMIT TRAN;

-- Show the logrecs

Walk throught the logrecs. What are all the other log reocrds for? It is for allocation a page and system table updates.

4. Run an INSERT again (no COMMIT needed) and see what the logrecs look like. Just 3 logrecs now.

Looking at the logrecs can you tell which log records go into a log block together?

5. Create a table to show updates

USE simplerecoverydb;
GO
DROP TABLE IF EXISTS asimpleclusteredtable;
GO
CREATE TABLE asimpleclusteredtable (col1 INT primary key clustered, col2 INT);
GO
INSERT into asimpleclusteredtable VALUES (1, 1);
GO

6. Update the primary key and look at the logrecs

USE simplerecoverydb;
GO
CHECKPOINT;
GO
BEGIN TRAN
UPDATE asimpleclusteredtable SET col1 = 10;
COMMIT TRAN;
GO

Now example log records

7. Now update the non-key column update as in-place but also roll it back

USE simplerecoverydb;
GO
CHECKPOINT;
GO
BEGIN TRAN
UPDATE asimpleclusteredtable SET col2 = 10;
ROLLBACK TRAN;
GO

Now example log recs including rowlog contents for before and aftre images and the COMPENSATION record

8. What does TRUNCATE TABLE look like?

USE simplerecoverydb;
GO
CHECKPOINT;
GO
TRUNCATE TABLE asimpletable;
GO

9. What about CREATE INDEX?

USE simplerecoverydb;
GO
DROP TABLE IF EXISTS bigtab;
GO
CREATE TABLE bigtab (col1 INT, col2 CHAR(7000));
GO
DECLARE @x int;
SET @x = 0;
WHILE (@x < 1000)
BEGIN
	INSERT INTO bigtab VALUES (@x, 'x');
	SET @x = @x + 1;
END
GO
CHECKPOINT;
GO
CREATE UNIQUE CLUSTERED INDEX bigtab_idx ON bigtab (col1);
GO
