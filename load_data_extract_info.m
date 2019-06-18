% load data

clc;

F = Focus();

F.dpf = 5;
F.V = '1_5';
F.OMR = '0500';


[RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);


n_f = sum(n_fish);
n_f_esc = sum(n_fish_esc);

if isempty(RT_ms) == 0
    %% ----- Determine index -----
    % -- SLC responses
    ind_SLC = find(RT_ms < 20);
    n_SLC = size(ind_SLC,2);
    
    % -- LLC responses
    ind_LLC = find(RT_ms > 20);
    n_LLC = size(ind_LLC,2);
    
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
    n_ok = size(indok,2);
    
    % -- Fish in the good quadrant and with no bout !
    ind = indok;
    for i = 1:size(indok,2)
        b = find(indnomov == indok(i));
        if isempty(b) == 1
            ind(i) = nan;
        end
    end
    indoknomov = ind(isnan(ind)==0);
    n_oknomov = size(indoknomov,2);
    
    %% ----- Means and std calculations -----
    % -- mean and std all escape
    std_all = 1/sqrt(size(mat_esc,2));
    m_all = mean(mat_esc);
    [~,p_all] = ttest(mat_esc);
    
    % -- mean and std SLC
    std_SLC = 1/sqrt(size(mat_esc(ind_SLC),2));
    m_SLC = mean(mat_esc(ind_SLC));
    [~,p_SLC] = ttest(mat_esc(ind_SLC));
    
    % -- mean and std LLC
    std_LLC = 1/sqrt(size(mat_esc(ind_LLC),2));
    m_LLC = mean(mat_esc(ind_LLC));
    [~,p_LLC] = ttest(mat_esc(ind_LLC));
    
    % -- mean and std fish in the good quadrant
    std_ok = 1/sqrt(size(mat_esc(indok),2));
    m_ok = mean(mat_esc(indok));
    [~,p_ok] = ttest(mat_esc(indok));
    
    % -- mean and std fish in the good quadrant without bout
    std_oknomov = 1/sqrt(size(mat_esc(indoknomov),2));
    m_oknomov = mean(mat_esc(indoknomov));
    [~,p_oknomov] = ttest(mat_esc(indoknomov));
    
    
    %% ----- SLC and LLC probabilities -----
    pb_all = sum(n_fish_esc)/sum(n_fish)*100;
    pb_SLC = size(ind_SLC,2)/sum(n_fish)*100;
    pb_LLC = size(ind_LLC,2)/sum(n_fish)*100;
end

OMR = str2double(F.OMR);

% %% ----- Plot -----
%
% % -- all turn
f_plot_new_OMR_acoustic(OMR, m_all, std_all, n_f, n_f_esc, p_all, F, 'All escape');
%
% % -- SLC turn
% f_plot_new_OMR_acoustic(OMR, m_SLC, std_SLC, n_f, n_SLC, p_SLC, F, 'SLC escape');
%
% % -- LLC turn
% f_plot_new_OMR_acoustic(OMR, m_LLC, std_LLC, n_f, n_LLC, p_LLC, F, 'LLC escape');
%
% % -- Fish in the good quadrant
% f_plot_new_OMR_acoustic(OMR, m_ok, std_ok, n_f, n_ok, p_ok, F, 'Good quadrant');
%
% % -- Fish in the good quadrant without bout
% f_plot_new_OMR_acoustic(OMR, m_oknomov, std_oknomov, n_f, n_oknomov, p_oknomov, F, 'Good quadrant, no bout');