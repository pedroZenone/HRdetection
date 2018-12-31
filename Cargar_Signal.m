%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Detección del complejo QRS
% Carga la señal electrocardiográfica
%
% Pedro Zenone - pedro.zenone@gmail.com
% Nicolás Linale - nicolaslinale@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ##########################
% Eliminar los registros del 1 al 10. Los de 20 bajarlos
% a 1
% Cambiar la forma en la que guardo la dataa
% ##########################

function Signal = Cargar_Signal (Param)

% rdsamp(): Ver "Physio StartUp"


%% Parámetros
CantRegistros = 30;
Registro = Param.Registro;
Factor_Ajuste = 0;


%% Elijo el reguistro
switch Registro
    case -13
        Senal = 'mitdb/202';
    case -12
        Senal = 'mitdb/213';
        
    case -11
        Senal = 'mitdb/212';
        
    case -10
        Senal = 'mitdb/209';
        
    case -9
        Senal = 'mitdb/207';
        
    case -8
        Senal = 'mitdb/201';
        
    case -7
        Senal = 'mitdb/215';
        
    case -6
        Senal = 'mitdb/214';
        
    case -5
        Senal = 'afdb/04043';
        
    case -4
        Senal = 'svdb/800';
        
    case -3
        Senal = 'nstdb/118e06';
        Factor_Ajuste = 6;
        
    case -2
        Senal = 'mitdb/100';
        Factor_Ajuste = 0.5;
        
    case -1
        Senal = 'chfdb/chf02';
        Factor_Ajuste = 1;
        
    case 0
        
    case 1
        File = './Signals/mitdb.txt';
        Fs = 360;
        Picos_Real = [76 369 662 946 1230 1514 1808 2044 2402 2705 2997 ...
            3282 3559 3862 4170 4465 4764 5059 5346 5633 5917 6214 6526 6823];
        
    case 2
        File = './Signals/ntsdb.txt';
        Fs = 360;
        Picos_Real = [75 376 680 986 1290 1593 1886 2181 2481 2772 3059 ...
            3370 3680 3985 4288 4586 4889 5176 5470 5768 6063 6356 6649 ...
            6934 7220 7511 7798 8087 8382 8669 8971 9271 9569 9880 10183 ...
            10484 10794 11027 11388 11692 11996 12298 12600 12903 13204 ...
            13502 13795 14076];
        
    case 3
        File = './Signals/ntsdbFEO.txt';
        Fs = 360;
        Picos_Real = [71 371 677 983 1286 1590 1882 2178 2478 2769 3056 ...
            3367 3677 3981 4285 4583 4886 5174 5467 5765 6060 6353 6647 ...
            6932 7217 7509 7796 8085 8380 8667 8969 9268 9567 9878 10181 ...
            10482 10792 11027 11385 11690 11994 12296 12597 12901 13202 ...
            13500 13793 14073 14361 14640 14918 15212 15499 15792 16092 ...
            16396 16703 17008 17316 17625];
        
    case 4
        File = './Signals/Fibrilacion_Auricular.txt';
        Fs = 250;
        Picos_Real = [138 277 418 559 698 836 977 1116 1255 1401 1538 ...
            1680 1821 1959 2102 2243 2382 2523 2662 2800 2943 3083 3220 ...
            3362 3501 3639 3780 3918 4056 4198 4340 4476 4617 4757 4895 ...
            5032 5174 5312 5451 5589 5731 5870 6008 6151 6292 6430 6569 ...
            6712 6848 6988 7131 7271 7407 7549 7688 7825 7968 8110 8248 ...
            8392 8529 8667 8809 8950 9088 9230 9369 9508 9653 9793 9933 ...
            10073 10211 10350 10493 10631 10769 10909 11053 11190 11330 ...
            11472 11611 11751 11895 12037 12174 12313 12455 12596 12732 ...
            12870 13007 13147 13288 13428 13566 13705 13844 13985 14126 ...
            14262 14400 14540 14679 14816 14957];
        
    case 5
        File = './Signals/Arritmia_supraventricular.txt';
        Fs = 384;
        Picos_Real = [492 998 1499 2006 2515 3013 3520 4016 4511 4983 ...
            5435 5841 6237 6610 6966 7340 7700 8052 8406 8759 9112 9464 ...
            9815 10172 10526 10885 11238 11600 11960 12327 12696 13060 ...
            13423 13781 14144 14501 14861 15223 15583 15939 16297 16650 ...
            16999 17350 17707 18063 18420 18780 19144 19429 19874 20282 ...
            20643 21006 21369 21718 22061 22404 22740];
        
    case 6
        File = './Signals/Registro_Ruidoso.txt';
        Fs = 360;
        Picos_Real = [71 371 677 983 1286 1590 1882 2178 2478 2769 3056 ...
            3367 3677 3981 4285 4583 4886 5174 5467 5765 6060 6353 6647 ...
            6932 7217 7509 7796 8085 8380 8667 8969 9268 9567 9878 10181 ...
            10482 10792 11027 11385 11690 11994 12296 12597 12901 13202 ...
            13500 13793 14073 14361 14640 14918 15212 15499 15792 16092 ...
            16396 16703 17008 17316 17625 17936 18245 18551 18857 19159 ...
            19461 19764 20058 20363 20658 20960 21269 21569];
        
    case 7
        File = './Signals/MITB.txt';
        Fs = 360;
        Picos_Real = [78 371 664 948 1232 1516 1810 2046 2404 2707 2999 ...
            3284 3561 3864 4172 4467 4766 5062 5348 5635 5920 6216 6528 ...
            6825 7107 7394 7671 7954 8247 8540 8838 9143 9433 9711 9999 ...
            10284 10592 10896 11192 11481 11782 12067 12352 12646 12951 ...
            13268 13563 13843 14132 14424 14712 15013 15311 15608 15901 ...
            16184 16466 16756 17059 17360 17658 17948 18228 18515 18797 ...
            19082 19390 19695 19990 20273 20555 20839 21132 21425];
        
    case 8
        File = './Signals/chfdb.txt';
        Fs = 250;
        Picos_Real = [11 169 323 476 634 788 944 1104 1262 1421 1574 ...
            1697 1887 2042 2207 2368 2530 2684 2841 3003 3160 3320 3481 ...
            3641 3798 3952 4114 4269 4433 4590 4753 4908 5067 5232 5396 ...
            5559 5717 5877 6037 6192 6349 6504 6660 6810 6965 7117 7266 ...
            7418 7573 7726 7877 8029 8183 8336 8488 8641 8797 8959 9118 ...
            9276 9436 9595 9750 9903 10059 10213 10366 10517 10669 10819 ...
            10969 11124 11275 11428 11585 11740 11902 12061 12224 12379 ...
            12535 12691 12852 13010 13169 13322 13480 13637 13791 13943 ...
            14099 14252 14406 14560 14721 14873];
        
    case 9
        File = './Signals/mitdb_214.txt';
        Fs = 250;
        Picos_Real = [138 277 418 559 698 836 977 1116 1255 1401 1538 ...
            1680 1821 1959 2102 2243 2382 2523 2662 2800 2943 3083 3220 ...
            3362 3501 3639 3780 3918 4056 4198 4340 4476 4617 4757 4895 ...
            5032 5174 5312 5451 5589 5731 5870 6008 6151 6292 6430 6569 ...
            6712 6848 6988 7131 7271 7407 7549 7688 7825 7968 8110 8248 ...
            8392 8529 8667 8809 8950 9088 9230 9369 9508 9653 9793 9933 ...
            10073 10211 10350 10493 10631 10769 10909 11053 11190 11330 ...
            11472 11611 11751 11895 12037 12174 12313 12455 12596 12732 ...
            12870 13007 13147 13288 13428 13566 13705 13844 13985 14126 ...
            14262 14400 14540 14679 14816 14957];
        
    case 10
        File = './Signals/mitdb_215.txt';
        Fs = 360;
        Picos_Real = [126 315 505 706 903 1100 1296 1483 1671 1857 2044 ...
            2224 2408 2596 2789 2993 3201 3401 3607 3791 3973 4155 4341 ...
            4523 4713  4912 5113 5311 5506 5692 5878 6071 6260 6431 6633 6819 ...
            7014 7217 7415 7618 7818 8020 8207 8392 8572 8755 8948 9105 9215 ...
            9550 9746 9946 10137 10324 10486 10622 10876 11064 11255 11451 ...
            11645 11843 12052 12250 12438 12620 12800 12979 13162 13342 13535 ...
            13734 13939 14140 14334 14519 14702 14887 15020 15263 15457 15651 ...
            15849 16045 16246 16438 16637 16812 17007 17182 17363 17544 17732 17928 ...
            18131 18329 18469 18718 18902 19086 19265 19444 19556 19818 20012 ...
            20212 20404 20596 20797 20998 21182 21362 21539];
        
    case 11
        File = './Signals/mitdb_201.txt';
        Fs = 360;
        Picos_Real = [161 417 688 907 1191 1424 1623 1967 2238 2497 2723 ...
            2957 3199 3472 3800 4112 4355 4593 4849 4990 5223 5479 5690 ...
            5921 6104 6393 6639 6838 7071 7326 7615 7821 8073 8305 8516 ...
            8669 8924 9119 9351 9645 10010 10269 10523 10773 11045 11302 ...
            11477 11802 12009 12254 12456 12692 12930 13224 13552 13803 ...
            14024 14351 14617 14868 15016 15243 15472 15694 15897 16153 ...
            16409 16571 16815 17044 17273 17426  17540 17777 17960 18263 ...
            18430 18683 18926 19077 19302 19593 19827 20053 20273 20586 ...
            20909 21169 21409 21563];
    
    case 17
        File = './Signals/mitdb_214_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_214_Long.mat', '%d');
        
    case 18
        File ='./Signals/nstdb_118e06_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/nstdb_118e06_Long.mat', '%d');
        
    case 19
        File ='./Signals/chfdb_chf02_Long.txt';
        Fs = 250;
        Picos_Real = importdata ('./Signals/chfdb_chf02_Long.mat', '%d');
        
    case 20
        File = './Signals/mitdb_207_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_207_Long.mat', '%d');
        warning('NICO: OJO. ESTA SEÑAL NO ESTÁ CHEQUEADA!!!');
        
    case 21
        File = './Signals/mitdb_214_3_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_214_3_Long.mat', '%d');
        
    case 22
        File = './Signals/mitdb_215_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_215_Long.mat', '%d');
        
    case 23
        File ='./Signals/mitdb_201_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_201_Long.mat', '%d');
    
    case 24
        File ='./Signals/afdb_04043_Long.txt';
        Fs = 250;
        Picos_Real = importdata ('./Signals/afdb_04043_Long.mat', '%d');
        
    case 25
        File ='./Signals/svdb_800_Long.txt';
        Fs = 384;
        Picos_Real = importdata ('./Signals/svdb_800_Long.mat', '%d');
        
    case 26
        File ='./Signals/mitdb_100_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_100_Long.mat', '%d');
        
    case 27
        File ='./Signals/mitdb_209_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_209_Long.mat', '%d');
        
    case 28
        File ='./Signals/mitdb_212_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_212_Long.mat', '%d');
        
    case 29
        File ='./Signals/mitdb_213_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_213_Long.mat', '%d');
        
    case 30
        File ='./Signals/mitdb_202_Long.txt';
        Fs = 360;
        Picos_Real = importdata ('./Signals/mitdb_202_Long.mat', '%d');
        
    otherwise
        error('\nERROR: Cargar_signal. Elija un registro válido\n');
