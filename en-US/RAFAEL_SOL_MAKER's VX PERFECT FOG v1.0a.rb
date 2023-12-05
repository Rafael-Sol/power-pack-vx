#===============================================================================
#                  RAFAEL_SOL_MAKER's VX PERFECT FOG v1.0a
#-------------------------------------------------------------------------------
# Descrição:    Adiciona um efeito de névoa similar ao do RPG Maker XP nos
#               mapas do RPG Maker VX, com funcionamento também semelhante.
#-------------------------------------------------------------------------------
# Modo de usar:
#
# Para mostrar a neblina, utilize no comando de evento 'Executar Script':
#
#   setup_fog (filename, opacity, zoom, hue, speed_x, speed_y, visible)
#
# Onde:       Equivale a:
# filename    > Nome do bitmap utilizado no efeito de névoa.
# hue         > Matiz(Coloração). Utilize um valor de 0 a 360.
# opacity     > Opacidade(Transparência). Utilize um valor de 0 a 255.
# blend_type  > Modo de mistura do bitmap da névoa. Veja abaixo.
# zoom        > Zoom, em escala. Valores decimais permitidos.
# speed_x     > Velocidade horizontal, em pixels. Valores negativos permitidos.
# speed_y     > Velocidade vertical, em pixels. Valores negativos permitidos.
# visible     > Visibilidade ou não da névoa. Use 'true' ou 'false'.
#
# Obs.: Todos os parâmetros são opcionais, valores padrão serão utilizados, se 
#  omitidos; É possível omitir somente os parâmetros da sua escolha;
#  Para omitir um valor basta usar 'nil' no seu lugar, sem as aspas;
#  O parâmetro 'blend_type' aceita 3 valores: BLEND_NORMAL, BLEND_ADD e 
#  BLEND_SUB, para utilização dos modos de mistura normal, adição e subtração,
# respectivamente. Coloque todos os gráficos de neblina na pasta 
# 'Graphics/Fogs/'.
# Você pode configurar os valores padrão no módulo de configurações gerais.
#
#   change_fog_tone(tone, [duration])
#    change_fog_opacity(opacity, [duration])
#
# Para mudar a tonalidade, e a opacidade da neblina, respectivamente; 
# Na tonalidade, utilize um objeto do tipo Tone,
# (Ex.: Tone.new(vermelho, verde, azul, [cinza]),
# Onde as cores aceitam valores de -255 a 255 e o cinza de 0 a 255;
# Para a opacidade utilize um valor de 0 a 255;
# O valor 'duration' é opcional, utilize um valor em frames,
# Se o valor for omitido a transição será imediata (0 frames).
#
#   hide_fog
#    show_fog 
#
# Utilize esses comandos para esconder e mostrar a névoa, respectivamente.
#
#-------------------------------------------------------------------------------
# Agradecimentos Especiais: Woratana, Miget man12
#-------------------------------------------------------------------------------
#===============================================================================

#===============================================================================
# UPDATES
#-------------------------------------------------------------------------------
# VX PERFECT FOG v1.0 -> v1.0a
# * Corrigida a prioridade da neblina, que agora aparece debaixo das mensagens;
#-------------------------------------------------------------------------------
#===============================================================================

module PowerPackVX_General_Configs 
  # FOG (NÉVOA)
  Fog_Filename = 'Fog01'  # Nome do bitmap
  Fog_Hue = 0             # Matiz(Coloração)
  Fog_Opacity = 256       # Opacidade
  Fog_Blend_Type = 0      # Modo de Mistura(Blend)
  Fog_Zoom = 1            # Escala de Zoom
  Fog_SpeedX = 4          # Velocidade Horizontal
  Fog_SpeedY = 4          # Velocidade Vertical
  Fog_Visible = true      # Visibilidade
end

module Cache
  def self.fog(filename)
    load_bitmap('Graphics/Fogs/', filename)
  end
end

