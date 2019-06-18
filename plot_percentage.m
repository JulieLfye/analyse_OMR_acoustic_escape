% test
%% plot proba esc

% close all;
clear;
clc;

F = Focus();

F.dpf = 7;
F.V = '3_0';

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
        n_SLCoknomov(k) = size(ind_SLCoknomov,2);
        
        % -- LLC responses
        ind_LLC = find(RT_ms > 20);
        n_LLC(k) = size(ind_LLC,2);
        ind_LLCoknomov = find(RT_ms(indoknomov) > 20);
        n_LLCoknomov(k) = size(ind_LLCoknomov,2);
                
    end
    
    %% -- Probabilities --
    p_all(k) = mean(n_fish_esc./n_fish)*100;
    s_all(k) = std(n_fish_esc./n_fish)/sqrt(size(n_fish,2))*100;
    
    iLLC = ind_LLC;
    iSLC = ind_SLC;
    iLLCok = ind_LLCoknomov;
    iSLCok = ind_SLCoknomov;
    iok = indoknomov;
    
    i = 1;
    for i = 1:size(n_fish,2)
        % all fish
        fL = find(iLLC <= sum(n_fish_esc(1:i)));
        fS = find(iSLC <= sum(n_fish_esc(1:i)));
        iLLC(fL) = [];
        iSLC(fS) = [];
         
        pS(i) = size(fS,2)/n_fish_esc(i)*100;
        pL(i) = size(fL,2)/n_fish_esc(i)*100;
        
        % fish good quadrant, no move
        fL = find(iLLCok <= sum(n_fish_esc(1:i)));
        fS = find(iSLCok <= sum(n_fish_esc(1:i)));
        fa = find(iok <= sum(n_fish_esc(1:i)));
        iLLCok(fL) = [];
        iSLCok(fS) = [];
        iok(fa) = [];
         
        pSok(i) = size(fS,2)/n_fish_esc(i)*100;
        pLok(i) = size(fL,2)/n_fish_esc(i)*100;
        pok(i) = size(fa,2)/n_fish_esc(i)*100;
        
    end
    % all fish
    mpS(k) = mean(pS,'omitnan');
    spS(k) = std(pS)/sqrt(size(n_fish_esc,2));
    mpL(k) = mean(pL,'omitnan');
    spL(k) = std(pL)/sqrt(size(n_fish_esc,2));
    % fish good quadrant, no move
    mpSok(k) = mean(pSok,'omitnan');
    spSok(k) = std(pSok)/sqrt(size(n_fish_esc,2));
    mpLok(k) = mean(pLok,'omitnan');
    spLok(k) = std(pLok)/sqrt(size(n_fish_esc,2));
    mpok(k) = mean(pok,'omitnan');
    spok(k) = std(pok)/sqrt(size(n_fish_esc,2));
    
end

if F.dpf == 7
    color = 'b';
elseif F.dpf == 6
    color = 'r';
elseif F.dpf == 5
    color = 'k';
end

%% plot all fish
% responsiveness
figure(1);
hold on
errorbar(OMR,p_all,s_all,'-d','Color',color, 'MarkerFaceColor',color)
xlim([-100 2100])
ylim([0 100])
xticks([0, 500, 1000, 1500, 2000])
xticklabels({'0', '500', '1000', '1500', '2000'})
title({'Fish responsiveness'})

% SLC
figure(2);
hold on
errorbar(OMR,mpS,spS,'-o','Color',color, 'MarkerFaceColor',color)
xlim([-100 2100])
ylim([0 100])
xticks([0, 500, 1000, 1500, 2000])
xticklabels({'0', '500', '1000', '1500', '2000'})
title({'SLC probalities'})
% LLC
figure(3);
hold on
errorbar(OMR,mpL,spL,'-s','Color',color, 'MarkerFaceColor',color)
xlim([-100 2100])
ylim([0 100])
xticks([0, 500, 1000, 1500, 2000])
xticklabels({'0', '500', '1000', '1500', '2000'})
title({'LLC probalities'})

%% plot fish good quadrant no move
% responsiveness
figure(4);
hold on
errorbar(OMR,mpok,spok,'-d','Color',color, 'MarkerFaceColor',color)
xlim([-100 2100])
ylim([0 100])
xticks([0, 500, 1000, 1500, 2000])
xticklabels({'0', '500', '1000', '1500', '2000'})
title({'Fish responsiveness, good quadrant, no bout'})

% SLC
figure(5);
hold on
errorbar(OMR,mpSok,spSok,'-o','Color',color, 'MarkerFaceColor',color)
xlim([-100 2100])
ylim([0 100])
xticks([0, 500, 1000, 1500, 2000])
xticklabels({'0', '500', '1000', '1500', '2000'})
title({'SLC probalities, good quadrant, no bout'})

% LLC
figure(6);
hold on
errorbar(OMR,mpLok,spLok,'-s','Color',color, 'MarkerFaceColor',color)
xlim([-100 2100])
ylim([0 100])
xticks([0, 500, 1000, 1500, 2000])
xticklabels({'0', '500', '1000', '1500', '2000'})
title({'LLC probalities, good quadrant, no bout'})
