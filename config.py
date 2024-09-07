PLAYER_ID = "0xff45c36b3177e04837a0625cf107c1f52fbbf984" # your player_id
API_KEY = "aae29ef9068f0436966a7fb03af82e57" # your api_key
TIG_WORKER_PATH = "/home/saber/tig-monorepo/target/release/tig-worker" # path to executable tig-worker
TIG_ALGORITHMS_FOLDER = "/home/saber/tig-monorepo/tig-algorithms" # path to tig-algorithms folder
API_URL = "https://mainnet-api.tig.foundation"

if PLAYER_ID is None or API_KEY is None or TIG_WORKER_PATH is None or TIG_ALGORITHMS_FOLDER is None:
    raise Exception("Please set the PLAYER_ID, API_KEY, and TIG_WORKER_PATH, TIG_ALGORITHMS_FOLDER variables in 'tig-benchmarker/master/config.py'")

PORT = 5115
JOBS = dict(
    satisfiability=dict(
        sat_allocd=dict(
            benchmark_duration=15000, # amount of time to run the benchmark in milliseconds
            wait_slave_duration=5000, # amount of time to wait for slaves to post solutions before submitting
            num_jobs=1, # number of jobs to create. each job will sample its own difficulty
            weight=1.0, # weight of jobs for this algorithm. more weight = more likely to be picked
        )
    ),
    vehicle_routing=dict(
        cw_heuristic=dict(
            benchmark_duration=15000,
            wait_slave_duration=5000,
            num_jobs=1,
            weight=1.0,
        )
    ),
    knapsack=dict(
        quick_knap=dict(
            benchmark_duration=15000,
            wait_slave_duration=5000,
            num_jobs=1,
            weight=1.0,
        )
    ),
    vector_search=dict(
        optimax_gpu=dict(
            benchmark_duration=40000, # recommend a high duration
            wait_slave_duration=40000, # recommend a high duration
            num_jobs=1,
            weight=1.0,
        )
    ),
)
