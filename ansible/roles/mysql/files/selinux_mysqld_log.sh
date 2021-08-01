#!/usr/bin/env bash
cd /root
if [[ ! -e /root/mysqld_log.pp && -e /root/mysqld_log.te ]]
    then
        checkmodule -M -m  ./mysqld_log.te -o ./mysqld_log.mod
        semodule_package -m ./mysqld_log.mod -o ./mysqld_log.pp
        semodule -i ./mysqld_log.pp

fi
