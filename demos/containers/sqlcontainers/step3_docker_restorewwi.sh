sudo docker exec -d sql2017cu10\
  /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'Sql2017isfast' -Q 'RESTORE DATABASE WideWorldImporters FROM DISK = "/var/opt/mssql/WideWorldImporters-Full.bak" WITH MOVE "WWI_Primary" TO "/var/opt/mssql/data/WideWorldImporters.mdf", MOVE "WWI_UserData" TO "/var/opt/mssql/data/WideWorldImporters_userdata.ndf", MOVE "WWI_Log" TO "/var/opt/mssql/data/WideWorldImporters.ldf", MOVE "WWI_InMemory_Data_1" TO "/var/opt/mssql/data/WideWorldImporters_InMemory_Data_1"'
