exports.handler = function(event, context, callback) {
  'use strict';

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
