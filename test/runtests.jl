#!/usr/bin/env julia

using Primitiv
using Base.Test

this_file = basename(@__FILE__)

function test_dir(dir)
    jl_files = sort(filter(f -> ismatch(r"^.+\.jl$", f), readdir(dir)),
                    by = fn -> stat(joinpath(dir, fn)).mtime)
    map(reverse(jl_files)) do file
        file == this_file && return
        include(joinpath(dir, file))
    end
end

@testset "Primitiv Test" begin
    test_dir(dirname(@__FILE__))
end
