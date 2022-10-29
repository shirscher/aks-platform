docker run \
  -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=SA-P@ssw0rd" \
  -p 1433:1433 \
  -d \
  --name node-app-db \
  mcr.microsoft.com/mssql/server:2019-CU18-ubuntu-20.04