class Game_Interpreter
  include PowerPackVX_General_Configs

  BLEND_NORMAL = 0  #Blend Mode: Normal
  BLEND_ADD = 1     #Blend Mode: Addition
  BLEND_SUB = 2     #Blend Mode: Subtraction

  #--------------------------------------------------------------------------
  # Inicialização da Névoa
  #--------------------------------------------------------------------------  
  def setup_fog (filename = Fog_Filename, hue = Fog_Hue, opacity = Fog_Opacity,
                  blend_type = Fog_Blend_Type, zoom = Fog_Zoom,  sx = Fog_SpeedX,
                  sy = Fog_SpeedY, visible = Fog_Visible)
    
    filename = Fog_Filename if filename.nil?
    hue = Fog_Hue if hue.nil?
    opacity = Fog_Opacity if opacity.nil?
    blend_type = Fog_Blend_Type if blend_type.nil?
    zoom = Fog_Zoom if zoom.nil?
    sx = Fog_SpeedX if sx.nil?
    sy = Fog_SpeedY if sy.nil?
    visible = Fog_Visible if visible.nil?

    # Iniciar a névoa, usa valores padrão caso algum valor seja omitido ('nil')
    $game_map.setup_fog (filename, hue, opacity , blend_type, zoom, sx, sy, visible)
  end

  #--------------------------------------------------------------------------
  # Tom da Névoa
  #--------------------------------------------------------------------------  
  def change_fog_tone (tone, duration = 0)
    # Iniciar troca do tom de cor
    $game_map.fog.start_tone_change(tone, duration)
    return true
  end

  #--------------------------------------------------------------------------
  # Opacidade da Névoa
  #--------------------------------------------------------------------------  
  def change_fog_opacity (opacity, duration = 0)
    # Iniciar troca do nível de opacidade
    $game_map.fog.start_opacity_change(opacity, duration)
    return true
  end
  
  #--------------------------------------------------------------------------
  # Esconder Névoa
  #--------------------------------------------------------------------------  
  def hide_fog
    # Tornar a névoa invisível
    $game_map.fog.visible = false
    return true
  end
  
  #--------------------------------------------------------------------------
  # Mostrar Névoa
  #--------------------------------------------------------------------------  
  def show_fog
    # Tornar a névoa visível novamente
    $game_map.fog.visible = true
    return true
  end

end

class Game_Fog
  attr_accessor :name
  attr_accessor :hue
  attr_accessor :opacity
  attr_accessor :blend_type
  attr_accessor :zoom
  attr_accessor :sx
  attr_accessor :sy
  attr_accessor :visible
  attr_reader   :ox
  attr_reader   :oy
  attr_reader   :tone

  def initialize
    @name = ""
    @hue = 0
    @opacity = 255.0
    @blend_type = 0
    @zoom = 100.0
    @sx = 0
    @sy = 0
    @ox = 0
    @oy = 0
    @visible = true
    @tone = Tone.new(0, 0, 0, 0)
    @tone_target = Tone.new(0, 0, 0, 0)
    @tone_duration = 0
    @opacity_duration = 0
    @opacity_target = 0
  end

  def setup (name, hue, opacity , blend_type, zoom, sx, sy, visible)
    @name = name
    @hue = hue
    @opacity =  opacity
    @blend_type = blend_type
    @zoom = zoom
    @sx = sx
    @sy = sy
    @visible = visible
    @ox = 0
    @oy = 0
    @tone = Tone.new(0, 0, 0, 0)
    @tone_target = Tone.new(0, 0, 0, 0)
    @tone_duration = 0
    @opacity_duration = 0
    @opacity_target = 0    
  end

  def start_tone_change(tone, duration)
    @tone_target = tone.clone
    @tone_duration = duration
    if @tone_duration == 0
      @tone = @tone_target.clone
    end
  end

  def start_opacity_change(opacity, duration)
    @opacity_target = opacity * 1.0
    @opacity_duration = duration
    if @opacity_duration == 0
      @opacity = @opacity_target
    end
  end

  def update
    @ox -= @sx 
    @oy -= @sy 
    if @tone_duration >= 1
      d = @tone_duration
      target = @tone_target
      @tone.red =   (@tone.red    * (d - 1) + target.red)   / d
      @tone.green = (@tone.green  * (d - 1) + target.green) / d
      @tone.blue =  (@tone.blue   * (d - 1) + target.blue)  / d
      @tone.gray =  (@tone.gray   * (d - 1) + target.gray)  / d
      @tone_duration -= 1
    end
    if @opacity_duration >= 1
      d = @opacity_duration
      @opacity = (@opacity * (d - 1) + @opacity_target) / d
      @opacity_duration -= 1
    end
  end

