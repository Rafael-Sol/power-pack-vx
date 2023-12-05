#===============================================================================
#             RAFAEL_SOL_MAKER's VX REGEXP NOTETAG SYSTEM v1.0
#-------------------------------------------------------------------------------
#Description:   Function especially made to evaluate all the notetags on Power 
#               Pack using regular expressions.  This script makes it much 
#               easier and practical to obtain the wanted values between misc. 
#               text and empty space.  
#               Multiple return values are supported when these are separated 
#               with ‘;’ in the same expression or even inanother; all these 
#               values are returned in an array. 
#               For Boolean expressions, it doesn’t care if ‘multi_values’ is 
#               set to ‘true’ or ’false’.
#-------------------------------------------------------------------------------
# How to Use: 
#                Sintax:
#                eval_regexp (text, expr, [type_expected], [multi_values?])
#                  * Parameters between "[]" are optional.
#                Where:
#                  text           -> Text where we will search for the tags.
#                  expr           -> What word is contained in the expression?
#                  type_espected  -> Expected variable type. See TYPES below.
#                  multi_values?  -> The function will get more than one value?
#
#                Some using examples: 
#                  number = eval_regexp(text, "number", TYPES::Numbers, true)
#                  number.nil? ?  @my_number = 0 : @my_number = number
#                  # For expressions like: <number 123, 456, 789>
#                
#                  @switch = eval_regexp(text, "switch", TYPES::Boolean)
#                  # For expressions like: < switch >, returns true or false
#-------------------------------------------------------------------------------
# Special Thanks: Yanfly, KGC, etc. for the original idea of the notetag system.
#-------------------------------------------------------------------------------
#===============================================================================

def eval_regexp (string, expression, type_expected = TYPES::Boolean, multi_values = false)

  if expression == "" or expression.include? (' ')
    raise(ArgumentError, "The given expression to the regular expression evaluator is invalid! \nPlease use a valid value that doesn't have any empty space!")
  end

  values = ""; sign = ""
  sign = "\\s*\\=\\s*" unless type_expected == TYPES::Boolean
  if multi_values
    case type_expected
      when TYPES::Numbers
      values = "[\\-]?\\d+(\\s*,\\s*[\\-]?\\d+)*"
      when TYPES::Percentage
      values = "\\d+%(\\s*,\\s*\\d+%)*"
      when TYPES::Text
      values = "\"(.*)+\"(\\s*,\\s*\"(.*)+\")*"
    end
  else
    case type_expected
      when TYPES::Numbers
      values = "[\\-]?\\d+"
      when TYPES::Percentage
      values = "\\d+%"
      when TYPES::Text
      values = "\"(.*)+\""
    end
  end

  if type_expected == TYPES::Text
    substring = []; startin = -1; lenght = -1
    for n in 0..(string.size - 1)
      if string[n, 1] == '<'
        startin = n
      elsif string[n, 1] == '>' and startin > 0
        lenght = n - startin + 1
      end
      if startin > 0 and lenght > 0
        substring.push string[startin, lenght]
        startin = -1; lenght = -1
      end
    end
    return nil if substring == []
    string = substring 
  end
  
  result = []
  for str in string
    while true
      /<\s*#{expression}#{sign}(#{values})\s*>/i.match (str)
      break if $1.nil?
      result.push $1
      str = $~.post_match
    end
  end

  if type_expected == TYPES::Boolean
    return true if result != []
    return false
  end
  return nil if result == []  

  if multi_values
    temp_res = []
    for res in result
      res.split(/\s*,\s*/).each { |str| temp_res.push str }
    end
    result = temp_res
  end

  result.each_index {|index|
    case type_expected
      when TYPES::Numbers
      result[index] = result[index].to_i
      when TYPES::Percentage
      result[index] = result[index].to_f / 100
      when TYPES::Text
      result[index].gsub! (/\"/) {}
    end }
    
  return result[0] if !multi_values
  return result

end

module TYPES
  Boolean       = 0 # Use this like a switch or boolean tagnote: <expression>
  Numbers       = 1 # Numbers, in general cases: <expression = 123> ou <expression = -456>
  Percentage    = 2 # Use like percentage: <expression = 75%> # Returns 0.75F
  Text          = 3 # For texts in general, etc: <expression = "c:/we/gotta/power123">
end
