const AWS = require('aws-sdk');
const config = require('./config.js');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports = function(event, context, callback) {
  'use strict';

  const claims = event.requestContext.authorizer.claims;
  const userId = claims['cognito:username'];

  const params = {
		TableName: config.tableName,
    Item: {
      userId: userId,
      gifId: event.body.gifId,
      gifPreviewUrl: event.body.gifPreviewUrl,
      collectionId: event.body.collectionId
    }
	};

  const response = {
    isBase64Encoded: false,
    statusCode: null,
    headers: {
      'Content-Type': 'application/json',
    },
    body: {}
  };

  return dynamoDb.put(params)
    .promise()
    .then((res) => {
      response.statusCode = 200;
      response.body = JSON.stringify({
        data: res
      });

      return callback(null, response);
  	})
    .catch((err) => {
      response.statusCode = 400;
      response.body.errors = JSON.stringify([err]);

      return callback(null, response);
    });
}
