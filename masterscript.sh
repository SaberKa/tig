#!/bin/bash
# Update the package list and install necessary packages
apt update
apt install -y tmux build-essential pkg-config libssl-dev git curl

# Clone the repository
git clone -b benchmarker_v2.0 https://github.com/tig-foundation/tig-monorepo.git
cd tig-monorepo
git config --global user.email "kyranmend@gmail.com" # can be anything
git config --global user.name "KyranMendoza1" # can be anything
git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vehicle_routing/clarke_wright_super
git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vector_search/optimax_gpu
git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git knapsack/knapmaxxing
git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git satisfiability/sat_allocd

cd /app

# Install rustup and cargo
bash -c '
curl --proto =https --tlsv1.3 https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env
export PATH="$HOME/.cargo/bin:$PATH"
cd /app/tig-monorepo/tig-benchmarker
ALGOS_TO_COMPILE="satisfiability_sat_allocd vehicle_routing_clarke_wright_super knapsack_knapmaxxing vector_search_optimax_gpu"
cargo fix --lib -p tig-algorithms --allow-dirty
cargo build -p tig-benchmarker --release --no-default-features --features "standalone ${ALGOS_TO_COMPILE}"
'

# Switch to the target release directory
cd /app/tig-monorepo/target/release

# Select algorithms to benchmark
SELECTED_ALGORITHMS='{"satisfiability":"sat_allocd","vehicle_routing":"clarke_wright_super","knapsack":"knapmaxxing","vector_search":"optimax_gpu"}'

# Export the variables so they are available to the tmux session
# Start a new tmux session
tmux new-session -d -s TIG

# Send the export commands and the command to run the benchmarker
tmux send-keys -t TIG "export SELECTED_ALGORITHMS='$SELECTED_ALGORITHMS'" C-m
tmux send-keys -t TIG "./tig-benchmarker 0x5de35f527176887b1b42a2703ba4d64e62a48de4 3de214b978b22a7b9c0957ccfc3a95a1 '$SELECTED_ALGORITHMS' --workers 0" C-m
