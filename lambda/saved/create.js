const AWS = require('aws-sdk');
const config = require('./config.js');
const dynamoDb = new AWS.DynamoDB.DocumentClient();

exports.default = function(event, context, callback) {
  'use strict';

  const queryStringParameters = event.queryStringParameters || {};
  const userId = queryStringParameters.userId;

  const params = {
		TableName: config.tableName,
    KeyConditionExpression: "userId = :u",
    ExpressionAttributeValues: {
      ":u": userId
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

      return res;
  	})
    .catch((err) => {
      response.statusCode = err.output.statusCode;
      response.body.errors = JSON.stringify([{
        title: err.output.payload.error,
        detail: err.message,
        status: err.output.statusCode.toString(),
      }]);

      return err;
    })
    .finally(() => {
      callback(null, response);
    });
}