end

class Game_Map
attr_accessor :fog

  def setup_fog (name, hue, opacity, blend_type, zoom, sx, sy, visible)
    visible = true if visible != true and visible != false
    @fog = Game_Fog.new
    @fog.setup (name.to_s, hue.to_i, opacity.to_f, blend_type.to_i, 
    zoom.to_f, sx.to_i, sy.to_i, visible) rescue raise(ArgumentError,
 'Erro durante a configuração da Névoa!\nPor favor re-verifique os valores dados!')
  end

  def setup_fog_basic  
    @fog = Game_Fog.new
  end

  def update_fog
  end  

  alias solmaker_gamemap_fog_setup setup unless $@
  def setup(map_id)
    setup_fog_basic
    solmaker_gamemap_fog_setup(map_id)    
  end

  alias solmaker_gamemap_fog_update update unless $@
  def update 
    update_fog
    solmaker_gamemap_fog_update 
  end

end

class Spriteset_Map

  def init_fog
    @plane_fog = Plane.new (@viewport1)
    @plane_fog.z = 200
    @temp_name = ""; @temp_hue = 0
  end  
 
  def update_fog
    $game_map.fog.update
    if @temp_name != $game_map.fog.name or @temp_hue != $game_map.fog.hue
      if @plane_fog.bitmap != nil
        @plane_fog.bitmap.dispose
        @plane_fog.bitmap = nil
      end
      if $game_map.fog.name != ""
        @plane_fog.bitmap = Cache.fog($game_map.fog.name)
        @plane_fog.bitmap.hue_change ($game_map.fog.hue)
      end
      Graphics.frame_reset
    end

    @plane_fog.opacity =     $game_map.fog.opacity
    @plane_fog.blend_type =  $game_map.fog.blend_type
    @plane_fog.zoom_x =      $game_map.fog.zoom
    @plane_fog.zoom_y =      $game_map.fog.zoom
    @plane_fog.visible =     $game_map.fog.visible
    @plane_fog.tone =       $game_map.fog.tone
    
    @plane_fog.ox = ($game_map.display_x + $game_map.fog.ox)/8.0 unless @plane_fog.nil?
    @plane_fog.oy = ($game_map.display_y + $game_map.fog.oy)/8.0 unless @plane_fog.nil?
    @temp_name = $game_map.fog.name;   @temp_hue = $game_map.fog.hue
  end

  def dispose_fog
    #Previne um bug ao setar a saturação, desfazendo a saturação já processada
    @plane_fog.bitmap.hue_change -@temp_hue unless @plane_fog.bitmap.nil?
    Graphics.frame_reset
    @plane_fog.dispose unless @plane_fog.nil?
    @plane_fog = nil
  end

  alias solmaker_fog_initialize initialize unless $@
  def initialize
    init_fog
    solmaker_fog_initialize
  end

  alias solmaker_fog_update update unless $@
  def update
    update_fog
    solmaker_fog_update
  end

  alias solmaker_fog_dispose dispose unless $@
  def dispose
    dispose_fog
    solmaker_fog_dispose
  end

end
