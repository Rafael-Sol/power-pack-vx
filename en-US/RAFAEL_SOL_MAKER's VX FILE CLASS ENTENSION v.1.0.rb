#===============================================================================
#             RAFAEL_SOL_MAKER's VX FILE CLASS ENTENSION v.1.0
#  (Based on 'ftools.rb', an old default (now deprecated) module from Ruby)
#-------------------------------------------------------------------------------
# Description:  Extensão para o módulo File, para aumentar o número de funções e
#               consequentemente melhorar a tarefa da manipulação de arquivos.
#-------------------------------------------------------------------------------
# How to Use: -
#-------------------------------------------------------------------------------
# Special Thanks: Hirofumi Watanabe (author), Zachary Landau
#-------------------------------------------------------------------------------
#===============================================================================

class << File
  BUFFER_SIZE = 8 * 1024

#===============================================================================
# If <to> is a valid directory, <from> will be combined (appended) with <to>,
# putting the backslashes as necessary. Otherwise, <to> will be returned. 
# Useful to compose a directory with <from> and <to> if only the filename was
# specified in <to>.
#===============================================================================
  def append_dir(from, to)
    if directory? to
      join to.sub(%r([/\\]$), ''), basename(from)
    else
      return to
    end
  end

#===============================================================================
# Copies a file from <from> to <to>. If <to> is a directory, copies <from> to
# <to/from>.
#===============================================================================
  def copy(from, to)
    to = append_dir(from, to)
    fmode = stat(from).mode
    tpath = to
    not_exist = !exist?(tpath)

    from = open(from, "rb")
    to = open(to, "wb")
    begin
      while true
        to.syswrite from.sysread(BUFFER_SIZE)
      end
    rescue EOFError
      ret = true
    rescue
      ret = false
    ensure
      to.close
      from.close
    end
    chmod(fmode, tpath) if not_exist
    return ret
  end

#===============================================================================
# Moves a file from <from> to <to> using the 'copy' command. If <to> is a
# directory, movies from <from> to <to/from>.
# 
#===============================================================================
  def move(from, to)
    to = append_dir(from, to)
    
    if RUBY_PLATFORM =~ /djgpp|(cyg|ms|bcc)win|mingw/ and file? to
      unlink to
    end
    fstat = stat(from)
    begin
      rename from, to
    rescue
      from_stat = stat(from)
      copy from, to and unlink from
      utime(from_stat.atime, from_stat.mtime, to)
      begin
        chown(fstat.uid, fstat.gid, to)
      rescue
      end
    end
  end

#===============================================================================
# Returns <true> if the contents of the files <from> and <to> are identical.
#===============================================================================
  def compare(from, to)
    return false if stat(from).size != stat(to).size
    from = open(from, "rb")
    to = open(to, "rb")
    ret = false
    fr = tr = ''

    begin
      while fr == tr
        fr = from.read(BUFFER_SIZE)
        if fr
          tr = to.read(fr.size)
        else
          ret = to.read(BUFFER_SIZE)
          ret = !ret || ret.length == 0
          break
        end
      end
    rescue
      ret = false
    ensure
      to.close
      from.close
    end
    ret
  end

#===============================================================================
# Remove a listof files. Each parameter must be a filename that will be deleted.
# Returns the number of erased files.
#===============================================================================
  def remove_files(*files)    
    files.each do |file|
      begin
        unlink file        
      rescue Errno::EACCES # for Windows
        continue if symlink? file
        begin
          mode = stat(file).mode
          o_chmod mode | 0200, file
          unlink file          
        rescue
          o_chmod mode, file rescue nil
        end
      rescue
      end
    end
  end

#===============================================================================
# Create a directory and all the directory tree, if needed. Example given:
# File.make_dirs 'C:/Users/Admin/RPGVX'
# Will make it to create all the following directories, if they doesn't exists.
#  * C:/Users
#  * C:/Users/Admin
#  * C:/Users/Admin/RPGVX
#===============================================================================
  def make_dirs(*dirs)    
    mode = 0755
    for dir in dirs
      parent = dirname(dir)
      next if parent == dir or directory? dir
      make_dirs parent unless directory? parent      
      if basename(dir) != ""
        begin
          Dir.mkdir dir, mode
        rescue SystemCallError
          raise unless directory? dir
        end
      end
    end
  end

#===============================================================================
# If <from> and  <to> aren't the same file, it will copy <to> e set the
# permission mode to <mode>. If <to> is a directory, copies from <from> to
# <to/from>. IF <mode> is not specified, the default will be used.
#===============================================================================
  def install(from, to, mode = nil)
    to = append_dir(from, to)
    unless exist? to and compare from, to
      remove_files to if exist? to
      copy from, to
      chmod mode, to
    end
  end

end
