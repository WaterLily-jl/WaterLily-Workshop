using WaterLily
using StaticArrays
using CUDA
include("../utils/TwoD_plots.jl")

# utility functions
norm(x::StaticArray) = √(x'*x)
s(t,a,U=1) = ifelse(t<U/a,0.5a*t^2,U*(t-0.5U/a))

function make_sim2D(;R=2^6, a=1, U=1, Re=1e3, mem=Array)
    
    # sdf for a plate of thickness 3
    function sdf(x,t) 
        norm(SA[x[1], x[2] - min(x[2],R)]) - 1.5 # disk
    end
    
    # map
    function map(x,t) 
        x - SA[8R/3+R*s(t/R,a), 0]  # move the center
    end

    # define the body
    body = AutoBody(sdf,map)

    # Return simulation
    return Simulation((12R,6R),(0,0),R;U,ν=U*R/Re,body,mem)
end

function make_sim3D(;R=2^6, a=1, U=1, Re=1e3, mem=Array,T=Float32)
    # sdf for a plate of thickness 3, use axis-symmetric
    function sdf(x,t)
        r = √(x[2]^2+x[3]^2)
        # distance to x-aligned cylinder
        return norm(SA[x[1], r-min(r,R)])-1.5
    end
    
    # map
    function map(x,t) 
        x - SA[8R/3+R*s(t/R,a), 0, 0]  # move the center
    end

    # define the body
    body = AutoBody(sdf,map)

    # Return simulation
    return Simulation((12R,3R,3R),(0,0,0),R;U,ν=U*R/Re,body,mem,T)
end

# 2D sim on the CPU
# sim = make_sim2D();
# sim_gif!(sim,duration=6.0,clims=(-5,5),plotbody=true,remeasure=true)

# 3D sim on the GPU
sim = make_sim3D(mem=CUDA.CuArray);

# make a writer with some attributes
velocity(a::Simulation) = a.flow.u |> Array;
pressure(a::Simulation) = a.flow.p |> Array;
_body(a::Simulation) = (measure_sdf!(a.flow.σ, a.body, WaterLily.time(a)); 
                                     a.flow.σ |> Array;)
lamda(a::Simulation) = (@inside a.flow.σ[I] = WaterLily.λ₂(I, a.flow.u);
                        a.flow.σ |> Array;)

custom_attrib = Dict(
    "Velocity" => velocity,
    "Pressure" => pressure,
    "Body" => _body,
    "Lambda" => lamda
)# this maps what to write to the name in the file

# make the writer
wr = vtkWriter("Disk"; attrib=custom_attrib)

# a simulation
t₀ = sim_time(sim)
duration = 6.0
tstep = 0.05
for tᵢ in range(t₀,t₀+duration;step=tstep)
    @show tᵢ
    sim_step!(sim,tᵢ);
    write!(wr,sim);
end
close(wr)
