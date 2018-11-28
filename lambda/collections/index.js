const create = require('./create.js');
const get = require('./get.js');
const query = require('./query.js');
const remove = require('./remove.js');
const update = require('./update.js');

exports.handler = function(event, context, callback) {
  'use strict';

  const pathParameters = event.pathParameters || {};
  const collectionId = pathParameters.collectionId;

  switch(event.httpMethod) {
    case 'POST':
      return create(event, context, callback);
      break;

    case 'GET':
      if (collectionId) {
        return get(event, context, callback);
      } else {
        return query(event, context, callback);
      }

      break;

    case 'DELETE':
      return remove(event, context, callback);
      break;

    case 'PUT':
      return update(event, context, callback);
      break;
  }
};
