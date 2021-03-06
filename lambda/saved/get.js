const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports = function(event, context, callback) {
  'use strict';

  const pathParameters = event.pathParameters || {};
  const claims = event.requestContext.authorizer.claims;
  const userId = claims['cognito:username'];
  const gifId = pathParameters['gif-id'];

  const params = {
		TableName: process.env.DYNAMO_TABLE_NAME,
    KeyConditionExpression: "userId = :u and gifId = :g",
    ExpressionAttributeValues: {
      ":u": userId,
      ":g": gifId
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

  return dynamoDb.query(params)
    .promise()
    .then((res) => {
      response.statusCode = 200;
      response.body = JSON.stringify({
        data: {
          items: res.Items
        }
      });

      return callback(null, response);
  	})
    .catch((err) => {
      response.statusCode = 400;
      response.body.errors = JSON.stringify([err]);

      return callback(null, response);
    });
}
