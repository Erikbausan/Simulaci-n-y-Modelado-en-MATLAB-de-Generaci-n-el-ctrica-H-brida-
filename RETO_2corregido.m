%% =========================================================
%  RETO 2 - MODELADO DEL BALANCE HÍBRIDO DE UNA MICRORRED
%  Curso: Software para Ingeniería (203036)
%  Estudiante: Erik Arcenio Bautista Sanchez
%  Código: 80 859 769 - Grupo: 203036_113
%  =========================================================
%  Descripción: Este script modela el comportamiento energético
%  de una microrred híbrida (solar + eólica) frente a la demanda
%  de una comunidad, durante un ciclo de 24 horas.
%  =========================================================

clc; clear; close all;

%% 1. Definición del vector temporal (24 horas)
tiempo = 1:24;   % Vector fila de 24 posiciones (hora del día)

%% 2. GENERACIÓN SOLAR (Pmax_solar = 25 kW)
% Producción nula en horas de noche: 1-5 y 19-24
% Curva ascendente durante el día con pico máximo al mediodía (hora 12)
P_solar = zeros(1,24);   % Inicialización del vector

% Perfil solar (curva tipo campana) - valores en kW
% Horas 6 a 18 con distribución ascendente/descendente
P_solar(6)  = 2;
P_solar(7)  = 6;
P_solar(8)  = 11;
P_solar(9)  = 16;
P_solar(10) = 20;
P_solar(11) = 23;
P_solar(12) = 25;   % Pico máximo al mediodía
P_solar(13) = 23;
P_solar(14) = 20;
P_solar(15) = 16;
P_solar(16) = 11;
P_solar(17) = 6;
P_solar(18) = 2;

%% 3. GENERACIÓN EÓLICA (Pmax_eolica = 15 kW)
% Fluctuación irregular durante las 24 horas (velocidad del viento variable)
% Ningún valor debe superar los 15 kW nominales
P_eolica = [3, 5, 4, 6, 7, 5, 8, 9, 7, 10, 12, 11, ...
            13, 14, 12, 10, 11, 9, 8, 7, 6, 5, 4, 3];

% Verificación de restricción de potencia nominal
if any(P_eolica > 15)
    error('La generación eólica supera la potencia nominal de 15 kW');
end

%% 4. GENERACIÓN HÍBRIDA TOTAL (Solar + Eólica)
P_generacion_total = P_solar + P_eolica;

%% 5. DEMANDA DE LA COMUNIDAD (Pmax_demanda = 15 kW)
% Inicialización del vector de demanda
P_demanda = zeros(1,24);

% --- Consumo Mínimo Nocturno (Horas 1-5 y 22-24): 2 a 4 kW ---
P_demanda(1:5)   = [3, 3, 2, 2, 3];
P_demanda(22:24) = [3, 4, 3];

% --- Consumo Diurno (Horas 6-17): 6 a 10 kW ---
% Incremento por apertura de escuela y bombeo agrícola
P_demanda(6)  = 6;
P_demanda(7)  = 7;
P_demanda(8)  = 8;
P_demanda(9)  = 9;
P_demanda(10) = 10;
P_demanda(11) = 10;
P_demanda(12) = 9;
P_demanda(13) = 8;
P_demanda(14) = 9;
P_demanda(15) = 8;
P_demanda(16) = 7;
P_demanda(17) = 6;

% --- Pico Máximo de Demanda (Horas 18-21): hasta 15 kW ---
% Alumbrado público y retorno doméstico
P_demanda(18) = 12;
P_demanda(19) = 14;
P_demanda(20) = 15;   % Pico máximo de diseño
P_demanda(21) = 13;

% Verificación de restricción de potencia máxima de demanda
if any(P_demanda > 15)
    error('La demanda supera la potencia máxima de diseño de 15 kW');
end

%% 6. VISUALIZACIÓN GRÁFICA
figure('Name','Simulación Energética de la Microrred','NumberTitle','off');

plot(tiempo, P_generacion_total, '-o', 'LineWidth', 2, ...
     'Color', [0 0.4470 0.7410], 'MarkerFaceColor', [0 0.4470 0.7410]);
hold on;
plot(tiempo, P_demanda, '-s', 'LineWidth', 2, ...
     'Color', [0.8500 0.3250 0.0980], 'MarkerFaceColor', [0.8500 0.3250 0.0980]);

% Configuración de ejes, título y leyenda
xlabel('Tiempo (horas)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Potencia (kW)', 'FontSize', 12, 'FontWeight', 'bold');
title('Simulación Energética de la Microrred Híbrida (24 h)', ...
      'FontSize', 14, 'FontWeight', 'bold');
legend('Generación Total (Solar + Eólica)', 'Demanda de la Comunidad', ...
       'Location', 'best', 'FontSize', 10);
grid on;
xlim([1 24]);
ylim([0 45]);

hold off;

%% 7. ANÁLISIS DEL BALANCE ENERGÉTICO
% Cálculo del balance neto: Generación - Demanda
Balance = P_generacion_total - P_demanda;

% Identificación de regímenes de operación
horas_superavit = tiempo(Balance > 0);   % Generación > Demanda
horas_deficit   = tiempo(Balance < 0);   % Demanda  > Generación

fprintf('=== ANÁLISIS DEL BALANCE ENERGÉTICO ===\n');
fprintf('Horas con superávit energético: %s\n', mat2str(horas_superavit));
fprintf('Horas con déficit energético  : %s\n', mat2str(horas_deficit));
fprintf('Generación total del día      : %.2f kWh\n', sum(P_generacion_total));
fprintf('Demanda total del día         : %.2f kWh\n', sum(P_demanda));
fprintf('Balance neto del día          : %.2f kWh\n', sum(Balance));