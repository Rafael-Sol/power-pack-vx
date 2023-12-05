#===============================================================================
#         RAFAEL_SOL_MAKER's VX TOGGLE FULLSCREEN & RESOLUTION v1.0 
#-------------------------------------------------------------------------------
# Description:  Puts the game in fullscreen or in a given resolution only by
#               pressing a key, with automatic corrected scale considering
#               window borders.
#               Supports multiple screen sizes up to 640x480 and got some other
#               adjustable properties. Similar to RPG Maker 2000/2003.
#------------------------------------------------- ------------------------------
# How to Use:   Press F5 to toggle the full screen mode;
#               Press F6 to change the resolution, if it's in windowed mode.
#               Extra settings can be found in the general configuration module.
#-------------------------------------------------------------------------------
# Special Thanks: Game_guy, OriginalWij, Mechacrash, Kylock
#-------------------------------------------------------------------------------
#===============================================================================

module PowerPackVX_General_Configs  
      
  # SCREEN OPTIONS
  Default_Screen_Width  = 544 # Game screen width [max = 640] [default = 544] 
  Default_Screen_Height = 416 # Game screen height [max = 480] [default = 416]    
  High_Res_Width  = 960       # Game screen width (adjustable resolution mode)
  High_Res_Height = 720       # Game screen height (adjustable resolution mode)
  
end

class << Graphics
  include PowerPackVX_General_Configs

  alias solmaker_update update unless $@
  def Graphics.update
    solmaker_update
    if Input.trigger?(Input::F5)
      toggle_fullscreen      
    elsif Input.trigger? (Input::F6)       
      if scaled? == false; scale_window(High_Res_Width, High_Res_Height) 
      else; scale_window(Default_Screen_Width , Default_Screen_Height); end      
    end      
  end
  
  def Graphics.fullscreen? # Property
    screen_size = Win32API.new('user32', 'GetSystemMetrics', 'I', 'I')
    screen_width = screen_size.call(0);   screen_height = screen_size.call(1)    
    detect_fullscreen = false
    detect_fullscreen = true if screen_width == 640 and screen_height == 480
    return detect_fullscreen
  end
  
  def Graphics.toggle_fullscreen # Main function
    keybd = Win32API.new 'user32.dll', 'keybd_event', ['i', 'i', 'l', 'l'], 'v'
    keybd.call(0xA4, 0, 0, 0)
    keybd.call(13, 0, 0, 0)
    keybd.call(13, 0, 2, 0)
    keybd.call(0xA4, 0, 2, 0)    
  end  
 
  def Graphics.scaled? # Property
    rect = [0, 0, 0, 0].pack('l4')      
    find = Win32API.new('user32', 'FindWindowEx', ['l','l','p','p'], 'i')
    window = find.call(0, 0, "RGSS Player", 0)      
    Win32API.new('user32', 'GetClientRect', %w(l p), 'i').call(window, rect)
    w, h = rect.unpack('l4') [2..3]
    detect_scaled_window = false
    detect_scaled_window = true if w != Default_Screen_Width and h != Default_Screen_Height
    return detect_scaled_window 
  end  
 
  def Graphics.scale_window(w, h) # Main function
    unless fullscreen? 
      size = Win32API.new('user32', 'GetSystemMetrics', 'I', 'I')
      move = Win32API.new('user32', 'MoveWindow', ['l','i','i','i','i','l'], 'l')
      find = Win32API.new('user32', 'FindWindowEx', ['l','l','p','p'], 'i')
      window = find.call(0, 0, "RGSS Player", 0)
      window_w = size.call(0)
      window_h = size.call(1)
      detect_border
      move.call(window, (window_w - w + @window_border_width) / 2,
                        (window_h - h + @window_border_height) / 2, 
                        w + @window_border_width, h + @window_border_height, 1)
    end
  end
  
  def Graphics.detect_border # Auxiliary function
      rect = [0, 0, 0, 0].pack('l4'); rect2 = [0, 0, 0, 0].pack('l4')      
      find = Win32API.new('user32', 'FindWindowEx', ['l','l','p','p'], 'i')
      window = find.call(0, 0, "RGSS Player", 0)      
      Win32API.new('user32', 'GetClientRect', %w(l p), 'i').call(window, rect)
      Win32API.new('user32', 'GetWindowRect', %w(l p), 'i').call(window, rect2) 
      w, h = rect.unpack('l4') [2..3]      
      x, y, x2, y2 = rect2.unpack('l4') [0..3]
      w2 = x2 - x; h2 = y2- y 
      @window_border_width = w2 - w
      @window_border_height = h2 - h
  end
    
end
