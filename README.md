# School Project

## Academic certificates on the blockchain ESGI

### Installation

```sh
forge init certificate
forge install OpenZeppelin/openzeppelin-contracts
```

### Smart contract

- name:
- path: 

### Test

```sh
forge test
forge coverage 
```

### Script

```sh
 forge script script/NFT.s.sol --fork-url $URL --sender $WALLET  --private-key $PK --broadcast
```

### Blockchain ESGI local deployment

- Chain ID = 85907431
- Network RPC URL = http://127.0.0.1:56773/ext/bc/6Ct2GEMskErHVUc1jbHuCikKtBuUA9FNC3ALxoBqTPcFrwL9Y/rpc
- blockchain name = esgibc

#### Create

```sh
avalanche blockchain create esgibc
avalanche blockchain deploy esgibc
```

#### Network

```sh
avalanche network start
avalanche network status
avalanche network stop
```

#### ESGIBC RPC URL

Local network

```sh
URL=http://127.0.0.1:56773/ext/bc/6Ct2GEMskErHVUc1jbHuCikKtBuUA9FNC3ALxoBqTPcFrwL9Y/rpc
```


