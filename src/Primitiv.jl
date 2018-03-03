module Primitiv

# shape.jl
export Shape,
       depth,
       batch,
       volume,
       lower_volume

# tensor.jl
export Tensor,
       valid,
       shape,
       to_float,
       reset!

include("init.jl")
include("shape.jl")
include("tensor.jl")

end
