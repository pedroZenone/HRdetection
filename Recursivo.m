%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Analiza para la ondita indicada todos los registros en texto
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Recursivo (Parametros, Signal)

%% Parámetros
Wavelet_Madre = Parametros.Wavelet_Madre;
CantRegistros = Parametros.CantRegistros;
Parametros.Nombre = Signal.Nombre;


%% Comparación
error = Comp_Iteracion (Parametros);

TP = error.TP;
FP = error.FP;
FN = error.FN;
SH = error.SH;
SE = mean(error.SE);
SP = mean(error.SP);
PE = mean(error.PE);
AC = mean(error.AC);

fprintf('TP \t FP \t FN \t SH \t Se \t\t Sp \t\t Erms \t AC \t\t Ondita Madre\n');

fprintf('%.2d \t %.2d \t %.2d \t %.2d \t %.2f \t %.2f \t %.2f \t %.2f \t %s\n', ...
    TP, FP, FN, SH, SE, SP, PE, AC, Wavelet_Madre);

fprintf('Total de señales analizadas: %d\n', CantRegistros);

end
