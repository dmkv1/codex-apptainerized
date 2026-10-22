# Containerized Codex for the lab

Codex CLI runs in an Apptainer container as the calling user. It sees only the current project folder, an optional second folder, and a private persistent home (`~/codex/codex-home`). Files it creates are owned by the user and group-writable (`umask 002`); in setgid project folders they get the folder's group.

## For users

Sign in once (ChatGPT account; enable device code login in ChatGPT security settings first):
```bash
codex login --device-auth
```

Then, from a project folder:
```bash
cd /mnt/data/NGS/Projects/MY_PROJECT
codex                          # Codex works in this folder
codex /mnt/data/NGS/Projects/OTHER   # also gives read-write access to a second folder
codex "summarize the scripts here"   # other arguments go to Codex
```

`codex` refuses to start in your home folder, its parents, or shallow paths like `/mnt/data`.

Inside the container: R with tidyverse, qs2, hdf5r and Seurat; Python with pandas/numpy/scipy/matplotlib, pysam, h5py and anndata; samtools, bcftools, bedtools, tabix/bgzip, mosdepth; git, gh, pandoc, Node.js. Personal R packages install to `~/R/library` inside the Codex home and persist.

`mamba` inside the container is the host installation (detected from `MAMBA_ROOT_PREFIX`, `CONDA_EXE`, `/opt/miniforge3`, `~/miniforge3`; override with `CODEX_MAMBA_ROOT`). It is mounted at its host path together with the environment and package folders from `~/.condarc`, so environments created by Codex work on the host as well. Without a host installation, `mamba` falls back to the bundled micromamba and its environments live only in the Codex home.

Codex reads lab instructions from `~/codex/codex-home/.codex/AGENTS.md`. The "lab defaults" block in it is refreshed when the image is updated; everything below it is yours to edit.

Codex keeps its own sandbox active inside the container: without approval it writes only to the project folder(s) and has no network for commands it runs.

## For the admin

Build as a regular user (needs `/etc/subuid` entries), then install as root:
```bash
./build.sh            # creates codex.sif
sudo ./install.sh     # /opt/codex/codex.sif (group lab-pk, 640) and /usr/local/bin/codex
```

`install.sh` takes the group from `CODEX_GROUP` (default `lab-pk`). Only members of that group can run the image. To update Codex, change `CODEX_VERSION` in `codex.def`, rebuild, reinstall; running sessions are not interrupted.

If the build runs out of space in `/tmp`, set `APPTAINER_TMPDIR` and `APPTAINER_CACHEDIR` to a larger disk, e.g. `/mnt/scratch`.

## Isolation

The launcher uses `apptainer run --containall` (no host home, clean environment, private `/tmp`, PID and IPC namespaces) with explicit binds only. The host network is shared. Proxy variables are forwarded if set.
