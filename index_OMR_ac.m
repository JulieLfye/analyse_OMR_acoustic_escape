% Determine important index

hold on
clear;


% -- load data
F = Focus();

F.dpf = '7';
F.OMR = '2000';
F.V = '1_5';

Data = F.load('data_OMR');
ang_b = Data.angle_before;
esc_mat = Data.escape_matrix;
fbout = Data.fish_bout_OMR;
nf = Data.nb_fish;
nf_esc = Data.nb_fish_escape;
RT = Data.reaction_time_ms;
s_esc = Data.sign_escape;

% -- remove nan value
a = sum(nf -nf_esc);
b = find(isnan(RT) == 1);

ang_b(b) = [];
esc_mat(b) = [];
fbout(b) = [];
RT(b) = [];
s_esc(b) = [];

% -- Determine SLC and LLC index
lim_SL = 20; % in ms
indSLC = find(RT < 20);
indLLC = find(RT > 20);
aSL = size(indSLC,2)+size(indLLC,2) - size(RT,2);

% -- Determine fish which had moved
indmov = find(fbout == 1);
indnomov = find(fbout == 0);
amov = size(indmov,2) + size(indnomov,2) - size(RT,2);

% -- Determine fish between +-[40-140]
indleft = find(ang_b > 0);
indright = find(ang_b <= 0);
aLR = size(indleft,2) + size(indright,2) - size(RT,2);

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

% -- Fish in the good quadrant and with no bout !
ind = indok;
for i = 1:size(indok,2)
    b = find(indnomov == indok(i));
    if isempty(b) == 1
        ind(i) = nan;
    end
end
indoknomov = ind(isnan(ind)==0);

% -- Fish in the good quadrant with bout
ind = indok;
for i = 1:size(indok,2)
    b = find(indmov == indok(i));
    if isempty(b) == 1
        ind(i) = nan;
    end
end
indokmov = ind(isnan(ind)==0);