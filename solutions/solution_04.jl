using WaterLily
using StaticArrays
using ParametricBodies
using CUDA
include("../utils/TwoD_plots.jl")

function make_sim(;L=32,N::Int=3,R=2,Re=1e3,λ=2,m=6,n=4,T=Float32,mem=Array)
    # Inflow, Rotation rate, and blade section half-angle
    U = T(inv(λ)); ω = T(λ*U/(R*L))

    # Helper functions and map
    Rot(ϕ) = SA[cos(ϕ) sin(ϕ); -sin(ϕ) cos(ϕ)]
    θ(x) = mod(atan(x[2],x[1]),2π)
    function map(x₁,t)
        # Transform to rotating axis-centerted frame
        x₂ = Rot(ω*t)*(x₁.-0.5f0n*R*L)
        # Move blade to origin and align with x-axis
        return SA[0.25f0L-x₂[2],abs(x₂[1]-R*L)]
    end

    # naca 0012 airfoil with closed TE
    NACA(s) = 0.6f0*(0.2969f0s-0.126f0s^2-0.3516f0s^4+0.2843f0s^6-0.1036f0s^8)
    curve(s,t) = L*SA[(1-s)^2,NACA(1-s)]
    
    # define the body
    body = ParametricBody(curve,(0,1);map,T,mem)
    
    # return a simulation
    Simulation((m*R*L,n*R*L),(U,0f0),L;U=1,ν=L/Re,body,T,mem)
end 

sim = make_sim(N=3,L=32,R=3,mem=CUDA.CuArray);
# sim = make_sim(N=3,L=32,R=3,mem=Array);

# intialize
t₀ = sim_time(sim); duration = 10.0; tstep = 0.1

# for GPU run
vort = similar(sim.flow.σ) |> Array
bod = similar(sim.flow.σ) |> Array

# step and plot
@time @gif for tᵢ in range(t₀,t₀+duration;step=tstep)
    # update until time tᵢ in the background
    sim_step!(sim,tᵢ,remeasure=true)
    
    # print time step
    println("tU/L=",round(tᵢ,digits=4),", Δt=",round(sim.flow.Δt[end],digits=3))
    @inside sim.flow.σ[I] = WaterLily.curl(3,I,sim.flow.u)*sim.L/sim.U
    copyto!(vort,sim.flow.σ)
    flood(vort[inside(vort)],clims=(-10,10),border=:none); 
    # @inside sim.flow.σ[I] = WaterLily.sdf(sim.body,SVector(Tuple(I).-0.5f0),tᵢ)
    # copyto!(bod,sim.flow.σ)
    # contour!(bod[inside(bod)]';levels=[0],lines=:black)
end
