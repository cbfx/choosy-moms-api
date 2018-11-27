'use strict';

const querystring = require('querystring');
const fetch = require('node-fetch');
const GIPHY = 'https://api.giphy.com';

exports.handler = function(event, context, callback) {
  let fetchParams = {
    method: event.httpMethod
  };
  if (event.body) {
    fetchParams.body = JSON.stringify(event.body);
  }
  const queryParams = querystring.stringify(
    Object.assign(event.queryStringParameters || {}, {
      api_key: process.env.GIPHY_API_KEY
    })
  );

  const giphyUrl = `${GIPHY}/${event.pathParameters.proxy}?${queryParams}`;
  return fetch(giphyUrl, fetchParams)
    .then((res) => {
      return res.json();
    })
    .then((json) => {
      callback(null, {
        isBase64Encoded: false,
        statusCode: json.meta.status,
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(json)
      });
    })
    .catch((err) => {
      return callback(err);
    });
};
