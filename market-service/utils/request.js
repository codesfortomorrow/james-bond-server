const http = require('http');
const https = require('https');

// Create HTTP/HTTPS agents with keep-alive enabled
const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });

async function getData(url) {
  const client = url.startsWith('https://') ? https : http;
  const agent = url.startsWith('https://') ? httpsAgent : httpAgent;

  const options = {
    agent, // Use the appropriate agent based on the protocol
    timeout: 30000, // Set your desired timeout
  };

  const promise = new Promise((resolve, reject) => {
    client.get(url, options, (res) => {
      let data = [];

      res.on('data', chunk => data.push(chunk));
      res.on('end', async () => {
        if (res.statusCode === 200) {
          try {
            if (data.length) {
              const response = JSON.parse(Buffer.concat(data));
              if (typeof response === 'object')
                resolve(response);
              else {
                console.error(url, response);
                reject(new Error(response));
              }
            } else {
              reject(new Error('Empty response'));
            }
          } catch (e) {
            console.error(url, data, e);
            reject(e);
          }
        } else {
          console.error(url, res.statusMessage);
          reject(new Error(res.statusMessage));
        }
      });
    }).on('error', err => {
      console.error(url, err);
      reject(err);
    });
  });

  return await promise.catch(err => err);
}

module.exports = { getData };
