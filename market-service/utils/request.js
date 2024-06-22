/* eslint-disable @typescript-eslint/no-var-requires */
const http = require('http');
const https = require('https');


const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });

async function getData(url, options = { retries: 3, timeout: 10000 }) {
  let attempts = 0;

  const client = url.startsWith('https://') ? https : http;
  const agent = url.startsWith('https://') ? httpsAgent : httpAgent;

  const mergedOptions = {
    agent,
     timeout: options.timeout,
  };

  while (attempts < options.retries) { 
    attempts++;

    try {
      const response = await new Promise((resolve, reject) => {
        client.get(url, mergedOptions, (res) => {
          let data = [];

          res.on('data', chunk => data.push(chunk));
          res.on('end', async () => {
            if (res.statusCode === 200) {
              try {
                if (data.length) {
                  const response = JSON.parse(Buffer.concat(data));
                  resolve(response); 
                } else {
                  reject(new Error('Empty response')); 
                }
              } catch (e) {
                reject(e); 
              }
            } else {
              reject(new Error(res.statusMessage)); 
            }
          });
        }).on('error', err => {
          reject(err); 
        });
      });

      return response; // Return successful response
    } catch (error) {
      console.error(`getData failed (attempt ${attempts}/${options.retries}):`, url, error);
      // Implement exponential backoff or other retry strategies if needed
    }
  }

  // All retries exhausted, throw final error
  throw new Error(`getData failed after ${options.retries} retries: ${url}`);
}

module.exports = { getData };
