%% ----- Analyse OMR acoustic -----

clear
close all
clc

j = 1;
all_path = [];
nb = 0;

while j~= 0
    
    disp('Select the raw_data.mat to analyze (OMR_acoustic)');
    [~,p] = uigetfile('*.mat',[],'C:\Users\LJP\Documents\MATLAB\these\data_OMR_acoustic\');
    all_path = [all_path '/' p];
    nb = nb + 1;
    j = input('Other file to analyze? yes:1   no:0     ');
end

all_path = [all_path '/'];

f_path = strfind(all_path,'/');

F = Focus();
fig = 1;

for k = 1:nb
    
    file = 'raw_data.mat';
    path = all_path(f_path(k)+1:f_path(k+1)-1);
    
    load(fullfile(path,file));
    
    v = path(end-24:end-22);
    dur =  P.OMR.Duration;
    m = floor(dur/1000);
    c = floor((dur-m*1000)/100);
    d = floor((dur-m*1000-c*100)/10);
    u = floor(dur-m*1000-c*100-d*10);
    dur = [num2str(m) num2str(c) num2str(d) num2str(u)];
    date = path(end-33:end-26);
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
    r = path(end-16:end-11);
    save(fullfile(F.path,['data_OMR_' r '.mat']), 'reaction_time1', 'reaction_time_ms1',...
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
end
