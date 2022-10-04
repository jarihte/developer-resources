.PHONY	: 	abi
abi		:; 	solc --abi --pretty-json -o ./abi ./interfaces/*.sol --overwrite