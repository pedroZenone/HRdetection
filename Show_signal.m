
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Hace los plots
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ ] = Show_signal ( Parametros, Signal, Posicion, Time )

%% Parametros
Accion          = Parametros.Accion;
Show            = Parametros.Show;
Wavelet_Madre   = Parametros.Wavelet_Madre;


%% Signal
ECG             = Signal.ECG;
Picos_Posta     = Signal.Picos_Real;
% Data            = Signal.Data;
Factor_Ajuste   = Signal.Factor_Ajuste;
Nombre          = Signal.Nombre;


if Show == 0
    return;
end

%% Display textos
switch (Accion)
    case 1
        Texto = 'Filtrado a Wavelet - Precision Double';
        fprintf('%s\n',Texto);
        fprintf('Tiempo: %f\n', Time);
    case 2
        Texto = 'Filtrado a Wavelet - Precision Punto Fijo';
        fprintf('%s\n',Texto);
        fprintf('Tiempo: %f\n', Time);
    case 3
        Texto = 'Filtrado por derivación';
        fprintf('%s\n',Texto);
        fprintf('Tiempo: %f\n', Time);
    case 4
        Texto = 'Filtro pasa banda';
        fprintf('%s\n',Texto);
        fprintf('Tiempo: %f\n', Time);
    case 5
        fprintf('Comparación de métodos\n');
        Texto = 'Filtrado a Wavelet - Precision Double';
        fprintf('Tiempo: %f; Método: %s\n', Time(1), Texto);
        Texto = 'Filtrado a Wavelet - Precision Punto Fijo';
        fprintf('Tiempo: %f; Método: %s\n', Time(2), Texto);
        Texto = 'Filtrado por derivación';
        fprintf('Tiempo: %f; Método: %s\n', Time(3), Texto);
        Texto = 'Filtro pasa banda';
        fprintf('Tiempo: %f; Método: %s\n', Time(4), Texto);
        Texto = 'Comparación de métodos';
    case 6
        Texto = 'Manejo de errores';
    case 7
        Texto = 'Peridiograma';
    case 8
        Texto = sprintf('Registro: %s', Nombre);
    otherwise
         fprintf('\nERROR. Show_Signal. Acción  mayor a 8\n');

end


%% Show plots
figure();

if (Accion < 5 || Accion == 8)
    
    if (Show == 1)
        plot (ECG + Factor_Ajuste*ones(length(ECG),1) ), hold on;
        plot (Posicion,'r');
    elseif (Show == 2)
        % Tomo la ubicación de los picos
        Pos_X = Get_Picos (Posicion);
        plot (ECG), hold on;
        plot( Pos_X, ECG(Pos_X),'Marker','*','MarkerEdgeColor',[1 0 0],'MarkerSize',8,'LineStyle','none' );
%         plot( Picos_Posta, ECG(Picos_Posta),'Marker','*','MarkerEdgeColor',[0 1 0],'MarkerSize',8,'LineStyle','none' );
    end
    Texto = sprintf ('Registro: %s', Nombre);
    title(Texto);
    
elseif (Accion == 5)
    
    if (Show == 1)
        plot (ECG + Factor_Ajuste*ones(length(ECG),1) ), hold on;
        plot (Posicion{1},'r');
        plot (Posicion{2},'g');
        plot (Posicion{3},'k');
        plot (Posicion{4},'m');
    elseif (Show == 2)
        % Tomo la ubicación de los picos
        for i = 1:4
            Pos_X{i} = Get_Picos (Posicion{i});
        end
        plot (ECG), hold on;
        plot( Pos_X{1}, ECG(Pos_X{1}),'Marker','o','MarkerEdgeColor',[1 0 0],'MarkerSize',10,'LineStyle','none' );
        plot( Pos_X{2}, ECG(Pos_X{2}),'Marker','d','MarkerEdgeColor',[0 0 0],'MarkerSize',10,'LineStyle','none' );
        plot( Pos_X{3}, ECG(Pos_X{3}),'Marker','*','MarkerEdgeColor',[0 0 0],'MarkerSize',10,'LineStyle','none' );
        plot( Pos_X{4}, ECG(Pos_X{4}),'Marker','s','MarkerEdgeColor',[1 0 1],'MarkerSize',10,'LineStyle','none' );
    end
    title(Texto);
    
elseif (Accion == 6)
    plot (ECG), hold on;
    plot( Posicion, ECG(Posicion),'Marker','*','MarkerEdgeColor',[1 0 0],'MarkerSize',8,'LineStyle','none' );
    plot( Picos_Posta, ECG(Picos_Posta),'Marker','*','MarkerEdgeColor',[0 1 0],'MarkerSize',8,'LineStyle','none' );
    title(Texto);

elseif (Accion == 7)
       % Reservado para pedro 
    
end

hold off;


%% Plot QRS de Physionet
% if ( ~isempty(Data) )
%     figure();
%     plot(ECG), hold on;
%     plot (Data(:,2), ECG(Data(:,2)), 'md','MarkerSize', 8,'MarkerEdgeColor',[0 1 0]);
%     hold off;
%     title('Ploteamos los picos indicados por Physionet');
% end


end


