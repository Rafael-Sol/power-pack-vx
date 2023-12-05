#===============================================================================
#              RAFAEL_SOL_MAKER's VX SCENE INTRO (2Kx LOGO) v1.3
#-------------------------------------------------------------------------------
# Description:  Enables the addition of a slide show of images that can also be
#               used as a logo before the title screen, like the one in
#               RPG Maker 2000/2003. You can also select a background music and
#               use as a scene in the map using the specific command.
#-------------------------------------------------------------------------------
# How to Use:
#   All images goes into the folder 'Graphics/Intro/';
#   To use it in-game, use the following command in 'Call Script':
#
#      show_intro (["Image1","OtherImage","Image_N"], "Music", 
#                   <wait_time>, <fade_in_time>, <fade_out_time>)
#
# OBS.: Parameters between <> are given in frames, 60 are equal to 1 second; 
#       all these parameters are optional.
#       If you don't want a background music just put 'nil' instead.
#-------------------------------------------------------------------------------
# Special Thanks: PRCoders 
#-------------------------------------------------------------------------------
#===============================================================================
 
#===============================================================================
# UPDATES
#-------------------------------------------------------------------------------
# VX SCENE INTRO (2Kx LOGO) v1.2 -> v1.3
# * Major structural change, mainly in the music handling, that now are
#     configurated to work together with the graphical fades, and now there is 
#     one in the changing of any scene to the intro scene;
# * Now it's  go back to the previus scene correctly, no matter what scene was,
#     instead always going back to the map. It's a fix and could be useful.
# * Now, if it's not specified any music, it will not stop all the musics and
#     sounds that are already running;
# * Other small adjusts allow the background Musics(BGMs) and Background Sounds 
#     (BGSs) to have a fadeout and run correctly short after the intro scene;
# * OBS.: The Sound Effects and Music Effects(SE & ME) will be stopped, since
#     the ME got a fadeout. They will not be ran again.
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
          # DO_SOMETHING_HERE...?
        end        
      end
      # If it's the last image, let's "erase out" the music;
      fade_out_music if counter == @pictures.size
      
      Graphics.fadeout(@fade_out_time - 5)
      Graphics.wait(5) #Prevent some flicker...      
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

# USE THESE LINES TO CONFIGURE A INTRO BEFORE TITLE SCREEN
if !$TEST 
  Scene_Intro.new (["Logo"], nil, 60, 30, 30)
end
