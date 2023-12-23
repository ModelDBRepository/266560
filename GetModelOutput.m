
function modelresponse = GetModelOutput(model)
[barwidth,barpos] = BarStimuli(); % look up where the bars were

modelresponse.background = ModelResponse([],[],model); % no bar in either eye
for jx = 1:6
    modelresponse.monocL(jx) = ModelResponse(jx,[],model);
    modelresponse.monocR(jx) = ModelResponse([],jx,model);
end
for jxL = 1:6
    for jxR = 1:6
        modelresponse.binoc(jxL,jxR) = ModelResponse(jxL,jxR,model);
    end
end

end

