%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Peridiograma
% Hace el peridiograma ;)
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Peridiograma (Parametros, Signal)

%% Signal
ECG = Signal.ECG;
Fs = Signal.Fs

%% Detecto los picos
Posicion = Wavelet_Double (Parametros, Signal);


%% Peridiograma
%% Calculo los eventos, su posicion y el periodo 
Pos2 = Get_Picos (Posicion);
periodo = diff(Pos2).*(1000/Fs);  % multiplico a las muestras por Ts en ms 
Pos2 = Pos2(1:end-1);         % posiciono los picos 

%% Armo el tacograma

FsTaco = 6; % frec de sampleo del tacograma

%%%%%%%%%%%%%%%%%%%%%%%  Metodo Risk %%%%%%%%%%%%%%%%%%%%%%%%

% Genero una función escalera sampleada a Fs. El valor de cada escalon es
% el periodo

yy = [];

yy(1:Pos2(1)-1) = zeros(1,Pos2(1)-1);
yy(Pos2(1)) = periodo(1);

for i= 1:length(periodo) - 1
    yy(Pos2(i):Pos2(i+1)-1) = ones(1,1:periodo(i)).*periodo(i);
end

yy(Pos2(end):length(ECG)) = ones(1,1:periodo(end)).*periodo(end);

% Bajo la frecuencia de sample de la funcion escalera yy

FPB1 = [-0.0235328861845602,-0.0205717961766722,0.149335159279318,0.394827347860047,0.394827347860047,0.149335159279318,-0.0205717961766722,-0.0235328861845602];
FPB2 = [-0.00483793938671025,-0.0105836236327971,-0.0145194806663151,-0.0165024872485148,-0.00899371231841148,0.00831984109991924,0.0381490358005675,0.0756051320609039,0.115476622953436,0.148447450656992,0.167401207668506,0.167401207668506,0.148447450656992,0.115476622953436,0.0756051320609039,0.0381490358005675,0.00831984109991924,-0.00899371231841148,-0.0165024872485148,-0.0145194806663151,-0.0105836236327971,-0.00483793938671025];
FPB3 = [0.00221665300717961,0.00417246366348459,0.00471097690942572,0.00102756273488692,-0.00802937966094066,-0.0198850809150974,-0.0274584238977285,-0.0211826109614485,0.00643637684961713,0.0557715546801262,0.117528200335759,0.174776320272163,0.209282057041183,0.209282057041183,0.174776320272163,0.117528200335759,0.0557715546801262,0.00643637684961713,-0.0211826109614485,-0.0274584238977285,-0.0198850809150974,-0.00802937966094066,0.00102756273488692,0.00471097690942572,0.00417246366348459,0.00221665300717961];

TacoRisk = conv(yy,FPB1,'same');
TacoRisk = downsample(TacoRisk,2);  % baje Fs a 180 , fp a 6; fs a 150

TacoRisk = conv(TacoRisk,FPB2,'same');
TacoRisk = downsample(TacoRisk,6);    % baje a 30, fp a 6; fs a 25

TacoRisk = conv(TacoRisk,FPB3,'same');
TacoRisk = downsample(TacoRisk,5);    % baje a 6, fp a 5; fs a 1.4 

% le saco el valor de continua para poder ver bien la fft

TacoRisk = TacoRisk - mean(TacoRisk);

%%%%%%%%%%%%%%%%%%%%%%%  Metodo Clifford %%%%%%%%%%%%%%%%%%%%%%%%

xi = 1:Fs/6:length(ECG);    % intervalos de sampling a 6 Hz
% uso tecnica de cubic splane para interpolar
TacoClifford = interp1(Pos2,periodo,xi,'spline'); % interpolo los eventos que ocurren en Pos2 con los que deberian aparecer en xi. O sea que ahora mi Tacograma va a estar sampleado a xi
% le saco el valor de continua para poder ver bien la fft
TacoClifford = TacoClifford- mean(TacoClifford);

%% Armo espectro de potencia y comparo metodos

nfft = 1024; % numero de puntos de periodograma/2 = numero de puntos con que hace fft/2

% Evaluo para el metodo de Clifford vs Risk. fft de 1025  muestras. window
% 4.5 veces menor que el size del tacograma. overlap 50% window
Pclifford = pwelch(TacoClifford,hamming(length(TacoClifford)/4.5),length(TacoClifford)/9,nfft,6);  % fft de 1024 muestras (nnfft) siempre debe ser mayor o igual que la ventana ya que sino pierdo mucha resolucion. La ventana la intento hacer lo mas chica posible, para ganar varianza solapeo al 50%
Prisk = pwelch(TacoRisk,hamming(length(TacoRisk)/4.5),length(TacoRisk)/9,nfft,6);
[Pxx F] = periodogram(TacoRisk,rectwin(length(TacoRisk)),[],6);

% consultar por esto: z3 = pwelch(yy,hamming(length(y)),[],[],6);
% otra cosa: pxx = pyulear(TacoClifford,9,1024). Esto da otra cosa distinta a lo
% que veo con pwelch

% Armo vector de frecuencia y muestro
endPeriod = length(Pclifford);

res = 3/endPeriod;  % resolution de fft
f = 0:res:1-res;
% muestro solo 1 Hz de periodograma
figure(1)
plot(f,Pclifford(1:ceil(endPeriod/3))),hold on, plot(f,Prisk(1:ceil(endPeriod/3)),'g'),
grid on
xlabel('Tachogram frecuency [Hz]');
ylabel('Power spectral density [ms^2/Hz]');
title('PDS'),
legend('cubic splane','filter+downsample')

 %% Calculo Banda de potencias

% regla de 3 simple para calculo de bandas
Eq0_04Hz = floor(0.04*endPeriod/3);
Eq0_15Hz = floor(0.15*endPeriod/3); 
Eq0_4Hz = floor(0.4*endPeriod/3);

% Calculo de potencias
LF1 = sum(Pclifford(Eq0_04Hz:Eq0_15Hz))*(3/endPeriod);  
HF1 = sum(Pclifford(Eq0_15Hz:Eq0_4Hz))*(3/endPeriod);
LF2 = sum(Prisk(Eq0_04Hz:Eq0_15Hz))*(3/endPeriod);  
HF2 = sum(Prisk(Eq0_15Hz:Eq0_4Hz))*(3/endPeriod);
LF3 = sum(Pxx(Eq0_04Hz:Eq0_15Hz))*(3/endPeriod);  
HF3 = sum(Pxx(Eq0_15Hz:Eq0_4Hz))*(3/endPeriod);
% Idem con funciones matlab
%HF2 =  bandpower(Pxx,F,[0.04 0.15],'psd')   % idem con funciones matlab
%LF2 =  bandpower(Pxx,F,[0.15 0.4],'psd')

% Calculo de ratio Lf/Hf
ratio1 = (LF1/HF1)*100;
ratio2 = (LF2/HF2)*100;


end
