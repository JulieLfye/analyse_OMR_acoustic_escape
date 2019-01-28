% save angle_to_OMR

% save(fullfile(a,'angle_to_OMR.mat'),angle_to_OMR)

% clc
%
% F = Focus();
%
% F.dpf = 5;
% F.OMR = 1000;
% F.V = '1_0';
%
% Data = F.load('');

%% -------------------------------------------------

ang = ang_body(1,:);
ang1 = ang;
close all
% correct angle ie 180° problem
% d = [nan abs(diff(ang))];
d = [nan diff(ang)];
plot(d)
[val,ind,w,p] = findpeaks(d,'MinPeakHeight',110*pi/180);
% [val,ind] = findpeaks(d,'MinPeakDistance',2);
hold on
plot(ind,val,'o')

for i = 1:size(ind,2)
    n = round(w(i));
    if n > 1 && p(i) > 1
        if n == 2
            dg = abs(d(ind(i))-d(ind(i)-n/2));
            dd = abs(d(ind(i)+n/2)-d(ind(i)));
            if dd <= 0.4  %17.2°, ind(i) is the angle to change
                q = ind(i);
                ang1(q) = (ang1(q-2)+ang1(q-1))/2;
            end
            if dg <= 0.4 % here it's ind(i)-1
                q = ind(i)-1;
                ang1(q) = (ang1(q-2)+ang1(q-1))/2;
            end
        end
        if n == 4
            dg = abs(d(ind(i))-d(ind(i)-n/2));
            dd = abs(d(ind(i)+n/2)-d(ind(i)));
            if dd <= 0.4  %17.2°, ind(i) is the middle
                q = ind(i);
                ang1(q-1) = (ang1((q-1)-2)+ang1((q-1)-1))/2;
                ang1(q+1) = (ang1((q+1)-2)+ang1((q+1)-1))/2;
                ang1(q) = (ang1(q-2)+ang1(q-1))/2;
            end
            if dg <= 0.4 %  ind(i)-1 is the middle
                q = ind(i)-1;
                ang1(q-1) = (ang1((q-1)-2)+ang1((q-1)-1))/2;
                ang1(q+1) = (ang1((q+1)-2)+ang1((q+1)-1))/2;
                ang1(q) = (ang1(q-2)+ang1(q-1))/2;
            end
        end
    end
end
figure;
plot(ang1)
