function y = myWkeep( x,sHacha)
%hacha los valores que estan de mas una vez hecha la reconstruccion
%unitaria
%
%   y = myWkeep( x,sHacha)
%
%   param: x: se�al a correjir
%          sHacha: length final que debe tener la se�al

l = length(x);

% if(l>sHacha)
%        display('warning'),return;
% end;

y = x(1:sHacha);    % para que cree un vector del mismo tipo que x

d = (l-sHacha)/2;
first = floor(d);

for i =1:sHacha
    y(i) = x(first+i);   
end;

end

