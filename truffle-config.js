require('dotenv').config()
const HDWalletProvider = require("truffle-hdwallet-provider");

module.exports = {
  rpc: {
    host: "localhost",
    port: 8080
  },
  networks: {
    // Ganache
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
      from: "0x301f88914faa176DD1DB9ebaFc7C540411fcaAbD"
    },
    // Geth with Websockets support
    // Smart Contract not working with Geth private Blockchain,
    // use Kovan or Ropsten for integration tests
    integration: {
      host: "127.0.0.1",
      port: 8080,
      network_id: "*",
      from: "0x09dd5353c2533492c59e84cbe6e96d1ed3e1dee3"
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(process.env.PRIVATE_KEY, "https://ropsten.infura.io/v3/" + process.env.INFURA_API_KEY)
      },
      network_id: 3,
      gas: 4000000,
      from: "0x76320F542831AE785131ef0683F236fEf4a5500E"
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(process.env.PRIVATE_KEY, "https://kovan.infura.io/v3/" + process.env.INFURA_API_KEY)
      },
      network_id: 42,
      gas: 4700000,
      from: "0x76320F542831AE785131ef0683F236fEf4a5500E"
    },
    live: {
      provider: function() {
        return new HDWalletProvider(process.env.PRIVATE_KEY, "https://mainnet.infura.io/v3/" + process.env.INFURA_API_KEY)
      },
      network_id: 1,
      gas: 4700000,
      from: "0x76320F542831AE785131ef0683F236fEf4a5500E"
    }
  }
};