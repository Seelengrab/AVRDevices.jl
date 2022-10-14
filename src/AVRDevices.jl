module AVRDevices

include("common.jl")

for path in readdir(@__DIR__)
    (!isfile(joinpath(@__DIR__, path)) || path in ("AVRDevices.jl", "common.jl")) && continue

    include(path)
end

end # module AVRDevices
