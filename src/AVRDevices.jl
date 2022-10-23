module AVRDevices

include("common.jl")

for path in readdir(joinpath(@__DIR__, "devices"))
    include(joinpath("devices", path, path*".jl"))
end

end # module AVRDevices
