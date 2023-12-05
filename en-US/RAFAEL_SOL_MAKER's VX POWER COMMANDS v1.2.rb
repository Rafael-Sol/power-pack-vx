#===============================================================================
#           RAFAEL_SOL_MAKER's VX POWER COMMANDS v1.2
#-------------------------------------------------------------------------------
# Descrição:    Coletânea especial com mais de 40 comandos variados e funções 
#               novas, tudo pronto para utilizar. Extremamente poderoso!!
#-------------------------------------------------------------------------------
# Modo de usar: Utilize as funções com o comando 'Executar Script:' dos eventos,
#               os parâmetros entre colchetes '[]' são opcionais. 
=begin
        
COMANDOS PARA A EQUIPE
  party_full?
  party_state?      (state_id)
  party_skill_learn?(skill_id)  
  remove_all_equip  (id)  
  decreate_steps    ([value])
  reset_steps
  get_all_items

COMANDOS PARA EVENTOS & PERSONAGENS
  start_event_id    (id)
  get_event_id      (x, y)  
  start_event_xy    (x, y)
  set_custom_speed  ([speed], [target]) 
  move_route_wait    ([id])
  stop_all_movement
  move_all  
  mirror_character  ([target])
  unmirror_character([target])  

COMANDOS UTILITÁRIOS PARA LOTES
  reset_all_switches 
  reset_all_variables
  reset_all_self_switches 
  batch_self_switch  (map_id, key, state, name) 
  delete_pictures    ([start], [finish])

COMANDOS PARA MAPAS
  disable_scroll 
  enable_scroll 
  save_bgm
  play_saved_bgm
  increase_timer    (value)
  decrease_timer    (value)
  scroll_lower_left  (distance, [speed])
  scroll_lower_right(distance, [speed])
  scroll_upper_left  (distance, [speed])
  scroll_upper_right(distance, [speed])

COMANDOS PARA FIGURAS
  mirror_picture  ([id])  
  unmirror_picture([id])   
  shake_picture    ([id], [power], [duration])
  jump_picture    ([id], [duration], [height])

COMANDOS DE MUDANÇA DE GRÁFICOS
  set_windowskin      ([filename])
  set_message_back    ([filename])
  set_balloon_icon    ([filename])
  set_vehicle_shadow  ([filename])
  set_gameover_graphic([filename])
  set_title_graphic    ([filename])

OUTROS COMANDOS  
  open_browser ([url])

=end
#-------------------------------------------------------------------------------
# Agradecimentos Especiais: 
#               Esse script não seria sequer imaginável se não fosse a ajuda
#               de grandes mestres do scripting: Equipe Pockethouse 
#               (Engine Melody), Tomy (Biblioteca KGC) e Mr.Anonymous (RGSS2+)
#               Grande parte desses comandos são graças a eles! Muito obrigado!!
#-------------------------------------------------------------------------------
#===============================================================================

#===============================================================================
# UPDATES
#-------------------------------------------------------------------------------
# VX POWER COMMANDS v1.1 -> v1.2
# * COMANDOS DE MUDANÇA DE GRÁFICOS:
# * Melhorada bastante a estrutura para o tratamento de imagens inválidas;
# * Agora a troca da sombra dos veículos será executada sem erros;
# * Corrigidas umas falhas no balloon, que agora é exibido sem flicker;
# * Agora ele muda o gráfico de título corretamente; porém ele não salva esse
#     gráfico nos saveslots, já que é uma variável global;
#-------------------------------------------------------------------------------
#===============================================================================

