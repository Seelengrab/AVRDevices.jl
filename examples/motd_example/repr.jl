using motd_example, AVRCompiler
using AVRCompiler.GPUCompiler, AVRCompiler.LLVM

job = AVRCompiler.native_job(motd_example.main, (), AVRCompiler.ArduinoParams("unnamed"))
mi,_ = GPUCompiler.emit_julia(job)
GPUCompiler.code_llvm(job; optimize=true, dump_module=true)
ctx=JuliaContext()
res = GPUCompiler.compile_method_instance(job, mi; ctx)[1]
getobj(res) = for (i,b) in enumerate(blocks(first(functions(res))))
    i == 10 && for (j,instr) in enumerate(instructions(b))
        j == 12 && begin
            @show instr
            @show instr.ref
            ccall(:jl_breakpoint, Cvoid, (Any,), instr.ref)
        end
    end
end
getobj(res)