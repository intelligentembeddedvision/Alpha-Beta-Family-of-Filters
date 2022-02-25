
% Filtrul alfa-beta-gama in rezolvarea problemei de prag

% inchide eventualele figuri deschide se reseteaza variabile
clear all;
close all;

font = 15;

% definire culori
cc=hsv(5);

% defineste parametri filtrului
alfa = 0.75;
%beta = 0.8;
%gama = 0.25;

%alfa = 0.75;
beta = 2;
gama = 1.5;

% perioada de esantionare T
T = 0.1;

% vectorii utilizati de catre filtrul alfa-beta-gama
pos_prediction1 = zeros(1, 2);
vel_prediction1 = zeros(1, 2);

pos_smooth1 = 0;
vel_smooth1 = 0;
acc_smooth1 = zeros(1,2);


% deschide fisierul cu date
fileID = fopen('D:\rares\Slavici\Licente2019\ClaudiuIstodor\nums22a.txt','r');

formatSpec = '%d %f %f';
sizeA = [3 Inf];
A1 = fscanf(fileID, formatSpec, sizeA);

A0 = A1;

% datele sunt citite, inchide fisierul
fclose(fileID);

% determina marimea matricii A
[r, c] = size(A1);

% afiseaza datele si valoarea de prag
figure;
for i = 2 : r
    plot(A1(1,:), A1(i,:), A1(1,:), A1(i,:), 'color',cc(i+2,:), 'LineWidth', 2);
    axis([0 90 0 100]);
    xlabel('Iterations (nondimensional)', 'fontsize',font)
    ylabel('Values, threshold (nondimensional)', 'fontsize', font)
    hold on;
end
grid on;
title({'Alpha-beta-gamma: alfa = 0.75, beta = 0.8, gamma = 1.5','\newline','Data and threshold 75'}, 'fontsize', font);

% defineste matricea care va retine iteratia si valoarea estimata 
B = zeros(r, c - 1);

% calculeaza predictia si efectueaza corectia 
for k = 1 : c - 1
    % instroduce valoarea observata; valoarea curenta de pe randul al
    % doilea din A
    pos_observed = A1(2, k + 1);
    k;
    
    % pasul 1: predictie
    pos_prediction1(1,2) = pos_smooth1 + T * vel_smooth1 + (T^2/2) * acc_smooth1(1, 2);
    vel_prediction1(1,2) = vel_smooth1 + T * acc_smooth1(1,2);
    
    % pasul 2: corectie
    pos_smooth1 = pos_prediction1(1,2) + alfa * (pos_observed - pos_prediction1(1,2));
    vel_smooth1 = vel_prediction1(1,2) + (beta/T) * (pos_observed - pos_prediction1(1,2));
    acc_smooth1(1, 2) = acc_smooth1(1,2) + (gama/(2 * T^2)) * (pos_observed - pos_prediction1(1,2));
    
    % actualizeaza date
    pos_prediction1(1,1) = pos_prediction1(1,2);
    vel_prediction1(1,1) = vel_prediction1(1,2);
    acc_smooth1(1,1) = acc_smooth1(1,2);
    
    % copiaza in B valoarea iteratiei
    B(1, k) = A1(1, k);
    
    % copiaza in B valoarea estimata pentru comparare cu valoarea de prag
    B(2, k) = pos_prediction1(1,2);
    
    % copiaza in B valoarea de prag pentru afisare
    B(3, k) = A1(3, k);
end

B;
% afiseaza datele si valoarea de prag
figure;
for i = 2 : r
    plot(B(1,:), B(i,:), B(1,:), B(i,:), 'color',cc(i+2,:), 'LineWidth', 2);
    axis([0 90 0 100]);
    xlabel('Iterations (nondimensional)', 'fontsize', font)
    ylabel('Estimation, threshold (nondimensional)', 'fontsize', font)
    hold on;
end
grid on;
title({'Alpha-beta-gamma: alfa = 0.75, beta = 2, gamma = 1.5','\newline','Data and threshold 75'}, 'fontsize', font);


% determinarea iteratiei la care estimarea depaseste valoarea de prag
for i = 1:c-1
    if(B(2, i) > B(3, i))
        B(1, i)
    end
end

