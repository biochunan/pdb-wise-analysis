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

# if its environment config file exists, install it from config else build from scratch
if [ -f "${envname}-environment.yaml" ]; then
    conda env update --file "${envname}-environment.yaml" --name $envname
else
    # ****************************************************************
    # CUSTOM PACKAGES 
    # Change this section according to your needs, two types of packages can be installed:
    # 1. conda/pip packages
    # 2. custom packages: COPY from host machine to container
    # ****************************************************************
    # install pytorch 2.1.1
    conda install -y pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
    
    # install torch_geometric 
    pip install torch_geometric
    # Optional dependencies:
    pip install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv \
        -f https://data.pyg.org/whl/torch-2.1.0+cu121.html
    
    # # install esm 
    # pip install fair-esm
    
    # # install igfold from git repo
    # git clone git@github.com:Graylab/IgFold.git 
    # pip install IgFold 
    # rm -rf IgFold
    # conda install -y -c conda-forge openmm==7.7.0 pdbfixer
    # conda install -y -c bioconda abnumber
    
    # extra pakcages 
    # sudo apt insatll -y dssp # installs the latest version of dssp, executable at /usr/bin/dssp, though graphein is not fully supported
    conda install -y -c salilab dssp  # requires libboost 1.73.0 explicitly, installs mkdssp version 3.0.0, executable at /home/vscode/.conda/envs/walle/bin/mkdssp
    conda install -y -c anaconda libboost==1.73.0  # required by dssp 
    pip install loguru biopandas omegaconf pyyaml tqdm wandb \
        torcheval torchmetrics gdown 'graphein[extras]' docker \
        seaborn matplotlib
    conda install -y -c bioconda clustalo  # clustal omega for pairwise alignment
    # ****************************************************************
fi

# cleanup
conda clean -a -y && \
pip cache purge && \
sudo apt autoremove -y 
