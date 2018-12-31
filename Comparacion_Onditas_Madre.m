%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Comparacion de Wavelets
% La rutina escoje 67 Wavelets madre diferentes, con distintos niveles de
% descomposición y compara los errores que produce cada una
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Comparacion_Onditas_Madre (Parametros)


%% Parámetros
Debug = Parametros.Debug;
Parametros.Show = 0;


%% Filtrado...
    %% Arranco el contador
    Start = tic;

    
    %% Cargo las Wavelets madre
    [ Wavelet_Madre, CantMadres ] =  Comp_Load_Wavelets_Madre();

    
    %% Analizo todos los registros para todas las wavelets
    for i = 1 : CantMadres
        
        Parametros.Wavelet_Madre = Wavelet_Madre{i};
        error = Comp_Iteracion (Parametros);

        Error.TP(i) = error.TP;
        Error.FP(i) = error.FP;
        Error.FN(i) = error.FN;
        Error.SH(i) = error.SH;
        Error.SE(i) = mean(error.SE);
        Error.SP(i) = mean(error.SP);
        Error.PE(i) = mean(error.PE);
        Error.AC(i) = mean(error.AC);
        Error.Validez{i} = error.Validez;
        
        if Debug
            fprintf('%d\n',i);
        end
    end


    %% Paro el contador
    Time = toc(Start);


%% Meto los resultados en un archivo
Parametros.Wavelets_Madres = Wavelet_Madre;
Parametros.CantMadres = CantMadres;
Comp_Print2File (Error, Time, Parametros);
fprintf('Time: %f\n',Time);
    
end
