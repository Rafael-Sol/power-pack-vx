#===============================================================================
#                             RAFAEL_SOL_MAKER's
#                     VX KEYBOARD INPUT MODULE PT-BR v1.0
#                    (Baseado no Script 'Keyboard Input')
#              [Feito em uma parceria entre OriginalWij e Yanfly]
#-------------------------------------------------------------------------------
# Descrição:    Módulo de entrada do teclado que permite a captura de teclas 
#               adicionais além das padrão, trazendo várias teclas novas de
#               função, teclas alfanuméricas, e acentuações, providenciando a 
#               captura de praticamente todas as teclas de um teclado 101/102   
#               teclas com suporte total para layout para Português do Brasil.
#-------------------------------------------------------------------------------
# Modo de usar: Vide abaixo.
#-------------------------------------------------------------------------------
# Agradecimentos Especiais: Yanfly, OriginalWij
#-------------------------------------------------------------------------------

#===============================================================================
#-------------------------------------------------------------------------------
#                             INSTRUÇÕES DE USO:
#-------------------------------------------------------------------------------
#===============================================================================
#   Para aqueles curiosos que desejam saber como receber certas letras enquanto
#   codificando seus comandos de entrada, use o seguinte como referência:
#   
#   REFERÊNCIA: Teclas-padrão que já acompanham o RPG Maker VX:
#     DOWN, LEFT, RIGHT, UP, A, B, C, X, Y, Z, L, R, 
#     SHIFT, CTRL, ALT, F5, F6, F7, F8, F9
#
#   KEYS::A até KEYS::Z e KEYS::Ç 
#     Retorna 'true'(verdadeiro) se a tecla da respectiva letra for pressionada.
#
#   NUMS[0] até NUMS[9]
#     Retorna 'true'(verdadeiro) se a tecla do respectivo número da fileira do
#     topo for pressionada. Não inclui os números no teclado numérico.
#   
#   NUMPAD[0] até NUMPAD[9]
#     Retorna 'true'(verdadeiro) se a tecla do respectivo número do teclado
#     numérico for pressionada. Não inclui os números na fileira do topo do 
#     teclado.
#
#   F1 até F12
#     Retorna 'true'(verdadeiro) se a respectiva tecla de função for 
#     pressionada. Incluem-se aqui as teclas F1, F2 e F12 que são reservadas 
#     para uso no RPG Maker, o uso dessas não é recomendado.
#
#   Abaixo se encontra uma lista de referência das outras teclas presentes:
#
#   Símbolos:
#      (NOME) |(TECLA)
#     USCORE  |  - 
#     EQUALS  |  = 
#     COMMA   |  , 
#     PERIOD  |  . 
#     SCOLON  |  ; 
#     QUOTE   |  ' 
#     SLASH   |  / 
#     BSLASH  |  \ 
#     LBRACE  |  [ 
#     RBRACE  |  ] 
#     TILDE   |  ~ 
#     ACCENT  |  ´ 
#     NMUL    |  * (do teclado numérico)
#     NPLUS   |  + (do teclado numérico)
#     NSEP    |  , (do teclado numérico)
#     NMINUS  |  - (do teclado numérico)
#     NDECI   |  . (do teclado numérico)
#     NDIV    |  / (do teclado numérico)
#
#   Teclas de Comando:
#      (NOME) |(TECLA)
#     BACK    |  Backspace
#     ENTER   |  Enter/Return
#     SPACE   |  Barra de Espaço
#     ESC     |  Escape(ESC)
#     APPS    |  Tecla Aplicações (Menu)
#     PSCREEN |  Print Screen
#     PAUSE   |  Pause
#     INSERT  |  Insert
#     DELETE  |  Delete
#     PGUP    |  Page Up
#     PGDOWN  |  Page Down
#     HOME    |  Home
#     ENDKEY  |  End
#     LWIN    |  Tecla Windows(esquerda)
#     RWIN    |  Tecla Windows(direita)
#     LSHIFT  |  Shift(esquerda)
#     RSHIFT  |  Shift(direita)
#     LCTRL   |  Control(esquerda)
#     RCTRL   |  Control(direita)
#     LALT    |  Tecla Menu/Alt(esquerda)
#     ALTGR   |  Tecla Menu/Alt Gr(direita)
#   
#   Teclas de "Trava":
#      (NOME) |(TECLA)
#     CAPS    |  Caps Lock
#     NUM     |  Numeric Lock
#     SCROLL  |  Scroll Lock
#
#   Métodos Novos do Módulo:
#     Input.typing?
#       Para checar se há alguma digitação ocorrendo. Retorna verdadeiro ou falso.
#     Input.key_type
#       Returns whatever key is being used to type as a string.
#     Exemplo:
#     if Input.typing?
#       string += Input.key_type
#     end 
#     upcase?  caps? num? scroll?
#
#-------------------------------------------------------------------------------
#===============================================================================

