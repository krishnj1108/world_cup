#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do 
  # make sure we are not reading in first line (col. names)
  if [[ $YEAR != year ]]
  then
    WIN_EXIST=$($PSQL "select * from teams where name='$WINNER'")
    # if winner team is not found in teams table
    if [[ -z $WIN_EXIST ]]
    then
      INSERT_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
    fi

    OPP_EXIST=$($PSQL "select * from teams where name='$OPPONENT'")
    # if opponent team is not found in teams table
    if [[ -z $OPP_EXIST ]]
    then
      INSERT_TEAM=$($PSQL "insert into teams(name) values('$OPPONENT')")
    fi

    # find winner and opponent ids
    WIN_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    # echo $WIN_ID
    OPP_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    # echo $OPP_ID

    # insert row with game information into games table
    INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_GOALS, $OPP_GOALS)")
    # echo $INSERT_GAME
  fi
done
