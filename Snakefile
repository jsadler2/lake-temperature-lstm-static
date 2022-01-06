# import os
# import sys
# # bad smell...
# path_1_fetch = os.path.abspath(os.path.join(__file__, '1_fetch', 'src'))
# print(path_1_fetch)
# if path_1_fetch not in sys.path:
#     sys.path.append(path_1_fetch)
# from sb_fetch import sb_get

rule fetch_all:
    input:
        "1_fetch/in/pull_date.txt",
        "1_fetch/out/lake_metadata.csv",
        "1_fetch/out/obs/temperature_observations.zip",
        # "1_fetch/out/driver/04_inputs.xml"
        "1_fetch/out/driver/clarity_01_N48.00-49.50_W89.50-97.25.zip"

# 1: Lake information for 881 lakes
rule fetch_metadata:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        "1_fetch/out/lake_metadata.csv"
    shell:
        "python 1_fetch/src/sb_fetch.py '5e5c1c1ce4b01d50924f27e7' -f lake_metadata.csv -d '1_fetch/out'"

# 2: Water temperature observations
rule fetch_obs:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        "1_fetch/out/obs/temperature_observations.zip"
    shell:
        "python 1_fetch/src/sb_fetch.py '5e5d0b68e4b01d50924f2b32' -f temperature_observations.zip -d '1_fetch/out/obs'"

# 3: Model configurations (lake model parameter values)
# rule fetch_pb0_config:
#     input:
#         "1_fetch/in/pull_date.txt"
#     output:
#         "1_fetch/out/pb0_config.json"
#     shell:
#         "python 1_fetch/src/sb_fetch.py '5e5c1c36e4b01d50924f27ea' -d '1_fetch/out'"

# 4: Model inputs (meteorological inputs, clarity, and ice flags)
rule fetch_drivers:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        # "1_fetch/out/driver/04_inputs.xml"
        "1_fetch/out/driver/clarity_01_N48.00-49.50_W89.50-97.25.zip"
    shell:
        "python 1_fetch/src/sb_fetch.py '5e5d0b96e4b01d50924f2b34' -d '1_fetch/out/driver'"

# 5: Model prediction data
# rule fetch_glm_preds:
#     input:
#         "1_fetch/in/pull_date.txt"
#     output:
#         "1_fetch/out/05_predictions.xml"
#     shell:
#         "python 1_fetch/src/sb_fetch.py '5e5d0bb9e4b01d50924f2b36' -d '1_fetch/out'"

