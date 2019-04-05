% test code new fasttrack

close all;
clc;
clear t;

fig = 0;
a = exist('p');

if a == 0
    disp('Select the movie folder to analyse');
    [f,p] = uigetfile('*.txt',[],'D:\OMR_acoustic_experiments');
    t = readtable(fullfile(p,f),'Delimiter','\t');
    s = table2array(t);
    fps = 150;
    param = ['parametersrun_',p(end-24:end-23),'.mat'];
    load(fullfile(p(1:end-23),param))
end

% -- Extract information from fast track
[nb_frame, nb_detected_object, xbody, ybody, ang_body]...
    = extract_parameters_from_fast_track(s);

% -- Determine the swimming sequence
[seq, xbody, ybody, ang_body] = extract_sequence(nb_detected_object,...
    xbody, ybody, ang_body, fps);

% -- Correct angle
OMR_angle = P.OMR.angle;
angle_OMR = nan(nb_detected_object,nb_frame);
f = 25;
for f = 1:nb_detected_object
    ind_seq = seq{1}(:,:); 
    while isempty(ind_seq) == 0
        cang = ang_body(f,ind_seq(1,1):ind_seq(2,1));
        
        % correct angle of the sequence
        [~, corr_angle] = correct_angle_sequence(cang, fig, OMR_angle);
        angle_OMR(f,ind_seq(1,1):ind_seq(2,1)) = corr_angle;
        ind_seq(:,1) = [];
    end
end

% Save 'ang_body', 'angle_OMR', 'file', 'fps', 'nb_detected_object', 
% 'nb_frame', 'nb_tracked_object', 'OMR_angle', 'path', 'xbody', 'ybody','P'
% in raw_data matrix

% I go on with the analyse

% -- Determine bout
