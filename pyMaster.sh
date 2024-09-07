#!/bin/bash
# Update the package list and install necessary packages
apt update
apt install -y tmux build-essential pkg-config libssl-dev git curl

# Start a new tmux session named 'tig-session' and run the commands inside it
tmux new-session -d -s tig-session bash -c '
    # Install Rust
    curl --proto =https --tlsv1.3 https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env
    export PATH="$HOME/.cargo/bin:$PATH"

    # Clone and set up the repository
    git clone -b benchmarker_v2.0 https://github.com/tig-foundation/tig-monorepo.git
    cd tig-monorepo
    git config --global user.email "katrou.saber@gmail.com"
    git config --global user.name "SaberKa"
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vehicle_routing/clarke_wright_super
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vector_search/optimax_gpu
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git knapsack/quick_knap
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git satisfiability/sat_optima

    #build tig-worker
    cargo build -p tig-worker --release

    #run Master
    cd tig-benchmarker
    pip3 install -r requirements.txt
    wget -O /home/saber/tig-monorepo/tig-benchmarker/master/config.py https://raw.githubusercontent.com/SaberKa/tig/main/config.py
    python3 main.py
'
