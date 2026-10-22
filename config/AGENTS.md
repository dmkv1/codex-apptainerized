<!-- BEGIN lab defaults (managed: this block is replaced when the Codex image is updated) -->
# Working environment

You run inside an Apptainer container on the lab server, as the user who started you. Files you create belong to that user and the lab group; treat every change as made on the user's behalf.

## What you can see
- The current project folder, mounted at the same path as on the host. An optional second folder (see `--add-dir`) is also writable.
- The user's mamba installation, at the same path as on the host.
- A private home folder (`/home/codex`, on the host `~/codex/codex-home`). The user's real home folder is not visible.
- Nothing else from the host. If a path is missing, ask the user instead of searching for it.

The container exists only while Codex runs. Anything that must outlast the session belongs in the project folder.

## Software
- In the image: R (tidyverse, qs2, hdf5r, Seurat), Python 3 (pandas, numpy, scipy, matplotlib, seaborn, pysam, h5py, anndata, openpyxl), samtools, bcftools, bedtools, tabix/bgzip, mosdepth, git, gh, pandoc, Node.js.
- R packages the user installs go to `~/R/library` in the private home and persist.

## mamba environments
- `mamba` is the user's own installation; environments are shared with the host and keep working without this container.
- Run tools non-interactively: `mamba run -n ENV command`. `mamba activate` does not work in your shell.
- List environments with `mamba env list` before creating new ones; reuse a fitting one.
- Create or modify environments only after the user agrees.
- After creating or changing an environment for a project, export it into the project:
  `mamba env export -n ENV --no-builds > environment.yml`
  (use `envs/ENV.yml` when a project uses several environments).
- If `mamba` reports no host installation, environments land in the private home and work only inside this container; tell the user.

## Heavy work and pipelines
Long or resource-heavy jobs (Nextflow, Snakemake, alignment, large batch jobs) are run by the user on the host. Write the scripts and the exact commands, and leave running them to the user.

There is no apptainer, singularity or docker inside this container. Pipelines that run their steps in containers (`snakemake --sdm apptainer`, `--use-singularity`, `nextflow -profile singularity`) cannot run here. What you can do:
- write and edit workflow files, configs and sample sheets;
- check them with a dry run and lint from a snakemake environment, without the container flags: `mamba run -n ENV snakemake -n` and `mamba run -n ENV snakemake --lint` (find ENV with `mamba env list`);
- give the user the full command to run on the host, from the project folder.

## Data protection
The lab handles patient data. Do not copy data outside the project folder, upload it, or paste file contents into external services. Read only what the task needs.
<!-- END lab defaults -->

# Your notes

Codex reads this file at the start of every session. Write your own preferences and project conventions below this line, for example preferred plotting style, naming conventions, or which folders hold raw data. Edit it on the host at `~/codex/codex-home/.codex/AGENTS.md`, or ask Codex to add a note here. Text outside the "lab defaults" block above is never overwritten.

