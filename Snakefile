configfile: "1_fetch/fetch_config.yaml"


rule fetch_all:
    input:
        "1_fetch/in/pull_date.txt",
        expand("{file}", file=config["sb_fetch.py"]["metadata_files"]),
        expand("{file}", file=config["sb_fetch.py"]["obs_files"]),
        expand("{file}", file=config["sb_fetch.py"]["driver_files"])

# Lake information for 881 MNTOHA lakes
rule fetch_metadata:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        "1_fetch/out/metadata/{file}"
    shell:
        "python 1_fetch/src/sb_fetch.py {config[sb_fetch.py][metadata_id]} -f {output}"

# Water temperature observations
rule fetch_obs:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        "1_fetch/out/obs/{file}"
    shell:
        "python 1_fetch/src/sb_fetch.py {config[sb_fetch.py][obs_id]} -f {output}"

# Model inputs (meteorological inputs, clarity, and ice flags)
rule fetch_driver:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        "1_fetch/out/driver/{file}"
    shell:
        "python 1_fetch/src/sb_fetch.py {config[sb_fetch.py][driver_id]} -f {output}"

