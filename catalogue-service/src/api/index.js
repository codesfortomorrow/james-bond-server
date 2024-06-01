const catalogue = require('./catalogue');

/**
 * RequestHandler extends app to handle routes using specific express router
 * 
 * @param app Application
 * @returns void
 */
const RequestHandler = (app) => {
  app.use('/', catalogue);
};

module.exports = RequestHandler;
