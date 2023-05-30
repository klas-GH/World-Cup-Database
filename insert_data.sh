#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE TABLE games, teams;"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT winner_goals opponent_goals
do
  if [[ $WINNER != "winner" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      # echo "WINNER_ID, $WINNER_ID,$WINNER"
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      # echo "OPPONENT_ID, $OPPONENT_ID, $OPPONENT"
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    
    $PSQL "INSERT INTO games(round,year,winner_id,opponent_id,winner_goals,opponent_goals)
       VALUES('$ROUND',$YEAR,$WINNER_ID,$OPPONENT_ID,$winner_goals,$opponent_goals)"

  fi
done
