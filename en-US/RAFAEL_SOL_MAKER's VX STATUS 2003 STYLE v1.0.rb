#===============================================================================
#                RAFAEL_SOL_MAKER's VX STATUS 2003 STYLE v1.0
#-------------------------------------------------------------------------------
# Description:  Status scene redesigned to be similar to the RPG Maker 2003
#               version. Added gold window and the information were well 
#               distributed and organized in multiple windows.
#               Compatible with 544x416 and 640x480 resolutions.
#-------------------------------------------------------------------------------
# How to Use: -
#-------------------------------------------------------------------------------
# Special Thanks: -
#-------------------------------------------------------------------------------
#                      ADDITIONAL INFORMATIONS:
#   New windows: Window_Status_Info, Window_Status_Statistics, 
# and Window_Status_Equip
#
#   Scene_Status -> Totally remade
# Additional windows: @gold_window(improved), @info_window, @statistics_window 
# and @equip_window
#
#   Window_Gold (improved)
# New optional parameter on initialization: (w = 160)
#
#   Window_Status -> Totally remade
# New optional parameters on initialization: (x = 0, y = 0)
# Removed procedures: draw_equipments, draw_parameters, draw_basic_info
#-------------------------------------------------------------------------------
#===============================================================================

module Vocab   
  #NEW WORDS!  
  Name        = "Name"
  Class       = "Class"
  Condition   = "Condition"
end

#==============================================================================
# Scene_Status
#------------------------------------------------------------------------------
# Operation class on the Status screen.
#==============================================================================
class Scene_Status < Scene_Base

  def start
    super
    create_menu_background
    @actor = $game_party.members[@actor_index]    
    @status_window = Window_Status.new(@actor, 0, 0) 
    @gold_window = Window_Gold.new(0, Graphics.height - 56, @status_window.width) 
    @info_window = Window_Status_Info.new(@status_window.width, 0, @actor)
    @statistics_window = Window_Status_Statistics.new(@status_window.width, 
                          @info_window.height, @actor)
    @equip_window = Window_Status_Equip.new(@status_window.width, 
                      @info_window.height + @statistics_window.height, @actor)
  end

  def terminate
    super
    dispose_menu_background
    @gold_window.dispose
    @status_window.dispose
    @info_window.dispose
    @statistics_window.dispose
    @equip_window.dispose
  end
  
  def update
    update_menu_background
    
    @gold_window.update
    @status_window.update
    @info_window.update
    @statistics_window.update
    @equip_window.update
    
    if Input.trigger?(Input::B)
      Sound.play_cancel
      return_scene
    elsif Input.trigger?(Input::R)
      Sound.play_cursor
      next_actor
    elsif Input.trigger?(Input::L)
      Sound.play_cursor
      prev_actor
    end
    super
  end

end

#==============================================================================
# Window_Status_Info
#------------------------------------------------------------------------------
# Window that displays the hit points, magic points and the experience
# obtained by the character.
#==============================================================================
class Window_Status_Info < Window_Base
  #--------------------------------------------------------------------------
  # Object initialization
  #     x     : X window coordinate
  #     y     : Y window coordinate
  #     actor : character
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    w = Graphics.width.to_f * 0.65 
    mh = (Graphics.height.to_f / 416)
    h = (WLH * 4 + 40) * mh 
    super(x, y, w, h)    
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    s1 = @actor.exp_s
    s2 = @actor.next_rest_exp_s
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    self.contents.font.color = system_color
    self.contents.draw_text(4, y + WLH * 0, 200, WLH, Vocab::ExpTotal)
    self.contents.draw_text(4, y + WLH * 1, 200, WLH, s_next)
    self.contents.font.color = normal_color
    cx  = contents.text_size(Vocab::ExpTotal).width    
    cx2 = contents.text_size(s_next).width    
    self.contents.draw_text(cx  + 18,  y + WLH * 0, width - cx , WLH, s2) #, 2)
    self.contents.draw_text(cx2 + 18, y + WLH * 1, width - cx2, WLH, s1) #, 2)
    
    draw_actor_hp(@actor, 4, y + WLH * 2)
    draw_actor_mp(@actor, 4, y + WLH * 3)
  end

end

#==============================================================================
# Window_Status_Statistics
#------------------------------------------------------------------------------
# Window that displays the statistics of the equipment used by the character.
#==============================================================================
class Window_Status_Statistics < Window_Base
  #--------------------------------------------------------------------------
  # Object initialization
  #     x     : X window coordinate
  #     y     : Y window coordinate
  #     actor : character
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    w = Graphics.width.to_f * 0.65 
    mh = (Graphics.height.to_f / 416)
    h = (WLH * 4 + 32) * mh
    super(x, y, w, h)
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_parameter(0, WLH * 0, 0)
    draw_parameter(0, WLH * 1, 1)
    draw_parameter(0, WLH * 2, 2)
    draw_parameter(0, WLH * 3, 3)
  end

  #--------------------------------------------------------------------------
  # Parameter Display 
  #     x    : X window coordinate
  #     y    : Y window coordinate
  #     type : value type (0~3)
  #--------------------------------------------------------------------------
  def draw_parameter(x, y, type)
    w2 = (width / 2) - 32
    case type
    when 0
      name = Vocab::atk; value = @actor.atk
    when 1
      name = Vocab::def; value = @actor.def
    when 2
      name = Vocab::spi; value = @actor.spi
    when 3
      name = Vocab::agi; value = @actor.agi
    end    
    self.contents.font.color = system_color
    self.contents.draw_text(x + 4, y, 128, WLH, name)
    self.contents.font.color = normal_color
    self.contents.draw_text(x + w2, y, 32, WLH, value, 2) #w2>144
    self.contents.font.color = system_color

  end
