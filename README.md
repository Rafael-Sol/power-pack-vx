![LogoPowerPack](http://i.imgur.com/9MW55Ed.png)

# Power Pack VX - Pacote de add-ons para RPG Maker VX

Fala, galera, tudo na paz?

Hoje vim trazer algumas das minhas antiguidades de RPG Maker, deixando elas disponíveis para quem precisar de maneira mais fácil de acessar aqui no Github. Muita coisa guardei ao longo dos anos enquanto desenvolvia projetos e ideias, sendo o Power Pack VX uma delas. Então como deixar isso comigo não tem mais valor nenhum, vou compartilhar aqui pois pode muito bem vir pra servir a alguém, principalmente para fins de estudos. Aqui vou incluir alguns dos meus primeiros scripts em Ruby, que já datavam de **meados de 2011**.

Me perdoem caso códigos estejam incompletos, muitas coisas dessas nunca foram levadas à frente por diversos motivos. O código também pode conter vários amadorismos, mas eu assim como todos tive que ir aprendendo. Espero honestamente que lhe seja de serventia!

## O que é o Power Pack VX?

Com o lançamento do RPG Maker VX em 2008, o mesmo trouxe várias melhorias com relação ao XP, porém ao custo de simplificar as coisas e remover algumas features. E claro, ainda haviam alguns dos defeitinhos da falta de polimento do XP que não foram devidamente endereçados. 

Aí surge o Power Pack.

Esse pacote tinha por objetivo ajudar a cobrir essas falhas, providenciando um conjunto completo contendo recursos, scripts e algumas outras modificações, para tornar o desenvolvimento e transição dos RPG Maker anteriores mais fácil e mais previsível.

No total houveram 4 releases, além do Beta e do RC, e mais um quinto release planejado.

## Scripts Disponíveis

A lista de scripts de minha autoria na última release do projeto foram os seguintes:

---
* **VX POWER COMMANDS v1.2**

Uma compilação excepcional com mais de 50 comandos para scripts, oferecendo novas funcionalidades para o RPG Maker. Sua implementação requer apenas algumas linhas na função 'Executar Script' dos eventos do programa para acessar as inovações. Os comandos abrangem áreas como equipe (party), herói e eventos (characters), utilitários para manipulação em lote de comandos, comandos para figuras (do comando Mostrar Figura), e a capacidade de alterar os gráficos padrão da pasta System, entre outros. Notavelmente fácil de utilizar e incrivelmente poderoso. A lista completa de comandos está disponível no início do script.

---
* **VX PERFECT FOG v1.0a**

Você provavelmente já teve contato com alguns scripts destinados a adicionar efeitos de neblina ao RPG Maker VX. Embora haja scripts que permitam a adição de várias camadas, é improvável que tenha encontrado algo semelhante ao script que apresento aqui. Este script introduz um efeito de névoa totalmente semelhante ao do RPG Maker XP nos mapas do RPG Maker VX, mantendo uma operação igualmente eficaz. O resultado é uma fusão das melhores características e facilidade de uso de diversos scripts, combinadas com o código do XP, resultando em um sistema de neblina "perfeito". Todos os comandos e instruções de uso estão detalhados no cabeçalho do script. Certifique-se de armazenar os gráficos na pasta 'Graphics/Fogs/'.

---
* **VX SAVE 2003 STYLE v1.2a** (Baseado no 'Save Estilo 2003' do UNIR)

Caso considere a tela de salvar do VX visualmente desagradável, compartilhamos da mesma opinião. Nesse sentido, busquei uma abordagem mais clássica, esteticamente agradável e também funcional, construindo em cima de um script desenvolvido pelo UNIR. Realizei diversas modificações e expansões, resultando no script apresentado aqui. Este script permite a expansão do número de slots de salvamento para o desejado, superando o limite padrão de 4. A cena foi redesenhada para se assemelhar à do RPG Maker 2003, exibindo as faces dos personagens e a quantia de dinheiro. Compatível com resoluções de 544x416 e 640x480. Esse script se destaca também por armazenar todos os slots de salvamento em uma pasta separada, evitando a mistura com os arquivos do jogo, DLLs e outros elementos. Embora não seja uma solução avançada, os resultados finais são bem interessantes.

---
* **VX SCENE INTRO (2Kx LOGO) v1.3**

Este script gráfico, embora fundamentalmente simples, destaca-se por algumas funcionalidades adicionais e uma aplicação específica. Permite a inclusão de um "slide show" de imagens, aplicável ao mapa, e um logotipo anterior à tela de título, assemelhando-se à do RPG Maker 2000/2003. Além disso, pode executar uma trilha sonora de fundo e possui configurações opcionais, como tempo de espera e transições de entrada e saída. O sistema foi completamente revisado, proporcionando transições suaves e perfeitamente sincronizadas entre gráficos e música, que retornam ao estado normal após a conclusão da cena. Os gráficos devem ser colocados na pasta Graphics/Intros/. A inclusão de uma introdução/logotipo antes do título é uma prática frequentemente empregada em jogos profissionais, por que não podemos usá-la também?

---
* **VX MAP ADJUSTER v1.0** (Add-on para resoluções)

Este recurso ajusta automaticamente as dimensões dos seus mapas para evitar erros de rolagem da tela. Além de alertar o desenvolvedor, o VX Map Adjuster também pode reestrurar os dados do mapa e salvar com as dimensões corretas e novas áreas preenchidas, caso esteja em modo de testes, poupando tempo. O destaque do código é a maneira de contornar impossibilidade de redimensionar a Table (classe interna que guarda os tiles de um mapa) de maneira convencional, uma vez que mexer nessa classe causa travamentos. Um exemplo prático do uso ocorre quando um script aumenta a resolução da tela para 640x480, exigindo mapas de tamanho mínimo de 20x15 tiles. Se um mapa com dimensões mínimas do VX, como 17x13, estiver presente, o VX Map Adjuster realiza as correções necessárias. Um utilitário indispensável para evitar contratempos durante a criação de mapas.

---
* **VX SINGLE ICON & FACE v1.1** (Baseado no 'Enable single icon usage' do snstar2006)

Enquanto o VX organiza recursos em conjuntos, nem sempre isso é prático. Em situações específicas, pode ser necessário utilizar recursos individuais, semelhante ao uso de charsets individuais ao adicionar um prefixo "$" ao nome. Este script permite a utilização individual de faces (antes limitadas à seleção da primeira parte da face) e também de ícones, criando paridade com o uso de charsets. Além disso, viabiliza o uso de iconsets adicionais além do padrão (o VX por padrão só aceita 1 iconset), configuráveis no Database por meio de notetags. Ícones individuais ou conjuntos adicionais devem ser armazenados na pasta 'Graphics/Icons/'. As faces individuais continuam na pasta padrão dos facesets.  As instruções detalhadas encontram-se no cabeçalho do script. Com isso a seleção e configuração de gráficos se torna mais flexível e acessível.

---
* **VX SMALL TWEAKS v1.1a** (10 em 1!)

Após uma análise minuciosa do VX, identifiquei diversas pequenas inconveniências. Em resposta, agrupei alguns mini-scripts e desenvolvimais tantos outros e deixei-os agrupados sob o título VX Small Tweaks, destinados a aprimorar a usabilidade do VX e corrigir erros ou incômodos menores. Entre as 10 melhorias desta versão, destacam-se:
* Ajustes e correções nas mensagens de batalha, corrigindo termos invertidos e erros de tradução;
* Melhoria na mensagem de fuga da batalha, com adição de uma mensagem extra para indicar sucesso na fuga;
* Aprimoramento na montagem de nomes dos inimigos, inserindo um espaço antes do nome (por exemplo, Inimigo A);
* Recuperação de HP e MP ao subir de nível (opcional);
* Redução pela metade da taxa de encontros enquanto estiver em veículo, o herói estiver na grama ou não;
* Possibilidade de eventos da Airship acionarem eventos com prioridade 'Acima do Herói';
* Correção da posição dos battlers, alinhando adequadamente os monstros na tela (add-on para resoluções como 640x480);
* Inclusão de som nas expressões;
* Facilidade de modificação do dinheiro inicial da equipe;
* Ajuste simplificado da altura de voo da Airship.

---
* **VX STATUS 2003 STYLE v1.0**

Uma mudança completa na tela de status do personagem, deixando-a mais esteticamente agradável e funcional. A cena de status padrão foi redesenhada para se assemelhar à do RPG Maker 2003, distribuindo e organizando as informações em várias janelas. Adicionalmente, incluí uma janela dedicada para exibição do dinheiro, eliminando a omissão presente na versão original. Embora possa não ser a cena de status mais visualmente exuberante, atende aos padrões mínimos essenciais, como sempre com total compatibilidade com as resoluções de 544x416 e 640x480.

---
* **VX SUPER AREA UTILITIES v1.1a** (Battleback e dano por área, entre outros)

Esta ferramenta permite ajuste do battleback (plano de fundo de batalha) por nome de área, mas também possui outras ferramentas para uso e configuração de áreas. Também permite a atribuição de danos específicos por passo, simulando o efeito de terreno de outros RPG Makers. Além disso, possibilita ajustar o HP mínimo do herói quando envenenado/lava e o dano em movimento pelo mapa, determinando se uma derrota (game over) ocorre caso toda a equipe seja nocauteada no mapa. Também permite ajustar a taxa de dano por passo do veneno e a taxa de regeneração dos itens de recuperação de HP por passo. A configuração é simples, requerendo apenas algumas modificações no módulo e a inclusão de comandos (notetags) nos nomes das áreas. Vale destacar que elimina o battlefloor da batalha, tornando-o desnecessário, e todos os gráficos de battleback devem ser armazenados em 'Graphics\Battlebacks'.

---
* **VX TOGGLE FULLSCREEN & RESOLUTION v1.0**

Este script representa uma solução abrangente ajustes de resolução, redimensionamento da tela para além do máximo padrão e tela cheia, sendo melhor que os concorrentes da época. Embora não seja um kit completo para configurar o VX em resolução máxima, é altamente complementar quando combinado com o script de OrginalWij para tal fim, após algumas modificações. Em comparação ao script de alta-resolução do Kylock, este script é mais avançado ao manter a escala corrigida, considerando as bordas da janela, uma característica única em sua categoria. Oferece a facilidade de alterar a resolução ou ativar o modo tela cheia com um simples pressionar de um atalho do teclado, assemelhando-se à funcionalidade do RPG Maker 2000/2003. 

---
* **VX TRANSITION SET v1.1**

Um dos meus favoritos e uma das coisas mais interessantes que haviam no RPG Maker 2000/2003, mas que estava faltando no VX. Este script vai além, trazendo adições significativas, proporcionando a capacidade de implementar transições personalizadas para as mudanças de tela. O usuário tem a flexibilidade de configurar até seis diferentes transições para entrada e saída de cada cena, abrangendo transições entre mapas e de entrada e saída de batalhas. Para maior versatilidade, o script também oferece a opção de empregar o tradicional efeito de fade-in/out. Todos os gráficos necessários devem ser organizados na pasta 'Graphics/Transitions/'. As instruções detalhadas sobre a personalização dessas transições estão disponíveis no início do script.

---
* **VX KEYBOARD INPUT MODULE PT-BR v1.0**

Apresento uma solução exclusiva para a entrada de teclado, concebida para atender às exigências específicas de usuários de língua portuguesa, com layout de teclado ABNT. Inicialmente, utilizei um script do shun, mas, em busca de maior abrangência e praticidade, adaptei um script mais robusto do OriginalWij/Yanfly, juntando as melhores funcionalidades dos 2 em um novo script exclusivo. Este script se destaca por oferecer suporte às teclas de acentuação, trazendo uma solução mais intuitiva para os desenvolvedores. É o primeiro script de entrada 100% PT-BR a proporcionar esse suporte, oferecendo uma base sólida para construção dum futuro script de digitação com acentuação das letras.

---
* **VX FILE CLASS ENTENSION v.1.0**

Este script visa potencializar a manipulação de arquivos no ambiente Ruby/RGSS, expandindo as capacidades das classes File e FileTest. Montado com base na funcionalidade do antigo ftools.rb, agora é possível realizar operações como cópia de arquivos, criação de árvores de diretórios, combinação automática de nomes de arquivos e pastas, exclusão simultânea de vários arquivos, comparação entre diferentes arquivos, alteração de atributos, entre outras funcionalidades. Oferece um conjunto aprimorado de ferramentas para manipulação eficiente de arquivos no contexto do desenvolvimento do jogo.

---
* **VX AUDIOFILE ENTENSION v.1.0**

Introduzindo uma extensão básica ao sistema sonoro do VX, especificamente na classe AudioFile do módulo RPG. Esta extensão afeta todas as quatro subclasses responsáveis pela reprodução de áudio no jogo: BGM, BGS, ME e SE. Destaca-se pela capacidade de memorizar os últimos sons tocados, agora disponíveis também para efeitos sonoros e efeitos musicais ('SE.last' e 'ME.last'). Além disso, oferece a possibilidade de obter a posição exata em que os sons estavam sendo reproduzidos, com precisão de milissegundos, uma vantagem valiosa para sincronização de eventos. Esta extensão de classe promete ser uma ferramenta muito útil para otimizar o controle e a compreensão do áudio durante o desenvolvimento do seu projeto.

---
* **VX SMOOTH WINDOW OPENING v1.0**

Este script oferece um efeito visual simples e elegante, que adiciona uma transparência à janela durante a abertura e fechamento, proporcionando uma experiência mais suave e agradável. Como parte desse efeito, a janela também encerra sua animação de fechamento de maneira mais gradual. Não há muitos detalhes a serem discutidos sobre esse script; basta integrá-lo ao seu projeto para desfrutar do efeito visual aprimorado.

---
* **VX GENERAL SCRIPT EVALUATOR v1.0a**

Este script aborda um desafio comum ao usar o comando 'Executar Script' em eventos, especialmente quando erros ocorrem. Imagine lidar com vários eventos em um mesmo mapa executando scripts e tentar rastrear os erros. Esse processo pode ser complicado, pois normalmente não se sabe qual evento gerou o erro e localizá-lo individualmente pode ser trabalhoso. Este script resolve esses problemas ao fornecer descrições detalhadas dos erros gerados por comandos de script. Ele avalia todos os scripts no comando de evento, rotas de movimento e até comandos condicionais, oferecendo informações precisas, como o ID do mapa e do evento, linha com erro e seu número, além do tipo e descrição do erro. Um avaliador de scripts abrangente e indispensável.

---
* **VX REGEXP NOTETAG SYSTEM v1.0a**

Este script representa uma evolução no uso de anotações (notetags) no banco de dados do jogo. Com a popularização do uso de anotações para adicionar palavras-chave e comandos em scripts, surgiu a necessidade de um sistema mais eficiente. O VX Regexp Notetag System se destaca ao oferecer um interpretador global para diversos tipos de dados, simplificando significativamente o processo. Com poucas linhas de código, é possível analisar completamente um texto e identificar expressões, obtendo seus valores de retorno. Isso inclui a capacidade de lidar com expressões em vários comandos ao longo do texto. Esse sistema inovador facilita consideravelmente o uso de notetags para notas na database e em outros locais desejados.

## Licença de Uso

![](http://i.creativecommons.org/l/by-sa/3.0/88x31.png)
A coletânea de scripts "Power Pack VX - Scripts Collection", foi originalmente licenciada sob a [Creative Commons Atribuição-Compartilhamento pela mesma licença 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/deed.pt_BR).

O uso comercial é livre, eu só peço que coloque meu nome lá em algum canto dos créditos e que me deixe saber caso faça uso dos meus scripts para que eu possa prestigiar o seu trabalho também!
