%% ----- Extract raw data for spontaneous activity movie -----
% by run

clear;
clc;
close all;

j = 1;
all_file = [];
all_path = [];
nb = 0;

while j~= 0
    
    disp('Select the first frame of the binarized movie');
    [f,p] = uigetfile('*.tif',[],'C:\Users\LJP\Documents\MATLAB\these\data_OMR_acoustic\');
    
    all_file = [all_file '/' f];
    all_path = [all_path '/' p];
    nb = nb + 1;
    j = input('Other file to analyze? yes:1   no:0     ');
end

all_file = [all_file '/'];
all_path = [all_path '/'];

f_file = strfind(all_file,'/');
f_path = strfind(all_path,'/');

tic
for k = 1:nb
    
    file = all_file(f_file(k)+1:f_file(k+1)-1);
    path = all_path(f_path(k)+1:f_path(k+1)-1);
    
    
    t = readtable(fullfile(path,'Tracking_Result\tracking.txt'),'Delimiter','\t');
    s = table2array(t);
    
    p = path(1:end-10);
    f = ['parametersrun_' path(end-12:end-11) '.mat'];
    load(fullfile(p,f));
    
    fps = 150;
    fig = 0;
    OMR_angle = P.OMR.angle;
    
    if isfile(fullfile(path(1:end-10), 'raw_data.mat')) == 0
        
        % Extract information from fast track
        [nb_tracked_object, nb_frame, nb_detected_object, xbody, ybody]...
            = extract_parameters_from_fast_track(s);
        
        % ----- Analyse ----
        % Extract angle from the binarized movie
        [ang_body] = extract_angle_fish(nb_detected_object, nb_frame, 50, 50,...
            xbody, ybody, file, path, fig, k , nb);
        
        % Determine the swimming sequence
        [seq, xbody, ybody, ang_body] = extract_sequence(nb_detected_object,...
            xbody, ybody, ang_body, fps);
        
        
        
        % correct angle
        ff = find(isnan(seq(1,:))==1);
        angle_OMR = nan(nb_detected_object,nb_frame);
        for f = 1:nb_detected_object
            if f == 1
                ind_seq = seq(:,1:ff(f)-1);
            else
                ind_seq = seq(:,ff(f-1)+1:ff(f)-1);
            end
            
            while isempty(ind_seq) == 0
                cang = ang_body(f,ind_seq(1,1):ind_seq(2,1));
                
                % correct angle of the sequence
                [~, corr_angle] = correct_angle_sequence(cang, 0, OMR_angle);
                angle_OMR(f,ind_seq(1,1):ind_seq(2,1)) = corr_angle;
                ind_seq(:,1) = [];
            end
        end
        
        % save raw data
        save(fullfile(path(1:end-10), 'raw_data.mat'), 'ang_body', 'angle_OMR',...
            'file', 'fps', 'nb_detected_object', 'nb_frame', 'nb_tracked_object',...
            'OMR_angle', 'path', 'xbody', 'ybody','P');
        disp('Raw data saved')
        
    else
        disp('Raw data already extracted')
    end
end
toc

clear;
close all;