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

#### useful commands 

```sh
avalanche blockchain create esgibc
avalanche blockchain deploy esgibc
avalanche network start
avalanche network status
avalanche network stop
```

#### ESGIBC RPC URL

Local network

```sh
URL=http://127.0.0.1:56773/ext/bc/6Ct2GEMskErHVUc1jbHuCikKtBuUA9FNC3ALxoBqTPcFrwL9Y/rpc
```

#### How to create an L1 subnet with avalanche-cli

Verify the avalanche version is 1.8.5
Do not work with version 2.0.0

```sh
avalanche --version
```

##### Create a signer (or multiple signers)

```sh
avalanche key create <key-name>
```

That will create an account user with private key located $HOME/.avalanche-cli/key/<key-name>.pk

##### Create a blockchain on local network

```sh
avalanche blockchain create <blockchain-name>
```

###### suggestions for answers

- ? Which Virtual Machine would you like to use?:
-> *Subnet-VM*

- ? Which validator management type would you like to use in your blockchain?:
-> *Proof of Authority*

- ? Which address do you want to enable as controller of ValidatorManager contract?:
-> *Get address from an existing stored key (created from avalanche key create or avalanche key import)*

- ? Which stored key should be used enable as controller of ValidatorManager contract?:
-> *key-name*

- ? Do you want to use default values for the Blockchain configuration?:
-> *I don't want to use default values*

- ? Version:
-> *Use latest release version*

- Chain ID: 
-> *85907431* (Enter an number to identify your blockchain)

- Token Symbol: 
-> *ESGI* (Enter a symbol for the token of your blockchain)

- ? How should the initial token allocation be structured?:
-> *Define a custom allocation (Recommended for production)*

- ? How would you like to modify the initial token allocation?:
-> *Add an address to the initial token allocation*

- Address to allocate to: 
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an avalanche address)

- ? How would you like to modify the initial token allocation?:
-> *Edit the amount of an address in the initial token allocation*

- Address to update the allocation of: 
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an Avalanche address)

- Updated amount to allocate (in ESGI units): 
-> *1070* (Enter an amount of tokens)

- ? How would you like to modify the initial token allocation?:
-> *Confirm and finalize the initial token allocation*

- ? Are you sure you want to finalize this allocation list?:
-> *Yes*

- ? Allow minting of new native tokens?:
-> *Yes, I want to be able to mint additional the native tokens (Native Minter Precompile ON)*

- ? Configure the addresses that are allowed to mint native tokens:
-> *Add an address for a role to the allow list*

- ? What role should the address have?:
-> *Admin*

- Enter the address of the account (or multiple comma separated):
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an avalanche address)

- ? What role should the address have?:
-> *Manager*

- Enter the address of the account (or multiple comma separated):
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an avalanche address)

- ? Configure the addresses that are allowed to mint native tokens:
-> *Confirm Allow List*

- ? Confirm?:
-> *Yes*

- How should the transaction fees be configured on your Blockchain?:
-> *Low block size    / Low Throughput    12 mil gas per block*

- ? Do you want dynamic fees on your blockchain?:
-> *No, I prefer to have constant gas prices*

- ? Should transaction fees be adjustable without a network upgrade?:
-> *No, use the transaction fee configuration set in the genesis block*

- ? Do you want the transaction fees to be burned (sent to a blackhole address)? All transaction fees on Avalanche are burned by default:
-> *No, I want to customize accumulated transaction fees distribution (Reward Manager Precompile ON)*

- ? Configure the addresses that are allowed to customize gas fees distribution:
-> *Add an address for a role to the allow list*

- ? What role should the address have?:
-> *Admin*

- Enter the address of the account (or multiple comma separated):
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an avalanche address)

- ? Configure the addresses that are allowed to customize gas fees distribution:
-> *Confirm Allow List*

- ? Confirm?:
-> *Yes*

- ? Do you want to connect your blockchain with other blockchains or the C-Chain?:
-> *No, I want to run my blockchain isolated*

- ? Do you want to enable anyone to issue transactions and deploy smart contracts to your blockchain?:
-> *No*

- ? Do you want to enable anyone to issue transactions to your blockchain?:
-> *No, I want only approved addresses to issue transactions on my blockchain (Transaction Allow List ON)*

- ? Configure the addresses that are allowed to issue transactions:
-> *Add an address for a role to the allow list*

- ? What role should the address have?:
-> *Admin*

- Enter the address of the account (or multiple comma separated):
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an avalanche address)

- ? Configure the addresses that are allowed to issue transactions:
-> *Add an address for a role to the allow list*

- ? What role should the address have?:
-> *Manager*

- Enter the address of the account (or multiple comma separated):
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an avalanche address)

step confirmation..

- ? Do you want to enable anyone to deploy smart contracts on your blockchain?:
-> *No, I want only approved addresses to deploy smart contracts on my blockchain (Smart Contract Deployer Allow List ON)*

- ? Configure the addresses that are allowed to deploy smart contracts:
-> *Add an address for a role to the allow list*

- ? What role should the address have?:
-> *Admin*

- Enter the address of the account (or multiple comma separated):
-> *0x6abB8fE046d4bDC2b81D619D4046D68d069eE27C* (Enter an avalanche address)

step confirmation..

✓ Successfully created blockchain configuration


To view all created addresses and what their roles are

```sh
avalanche blockchain describe <blockchain-name>
```

##### Deploy the blockchain

```sh
avalanche blockchain deploy <blockchain-name>
```

- ? Choose a network for the operation:
-> *Local Network*

✓ L1 is successfully deployed on Local Network
