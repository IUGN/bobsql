USE query_antipattern;
GO
ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE;
GO
EXEC getcustomer_byid 1;
GO