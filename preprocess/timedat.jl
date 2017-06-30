"""
Read timeinfo file and extract texts for learning word representations.
"""
function read_timedat(path::String)
    lines = open(readlines, path)
    dict = Dict{String,Vector{String}}()
    names = String[]
    regex_user = r"@\w+"
    name, str = "", ""

    for i = 2:length(lines)
        line = lines[i]
        isempty(line) && continue
        items = split(line, '\t')
        if length(items) == 3
            name = String(items[1])
            if !haskey(dict,name)
                dict[name] = String[]
                push!(names, name)
            end
            str = String(items[3])
        elseif length(items) < 3
            str = line
        else
            continue
        end
        str = replace(str, regex_user, "@user")
        str = strip(str)
        if !isempty(str)
            push!(dict[name], str)
        end
    end
    map(n -> join(dict[n]," "), names)
end

path = "C:/Users/hshindo/Dropbox/brainCREST/research/dat170613"
res = read_timedat("$(path)/timedat184_sort.tsv")
open("$(path)/timedat184_sort.out", "w") do f
    #for (k,v) in res
    #    println(f, k)
    #    println(f, join(v," "))
    #end
    for s in res
        println(f, s)
    end
end
