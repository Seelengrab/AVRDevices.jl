using motd_example, AVRCompiler, AVRDevices
using AVRCompiler.GPUCompiler, AVRCompiler.LLVM, AVRDevices.ATmega328p.Serial

job = AVRCompiler.native_job(Serial._write, (USART0{0x08}, Base.CodeUnits{UInt8, String}), AVRCompiler.ArduinoParams("unnamed"))
mi,_ = GPUCompiler.emit_julia(job; validate=false)
GPUCompiler.code_llvm(job; optimize=true, dump_module=true)
# ctx=JuliaContext()
# res = GPUCompiler.compile_method_instance(job, mi; ctx)[1]
