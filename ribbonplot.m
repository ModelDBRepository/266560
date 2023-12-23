function h=ribbonplot(x,y,ylo,yhi,col,alpha,varargin)
% ribbonplot(x,y,ylo,yhi,col,alpha,varargin)
% Plot y against x but add on a shaded region from ylo to yhi
h=plot(x,y,varargin{:},'col',col,varargin{:});
hold on
[nx,ny]=size(x);
if nx>ny
    x=x';
end

fill([x x(end:-1:1)] , [ylo yhi(end:-1:1)] , col,'linest','none','facealpha',alpha)