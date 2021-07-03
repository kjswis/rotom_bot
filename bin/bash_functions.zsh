#!/bin/zsh

dbname=$(sed -n -e 's/POSTGRES_DB=\(.*\)/\1/p' $ROTOM_DIR/.env)
dbuser=$(sed -n -e 's/POSTGRES_USER=\(.*\)/\1/p' $ROTOM_DIR/.env)
dbpasswd=$(sed -n -e 's/POSTGRES_PASSWORD=\(.*\)/\1/p' $ROTOM_DIR/.env)

function pkmn-help {
  echo "Bot Commands"
  echo "   pkmn-bot                Refresh containers to reflect new code changes"
  echo "   pkmn-logs               View container logs, add 'follow' to see live logs"
  echo "   pkmn-pry                View the active console to see output"
  echo
  echo "Database Commands"
  echo "   pkmn-db                 Connect to the bot database"
  echo "   pkmn-db-update          Pull in fresh db data and update locally which uses:"
  echo "      pkmn-db-clear        empty existing db"
  echo "      pkmn-db-import       import a fresh db backup"
  echo "      pkmn-db-restore      restore the backup data"
  echo
  echo "Bash and Rake Commands"
  echo "   pkmn-rake task:name     Run the given rake task"
  echo "   pkmn-migrate name:up    Run the given migration task"
  echo "   pkmn-bash [command]     Runs a command if given, or connects to the bot shell"
}

function pkmn-cd {
  cd $ROTOM_DIR
}

function pkmn-bot {
  echo "Refreshing Containers"
  echo "-------------------->"
  docker-compose build
  docker-compose down
  docker-compose up -d

  echo
  echo "Bot Refreshed!"
}

function pkmn-logs {
  if [ $1 = 'follow' ]; then
    docker logs rotom_bot_bot_1 --tail=200 -f
  else
    docker logs rotom_bot_bot_1 --tail=200
  fi
}

function pkmn-pry {
  docker attach rotom_bot_bot_1
}

function pkmn-db {
  docker exec -it rotom_bot_db_1 psql "$dbname" "$dbuser"
}

function pkmn-db-update {
  pkmn-db-clear
  pkmn-db-import
  pkmn-db-restore
}

function pkmn-db-clear {
  echo "Clearing Database $dbname"
  echo "-----------------${dbname//([a-z]|[A-Z]|[0-9]|\.)/-}>"

  docker exec rotom_bot_db_1 psql -U $dbuser -c "DROP DATABASE $dbname;"
  docker exec rotom_bot_db_1 psql -U $dbuser -c "CREATE DATABASE $dbname OWNER $dbuser;"
  echo
}

function pkmn-db-import {
  echo "Importing Postgres Backup Data"
  echo "----------------------------->"
  scp marcie:pmdb .
  docker cp pmdb rotom_bot_db_1:/pmdb
  echo
}

function pkmn-db-restore {
  echo "Updating Database $dbname"
  echo "-----------------${dbname//([a-z]|[A-Z]|[0-9]|\.)/-}>"

  docker exec rotom_bot_db_1 bash -c "psql -U $dbuser -d $dbname < pmdb"
  echo
  echo "Database Refreshed!"
}

function pkmn-bash {
  if [ $1 ]; then
    docker exec rotom_bot_bot_1 sh -c "$1"
  else
    docker exec -it rotom_bot_bot_1 sh
  fi
}

function pkmn-rake {
  echo "Running rake $1"
  echo "-------------${1//([a-z]|[A-Z]|[0-9]|:|_)/-}>"

  docker exec rotom_bot_bot_1 sh -c "rake $1"
}

function pkmn-migrate {
  echo "Running rake migrate:$1"
  echo "---------------------${1//([a-z]|[A-Z]|[0-9]|:|_)/-}>"

  docker exec rotom_bot_bot_1 sh -c "rake migrate:$1"
}
