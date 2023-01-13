#! /usr/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  #Checks if the agrument is a number
  if [[ $1 =~ [0-9] ]]
  then
    #Finds all the properties
    ATOMIC_NUMBER=$1
    ELEMENTS=$($PSQL "SELECT * FROM elements WHERE atomic_number=$ATOMIC_NUMBER;")
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< $ELEMENTS
  fi
  #Checks if the argument is a symbol
  if [[ $1 =~ [a-Z] ]]
  then
    SYMBOL=$1
    ELEMENTS=$($PSQL "SELECT * FROM elements WHERE symbol='$SYMBOL';")
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< $ELEMENTS
  fi
  #Checks if the argument is a name
  if [[ $1 == [A-Za-z]??* ]]
  then
    NAME=$1
    ELEMENTS=$($PSQL "SELECT * FROM elements WHERE name='$NAME';")
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< $ELEMENTS
  fi
  #Check if element exists
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER;")
    IFS='|' read -r ATOMIC_NUMBER MASS MELT BOIL TYPE_ID <<< $PROPERTIES
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi