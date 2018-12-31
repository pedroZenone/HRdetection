function y = myDyadup(x)
% realiza un upsample de la se�al, es lo mismo que dyadup(x,0)
%       y = myDyadup(x)
%       param in: x: se�al


lx = length(x);
l = 2*lx - 1;
%relleno con ceros y cargos los extremos asi despues lo hago mas generico
y = zeros(1,l);
y(1) = x(1);    
y(l) = x(lx);

for i = 1:lx-1
    y(i*2+1) = x(i+1);   %cargo los numeros impartes
end

end

