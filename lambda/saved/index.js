import create from './create';
import query from './query';
import get from './get';
import remove from './remove';
import update from './update';

exports.handler = function(event, context, callback) {
  const VERB = event.httpMethod;
  const { userId, savedId } = event.pathParameters;

  switch(VERB) {
    case POST: {
      create(event, context, callback);
      break;
    }
    case GET: {
      if (userId && collectionId) {
        get(event, context, callback);
      } else {
        query(event, context, callback);
      }

      break;
    }
    case DELETE: {
      remove(event, context, callback);
      break;
    }
    case PUT: {
      update(event, context, callback);
      break;
    }
  }
};
