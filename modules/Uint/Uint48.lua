function toBase2(Int,Fill)
    local BitArray = {}
    while Int > 0 do
        local Rest = Int%2
        table.insert(BitArray,math.floor(Rest))
        Int = (Int-Rest)/2
    end
    local awaitingReturn = table.concat(BitArray)
    return (awaitingReturn..("0"):rep((Fill or 8)-#awaitingReturn))
end
function Uint48_encode(BufferArray)
    local Buffer = {}
    while #BufferArray > 0 do
        local Int = table.remove(BufferArray)
        local Binary = toBase2(Int,48)
        for Index=1,#Binary,8 do
            table.insert(Buffer,string.char(tonumber(Binary:sub(Index,Index+7):reverse(),2)))
        end
    end
    return table.concat(Buffer)
end
function Uint48_decode(Buffer)
    local BufferArray = {}
    for BufferIndex=1,#Buffer,6 do
        local SectorRaw = Buffer:sub(BufferIndex,BufferIndex+5)
        local Sector = {}
        for SectorIndex=1,#SectorRaw do
            table.insert(Sector,toBase2(SectorRaw:sub(SectorIndex,SectorIndex):byte()))
        end
        table.insert(BufferArray,tonumber(table.concat(Sector):reverse(),2))
    end
    return BufferArray
end
return {
    ["encode"]=Uint48_encode,
    ["decode"]=Uint48_decode
}
