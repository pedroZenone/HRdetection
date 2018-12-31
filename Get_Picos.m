function y = Get_Picos( Position )

% Entrega un vector con las posiciones x del pico R

y = zeros (1, sum(Position));
j = 1;
for i = 1:length(Position)
     
     if(Position(i))
          y(j) = i;
          j = j + 1;
     end
    
end

end

