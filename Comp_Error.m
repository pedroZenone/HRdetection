%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Comparacion de Wavelets
% La rutina calcula los principales indicadores de comparación de
% algoritmos de detección QRS
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TP: Detecciones correctas
% FP: Detecciones incorrectas (no había pico)
% FN: No se detectó un pico

% OJO: La rutina hace la siguiente suposición:
% Para la potencia de error, ambos vectores deben ser iguales. Caso
% contrario, la comparación no es válida. Para que sea correcta, ambos
% vectores (picos detectados y picos posta) deben tener la misma longitud.
% Si no la tienen, es porque hubo un FP o un FN. En ese caso, no hay manera
% de saber cuál fue el pico que se perdió (FN) o cuál se inventó (FP) y así
% se descoordinan los indices de ambos vectores.
% En general, hay tantos FP como FN, lo que indica que un pico fue
% detectado en un lugar cercano al real, pero no perdido ni inventado. Es
% en estos últimos dos casos en los que la longitud de ambos vectores
% difiere y, por lo tanto, lo vamos a considerar para la potencia de error
% como un "error grosero".
% 
% Para el resto de los indicadores, se considera un TP a aquella muestra
% que se encuentre dentro de un radio menor o igual a KNN. Caso contrario,
% la detección será considerada FP y la no detección FN.


function Error = Comp_Error (Parametros, Signal, Detectados)


%% Signal
Picos_Posta    = Signal.Picos_Real;
Cant_Picos     = Signal.Cant_Picos;
Nombre         = Signal.Nombre;
KNN            = Parametros.Umbral.KNN;
Shifted        = Parametros.Umbral.Shifted;
% Debug          = Parametros.Debug;


%% Potencia de error
if numel(Picos_Posta) ~= numel(Detectados)
    Pot_Error = NaN;
else
    Pot_Error = sqrt (sum ( (Picos_Posta - Detectados).^2 ) ) / Cant_Picos;
end


%% Cálculo de errores por el método "confusion matrix"
% Igualo la dimensión de los dos vectores
if numel(Picos_Posta) > numel(Detectados)
    while numel(Picos_Posta) > numel(Detectados)
        Detectados = [Detectados 0];
    end
    FP0 = - 1;
else
    FP0 = 0;
end

if numel(Detectados) > numel(Picos_Posta)
    while numel(Detectados) > numel(Picos_Posta)
        Picos_Posta = [Picos_Posta 0];
    end
    FN0 = - 1;
else
    FN0 = 0;
end

% Creo la matriz confusión. Solo me interesa la lista de los elementos
[~, order] = confusionmat(Picos_Posta, Detectados);

% Hallo TP, FP, FN
isA0 = ismember(order, Picos_Posta);
isAK = ismemberf(order, Picos_Posta, 'tol', KNN);
isAK1 = ismemberf(order, Picos_Posta, 'tol', KNN + 1);
isBK = ismemberf(order, Detectados, 'tol', KNN);
isBS = ismemberf(order, Detectados, 'tol', Shifted);

TP = sum( isA0 & isBK  ) + FN0;
FN = sum( isAK & ~isBK ) + FN0;
FP = sum( ~isAK1 & isBK ) + FP0;

% Si detecté más TP que los que verdaderamente había, los paso como FP
while TP > Cant_Picos
    TP = TP - 1;
    FP = FP + 1;
    warning('OJO: TP > Cantidad de picos\n');
end

% Hallo los SH
SH = sum( isA0 & isBS  ) - TP + FN0;
FN = FN - SH;


%% Cálculo de los indicadores
% Sensibilidad: informa sobre los falsos negativos (true positive rate)
Se = 100* TP / (TP + FN + SH);

% Specificity: informa sobre los falsos positivos (true negative rate)
% Precisión
Sp = 100* TP / (TP + FP + SH);

% Accuarcy
% Accuarcy = (TP + TN) / (TP + TN + FP + FN);
Accuarcy = 100*TP / Cant_Picos;


%% Cargo la estructura Error
Error.Tp = TP;
Error.Fp = FP;
Error.Fn = FN;
Error.Sh = SH;
Error.Se = Se;
Error.Sp = Sp;
Error.Pe = Pot_Error;
Error.Ac = Accuarcy;


%% Resultados
display (sprintf ('Registro: %s',Nombre));
display (sprintf ('Total picos: %d',Cant_Picos));
display (sprintf ('TP: \t%.2d',TP));
display (sprintf ('FP: \t%.2d',FP));
display (sprintf ('FN: \t%.2d',FN));
display (sprintf ('SH: \t%.2d',SH));
display (sprintf ('Sensibility: \t%.2f %%', Se))
display (sprintf ('Specificity: \t%.2f %%', Sp))
display (sprintf ('Accuarcy: \t%.2f %%', Accuarcy))
display (sprintf ('Pot de error: \t%.2f\n', Pot_Error))

end
