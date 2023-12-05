#===============================================================================
#             RAFAEL_SOL_MAKER's VX REGEXP NOTETAG SYSTEM v1.0
#-------------------------------------------------------------------------------
# Descrição:    Função feita especialmente para padronizar a avaliação de 
#               expressões regulares sob a forma de Tagnotes no Power Pack.                
#               Esse script torna muito mais fácil e prática a obtenção dos  
#               valores desejados em meio ao texto e espaços em branco. 
#               Suporta também múltiplos valores, que são retornados num array,
#               quando os valores estão separados por vírgulas na mesma 
#               expressão, ou quando estão em outra expressão igual. 
#               O retorno de expressões do tipo 'Boolean' independe da opção 
#               'múltiplos valores' estar marcada com verdadeira ou não.
#-------------------------------------------------------------------------------
# Modo de usar: 
#                Sintaxe de uso:
#                eval_regexp (texto, expressão, [tipo_esperado], [multi_valores?])
#                  * Valores entre colchetes ("[]") são opcionais.
#                Onde:
#                  texto          -> Texto da onde as tags serão tiradas.
#                  expressão      -> Qual a palavra contida na expressão?
#                  tipo_esperado  -> Consulte o módule TYPES no fim do script.
#                  multi_valores? -> Se a função capturará mais de um valor.
#
#                Alguns exemplos de uso: 
#                  número = eval_regexp(texto, "número", TYPES::Numbers, true)
#                  número.nil? ?  @meu_número = 0 : @meu_número = número
#                  # Para expressões do tipo: <número 123, 456, 789>
#                
#                  @switch = eval_regexp(texto, "switch", TYPES::Boolean)
#                  # Para expressões do tipo: < switch >
#-------------------------------------------------------------------------------
# Agradecimentos Especiais: Yanfly, KGC, etc. pela idéia do sistema de notetags.
#-------------------------------------------------------------------------------
#===============================================================================

def eval_regexp (string, expression, type_expected = TYPES::Boolean, multi_values = false)

  if expression == "" or expression.include? (' ')
    raise(ArgumentError, "A expressão informada para o avaliador de expressões regulares é inválida! Por favor informe um valor válido e que não possua\nespaços em branco!")
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
  Boolean       = 0 # Somente como Tagnote de ativação (switch): <expressão>
  Numbers       = 1 # Numeros em geral: <expressão = 123> ou <expressão = -456>
  Percentage    = 2 # Usar como porcentagem: <expressão = 75%>
  Text          = 3 # Para nomes em geral, etc: <expressão = "agora/com/équio">
end
