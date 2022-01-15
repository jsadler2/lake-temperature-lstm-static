import os

configfile: "1_fetch/fetch_config.yaml"


def get_mntoha_input_files(wildcards):
    '''List all MNTOHA files to download
    Includes metadata, temperature observations, and drivers

    :param wildcards: Snakemake wildcards (unused)
    :returns: list of filepaths to be downloaded

    '''
    out_dir = "1_fetch/out"
    categories = config["mntoha"].keys()
    input_files = []
    for category in categories:
        for filename in config["mntoha"][category]["files"]:
            input_files.append(os.path.join(out_dir, category + "_mntoha", filename))
    return input_files


rule all:
    input:
        "1_fetch/in/pull_date.txt",
        get_mntoha_input_files
        expand("1_fetch/out/drivers_mntoha/{driver_type}_{suffix}.zip",
                driver_type=config["sb_fetch.py"]["drivers"]["driver_types"], 
                suffix=config["sb_fetch.py"]["drivers"]["MNTOHA_suffixes"])


rule fetch_mntoha_data_file:
    input:
        "1_fetch/in/pull_date.txt"
    output:
        "1_fetch/out/{file_category}_mntoha/{file}"
    params:
        sb_id = lambda wildcards: config["mntoha"][wildcards.file_category]["sb_id"]
    script:
        "1_fetch/src/sb_fetch.py"

