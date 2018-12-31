function y = myExtend( x,l_add )
%   Esta funcion hace una extension de tipo simetrica half-poiint, es un
%   espejo.
%   Solo para signal (1-D) y del tipo espejo('sym')
%   y = myExtend( x,l_add )
%   Param: x    : signal
%          l_add: longitud a adicionar en extremos

lx = length(x);
y = ones(1,lx + 2*l_add); 

for i = 1:l_add
    y(i) = x(l_add-i+1);
end

for i = l_add+1:lx+l_add
    y(i) = x(i-l_add);
end

% for i = l_add+lx+1:lx+2*l_add
%     y(i) = -1*x(i-l_add-lx);
% end

for i = 1:l_add
    y(l_add+lx+i) = x(lx-i+1);
end

end

