legibleVariableName = (str) ->
    out = str[0].toUpperCase()
    for char in str.substring(1)
        if char == char.toUpperCase()
            out += " " + char
        else
            out += char
    return out

legibleEnumName = (str) ->
    out = str[0].toUpperCase()
    makeCaps = false
    for char in str.substring(1)
        if char == "_"
            makeCaps = true
            out += " "
        else if makeCaps
            makeCaps = false
            out += char.toUpperCase()
        else
            out += char.toLowerCase()
    return out

module.exports = 
    legibleVariableName: legibleVariableName
    legibleEnumName: legibleEnumName
