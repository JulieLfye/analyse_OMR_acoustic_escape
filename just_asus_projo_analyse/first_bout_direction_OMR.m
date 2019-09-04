% code test

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
% wb = waitbar(0,sprintf('First bout direction, movie 1 / %d', nb(2)-nb(1)+1));
for k = nb(1):nb(2)
    
    d = floor(k/10);
    u = floor(k-d*10);
    run = ['run_', num2str(d), num2str(u)];
    path = fullfile(selpath,run);
    
    if isfile(fullfile(path, 'raw_data.mat')) == 1
        
        load(fullfile(path,'raw_data.mat'));
        path = fullfile(selpath,run);
        F.dpf = P.fish(4);
        if P.OMR.Duration == 0
            F.OMR = '0000';
        elseif P.OMR.Duration == 500
            F.OMR = '0500';
        else
            F.OMR = num2str(P.OMR.Duration);
        end
        
        % -- determine fish that are present from the OMR beginning
        fOMR = find(isnan(xbody(:,150)) == 0)';
        fescape = find(isnan(xbody(:,end-50)) == 0)';
        
        fish_to_consider = nan(size(fOMR));
        for i = 1:size(fOMR,2)
            a = find(fescape == fOMR(i));
            if isempty(a) == 0
                fish_to_consider(i) = fOMR(i);
            end
        end
        fish_to_consider(isnan(fish_to_consider)==1) = [];
        
        % -- Determine direction of the first bout direction (if turn)
        mat_turn = nan(1,size(fish_to_consider,2));
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
                    mat_turn(i) = -sign(ang_b)*sign(turn);
                end
                
            end
        end
        load(fullfile(path,'OMR_ac_data.mat'));
        save(fullfile(path, 'OMR_ac_data.mat'), 'angle_before', 'escape_matrix',...
            'fish_bout_OMR', 'fish_to_consider', 'nb_fish', 'nb_fish_escape', 'reaction_time',...
            'reaction_time_ms', 'sign_escape', 'mat_turn')
        
        D = F.load('data_OMR.mat');
        angle_before = D.angle_before;
        escape_matrix = D.escape_matrix;
        fish_bout_OMR = D.fish_bout_OMR;
        nb_fish = D.nb_fish;
        nb_fish_escape = D.nb_fish_escape;
        reaction_time_ms = D.reaction_time_ms;
        sign_escape = D.sign_escape;
        first_bout_direction = [D.first_bout_direction mat_turn];
        save(fullfile(F.path,'data_OMR.mat'),'angle_before', 'escape_matrix',...
            'fish_bout_OMR', 'nb_fish', 'nb_fish_escape', 'reaction_time_ms',...
            'sign_escape','first_bout_direction');
    end
end
toc
selpath