%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Comparacion de Wavelets
% La rutina imprime todos los resultados en un archivo de texto llamado
% FILE
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Comp_Print2File (Error, Time, Parametros)

%% Parámetros
Nivel_Descomp = Parametros.Nivel_Descomp;
CantRegistros = Parametros.CantRegistros;
Wavelet_Madre = Parametros.Wavelets_Madres;
CantMadres    = Parametros.CantMadres;
Save          = Parametros.Save;
KNN           = Parametros.Umbral.KNN;
File_Name     = Parametros.File_Name;


%% Error
TP = Error.TP;
FP = Error.FP;
FN = Error.FN;
SH = Error.SH;
SE = Error.SE;
SP = Error.SP;
PE = Error.PE;
AC = Error.AC;
Validez = Error.Validez;


%% Escribo el archivo
Path = sprintf ('./Resultados/%s', File_Name);

if Save == 0
    FID = 1;
else
    FID = fopen(Path,'w');
end

% Imprimo la tabla
fprintf(FID, 'TP \t FP \t FN \t SH \t Se \t\t\t Sp \t\t Erms \t AC \t\t\t Ondita Madre \t Validez\n');

for i = 1 : CantMadres
    fprintf(FID, '%.2d \t %.2d \t %.2d \t %.2d \t %.2f \t\t %.2f \t\t %.2f \t %.2f \t\t %s \t\t\t %s\n', ...
        TP(i), FP(i), FN(i), SH(i), SE(i), SP(i), PE(i), AC(i), Wavelet_Madre{i}, Validez{i});
end

% Busco las mejores onditas
i = SE == max(SE);
fprintf(FID, '\nMejor SE: %f', max(SE));
fprintf(FID, ' - %s', Wavelet_Madre{i});

i = SP == max(SP);
fprintf(FID, '\nMejor SP: %f', max(SP));
fprintf(FID, ' - %s', Wavelet_Madre{i});

i = PE == min(PE);
fprintf(FID, '\nMejor PE: %f', min(PE));
fprintf(FID, ' - %s', Wavelet_Madre{i});

i = AC == max(AC);
fprintf(FID, '\nMejor AC: %f', max(AC));
fprintf(FID, ' - %s', Wavelet_Madre{i});

% Imprimo el fondo
fprintf(FID, '\n\n\nTotal de Wavelets analizadas: %d\n', CantMadres);
fprintf(FID, 'Total de señales analizadas: %d\n', CantRegistros);
fprintf(FID, 'Total de picos: %d\n', 8753);
fprintf(FID, 'Time elapsed: %f\n\n', Time);

fprintf(FID, '\nPedro Zenone - pedro.zenone@gmail.com\n');
fprintf(FID, 'Nicolás Linale - nicolaslinale@gmail.com\n');

% Guardo el archivo
if Save == 1
    fclose(FID);
end

end
