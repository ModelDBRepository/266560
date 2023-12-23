clear all
close all
modelfilename = 'model_of_cell_rr170117_darkbar_on.mat';

'Loading file:'
load(modelfilename) % Loads a file containing a single structure, "model"
'This is the model:'
model
% Plot the model receptive fields:
PlotModelRFs(model)

% Get the model response to binocular and monocular stimuli:
model.response = GetModelOutput(model)
% Plot these responses:
PlotNeuronalData(model.response)
