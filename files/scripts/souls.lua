dofile_once("mods/moles_souls/files/utils.lua")
dofile_once("mods/moles_souls/lib/stringstore.lua")
dofile_once("mods/moles_souls/lib/noitavariablestore.lua")
local souls = {};
local store = stringstore.open_store(stringstore.noita.variable_storage_components(EntityGetWithTag("player_unit")[1]))
                  .souls;
GamePrint(type(store))

function souls:spawn(herd)
    GamePrint(herd)
    local player = EntityGetWithTag("player_unit")[1]
    local px, py = EntityGetTransform(player)
    if herd == "synthetic" then
        EntityAddChild(player, EntityLoad("mods/moles_souls/files/entities/souls/soul_synthetic.xml", px, py))
        return
    end
    if ("mods/moles_souls/files/entities/souls/soul_" .. herd .. ".xml") ~= nil then
        local is_gilded = math.random(1, 100)
        if is_gilded == 1 then
            herd = "gilded"
        end
        local child_id = EntityLoad("mods/moles_souls/files/entities/souls/soul_" .. herd .. ".xml", px, py)
        EntityAddChild(player, child_id)
    end
end

function souls:kill(herd)
    local tag = "soul_" .. herd
    if herd == "any" then tag = "soul" end
    local souls = EntityGetWithTag(tag);
    if (souls == nil) then 
        return error("");
    end
    EntityKill(souls[math.random(1, #souls)]);
end

function souls:add(herd, num)
    for i=1,num do
        if pcall(self.spawn(herd)) then
            GamePrint("Err: Soul of type " .. herd .. "could not be spawned");
            return error("Soul of type " .. herd .. "could not be spawned"); 
        end;
        store[herd] = store[herd] + 1;
        store["total"] = store["total"] + 1;

    end
    
end

function souls:remove(herd, num)
    for i=1,num do
        if pcall(self.kill(herd)) then
            
        else 
        if herd ~= "any" then store[herd] = store[herd] - 1 end;
        store["total"] = store["total"] - 1;
        end
    end
end

function souls:count(herd) 
    herd = herd or "total"
    return store[herd]
end

function souls:init()
    store["total"] = 0
    store["bat"] = 0
    store["fly"] = 0
    store["friendly"] = 0
    store["gilded"] = 0
    store["mage"] = 0 
    store["orcs"] = 0
    store["slimes"] = 0
    store["spider"] = 0
    store["synthetic"] = 0
    store["zombie"] = 0
end
return souls
