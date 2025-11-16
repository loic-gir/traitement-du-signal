function y_echo = Echo(y, Fs, delay_ms, decay, num_echos)
% Echo : Ajoute un effet d'écho au signal audio
%
% y         : signal d'entrée
% Fs        : fréquence d'échantillonnage
% delay_ms  : délai de l'écho en millisecondes
% decay     : facteur d'atténuation (0 à 1)
% num_echos : nombre d'échos successifs
%
% y_echo    : signal avec écho

% Conversion du délai en nombre d'échantillons
delay_samples = round(delay_ms * Fs / 1000);

% Longueur du signal de sortie
output_length = length(y) + num_echos * delay_samples;
y_echo = zeros(output_length, 1);

% Signal original
y_echo(1:length(y)) = y;

% Ajout des échos successifs
for i = 1:num_echos
    start_idx = i * delay_samples + 1;
    end_idx = start_idx + length(y) - 1;
    attenuation = decay^i;
    y_echo(start_idx:end_idx) = y_echo(start_idx:end_idx) + attenuation * y;
end

% Normalisation
y_echo = y_echo / max(abs(y_echo));

end
