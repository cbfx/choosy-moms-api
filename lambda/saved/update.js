const AWS = require('aws-sdk');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

module.exports = function(event, context, callback) {
  'use strict';

  const claims = event.requestContext.authorizer.claims;
  const userId = claims['cognito:username'];
  const pathParameters = event.pathParameters || {};
  const gifId = pathParameters.gifId;
  const body = JSON.parse(event.body);

  const params = {
		TableName: process.env.DYNAMO_TABLE_NAME,
    Key: {
      userId,
      gifId
    },
    UpdateExpression: "set gifPreviewUrl = :g, collectionId = :c",
    ExpressionAttributeValues: {
      ":g": body.gifPreviewUrl,
      ":c": body.collectionId
    },
    ReturnValues: "UPDATED_NEW"
	};

  const response = {
    isBase64Encoded: false,
    statusCode: null,
    headers: {
      'Content-Type': 'application/json',
    },
    body: {}
  };

  return dynamoDb.update(params)
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
    })
}
