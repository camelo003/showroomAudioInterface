import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

String intructions = "Primeiro faça com que essa janela encoste nas laterais da tela.\nSelecione cada um dos marcadores com as teclas 1, 2, 3, 4 e 5 e as movimente com o mouse.\nPosicione cada marcador alinhado com a posição da caixa satélite na sala.\nClique para confirmar ou aperte 0 para cancelar.\nQuando todos os marcadores estiverem devidamente posicionados, pressione 'c'  para calibrar.\nPara resetar os marcadores para a posição inicial, aperte 'r' ('c' em seguida para re-calibrar).";

/*
Primeiro faça com que essa janela encoste nas laterais da tela.
Selecione cada um dos marcadores com as teclas 1, 2, 3, 4 e 5 e as movimente com o mouse.
Posicione cada marcador alinhado com a posição da caixa satélite na sala.
Clique para confirmar ou aperte 0 para cancelar.
Quando todos os marcadores estiverem devidamente posicionados, pressione 'c'  para calibrar.
Para resetar os marcadores para a posição inicial, aperte 'r' ('c' em seguida para re-calibrar).
*/

marker m1 = new marker("1",-100);
marker m2 = new marker("2",-50);
marker m3 = new marker("3",0);
marker m4 = new marker("4",50);
marker m5 = new marker("5",100);

void setup(){
  size(displayWidth,600);
  textSize(36);
  surface.setResizable(true);
  stroke(200);
  
  oscP5 = new OscP5(this,9995);
  myRemoteLocation = new NetAddress("127.0.0.1",9994);  
}

void draw(){
  background(10);
  textSize(18);
  fill(200);
  text(intructions,7,20);
  textSize(36);
  text("-100", 7, height/2-36);
  text("100", width-75, height/2-36);
  line(0,height/2,width,height/2);
  
  m1.updateMarker();
  m1.drawMarker();
  
  m2.updateMarker();
  m2.drawMarker();
  
  m3.updateMarker();
  m3.drawMarker();
  
  m4.updateMarker();
  m4.drawMarker();
  
  m5.updateMarker();
  m5.drawMarker();
  
}

void keyPressed(){
  if(key=='1'){
    m1.selected = true;
  }else if(key=='2'){
    m2.selected = true;
  }else if(key=='3'){
    m3.selected = true;
  }else if(key=='4'){
    m4.selected = true;
  }else if(key=='5'){
    m5.selected = true;
  }else if(key=='r'){
    m1.pos = -100;
    m2.pos = -50;
    m3.pos = 0;
    m4.pos = 50;
    m5.pos = 100;
  }else if(key=='c'){
    OscMessage msg1 = new OscMessage("/c1");
    msg1.add(m1.pos);
    oscP5.send(msg1, myRemoteLocation);
    
    OscMessage msg2 = new OscMessage("/c2");
    msg2.add(m2.pos);
    oscP5.send(msg2, myRemoteLocation);
    
    OscMessage msg3 = new OscMessage("/c3");
    msg3.add(m3.pos);
    oscP5.send(msg3, myRemoteLocation);
    
    OscMessage msg4 = new OscMessage("/c4");
    msg4.add(m4.pos);
    oscP5.send(msg4, myRemoteLocation);
    
    OscMessage msg5 = new OscMessage("/c5");
    msg5.add(m5.pos);
    oscP5.send(msg5, myRemoteLocation);
  }
}


class marker
{
    String number;
    float pos;
    float oldPos;
    boolean selected;
    boolean pSelected;
    
    marker(String _number,float _pos){
      number = _number;
      pos = _pos;
      oldPos = pos;
      selected = false;
      pSelected = false;
    }
    
    void updateMarker(){
      if(selected){
        if(!pSelected){
          oldPos = pos;
          pSelected = true;
        }
        pos = map(mouseX,0,width,-100,100);
        if(mousePressed){
          selected = false;
          pSelected = false;
        }
        if(keyPressed && key == '0'){
          pos = oldPos;
          selected = false;
          pSelected = false;
        }
      }
    }
    
    void drawMarker(){
      float mappedPos = map(pos,-100,100,0,width);
      if(selected){
        fill(200);
      }else{
        fill(50);
      }
      if(mappedPos<75/2){
        mappedPos = 75/2;
      }else if(mappedPos > width-75/2){
        mappedPos = width-75/2;
      }
      ellipse(mappedPos,height/2,75,75);
      textSize(30);
      fill(10);
      text(number,mappedPos-8,height/2+10);
      pushMatrix();
      translate(mappedPos,height/2-30);
      ellipse(0,0,12,12);
      popMatrix();
    }
 };
