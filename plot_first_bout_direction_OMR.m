% plot first bout direction OMR

close all;
clear;
clc;

F = Focus();

F.dpf = 5;
F.V = '1_5';

OMR = [500, 1000, 1500, 2000];


for k = 2:5
    if k == 2
        F.OMR = '0500';
        Data = F.load('data_OMR');
        fbd = Data.first_bout_direction;
        f = find(isnan(fbd)==1);
        fbd(f) = [];
    elseif k == 3
        F.OMR = '1000';
        Data = F.load('data_OMR');
        fbd = Data.first_bout_direction;
        f = find(isnan(fbd)==1);
        fbd(f) = [];
    elseif k == 4
        F.OMR = '1500';
        Data = F.load('data_OMR');
        fbd = Data.first_bout_direction;
        f = find(isnan(fbd)==1);
        fbd(f) = [];
    elseif k == 5
        F.OMR = '2000';
        Data = F.load('data_OMR');
        fbd = Data.first_bout_direction;
        f = find(isnan(fbd)==1);
        fbd(f) = [];
    end
    
    n_f(k-1) = sum(Data.n_fish);
    n_fbd(k-1) = size(fbd,2);
    
    
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
    
end