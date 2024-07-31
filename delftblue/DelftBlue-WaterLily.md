# Running WaterLily.jl on DelftBlue

First make a directory in your scratch space and change to it:

```bash
cd /scratch/your_netID/
mkdir Workspace
cd Workspace
```

##### Install Julia via the Julia version manager

In the terminal, run the following command to download and run the Julia version manager install script:

```bash
curl -fsSL https://install.julialang.org | sh
```
use the default using `enter`
```
? Do you want to install with these default configuration choices?
❯ Proceed with installation
  Customize installation
  Cancel installation
```

This install in the Julia package manager in `~/.juliaup/` and creates a symbolic link to the julia executable in `~/.juliaup/bin/julia`

> WARNING!
> __this must be done before running `julia` for the first time!__

To install all the package in the `/scratch/your_netID/` (to save the space on `home`), you need to set the `JULIA_DEPOT_PATH` environment variable to point to the scratch directory. To do this, add the following line to your `.bash_profile` file (you can do that by typing in the terminal `nano ~/.bash_profile` and go down to the end og the file. To save and close, use `ctrl+o` then `enter` to save and,`ctrl+x` and then `enter` to close):

```bash
export JULIA_DEPOT_PATH="/scratch/your_netID/.julia":$JULIA_DEPOT_PATH
```
and then refresh your environment with `source ~/.bash_profile`.


#### Install WaterLily.jl

Clone the WaterLily.jl repository (or yours if you have forked it):

```bash
git clone git@github.com:WaterLily-jl/WaterLily.jl.git
```

change to the `WaterLily.jl` directory and start `Julia`:

```bash
cd WaterLily.jl
julia
```

Check that you are at least running julia 1.10.0

Initialise the project and install the dependencies:
```bash
julia ]
(@v1.10) pkg> activate /scratch/your_netID/Workspace/Waterlily
(WaterLily) pkg> instantiate
```
(this take a while) the last line install the the packages listed in the `Project.toml` file.

Finally, add the following file to your `.bash_profile` file:
(you can edit it with `nano ~/.bash_profile`)

```bash
export PATH=$PATH:/home/your_netID/.juliaup/bin
```
to save and close do `ctrl+o` then `enter` and the `ctrl+x` then `enter` to close.

#### Submit a job on DelftBlue

To submit a `GPU` job on DelftBlue, run
```bash
sbatch subWaterLily
```
wher the `subWaterlily` file is:

```bash
#!/bin/sh

#SBATCH --job-name="WaterLily.jl"
#SBATCH --partition=gpu
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --gpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH --account=research-3me-mtt
​
module load 2022r2
module load cuda/11.6
​
time julia my_script.jl
```

You can then check the status of the job with

```bash
squeue -u your_netID
    JOBID PARTITION     NAME USER  ST       TIME  NODES NODELIST(REASON)
  2901284       gpu WaterLil your_netID PD       0:00      1 (None)
```

#### Uploading a `Julia` script to DelftBlue

To send your script to `DelftBlue`, use the command
  
  ```bash
  scp my_script.jl your_netID@delftblue.tudelft.nl:~/scratch/your_netID/Workspace/WaterLily
  ```
