%% ----- Extract raw data for spontaneous activity movie -----
% by folder

clear;
clc;
close all;

nb = [nan, nan];
no_movie_bin = [];
file = 'movie_bin_0000.tif';

disp('Select the folder with the movie to analyze');
selpath = uigetdir('C:\Users\LJP\Documents\MATLAB\these\data_OMR_acoustic\');
disp('Movie to analyse?');
nb(1,1) = input('from ??     ');
nb(1,2) = input('to ??       ');

tic
for k = nb(1,1):nb(1,2)
    
    d = floor(k/10);
    u = floor(k-d*10);
    run = ['run_', num2str(d), num2str(u)];
    path = fullfile(selpath,run);
    
    if isfolder(fullfile(path, 'movie_bin')) == 1
         if isfile(fullfile(path,'raw_data.mat')) == 0
    
        path = fullfile(path,'movie_bin');
        t = readtable(fullfile(path,'Tracking_Result\tracking.txt'),'Delimiter','\t');
        s = table2array(t);
    
    p = path(1:end-10);
    f = ['parametersrun_', num2str(d), num2str(u), '.mat'];
    load(fullfile(p,f));
    
    fps = 150;
    fig = 0;
    OMR_angle = P.OMR.angle;
        
        % Extract information from fast track
        [nb_tracked_object, nb_frame, nb_detected_object, xbody, ybody]...
            = extract_parameters_from_fast_track(s);
        
        % ----- Analyse ----
        % Extract angle from the binarized movie
        [ang_body] = extract_angle_fish(nb_detected_object, nb_frame, 50, 50,...
            xbody, ybody, file, path, fig, k - nb(1,1) + 1, nb(1,2)-nb(1,1) + 1);
        
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
        X = ['Raw data already extracted run ', num2str(d), num2str(u)];
        disp(X)
         end
    else
        no_movie_bin = [no_movie_bin, k];
    end
end
toc

if isempty(no_movie_bin) == 0
    X = ['No movie bin for run ', num2str(no_movie_bin)];
    disp(X);
end

close all;