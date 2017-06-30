function setup_model()
    T = Float32
    @graph feat begin
        x = Linear(T,54,54)(feat)
        x = relu(x)
        x = Linear(T,54,89)(x)
        softmax(x)
    end
end

"""
    MSE with NA
"""
function mse_na(x1::Var, x2::Var)
    y = Var(nothing, mse, (x1,x2))
    (isvoid(x1.data) || isvoid(x2.data)) && return y

    y.data = mse_na(x1.data, x2.data)
    y.df! = () -> begin
        isvoid(x2.grad) || throw("")
        ∇mse_na!(y.grad, x1.data, x1.grad, x2.data)
    end
    y
end

function mse_na(x1::Matrix{T}, x2::Matrix{T}) where T
    size(x1) == size(x2) || throw("Size unmatch.")
    res = similar(x1, size(x1,2))
    @inbounds for j = 1:size(x1,2)
        v = T(0)
        for i = 1:size(x1,1)
            x2[i,j] < T(0) && continue # NA
            diff = x2[i,j] - x1[i,j]
            v += diff * diff
        end
        res[j] = v / size(x1,1)
    end
    res
end

function ∇mse_na!(gy::Vector{T}, x1::Matrix{T}, gx1::Matrix{T}, x2::Matrix{T}) where T
    @inbounds for j = 1:size(x1,2)
        for i = 1:size(x1,1)
            x2[i,j] < T(0) && continue
            g = gy[j] * (x2[i,j] - x1[i,j]) * 2 / size(x1,1)
            gx1[i,j] -= g
            #gx2[i] += g
        end
    end
end
