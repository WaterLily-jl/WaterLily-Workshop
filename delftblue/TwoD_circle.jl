using WaterLily
using CUDA
function circle(n,m;Re=250,U=1,f=Array)
    radius, center = m/8, m/2
    body = AutoBody((x,t)->sum(abs2, x .- center) - radius)
    Simulation((n,m), (U,0), radius; ν=U*radius/Re, body,mem=f)
end

sim = circle(3*2^6,2^7;f=CUDA.CuArray);
sim_step!(sim,10;verbose=true)
println(typeof(sim.flow.u))
