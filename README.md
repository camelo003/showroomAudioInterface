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

3. O patch criado apresenta duas alternativas para distribuição de áudio. Uma delas necessita da instalação de dois externals: *zexy* e *else*. Para isso é preciso ir na opção _'Procurar por externals'_(Ajuda > Procurar por externals), realizar a busca por ambos e instalar as versões mais recentes.

![image04](/images/showroomTut04.png)

![image05](/images/showroomTut05.png)

![image06](/images/showroomTut06.png)

Após a instalação de ambos os externals, é recomendável adicionar ambos à inicialização do Pure Data na opção _'Inicialização'_(Arquivo > Preferências > Inicialização). Deve-se adicionar um external por vez, aplicar as alterações, e reiniciar o Pure Data antes de abrir o arquivo do showroom.

![image07](/images/showroomTut07.png)

![image08](/images/showroomTut08.png)


4. Agora basta abrir o arquivo "showroomAudioInterface.pd" no Pure Data, o que pode ser feito em File > Open. *IMPORTANTE!* É necessário que no mesmo arquivo do patch estaja a pasta _'audios'_ com todos os arquivos .wav dentro. E é isso! Essa janela já é patch funcional, pronto para receber comandos e controlar volume da saída de som nas caixas. No Pure Data a programação é feita criando objetos (que são essas caixinhas) e controlando o fluxo com conexões (que são essas linhas). Parece confuso, mas não será necessário mexer em nada aqui!

![image03](/images/showroomTut03.png)

Esse programa fica constantemente "escutando" mensagens osc de 3 portas, cada uma com um propósito:

  - ***Porta 9990,*** _recebe_ comandos de reproduzir e interromper os áudios com as falas;
  - ***Porta 9992,*** _recebe_ a posição do personagem durante a experiência;
  - ***Porta 9994,*** _recebe_ informações para _calibragem_, isso é, informar ao programa onde as caixas de som estão posicionadas.
    
Adicionalmente o programa ainda manda um feedback assim que termina a execução de um arquivo:

  - ***Porta 9991,*** _envia_ avisos quando encerra a execução de algum arquivo.
    
Aqui um detalhamento de como interagir em cada uma dessas portas:
    
#### Porta 9990

Nessa porta espera-se receber comandos para tocar os áudios. Os comandos possíveis são ```/sr_17/play``` para tocar um arquivo e ```/sr_17/stop``` para se interromper a reprodução. Nesse mesmo canal ainda é possível enviar o comando ```/stop_all``` para se interromper qualquer áudio que estiver rodando. Atente que nesse caso o trecho _"_17"_ atua especificamente no arquivo de áudio "SHOWROOM_17.wav". É possível saber o código específico de cada arquivo de áudio na tabela a seguir:

| Arquivo | Comando OSC | Início da fala |
|:---------------:|:-----------:|:---------------------------------------|
| SHOWROOM_17.wav | `/sr_17` | _"Oi de novo! Fica muito mais legal..."_ |
| SHOWROOM_18.wav | `/sr_18` | _"Sabia que ali no fundo tem até um estúdio de som?"_ |
| SHOWROOM_18_2.wav | `/sr_18_2` | _"Sabia que ali no fundo a gente vai ter um estúdio de som?"_ |
| SHOWROOM_20.wav | `/sr_20` | _"Ah! E você sabia que uma das maiores..."_ |
| SHOWROOM_21.wav | `/sr_21` | _"Na tela do meio, a gente tem o log e as transcrições..."_ |
| SHOWROOM_22.wav | `/sr_22` | _"E ali na última tela tá a jornada que você tá percorrendo..."_ |
| SHOWROOM_23.wav | `/sr_23` | _"Agora, deixa eu te contar um pouco mais sobre mim."_ |
| SHOWROOM_24.wav | `/sr_24` | _"Me mostra o que você tá a fim de conhecer agora..."_ |
| SHOWROOM_25.wav | `/sr_25` | _"Hummmm....não entendi."_ |
| SHOWROOM_26.wav | `/sr_26` | _"O bot? Boa escolha!"_ |
| SHOWROOM_27.wav | `/sr_27` | _"O OWI? Legal! Você vai adorar conhecer a Duda."_ |
| SHOWROOM_28.wav | `/sr_28` | _"Poxa, eu queria mesmo te mostrar esse outro canal."_ |
| SHOWROOM_29.wav | `/sr_29` | _"Legal! Vou te mandar uma mensagem de novo."_ |
| SHOWROOM_30.wav | `/sr_30` | _"Hum....pelo jeito não vai dar..."_ |
| SHOWROOM_31.wav | `/sr_31` | _"Fiquei muito feliz de passar..."_ |
| SHOWROOM_31_2.wav | `/sr_31_2` | _"Fiquei muito feliz de passar..."_ |
| SHOWROOM_31_3.wav | `/sr_31_3` | _"Fiquei muito feliz de passar..."_ |
| SHOWROOM_32.wav | `/sr_32` | _"Ô, Duda, representa a gente direitinho, ok?"_ |
| SHOWROOM_33.wav | `/sr_33` | _"Deixa comigo, Duda!"_ |
| SHOWROOM_34.wav | `/sr_34` | _"Pra terminar, vou te contar uma ótima notícia."_ |

#### Porta 9992

Essa porta deve receber ***constantemente*** a posição relativa do personagem, ou seja, deve ser atualizada dentro do loop da aplicação. Essa coordenada deve estar mapeada no espectro entre -100 e 100, onde -100 é a posição mais a esquerda em que o personagem pode aparecer na tela e 100 é a mais a direita.

O envio deser ser feito atravez do comando `/charPos/xx`, onde ao invés de _'xx'_ deve haver o numero da posição do personagem mapeada.

#### Porta 9994

A configuração inicial desse patch considera as caixas satélites dispostas de forma equidistante onde a primeira está alinhada com o canto esquerdo da tela e a última, o canto direito. Mas caso as caixas estejam dispostas de outra forma, ou de maneira irregular, é possivel "calibrar" a posição das caixas.

Para isso foi feita a aplicação _calibrar.exe_ onde o código fonte e arquivo executável se encontram na pasta _p5Calibrar._ Com esse programinha rodando é só seguir as instruções exibidas na tela.
