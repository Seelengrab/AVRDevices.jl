# AVRDevices.jl

This package contains register definitions and some utility functions for programming on AVR boards. Compilation of code using
this package is best done using [AVRCompiler.jl].

Currently only the ATmega328P is supported, due to ressource limitations of the author.

To install this package, simply `]add https://github.com/Seelengrab/AVRDevices.jl`.

## Usage

Simply do

```julia
using AVRDevices.Common
using AVRDevices.ATmega328P
```

or equivalent and start programming! Each board has definitions for the individual registers.

!!! warn
  Don't try to run any of the functions from `Common` or any of the device submodules on your development machine.
  The code will try to write to some (for a regular PC) pretty unusual pointers and will most likely segfault. If you need to inspect
  the generated code, use `@code_llvm dump_module=true` or inspect the generated AVR assembly after compilation with [AVRCompiler.jl]().

The `Common` submodule has definitions for a `Register` struct, as well as some utility functions for loading/storing
from them (and pointers) in a way such that LLVM does not eliminate the loads & stores.

Registers can be read from like

```julia
val = r[]
```

and set like

```julia
r[] = val
# or this, if rpin1 is bit1 of register r
r[] = rpin1
```

All the usual operations like masking are supported via `r[] &= mask`. These register operations use volatile loading/storing under the hood.