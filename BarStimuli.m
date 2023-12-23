function [barwidth,barpos] = BarStimuli(); % look up where the bars were
barwidth = atand(((960-666)/3.7)/100)/3; % in deg ;960-666 ist monitor centre minus extreme bar edge in pixeln; 3.7 ist umrechungsfaktor zu mm
barpos = [-(barwidth*2+0.5*barwidth):barwidth:(barwidth*2+0.5*barwidth)];%Ronny change 180320
