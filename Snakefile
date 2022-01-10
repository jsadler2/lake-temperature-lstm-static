import os

configfile: "1_fetch/fetch_config.yaml"



rule all:
    input:
        "1_fetch/in/pull_date.txt",
        expand("1_fetch/out/metadata/{file}", file=config["sb_fetch.py"]["metadata"]["files"]),
        expand("1_fetch/out/obs/{file}", file=config["sb_fetch.py"]["obs"]["files"]),
        expand("1_fetch/out/drivers/{file}", file=config["sb_fetch.py"]["drivers"]["files"]),
        expand("1_fetch/out/drivers/{driver_type}_{suffix}.zip",
                driver_type=config["sb_fetch.py"]["drivers"]["driver_types"], 
                suffix=config["sb_fetch.py"]["drivers"]["MNTOHA_suffixes"])


rule fetch_sb_data_file:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        "1_fetch/out/{file_category}/{file}"
    params:
        sb_id = lambda wildcards: config["sb_fetch.py"][wildcards.file_category]["sb_id"]
    shell:
        "python 1_fetch/src/sb_fetch.py {params.sb_id} -f {output}"

