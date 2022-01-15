include: "1_fetch.smk"


rule all:
    input:
        "1_fetch/in/pull_date.txt",
        get_mntoha_input_files

