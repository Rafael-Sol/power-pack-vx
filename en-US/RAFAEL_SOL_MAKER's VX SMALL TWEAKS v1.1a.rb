#===============================================================================
#               RAFAEL_SOL_MAKER's VX SMALL TWEAKS v1.1a (9 in 1)
#-------------------------------------------------------------------------------
# Description:  Collection of small adjustments to improve the usability of VX
#               and fix some bugs or inconveniences.
#               Among the 9 adjustments, this version of the script includes:
#               - Set the message of escape from battle
#               - Adjust the making of enemies' names
#               - Recover HP and MP when you level up
#               - The encounter rate will be halved if you are in a vehicle
#               - Airship now triggers events with priority 'Above the Hero'
#               - Corrected position of battlers (resolution add-on, optional)
#               - Sound effect in the expressions
#               - Modify the starting party's money with ease
#               - Change easily the flight altitude of the Airship
#-------------------------------------------------------------------------------
# How to Use: -
#-------------------------------------------------------------------------------
# Special Thanks: João B, Yellow Magic, Maliki79, ScreWe.
#                 (http://www.rpgrevolution.com/)
#-------------------------------------------------------------------------------
#===============================================================================

module PowerPackVX_General_Configs  
  # BASIC ENGINE ADJUSTS
  Recover_When_Level_Up = true  # Recover HP and MP when level up?
  Starting_Money = 150          # Starting Money
  Airship_Altitude = 48         # Airship altitude
end

module Vocab   
  # EDITED TERMS
  EscapeStart   = "The %s's party tries to escape..."   
  EscapeFailure = "Your party couldn't escape!"  
  # NEW TERMS
  EscapeEnd     = "Your party escaped with success."
end

module Sound 
  # SOUND EFFECT FOR EXPRESSIONS
  def self.play_baloon
    Audio.se_play('Audio/SE/Jump1', 100, 100) 
  end  
end

#===============================================================================
# Adjust on the escape battle message
#===============================================================================
class Scene_Battle < Scene_Base

  def process_escape
    @info_viewport.visible = false
    @message_window.visible = true
    text = sprintf(Vocab::EscapeStart, $game_party.name)
    $game_message.texts.push(text)
    wait_text = '\.\.'
    if $game_troop.preemptive
      success = true
    else
      success = (rand(100) < @escape_ratio)
    end    
    if success
      Sound.play_escape
      $game_message.texts.push(wait_text + Vocab::EscapeEnd)
      wait_for_message
      battle_end(1)
    else
      @escape_ratio += 10
      $game_message.texts.push(wait_text + Vocab::EscapeFailure)
      wait_for_message
      $game_party.clear_actions
      start_main
    end
  end
  
end

#===============================================================================
# Adjust on the making of unique enemies names
#===============================================================================
class Game_Troop < Game_Unit
  
  alias sol_maker_make_unique_names make_unique_names unless $@
  def make_unique_names
    sol_maker_make_unique_names
    for enemy in members
      enemy.letter = ' ' + enemy.letter 
    end
  end
  
end

#===============================================================================
# Recover HP and MP when level up
#===============================================================================
class Game_Actor < Game_Battler   
  include PowerPackVX_General_Configs

  alias sol_maker_level_up level_up unless $@
  def level_up
    sol_maker_level_up
    if Recover_When_Level_Up
      self.hp += maxhp; self.mp += maxmp
    end
  end
  
end

#===============================================================================
# If you are in a vehicle, the encounter rate will be halved 
#=============================================================================== 
class Game_Player < Game_Character
 
  def update_encounter
    return if in_airship? 
    return if $TEST and Input.press?(Input::CTRL)   
    if $game_map.bush?(@x, @y)
      if in_vehicle?
        @encounter_count = @encounter_count.to_f - 1
      else
        @encounter_count -= 2
      end
    else
      if in_vehicle?
        @encounter_count = @encounter_count.to_f - 0.5 
      else
        @encounter_count -= 1
      end
    end    
  end
  
#===============================================================================
# Events with priority 'Above the Hero' can be triggered in Airship
#===============================================================================  
  def check_touch_event
    return check_event_trigger_here([1,2])
  end
  def check_action_event
    return true if check_event_trigger_here([0])
    return check_event_trigger_there([0,1,2])
  end
  
  alias sol_maker_check_event_trigger_here check_event_trigger_here unless $@
  def check_event_trigger_here(triggers)    
    return false if $game_map.interpreter.running? # Repeated command...
    
    for event in $game_map.events_xy(@x, @y)
      return false if in_airship? and event.priority_type != 2  
    end
    sol_maker_check_event_trigger_here(triggers)    
  end

  alias sol_maker_check_event_trigger_there check_event_trigger_there unless $@
  def check_event_trigger_there(triggers)
    return false if $game_map.interpreter.running? # Repeated command...
    
    front_x = $game_map.x_with_direction(@x, @direction)
    front_y = $game_map.y_with_direction(@y, @direction)
    for event in $game_map.events_xy(front_x, front_y)
      return false if in_airship? and event.priority_type != 2
    end
    sol_maker_check_event_trigger_there(triggers)
  end
  
end

#===============================================================================
#  Battlers(monsters) now have corrected positions on all resolutions
#===============================================================================
class Sprite_Battler < Sprite_Base
  
  def update
    super
    if @battler == nil
      self.bitmap = nil
    else
      @use_sprite = @battler.use_sprite?
      if @use_sprite
        ax =  @battler.screen_x.to_f * (Graphics.width.to_f / 544) 
        ay =  @battler.screen_y.to_f * (Graphics.height.to_f / 416)
        self.x = ax.to_i         
        self.y = ay.to_i 
        self.z = @battler.screen_z
        update_battler_bitmap
      end
      setup_new_effect
      update_effect
    end
  end
  
end

#===============================================================================
# Sound Effect for Expressions
#===============================================================================
class Sprite_Character < Sprite_Base

  alias sol_maker_start_balloon start_balloon unless $@
  def start_balloon
    Sound.play_baloon 
    sol_maker_start_balloon
  end
  
end

#===============================================================================
# Change the money at the beginning of the game
#===============================================================================
class Game_Party < Game_Unit  
  include PowerPackVX_General_Configs
  
  alias sol_maker_initialize initialize unless $@
  def initialize
    sol_maker_initialize
    @gold = Starting_Money
  end

end

#===============================================================================
# Change the Airship altitude
#===============================================================================  
class Game_Vehicle < Game_Character
  MAX_ALTITUDE = PowerPackVX_General_Configs::Airship_Altitude
end

