function VocodeurGUI()
% Interface graphique
% Création de la fenêtre
fig = figure('Name', 'Vocodeur de Phase', 'MenuBar', 'none', ...
             'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
% Variables données audio
y = [];
Fs = 44100;
y_processed = [];

%% === PANNEAU GAUCHE ===
panel_w = 0.18;      % largeur colonne gauche
x0 = 0.02;
panel = uipanel('Title', 'CONTROLES', ...
                'Units', 'normalized', ...
                'Position', [x0-0.005, 0.05, panel_w+0.01, 0.90], ...
                'FontWeight', 'bold', 'BackgroundColor',[0.95 0.95 0.95]);

%% Tous les contrôles sont à l'intérieur du panneau
px = 0.05;           % marge interne pour garder la même esthétique
pw = 0.90;           % largeur interne identique à avant

%% ----- TITRE -----
uicontrol(panel,'Style', 'text', 'String', '--- CONTROLES ---', ...
          'Units', 'normalized', 'Position', [px, 0.92, pw, 0.03], ...
          'FontWeight', 'bold');

%% ----- CHARGER -----
uicontrol(panel,'Style', 'pushbutton', 'String', 'Charger Audio', ...
          'Units', 'normalized', 'Position', [px, 0.86, pw, 0.05], ...
          'Callback', @chargerAudio, ...
          'BackgroundColor',[0.2 0.4 0.6],'ForegroundColor',[1 1 1]);
txt_fichier = uicontrol(panel,'Style', 'text', 'String', 'Aucun fichier chargé', ...
                        'Units', 'normalized', 'Position', [px, 0.82, pw, 0.03]);

%% ----- VITESSE -----
uicontrol(panel,'Style', 'text', 'String', 'Vitesse:', ...
          'Units', 'normalized', 'Position', [px, 0.76, 0.30, 0.03]);
txt_vitesse = uicontrol(panel,'Style', 'text', 'String', '1.00', ...
                        'Units', 'normalized', 'Position', [px+0.32, 0.76, 0.20, 0.03]);
slider_vitesse = uicontrol(panel,'Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', 1, ...
                           'Units', 'normalized', 'Position', [px, 0.72, pw, 0.03], ...
                           'Callback', @updateVitesseLabel);
uicontrol(panel,'Style', 'pushbutton', 'String', 'Modifier Vitesse', ...
          'Units', 'normalized', 'Position', [px, 0.67, pw, 0.04], ...
          'Callback', @modifierVitesse, ...
          'BackgroundColor',[0.3 0.5 0.7],'ForegroundColor',[1 1 1]);

%% ----- HAUTEUR -----
uicontrol(panel,'Style', 'text', 'String', 'Hauteur:', ...
          'Units', 'normalized', 'Position', [px, 0.61, 0.30, 0.03]);
txt_hauteur = uicontrol(panel,'Style', 'text', 'String', '1.00', ...
                        'Units', 'normalized', 'Position', [px+0.32, 0.61, 0.20, 0.03]);
slider_hauteur = uicontrol(panel,'Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', 1, ...
                           'Units', 'normalized', 'Position', [px, 0.57, pw, 0.03], ...
                           'Callback', @updateHauteurLabel);
uicontrol(panel,'Style', 'pushbutton', 'String', 'Modifier Hauteur', ...
          'Units', 'normalized', 'Position', [px, 0.52, pw, 0.04], ...
          'Callback', @modifierHauteur, ...
          'BackgroundColor',[0.3 0.5 0.7],'ForegroundColor',[1 1 1]);

%% ----- ROBOTISATION -----
uicontrol(panel,'Style', 'text', 'String', 'Freq Robot (Hz):', ...
          'Units', 'normalized', 'Position', [px, 0.46, 0.50, 0.03]);
edit_freq_robot = uicontrol(panel,'Style', 'edit', 'String', '500', ...
                            'Units', 'normalized', 'Position', [px+0.52, 0.46, 0.20, 0.03]);
uicontrol(panel,'Style', 'pushbutton', 'String', 'Robotiser', ...
          'Units', 'normalized', 'Position', [px, 0.41, pw, 0.04], ...
          'Callback', @robotiser, ...
          'BackgroundColor',[0.3 0.5 0.7],'ForegroundColor',[1 1 1]);

%% ----- ECHO -----
chk_echo = uicontrol(panel,'Style', 'checkbox', 'String', ' Activer Echo', ...
                     'Units', 'normalized', 'Position', [px, 0.35, pw, 0.04], ...
                     'Value', 0, 'BackgroundColor',[0.95 0.95 0.95], ...
                     'FontWeight', 'bold');

%% ----- LECTURE -----
uicontrol(panel,'Style', 'text', 'String', '--- LECTURE ---', ...
          'Units', 'normalized', 'Position', [px, 0.29, pw, 0.03], ...
          'FontWeight', 'bold');
uicontrol(panel,'Style', 'pushbutton', 'String', 'Ecouter Original', ...
          'Units', 'normalized', 'Position', [px, 0.24, pw, 0.05], ...
          'Callback', @ecouterOriginal, ...
          'BackgroundColor',[0.2 0.4 0.6],'ForegroundColor',[1 1 1]);
uicontrol(panel,'Style', 'pushbutton', 'String', 'Ecouter Traité', ...
          'Units', 'normalized', 'Position', [px, 0.18, pw, 0.05], ...
          'Callback', @ecouterTraite, ...
          'BackgroundColor',[0.2 0.4 0.6],'ForegroundColor',[1 1 1]);
uicontrol(panel,'Style', 'pushbutton', 'String', 'Réinitialiser', ...
          'Units', 'normalized', 'Position', [px, 0.11, pw, 0.04], ...
          'Callback', @reinitialiser, ...
          'BackgroundColor',[0.5 0.5 0.5],'ForegroundColor',[1 1 1]);

%% === PARTIE DROITE : GRAPHIQUES ===
ax1 = axes('Position', [0.23, 0.72, 0.73, 0.24]);
title('Signal Original - Domaine Temporel');
xlabel('Temps (s)'); ylabel('Amplitude'); grid on;
ax2 = axes('Position', [0.23, 0.40, 0.73, 0.24]);
title('Signal Traité - Domaine Temporel');
xlabel('Temps (s)'); ylabel('Amplitude'); grid on;
ax3 = axes('Position', [0.23, 0.08, 0.35, 0.24]);
title('Spectrogramme Original');
ax4 = axes('Position', [0.61, 0.08, 0.35, 0.24]);
title('Spectrogramme Traité');

%% ==== FONCTIONS ====
    function chargerAudio(~, ~)
        [nom, chemin] = uigetfile('*.wav', 'Choisir un fichier audio');
        if nom ~= 0
            [y, Fs] = audioread(fullfile(chemin, nom));
            y = y(:,1);
            y_processed = y;
            set(txt_fichier, 'String', nom);
            t = (0:length(y)-1) / Fs;
            plot(ax1, t, y);
            title(ax1, ['Signal Original: ' nom]);
            xlabel(ax1, 'Temps (s)'); ylabel(ax1, 'Amplitude');
            grid(ax1, 'on');
            axes(ax3);
            spectrogram(y, 256, 250, 256, Fs, 'yaxis');
            title('Spectrogramme Original');
        end
    end

    function updateVitesseLabel(~,~)
        val = get(slider_vitesse, 'Value');
        set(txt_vitesse, 'String', sprintf('%.2f', val));
    end

    function updateHauteurLabel(~,~)
        val = get(slider_hauteur, 'Value');
        set(txt_hauteur, 'String', sprintf('%.2f', val));
    end

    function modifierVitesse(~,~)
        if isempty(y), return; end
        rapp = get(slider_vitesse, 'Value');
        y_processed = PVoc(y, rapp, 1024);
        
        % Gestion Echo
        if get(chk_echo, 'Value') == 1
            y_processed = y_processed(:); % Force le vecteur en colonne pour éviter les erreurs
            y_processed = Echo(y_processed, Fs, 300, 0.5, 3);
        end
        afficherTraite();
    end

    function modifierHauteur(~,~)
        if isempty(y), return; end
        facteur = get(slider_hauteur, 'Value');
        [a, b] = rat(facteur);
        yvoc = PVoc(y, a/b, 256, 256);
        y_processed = resample(yvoc, a, b);
        
        % Gestion Echo
        if get(chk_echo, 'Value') == 1
            y_processed = y_processed(:); % Force le vecteur en colonne pour éviter les erreurs
            y_processed = Echo(y_processed, Fs, 300, 0.5, 3);
        end
        afficherTraite();
    end

    function robotiser(~,~)
        if isempty(y), return; end
        fc = str2double(get(edit_freq_robot, 'String'));
        y_processed = Rob(y, fc, Fs);
        
        % Gestion Echo
        if get(chk_echo, 'Value') == 1
            y_processed = y_processed(:); % Force le vecteur en colonne pour éviter les erreurs
            y_processed = Echo(y_processed, Fs, 300, 0.5, 3);
        end
        afficherTraite();
    end

    function ecouterOriginal(~,~)
        if ~isempty(y), soundsc(y, Fs); end
    end

    function ecouterTraite(~,~)
        if ~isempty(y_processed), soundsc(y_processed, Fs); end
    end

    function reinitialiser(~,~)
        if ~isempty(y)
            y_processed = y;
            set(slider_vitesse, 'Value', 1);
            set(slider_hauteur, 'Value', 1);
            set(txt_vitesse, 'String', '1.00');
            set(txt_hauteur, 'String', '1.00');
            set(edit_freq_robot, 'String', '500');
            set(chk_echo, 'Value', 0);
            afficherTraite();
        end
    end

    function afficherTraite()
        t = (0:length(y_processed)-1) / Fs;
        plot(ax2, t, y_processed);
        title(ax2, 'Signal Traité');
        xlabel(ax2, 'Temps (s)'); ylabel(ax2, 'Amplitude');
        grid(ax2, 'on');
        axes(ax4);
        spectrogram(y_processed, 256, 250, 256, Fs, 'yaxis');
        title('Spectrogramme Traité');
    end
end

function y_echo = Echo(y, Fs, delay_ms, att, nb_echos)
% Echo : Ajoute un effet d'écho au signal audio
%
% y         : signal d'entrée
% Fs        : fréquence d'échantillonnage
% delay_ms  : délai de l'écho en millisecondes
% att     : facteur d'atténuation (0 à 1)
% nb_echos : nombre d'échos successifs
%
% y_echo    : signal avec écho
% Conversion du délai en nombre d'échantillons
delay_samples = round(delay_ms * Fs / 1000);
% Longueur du signal de sortie
output_length = length(y) + nb_echos * delay_samples;
y_echo = zeros(output_length, 1);
% Signal original
y_echo(1:length(y)) = y;
% Ajout des échos successifs
for i = 1:nb_echos
    start_idx = i * delay_samples + 1;
    end_idx = start_idx + length(y) - 1;
    attenuation = att^i;
    y_echo(start_idx:end_idx) = y_echo(start_idx:end_idx) + attenuation * y;
end
% Normalisation
y_echo = y_echo / max(abs(y_echo));
end
