% analyse file tracking from fast track
clc;
close all;

% disp('Select the data file for the good dpf')
% [file,path] = uigetfile('*.mat',[],'C:\Users\LJP\Documents\MATLAB\these\manip_pot_vibrant_data\');
% load(fullfile(path,file));

disp('Select the first frame of the binarized movie');
[file,path] = uigetfile('*.tif',[],'C:\Users\LJP\Documents\MATLAB\these\manip_pot_vibrant_data\');
t = readtable(fullfile(path,'Tracking_Result\tracking.txt'),'Delimiter','\t');
s = table2array(t);

disp('Select the experiment parameters file')
a = path;
a(end-9:end) = [];
[f,p] = uigetfile('.mat',[],a);
load(fullfile(p,f));

v = input('Which voltage was used? ','s');

%camera setting
fps = 150;


%% ----- Extract parameter -----
[nb_tracked_object, nb_frame, nb_detected_object, xbody, ybody]...
    = extract_parameters_from_fast_track(s);
clear t s

%% ----- Analyse ----
% determine angle
fig = 0;
ang_body = nan(nb_detected_object,nb_frame);
[ang_body] = extract_angle_fish(nb_detected_object, nb_frame, 50, 50,...
    xbody, ybody, file, path, P, fig);


% correct head tail problem
fig = 0; % fig=1 plot some figures
[angle, angle_to_OMR] = correct_angle(nb_detected_object,...
    nb_frame, ang_body, fig, P);

% reaction time
[reaction_time, angle_before, angle_escape] = data_OMR_acoustic(nb_detected_object,...
    nb_frame, angle_to_OMR, fps);

% clearvars -except reaction_time angle_before angle_escape P v file path angle_to_OMR








% figure;
% time = (1:1:(size(angle,2)))*1000/150;
% for f = 1:nb_detected_object
%     hold on
% %     plot(angle_to_OMR(f,end-55:end));
%     plot(time,angle_to_OMR(f,:));
% %     plot(angle_to_OMR(f,:));
% end
% plot([0 time(end)], [0 0],':k');
% plot([0 time(end)], [-pi -pi],':k');
% plot([0 time(end)], [pi pi],':k');
% plot([time(nb_frame-47) time(nb_frame-47)],ylim,'r');
% xlabel('time (ms)')
% ylabel('angle to OMR (rad)')