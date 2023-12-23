function PlotModelRFs(model)
barwidth = 12.8; % in deg
barvalue = 1;
barpos = [-32:12.8:32,55];%Ronny change 180320
figure('pos',[403   413   560   253])
subplot(1,2,1)
bar(barpos(1:6),model.RFL.*(model.RFL>0),'g');
hold on
bar(barpos(1:6),model.RFL.*(model.RFL<0),'r');
title(['                  left eye RF               expnt ' num2str(model.outputexponent) ' ; tonic inp. ' num2str(model.tonicinput)])
subplot(1,2,2)
bar(barpos(1:6),model.RFR.*(model.RFR>0),'g');
hold on
bar(barpos(1:6),model.RFR.*(model.RFR<0),'r');
% title(['right eye RF  ton.inp. ' num2str(model.tonicinput) ])
title('                   right eye RF')
for j=1:2
    subplot(1,2,j)
    %plot(xlim,[0 0],'k-')
    %plot(xlim,[1 1]*model.tonicinput,'b-')
    bar(barpos(7),model.tonicinput,'BARWIDTH',12,'FaceColor',[0.5 0.5 0.5],'EdgeColor',[0.5 0.5 0.5]);
%     bar(barpos(7),model.tonicinput);
    xticks(barpos)
    xticklabels({'-32°'; '-19.2°'; '-6.4°' ;'6.4°' ;'19.2°' ;'32°';'tonic'})
    ylim([ min([model.RFL model.RFR model.tonicinput]) max([model.RFL model.RFR model.tonicinput]) ])
    xlim([barpos(1)-13,barpos(end)+13])
end