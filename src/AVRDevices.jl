module AVRDevices

include("common.jl")

for path in readdir(@__DIR__)
    (!isfile(path) || path == @__FILE__) && continue

    include(path)
end

end # module AVRDevices
