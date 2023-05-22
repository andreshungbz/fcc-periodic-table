#!/bin/bash

# PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# terminate program if there is no given argument
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  # lookup element based on atomic number, element symbol, or element name
  LOOKUP_RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number::VARCHAR='$1' OR symbol='$1' OR name='$1'")

  # in the case that the element does not exist in database
  if [[ -z $LOOKUP_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      # print element details
      echo $LOOKUP_RESULT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MP BP
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
      done
  fi
fi