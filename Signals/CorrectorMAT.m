


clc;
clear;
close all;

FILE_MAT = 'svdb_800_Long.mat';
FILE_SIGNAL = 'svdb_800_Long.txt';

% Leo el archivo
Fid = fopen(FILE_SIGNAL);
ECG = fscanf(Fid, '%f');
Picos = importdata (FILE_MAT, '%d');

for i = 1 : numel(Picos)
     Actual = Picos(i);
     
     if ECG (Actual) == ECG (Actual - 1)
          Picos (i) = Picos (i) - 1;
%                a = 10
     end
     
end


% Rescribo el archivo
save (FILE_MAT, 'Picos');