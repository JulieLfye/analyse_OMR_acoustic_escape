% analyse file tracking from fast track
clear;
clc;
close all;

disp('Select the first frame of the binarized movie');
[file,path] = uigetfile('*.tif');
t = readtable(fullfile(path,'Tracking_Result\tracking.txt'),'Delimiter','\t');
s = table2array(t);

%% ----- Extract parameter -----
tic
[nb_tracked_object, nb_frame, nb_detected_object, xbody, ybody]...
    = extract_parameters_from_fast_track(s);
clear t s

%% ----- Analyse ----
% determine angle
ang_body = nan(nb_detected_object,nb_frame);
[ang_body] = extract_angle_fish(nb_detected_object, nb_frame, 50, 50,...
    xbody, ybody, file, path);
toc

% correct head tail problem
[angle] = correct_angle(nb_detected_object, nb_frame, ang_body);
toc

% reaction time
