function yrob = Rob(y,fc,Fs)
% Rob : Fonction de robotisation de la voix
%
% y : signal audio d'entree (vecteur colonne)
% fc : frequence de la porteuse en Hz (200, 500, 1000, 2000)
% Fs : frequence d'echantillonnage
%
% yrob : signal audio "robotise" en sortie

% Nombre d'echantillons du signal
N = length(y);

% Creation du vecteur temps
t = (0:N-1)' / Fs;  % Vecteur colonne pour correspondre a y

% Modulation par une exponentielle complexe a la frequence fc
% yrob(t) = y(t) * exp(j*2*pi*fc*t)
signal = y .* exp(1i * 2 * pi * fc * t);

% On recupere la partie reelle du signal module
rob = real(signal);

% Normalisation pour eviter la saturation
rob = rob / max(abs(rob));

end
