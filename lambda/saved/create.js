const AWS = require('aws-sdk');
const config = require('./config.js');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports = function(event, context, callback) {
  'use strict';

  const claims = event.requestContext.authorizer.claims;
  const userId = claims['cognito:username'];
  const body = JSON.parse(event.body);

  console.log('event', event);
  console.log('claims', claims, userId);

  const params = {
		TableName: config.tableName,
    Item: {
      userId: userId,
      gifId: body.gifId,
      gifPreviewUrl: body.gifPreviewUrl,
      collectionId: body.collectionId
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

  console.log('params', params);
  console.log('response pre PUT', response);

  return dynamoDb.put(params)
    .promise()
    .then((res) => {
      console.log('successful PUT', res);
      response.statusCode = 200;
      response.body = JSON.stringify({
        data: res
      });

      callback(null, response);
  	})
    .catch((err) => {
      console.log('bad PUT', err);
      response.statusCode = 400;
      response.body.errors = JSON.stringify([err]);

      callback(null, response);
    });
}
