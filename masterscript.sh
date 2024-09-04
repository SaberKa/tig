#!/bin/bash
# Update the package list and install necessary packages
apt update
apt install -y systemd tmux build-essential pkg-config libssl-dev git curl

# Create a systemd service file to run the script after server restart
cat <<EOF > /etc/systemd/system/tig-startup.service
[Unit]
Description=Run Tig Benchmark Script on Startup
After=network.target

[Service]
ExecStart=/root/masterscript.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Enable the service to run on startup
systemctl enable tig-startup.service

# Start a new tmux session named 'tig-session' and run the commands inside it
tmux new-session -d -s tig-session bash -c '
    # Install Rust
    curl --proto =https --tlsv1.3 https://sh.rustup.rs -sSf | sh -s -- -y
    source $HOME/.cargo/env
    export PATH="$HOME/.cargo/bin:$PATH"

    # Clone and set up the repository
    git clone -b benchmarker_v2.0 https://github.com/tig-foundation/tig-monorepo.git
    cd tig-monorepo
    git config --global user.email "kyranmend@gmail.com"
    git config --global user.name "KyranMendoza1"
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vehicle_routing/clarke_wright_super
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git vector_search/optimax_gpu
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git knapsack/quick_knap
    git pull --no-edit --no-rebase https://github.com/tig-foundation/tig-monorepo.git satisfiability/sat_allocd

    # Compile the selected algorithms
    ALGOS_TO_COMPILE="satisfiability_sat_allocd vehicle_routing_clarke_wright_super knapsack_quick_knap vector_search_optimax_gpu"
    cargo build -p tig-benchmarker --release --no-default-features --features "${ALGOS_TO_COMPILE}"

    # Get the number of CPU threads available
    WORKERS=$(nproc)

    # Run the benchmarker with the number of workers set to the number of CPU threads
    SELECTED_ALGORITHMS='"'"'{"satisfiability":"sat_allocd","vehicle_routing":"clarke_wright_super","knapsack":"quick_knap","vector_search":"optimax_gpu"}'"'"'
    ./target/release/tig-benchmarker 0x5de35f527176887b1b42a2703ba4d64e62a48de4 3de214b978b22a7b9c0957ccfc3a95a1 $SELECTED_ALGORITHMS --workers 0
'