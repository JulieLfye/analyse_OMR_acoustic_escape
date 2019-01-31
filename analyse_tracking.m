% analyse file tracking from fast track
clear;
clc;
close all;

% disp('Select the data file for the good dpf')
% [file,path] = uigetfile('*.mat',[],'C:\Users\LJP\Documents\MATLAB\these\manip_pot_vibrant_data\');
% load(fullfile(path,file));

disp('Select the first frame of the binarized movie');
% [file,path] = uigetfile('*.tif',[],'C:\Users\LJP\Documents\MATLAB\these\manip_pot_vibrant_data\');
[file,path] = uigetfile('*.tif',[],'G:\these\pot_vibrant');
t = readtable(fullfile(path,'Tracking_Result\tracking.txt'),'Delimiter','\t');
s = table2array(t);

disp('Select the experiment parameters file')
a = path;
a(end-9:end) = [];
[f,p] = uigetfile('.mat',[],a);
load(fullfile(p,f));

v = input('Which voltage was used? ','s');
b = strfind(v,'.');
if isempty(b) == 0
    v(b) = '_';
else
    v = [v '_0'];
end
F = Focus();

F.V = v;
F.dpf = str2num(P.fish(4));
F.OMR = P.OMR.Duration;

%camera setting
fps = 150;


%% ----- Extract parameter -----
tic
[nb_tracked_object, nb_frame, nb_detected_object, xbody, ybody]...
    = extract_parameters_from_fast_track(s);

%% ----- Analyse ----
% determine angle
fig = 0;
[ang_body] = extract_angle_fish(nb_detected_object, nb_frame, 50, 50,...
    xbody, ybody, file, path, fig);

return

% correct head tail problem
fig = 1; % fig=1 plot some figures
[angle, angle_to_OMR] = correct_angle(nb_detected_object,...
    nb_frame, ang_body, fig, P);

% reaction time
[reaction_time1, reaction_time_ms1, angle_before1, angle_escape1,...
    nb_fish_considered1, nb_fish_escape1] = data_OMR_acoustic(nb_detected_object,...
    nb_frame, angle_to_OMR, fps);
toc

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
