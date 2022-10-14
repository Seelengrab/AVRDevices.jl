# AVRDevices.jl

This package contains register definitions and some utility functions for programming on AVR boards.

Currently only the ATmega328P is supported, due to ressource limitations.

Simply do

```julia
using AVRDevices: Common, ATmega328P
using .Common, .ATmega328p
```

or equivalent and start programming! Each board has definitions for the individual registers.

The `Common` submodule has definitions for a `Register` struct, as well as some utility functions for loading/storing
from them (and pointers) in a way such that LLVM does not eliminate the loads & stores.

Registers can be read from like

```julia
val = r[]
```

and set like

```
r[] = val  
```

All the usual operations like masking are supported via `r[] &= mask`. These register operations use volatile loading/storing under the hood.