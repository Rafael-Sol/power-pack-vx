#===============================================================================
#                 RAFAEL_SOL_MAKER's VX TRANSITION SET v1.1
#-------------------------------------------------------------------------------
# Description:   With this script you can use a set of multiple
#                customized transitions in the teleport, or at the beginning or 
#                end of battles. You can configure in and out transitions, and a 
#                total of six different transitions that can be used. To change 
#                the transition graphic in-game use the command:
#                
#                  set_transition (transition, filename)
#
#                Where 'transition' accepts the following values: MAP_IN, 
#                MAP_OUT, BATTLE_IN, BATTLE_OUT, BATTLE_END_IN, BATTLE_END_OUT;
#                And 'filename' is the name of the bitmap used for transition, 
#                which should be in the folder 'Graphics/Transitions/'.
#                If you prefer to use the fade effect instead, just use a blank 
#                filename, a empty quote: "" (can be single or double);
#
#                  set_transition_wait (duration)
#
#                To set the transition's delay time, in frames.
#   
#                OBS.: Also uses a teleport sound effect that can be configured 
#                by Sound module. The settings and default values can be found 
#                in the configurable module.            
#-------------------------------------------------------------------------------
# How to Use: -
#-------------------------------------------------------------------------------
# Special Thanks: Angel Ivy-chan
#-------------------------------------------------------------------------------
#===============================================================================

module PowerPackVX_General_Configs  
  # TRANSITION BETWEEN THE SCENES
  Transition_In =  'Blind02'    # Map Transition (in)
  Transition_Out = 'Blind02'    # Map Transition (out)
  Battle_In =      'Blind03'    # Battle Transition (in)
  Battle_Out =     'Blind03'    # Battle Transition (out) 
  Battle_End_In =  'Blind04'    # Battle End Transition (in)
  Battle_End_Out = 'Blind04'    # Battle End Transition (out)  
  Transition_Wait = 60          # Transition Delay, in Frames  
end

module Cache  
  # Preparation of Transitions in Cache
  def self.transition(filename)
    load_bitmap('Graphics/Transitions/', filename)
  end  
end

module Sound  
  # Teleport's Sound Effect
  def self.play_teleport
    Audio.se_play('Audio/SE/Run', 25, 50) 
  end
end

class Game_Interpreter
include PowerPackVX_General_Configs

  MAP_IN =    1       #Transition: Map In
  MAP_OUT =    2      #Transition: Map Out
  BATTLE_IN =   3     #Transition: Battle In
  BATTLE_OUT =   4    #Transition: Battle Out
  BATTLE_END_IN = 5   #Transition: End of Battle In
  BATTLE_END_OUT = 6  #Transition: End of Battle Out
  
  #--------------------------------------------------------------------------
  # Change Transitions Between Scenes
  #--------------------------------------------------------------------------  
  def set_transition (transition = MAP_IN, filename = '')
    # Selects which transition will be changed 
    case transition
      when MAP_IN
        $game_system.map_in = filename
        when MAP_OUT
        $game_system.map_out = filename
      when BATTLE_IN
        $game_system.battle_in = filename
      when BATTLE_OUT
        $game_system.battle_out = filename
      when BATTLE_END_IN
        $game_system.battle_end_in = filename
      when BATTLE_END_OUT
        $game_system.battle_end_out = filename
    end
  end
  
  #--------------------------------------------------------------------------
  # Change the Transition Delay
  #-------------------------------------------------------------------------- 
  def set_transition_wait (duration = 45)
    $game_system.transition_wait = duration
  end
  
end

class Game_System
include PowerPackVX_General_Configs

  attr_accessor :map_in
  attr_accessor :map_out    
  attr_accessor :battle_in
  attr_accessor :battle_out  
  attr_accessor :battle_end_in
  attr_accessor :battle_end_out  
  attr_accessor :transition_wait
  
  alias solmaker_transition_initialize initialize unless $@
  def initialize
    solmaker_transition_initialize
    load_transitions      
  end
  
  def load_transitions
    @map_in = Transition_In 
    @map_out = Transition_Out 
    @battle_in  = Battle_In 
    @battle_out = Battle_Out 
    @battle_end_in  = Battle_End_In 
    @battle_end_out = Battle_End_Out 
    @transition_wait = Transition_Wait 
  end
  
end

class Scene_Map

  def perform_transition
    if Graphics.brightness == 0 
      if $game_temp.in_battle == true      
        $game_temp.in_battle = false
        Graphics.freeze
        Graphics.brightness = 255
        filename = ""
        if $game_system.battle_end_in != ""
          filename = 'Graphics/Transitions/' + $game_system.battle_end_in
        end  
        Graphics.transition($game_system.transition_wait, filename)  
      else
        fadein(30)  
      end
    else                              
      Graphics.transition(15)
    end
  end

  def update_transfer_player    
    return unless $game_player.transfer?  
    Sound.play_teleport;
    Graphics.freeze; @spriteset.dispose    
    $game_player.perform_transfer; $game_map.autoplay; $game_map.update 
    filename = ""
    if $game_system.map_out != ""
      filename = 'Graphics/Transitions/' + $game_system.map_out
    end
    Graphics.transition($game_system.transition_wait, filename)
    Input.update; Graphics.freeze; @spriteset = Spriteset_Map.new  
    filename = ""
    if $game_system.map_in != ""
      filename = 'Graphics/Transitions/' + $game_system.map_in
    end
    Graphics.transition($game_system.transition_wait, filename)
  end    
    
  def perform_battle_transition    
    filename = ""
    if $game_system.battle_out != ""
      filename = 'Graphics/Transitions/'+ $game_system.battle_out
    end
    Graphics.transition($game_system.transition_wait, filename)
    Graphics.freeze     
  end   

end

class Scene_Battle < Scene_Base

  def perform_transition
    filename = ""
    if $game_system.battle_in != ""
      filename = 'Graphics/Transitions/'+ $game_system.battle_in
    end
    Graphics.transition($game_system.transition_wait, filename)
  end  

  def battle_end(result)
    if result == 2 and not $game_troop.can_lose
      call_gameover
      $game_temp.in_battle = false
    else
      $game_party.clear_actions
      $game_party.remove_states_battle
      $game_troop.clear
      if $game_temp.battle_proc != nil
        $game_temp.battle_proc.call(result)
        $game_temp.battle_proc = nil
      end      
      @message_window.clear
      Graphics.freeze
      @message_window.visible = false 
      @spriteset.dispose
      filename = ""
      if $game_system.battle_end_out != ""
        filename = 'Graphics/Transitions/' + $game_system.battle_end_out
      end    
      Graphics.transition($game_system.transition_wait, filename)
      unless $BTEST
        $game_temp.map_bgm.play
        $game_temp.map_bgs.play
      end
      $scene = Scene_Map.new
      Graphics.brightness = 0     
    end
  end 
  
end
