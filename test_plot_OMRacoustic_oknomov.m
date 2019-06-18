% test
%% plot proba esc

% close all;
clear;
clc;

F = Focus();

F.dpf = 6;
F.V = '1_5';

OMR = [0, 500, 1000, 1500, 2000];
pb_all = nan(1,5);

n_oknomov = nan(1,5);
n_SLC = nan(1,5);
n_LLC = nan(1,5);
n_SLCoknomov = n_SLC;
n_LLCoknomov = n_LLC;

k = 1;
for k = 1:5
    if k == 1
        F.OMR = '0000';
        [RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);
    elseif k == 2
        F.OMR = '0500';
        [RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);
    elseif k == 3
        F.OMR = '1000';
        [RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);
    elseif k == 4
        F.OMR = '1500';
        [RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);
    elseif k == 5
        F.OMR = '2000';
        [RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);
    end
    
    n_f(k) = sum(n_fish);
    n_f_esc(k) = sum(n_fish_esc);
    
    if isempty(RT_ms) == 0
        %% ----- Determine index -----
        % -- Determine fish which had moved
        indmov = find(fbout == 1);
        indnomov = find(fbout == 0);
        
        % -- Determine fish between +-[40-140]
        indleft = find(ang_b > 0);
        indright = find(ang_b <= 0);
        aLR = size(indleft,2) + size(indright,2) - size(RT_ms,2);
        
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
        n_ok(k) = size(indok,2);
        
        % -- Fish in the good quadrant and with no bout !!!
        ind = indok;
        for i = 1:size(indok,2)
            b = find(indnomov == indok(i));
            if isempty(b) == 1
                ind(i) = nan;
            end
        end
        indoknomov = ind(isnan(ind)==0);
        n_oknomov(k) = size(indoknomov,2);
        
        % -- SLC responses
        ind_SLC = find(RT_ms < 20);
        n_SLC(k) = size(ind_SLC,2);
        ind_SLCoknomov = find(RT_ms(indoknomov) < 20);
        ind_SLCoknomov = indoknomov(ind_SLCoknomov);
        n_SLCoknomov(k) = size(ind_SLCoknomov,2);
        
        % -- LLC responses
        ind_LLC = find(RT_ms > 20);
        n_LLC(k) = size(ind_LLC,2);
        ind_LLCoknomov = find(RT_ms(indoknomov) > 20);
        ind_LLCoknomov = indoknomov(ind_LLCoknomov);
        n_LLCoknomov(k) = size(ind_LLCoknomov,2);
        
    end
    
    %% --- OMR acoustic oknomov analyse --- Per fish
    % - mean and std all oknomov
    m_oknomov(k) = mean(mat_esc(indoknomov));
    std_oknomov(k) = 1/sqrt(size(indoknomov,2));
    [~,p_oknomov(k)] = ttest(mat_esc(indoknomov));
    
    % - mean and std SLC oknomov
    m_SLCoknomov(k) = mean(mat_esc(ind_SLCoknomov));
    std_SLCoknomov(k) = 1/sqrt(size(ind_SLCoknomov,2));
    [~,p_SLCoknomov(k)] = ttest(mat_esc(ind_SLCoknomov));
    
    % - mean and std LLC oknomov
    m_LLCoknomov(k) = mean(mat_esc(ind_LLCoknomov));
    std_LLCoknomov(k) = 1/sqrt(size(ind_LLCoknomov,2));
    [~,p_LLCoknomov(k)] = ttest(mat_esc(ind_LLCoknomov));
    
end

if F.dpf == 7
    color = 'b';
elseif F.dpf == 6
    color = 'r';
elseif F.dpf == 5
    color = 'k';
end

% - all oknomov
f_plot_new_OMR_acoustic(OMR, m_oknomov, std_oknomov, [], n_oknomov,...
    p_oknomov, F, 'Good quadrant, no move, all')
% - SLC oknomov
f_plot_new_OMR_acoustic(OMR, m_SLCoknomov, std_SLCoknomov, [], n_SLCoknomov,...
    p_SLCoknomov, F, 'Good quadrant, no move, SLC')
%- LLC oknomov
f_plot_new_OMR_acoustic(OMR, m_LLCoknomov, std_LLCoknomov, [], n_LLCoknomov,...
    p_LLCoknomov, F, 'Good quadrant, no move, LLC')
