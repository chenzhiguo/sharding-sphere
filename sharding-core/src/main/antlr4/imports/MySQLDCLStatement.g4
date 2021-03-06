grammar MySQLDCLStatement;

import MySQLKeyword, Keyword, BaseRule, DataType, Symbol;

grantPriveleges
    : GRANT privType columnList? (COMMA privType columnList?)*
    ON objectType? privLevel
    TO userOrRoles
    (WITH GRANT OPTION)?
    ;

privType
    : ALL PRIVILEGES?
    | ALTER ROUTINE?
    | CREATE (ROUTINE | TEMPORARY TABLES? | USER | VIEW)?
    | DELETE
    | DROP
    | EVENT
    | EXECUTE
    | FILE
    | GRANT OPTION
    | INDEX
    | INSERT
    | LOCK TABLES
    | PROCESS
    | PROXY
    | REFERENCES
    | RELOAD
    | REPLICATION CLIENT
    | REPLICATION SLAVE
    | SELECT
    | SHOW DATABASES
    | SHOW VIEW
    | SHUTDOWN
    | SUPER
    | TRIGGER
    | UPDATE
    | USAGE
    | AUDIT_ADMIN
    | BINLOG_ADMIN
    | CONNECTION_ADMIN
    | ENCRYPTION_KEY_ADMIN
    | FIREWALL_ADMIN
    | FIREWALL_USER
    | GROUP_REPLICATION_ADMIN
    | REPLICATION_SLAVE_ADMIN
    | ROLE_ADMIN
    | SET_USER_ID
    | SYSTEM_VARIABLES_ADMIN
    | VERSION_TOKEN_ADMIN
    ;

objectType
    : TABLE | FUNCTION | PROCEDURE
    ;

privLevel
    : ASTERISK
    | ASTERISK DOT ASTERISK
    | schemaName DOT ASTERISK
    | schemaName DOT tableName
    | tableName
    | schemaName DOT routineName
    ;

user
    : STRING AT_ STRING | STRING | ID
    ;

users
    : user (COMMA user)*
    ;

role
    : STRING AT_ STRING | STRING | ID
    ;

roles
    : role (COMMA role)*
    ;

userOrRole
    : user | role
    ;

userOrRoles
    : userOrRole (COMMA userOrRole)*
    ;

grantProxy
    : GRANT PROXY ON userOrRole TO userOrRoles (WITH GRANT OPTION)?
    ;

grantRoles
    : GRANT roleNames TO userOrRoles (WITH ADMIN OPTION)?
    ;

revokePriveleges
    : REVOKE privType columnList? (COMMA privType columnList?)*
    ON objectType? privLevel
    FROM userOrRoles
    ;

revokeAllPriveleges
    : REVOKE ALL PRIVILEGES? COMMA GRANT OPTION
    FROM userOrRoles
    ;

revokeProxy
    : REVOKE PROXY ON userOrRole
    FROM userOrRoles
    ;

revokeRoles
    : REVOKE roleNames
    FROM userOrRoles
    ;

createUser
    : CREATE USER (IF NOT EXISTS)?
    user authOptions?
    DEFAULT ROLE roles
    (REQUIRE (NONE | tlsOption (COMMA AND? tlsOption)*))?
    (WITH resourceOption (COMMA resourceOption)*)?
    (passwordOption | lockOption)*
    ;

authOption
    : IDENTIFIED BY STRING (REPLACE STRING)? (RETAIN CURRENT PASSWORD)?
    | IDENTIFIED WITH authPlugin
    | IDENTIFIED WITH authPlugin BY STRING (REPLACE STRING)? (RETAIN CURRENT PASSWORD)?
    | IDENTIFIED WITH authPlugin AS STRING
    | DISCARD OLD PASSWORD
    ;

authOptions
    : authOption (COMMA authOption)*
    ;

authPlugin
    : ID
    ;

tlsOption
    : SSL | CIPHER STRING | ISSUER STRING | SUBJECT STRING | ID
    ;

resourceOption
    : MAX_QUERIES_PER_HOUR NUMBER
    MAX_UPDATES_PER_HOUR NUMBER
    MAX_CONNECTIONS_PER_HOUR NUMBER
    MAX_USER_CONNECTIONS NUMBER
    ;

passwordOption
    : PASSWORD EXPIRE (DEFAULT | NEVER | INTERVAL NUMBER DAY)?
    | PASSWORD HISTORY (DEFAULT | NUMBER)
    | PASSWORD REUSE INTERVAL (DEFAULT | NUMBER DAY)
    | PASSWORD REQUIRE CURRENT (DEFAULT | OPTIONAL)?
    ;

lockOption
    : ACCOUNT (LOCK | UNLOCK)
    ;

alterUser
    : ALTER USER (IF EXISTS)?
    user authOptions
    (REQUIRE (NONE | tlsOption (COMMA AND? tlsOption)*))?
    (WITH resourceOption (COMMA resourceOption)*)?
    (passwordOption | lockOption)*
    ;

alterCurrentUser
    : ALTER USER (IF EXISTS)? USER() userFuncAuthOption
    ;

userFuncAuthOption
    : IDENTIFIED BY STRING (REPLACE STRING)? (RETAIN CURRENT PASSWORD)?
    | DISCARD OLD PASSWORD
    ;

alterUserRole
    : ALTER USER (IF EXISTS)?
    user DEFAULT ROLE
    (NONE | ALL | roles)
    ;

dropUser
    : DROP USER (IF EXISTS)? users
    ;

renameUser
    : RENAME USER user TO user (user TO user)*
    ;

createRole
    : CREATE ROLE (IF NOT EXISTS)? roles
    ;

dropRole
    : DROP ROLE (IF EXISTS)? roles
    ;

setPassword
    : SET PASSWORD (FOR user)? EQ STRING (REPLACE STRING)? (RETAIN CURRENT PASSWORD)?
    ;

setDefaultRole
    : SET DEFAULT ROLE (NONE | ALL | roles) TO users
    ;

setRole
    : SET ROLE (DEFAULT | NONE | ALL | ALL EXCEPT roles | roles)
    ;
