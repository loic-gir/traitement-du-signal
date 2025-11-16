function VocodeurGUI()
% Interface graphique

% Création de la fenêtre
fig = figure('Name', 'Vocodeur de Phase', 'MenuBar', 'none', 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);

% Variables données audio
y = [];
Fs = 44100;
y_processed = [];

% BOUTONS
uicontrol('Style', 'text', 'String', '--- CONTROLES ---', ...
          'Units', 'normalized', 'Position', [0.02, 0.92, 0.15, 0.03], 'FontWeight', 'bold');

% Charger fichier
uicontrol('Style', 'pushbutton', 'String', 'Charger Audio', ...
          'Units', 'normalized', 'Position', [0.02, 0.86, 0.15, 0.05], 'Callback', @chargerAudio, ...
          'BackgroundColor',[0.2 0.4 0.6],'ForegroundColor',[1 1 1]);

txt_fichier = uicontrol('Style', 'text', 'String', 'Aucun fichier chargé', ...
                        'Units', 'normalized', 'Position', [0.02, 0.82, 0.15, 0.03]);

% Vitesse
uicontrol('Style', 'text', 'String', 'Vitesse:', ...
          'Units', 'normalized', 'Position', [0.02, 0.76, 0.06, 0.03]);
txt_vitesse = uicontrol('Style', 'text', 'String', '1.00', ...
                        'Units', 'normalized', 'Position', [0.13, 0.76, 0.04, 0.03]);
slider_vitesse = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', 1, ...
                           'Units', 'normalized', 'Position', [0.02, 0.73, 0.15, 0.03], ...
                           'Callback', @updateVitesseLabel);
uicontrol('Style', 'pushbutton', 'String', 'Modifier Vitesse', ...
          'Units', 'normalized', 'Position', [0.02, 0.68, 0.15, 0.04], 'Callback', @modifierVitesse, ...
          'BackgroundColor',[0.3 0.5 0.7],'ForegroundColor',[1 1 1]);

% Hauteur
uicontrol('Style', 'text', 'String', 'Hauteur:', ...
          'Units', 'normalized', 'Position', [0.02, 0.62, 0.06, 0.03]);
txt_hauteur = uicontrol('Style', 'text', 'String', '1.00', ...
                        'Units', 'normalized', 'Position', [0.13, 0.62, 0.04, 0.03]);
slider_hauteur = uicontrol('Style', 'slider', 'Min', 0.5, 'Max', 2, 'Value', 1, ...
                           'Units', 'normalized', 'Position', [0.02, 0.59, 0.15, 0.03], ...
                           'Callback', @updateHauteurLabel);
uicontrol('Style', 'pushbutton', 'String', 'Modifier Hauteur', ...
          'Units', 'normalized', 'Position', [0.02, 0.54, 0.15, 0.04], 'Callback', @modifierHauteur, ...
          'BackgroundColor',[0.3 0.5 0.7],'ForegroundColor',[1 1 1]);

% Robotisation
uicontrol('Style', 'text', 'String', 'Freq Robot (Hz):', ...
          'Units', 'normalized', 'Position', [0.02, 0.48, 0.10, 0.03]);
edit_freq_robot = uicontrol('Style', 'edit', 'String', '500', ...
                            'Units', 'normalized', 'Position', [0.125, 0.48, 0.045, 0.03]);
uicontrol('Style', 'pushbutton', 'String', 'Robotiser', ...
          'Units', 'normalized', 'Position', [0.02, 0.43, 0.15, 0.04], 'Callback', @robotiser, ...
          'BackgroundColor',[0.3 0.5 0.7],'ForegroundColor',[1 1 1]);a

% Lecture
uicontrol('Style', 'text', 'String', '--- LECTURE ---', ...
          'Units', 'normalized', 'Position', [0.02, 0.36, 0.15, 0.03], 'FontWeight', 'bold');

