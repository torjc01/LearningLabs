#!/bin/sh 
# 
# Copies the config file into the docker instance running.
# 
docker cp DDL-Kryptogarten.sql MySQLKrypto:DDL.sql
docker cp DML-Kryptogarten.sql MySQLKrypto:DML.sql
docker cp config.sql MySQLKrypto:config.sql