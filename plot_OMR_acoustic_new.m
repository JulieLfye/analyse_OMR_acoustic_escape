% plot OMR acoustic

% close all;
clear;
clc;
% close all;

F = Focus();

% Experiment Protocol background
% r = 'whole_illumination_asus_projo'; % OMR duration 0,500,1000,1500,2000
% r = 'whole_illumination'; % OMR duration 0,250,500,750,1000
r = 'OMR_fixed'; % OMR duration 0,250,500,750,1000

F.Root = fullfile('D:\OMR_acoustic_experiments',r,'OMR_acoustic\data\');


F.dpf = 5;
F.V = '3_0';

a = F.path;
a = a(1:end-5);
a = dir(a);

for i = 1:size(a,1)-2
    b = a(i+2).name;
    OMRname(i,:) = b(end-3:end);
    OMR(i) = str2num(OMRname(i,:));
end

std_all = nan(1,5);
m_all = nan(1,5);
p_all = nan(1,5);
std_SLC = nan(1,5);
m_SLC = nan(1,5);
p_SLC = nan(1,5);
std_LLC = nan(1,5);
m_LLC = nan(1,5);
p_LLC = nan(1,5);
std_ok = nan(1,5);
m_ok = nan(1,5);
p_ok = nan(1,5);
std_oknomov = nan(1,5);
m_oknomov = nan(1,5);
p_oknomov = nan(1,5);
pb_all = nan(1,5);
pb_SLC = nan(1,5);
pb_LLC = nan(1,5);
std_oknomovSLC = nan(1,5);
m_oknomovSLC = nan(1,5);
p_oknomovSLC = nan(1,5);
std_oknomovLLC = nan(1,5);
m_oknomovLLC = nan(1,5);
p_oknomovLLC = nan(1,5);

n_f = nan(1,5);
n_f_esc = nan(1,5);
n_SLC = nan(1,5);
n_LLC = nan(1,5);
n_ok = nan(1,5);
n_oknomov = nan(1,5);
n_oknomovSLC = nan(1,5);
n_oknomovLLC = nan(1,5);

k = 1;
for k = 1:size(a,1)-2
    F.OMR = OMRname(k,:);
    [RT_ms, ang_b, sign_esc, mat_esc, n_fish, n_fish_esc, fbout] = data_for_plotting(F);
    
    
    n_f(k) = sum(n_fish);
    n_f_esc(k) = sum(n_fish_esc);
    
    if isempty(RT_ms) == 0
        %% ----- Determine index -----
        % -- SLC responses
        ind_SLC = find(RT_ms < 20);
        n_SLC(k) = size(ind_SLC,2);
        
        % -- LLC responses
        ind_LLC = find(RT_ms > 20);
        n_LLC(k) = size(ind_LLC,2);
        
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
        
        % -- Fish in the good quadrant and with no bout !
        ind = indok;
        for i = 1:size(indok,2)
            b = find(indnomov == indok(i));
            if isempty(b) == 1
                ind(i) = nan;
            end
        end
        indoknomov = ind(isnan(ind)==0);
        n_oknomov(k) = size(indoknomov,2);
        
        
        %% ----- Means and std calculations -----
        % -- mean and std all escape
        std_all(k) = 1/sqrt(size(mat_esc,2));
        m_all(k) = mean(mat_esc);
        [~,p_all(k)] = ttest(mat_esc);
        
        % -- mean and std SLC
        std_SLC(k) = 1/sqrt(size(mat_esc(ind_SLC),2));
        m_SLC(k) = mean(mat_esc(ind_SLC));
        [~,p_SLC(k)] = ttest(mat_esc(ind_SLC));
        
        % -- mean and std LLC
        std_LLC(k) = 1/sqrt(size(mat_esc(ind_LLC),2));
        m_LLC(k) = mean(mat_esc(ind_LLC));
        [~,p_LLC(k)] = ttest(mat_esc(ind_LLC));
        
        % -- mean and std fish in the good quadrant
        std_ok(k) = 1/sqrt(size(mat_esc(indok),2));
        m_ok(k) = mean(mat_esc(indok));
        [~,p_ok(k)] = ttest(mat_esc(indok));
        
        % -- mean and std fish in the good quadrant without bout
        std_oknomov(k) = 1/sqrt(size(mat_esc(indoknomov),2));
        m_oknomov(k) = mean(mat_esc(indoknomov));
        [~,p_oknomov(k)] = ttest(mat_esc(indoknomov));
        
        % -- mean and std fish good quadrant without bout SLC
        indoknomovSLC = intersect(ind_SLC,indoknomov);
        if isempty(indoknomovSLC) == 0
            std_oknomovSLC(k) = 1/sqrt(size(mat_esc(indoknomovSLC),2));
            m_oknomovSLC(k) = mean(mat_esc(indoknomovSLC));
            [~,p_oknomovSLC(k)] = ttest(mat_esc(indoknomovSLC));
            n_oknomovSLC(k) = size(indoknomovSLC,2);
        else
            std_oknomovSLC(k) = nan;
            m_oknomovSLC(k) = nan;
            p_oknomovSLC(k) = nan;
            n_oknomovSLC(k) = 0;
        end
        
        % -- mean and std fish good quadrant without bout LLC
        indoknomovLLC = intersect(ind_LLC,indoknomov);
        if isempty(indoknomovLLC) == 0
            std_oknomovLLC(k) = 1/sqrt(size(mat_esc(indoknomovLLC),2));
            m_oknomovLLC(k) = mean(mat_esc(indoknomovLLC));
            [~,p_oknomovLLC(k)] = ttest(mat_esc(indoknomovLLC));
            n_oknomovLLC(k) = size(indoknomovLLC,2);
        else
            std_oknomovLLC(k) = nan;
            m_oknomovLLC(k) = nan;
            p_oknomovLLC(k) = nan;
            n_oknomovLLC(k) = 0;
        end
        
        %% ----- SLC and LLC probabilities -----
        pb_all(k) = sum(n_fish_esc)/sum(n_fish)*100;
        pb_SLC(k) = size(ind_SLC,2)/sum(n_fish)*100;
        pb_LLC(k) = size(ind_LLC,2)/sum(n_fish)*100;
    end
end

%% ----- Plot -----
% 
% % -- all turn
% figure(1)
% f_plot_new_OMR_acoustic(OMR, m_all, std_all, n_f, n_f_esc, p_all, F, 'All escape');
% 
% % -- SLC turn
% figure(2)
% f_plot_new_OMR_acoustic(OMR, m_SLC, std_SLC, n_f, n_SLC, p_SLC, F, 'SLC escape');
% 
% % -- LLC turn
% figure(3)
% f_plot_new_OMR_acoustic(OMR, m_LLC, std_LLC, n_f, n_LLC, p_LLC, F, 'LLC escape');
% 
% % -- Fish in the good quadrant
% figure(4)
% f_plot_new_OMR_acoustic(OMR, m_ok, std_ok, n_f, n_ok, p_ok, F, 'Good quadrant');
% 
% % -- Fish in the good quadrant without bout
% figure(5)
% f_plot_new_OMR_acoustic(OMR, m_oknomov, std_oknomov, n_f, n_oknomov, p_oknomov, F, 'Good quadrant, no bout');

% -- Fish in the good quadrant without bout
figure(1)
f_plot_new_OMR_acoustic(OMR, m_oknomovSLC, std_oknomovSLC, n_f, n_oknomovSLC, p_oknomovSLC, F, 'Good quadrant, no bout, SLC');

% -- Fish in the good quadrant without bout
figure(2)
f_plot_new_OMR_acoustic(OMR, m_oknomovLLC, std_oknomovLLC, n_f, n_oknomovLLC, p_oknomovLLC, F, 'Good quadrant, no bout, LLC');