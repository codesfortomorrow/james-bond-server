const jwt = require('jsonwebtoken');

module.exports = AuthenticateSession = (req, res, next) => {
  const bearerHeader = req.headers['authorization'];
  if (typeof bearerHeader !== 'undefined') {
    const bearer = bearerHeader.split(' ');
    const bearerToken = bearer[1];

    req.token = bearerToken;

    jwt.verify(bearerToken, process.env.JWT_TOKEN_SECRET, (err, data) => {
      if (err) {
        res.sendStatus(403);
        return;
      } else {
        req[req.method === 'GET' ? 'query' : 'body'] = { ...req[req.method === 'GET' ? 'query' : 'body'], ...data };
        next();
      };
    });
  } else {
    res.sendStatus(403);
    return;
  };
}