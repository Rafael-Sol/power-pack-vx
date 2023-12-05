#===============================================================================
#                RAFAEL_SOL_MAKER's VX SINGLE ICON & FACE v1.1
#              Based on 'Enable single icon usage' by snstar2006 
#-------------------------------------------------------------------------------
# Description:  Allows the use of individual faces, no matter the index used,
#               and also allows the use of custom icons and iconsets even in 
#               the Database.
#-------------------------------------------------------------------------------
# How to Use:   Put a '$' at the beginning of the file name and it will be used
#               as "unique" size, the script take care of the rest, regardless 
#               the selected index.
#               Additional iconsets should be placed in the folder 
#               'Graphics/Icons', if no file is specified it will use the 
#               default iconset.
#               To use a different icon in database use the command
#               <ICON "filename">, with no quotes, and to specify the icon you
#               can use <ICON_ID x> to select the one you want. (x is the ID)
#               The default iconset was kept for convenience in the editor and
#               compatibility.
#               It's possible to use two commands, if they are in the same
#               line use ';' to separate them. 
#-------------------------------------------------------------------------------
# Special Thanks: snstar2006 
#-------------------------------------------------------------------------------
#===============================================================================

module Cache
  def self.icon(filename)
    load_bitmap('Graphics/Icons/', filename)
  end  
end

module PowerPackVX_Advanced_Configs  
  ICON = /<(?:ICON|icon)\s*(.*)>/i  
  ICON_ID = /<(?:ICON_ID|icon id)\s*(\d+)>/i  
end

class RPG::BaseItem  
  include PowerPackVX_Advanced_Configs
    
  def prepare_base_functions
    @custom_icon = ''
    @custom_icon_index = 0
      
    self.note.split(/[\r\n;]+/).each { |line|
    case line
    when ICON_ID
      @custom_icon_index = $1.to_i 
    when ICON
      a = line.split(/ /)[1]
      d = ""
      while ((c = a.slice!(/./m)) != nil)
        d += c if c != ">"
      end
      @custom_icon = d
    end }
  end
    
  def custom_icon
    prepare_base_functions if @icon == nil
    return @custom_icon
  end
    
  def custom_icon_index
    prepare_base_functions if @icon_index == nil
    return @custom_icon_index
  end  
    
end
  
class Window_Base < Window
  
  def draw_face(face_name, face_index, x, y, size = 96)
    return if face_name == nil
    bitmap = Cache.face(face_name)
    sign = face_name[/^[\!\$]./]  
    rect = Rect.new(0, 0, size, size)
    if sign == nil or ! sign.include?('$')
      rect.x = face_index % 4 * 96 + (96 - size) / 2
      rect.y = face_index / 4 * 96 + (96 - size) / 2
    end
    self.contents.blt(x, y, bitmap, rect)
    bitmap.dispose
  end
  
  def draw_icon(icon_index, x, y, enabled = true, icon_name = "" )
    icon_name == "" ? bitmap = Cache.system("Iconset") : bitmap = Cache.icon(icon_name)
    sign = icon_name[/^[\!\$]./]
    icon_index = 0 if sign != nil and sign.include?("$")
    rect = Rect.new(icon_index % 16 * 24, icon_index / 16 * 24, 24, 24)    
    self.contents.blt(x, y, bitmap, rect, enabled ? 255 : 128)
  end
 
  def draw_item_name(item, x, y, enabled = true)
    if item != nil
      if item.custom_icon != ""
        index = item.custom_icon_index;  index = 0 if index.nil?    
        draw_icon(index, x, y, enabled, item.custom_icon)
      else
        draw_icon(item.icon_index, x, y, enabled)
      end
      self.contents.font.color = normal_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      self.contents.draw_text(x + 24, y, 172, WLH, item.name)
    end
  end

end
