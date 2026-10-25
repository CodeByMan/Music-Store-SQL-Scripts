USE master;

IF DB_ID(N'MusicStoreSQL') IS NULL
    EXEC(N'CREATE DATABASE MusicStoreSQL');
