function read_timeinfo(path::String)
    println("Reading $path...")
    lines = open(readlines, path)
    res = String[]
    regex_user = r"@\w+"

    for i = 2:length(lines)
        line = lines[i]
        isempty(line) && continue
        items = split(line, ',')
        if length(items) == 3
            str = String(items[3])
        elseif length(items) < 3
            str = line
        else
            continue
        end
        str = replace(str, regex_user, "@user")
        str = strip(str)
        isempty(str) || push!(res,str)
    end
    res
end

path = "D:/crest/twitter_raw"
data = String[]
for s in readdir(path)
    res = read_timeinfo("$(path)/$s")
    append!(data, res)
end
open("$(path)/timeinfo.out", "w") do f
    foreach(x -> println(f,x), data)
end
r = r"@\w+: "
ismatch(r, "@mimibear5: ")
