const PRIMITIV_C_OK = 0
const PRIMITIV_C_ERROR = -1
const PRIMITIV_C_STATUS = UInt32

const primitivShape_t = Void

macro call(fun, args...)
    status = Expr(:call, :ccall, ("primitiv$fun", "libprimitiv_c"), :PRIMITIV_C_STATUS, args...)
    err = gensym()
    esc(:(if ($err = $status) != PRIMITIV_C_OK; error(get_message()); end))
end

function get_message()
    size_ptr = Ref{UInt32}(0)
    status = ccall((:primitivGetMessage, :libprimitiv_c), PRIMITIV_C_STATUS, (Cstring, Ptr{UInt32}), C_NULL, size_ptr)
    @assert status == PRIMITIV_C_OK
    message = "0" ^ size_ptr[]
    status = ccall((:primitivGetMessage, :libprimitiv_c), PRIMITIV_C_STATUS, (Cstring, Ptr{UInt32}), message, size_ptr)
    @assert status == PRIMITIV_C_OK
    message
end