uicontrol('Style', 'pushbutton', 'String', 'Ecouter Original', ...
          'Units', 'normalized', 'Position', [0.02, 0.30, 0.15, 0.05], 'Callback', @ecouterOriginal, ...
          'BackgroundColor',[0.2 0.4 0.6],'ForegroundColor',[1 1 1]);
uicontrol('Style', 'pushbutton', 'String', 'Ecouter Traité', ...
          'Units', 'normalized', 'Position', [0.02, 0.24, 0.15, 0.05], 'Callback', @ecouterTraite, ...
          'BackgroundColor',[0.2 0.4 0.6],'ForegroundColor',[1 1 1]);

uicontrol('Style', 'pushbutton', 'String', 'Réinitialiser', ...
          'Units', 'normalized', 'Position', [0.02, 0.16, 0.15, 0.04], 'Callback', @reinitialiser, ...
          'BackgroundColor',[0.5 0.5 0.5],'ForegroundColor',[1 1 1]);

% PARTIE DROITE : GRAPHIQUES 
% Signal original
ax1 = axes('Position', [0.22, 0.72, 0.75, 0.24]);
title('Signal Original - Domaine Temporel');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

% Signal traité
ax2 = axes('Position', [0.22, 0.40, 0.75, 0.24]);
title('Signal Traité - Domaine Temporel');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

% Spectrogramme original
ax3 = axes('Position', [0.22, 0.08, 0.35, 0.24]);
title('Spectrogramme Original');

% Spectrogramme traité
ax4 = axes('Position', [0.62, 0.08, 0.35, 0.24]);
title('Spectrogramme Traité');

% FONCTIONS 
    function chargerAudio(~, ~)
        [nom, chemin] = uigetfile('*.wav', 'Choisir un fichier audio');
        if nom ~= 0
            [y, Fs] = audioread(fullfile(chemin, nom));
            y = y(:,1);
            y_processed = y;
            set(txt_fichier, 'String', nom);
            
            % Signal
            t = (0:length(y)-1) / Fs;
            plot(ax1, t, y);
            title(ax1, ['Signal Original: ' nom]);
            xlabel(ax1, 'Temps (s)');
            ylabel(ax1, 'Amplitude');
            grid(ax1, 'on');
            
            % Spectrogramme original
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
        if isempty(y)
            return;
        end
        rapp = get(slider_vitesse, 'Value');
        y_processed = PVoc(y, rapp, 1024);
        afficherTraite();
    end

    function modifierHauteur(~,~)
        if isempty(y)
            return;
        end
        facteur = get(slider_hauteur, 'Value');
        [a, b] = rat(facteur);
        yvoc = PVoc(y, a/b, 256, 256);
        y_processed = resample(yvoc, a, b);
        afficherTraite();
    end

    function robotiser(~,~)
        if isempty(y)
            return;
        end
        fc = str2double(get(edit_freq_robot, 'String'));
        y_processed = Rob(y, fc, Fs);
        afficherTraite();
    end

    function ecouterOriginal(~,~)
        if ~isempty(y)
            soundsc(y, Fs);
        end
    end

    function ecouterTraite(~,~)
        if ~isempty(y_processed)
            soundsc(y_processed, Fs);
        end
    end

    function reinitialiser(~,~)
        if ~isempty(y)
            y_processed = y;
            set(slider_vitesse, 'Value', 1);
            set(slider_hauteur, 'Value', 1);
            set(txt_vitesse, 'String', '1.00');
            set(txt_hauteur, 'String', '1.00');
            set(edit_freq_robot, 'String', '500');
            afficherTraite();
        end
    end

    function afficherTraite()
        % Signal temporel traité
        t = (0:length(y_processed)-1) / Fs;
        plot(ax2, t, y_processed);
        title(ax2, 'Signal Traité');
        xlabel(ax2, 'Temps (s)');
        ylabel(ax2, 'Amplitude');
        grid(ax2, 'on');
        
        % Spectrogramme traité
        axes(ax4);
        spectrogram(y_processed, 256, 250, 256, Fs, 'yaxis');
        title('Spectrogramme Traité');
    end
end
