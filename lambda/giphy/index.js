'use strict';

exports.handler = function (event, context, callback) {
  const response = {
    isBase64Encoded: false,
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({"lambda": "giphy"}),
  };
  callback(null, response);
};
