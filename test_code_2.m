% test_code_2

close all
f = 1;
ang = ang_body(f,:);

d  = [nan diff(ang)];
plot(d)
[val,ind] = findpeaks(d,'MinPeakHeight',pi/2);
% b = find(val>4.5);
% val(b) = [];
% ind(b) = [];
hold on
plot(ind,val,'o')



%% determine group of peaks to correct
dind = diff(ind);
b1 = find(dind<8);
a = diff(b1);
b2 = find(a>1);
ind2 = ind;
if isempty(b2) == 0
    n1 = 1;
    n2 = b2(1);
    i = 1;
    
    while i <= size(b2,2)+1
        if n1 == n2
            gpind = ind(b1(n1):b1(n1)+1);
            ind2(b1(n1):b1(n1)+1) = nan;
            i = i+1;
            n1 = n2+1;
            if i >= size(b2,2)+1
                n2 = size(b1,2);
            else
                n2 = b2(i);
            end
            
            % correct the angle now
            mmin = min(gpind);
            mmax = max(gpind);
            m = round(mean(gpind));
            md = mean(ang(mmax+4:mmax+5),'omitnan');
            mg = mean(ang(mmin-5:mmin-4),'omitnan');
            % correction
            for j = mmin-3:m
                ang(j) = mg;
            end
            for j = m+1:mmax+3
                ang(j) = md;
            end
            
            
        else
            gpind = ind(b1(n1):b1(n2)+1);
            ind2(b1(n1):b1(n2)+1) = nan;
            i = i+1;
            n1 = n2+1;
            if i >= size(b2,2)+1
                n2 = size(b1,2);
            else
                n2 = b2(i);
            end
            
            % correct the angle now
            mmin = min(gpind);
            mmax = max(gpind);
            m = round(mean(gpind));
            md = mean(ang(mmax+4:mmax+5),'omitnan');
            mg = mean(ang(mmin-5:mmin-4),'omitnan');
            % correction
            for j = mmin-3:m
                ang(j) = mg;
            end
            for j = m+1:mmax+3
                ang(j) = md;
            end
        end
    end
elseif isempty(b1) == 0
    n1 = 1;
    gpind = ind(b1(n1):b1(n1)+1);
    mmin = min(gpind);
    mmax = max(gpind);
    m = round(mean(gpind));
    md = mean(ang(mmax+4:mmax+5),'omitnan');
    mg = mean(ang(mmin-5:mmin-4),'omitnan');
    for j = mmin-3:m
        ang(j) = mg;
    end
    for j = m+1:mmax+3
        ang(j) = md;
    end
    
end


%% correct isolated point

l = find(isnan(ind2) == 0);
for i = 1:size(l,2)
    q = ind2(l(i));
    md = mean(ang(q+4:q+5),'omitnan');
    mg = mean(ang(q-5:q-4),'omitnan');
    % correct angle
    ang(q-2) = mg;
    ang(q-1) = mg;
    ang(q) = mg;
    ang(q+1) = md;
    ang(q+2) = md;
    
end

ang(1) = mean(ang(2:5),'omitnan');
ang(end) = mean(ang(end-5:end-2),'omitnan');
figure;
plot(ang_body(f,:));
hold on;
plot(ang);

%% Correction of the 0-360 edge
angle = ang;
% for f = 1:nb_detected_object
for i = 2:nb_frame
    d = (ang(i) - ang(i-1))*180/pi;
    if isnan(d) == 0
        ta = angle_per_frame(d);
        if abs(ta) <= 150
            angle(i) = angle(i-1) + ta*pi/180;
        else
            angle(i) = angle(i-1);
        end
    end
end

figure;
plot(angle*180/pi)
