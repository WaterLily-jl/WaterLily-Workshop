using WaterLily
include("../utils/TwoD_plots.jl")

function circle(m,n;Re=250,U=1)
    # some dimensions
    radius, center = n/8, n/2+1

    # sdf for a circle
    function sdf(x,t)
        √sum(abs2, x .- center) - radius
    end
    
    # make a body
    body = AutoBody(sdf)

    # make a simulation
    Simulation((m,n), (U,0), radius; ν=U*radius/Re, body)
end

# make a gif of the simulation
sim_gif!(circle(3*2^6,2^7),duration=40,clims=(-5,5),plotbody=true)
