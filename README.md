# cryptobot

Задача:
Сделать Wrapped версию контракта классических ботов
Старый контракт ERC721 - https://etherscan.io/address/0xf7a6e15dfd5cdd9ef12711bd757a9b6021abf643
Нужно добавить токен URI 
Нужно сделать так, чтобы было возможно враппить туда-обратно и массово в одну транзакцию (завправить 100 ботов, разврапить 100 ботов)
В старом контракте нет функции approveAll - надо придумать решение
Важно сохранить функцию getBot


Реф:
Cryptopunks (Origin)
Base Contract
https://opensea.io/collection/cryptopunks
https://etherscan.io/address/0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb
Wrapped
https://opensea.io/collection/wrapped-cryptopunks
https://etherscan.io/address/0xb7f7f6c52f2e2fdb1963eab30438024864c313f6
Wrapped Cryptokities
https://etherscan.io/address/0xa10740ff9ff6852eac84cdcff9184e1d6d27c057#writeContracts-wrapper

## Test

### Fork

brownie console --network mainnet-fork

### Run

brownie test -vv -R
