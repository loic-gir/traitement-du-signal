function y = TFCT_Interp(X,t,Nov)

% y = TFCT_Interp(X, t, hop)   
% Interpolation du vecteur issu de la TFCT
%
% X : matrice issue de la TFCT
% t : vecteur des temps (valeurs reelles) sur lesquels on interpole
% Pour chaque valeur de t (et chaque colonne), on interpole le module du spectre 
% et on determine la difference de phase entre 2 colonnes successives de X
% 
% y : la sortie est une matrice ou chaque colonne correspond a l'interpolation de la colonne correspondante de X
% en preservant le saut de phase d'une colonne a l'autre
%
% programme largement inspire d'un programme fait a l'universite de Columbia


[nl,nc] = size(X);

% calcul de N = Nfft
N = 2*(nl-1);

% Initialisations
%-------------------
% Le spectre interpole
y = zeros(nl, length(t));

% Phase initiale
ph = angle(X(:,1)); 

% Dephasage entre chaque echantillon de la TF
dphi = zeros(nl,1);
dphi(2:nl) = (2*pi*Nov)./(N./(1:(N/2)));

% Premier indice de la colonne interpolee a calculer 
% (premiere colonne de Y). Cet indice sera incremente
% dans la boucle
ind_col = 1;

% On ajoute a X une colonne de zeros pour eviter le probleme de 
% X(col+1) en fin de boucle
X = [X,zeros(nl,1)];


% Boucle pour l'interpolation
%----------------------------
%Pour chaque valeur de t, on calcul la nouvelle colonne de Y a partir de 2
%colonnes successives de X

%% Implementation de l'algorithme d'interpolation

% Boucle sur toutes les valeurs du vecteur temps t
for n = 1:length(t)
    % Valeur courante de t
    tn = t(n);
    
    % a) Determination des 2 colonnes de X a utiliser
    % Ncx1 : colonne de gauche (partie entiere inferieure)
    % Ncx2 : colonne de droite (partie entiere superieure + 1)
    Ncx1 = floor(tn) + 1;  % +1 car les indices MATLAB commencent a 1
    Ncx2 = Ncx1 + 1;
    
    % b) Calcul du module interpole
    % Calcul du coefficient d'interpolation beta
    beta = tn - floor(tn);
    alpha = 1 - beta;
    
    % Interpolation lineaire du module
    My = alpha * abs(X(:, Ncx1)) + beta * abs(X(:, Ncx2));
    
    % c) Calcul de la colonne de Y
    y(:, ind_col) = My .* exp(1i * ph);
    
    % d) Mise a jour de la phase pour la prochaine colonne
    % Etape 1 : Calcul de la variation de phase entre les 2 colonnes de X
    dphi_var = angle(X(:, Ncx2)) - angle(X(:, Ncx1)) - dphi;
    
    % Etape 2 : Ramener la phase entre -pi et +pi
    dphi_var = dphi_var - 2*pi * round(dphi_var / (2*pi));
    
    % Etape 3 : Mise a jour finale de la phase
    ph = ph + dphi_var + dphi;
    
    % e) Incrementation de l'indice de colonne de Y
    ind_col = ind_col + 1;
end
