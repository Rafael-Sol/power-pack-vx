#===============================================================================
#                 RAFAEL_SOL_MAKER's VX SAVE 2003 STYLE v1.2a
#                   Based on 'Save Estilo 2003' by UNIR.
#-------------------------------------------------------------------------------
# Description : Enables to increase the number of saveslots beyond the default
#               that are only 4, for the wished number.
#               Also modify the scene so it resembles more the one from 
#               RPG Maker 2003 showing character faces and money.
#               Compatible with 544x416 and 640x480 resolutions.
#-------------------------------------------------------------------------------
# How to Use: Configure the total of saveslots in the configurable module.
#-------------------------------------------------------------------------------
# Special Thanks: UNIR
#-------------------------------------------------------------------------------
#===============================================================================

#===============================================================================
# UPDATES
#-------------------------------------------------------------------------------
# VX SAVE 2003 STYLE v1.2 -> v1.2a
# * Now the title scene can load the save files again...
#   (Oops, how I could forget this?!)
# VX SAVE 2003 STYLE v1.1 -> v1.2
# * Now the file name is generated with 2 digits, even if it's lesser than 10;
#     Eg.: 'Save01.rvdata'
# * The saveslots got a separated folder(created automatically, if needed)
#     [Game's root path]/Saveslots/
#-------------------------------------------------------------------------------
#===============================================================================

module PowerPackVX_General_Configs  
  # BASIC SYSTEM ADJUSTS
  Total_Saveslots = 15  # Total of avaliable saveslots
end


module Vocab  
  # NEW WORDS! 
  Money       = "Money"
  Time        = "Time"
end

#==============================================================================
# Window_SaveFile
#------------------------------------------------------------------------------
# Shows the save game screen and allows to save and load a file.
#==============================================================================

class Window_SaveFile < Window_Base
include PowerPackVX_General_Configs

  def initialize(file_index, filename, top = 0)
    y = top + (file_index % Total_Saveslots) * 120
    super(0, y, Graphics.width, 120)
    @file_index = file_index
    @filename = filename
    load_gamedata
    refresh
    @selected = false
  end
  
  def load_gamedata
    @time_stamp = Time.at(0)
    @file_exist = FileTest.exist?(@filename)
    if @file_exist
      file = File.open(@filename, "r")
      @time_stamp = file.mtime
      begin
        @characters         = Marshal.load(file)
        @frame_count        = Marshal.load(file)
        @last_bgm           = Marshal.load(file)
        @last_bgs           = Marshal.load(file)
        @game_system        = Marshal.load(file)
        @game_message       = Marshal.load(file) #
        @game_switches      = Marshal.load(file) #
        @game_variables     = Marshal.load(file) #
        @game_self_switches = Marshal.load(file) #
        @game_actors        = Marshal.load(file) #
        @game_party         = Marshal.load(file)
        @total_sec = @frame_count / Graphics.frame_rate
      rescue
        @file_exist = false
      ensure
        file.close
      end
    end
  end
  
  def refresh
    self.contents.clear
    name = Vocab::File + " #{@file_index + 1}"
    self.contents.draw_text(4, 0, 200, WLH, name)
    @name_width = contents.text_size(name).width
    if @file_exist
      draw_party_characters(176, 0)
      draw_money (4, 32, 176)
      draw_playtime(4, 64, 176)
    end
  end

  def draw_party_characters(x, y, spacing = 16)
    interval = []
    for i in 0...@characters.size.to_i; interval.push i; end; interval.reverse!
    for i in interval
      name = @characters[i][2]
      index = @characters[i][3]      
      diff = Graphics.width - 544
      scale = 64 + (diff.to_f * 0.3).to_i
      draw_face(name, index, x + i * scale + (i * spacing) , y)
    end
  end

  def draw_playtime(x, y, width)    
    hour = @total_sec / 60 / 60
    min = @total_sec  / 60 % 60
    sec = @total_sec  % 60 % 60
    if hour > 99
      hour = 99
      min  = 00
    end
    time_string = Vocab::Time
    cx = contents.text_size(time_string).width
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, cx, WLH, time_string)
    time_string = sprintf("%02d:%02d:%02d", hour, min, sec)
    self.contents.font.color = system_color
    self.contents.draw_text(cx + 18, y, width - cx + 4, WLH, time_string)
  end

  def draw_money(x, y, width)
    string = Vocab::Money + ' ' + @game_party.gold.to_s
    cx = contents.text_size(string).width
    self.contents.font.color = normal_color
    self.contents.draw_text(x, y, cx, WLH, string, 0)
    self.contents.font.color = system_color
    self.contents.draw_text(cx + 4, y, width - cx + 4, WLH, Vocab::gold, 0)  
  end  

  def update_cursor
    if @selected
      self.cursor_rect.set(0, 0, 168, height - 32)
    else
      self.cursor_rect.empty
    end
  end
