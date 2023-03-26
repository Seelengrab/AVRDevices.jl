module ATmega328p

using ..AVRDevices.Common

# The definitions in this module are based off of this datasheet:
# https://ww1.microchip.com/downloads/en/DeviceDoc/ATmega48A-PA-88A-PA-168A-PA-328-P-DS-DS40002061B.pdf

include("registers.jl")
include("serial.jl")

end