#===============================================================================
# Input
#===============================================================================
class << Input  
  #--------------------------------------------------------------------------
  # Aliases (Ligadas ao Módulo)
  #--------------------------------------------------------------------------
  alias rsm_keybd_press press? unless $@
  alias rsm_keybd_trigger trigger? unless $@
  alias rsm_keybd_repeat repeat? unless $@
  alias rsm_keybd_update update unless $@
end

module Input
  #--------------------------------------------------------------------------
  # Constantes do Módulo
  #--------------------------------------------------------------------------
  module KEYS
    A = 65; B = 66; C = 67; D = 68; E = 69; F = 70; G = 71; H = 72; I = 73; 
    J = 74; K = 75; L = 76; M = 77; N = 78; O = 79; P = 80; Q = 81; R = 82; 
    S = 83; T = 84; U = 85; V = 86; W = 87; X = 88; Y = 89; Z = 90; Ç = 186
  end

  NUMS =   [48, 49, 50, 51, 52, 53, 54, 55, 56, 57]
  NUMPAD = [96, 97, 98, 99, 100, 101, 102, 103, 104, 105]  
  F1  = 112; F2  = 113; F3  = 114; F4 = 115
  F10 = 121; F11 = 122; F12 = 123  
  CAPS   = 320; NUM   = 144; SCROLL = 145
  BACK   = 308; TAB   = 309; ENTER  = 313; ESC    = 327; SPACE  = 332  
  APPS = 93; PSCREEN = 44; PAUSE = 19; INSERT = 45; DELETE = 46
  PGUP = 33; PGDOWN  = 34; HOME  = 36; ENDKEY   = 35; KEYEND   = 35
  LWIN  = 91;  RWIN = 92;   LSHIFT = 160; RSHIFT = 161
  LCTRL = 162; RCTRL = 163; LALT   = 164; ALTGR  = 165
  NMUL   = 106; NPLUS  = 107; NSEP   = 108; NMINUS = 109
  NDECI  = 110; NDIV   = 111  
  EQUALS = 187; COMMA = 188;  USCORE = 189; PERIOD = 190
  SCOLON = 191; TILDE  = 222; QUOTE  = 192; ACCENT = 219
  LBRACE = 221; RBRACE = 220; SLASH  = 193; BSLASH = 226

  Extras = 
  [EQUALS, COMMA, USCORE, PERIOD, SCOLON, TILDE,
   QUOTE, ACCENT, LBRACE, RBRACE, SLASH, BSLASH,
   NMUL, NPLUS, NSEP, NMINUS, NDECI, NDIV]    

  #--------------------------------------------------------------------------
  # Configuração inicial do Módulo
  #--------------------------------------------------------------------------
  GetKeyState  = Win32API.new("user32", "GetAsyncKeyState", "i", "i") 
  GetLocksState = Win32API.new("user32", "GetKeyState", "i", "i") 
  KeyRepeatCounter = {}
  module_function 
  
  #--------------------------------------------------------------------------
  # método 'aliased': update
  #--------------------------------------------------------------------------
  def update
    rsm_keybd_update
    for key in KeyRepeatCounter.keys
      if (GetKeyState.call(key).abs & 0x8000 == 0x8000)
        KeyRepeatCounter[key] += 1
      else
        KeyRepeatCounter.delete(key)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # método 'aliased': press?
  #--------------------------------------------------------------------------
  def press?(key)
    return rsm_keybd_press(key) if key < 30
    adjusted_key = adjust_key(key)
    return true unless KeyRepeatCounter[adjusted_key].nil?
    return key_pressed?(adjusted_key)
  end
  
  #--------------------------------------------------------------------------
  # método 'aliased': trigger?
  #--------------------------------------------------------------------------
  def trigger?(key)
    return rsm_keybd_trigger(key) if key < 30
    adjusted_key = adjust_key(key)
    count = KeyRepeatCounter[adjusted_key]
    return ((count == 0) or (count.nil? ? key_pressed?(adjusted_key) : false))
  end
  
  #--------------------------------------------------------------------------
  # método 'aliased': repeat?
  #--------------------------------------------------------------------------
  def repeat?(key)
    return rsm_keybd_repeat(key) if key < 30
    adjusted_key = adjust_key(key)
    count = KeyRepeatCounter[adjusted_key]
    return true if count == 0
    if count.nil?
      return key_pressed?(adjusted_key)
    else
      return (count >= 23 and (count - 23) % 6 == 0)
    end
  end
  
  #--------------------------------------------------------------------------
  # novo método: adjust_key
  #--------------------------------------------------------------------------
  def adjust_key(key)
    key -= 300 if key > 300
    return key
  end
  
  #--------------------------------------------------------------------------
  # novo método: key_pressed?
  #--------------------------------------------------------------------------
  def key_pressed?(key)
    if (GetKeyState.call(key).abs & 0x8000 == 0x8000)
      KeyRepeatCounter[key] = 0
      return true
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # novo método: typing?
  #--------------------------------------------------------------------------
  def typing?
    return true if repeat?(SPACE)
    return true if repeat?(186)
    for i in 65..90
      return true if repeat?(i)
    end    
    for i in 0...NUMS.size
      return true if repeat?(NUMS[i])
      return true if repeat?(NUMPAD[i])
    end
    for key in Extras
      return true if repeat?(key)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # novo método: key_type
  #--------------------------------------------------------------------------
  def key_type
    return " " if repeat?(SPACE)
    return (upcase? ? "Ç" : "ç") if repeat?(186)
    n = 65
    for i in 'A'..'Z'
      next unless repeat?(n)
      return upcase? ? i.upcase : i.downcase
       n += 1
    end    
    for i in 0...NUMS.size
      return i.to_s if repeat?(NUMPAD[i])
      if !press?(SHIFT)
        if press?(ALTGR) and repeat?(NUMS[i])
          case i
            when 1; return "¹"
            when 2; return "²"
            when 3; return "³"
            when 4; return "£"
            when 5; return "¢"
            when 6; return "¬"
            when 7..9, 0; return ""
          end
        end
        return i.to_s if repeat?(NUMS[i])
      elsif repeat?(NUMS[i])
        case i
          when 1; return "!"
          when 2; return "@"
          when 3; return "#"
          when 4; return "$"
          when 5; return "%"
          when 6; return "¨"
          when 7; return "&"
          when 8; return "*"
          when 9; return "("
          when 0; return ")"
        end
      end
    end       #"§" "ª" "º" "°" 
              #=[]/
    for key in Extras
      next unless repeat?(key)
      case key      
        when EQUALS; return press?(SHIFT) ? "+" : "="
        when COMMA;  return press?(SHIFT) ? "<" : ","
        when USCORE; return press?(SHIFT) ? "_" : "-"
        when PERIOD; return press?(SHIFT) ? ">" : "."
          
        when LBRACE; return press?(SHIFT) ? "{" : "["
        when RBRACE; return press?(SHIFT) ? "}" : "]"
        when SLASH;  return press?(SHIFT) ? "?" : "/"
        when BSLASH; return press?(SHIFT) ? "|" : "\\"
        when SCOLON; return press?(SHIFT) ? ":" : ";"
        when QUOTE;  return press?(SHIFT) ? "\"" : "'"
        when ACCENT; return press?(SHIFT) ? "`" : "´"
        when TILDE;  return press?(SHIFT) ? "^" : "~"
        
        when NMUL;   return "*"
        when NPLUS;  return "+"
        when NSEP;   return ","
        when NMINUS; return "-"
        when NDECI;  return "."
        when NDIV;   return "/"
      end
    end
    return ""
  end
  
  #--------------------------------------------------------------------------
  # novo método: upcase?
  #--------------------------------------------------------------------------
  def upcase?
    return !press?(SHIFT) if caps?
    return true if press?(SHIFT)
    return false
  end
  
  #--------------------------------------------------------------------------
  # novo método: caps?
  #--------------------------------------------------------------------------
  def caps?
    return true if GetLocksState.call(adjust_key(CAPS)) == 1
    return false
  end
  
  #--------------------------------------------------------------------------
  # novo método: num?
  #--------------------------------------------------------------------------  
  def num?
    return true if GetLocksState.call(NUM) == 1
    return false
  end
  
  #--------------------------------------------------------------------------
  # novo método: scroll?
  #--------------------------------------------------------------------------  
  def scroll?
    return true if GetLocksState.call(SCROLL) == 1
    return false
  end
  
end # Input
