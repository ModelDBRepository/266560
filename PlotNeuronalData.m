function PlotNeuronalData(neuron)
% Structure neuron has fields binoc,monocL,monocR,background
[barwidth,barpos] = BarStimuli(); %
Xextent = 0.6;
Yextent = 0.6;

% Interpolate
[xL,xR]=meshgrid(barpos,barpos) ;
% Describes how finely to plot
barpos2 = [min(barpos)-barwidth/2:0.1:max(barpos)+barwidth/2];
[xL2,xR2]=meshgrid(barpos2,barpos2) ;
binoc2 = imresize(neuron.binoc,100,'bicubic');
monocR2 = interp1(barpos,neuron.monocR,barpos2);
monocL2 = interp1(barpos,neuron.monocL,barpos2);

for jfig=1:2 % once raw,once upsampled
    figure('pos',[ 680   100   560   560],'color','w')
    if jfig==1
        imagesc(barpos,barpos,neuron.binoc);
        axis tight
        % Get the axis limits in order to set the other plots to match
        ylB=ylim;
        xlB=xlim;
    else
        imagesc(barpos2,barpos2,binoc2);
        axis tight
        ylim(ylB)
        xlim(xlB)
    end
    axis tight
    AddIsolines(barpos)
    
    set(gca,'ydir','norm')
    colormap hot
    set(gca,'pos',[0.2 0.2 Xextent Yextent],'xticklabels','','yticklabels','')
    yticks(barpos)
    xticks(barpos)
    
    
    h=colorbar;
    p=get(h,'pos');
    set(h,'pos',[p(1)+0.15 p(2:end)])
    text(1.3,0.5,'mean neuronal response','units','norm','rot',-90,'vertical','mid','horiz','cen','fontsize',12)
    
    % For figuring out axis limits
    tmp1 = [neuron.monocR neuron.monocL neuron.background];
    if isfield(neuron,'SEM')
        tmp2 = [neuron.SEM.monocR neuron.SEM.monocL neuron.SEM.background];
    else
        tmp2 = 0*tmp1;
    end
    
    vertplot = axes('pos',[0.1 0.2 0.1 Yextent]);
    ylim(ylB)
    hold on
    if isfield(neuron,'SEM')
        ribbonploty(neuron.background*[1 1],ylim,(neuron.background-neuron.SEM.background)*[1 1],(neuron.background+neuron.SEM.background)*[1 1],'b',0.5,'linew',2);
        ribbonploty(neuron.monocL,barpos,neuron.monocL-neuron.SEM.monocL,neuron.monocL+neuron.SEM.monocL,'r',0.5,'linew',2,'markerfacecol','r','marker','o');
    else
        plot(neuron.monocL,barpos,'ro-','linew',2,'markerfacecol','r')
        plot(neuron.background*[1 1],ylB,'b')
    end
    ylabel('bar centre in left eye')
    xlim([0.9*min(tmp1-tmp2) max(tmp1+tmp2)*1.1])
    set(gca,'xaxislocation','top')
    box on
    set(gca,'ytick',barpos,'yticklabel',num2str(round(barpos(:))))
    
    horizplot = axes('pos',[0.2 0.1 Xextent 0.1]);
    xlim(xlB)
    hold on
    if isfield(neuron,'SEM')
        ribbonplot(xlim,neuron.background*[1 1],(neuron.background-neuron.SEM.background)*[1 1],(neuron.background+neuron.SEM.background)*[1 1],'b',0.5,'linew',2);
        ribbonplot(barpos,neuron.monocR,neuron.monocR-neuron.SEM.monocR,neuron.monocR+neuron.SEM.monocR,'r',0.5,'linew',2,'marker','o','markerfacecol','r');
    else
        plot(barpos,neuron.monocR,'ro-','linew',2,'markerfacecol','r')
        plot(xlB,neuron.background*[1 1],'b')
    end
    box on
    ylim([0.9*min(tmp1-tmp2) max(tmp1+tmp2)*1.1])
    xlabel('bar centre in right eye')
    set(horizplot,'ytick',get(vertplot,'xtick'),'yticklabels',get(vertplot,'xticklabels'))
    set(gca,'xtick',barpos,'xticklabel',num2str(round(barpos(:))))
end

