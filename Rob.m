function yrob = Rob(y,fc,Fs)

% Nombre d'echantillons du signal
N = length(y);

% Creation du vecteur temps
t = (0:N-1)' / Fs;  % Vecteur colonne pour correspondre a y

% Modulation par une exponentielle complexe a la frequence fc
signal = y .* exp(1i * 2 * pi * fc * t);

% On recupere la partie reelle du signal module
yrob = real(signal);

% Normalisation pour eviter la saturation
yrob = yrob / max(abs(yrob));

end
