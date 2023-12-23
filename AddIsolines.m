function AddIsolines(barpos)
xl=xlim;
yl=ylim;
ScreenDistanceMm = 100; % =V, distance to screen in mm
MantisInterocularMm = 8; % =I, distance between mantis eyes in mm

azcol = [0.6 0.6 0]; % colour to use for plotting iso-azimuth lines
distcol = [0.42 0.42 0.42];  % colour to use for plotting iso-distance lines

BarWidthDeg = mean(diff(barpos)); % width of each bar, in degrees
axrng= max(xl) ; % axis range
hold on


% Now let's mark on lines of constant azimuth of the virtual object, aV
% Alter these to control spacing of constant-azimuth isolines:
aVs = [-2.5:0.5:2.5]* BarWidthDeg; % these are the azimuths we choose to mark
% We use the formula that 2*tan(aV) =  tan(aL) + tan(aR)
aLs = [-5:0.01:5] * BarWidthDeg; % range of aL to consider. Needs to be wide enough that the lines get to the edge of the matrix plot.
for jaV=1:length(aVs)
    aV = aVs(jaV); % current value of aV, in deg
    tanaRs = 2*tand(aV) - tand(aLs); % tand since we are working in degrees
    aRs = atand(tanaRs);
    plot(aRs,aLs,'col',azcol,'linew',2)
    
    % Label:
    % Find the index of the place where aR is closest to axrng
    [mn,k]=min(abs(aRs-axrng)); % at the right
    if aLs(k)>=-axrng
        text(aRs(k)+1,aLs(k),sprintf('%2.0f^o',aV),'col',azcol,'rot',0)
    end
    % Find the index of the place where aL is closest to -axrng
    [mn,k]=min(abs(aLs+axrng)); % at the bottom
    if aRs(k)<axrng && aV~=0
        
        text(aRs(k),aLs(k)+3,sprintf('%2.0f^o',aV),'col',azcol,'rot',0)
    end
end

% Now let's mark on lines of constant distance
V = ScreenDistanceMm; % for brevity
I = MantisInterocularMm;
% NB alter these to control spacing of constant-distance isolines
Rs = I*V ./ (I + 2*V.*tand(BarWidthDeg.*[-2.5:0.5:2.5]));;
% ^ these are the distances we're going to plot. Crossed and uncrossed
% disparities of integer multiples of the bar width. THe uncrossed ones
% give negative distances.
for jR=1:length(Rs)
    if Rs(jR)>0
        Rsq = Rs(jR)^2; % distance sq
        a = (I^2- 4*Rsq)*V^2 .* ones(size(aLs));
        b = ((I^2.*tand(aLs)+ 2*Rsq*2*tand(aLs)).*V + 2*Rsq*2*I)*2*V;
        c = (I^2- 4*Rsq)*V^2*tand(aLs).^2- 4*Rsq*2*I*V.*tand(aLs) + 4*I^2*(V^2-Rsq);
        tanaRs = 0.5.* ( -b + sqrt( b.^2 - 4.*a.*c) ) ./ a;
        aRs=atand(tanaRs);
        plot(aRs,aLs,'col',distcol,'linew',2);

        
        % Label:
        % Find the index of the place where aL is closest to axrng
        [mn,k]=min(abs(aLs-axrng)); % at the left
        text(aRs(k),aLs(k)+1,sprintf('%2.0f ',Rs(jR)),'col',distcol,'rot',90,'units','data')
    end
end
% Add on the infinity isoline:
aRs = atand(I/V + tand(aLs));
plot(aRs,aLs,'--','col',distcol,'linew',2);
        
text(0.5,1.1,'distance from mantis (mm)','col',distcol,'units','norm','horiz','cen','vert','mid')
xlim(xl)
ylim(yl)
end
