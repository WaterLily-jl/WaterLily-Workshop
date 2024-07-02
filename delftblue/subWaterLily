#!/bin/sh

#SBATCH --job-name="WaterLily"
#SBATCH --partition=gpu
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --gpus-per-task=1
#SBATCH --mem-per-cpu=4G
#SBATCH --account=research-me-mtt

module load 2022r2
module load cuda/11.6

time julia TwoD_circle.jl