class Game_Interpreter
include PowerPackVX_General_Configs
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def party_full?
    return $game_party.full?
  end

  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def party_state?
    return $game_party.state?
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def party_skill_learn?
    return $game_party.skill_learn?
  end 
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def remove_all_equip(id)
    actor = $game_actors[id]
    if actor != nil
      for i in 0..4
        actor.equip(i, 0)
      end
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def decrease_steps(value = 1)
    $game_party.decreate_steps(value)
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reset_steps
    $game_party.reset_steps
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------   
  def get_all_items
    items = []
    items += $data_items
    items += $data_weapons
    items += $data_armors
    for item in items.compact
      next if item.name == "" 
      $game_party.gain_item(item, 99)
    end
  end

  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def start_event_id(id)
    event = $game_map.events[id]
    @child_interpreter = Game_Interpreter.new(@depth + 1)
    @child_interpreter.setup(event.list, @event_id)
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def get_event_id(x, y)
    event_id = 0
    events   = $game_map.events.values.find_all { |e| e.x == x && e.y == y }
    event_id = (events.max { |a, b| a.id <=> b.id }).id unless events.empty?
    return event_id
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def start_event_xy(x, y)
    for event in $game_map.events_xy(x, y)
      event.start
    end
  end

  #--------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------- 
  def set_custom_speed(speed = 4, target = -1)
    character = get_character(target)
    character.set_move_speed(speed)
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def move_route_wait(id = 0)
    unless $game_temp.in_battle
      @moving_character = get_character(id)
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def disable_scroll
    $game_system.scroll_disabled = true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def enable_scroll
    $game_system.scroll_disabled = false
  end

  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def save_bgm
    $game_system.saved_bgm = RPG::BGM.last
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def play_saved_bgm
    if $game_system.saved_bgm != nil
      $game_system.saved_bgm.play
    end
  end

  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def increase_timer(value)
    $game_system.timer += value * Graphics.frame_rate
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def decrease_timer(value)
    $game_system.timer -= value * Graphics.frame_rate
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def scroll_lower_left(distance, speed = 4)
    $game_map.start_scroll(1, distance, speed)
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def scroll_lower_right(distance, speed = 4)
    $game_map.start_scroll(3, distance, speed)
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def scroll_upper_left(distance, speed = 4)
    $game_map.start_scroll(7, distance, speed)
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def scroll_upper_right(distance, speed = 4)
    $game_map.start_scroll(9, distance, speed)
  end  

  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------  
  def stop_all_movement
    $game_map.stop_all_movement = true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------  
  def move_all
    $game_map.stop_all_movement = false
  end  

  #--------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------- 
  def mirror_character(target = -1)
    character = get_character(target)
    character.mirror = true
    return true
  end  
  
  #--------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------- 
  def unmirror_character(target = -1)
    character = get_character(target)
    character.mirror = false
    return true
  end 

  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reset_all_switches    
    $game_switches = Game_Switches.new
    $game_map.refresh
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reset_all_variables
    $game_variables = Game_Variables.new
    $game_map.refresh
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def reset_all_self_switches
    $game_self_switches = Game_SelfSwitches.new
    $game_map.refresh
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def batch_self_switch(map_id, key, state, name)
    map = load_data(sprintf("Data/Map%03d.rvdata", map_id))
    events = []
    for i in map.events.keys
      events[i] = Game_Event.new(map_id, map.events[i])
    end
    for event in events
      next if event == nil
      id = event.id
      if event.name.include?(name) 
        $game_self_switches[[map_id, id, key]] = state
      end
    end
    $game_map.refresh if map_id == $game_map.map_id
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def delete_pictures(start = 1, finish = 20)
    for i in start..finish
      $game_screen.pictures[i].erase
    end
  end  
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def mirror_picture(id = 1)
    screen.pictures[id].mirror = true
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def unmirror_picture(id = 1)
    screen.pictures[id].mirror = false
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def shake_picture(id = 1, power = 1, duration = 1)
    screen.pictures[id].shake(power, duration)
    return true
  end  
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def jump_picture(id = 1, height = 20, duration = 8)
    screen.pictures[id].jump(height, duration)
    return true
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_windowskin(filename = nil)
    $game_system.windowskin = filename
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_message_back(filename = nil)
    $game_system.message_back = filename
  end 
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_balloon_icon(filename = nil)
    $game_system.balloon_icon = filename
  end
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_vehicle_shadow(filename = nil)
    $game_system.vehicle_shadow = filename
  end  
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_gameover_graphic(filename = nil)
    $game_system.gameover_graphic = filename
  end
  
  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def set_title_graphic(filename = nil)
    $game_system.title_graphic = filename
  end

  #--------------------------------------------------------------------------
  # 
  #--------------------------------------------------------------------------
  def open_browser(url = "http://www.condadobraveheart.com")
    browser = Win32API.new("shell32", "ShellExecuteA", %w(p p p p p i), "i") 
    browser.call(0, "open", url, 0, 0, 1) 
  end
  
end

#===============================================================================
#                        VX POWER COMMANDS FUNCTIONS
#-------------------------------------------------------------------------------
#===============================================================================

