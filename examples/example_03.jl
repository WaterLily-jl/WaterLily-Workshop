using WaterLily
using StaticArrays
using ParametricBodies
using CUDA
include("../TwoD_plots.jl")

function make_sim(;L=32,λ=1.4,R=3,Re=1e3,m=10,n=6,T=Float32,mem=Array)
    # Inflow and agle of attack
    U = T(inv(1+λ)); ω = T(λ*U/(R*L))

    # Helper functions and map
    Rot(ϕ) = SA[cos(ϕ) sin(ϕ); -sin(ϕ) cos(ϕ)]
    θ(x) = mod(atan(x[2],x[1]),2π)
    function map(x₁,t)
        # Transform to rotating axis-centerted frame
        x₂ = 
        # Move blade to origin and align with x-axis
        return 
    end

    # naca 0012 airfoil with closed TE
    NACA(s) = 0.6f0*(0.2969f0s-0.126f0s^2-0.3516f0s^4+0.2843f0s^6-0.1036f0s^8)
    curve(s,t) = L*SA[(1-s)^2,NACA(1-s)]
    
    # define the body
    body = ParametricBody(...)

    # return a simulation
    Simulation()
end 

# check cuda and make sim
@assert CUDA.functional()
sim = ;

