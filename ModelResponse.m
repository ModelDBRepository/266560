function response = ModelResponse(barposL,barposR,model);
L = sum(model.RFL(barposL));
R = sum(model.RFR(barposR));
input = L + R  + model.tonicinput ;
response = Thresh(input, model.threshold,model.outputexponent);



end