#===============================================================================
# Game_Map
#===============================================================================
class Game_Map
  attr_accessor :stop_all_movement
  
  alias sol_maker_initialize initialize unless $@
  def initialize 
    sol_maker_initialize
    @stop_all_movement = nil
  end
  
  def update_scroll
    if @scroll_rest > 0
      distance = 2 ** @scroll_speed
      case @scroll_direction
      when 1  
        scroll_down(distance)
        scroll_left(distance)
      when 2  
        scroll_down(distance)
      when 3  
        scroll_down(distance)
        scroll_right(distance)
      when 4  
        scroll_left(distance)
      when 6  
        scroll_right(distance)
      when 7  
        scroll_up(distance)
        scroll_left(distance)
      when 8 
        scroll_up(distance)
      when 9  
        scroll_up(distance)
        scroll_right(distance)
      end
      @scroll_rest -= distance
    end
  end
  
end

#===============================================================================
# Game_System
#===============================================================================
class Game_System
  attr_accessor :saved_bgm
  attr_accessor :windowskin 
  attr_accessor :message_back
  attr_accessor :balloon_icon            
  attr_accessor :vehicle_shadow
  attr_accessor :gameover_graphic
  attr_accessor :scroll_disabled          
  
  alias sol_maker_initialize initialize unless $@
  def initialize 
    sol_maker_initialize
    @saved_bgm          = nil
    @windowskin         = nil
    @message_back       = nil
    @balloon_icon      = nil
    @vehicle_shadow    = nil
    @gameover_graphic  = nil
    @scroll_disabled    = false  
  end
  
  def save_bgm
    @saved_bgm = RPG::BGM.last
  end
  
  def play_saved_bgm
    if @saved_bgm != nil
      @saved_bgm.play
    end
  end
  
end

#===============================================================================
# Game_Character
#===============================================================================
class Game_Character
  attr_accessor :mirror

  alias sol_maker_initialize initialize unless $@
  def initialize
    sol_maker_initialize
    @mirror = false
  end
  
  alias sol_maker_update_self_movement update_self_movement unless $@
  def update_self_movement
    return if $game_map.stop_all_movement
    sol_maker_update_self_movement
  end
  
end

#===============================================================================
# Game_Player
#===============================================================================
class Game_Player < Game_Character  

  def update
    last_real_x = @real_x
    last_real_y = @real_y
    last_moving = moving?
    move_by_input
    super
    update_scroll(last_real_x, last_real_y) unless $game_system.scroll_disabled
    update_vehicle
    update_nonmoving(last_moving)
  end
  
end

#===============================================================================
# Game_Picture
#===============================================================================
class Game_Picture
  attr_accessor :mirror
 
  alias sol_maker_initialize initialize unless $@
  def initialize(number)  
  sol_maker_initialize(number) 
    @shake_x        = @x
    @shake_y        = @y
    @shake_duration = 0
    @shake_power    = 1
    @shake_flag     = 1
    @jump_down      = @y
    @jump_up        = @y - 20.0
    @jump_duration  = 0
    @mirror = false
  end
  
  alias sol_maker_update update unless $@
  def update
  sol_maker_update
    if @shake_duration >= 1
      @shake_flag *= -1
      f = @shake_flag
      @x = @shake_x + ((@x - @shake_x) + rand(@shake_power) * (f * -1)) * f
      @y = @shake_y + ((@y - @shake_y) + rand(@shake_power) * (f * -1)) * f
      @shake_duration -= 1
      if @shake_duration <= 0
        @x = @shake_x
        @y = @shake_y
      end
    end
    if @jump_duration >= 1
      d = @jump_duration
      if d >= 5
        d -= 4 
        @y = (@y * (d - 1) + @jump_up) / d
      else
        @y = (@y * (d - 1) + @jump_down) / d
      end
      @jump_duration -= 1
    end
  end
  
  def shake(power, duration)
    @shake_power = power
    @shake_duration = duration
    @shake_x = @x
    @shake_y = @y
  end
  
  def jump(height = 20, duration = 8)
    @jump_duration = duration
    @jump_up = @y - height.to_f
    @jump_down = @y 
  end

end

