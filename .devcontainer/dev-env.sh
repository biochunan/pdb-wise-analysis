#!/bin/zsh

# init conda
conda init zsh 

# source .zshrc to activate conda 
source $HOME/.zshrc

# keep a copy of current working directory
cwd=$(pwd)

# define the environment name e.g. "esm2", "wwpdb", etc. 
envname=pdb-wise-analysis

# if conda env doesn't exist, create it
conda env list | grep -q $envname || conda create -n $envname python=3.11 -y && conda activate $envname

# install jupyter environment 
conda install -y -c conda-forge jupyterlab 
