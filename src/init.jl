const PRIMITIV_C_BOOL = Cuint
const PRIMITIV_C_FALSE = 0
const PRIMITIV_C_TRUE = 1
const PRIMITIV_C_STATUS = Cuint
const PRIMITIV_C_OK = 0
const PRIMITIV_C_ERROR = -1

const primitivShape_t = Void
const primitivTensor_t = Void

macro call(fun, args...)
    status = Expr(:call, :ccall, ("primitiv$fun", "libprimitiv_c"), :PRIMITIV_C_STATUS, args...)
    err = gensym()
    esc(:(if ($err = $status) != PRIMITIV_C_OK; error(get_message()); end))
end

function get_message()
    size_ptr = Ref{UInt32}(0)
    status = ccall((:primitivGetMessage, :libprimitiv_c), PRIMITIV_C_STATUS, (Cstring, Ptr{Cuint}), C_NULL, size_ptr)
    @assert status == PRIMITIV_C_OK
    message = "0" ^ size_ptr[]
    status = ccall((:primitivGetMessage, :libprimitiv_c), PRIMITIV_C_STATUS, (Cstring, Ptr{Cuint}), message, size_ptr)
    @assert status == PRIMITIV_C_OK
    message
end
