%% ----- Extract raw data for OMR + acoustic -----

close all;
clc;
clear;

warning off

nb = [nan, nan];
no_tracking = [];
file = 'tracking.txt';

disp('Select the folder with the movie to analyze');
selpath = uigetdir('D:\OMR_acoustic_experiments\OMR_acoustic');
disp('Movie to analyse?');
nb(1) = input('from ??     ');
nb(2) = input('to ??       ');

F = Focus();
F.V = selpath(end-6:end-4);

tic
wb = waitbar(0,sprintf('Extract bout, movie 1 / %d', nb(2)-nb(1)+1));
for k = nb(1):nb(2)
    
    d = floor(k/10);
    u = floor(k-d*10);
    run = ['run_', num2str(d), num2str(u)];
    path = fullfile(selpath,run);
    
    if isfolder(fullfile(path, 'movie','Tracking_Result')) == 1
        %         if isfile(fullfile(path,'raw_data.mat')) == 0
        
        path = fullfile(path,'movie','Tracking_Result');
        t = readtable(fullfile(path,file),'Delimiter','\t');
        s = table2array(t);
        
        p = path(1:end-21);
        f = ['parametersrun_', num2str(d), num2str(u), '.mat'];
        load(fullfile(p,f));
        
        fps = 150;
        OMR_angle = P.OMR.angle;
        
        F.dpf = P.fish(4);
        if P.OMR.Duration == 0
            F.OMR = '0000';
        elseif P.OMR.Duration == 500
            F.OMR = '0500';
        else
            F.OMR = num2str(P.OMR.Duration);
        end
        
        % -- Extract information from fast track
        [nb_frame, nb_detected_object, xbody, ybody, ang_body, ang_tail]...
            = extract_parameters_from_fast_track(s);
        
        % -- Determine the swimming sequence
        [seq, xbody, ybody, ang_body, ang_tail] = extract_sequence(nb_detected_object,...
            xbody, ybody, ang_body, ang_tail, fps);
        
        % -- Remove too short sequence
        f_remove = [];
        for i = 1:nb_detected_object
            f = size(find(isnan(xbody(i,:))==0),2);
            if f < 55
                f_remove = [f_remove i];
            end
        end
        
        xbody(f_remove,:) = nan;
        ybody(f_remove,:) = nan;
        ang_body(f_remove,:) = nan;
        ang_tail(f_remove,:) = nan;
        for i = 1:size(f_remove,2)
            seq{f_remove(i)} = [];
        end
        
        % -- Correct angle
        fig = 0;
        angle_OMR = nan(nb_detected_object,nb_frame);
        angle_tail = nan(nb_detected_object,nb_frame);
        for f = 1:nb_detected_object
            ind_seq = seq{f}(:,:);
            while isempty(ind_seq) == 0
                % correct body angle of the sequence
                cang = ang_body(f,ind_seq(1,1):ind_seq(2,1));
                [~, corr_angle] = correct_angle_sequence(cang, fig, OMR_angle, 230*pi/180);
                angle_OMR(f,ind_seq(1,1):ind_seq(2,1)) = corr_angle;
                
                % correct tail angle of the sequence
                cang = ang_tail(f,ind_seq(1,1):ind_seq(2,1));
                [~, corr_angle] = correct_angle_sequence(cang, fig, OMR_angle, 2);
                angle_tail(f,ind_seq(1,1):ind_seq(2,1)) = corr_angle;
                ind_seq(:,1) = [];
            end
        end
        
        % -- Find bout
        checkIm = 0;
        [indbout, xbody, ybody] = extract_bout(xbody,...
            ybody, nb_detected_object, seq, fps, f_remove, checkIm);
        
        % -- Determine escape matrix
        [reaction_time, reaction_time_ms, angle_before, sign_escape,...
            fish_to_consider, escape_matrix, fish_bout_OMR, nb_fish, nb_fish_escape] = ...
            data_OMR_acoustic(nb_frame, xbody, ang_tail, angle_OMR, ang_body, fps, indbout);
        
        % -- Determine direction of the first bout direction (if turn)
        mat_first_turn = nan(1,size(fish_to_consider,2));
        i = 13;
        for i = 1:size(fish_to_consider,2)
            f = fish_to_consider(i);
            indbt = indbout{f};
            t = find(indbt(1,:) > 150,1);
            esc_im = (1000 + P.OMR.Duration)*150/1000 - 20;
            if indbt(1,t) < esc_im % first bout before esc, during OMR
                ang_b = mean(angle_OMR(f,indbt(1,t)-10:indbt(1,t)));
                ang_b = mod(ang_b, 2*pi);
                if ang_b > pi
                    ang_b = ang_b - 2*pi;
                end
                turn = angle_OMR(f,indbt(2,t))-angle_OMR(f,indbt(1,t));
                if abs(turn) > 20*pi/180
                    mat_first_turn(i) = -sign(ang_b)*sign(turn);
                end  
            end
        end
        
        % -- save data
        save(fullfile(path(1:end-21), 'raw_data.mat'), 'ang_body', 'ang_tail', 'angle_OMR',...
            'angle_tail', 'f_remove', 'file', 'fps', 'indbout', 'nb_detected_object',...
            'nb_frame', 'OMR_angle', 'P', 'path', 'seq', 'xbody', 'ybody');
        save(fullfile(path(1:end-21), 'OMR_ac_data.mat'), 'angle_before', 'escape_matrix',...
            'fish_bout_OMR', 'fish_to_consider', 'nb_fish', 'nb_fish_escape', 'reaction_time',...
            'reaction_time_ms', 'sign_escape', 'mat_first_turn')
        disp('Data saved')
        
        % -- save OMR + ac data in a summary file
        ang_b = angle_before;
        esc_mat = escape_matrix;
        fbOMR = fish_bout_OMR;
        nf = nb_fish;
        nfesc = nb_fish_escape;
        rtms = reaction_time_ms;
        sesc = sign_escape;
        mft = mat_first_turn;
        first_bout_direction = mft;
        
        if isfolder(F.path) == 0
            mkdir(F.path);
        end
        
        if isfile(fullfile(F.path,'data_OMR.mat')) == 1
            D = F.load('data_OMR.mat');
            angle_before = [D.angle_before ang_b];
            escape_matrix = [D.escape_matrix esc_mat];
            fish_bout_OMR = [D.fish_bout_OMR fbOMR];
            nb_fish = [D.nb_fish nf];
            nb_fish_escape = [D.nb_fish_escape nfesc];
            reaction_time_ms = [D.reaction_time_ms rtms];
            sign_escape = [D.sign_escape sesc];
            first_bout_direction = [D.first_bout_direction mft];
            save(fullfile(F.path,'data_OMR.mat'),'angle_before', 'escape_matrix',...
                'fish_bout_OMR', 'nb_fish', 'nb_fish_escape', 'reaction_time_ms',...
                'sign_escape');
        else
            save(fullfile(F.path,'data_OMR.mat'),'angle_before', 'escape_matrix',...
                'fish_bout_OMR', 'nb_fish', 'nb_fish_escape', 'reaction_time_ms',...
                'sign_escape', 'first_bout_direction');
        end
        
    else
        no_tracking = [no_tracking, k];
    end
    waitbar((k-nb(1)+1)/(nb(2)-nb(1)+1),wb,sprintf('Extract bout, movie %d / %d', k-nb(1)+1, nb(2)-nb(1)+1));
end
toc

if isempty(no_tracking) == 0
    X = ['No tracking for run ', num2str(no_tracking)];
    disp(X);
end

close(wb)
% close all;
