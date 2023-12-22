// Autor: Aaron Alvarado, Larissa Richvalski
// Datum: 2022-12-20
// Version: 2.0
// Beschreibung: Lambda Skript für das verkleinern der Bilder


'use strict';

const AWS = require('aws-sdk');
const sharp = require('sharp');

exports.handler = async (event, context) => {
    // Erstellt eine neue S3 Instanz
    const s3 = new AWS.S3();
    
    // Holt den Bucket Namen aus dem Event
    const bucket = event.Records[0].s3.bucket.name;

    // Holt den Key des Bildes aus dem Event
    const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));

    // Holt den Resize Wert aus der Umgebungsvariable
    let percentageResize = process.env.RESIZEPERCENTAGE;

    try {
        // Holt das Bild aus dem Bucket
        const data = await s3.getObject({ Bucket: bucket, Key: key }).promise();
        const image = sharp(data.Body);

        // Bildgrösse anpassen
        const metadata = await image.metadata();
        let size = Math.round(metadata.width * percentageResize / 100);
        console.log(`Resizing ${key} to ${size}`);
        let resizedImage = await image.resize(size).toBuffer();

        // Ladet das Bild in den Bucket hoch
        await s3.putObject({
            Body: resizedImage,
            Bucket: process.env.BUCKETDESTINATION,
            Key: `resized-${key}`,
            ContentType: 'image/jpeg'
        }).promise();

        console.log(`Resized ${key} and uploaded to target bucket`);

    } catch (err) {
        console.error(err);
    }
};