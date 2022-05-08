# Random Token
A smart contract for ERC721 token with ERC721Enumerable optional extension

# Build, Run, Test
To compile:
``` 
truffle compile 
```

To go to interactive mode:
- Go into develop cli:
```
truffle develop
```
- Deploy:
```
truffle(develop)> migrate
```

# Questions and Choice
- Hard-code variables for sake of simplicity.
- No authority/whitelist needed.
- Will not work if 1 wei price is used (for now).
- owner mint for free but still affect token price.

