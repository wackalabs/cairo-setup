#!/bin/zsh

dir=$(pwd)

shell=$(echo $0)
if [[ $shell == *bash ]]; then
  shell="bash"
else
  shell="zsh"
fi

shellrc=$(echo $HOME/.bashrc)
if [[ $shell == *zsh ]]; then
  shellrc=$(echo $HOME/.zshrc)
fi


echo "[Current directory]: $dir\n"
echo "[Shell env]: $shell ($shellrc)\n"
echo "[OS type]: $OSTYPE\n"

if hash direnv 2>/dev/null; then
  echo "[direnv already installed]\n"
else
  echo "[Installing direnv]\n"
  if [[ $OSTYPE == darwin* ]]; then
    brew install direnv
  else
    curl -sfL https://direnv.net/install.sh | bash
  fi
  eval "$(direnv hook $shell)"
  echo "eval \"\$(direnv hook $shell)\"\n" >> $shellrc
  direnv allow
fi

echo "[Setting up starknet]\n"

if [[ !$STARKNET_NETWORK ]]; then
  export STARKNET_NETWORK=alpha-goerli
  echo "export STARKNET_NETWORK=alpha-goerli" >> $shellrc
fi
if [[ !$STARKNET_WALLET ]]; then
  echo "export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount\n" >> $shellrc
fi

echo "STARKNET_NETWORK:" $STARKNET_NETWORK
echo "STARKNET_WALLET:" $STARKNET_WALLET

echo "\n[Deploying starknet account]\n"

starknet deploy_account
