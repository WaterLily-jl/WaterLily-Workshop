using WaterLily
include("../utils/TwoD_plots.jl")

function circle(m,n;Re=250,U=1)
    # some dimensions
    radius, center = 

    # sdf for a circle
    function sdf(x,t)
        ...
    end
    
    # make a body
    body = 

    # make a simulation
    Simulation(...)
end

# make a gif of the simulation
sim_gif!(circle(3*2^6,2^7),duration=40,clims=(-5,5),plotbody=true)
