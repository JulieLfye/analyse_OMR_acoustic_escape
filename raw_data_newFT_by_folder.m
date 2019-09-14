%% ----- Extract raw data for OMR + acoustic -----

close all;
clc;
clear;

warning off

nb = [nan, nan];
no_tracking = [];
file = 'tracking.txt';

disp('Select the folder with the movie to analyze');
selpath = uigetdir('D:\OMR_acoustic_experiments');
disp('Movie to analyse?');
nb(1) = input('from ??     ');
nb(2) = input('to ??       ');

F = Focus();
F.V = selpath(end-6:end-4);
F.Root = [selpath(1:end-16) 'data\'];


wb = waitbar(0,sprintf('Extract bout, movie 1 / %d', nb(2)-nb(1)+1));
for k = nb(1):nb(2)
    
    d = floor(k/10);
    u = floor(k-d*10);
    run = ['run_', num2str(d), num2str(u)];
    path = fullfile(selpath,run);
    
    if isfolder(fullfile(path, 'movie','Tracking_Result')) == 1
        %                 if isfile(fullfile(path,'raw_data.mat')) == 0
        
        path = fullfile(path,'movie','Tracking_Result');
        t = readtable(fullfile(path,file),'Delimiter','\t');
        s = table2array(t);
        
        p = path(1:end-21);
        f = ['parametersrun_', num2str(d), num2str(u), '.mat'];
        load(fullfile(p,f));
        
        fps = 150;
        OMR_angle = P.OMR.angle;
        F.dpf = P.fish(4);
        
        o = P.OMR.Duration;
        m = floor(o/1000);
        c = floor((o-m*1000)/100);
        d = floor((o-m*1000-c*100)/10);
        u = floor(o-m*1000-c*100-d*10);
        F.OMR = [num2str(m) num2str(c) num2str(d) num2str(u)];
        
        % -- Extract information from fast track
        [nb_frame, nb_detected_object, xbody, ybody, ang_body, ang_tail]...
            = extract_parameters_from_fast_track(s);
        xbody_raw = xbody;
        ybody_raw = ybody;
        ang_body_raw = ang_body;
        ang_tail_raw = ang_tail;
        
        % -- Determine the swimming sequence
        [seq, xbody, ybody, ang_body, ang_tail] = extract_sequence(nb_detected_object,...
            xbody, ybody, ang_body, ang_tail, fps);
        
        % -- Remove too short sequence
        f_remove = [];
        fish_ok = [];
        for i = 1:nb_detected_object
            f = size(find(isnan(xbody(i,:))==0),2);
            if f < 75
                f_remove = [f_remove i];
            else
                fish_ok = [fish_ok i];
            end
        end
        
        xbody(f_remove,:) = [];
        ybody(f_remove,:) = [];
        ang_body(f_remove,:) = [];
        ang_tail(f_remove,:) = [];
        seq(f_remove) = [];
        
        % -- Correct angle
        fig = 0;
        nfish = size(xbody,1);
        angle_OMR = nan(size(xbody));
        angle_tail = nan(size(xbody));
        for f = 1:nfish
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
            ybody, nfish, seq, fps, f_remove, checkIm);
        
        % -- Determine escape matrix
        fig = 0;
        [reaction_time, reaction_time_ms, angle_before, sign_escape,...
            fish_to_consider, escape_matrix, fish_bout_OMR, nb_fish, nb_fish_escape] = ...
            data_OMR_acoustic(nb_frame, xbody, ang_tail, angle_OMR, ang_body, fps, indbout,fig);
        fa_remove = setdiff(1:size(xbody,1),fish_to_consider);
        xbody(fa_remove,:) = [];
        ybody(fa_remove,:) = [];
        angle_OMR(fa_remove,:) = [];
        angle_tail(fa_remove,:) = [];
        indbout(fa_remove) = [];
        
        fish_to_consider_FT = fish_ok(fish_to_consider)-1;
        fish_to_consider = fish_ok(fish_to_consider);
        f_remove = 1:nb_detected_object;
        fish_to_remove = setdiff(f_remove,fish_to_consider);
        
        % -- Determine direction of the first bout (if turn)
        mat_first_turn = nan(1,nb_fish);
        i = 13;
        for i = 1:nb_fish
            indbt = indbout{i};
            if isempty(indbt) == 0
                t = find(indbt(1,:) > 150,1);
                esc_im = nb_frame-60;
                if indbt(1,t) < esc_im % first bout before esc, during OMR
                    ang_b = mean(angle_OMR(i,indbt(1,t)-10:indbt(1,t)));
                    ang_b = mod(ang_b, 2*pi);
                    if ang_b > pi
                        ang_b = ang_b - 2*pi;
                    end
                    turn = angle_OMR(i,indbt(2,t))-angle_OMR(i,indbt(1,t));
                    if abs(turn) > 20*pi/180
                        mat_first_turn(i) = -sign(ang_b)*sign(turn);
                    end
                end
            end
        end
        
        % -- save raw data
        save(fullfile(path(1:end-21), 'raw_data.mat'), 'ang_body_raw', 'ang_tail_raw',...
            'angle_OMR', 'angle_tail', 'file', 'fish_to_consider', 'fish_to_consider_FT',...
            'fish_to_remove', 'fps', 'indbout', 'nb_detected_object', 'nb_frame',...
            'OMR_angle', 'P', 'path', 'xbody', 'xbody_raw', 'ybody', 'ybody_raw');
        
        save(fullfile(path(1:end-21), 'OMR_ac_data.mat'), 'angle_before', 'escape_matrix',...
            'fish_bout_OMR', 'fish_to_consider', 'fish_to_consider_FT',...
            'nb_fish', 'nb_fish_escape', 'OMR_angle','reaction_time',...
            'reaction_time_ms', 'sign_escape', 'mat_first_turn', 'angle_OMR',...
            'angle_tail');
        disp('Data saved')
        
        % -- save OMR + ac data in a summary file
        ang_b = angle_before;
        angle_before = [];
        esc_mat = escape_matrix;
        escape_matrix = [];
        fbOMR = fish_bout_OMR;
        fish_bout_OMR = [];
        nf = nb_fish;
        nfesc = nb_fish_escape;
        rtms = reaction_time_ms;
        reaction_time_ms = [];
        sesc = sign_escape;
        sign_escape = [];
        mft = mat_first_turn;
        fFT = fish_to_consider_FT;
        fish_to_consider_FT = [];
        
        if isfolder(F.path) == 0
            mkdir(F.path);
        end
        
        if isfile(fullfile(F.path,'data_OMR.mat')) == 1
            D = F.load('data_OMR.mat');
            a = size(D.escape_matrix,2);
            
            D.angle_before{a+1} = ang_b;
            D.escape_matrix{a+1} = esc_mat;
            D.fish_bout_OMR{a+1} = fbOMR;
            nb_fish = [D.nb_fish nf];
            nb_fish_escape = [D.nb_fish_escape nfesc];
            D.reaction_time_ms{a+1} = rtms;
            D.sign_escape{a+1} = sesc;
            D.first_bout_direction{a+1} = mat_first_turn;
            D.fish_to_consider_FT{a+1} = fFT;
            
            angle_before = D.angle_before;
            escape_matrix = D.escape_matrix;
            fish_bout_OMR = D.fish_bout_OMR;
            reaction_time_ms = D.reaction_time_ms;
            sign_escape = D.sign_escape;
            first_bout_direction = D.first_bout_direction;
            fish_to_consider_FT = D.fish_to_consider_FT;
            
            save(fullfile(F.path,'data_OMR.mat'),'angle_before', 'escape_matrix',...
                'fish_bout_OMR', 'nb_fish', 'nb_fish_escape', 'reaction_time_ms',...
                'sign_escape', 'first_bout_direction', 'fish_to_consider_FT');
        else
            angle_before{1} = ang_b;
            escape_matrix{1} = esc_mat;
            fish_bout_OMR{1} = fbOMR;
            nb_fish(1) = nf;
            nb_fish_escape(1) = nfesc;
            reaction_time_ms{1} = rtms;
            sign_escape{1} = sesc;
            first_bout_direction{1} = mat_first_turn;
            fish_to_consider_FT{1} = fFT;
            
            save(fullfile(F.path,'data_OMR.mat'),'angle_before', 'escape_matrix',...
                'fish_bout_OMR', 'nb_fish', 'nb_fish_escape', 'reaction_time_ms',...
                'sign_escape', 'first_bout_direction', 'fish_to_consider_FT');
        end
        
    else
        no_tracking = [no_tracking, k];
    end
    waitbar((k-nb(1)+1)/(nb(2)-nb(1)+1),wb,sprintf('Extract bout, movie %d / %d', k-nb(1)+1, nb(2)-nb(1)+1));
end

if isempty(no_tracking) == 0
    X = ['No tracking for run ', num2str(no_tracking)];
    disp(X);
end

close(wb)
% close all;
selpath