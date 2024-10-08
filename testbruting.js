const axios = require('axios');
const fs = require('fs')
// Base URL parts (fixed)
let prefix = "https://cdn1.vikaa.fi/552210/exercise5/potplants_cdn/photos/abc709ae/e6cfaa005f7";
let infix = "ffff010b0000";
let listofstarts = ['ecc4b', 'ecfbb', 'ed576', 'edae4', 'ee3a8', 'ee898', 'ef5fc', 'ef9ff', 'ef51e', 'f0afc', 'f3c5c', 'f04d1',
  'f5d38','f5daa', 'f15ae', 'f55c0', 'f0483', 'f3660', 'f4491','f6120']
let startofinfix = '3411'

nrosh = [['ecfbb', '3413'],
      ['ed576', '341e'],
      ['edae4', '342a'],
      ['ee3a8', '3434'],
      ['ee898', '343a'],
      ['ef5fc', '3448'],
      ['ef9ff', '3450'],
      ['ef51e', '3445'],
      ['f0afc', '346f'],
      ['f3c5c', '34d9'],
      ['f04d1', '3462'],
      ['f5d38', '3502'],
      ['f5daa', '3503'],
      ['f15ae', '348f'],
      ['f55c0', '34f3'],
      ['f0483', '3460'],
      ['f3660', '34cd'],
      ['f4491', '34e2'],
      ['f6120', '350c']]

function hexToDecimal(hex) {
  return parseInt(hex, 16);
}
for (let i = 0; i < nrosh.length; i++) {
  let hexxx = nrosh[i]
  console.log([hexToDecimal(hexxx[0]), hexToDecimal(hexxx[1])])
}

// Function to make the HTTP GET request using axios
async function makeRequest(url, index, totalRequests) {
  try {
    const response = await axios.get(url); 
    if (response.status === 200) {
      console.log(`Success: ${url}`); // Log if successful
      fs.writeFile('output.txt', url, (err) => {
          if (err) {
              console.error('Error writing to file:', err);
          } else {
              console.log('File has been written successfully!');
          }
      });
    } else {
      console.log(`Attempt ${index + 1}/${totalRequests}: ${url} - Not found.`);
    }
  } catch (error) {
    
    if (error.response && error.response.status === 429) {
      console.log("Server is blocking. Slow down.");
    } else if (error.response && error.response.status !== 200) {
      console.log(`Attempt ${index + 1}/${totalRequests}: ${url} - Not found.`);
    } else {
      console.log(`Error: ${error.message} and url: ${url}`);
    }
  }
}

function generateHex(startHex, count) {
  let startDec = parseInt(startHex, 16); // Convert starting hex to decimal
  let hexArray = [];

  for (let i = 0; i < count; i++) {
      hexArray.push(startDec.toString(16)); // Convert decimal back to hex and store
      startDec++; // Increment decimal value
  }

  return hexArray;
}

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function decimalToHex(decimal) {
  return decimal.toString(16);
}

async function force() {
  let hex = 3412
  let max = 970683
  let min = 969803

  for (let i = min; i < max; i++) {
    let candidate = prefix + decimalToHex(i) + infix + '3412' + '.png';
    await makeRequest(candidate, i, 1000);
      // Introduce a 200ms delay between requests
    await delay(200); 

  }
}

// 4374 is last one
// 42
// Attempt 10/20: https://cdn1.vikaa.fi/552210/exercise5/potplants_cdn/photos/abc709ae/e6cfaa005f7f0afcffff010b00003433b.png - Not found.
force();