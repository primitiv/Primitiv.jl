mutable struct Shape
    inner::Ptr{primitivShape_t}

    function Shape(dims::Any = nothing, batch::UInt32 = UInt32(1))
        shape_ptr_ptr = Ptr{primitivShape_t}[0]
        if dims == nothing
            @call(CreateShape, (Ptr{Ptr{primitivShape_t}},), shape_ptr_ptr)
        else
            @call(CreateShapeWithDims, (Ptr{UInt32}, Int32, UInt32, Ptr{Ptr{primitivShape_t}}), dims, Int32(size(dims)[1]), UInt32(batch), shape_ptr_ptr)
        end
        shape_ptr = shape_ptr_ptr[1]
        shape = new(shape_ptr)
        finalizer(shape, obj -> @call(DeleteShape, (Ptr{primitivShape_t},), obj.inner))
        shape
    end
end

function depth(shape::Shape)
    retval_ptr = Ref{UInt32}(0)
    @call(GetShapeDepth, (Ptr{primitivShape_t}, Ptr{UInt32}), shape.inner, retval_ptr)
    retval_ptr[]
end