end


%% Cargo la señal 
if (Registro < 0)
    
    %% Desargo la señal desde Physionet
    Picos_Real = [];
    Cant_Picos = 0;
    
    ECG = rdsamp(Senal,'begin',Param.Time_Begin,'stop',Param.Time_Stop,'phys',true);
    ECG(:,3) = [];
    ECG(:,1) = [];

    % Levanto posicion de QRS, si es que la base de datos lo incluye...
    Data = rdann(Senal, 'atr', 'start',Param.Time_Begin, 'stop',Param.Time_Stop, 'concise');

    % Fs
    Desc = wfdbdesc(Senal, false);
    Fs = Desc.samplingFrequency;
    
    if(Registro == -4)
        ECG = resample(ECG,3,1);
        Fs = Fs*3;
    end
    
    Signal.Nombre = Senal;
    
    
elseif (Registro > 0)
    
    %% Cargo la señal de un txt
    
    Fid = fopen(File);
    ECG = fscanf(Fid,'%f');
    Data = [];
    Signal.Nombre = File;
    Cant_Picos = numel(Picos_Real);
    
else
    %% Registro = 0;
    % Sirve para devolver solamente (y rápido) el numero de registros
    % disponibles en txt
    ECG = [];
    Fs = 0;
    Data = [];
    Factor_Ajuste = 0;
    Cant_Picos = 0;
    Picos_Real = [];
    Signal.Nombre = 'Null';
end


%% Cargo la estructura
Signal.ECG = ECG;
Signal.Fs = Fs;
Signal.Data = Data;
Signal.Factor_Ajuste = Factor_Ajuste;
Signal.Cant_Picos = Cant_Picos;
Signal.Picos_Real = Picos_Real;
Signal.CantRegistros = CantRegistros;

end


