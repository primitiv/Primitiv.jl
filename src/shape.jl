mutable struct Shape
    inner::Ptr{primitivShape_t}

    function Shape(inner::Ptr{primitivShape_t})
        @assert inner != C_NULL
        shape = new(inner)
        finalizer(shape, obj -> @call(DeleteShape, (Ptr{primitivShape_t},), obj.inner))
        shape
    end

    function Shape()
        shape_ptr_ptr = Ptr{primitivShape_t}[0]
        @call(CreateShape, (Ptr{Ptr{primitivShape_t}},), shape_ptr_ptr)
        Shape(shape_ptr_ptr[1])
    end

    function Shape(dims::AbstractArray{T}, batch::Integer = 1) where T<:Integer
        shape_ptr_ptr = Ptr{primitivShape_t}[0]
        @call(CreateShapeWithDims, (Ptr{Cuint}, Cint, Cuint, Ptr{Ptr{primitivShape_t}}), convert(Array{UInt32}, dims), size(dims)[1], batch, shape_ptr_ptr)
        Shape(shape_ptr_ptr[1])
    end
end


"""
    depth(shape)

Returns the depth (length of non-1 dimensions) of the shape.

# Arguments
- `shape::Shape` shape object
"""
function depth(shape::Shape)
    retval_ptr = Ref{UInt32}(0)
    @call(GetShapeDepth, (Ptr{primitivShape_t}, Ptr{Cuint}), shape.inner, retval_ptr)
    retval_ptr[]
end

"""
    batch(shape)

Returns the batch size.

# Arguments
- `shape::Shape` shape object
"""
function batch(shape::Shape)
    retval_ptr = Ref{UInt32}(0)
    @call(GetShapeBatchSize, (Ptr{primitivShape_t}, Ptr{Cuint}), shape.inner, retval_ptr)
    retval_ptr[]
end

"""
    volume(shape)

Returns the number of elements in each sample.

# Arguments
- `shape::Shape` shape object
"""
function volume(shape::Shape)
    retval_ptr = Ref{UInt32}(0)
    @call(GetShapeVolume, (Ptr{primitivShape_t}, Ptr{Cuint}), shape.inner, retval_ptr)
    retval_ptr[]
end

"""
    lower_volume(shape)

Returns the number of elements in 1 to specified dim.

# Arguments
- `shape::Shape` shape object
- `dim::Integer` Upper bound of the dimension.
"""
function lower_volume(shape::Shape, dim::Integer)
    retval_ptr = Ref{UInt32}(0)
    @call(GetShapeLowerVolume, (Ptr{primitivShape_t}, Cuint, Ptr{Cuint}), shape.inner, dim, retval_ptr)
    retval_ptr[]
end
