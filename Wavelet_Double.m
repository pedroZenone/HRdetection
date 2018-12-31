%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Método: Wavelet
% Precisión: Punto flotante (Double)
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Posicion, Time] = Wavelet_Double (Parametros, Signal)

%% Parámetros
Umbral          = Parametros.Umbral;
Wavelet_Madre	 = Parametros.Wavelet_Madre;
Nivel_Descomp	 = Parametros.Nivel_Descomp;
Debug           = Parametros.Debug;


%% Signal
ECG             = Signal.ECG;
Fs              = Signal.Fs;


%% Filtrado
    %% Arranco el contador
    tic;


    %% Transformada Wavelet
    % Coeficientes de la Wavelet
    [LO_D,HI_D,Lo_R,Hi_R] = wfilters(Wavelet_Madre);

    [c, l] = myWavedec(ECG, Nivel_Descomp, LO_D, HI_D);

    % cD3 =  myDetcoef(c, l, 3);
    % cD4 =  myDetcoef(c, l, 4);
    % cD5 =  myDetcoef(c, l, 5);
    
    D3 = myWrcoef(Hi_R, Lo_R, c, l, 3);
    D4 = myWrcoef(Hi_R, Lo_R, c, l, 4);
    D5 = myWrcoef(Hi_R, Lo_R, c, l, 5);
    if (Nivel_Descomp >= 6)
        cD6 = detcoef(C,L,6); D6 = wrcoef('d',C,L,Wavelet_Madre,6);
    end

    % Asi seria con las funciones del Toolbox de Wavelet...
    % [C,L] = wavedec(ECG, Nivel_Descomp, Wavelet_madre); % Esto me entrega un vector C con los datalles 1,2,3 + la aproximacion
    % % Levanto los details y los expando
    % cD5 = detcoef(C,L,5);D5 = wrcoef('d',C,L,Wavelet_madre,5);
    % cD4 = detcoef(C,L,4);D4 = wrcoef('d',C,L,Wavelet_madre,4);
    % cD3 = detcoef(C,L,3);D3 = wrcoef('d',C,L,Wavelet_madre,3);

    
    %% Debug
    if Debug
        Text = sprintf('ECG Register: %s\n', Signal.Nombre);
        figure();
        subplot(411), plot(ECG,'k'); ylabel('(a) Original Signal'); grid; xlim([17000 18000]);
        title ( Text );
        subplot(412), plot(D3,'k'); ylabel('(b) Detail 3'); grid; xlim([17000 18000]);
        subplot(413), plot(D4,'k'); ylabel('(c) Detail 4'); grid; xlim([17000 18000]);
        subplot(414), plot(D5,'k'); ylabel('(d) Detail 5'); grid; xlim([17000 18000]);
        if (Nivel_Descomp >= 6)
            plot(D6,'k'); ylabel('(e) Detail 6'); grid;
        end
        
%         t = 0:numel(ECG)-1;
%         plot(t, ECG, t, D3, t, D4, t, D5);
        
    end
    
    
    %% Filtrado lineal
    % ¡Aca esta la magia! Hago unas operaciones y normalizo
%     e1 = D3*0.7 + D4 + D5*1.2;
%      e1 = D3*1.2 + D4 + D5*0.8;
%      e2 = ( D4.*(D3*1.2 + D5*0.8) ) / ( 2 ^ Nivel_Descomp );

    e1 = D3*1.2 + D4 + D5*0.75;
    e2 = ( D4.*(D3 + D5) ) / ( 2 ^ Nivel_Descomp );
    e1xe2 = abs ( e1.*e2 );
    Maximo = max(e1xe2);
    e1xe2 = e1xe2 / Maximo;
    
    
    %% Filtrado no lineal
    % Aplico hard tresholding
%     Posicion = Threshold ( e1xe2, Fs, Umbral.Threshold );
%     Posicion = Check_Treshold ( Posicion, e1xe2, Fs, Umbral.Check_Threshold );
%     Posicion = Correccion ( ECG, Posicion, Umbral.Correccion);
    
    % Die neue Verfahren
    InterSignal.e1xe2 = e1xe2;
    InterSignal.d3 = D3;
    InterSignal.d4 = D4;
    InterSignal.Sin_d3 = (D4+D5).*D4.*D5;
    Recursividad = 0;
    Posicion = Maquina_Estados ( ECG, InterSignal, Umbral, Fs, Recursividad );
    
    
    %% Debug
    if Debug
        Text = sprintf('ECG Register: %s\n', Signal.Nombre);
        figure();
        subplot(511), plot(ECG,'k'), ylabel('(a) Original Signal'), grid; xlim([17000 18000]);
        title ( Text );
        subplot(512), plot(e1,'k'), ylabel('(b) e1 signal'), grid; xlim([17000 18000]);
        subplot(513), plot(e2,'k'), ylabel('(c) e2 signal'), grid; xlim([17000 18000]);
        subplot(514), plot(e1xe2,'k'), ylabel('(d) Normalized e3'), grid;  xlim([17000 18000]);
        subplot(515), plot(Posicion,'k'), ylabel('(e) After Thresholding'), grid; xlim([17000 18000]);
        
        Comp_Error (Parametros, Signal, Get_Picos( Posicion));
    end
    
    
    %% Paro el contador
    Time = toc;
    
    
%% Muestro los resultados
Show_signal (Parametros, Signal, Posicion, Time);


%% Botoneo a los que están errados
if Debug
     Pos_X = Get_Picos(Posicion);
     fprintf('\nFP: ');
     fprintf ('%i - ', Pos_X ( ismember(Pos_X, Signal.Picos_Real) ~= 1 ));
     fprintf('\nFN: ');
     fprintf ('%i - ', Signal.Picos_Real ( ismember(Signal.Picos_Real, Pos_X) ~= 1 ));
     fprintf('\n');
end


end


