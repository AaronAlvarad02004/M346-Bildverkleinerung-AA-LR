#!/bin/bash
# Autor: Aaron Alvarado, Larissa Richvalski
# Date: 2023-12-20
# Beschreibung: Skript zum Erstellen der lambda Funktion, der Buckets und der Variablen

BUCKETSOURCE=""
BUCKETDESTINATION=""
RESICEPERCENTAGE= 0

# Erstellen der lambda Funktion
while true; do

    # Name des Buckets abfragen
    echo ""
    echo "Geben sie den Namen des Buckets fuer die originalen Bilder ein: (kleinbuchstaben)"
    # In Variable speichern
    read BUCKETSOURCE

  # Uebpruefen ob Bucket existiert
  RESULT=$(aws s3api head-bucket --bucket $BUCKETSOURCE 2>&1)

	echo $RESULT
  # Ueberpruefen der Antwort
  if [[ $RESULT = *404* ]]
   then
    echo "Bucket $BUCKETSOURCE ist verfuegbar"
    echo ""
    echo "-----------------------------"
    echo ""
    aws s3 mb s3://$BUCKETSOURCE
    echo "-----------------------------"
    break
  else
    echo "Bucket $BUCKETSOURCE ist nicht verfuegbar, bitte nochmals versuchen"
    echo ""
    echo "-----------------------------"
  fi
done
while true; do
# Name des Buckets abfragen
    echo "Geben sie den Namen des Buckets fuer die verkleinerten Bildern ein: (kleinbuchstaben)"
    # In Variable speichern
    read BUCKETDESTINATION

  # Uebpruefen ob Bucket existiert
  RESULT=$(aws s3api head-bucket --bucket $BUCKETDESTINATION 2>&1)

  # Ueberpruefen der Antwort
  if [[ $RESULT = *404* ]] 
  then
    echo "Bucket $BUCKETDESTINATION ist verfuegbar"
    echo ""
    echo "-----------------------------"
    echo ""
    aws s3 mb s3://$BUCKETDESTINATION
    echo "-----------------------------"
    break
  else
    echo "Bucket $BUCKETSESTINATION ist nicht verfuegbar, bitte nochmals versuchen"
    echo ""
    echo "-----------------------------"
    echo ""
  fi
done
while true; do
  echo "Geben Sie einen Prozentsatz fuer die Verkleinerung des Bildes ein (als ganze Zahl, ohne Prozentzeichen)" 
  read RESICEPERCENTAGE

  if [[ $RESICEPERCENTAGE =~ ^[0-9]+$ ]]; then
    echo "Sie haben $RESICEPERCENTAGE% eingegeben."
    break
  else
    echo "Fehler: Sie haben keinen gültigen Prozentsatz eingegeben."
  fi
done


