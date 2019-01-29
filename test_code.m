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
close all
f = 8;
ang1 = ang_body(f,:);
figure;
plot(ang1);
b = 0.4;
% for f = 1:nb_detected_object

% correct angle ie 180� problem
% d = [nan abs(diff(ang))];
d = [nan diff(ang_body(f,:))];
plot(d)
[val,ind] = findpeaks(d,'MinPeakHeight',pi/2);
hold on
plot(ind,val,'o')
f = 1;
for i = 1:size(ind,2)
    q = ind(i);
    dg = d(q-1);
    dd = d(q+1);
    if abs(dg) <= b && abs(dd) <= b
        dgg = d(q-2);
        ddd = d(q+2);
        if abs(dgg) <= b && abs(ddd) <= b
            ang1(f,q) = ang1(f,q);
        elseif abs(dgg) <= b
            ang1(f,q) = ang1(f,q-2);
            ang1(f,q+1) = ang1(f,q-1);
        elseif abs(ddd) <= b
            ang1(f,q-1) = ang1(f,q-3);
            ang1(f,q) = ang1(f,q-2);
        end
    elseif abs(dg) <= b
        ang1(f,q) = ang1(f,q-1);
    elseif abs(dd) <= b
        ang1(f,q-1) = ang1(f,q-2);
    elseif dg < -b && dd < -b
        ang1(f,q) = ang1(f,q-1);
    end
end
% end
% figure;
% plot(ang_body(10,:));
figure;
plot(ang1');


angle = ang1;
ang_OMR = ang1;
% for f = 1:nb_detected_object
for i = 2:nb_frame
    d = (ang1(f,i) - ang1(f,i-1))*180/pi;
    if isnan(d) == 0
        ta(i) = angle_per_frame(d);
        if abs(ta(i)) <= 100
            angle(f,i) = angle(f,i-1) + ta(i);
        else
            angle(f,i) = angle(f,i-1);
        end
    end
end
angle(f,end) = angle(f,end-1);

OMRangle = mod(P.OMR.angle,360)*pi/180;
ang_OMR(f,:) = angle(f,:) - OMRangle;
ang2 = mean(angle(f,1:5),'omitnan');
if ang2 > pi
    ang_OMR(f,:) = angle(f,:) - 2*pi;
end
% end
figure, plot(ang_OMR');