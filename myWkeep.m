function y = myWkeep( x,sHacha)
%hacha los valores que estan de mas una vez hecha la reconstruccion
%unitaria
%
%   y = myWkeep( x,sHacha)
%
%   param: x: señal a correjir
%          sHacha: length final que debe tener la señal

l = length(x);

% if(l>sHacha)
%        display('warning'),return;
% end;

y = zeros(1,sHacha);
d = (l-sHacha)/2;
first = floor(d);

for i =1:sHacha
    y(i) = x(first+i);   
end;

end

