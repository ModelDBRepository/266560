function ribbonploty(x,y,xlo,xhi,col,alpha,varargin)
% Plot y against x but add on a shaded region from xlo to xhi (like
% ribbonplot but for vertical plots)
plot(x,y,varargin{:},'col',col,varargin{:})
hold on
[nx,ny]=size(x);
if nx>ny
    x=x';
end

fill( [xlo xhi(end:-1:1)] , [y y(end:-1:1)] ,col,'linest','none','facealpha',alpha)