#===============================================================================
# Game_Party
#===============================================================================
class Game_Party < Game_Unit  
  
  def full?
    return (@actors.size >= MAX_MEMBERS)
  end
  
  def reset_steps
    @steps = 0
  end

  def decrease_steps(value)
    @steps -= value
    @steps = 0 if @steps < 0
  end

  def skill_learn?(skill_id)
    for actor in members
      return true if actor.skill_learn?($data_skills[skill_id])
    end
    return false
  end

  def state?(state_id)
    for actor in members
     return true if actor.state?(state_id)
    end
    return false
  end
  
end

#===============================================================================
# Sprite_Picture
#===============================================================================
class Sprite_Picture < Sprite
  
  alias update_sprite_picture_rf update unless $@
  def update
    if @picture == nil
      $game_map.screen.clear
      return
    end
    update_sprite_picture_rf
    self.mirror = @picture.mirror
  end
  
end 

#===============================================================================
# Sprite_Picture
#===============================================================================
class Sprite_Character < Sprite_Base
  attr_accessor :balloon_name

  def start_balloon
    dispose_balloon
    @balloon_duration = 8 * 8 + BALLOON_WAIT
    @balloon_sprite = ::Sprite.new(viewport)
    @balloon_sprite.bitmap = Cache.system($game_system.balloon_icon) rescue Cache.system("Balloon")
    @balloon_sprite.ox = 16
    @balloon_sprite.oy = 32
    update_balloon
  end
  
  alias sol_maker_update update unless $@
  def update
    sol_maker_update
    self.mirror = @character.mirror
  end
end

#===============================================================================
# Spriteset_Map
#===============================================================================
class Spriteset_Map
  attr_accessor :vehicle_shadow_name  

  alias sol_maker_create_shadow create_shadow unless $@
  def create_shadow
    sol_maker_create_shadow
    set_vehicle_shadow
  end
  
  alias sol_maker_update_shadow update_shadow unless $@
  def update_shadow
    set_vehicle_shadow
    sol_maker_update_shadow
  end
  
  def set_vehicle_shadow
    if @vehicle_shadow_name != $game_system.vehicle_shadow
      @vehicle_shadow_name = $game_system.vehicle_shadow
      @shadow_sprite.bitmap = Cache.system(@vehicle_shadow_name) rescue Cache.system("Shadow")
    end
  end
  
end

#===============================================================================
# Spriteset_Map
#===============================================================================
class Window_Base < Window
  attr_accessor :windowskin_name

  alias sol_maker_initialize initialize unless $@
  def initialize(x, y, width, height)
    sol_maker_initialize(x, y, width, height)
    set_windowskin
  end
  
  alias sol_maker_update update unless $@
  def update
  sol_maker_update
  @windowskin_name  = nil  
    set_windowskin
  end
  
  def set_windowskin
    if @windowskin_name != $game_system.windowskin
      @windowskin_name = $game_system.windowskin      
      self.windowskin = Cache.system($game_system.windowskin) rescue Cache.system("Window")
    end
  end
  
end

#===============================================================================
# Window_Message
#===============================================================================
class Window_Message < Window_Selectable
  attr_accessor :messageback_name
  
  alias sol_maker_create_back_sprite create_back_sprite unless $@
  def create_back_sprite
    sol_maker_create_back_sprite  
    set_message_back
  end
  
  alias sol_maker_update_back_sprite update_back_sprite unless $@
  def update_back_sprite
    sol_maker_update_back_sprite
    set_message_back
  end
  
  def set_message_back
    if @messageback_name != $game_system.message_back
      @messageback_name = $game_system.message_back      
      @back_sprite.bitmap = Cache.system($game_system.message_back) rescue Cache.system("MessageBack")
    end
  end
  
end

#===============================================================================
# Scene_Title
#===============================================================================
class Scene_Title < Scene_Base
  
  alias sol_maker_create_title_graphic create_title_graphic unless $@
  def create_title_graphic
    @sprite = Sprite.new
    @sprite.bitmap = Cache.system($temp_title_graphic) rescue Cache.system("Title")
  end
  
end

#===============================================================================
# Scene_Gameover
#===============================================================================
class Scene_Gameover < Scene_Base
  
  alias sol_maker_create_gameover_graphic create_gameover_graphic unless $@
  def create_gameover_graphic
    sol_maker_create_gameover_graphic
    @sprite.bitmap = Cache.system($game_system.gameover_graphic) rescue Cache.system("GameOver")
  end
  
end
