#===============================================================================
#             RAFAEL_SOL_MAKER's VX AUDIOFILE ENTENSION v.1.0
#        (Include implementations from 'Audio Position' 1.0, by OriginalWij)
#-------------------------------------------------------------------------------
# Description:  Complements the audio functions adding some new routines like
#               'ME.last' e 'SE.last' to paly again the last effects ran
#               recently. This version contains implementations from 
#               OriginalWij's script that adds the currently sound position
#               (eg.: BGM.position), it could be very useful for sincronizations
#               between then. In the future this script would be more powerful 
#               and give more control over all the audio files of your game.
#-------------------------------------------------------------------------------
# How to Use:   Just put the command of your preference, like:
#                 my_var = RPG::BGS.position
#               OBS.: If the sound is repeating or if it's already finishied,
#               the total execution time (position) will continue to increment, 
#               until you stop it, to reset the counter.
#-------------------------------------------------------------------------------
# Special Thanks: OriginalWij
#-------------------------------------------------------------------------------
#===============================================================================

module RPG  
 
  class BGM < AudioFile
    @@last = BGM.new
    @@position = 0
    def play
      if @name.empty?
        Audio.bgm_stop
        @@last = BGM.new
        @@position = 0
      else
        Audio.bgm_play("Audio/BGM/" + @name, @volume, @pitch)
        @@last = self
        @@position = Time.now
      end
    end
    
    def self.stop
      Audio.bgm_stop
      @@last = BGM.new
      @@position = 0
    end
    
    def self.fade(time)
      Audio.bgm_fade(time)
      @@last = BGM.new
      @@position = 0
    end
    
    def self.last
      return @@last
    end
    
    def self.position
      return 0 if @@position == 0
      return Time.now - @@position
    end
  end
  
  class BGS < AudioFile
    @@last = BGS.new
    @@position = 0
    def play
      if @name.empty?
        Audio.bgs_stop
        @@last = BGS.new
        @@position = 0
      else
        Audio.bgs_play("Audio/BGS/" + @name, @volume, @pitch)
        @@last = self
        @@position = Time.now
      end
    end
    
    def self.stop
      Audio.bgs_stop
      @@last = BGS.new
      @@position = 0
    end
    
    def self.fade(time)
      Audio.bgs_fade(time)
      @@last = BGS.new
      @@position = 0
    end
    
    def self.last
      return @@last
    end

    def self.position
      return 0 if @@position == 0
      return Time.now - @@position
    end
  end
  
  class ME < AudioFile
    @@last = ME.new
    @@position = 0
    def play
      if @name.empty?
        Audio.me_stop
        @@last = ME.new
        @@position = 0
      else
        Audio.me_play("Audio/ME/" + @name, @volume, @pitch)
        @@last = self        
        @@position = Time.now
      end       
    end
    
    def self.stop
      Audio.me_stop
      @@last = ME.new
      @@position = 0
    end
    
    def self.fade(time)
      Audio.me_fade(time)
      @@last = ME.new
      @@position = 0
    end
    
    def self.last
      return @@last
    end
    
    def self.position
      return 0 if @@position == 0
      return Time.now - @@position
    end    
  end  

  class SE < AudioFile
    @@last = SE.new
    @@position = 0
    def play      
      if @name.empty?
        Audio.se_stop
        @@last = SE.new
        @@position = 0
      else
        Audio.se_play("Audio/SE/" + @name, @volume, @pitch)
        @@last = self        
        @@position = Time.now
      end      
    end
    
    def self.stop
      Audio.se_stop
      @@last = SE.new
      @@position = 0
    end
    
    def self.fade(time)
      #Audio.se_fade(time) # IT DOESN'T EXISTS!!
      #@@last = SE.new
      #@@position = 0
      raise(NotImplementedError,"Sound Effects(SE) fade isn't avaliable yet in this version of the script! Try iy out in the future!")
    end
    
    def self.last
      return @@last
    end
    
    def self.position
      return 0 if @@position == 0
      return Time.now - @@position
    end    
  end
end
