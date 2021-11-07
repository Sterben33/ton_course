tondev sol compile PurchaseList.sol
tonos-cli decode stateinit PurchaseList.tvc --tvc

tondev sol compile .\ShoppingDebot.sol

tonos-cli genaddr .\ShoppingDebot.tvc .\ShoppingDebot.abi.json --genkey ShoppingDebot.keys.json > ShoppingDebot.log.log

tonos-cli --url net.ton.dev deploy .\ShoppingDebot.tvc "{}" --sign .\ShoppingDebot.keys.json --abi .\ShoppingDebot.abi.json

tonos-cli --url net.ton.dev call 0:321c18da627816f6a3e10496bf0680860c9010abc981c0b2da0f5ae2b6a02863 setABI dabi.json --sign .\ShoppingDebot.keys.json --abi .\ShoppingDebot.abi.json

tonos-cli --url net.ton.dev run --abi .\ShoppingDebot.abi.json 0:321c18da627816f6a3e10496bf0680860c9010abc981c0b2da0f5ae2b6a02863 getDebotInfo "{}"

tonos-cli --url net.ton.dev call --abi .\ShoppingDebot.abi.json --sign .\ShoppingDebot.keys.json 0:321c18da627816f6a3e10496bf0680860c9010abc981c0b2da0f5ae2b6a02863 setTodoCode .\PurchaseList.decode.json

tonos-cli --url net.ton.dev debot fetch 0:321c18da627816f6a3e10496bf0680860c9010abc981c0b2da0f5ae2b6a02863