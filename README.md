# lake-temperature-lstm-static

Predict lake temperatures at depth using static lake attributes.

## Installing

Create a new `conda` environment by running

```
conda env create -f environment.yml
conda activate ltls
```

Note: if `mamba` is available, the creation of the environment will be faster by running

`mamba env create -f environment.yml`

## Downloading input data

For now, MNTOHA data are being used.
A more complete set of lakes will be incorporated in the future, but MNTOHA lake data are readily available to download from ScienceBase.
To download temperature observations, meteorological drivers, and metadata, run

`snakemake -c1 -p fetch_all`

You can replace the `1` in `-c1` with the number of cores to use in a parallelized environment.

The data will be downloaded to the `1_fetch/out` folder.
If the download is interrupted, you can resume it and overwrite partially downloaded files by running

`snakemake -c1 -p --rerun-incomplete fetch_all`

