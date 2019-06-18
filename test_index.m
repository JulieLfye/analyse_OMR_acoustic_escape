% test
%% plot proba esc

% close all;
clear;
clc;

F = Focus();

F.dpf = 5;
F.V = '1_5';


F.OMR = '2000';
[RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);

if isempty(RT_ms) == 0
    %% ----- Determine index -----
    % -- Determine fish which had moved
    indmov = find(fbout == 1);
    indnomov = find(fbout == 0);
    
    % -- Determine fish between +-[40-140]
    indleft = find(ang_b > 0);
    indright = find(ang_b <= 0);
    
    l1 = find(ang_b > 40*pi/180);
    l2 = find(ang_b < 140*pi/180);
    for i = 1:size(l1,2)
        b = find(l2 == l1(i));
        if isempty(b) == 1
            l1(i) = nan;
        end
    end
    indlq = l1(isnan(l1)==0);
    
    r1 = find(ang_b < -40*pi/180);
    r2 = find(ang_b > -140*pi/180);
    b = [];
    for i = 1:size(r1,2)
        b = find(r2 == r1(i));
        if isempty(b) == 1
            r1(i) = nan;
        end
    end
    indrq = r1(isnan(r1)==0);
    indok = [indlq, indrq];
    n_ok = size(indok,2);
    
    % -- Fish in the good quadrant and with no bout !!!
    ind = indok;
    for i = 1:size(indok,2)
        b = find(indnomov == indok(i));
        if isempty(b) == 1
            ind(i) = nan;
        end
    end
    indoknomov = ind(isnan(ind)==0);
    n_oknomov = size(indoknomov,2);
    
    % -- SLC responses
    ind_SLC = find(RT_ms < 20);
    n_SLC = size(ind_SLC,2);
    ind_SLCoknomov = find(RT_ms(indoknomov) < 20);
    ind_SLCoknomov = indoknomov(ind_SLCoknomov);
    n_SLCoknomov = size(ind_SLCoknomov,2);
    
    % -- LLC responses
    ind_LLC = find(RT_ms > 20);
    n_LLC = size(ind_LLC,2);
    ind_LLCoknomov = find(RT_ms(indoknomov) > 20);
    ind_LLCoknomov = indoknomov(ind_LLCoknomov);
    n_LLCoknomov = size(ind_LLCoknomov,2);
    
end