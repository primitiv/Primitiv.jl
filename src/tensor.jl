mutable struct Tensor
    inner::Ptr{primitivTensor_t}

    function Tensor(inner::Ptr{primitivTensor_t})
        @assert inner != C_NULL
        tensor = new(inner)
        finalizer(tensor, obj -> @call(DeleteTensor, (Ptr{primitivTensor_t},), obj.inner))
        tensor
    end

    function Tensor()
        tensor_ptr_ptr = Ptr{primitivTensor_t}[0]
        @call(CreateTensor, (Ptr{Ptr{primitivTensor_t}},), tensor_ptr_ptr)
        Tensor(tensor_ptr_ptr[1])
    end
end

"""
    valid(tensor)

Check whether the object is valid or not.

# Arguments
- `tensor::Tensor` tensor object
"""
function valid(tensor::Tensor)
    retval_ptr = Ref{PRIMITIV_C_BOOL}(0)
    @call(IsValidTensor, (Ptr{primitivTensor_t}, Ptr{Cuint}), tensor.inner, retval_ptr)
    retval_ptr[] == PRIMITIV_C_TRUE
end

"""
    shape(tensor)

Returns the shape of the Tensor.

# Arguments
- `tensor::Tensor` tensor object
"""
function shape(tensor::Tensor)
    shape_ptr_ptr = Ptr{primitivShape_t}[0]
    @call(GetTensorShape, (Ptr{primitivTensor_t}, Ptr{Ptr{primitivShape_t}}), tensor.inner, shape_ptr_ptr)
    Shape(shape_ptr_ptr[])
end

"""
    to_float(tensor)

Retrieves one internal value in the tensor.

# Arguments
- `tensor::Tensor` tensor object
"""
function to_float(tensor::Tensor)
    retval_ptr = Ref{Float32}(0)
    @call(EvaluateTensorAsFloat, (Ptr{primitivTensor_t}, Ptr{Cfloat}), tensor.inner, retval_ptr)
    retval_ptr[]
end


"""
    reset!(tensor)

Reset internal values using a constant.

# Arguments
- `tensor::Tensor` tensor object
"""
function reset!(tensor::Tensor, k::AbstractFloat)
    @call(ResetTensor, (Ptr{primitivTensor_t}, Cfloat), tensor.inner, k)
end
