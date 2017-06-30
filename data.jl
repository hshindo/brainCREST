function readdata()
    path = "C:/Users/hshindo/Dropbox/brainCREST/research/dat170613"
    per = read_personality("$(path)/personality184.tsv")
    feat = read_twitter("$(path)/twitter184.tsv")
    twi = read_timedat("$(path)/timedat184_sort.id")
    per, feat, twi
end

function read_personality(path::String)
    lines = open(readlines, path)
    deleteat!(lines, 1)
    vecs = []
    for i = 1:length(lines)
        items = Vector{String}(split(lines[i],'\t'))
        name = items[1]
        age = items[2]
        sex = items[3]
        data = map(items[4:end-1]) do x
            x == "NA" ? Float32(-1) : parse(Float32,x)
        end
        push!(vecs, data)
    end

    # normalize
    v1 = vecs[1]
    for i = 1:length(v1)
        data = map(v -> v[i], vecs)
        data = data / maximum(data)
        #data = map(x -> x < 0 ? -1 : x, data)
        for j = 1:length(vecs)
            vecs[j][i] = data[j] < 0 ? -1 : data[j]
        end
    end
    vecs
end

function read_twitter(path::String)
    lines = open(readlines, path)
    deleteat!(lines, 1)
    vecs = []
    for i = 1:length(lines)
        items = Vector{String}(split(lines[i],'\t'))
        data = map(x -> parse(Float32,x), items[2:end])
        push!(vecs, data)
    end

    # normalize
    v1 = vecs[1]
    for i = 1:length(v1)
        data = map(v -> v[i], vecs)
        data = batch_normalize(data)
        for j = 1:length(vecs)
            vecs[j][i] = data[j]
        end
    end
    vecs
end

function read_timedat(path::String)
    lines = open(readlines, path)
    vecs = []
    for i = 1:length(lines)
        items = Vector{String}(split(lines[i],' '))
        data = map(x -> parse(Int,x), items)
        push!(vecs, data)
    end
    vecs
end

function batch_normalize(vec::Vector{Float32})
    m = mean(vec)
    sd = std(vec)
    map(x -> (x-m)/sd, vec)
end
