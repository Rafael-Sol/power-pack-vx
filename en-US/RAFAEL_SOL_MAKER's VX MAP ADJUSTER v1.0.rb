#===============================================================================
#         RAFAEL_SOL_MAKER's VX MAP ADJUSTER v1.0 (Add-on para resoluções)
#-------------------------------------------------------------------------------
# Descrição:    Automaticamente redimensiona o seu mapa, caso ele seja menor
#               que a tela, para prevenir um erro na rolagem (scrolling) desse.
#               Ele alerta ao rodar o jogo, e também pode salvar o mapa já no 
#               tamanho correto e preeenchido, caso esteja em modo de testes.
#               Esse código todo vem do fato de que não é possivel redimensionar 
#               Tables de um mapa diretamente sem resultar em travamento do jogo 
#               OBS.: De modo geral, requer um script de resolução que a tela
#                fosse redimensionada e então seja feito algum trabalho...
#-------------------------------------------------------------------------------
# Modo de usar: Basta configurar ele no modo de configurações avançadas (abaixo)
#-------------------------------------------------------------------------------
# Agradecimentos Especiais: -
#-------------------------------------------------------------------------------
#===============================================================================

module PowerPackVX_Advanced_Configs
  Auto_Resize_Map = true    # Redimensionar automaticamente os mapas menores?
  Save_Resized_Map = false  # Salvar o mapa redimensionado?
  Filler_Tile_ID = 2816     # ID do tile para preencher as lacunas
end

class Game_Map
include PowerPackVX_Advanced_Configs

  alias sol_maker_setup setup unless $@
  def setup(map_id)
    sol_maker_setup (map_id)
    if Auto_Resize_Map
      # Descobre qual o tamanho mínimo ideal para o mapa;
      wd = Graphics.width / 32
      wd += 1 if (Graphics.width % 32) > 0
      hg = Graphics.height / 32
      hg += 1 if (Graphics.height % 32) > 0    
      if @map.width < wd or @map.height < hg
        if $TEST 
          print 'O mapa precisa ter o tamanho mínimo de ' + wd.to_s + 
            ' tiles de largura, por '+ hg.to_s + 
            ' tiles de altura para a resolução selecionada;',
            'Ele será redimensionado automaticamente para esse tamanho.'
          resize_map (wd,hg)
        end #if $TEST
      end #if map width/height
    end #if Resize
  end
  
  
  def resize_map (mapwidth, mapheight)  
    # Cria um novo mapa;
    map2 = RPG::Map.new ([@map.width, mapwidth].max, [@map.height, mapheight].max)    
    # Preenche ele todo com um padrão só...
    for x in 0.. map2.width-1
      for y in 0..map2.height-1
        map2.data[x,y,0] = Filler_Tile_ID
        map2.data[x,y,1] = 0
        map2.data[x,y,2] = 0
      end
    end 
    # "Coloca" o mapa aberto dentro do novo;
    for x in 0..@map.width-1
      for y in 0..@map.height-1
        for z in 0..2
          map2.data[x,y,z] = @map.data[x,y,z]
        end
      end
    end 
    # Passar todas as propriedades, obviamente;
    map2.scroll_type = @map.scroll_type
    map2.autoplay_bgm = @map.autoplay_bgm 
    map2.bgm = @map.bgm
    map2.autoplay_bgs = @map.autoplay_bgs 
    map2.bgs = @map.bgs
    map2.disable_dashing = @map.disable_dashing
    map2.encounter_list = @map.encounter_list 
    map2.encounter_step = @map.encounter_step 
    map2.parallax_name = @map.parallax_name
    map2.parallax_loop_x = @map.parallax_loop_x
    map2.parallax_loop_y = @map.parallax_loop_y
    map2.parallax_sx = @map.parallax_sx
    map2.parallax_sy = @map.parallax_sy
    map2.parallax_show = @map.parallax_show 
    map2.events = @map.events
    # O mapa enfim fica pronto, descarta o mapa temporário.
    @map = map2; map2 = nil
    if Save_Resized_Map
      save_data(@map, sprintf("Data/Map%03d.rvdata", @map_id)) 
      print 'O mapa foi devidamente redimensionado e salvo com sucesso!'
    end
  end
  
end
