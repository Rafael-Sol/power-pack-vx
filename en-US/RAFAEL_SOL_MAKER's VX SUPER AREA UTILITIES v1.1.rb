#===============================================================================
#               RAFAEL_SOL_MAKER's VX SUPER AREA UTILITIES v1.1
#-------------------------------------------------------------------------------
# Description:  With this script you can set batlle backgrounds, like RPG Maker 
#               XP, for specific areas, assign a specified damage in each step, 
#               simulating the terrain damage, specify poison damage and healing 
#               rate from items, and others things, everything here.
#               OBS.: It also erases the battlefloor, since it is unnecessary.
#-------------------------------------------------------------------------------
# How to Use:   Type the following commands in the names of areas:
#               <battleback "filename"> to set a battle background; (no quotes!)
#               <damage_area x> to damage 'x' HP points to all party members;
#               Is it possible to put the two commands in the same area using
#               ';' to separate them. Everything else configure below.
#-------------------------------------------------------------------------------
# Special Thanks: Moghunter
#-------------------------------------------------------------------------------
#===============================================================================

module PowerPackVX_General_Configs  
  # BASIC ENGINE ADJUSTS
  Minimum_HP = 1                # Min HP for poison/area damage (0 = dead)
  Poison_Damage = 1             # Poison damage for each step
  Recover_Rate = 1              # HP Recover for each step (special itens)
  GameOver_on_Map = false       # If all party is dead on map, we got a Game Over?
  
  # DEFAULT GRAPHICS
  Default_Battleback = 'Grassland01' # Default BattleBack filename
end

module Cache    
  # BattleBack directly from Cache
  def self.battleback(filename)
    load_bitmap('Graphics/Battlebacks/', filename)
  end
end

module PowerPackVX_Advanced_Configs
  # FOR AREA NAMES (Don't change nothing here, or the commands could not work!)
  TERRAIN_DAMAGE = /<(?:DAMAGE_AREA|damage area)\s*([\-]?\d+)>/i
  BATTLEBACK_FILE = /<(?:BATTLEBACK|battleback)\s*(.*)>/i
end

class Game_Party < Game_Unit
include PowerPackVX_Advanced_Configs
include PowerPackVX_General_Configs 

  def on_player_walk
    
    for actor in members
      if actor.slip_damage?
        if (actor.hp - Poison_Damage) < Minimum_HP
          actor.hp = Minimum_HP
        else
          actor.hp -= Poison_Damage
        end        
        $game_map.screen.start_flash(Color.new(255,0,0,64), 4)
      end
      if actor.auto_hp_recover and actor.hp > 0
        actor.hp += Recover_Rate 
      end
    end   

    in_area = false
    for area in $data_areas.values
      if $game_player.in_area?(area)
        name = get_battleback_name(area.name)
        if !name.nil? and !$game_map.battleback_lock
          in_area = true; $game_map.battleback_name = name
        end
        damage = get_damage_area(area.name)        
        unless damage.nil? 
          for actor in $game_party.members
            if actor.hp > Minimum_HP
              if (actor.hp - damage) < Minimum_HP 
                actor.hp = Minimum_HP 
              else
                actor.hp -= damage
              end   
            end
          end  
          $game_map.screen.start_flash(Color.new(255,0,0,64), 4)      
        end #unless      
      end #if   
    end #for
    
    $game_map.battleback_name = Default_Battleback if !in_area and !$game_map.battleback_lock
    $scene = Scene_Gameover.new if $game_party.all_dead? and GameOver_on_Map == true
    
  end 

  def get_battleback_name (area_name)
    area_name.split(/[\r\n;]+/).each { |line|
      if line =~ BATTLEBACK_FILE
        a = line.split(/ /)[1]
        d = ""
        while ((c = a.slice!(/./m)) != nil)
          d += c if c != ">"
        end
        return d      
      end }    
    return nil
  end
  
  def get_damage_area (area_name)
    area_name.split(/[\r\n;]+/).each { |line|      
    return $1.to_i if line =~ TERRAIN_DAMAGE }
    return nil
  end
  
end 

class Spriteset_Battle
include PowerPackVX_General_Configs

  def create_battleback
    @battleback_sprite = Sprite.new(@viewport1)
    source = Cache.battleback($game_map.battleback_name) rescue Cache.battleback(Default_Battleback)
    @battleback_sprite.x = (Graphics.width / 2) - (source.width / 2)
    @battleback_sprite.bitmap = source 
  end
  
  # SINCE WE DON'T NEED, LET'S "KILL" THE BATTLE FLOOR
  def create_battlefloor; end
  def update_battlefloor; end
  def dispose_battlefloor; end
  
end

class Game_Map
  attr_accessor :battleback_name
  attr_accessor :battleback_lock
end