end

#==============================================================================
# Scene_File
#------------------------------------------------------------------------------
# Operation of saved files on screen class.
#==============================================================================

class Scene_File < Scene_Base
include PowerPackVX_General_Configs

  def write_save_data(file)
    characters = []    
    for actor in $game_party.members
      characters.push([ actor.character_name, actor.character_index,
                        actor.face_name, actor.face_index, 
                        actor.name, actor.level ])
    end
    $game_system.save_count += 1
    $game_system.version_id = $data_system.version_id
    @last_bgm = RPG::BGM::last
    @last_bgs = RPG::BGS::last
    Marshal.dump(characters,           file)
    Marshal.dump(Graphics.frame_count, file)
    Marshal.dump(@last_bgm,            file)
    Marshal.dump(@last_bgs,            file)
    Marshal.dump($game_system,         file)
    Marshal.dump($game_message,        file)
    Marshal.dump($game_switches,       file)
    Marshal.dump($game_variables,      file)
    Marshal.dump($game_self_switches,  file)
    Marshal.dump($game_actors,         file)
    Marshal.dump($game_party,          file)
    Marshal.dump($game_troop,          file)
    Marshal.dump($game_map,            file)
    Marshal.dump($game_player,         file)
  end
  
  def start
    super    
    @file_max = Total_Saveslots
    create_menu_background    
    @help_window = Window_Help.new
    @page_file_max = ((Graphics.height - @help_window.height) / 120).truncate
    @spacing = ((Graphics.height - @help_window.height) - (@page_file_max * 120)) / 2
    
    create_dir_if_needed
    create_savefile_windows
    create_arrows
    if @saving
      @index = $game_temp.last_file_index
      @help_window.set_text(Vocab::SaveMessage)
    else
      @index = self.latest_file_index
      @help_window.set_text(Vocab::LoadMessage)
    end
    @savefile_windows[@index].selected = true
    for i in 0...@file_max
      window = @savefile_windows[i]
      if @index > @page_file_max - 1
        if @index < @file_max - @page_file_max - 1
          @top_row = @index
          window.y -= @index * window.height 
        elsif @index >= @file_max - @page_file_max
          @top_row = @file_max - @page_file_max
          window.y -= (@file_max - @page_file_max) * window.height 
        else
          @top_row = @index
          window.y -= @index * window.height 
        end
      end
      window.visible = (window.y >= (@help_window.height + @spacing)  and
      window.y < (@help_window.height + @spacing) + @page_file_max * window.height)
    end
  end
  
  alias sol_maker_terminate terminate unless $@
  def terminate
    sol_maker_terminate
    dispose_arrows
  end
  
  def create_dir_if_needed
    Dir.mkdir("Saveslots") unless File.directory?("Saveslots")
  end
  
  def create_arrows
    @sprite_arrow = Sprite.new
    @bitmap_arrow = Bitmap.new (16, Graphics.height - @help_window.height)
    @sprite_arrow.bitmap = @bitmap_arrow
    @sprite_arrow.x = ( Graphics.width / 2) - 8 
    @sprite_arrow.y = @help_window.height
    @sprite_arrow.z = 100
  end
  
  def dispose_arrows
    @bitmap_arrow.dispose unless @bitmap_arrow.nil?
    @sprite_arrow.dispose unless @sprite_arrow.nil?    
  end
  
  def update_arrows
    filename = $game_system.windowskin
    unless filename.nil?
      bitmap = Cache.system(filename)
    else
      bitmap = Cache.system("Window")
    end
    @bitmap_arrow.clear    
    @bitmap_arrow.blt (0, 0, bitmap, 
                          Rect.new(88,16,16,16)) if @index >  0 
    @bitmap_arrow.blt (0, @bitmap_arrow.height - 16, Cache.system("Window"), 
                          Rect.new(88,32,16,16)) if @index < Total_Saveslots - 1
  end
  
  def create_savefile_windows
    @top_row = 0
    @savefile_windows = []
    for i in 0...@file_max
      @savefile_windows.push(Window_SaveFile.new(i, make_filename(i),@help_window.height))
    end
    for i in @savefile_windows
      i.y += @spacing
    end
  end
  
  def make_filename(file_index)
    return "Saveslots/Save" + sprintf("%02d", file_index + 1) + ".rvdata"
  end

  def update_savefile_selection
    if Input.trigger?(Input::C)
      determine_savefile
    elsif Input.trigger?(Input::B)
      Sound.play_cancel
      return_scene
    else
      last_index = @index
      if Input.repeat?(Input::DOWN)  
          cursor_down(Input.trigger?(Input::DOWN))
      end
      if Input.repeat?(Input::UP) 
        cursor_up(Input.trigger?(Input::UP))  
      end
      if @index != last_index
        Sound.play_cursor
        @savefile_windows[last_index].selected = false
        @savefile_windows[@index].selected = true
      end      
    end
    update_arrows
  end

  def determine_savefile
    if @saving
      Sound.play_save
      do_save
    else
      if @savefile_windows[@index].file_exist
        Sound.play_load
        do_load
      else
        Sound.play_buzzer
        return
      end
    end
    $game_temp.last_file_index = @index
  end

  def cursor_down(wrap)
    Sound.play_buzzer if wrap and @index == Total_Saveslots - 1
    if @index < @file_max - 1 
      @index = (@index + 1) % @file_max
      for i in 0...@file_max
        window = @savefile_windows[i]
        if @index == 0
          @top_row = 0
          window.y = (@help_window.height + @spacing) + i % @file_max * window.height 
        elsif @index - @top_row > @page_file_max - 1
          window.y -= window.height 
        end
        window.visible = (window.y >= (@help_window.height + @spacing) and
          window.y < (@help_window.height + @spacing) + @page_file_max * window.height)
      end
      if @index - @top_row > @page_file_max - 1
        @top_row += 1
      end
    end
  end

  def cursor_up(wrap)
    Sound.play_buzzer if wrap and @index == 0
    if @index > 0 
      @index = (@index - 1 + @file_max) % @file_max
      for i in 0...@file_max
        window = @savefile_windows[i]
        if @index == @file_max - 1
          @top_row = @file_max - @page_file_max
          window.y = (@help_window.height + @spacing) + i % @file_max * window.height           
          window.y -= (@file_max - @page_file_max) * window.height
        elsif @index - @top_row < 0
          window.y += window.height 
        end
        window.visible = (window.y >= (@help_window.height + @spacing) and
          window.y < (@help_window.height + @spacing) + @page_file_max * window.height)        
      end
      if @index - @top_row < 0
        @top_row -= 1
      end
    end
  end

end

class Scene_Title < Scene_Base
  def check_continue
    @continue_enabled = (Dir.glob('Saveslots/Save*.rvdata').size > 0)
  end
end
