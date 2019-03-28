# showroomAudioInterface

Pequeno guia de como imprementar essa interface de áudio ao software que vai rodar durante a experiência do shoowroom.

Basicamente, teremos um programa rodando em paralelo à Unity que deve disparar os arquivos de áudios com as falas do personagem enquanto ajusta o volume de cada uma das caixas satélites baseado na posição do personagem na tela.

### Passo-a-passo pra implementação.

1. O software que será a interface de áudio é uma aplicação desenvolvida em Pure Data (essa solução normalmente é chamada de _patch_). O puredata é um programa para síntese, análise e manipulação de som em tempo real, ou seja, não há diferença no seu funcionamente entre estar desenvolvendo e estar executando. O primeiro passo então é baixar o Pure Data que é open source e pode ser baixado para várias platamosmas [*nesse link aqui*](https://puredata.info/downloads/pure-data).

2. Antes mesmo de abrirmos o _patch_ que será a interface de áudio é preciso fazer algumas configurações. São duas:
    - Garantir que a checkbox DSP esteja ligada;
    - Abrir as opções _'Audio Settings'_ (Media > Audio Settings) e no campo _Sample rate:_ colocar o valor 48000. Isso porque os arquivos foram fechados nesse taxa de amostragem. *IMPORTANTE!* Nessa jenela é preciso apertar o botão _Save All Settings._ Isso garante que da próxima ves que o Pure Data for aberto ele mantenha essa configuração.
    
![image01](/images/showroomTut01.png)

![image02](/images/showroomTut02.png)
  
3. Agora basta abrir o arquivo "showroomAudioInterface.pd" no Pure Data, o que pode ser feito em File > Open. E é isso! Essa janela já é patch funcional, pronto para receber comandos e controlar volume da saída de som nas caixas. No Pure Data a programação é feita criando objetos (que são essas caixinhas) e controlando o fluxo com conexões (que são essas linhas). Parece confuso, mas não será necessário mexer em nada aqui!

![image03](/images/showroomTut03.png)

Esse programa fica constantemente "escutando" mensagens osc de 3 portas, cada uma com um propósito:

    - ***Porta 9990,*** _recebe_ comandos de reproduzir e interromper os áudios com as falas;
    - ***Porta 9992,*** _recebe_ a posição do personagem durante a experiência;
    - ***Porta 9994,*** _recebe_ informações para _calibragem_, isso é, informar ao programa onde as caixas de som estão posicionadas.
    
Adicionalmente o programa ainda manda um feedback assim que termina a execução de um arquivo:

    - ***Porta 9991,*** O programa envia avisos quando encerra a execução de algum arquivo.
    
Aqui um detalhamento de como interagir em cada uma dessas portas:
    

