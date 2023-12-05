#===============================================================================
#             RAFAEL_SOL_MAKER's VX SMOOTH WINDOW OPENING v1.0
#-------------------------------------------------------------------------------
# Description:  A simple special effect that make the window fades softly while
#               it's opening and closing. It halves down the speed of the 
#               opening and closing animation, to create a more smooth effect.
#-------------------------------------------------------------------------------
# How to Use: -
#-------------------------------------------------------------------------------
# Special Thanks: -
#-------------------------------------------------------------------------------
#===============================================================================

class Window_Base < Window
  attr_accessor :update_opacity
  
  alias vx_smooth_window_initialize initialize unless $@  
  def initialize (x, y, width, height)
    vx_smooth_window_initialize (x, y, width, height)
    @update_opacity = true
  end 

  def update    
    super
    if @opening
      self.openness += 24
      @opening = false if self.openness == 255
    elsif @closing
      self.openness -= 24
      @closing = false if self.openness == 0
    end    
    if (@opening or @closing) and @update_opacity 
      self.opacity = self.openness
      self.back_opacity = self.openness
    end
  end
  
end

class Window_Message < Window_Selectable
  alias vx_smooth_window_update update unless $@  
  def update  
    @background == 0 ? @update_opacity = true : @update_opacity = false   
    vx_smooth_window_update
  end  
end
