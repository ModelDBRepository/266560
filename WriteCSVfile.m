clear all
files = dir('*.mat');
colnames = {'CellName_Condition' 'TonicInput' 'OutputExponent' ...
    'RF_left_1' 'RF_left_2' 'RF_left_3' 'RF_left_4' 'RF_left_5' 'RF_left_6' ...
    'RF_right_1' 'RF_right_2' 'RF_right_3' 'RF_right_4' 'RF_right_5' 'RF_right_6' };
    
for j=1:length(files)
    load(files(j).name,'model')
    array{j,1} = files(j).name;
    array{j,2} = model.tonicinput;
    array{j,3} = model.outputexponent;
    for k=1:6
        array{j,3+k} = model.RFL(k);
    end
    for k=1:6
        array{j,9+k} = model.RFR(k);
    end
end

writetable(cell2table(array,'VariableNames',colnames),'CellParameters.csv')
    
