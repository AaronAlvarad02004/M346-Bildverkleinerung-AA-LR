#!/bin/bash
# Autor: Aaron Alvarado, Larissa Richvalski
# Date: 2023-12-20
# Beschreibung: Skript zum Erstellen der lambda Funktion, der Buckets und der Variablen


# Überprüfen, ob aws CLI installiert ist
if command -v aws &> /dev/null
then
    echo "AWS CLI ist bereits installiert."
else
    echo "AWS CLI ist nicht installiert. Beginne mit der Installation."

    # AWS CLI installieren
    sudo apt-get update
    sudo apt-get install -y awscli

    # Überprüfen, ob die Installation erfolgreich war
    if command -v aws &> /dev/null
    then
        echo "AWS CLI wurde erfolgreich installiert."
    else
        echo "Fehler bei der Installation von AWS CLI. Bitte überprüfen Sie die Installationsanweisungen für Ihr System."
        exit 1
    fi
fi
AWS_CONFIG_FILE=~/.aws/config

# Überprüfen, ob die AWS-Konfigurationsdatei existiert
if [ -f "$AWS_CONFIG_FILE" ]; then
    echo "AWS-Konfiguration existiert bereits."
else
    echo "AWS-Konfiguration existiert nicht. Konfiguration wird jetzt erstellt."

    # Konfiguration erstellen
    aws configure
    echo "Geben Sie den Session Token an mit der Variable aws_session_token= :"
    read userInput
    chmod  --recursive 777 ~/.aws
    echo "$userInput" >> ~/.aws/credentials


    # Überprüfen, ob die Konfiguration erfolgreich erstellt wurde
    if [ -f "$AWS_CONFIG_FILE" ]; then
        echo "AWS-Konfiguration erfolgreich erstellt."
    else
        echo "Fehler bei der Erstellung der AWS-Konfiguration."
        exit 1
    fi
fi

BUCKETSOURCE=""
BUCKETDESTINATION=""
RESICEPERCENTAGE=0

ARN=$(aws sts get-caller-identity --query "Account" --output text)

sed -i "s/ACCOUNT_ID/${ARN}/g" index-notification.json

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
  read RESIZEPERCENTAGE

  if [[ $RESIZEPERCENTAGE =~ ^[0-9]+$ ]]; then
    echo "Sie haben $RESIZEPERCENTAGE% eingegeben."
    break
  else
    echo "Fehler: Sie haben keinen gültigen Prozentsatz eingegeben."
  fi
done

# Löschen der lambda Funktion
aws lambda delete-function --function-name imageConverter
# Deployment Package erstellen
zip index.zip index.js
# Erstellen der lambda Funktion
aws lambda create-function --function-name imageConverter --runtime nodejs18.x --role arn:aws:iam::$ARN:role/LabRole --handler index.handler --zip-file fileb://./index.zip --memory-size 256

#aws iam put-role-policy --role-name LabRole --policy-name LabRolePolicy --policy-document file://lab-role-policy.json

# Berechtigung für S3 Bucket und S3 trigger hinzufügen
aws lambda add-permission --function-name imageConverter --action "lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn arn:aws:s3:::$BUCKETSOURCE --statement-id "$BUCKETSOURCE"

aws s3api put-bucket-notification-configuration --bucket "$BUCKETSOURCE" --notification-configuration '{
    "LambdaFunctionConfigurations": [
        {
            "LambdaFunctionArn": "arn:aws:lambda:us-east-1:'$ARN':function:imageConverter",
            "Events": [
                "s3:ObjectCreated:Put"
            ]
        }
    ]
}'

# Die Variablen werden übergeben
aws lambda update-function-configuration --function-name imageConverter --environment "Variables={BUCKETSOURCE=$BUCKETSOURCE,BUCKETDESTINATION=$BUCKETDESTINATION, RESIZEPERCENTAGE=$RESIZEPERCENTAGE}" --query "Environment"

#Das Bild wird in den Source Bucket hochgeladen
aws s3 cp testImage.jpg s3://$BUCKETSOURCE//testImage.jpg

#LATE# STIMAGE=$(aws s3 ls s3://$BUCKETDESTINATION --recursive | sort | tail -n 1 | awk '{print $4}')

# Es Wird ein Verzeichnis erstellt
mkdir ~/CompresedImage

#Die Berechtigung wird geändert
chmod --recursive 777 ~/CompresedImage

#aws s3 cp s3://$BUCKETDESTINATION/$LATESTIMAGE "/home"

echo "Das Bild liegt im Home verzeichnis unter /home/CompresedImage"

sleep 5