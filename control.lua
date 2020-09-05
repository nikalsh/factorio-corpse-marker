--control.lua

local markers = {}

script.on_event(defines.events.on_player_died, 
  function(event)

    local player = game.get_player(event.player_index)

    player.print(player.position.x)
    player.print(player.position.y)

    add_corpse_marker(player)

  end
)

script.on_event(defines.events.on_character_corpse_expired, 
  function(event)

    remove_corpse_marker(event.entity)

  end  
)

script.on_event(defines.events.on_pre_player_mined_item,
  function(event)    
--  game.print(event.entity.position["x"])
--  game.print(event.entity.position["y"])
    remove_corpse_marker(event.entity)

  end
)

function remove_corpse_marker(entity)
  local x = entity.position["x"]
  local y = entity.position["y"]

  if markers[x] ~= nil and markers[x][y] ~= nil then
    markers[x][y].destroy()
    markers[x][y] = nil
  end

end


function add_corpse_marker(player)
  local x = player.position.x
  local y = player.position.y

  local surface = "nauvis"

  local signalID = {
    type="virtual",
    name="signal-dot",
  }

  local tagData = {
    position = { x, y },
    icon = signalID,
    text = player.name.."'s corpse"
  }

  local tag = player.force.add_chart_tag(surface, tagData) 

  if markers[x] then
    markers[x][y] = tag  
  else
    markers[x] = { y }
    markers[x][y] = tag
  end

end

function print_event(event) 
  for key, value in pairs(event) do
    game.print(key)
    game.print(value)
  end 
end
