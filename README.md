# eTrustable Smart Contracts

## Testing

    truffle test

## Deploy

For integration environment

    truffle deploy --network integration --reset

For dev environment

    truffle deploy --reset

## Set up Geth node with Websocket support

Set up your environment

[https://medium.com/@chim/ethereum-how-to-setup-a-local-test-node-with-initial-ether-balance-using-geth-974511ce712](https://medium.com/@chim/ethereum-how-to-setup-a-local-test-node-with-initial-ether-balance-using-geth-974511ce712)

Create with the following command two test accounts

    geth --datadir data account new

Create a genesis file with the created accounts

    {
       "config": {
          "chainId": 15,
          "homesteadBlock": 0,
          "eip155Block": 0,
          "eip158Block": 0
      },
      "nonce": "0x0000000000000042",
      "timestamp": "0x0",
      "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
      "gasLimit": "0x8000000",
      "difficulty": "0x400",
      "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
      "coinbase": "0x3333333333333333333333333333333333333333",
      "alloc": {
          "0xd957ff3c27d3e3a6a28db4f7a9e389634ef8c4d0": {
          "balance": "0x1337000000000000000000"},
          "0x966b3b457af326aab8dfd64ca2002eb9123141c9": {
          "balance": "0x2337000000000000000000"}
      }
    }

Init node

    geth --identity "LocalTestNode" --rpc --rpcport 8080 --rpccorsdomain "*" --datadir data/ --port 30303 --nodiscover --rpcapi db,eth,net,web3,personal --networkid 1999 --maxpeers 0 --verbosity 6 init CustomGenesis.json 2>> logs/00.log

Start the node with Websocket support

    geth --identity "LocalTestNode" --rpc --rpcport 8080 --rpccorsdomain "*" --datadir data/ --port 30303 --nodiscover --rpcapi db,eth,net,web3,personal --networkid 1999 --maxpeers 0 -ws --wsaddr="0.0.0.0" --wsorigins "*" --wsport 8546 console

Finally unlock the account you will use as from in Truffle or Geth. You can also use --unlock option when Geth is started

    personal.unlockAccount("0x495ab008c2c6f974e8bc80cde34391b1d901aa3b", 'test')