// Autor: Aaron Alvarado, Larissa Richvalsky
// Datum: 2023-12-22
// Version: 1.0
// Beschreibung: Lambda Skript für das Verkleinern eines Bildes

// dependencies
'use strict';

const AWS = require('aws-sdk');
const Sharp = require('sharp');

exports.handler = async function(event, context) {
    try {
        // get reference to S3 client
        const s3bucket1 = new AWS.S3();
        const s3bucket2 = new AWS.S3();

        // Read options from the event.
        console.log("Reading options from event:\n", util.inspect(event, {depth: 5}));
        const srcBucket = event.Records[0].s3.bucket.name;
        const srcKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
        const destBucket = event.Records[0].s3.bucket.name;
        const destKey = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));

        // Gets the percentage from variable
        const resizePerc = process.env.PERCENTAGE_RESIZE;

        console.log(srcBucket);
        console.log(srcKey);

        // Infer the image type.
        const typeMatch = srcKey.match(/\.([^.]*)$/);
        if (!typeMatch) {
            throw new Error('Unable to infer image type for key ' + srcKey);
        }
        const imageType = typeMatch[1];
        if (imageType !== "jpg" && imageType !== "png") {
            console.log('Skipping non-image ' + srcKey);
            return;
        }

        // Download the image from S3, transform, and upload to different S3 bucket with different folders.
        const data = await downloadImage(s3bucket1, srcBucket, srcKey);
        const resizedData = await transformImage(data, imageType, resizePerc);
        await uploadImage(s3bucket2, destBucket, destKey, resizedData);

        console.log('Successfully resized ' + srcBucket + ' and uploaded to ' + destBucket);
    } catch (error) {
        console.error('Unable to resize and upload image:', error);
    }
}

async function downloadImage(s3, bucket, key) {
    const response = await s3.getObject({ Bucket: bucket, Key: key }).promise();
    return response.Body;
}

async function transformImage(data, imageType, resizePerc) {
    return Sharp(data)
        .resize({ percentage: parseFloat(resizePerc) })
        .toBuffer(imageType);
}

async function uploadImage(s3, bucket, key, data) {
    await s3.putObject({ Bucket: bucket, Key: key, Body: data }).promise();
}
