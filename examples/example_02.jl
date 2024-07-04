using WaterLily
using StaticArrays
using CUDA
include("../utils/utils/TwoD_plots.jl")

# utility functions
norm(x::StaticArray) = √(x'*x)
s(t,a,U=1) = ifelse(t<U/a, 0.5a*t^2, U*(t-0.5U/a))

function make_sim2D(;R=2^6, a=1, U=1, Re=1e3, mem=Array)
    
    # sdf for a plate of thickness 3
    function sdf(x,t) 
        ...
    end
    
    # map
    function map(x,t) 
        ...
    end

    # define the body
    body = 

    # Return simulation
    return Simulation(...)
end

# sim = make_sim2D();
# sim_gif!(sim,duration=6.0,clims=(-5,5),plotbody=true,remeasure=true)

# sim and sim gif

# 3D example
sim = ;

# make the writer

# a simulation

# dont forget to close writer
#close(wr)