end

#==============================================================================
# Window_Status_Equip
#------------------------------------------------------------------------------
# Window that displays the items equipped on the hero in the status screen.
#==============================================================================
class Window_Status_Equip < Window_Base
  #--------------------------------------------------------------------------
  # Object initialization
  #     x     : X window coordinate
  #     y     : Y window coordinate
  #     actor : character
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    w = Graphics.width.to_f * 0.65 
    mh = (Graphics.height.to_f / 416)
    h = (Graphics.height - y) #(WLH * 5 + 32) * mh 
    super(x, y, w, h) 
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def refresh
    w2 = (width / 2) - 32
    self.contents.clear
    @data = []
    for item in @actor.equips do @data.push(item) end
    @item_max = @data.size
    self.contents.font.color = system_color
    if @actor.two_swords_style
      self.contents.draw_text(4, WLH * 0, w2, WLH, Vocab::weapon1)
      self.contents.draw_text(4, WLH * 1, w2, WLH, Vocab::weapon2)
    else
      self.contents.draw_text(4, WLH * 0, w2, WLH, Vocab::weapon)
      self.contents.draw_text(4, WLH * 1, w2, WLH, Vocab::armor1)
    end
    self.contents.draw_text(4, WLH * 2, w2, WLH, Vocab::armor2)
    self.contents.draw_text(4, WLH * 3, w2, WLH, Vocab::armor3)
    self.contents.draw_text(4, WLH * 4, w2, WLH, Vocab::armor4)
    draw_item_name(@data[0], w2, WLH * 0)
    draw_item_name(@data[1], w2, WLH * 1)
    draw_item_name(@data[2], w2, WLH * 2)
    draw_item_name(@data[3], w2, WLH * 3)
    draw_item_name(@data[4], w2, WLH * 4)
  end

end

#==============================================================================
# Window_Status
#------------------------------------------------------------------------------
# Window that displays basic information of the characters.
#==============================================================================
class Window_Status < Window_Base
  #--------------------------------------------------------------------------
  # Object initialization
  #     actor :   character
  #--------------------------------------------------------------------------
  def initialize(actor, x = 0, y = 0 )
    h = Graphics.height - (WLH + 32)
    w = Graphics.width.to_f * 0.35
    super(x, y, w, h )
    @actor = actor
    refresh
  end
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_basic_info (4, 0)   #NEW WINDOW
  end
  #--------------------------------------------------------------------------
  # Display of the basic information
  #     x: displays in x coordinate
  #     y: displays in y coordinate  
  #--------------------------------------------------------------------------
  def draw_basic_info(x, y)
    draw_actor_face         (@actor, x, y + WLH * 0)
    self.contents.font.color = system_color
    self.contents.draw_text (x, y + WLH * 1 + 96, 256, WLH, Vocab::Name)
    draw_actor_name         (@actor, x + 32, y + WLH * 2 + 96)
    self.contents.font.color = system_color
    self.contents.draw_text (x, y + WLH * 3 + 96, 256, WLH, Vocab::Class )
    draw_actor_class        (@actor, x + 32, y +WLH * 4 + 96)
    self.contents.font.color = system_color
    self.contents.draw_text (x, y + WLH * 5 + 96, 256, WLH, Vocab::level )
    draw_actor_level        (@actor, x + 32, y + WLH * 6 + 96)
    self.contents.font.color = system_color
    self.contents.draw_text (x, y + WLH * 7 + 96, 256, WLH, Vocab::Condition )
    draw_actor_state        (@actor, x + 32, y + WLH * 8 + 96)
  end

  def draw_parameters(x, y);  end
  def draw_exp_info  (x, y);  end
  def draw_equipments(x, y);  end
  
end

#==============================================================================
# Window_Gold
#------------------------------------------------------------------------------
# Window that displays the money.
#==============================================================================
class Window_Gold < Window_Base
  #--------------------------------------------------------------------------
  # Object initialization
  #     x     : X window coordinate
  #     y     : Y window coordinate
  #--------------------------------------------------------------------------
  def initialize(x, y, w = 160)
    super(x, y, w, WLH + 32)
    refresh
  end
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_currency_value($game_party.gold, 4, 0, width - 40)
  end
end
