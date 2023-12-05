![LogoPowerPack](http://i.imgur.com/9MW55Ed.png)

# Power Pack VX - Pacote de add-ons para RPG Maker VX

Fala, galera, tudo em paz?

Hoje vim fazer algo que já devia ter feito há tempos, séculos até. Vou enfim começar a dar cabo das minhas antiguidades de RPG Maker, passar várias delas adiante. Muita coisa guardei ao longo dos anos enquanto desenvolvia projetos e ideias, mas poucas coisas eu realmente lancei. Então como deixar isso comigo não tem mais valor nenhum, vou passar adiante pois pode muito bem vir pra servir a alguém, principalmente para estudos. Hora de soltar essas pérolas, incluindo alguns dos meus primeiros scripts em Ruby, que já datavam de 2011!

Me perdoem caso códigos estejam incompletos, muitas coisas dessas nunca foram levadas à frente por diversos motivos. O código também pode conter vários amadorismos, mas eu assim como todos tive que ir aprendendo. 

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
* **VX TRANSITION SET v1.1**
Em breve!

---
* **VX KEYBOARD INPUT MODULE PT-BR v1.0**
Em breve!

---
* **VX FILE CLASS ENTENSION v.1.0**
Em breve!

---
* **VX AUDIOFILE ENTENSION v.1.0**
Em breve!

---
* **VX SMOOTH WINDOW OPENING v1.0**
Em breve!

---
* **VX GENERAL SCRIPT EVALUATOR v1.0a**
Em breve!

---
* **VX REGEXP NOTETAG SYSTEM v1.0a**
Em breve!

## Licença de Uso

![](http://i.creativecommons.org/l/by-sa/3.0/88x31.png)
A coletânea de scripts "Power Pack VX - Scripts Collection", foi originalmente licenciada sob a [Creative Commons Atribuição-Compartilhamento pela mesma licença 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/deed.pt_BR).

O uso comercial é livre, eu só peço que coloque meu nome lá em algum canto dos créditos e que me deixe saber caso faça uso dos meus scripts para que eu possa prestigiar o seu trabalho também!
