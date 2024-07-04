# Array indexing like matlab, but with python syntax
a = zeros((10,10,10)) 
a[1:end,2:end-4,:] .= 1.0

#Array operation supported 
sqrt(vec’*vec) -> dot(vec,vec)

#Can use any mathematical symbols
Re = U*L/ν

#Broadcasting operation must be explicit 
a = @. [1., 2., 3.] + 1.0        or,      a = [1., 2., 3.] .+ 1.0

#Static Arrays for better memory management 
using StaticArrays
a = SA[1. 2. 3.]

#to print and add end of line character…super annoying
println() 

@my_macro # is a macro
my_func(...) and my_func!(...) # are not the same!

# # Anonymous function 
# (x,y)->x*y                                                         
    
# # Function arguments 
# function my_func(a,b=10;c=101)
#     ...
# end

# nested loops
# for i ∈ 1:10, j ∈ 1:10
#     ...
# end

using WaterLily
include("../utils/TwoD_plots.jl")

m,n = 2^8,2^8
Re=250
U=1
ϵ = 12
# some dimensions
radius, center = m/4, m/2

# sdf for a circle
function sdf(x,t)
    √sum(abs2, x .- center) - radius
end

# make a body
body = AutoBody(sdf)

# make a simulation
sim = Simulation((n,m), (U,0), radius; ν=U*radius/Re, ϵ, body)
@inside sim.flow.σ[I] = WaterLily.sdf(sim.body,SVector(Tuple(I).-0.5f0),0.0)
flood(sim.flow.σ[inside(sim.flow.σ)],border=:none)
# flood(sim.flow.μ₀[:,:,1],border=:none)
savefig("BDIM_1.png")