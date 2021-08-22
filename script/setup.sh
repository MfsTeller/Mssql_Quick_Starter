#!/bin/bash

set -e
echo "MSSQL: INFO: 00001: setup started."

SA_PASSWORD="P@ssw0rdTemp"
##################################################
# parse command line arguments
##################################################
for OPT in "$@"
do
    case $OPT in
        -d | --database)
            if [[ -z "$2" ]] ; then
                echo "MSSQL: ERROR: 00001: option requires an argument -- $1" 1>&2
                exit 1
            fi
            ARG_DATABASE=$2
            shift 2
            ;;
        -- | -)
            shift 1
            param+=( "$@" )
            break
            ;;
        -*)
            echo "MSSQL: ERROR: 00002: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit 1
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                #param=( ${param[@]} "$1" )
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done

##################################################
# update system administrator password
##################################################
# /opt/mssql-tools/bin/sqlcmd \
# -S localhost -U SA -P $SA_PASSWORD \
# -Q 'ALTER LOGIN SA WITH PASSWORD="P@ssw0rd"'

##################################################
# execute each sql file
##################################################
function execute_sql_files_without_option () {
    for sqlfile in $1/*.sql; do
        echo "MSSQL: INFO: 00002: execute SQL file [" $sqlfile "]"
        /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i $sqlfile
    done
}
function execute_sql_files () {
    for sqlfile in $1/*.sql; do
        echo "MSSQL: INFO: 00002: execute SQL file [" $sqlfile "]"
        if [[ -z "$ARG_DATABASE" ]] ; then
            /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -i $sqlfile
        else
            /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -d $ARG_DATABASE -i $sqlfile
        fi
    done
}

DDL_DATABASE_DIR=/opt/workspace/DDL/database
DDL_TABLE_DIR=/opt/workspace/DDL/table
DDL_VIEW_DIR=/opt/workspace/DDL/view
DML_DIR=/opt/workspace/DML

execute_sql_files_without_option $DDL_DATABASE_DIR
execute_sql_files $DDL_TABLE_DIR
execute_sql_files $DDL_VIEW_DIR
execute_sql_files $DML_DIR

# setup completed
echo "MSSQL: INFO: 00002: setup completed."
