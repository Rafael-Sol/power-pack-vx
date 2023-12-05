#===============================================================================
#             RAFAEL_SOL_MAKER's VX SCENE INTRO (2Kx LOGO) v1.3
#-------------------------------------------------------------------------------
# Descrição:    Possibilita a adição de um "slide show" de imagens, que pode ser
#               usado como um logotipo antes da tela de título, similar ao do 
#               RPG Maker 2000/2003. Também pode executar uma música de fundo e
#               é possível também utilizar no mapa usando o comando específico.
#-------------------------------------------------------------------------------
# Modo de usar: 
#   Todas as imagens devem ir para a pasta 'Graphics/Intro/';
#   Exemplo de uso in-game, colocar no comando 'Chamar Script': 
#
#      show_intro (["Imagem1","ImagemOutra","Imagem_N"], "Música", 
#                   <wait_time>, <fade_in_time>,<fade_out_time>)
#
# OBS.: Parâmetros entre <> são dados em frames, 60 equivalem a 1 segundo; 
#       todos esses parâmetros são opcionais.
#       Para não especificar uma música de fundo use 'nil'.
#-------------------------------------------------------------------------------
# Agradecimentos Especiais: PRCoders 
#-------------------------------------------------------------------------------
#===============================================================================

#===============================================================================
# UPDATES
#-------------------------------------------------------------------------------
# VX SCENE INTRO (2Kx LOGO) v1.2 -> v1.3
# * Mudança maior na estrutura, principalmente na parte das músicas, que estão 
#     devidamente configuradas em conjunto com os fadeouts gráficos, sendo que  
#     agora há um na mudança de uma cena para  a intro;
# * Agora ele também volta corretamente para a cena anterior, não importando qual
#     ela seja, ao invés de sempre voltar para o mapa. Pode ser algo útil;
# * Agora, caso não seja configurada uma música, ele não irá parar e interromper
#     todas as músicas e sons que já estiverem tocando;
# * Outros pequenos ajustes permitem que as Músicas de Fundo e Sons de Fundo  
#     (BGM & BGS) recebam fadeout e depois voltem a tocar corretamente 
#     logo após a Intro;
# * OBS.: Os Efeitos Sonoros e Efeitos Musicais (SE & ME) são interrompidos,  
#     sendo que o ME possui fadeout. Esses não voltarão a tocar novamente.
#-------------------------------------------------------------------------------
#===============================================================================

class Game_Interpreter  
  def show_intro (pictures, intro_music, wait = 60, fade_in = 60,  fade_out = 60)
    $scene = Scene_Intro.new (pictures, intro_music, wait, fade_in, fade_out)
  end
end

module Cache  
  def self.intro(filename)
    load_bitmap('Graphics/Intros/', filename)
  end
end

class Scene_Intro < Scene_Base
  include RPG
  
  def initialize (pictures, intro_music, wait_time, fade_in_time, fade_out_time)   
    @pictures = pictures  
    @intro_music = intro_music
    @wait_time = wait_time
    @fade_in_time = fade_in_time  
    @fade_out_time = fade_out_time
    
    unless $scene.nil?
      fade_out_music
      Graphics.fadeout (@fade_out_time)
    else
      update
    end    
  end
  
  def update
    play_intro_music; counter = 0
    @sprite = Sprite.new; @sprite.z = 9999
    
    for image in @pictures
      counter += 1
      Graphics.freeze  
      @sprite.bitmap = Cache.intro(image)
      Graphics.transition(@fade_in_time)
      
      for i in 0...@wait_time
        Graphics.update
        Input.update
        if Input.trigger?(Input::C)          
          break
        elsif Input.trigger?(Input::B)
          # FAZ_ALGO_AQUI...?
        end        
      end
      #Se for a última imagem, vamos "apagar" a música;
      fade_out_music if counter == @pictures.size
      
      Graphics.fadeout(@fade_out_time - 5)
      Graphics.wait(5) #Prevenindo algum flicker...      
    end
    
    replay_last_music
    Graphics.freeze    
    @sprite.dispose  unless @sprite.nil?
    
    unless $scene.nil?         
      $scene = $previous_scene
    end
  end    
   
  def fade_out_music
    unless @intro_music == nil  
      time = @fade_out_time * 33.33      
      ME.fade(time); SE.stop  
      Audio.bgm_fade(time); Audio.bgs_fade(time)
    end
  end
  
  def play_intro_music
    unless @intro_music == nil
      Audio.bgm_play ('Audio/BGM/' + @intro_music)
    end
  end
 
  def replay_last_music    
    unless @intro_music == nil
      BGM.last.play
      BGS.last.play
    end
  end
  
end

$scene = Scene_Intro.new (["Logo"], nil, 60, 30, 30)
