function y = Thresh(x,threshold,power)
y = (x>=threshold).*((x-threshold).^power);
end