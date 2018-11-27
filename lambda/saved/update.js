import AWS from 'aws-sdk';
import config from './config';

const dynamoDb = new AWS.DynamoDB.DocumentClient();

exports.default = function(event, context, callback) {
  'use strict';

  const { userId } = event.queryStringParameters;

  const params = {
		TableName: config.tableName,
    KeyConditionExpression: "UserId = :u",
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
          items: [...res.Items]
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
