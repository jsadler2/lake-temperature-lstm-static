import os

configfile: "1_fetch/fetch_config.yaml"


def get_input_files(wildcards):
    out_dir = "1_fetch/out"
    categories = config["sb_fetch.py"].keys()
    input_files = []
    for category in categories:
        for filename in config["sb_fetch.py"][category]["files"]:
            input_files.append(os.path.join(out_dir, category, filename))
    return input_files


rule all:
    input:
        "1_fetch/in/pull_date.txt",
        get_input_files,
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

