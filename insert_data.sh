#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # find winner and opponent ids in db
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    # check if winner is not present
    if [[ -z $WINNER_ID ]]
    then
      # insert team
      WINNER_INSERT_RESULT=$($PSQL "INSERT INTO teams(name)VALUES('$WINNER')")
      echo $WINNER_INSERT_RESULT
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi
    # check if opponent is not present
    if [[ -z $OPPONENT_ID ]]
    then
      # insert team
      OPPONENT_INSERT_RESULT=$($PSQL "INSERT INTO teams(name)VALUES('$OPPONENT')")
      echo $OPPONENT_INSERT_RESULT
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
    # insert game info
    GAME_INSERT_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals)VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
    echo $GAME_INSERT_RESULT
  fi
done
