%% ----- Analyse OMR acoustic -----
% by folder

clear
close all
clc

nb = [nan, nan];
no_raw_data = [];

disp('Select the folder with the movie to analyze');
selpath = uigetdir('C:\Users\LJP\Documents\MATLAB\these\data_OMR_acoustic\');
disp('Movie to analyse?');
nb(1,1) = input('from ??     ');
nb(1,2) = input('to ??       ');


F = Focus();
fig = 0;

for k = nb(1,1):nb(1,2)
    
    dp = floor(k/10);
    up = floor(k-dp*10);
    run = ['run_', num2str(dp), num2str(up)];
    path = fullfile(selpath,run);
    
    if isfile(fullfile(path,'raw_data.mat')) == 1
        file = 'raw_data.mat';
        load(fullfile(path,file));
        
        v = selpath(end-6:end-4);
        dur =  P.OMR.Duration;
        m = floor(dur/1000);
        c = floor((dur-m*1000)/100);
        d = floor((dur-m*1000-c*100)/10);
        u = floor(dur-m*1000-c*100-d*10);
        dur = [num2str(m) num2str(c) num2str(d) num2str(u)];
        date = selpath(end-15:end-8);
        dpf = str2num(P.fish(4));
        
        F.dpf = dpf;
        F.V = v;
        F.OMR = dur;
        F.date = date;
        
        % analyse
        [reaction_time1, reaction_time_ms1, angle_before1, angle_escape1,...
            nb_fish_considered1, nb_fish_escape1, f_remove] = data_OMR_acoustic(nb_detected_object,...
            nb_frame, angle_OMR, fps, fig);
        
        % create date folder if not existing
        if isfolder(F.path) == 0
            mkdir(F.path);
        end
        
        % save data for the movie
        save(fullfile(F.path,['data_OMR_', num2str(dp), num2str(up) , '.mat']), 'reaction_time1', 'reaction_time_ms1',...
            'angle_before1', 'angle_escape1', 'nb_fish_considered1', 'nb_fish_escape1', 'f_remove');
        
        % save all data of this date
        if isfile(fullfile(F.path,'data_OMR.mat')) == 1
            D = F.load('data_OMR.mat');
            reaction_time = [D.reaction_time reaction_time1];
            reaction_time_ms = [D.reaction_time_ms reaction_time_ms1];
            angle_before = [D.angle_before angle_before1];
            angle_escape = [D.angle_escape angle_escape1];
            nb_fish_considered = [D.nb_fish_considered nb_fish_considered1];
            nb_fish_escape = [D.nb_fish_escape nb_fish_escape1];
            save(fullfile(F.path,'data_OMR.mat'),'reaction_time', 'reaction_time_ms',...
                'angle_before', 'angle_escape', 'nb_fish_considered', 'nb_fish_escape');
        else
            reaction_time = reaction_time1;
            reaction_time_ms = reaction_time_ms1;
            angle_before = angle_before1;
            angle_escape = angle_escape1;
            nb_fish_considered = nb_fish_considered1;
            nb_fish_escape = nb_fish_escape1;
            save(fullfile(F.path,'data_OMR.mat'),'reaction_time', 'reaction_time_ms',...
                'angle_before', 'angle_escape', 'nb_fish_considered', 'nb_fish_escape');
        end
        
    else
        no_raw_data = [no_raw_data, k];
    end
end

if isempty(no_raw_data) == 0
    X = ['No raw data for run ', num2str(no_raw_data)];
    disp(X);
end