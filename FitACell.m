% This function loads the cell specified in "cellname", plots its data and
% fits the model to it.

clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% !!! Change following 2 lines to load different cells/conditions!!
cellname = 'rr171019'; % identifies cell.
condition = 'brightbar_on'; % specifies condition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

format short

% First look up which eye had the green filter:
load([cellname filesep 'GreenFilter.mat']);

% Now load the cell data itself
load([cellname filesep cellname '_' condition '.mat']);

[~,nreps]=size(background);

% Let's place them all into a 7x7xnreps matrix
% Background response goes in (7,7,...):
ronnymatrix(7,7,:) = background;
if green_filter_left_eye==1
    ronnymatrix(7,1:6,:) = Buffer_blue; % left eye has green filter, sees the bars which appear blue when dark
    ronnymatrix(1:6,7,:)  = Buffer_green;
    ronnymatrix(1:6,1:6,:) = permute(spikeCount_binoc,[2 1 3]);
else
    ronnymatrix(7,1:6,:) = Buffer_green; % right eye has green filter, sees the bars which appear blue when dark
    ronnymatrix(1:6,7,:)  = Buffer_blue;
    ronnymatrix(1:6,1:6,:) = spikeCount_binoc;
end

% Now we normalise by the highest mean rate within trials seen in any condition:
for k = 1 : numel(ronnymatrix(1,1,:))
    max_of_all = max(max(ronnymatrix(:,:,k)));
    ronnymatrix(:,:,k) = ronnymatrix(:,:,k)./max_of_all;
end
% Now let's average over repetitions
mn = mean(ronnymatrix,3);
% and calculate the standard deviation too:
sd = std(ronnymatrix,[],3);

% Now we rewrite this information into a structure with clearer names:
neuronresponse.background  =     mn(7,7);
neuronresponse.reps.background  =    squeeze(ronnymatrix(7,7,:));
neuronresponse.SEM.background = sd(7,7)/sqrt(nreps);
neuronresponse.monocL =      mn(7,1:6);
neuronresponse.reps.monocL =  squeeze(ronnymatrix(7,1:6,:));
neuronresponse.SEM.monocL =  sd(7,1:6)/sqrt(nreps);
neuronresponse.monocR =     mn(1:6,7)';
neuronresponse.reps.monocR =  squeeze(ronnymatrix(1:6,7,:));
neuronresponse.SEM.monocR = sd(1:6,7)'/sqrt(nreps);
neuronresponse.binoc =     mn(1:6,1:6)';
neuronresponse.reps.binoc =     mn(1:6,1:6,:);
neuronresponse.SEM.binoc = sd(1:6,1:6)'/sqrt(nreps);
% indiv reps
neuronresponse.monocL_Alltrials = squeeze(ronnymatrix(7,1:6,:))';
neuronresponse.monocR_Alltrials = squeeze(ronnymatrix(1:6,7,:))';

% Now we plot the neuronal data:
PlotNeuronalData(neuronresponse)
drawnow

% Use ANOVA to test whether bar position in left and/or right eye has a significant main
% effect, and whether the interaction is significant:
DoAnovaTest(ronnymatrix);

%%%%%%%%%%%%%%%%%%%
% Now it's time to fit this data with our model.

% FitModel does the fitting. You can call it with just neuronresponse as a sole argument, but the optimisation is non-convex so the initial parameters are rather critical. I therefore did it this way - first fitted the L and R RFs without fitting the output exponent (so 12 free parameters), and set the initial guesses for the RFs to 1 at all bar locations:
model12 = FitModel(neuronresponse,ones(1,12))

% Then I used the RFs thus found as the initial guess when fitting a 13-parameter model including the output exponent:
model13 = FitModel(neuronresponse,[model12.RFL model12.RFR 1])

% If you want to fit all 14 parameters at once to all the data, you can do this. It will give very similar results:
% model14 = FitModel(neuronresponse,[model13.RFL model13.RFR model13.outputexponent model13.tonicinput])

% Now plot the final  model:
PlotModelRFs(model13)

PlotNeuronalData(model13.response)

fprintf('% variance explained by 13-parameter model = %f %%\n ',model13.percentVarianceExplained)

clear model
model.RFL = model13.RFL;
model.RFR = model13.RFR;
model.outputexponent = model13.outputexponent;
model.threshold = model13.threshold;
model.tonicinput = model13.tonicinput;

modelfilename = sprintf('model_of_cell_%s_%s.mat',cellname,condition)
save(modelfilename,'model')
