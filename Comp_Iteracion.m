%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Comparacion de Wavelets
% La rutina realiza el análisis de errores para una wavelet madre dada.
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Error ] = Comp_Iteracion ( Parametros )


%% Inicializo las variables
TP = 0;
FP = 0;
FN = 0;
SH = 0;
SE = zeros (1,7);
SP = zeros (1,7);
PE = zeros (1,7);
AC = zeros (1,7);
Validez = 'Ok';


%% Hago la iteración
j = 1;
i = 21;

while i <= Parametros.CantRegistros
    
    % Cargo la señal
    Parametros.Registro = i;
    [ Signal ] = Cargar_Signal (Parametros);
    
    % Filtro
    Detectados  = Wavelet_Double (Parametros, Signal);
    Detectados = Get_Picos(Detectados);

    % Calculo el error
    error = Comp_Error (Parametros, Signal, Detectados);
    TP = TP + error.Tp;
    FP = FP + error.Fp;
    FN = FN + error.Fn;
    SH = SH + error.Sh;
    SE(j) = error.Se;
    SP(j) = error.Sp;
    PE(j) = error.Pe;
    AC(j) = error.Ac;
    
    i = i + 1;
    j = j + 1;
    
end

if TP + FN + SH == 8753
     Validez = 'Ok';
else
     Validez = 'No';
end

%% Cargo la estructura para devolver
Error.TP = TP;
Error.FP = FP;
Error.FN = FN;
Error.SH = SH;
Error.SE = SE;
Error.SP = SP;
Error.PE = PE;
Error.AC = AC;
Error.Validez = Validez;

end

