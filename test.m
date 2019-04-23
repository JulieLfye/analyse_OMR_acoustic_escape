% test code
close all

frame = nb_frame-55+1:1:nb_frame;

reaction_time = nan(1,nb_detected_object);
angle_before = nan(1,nb_detected_object);
angle_escape = nan(1,nb_detected_object);
escape_matrix = nan(1,nb_detected_object);


%% Determine fish that are present from OMR beginning to escape
fOMR = find(isnan(xbody(:,150)) == 0)';
fescape = find(isnan(xbody(:,end-50)) == 0)';

fish_to_consider = nan(size(fOMR));
for i = 1:size(fOMR,2)
    a = find(fescape == fOMR(i));
    if isempty(a) == 0
        fish_to_consider(i) = fOMR(i);
    end
end
fish_to_consider(isnan(fish_to_consider)==1) = [];


%% Determine reaction_time, angle_before, angle_escape and escape matrix

i = 10;
escbr = nan(size(fish_to_consider));
% for i = 1:size(fish_to_consider,2)
    f = fish_to_consider(i);
    
    angt = angle_tail(f,frame);
    angb = angle_OMR(f,frame);
    angbr = ang_body(f,frame);
    ang = angbr;
    for j = 2:size(frame,2)
        d1 = (angbr(j) - angbr(j-1))*180/pi;
        if isnan(d1) == 0
            ta = angle_per_frame(d1);
            if abs(ta) <= 170
                ang(1,j) = ang(1,j-1) + ta*pi/180;
            else
                ang(1,j) = ang(1,j-1);
            end
        end
    end
    
    d = abs(diff(angt));
    b = find(d(7:end-30) > 60*pi/180,1);
    
    if isempty(b)==0
        
        d1 = abs(diff(ang));
        a(i) = 6*std(d1(1:6));
        if a(i) < 1 && a(i) > 0.1
            b1 = find(d1(7:end-30) > 6*std(d1(1:6)),1)+6;
            if isempty(b1) == 0
                escbr(i) = b1+frame(1)-1;
            end
        else
            b1 = find( d1(7:end-30) > 0.2,1)+6;
            if isempty(b1) == 0
                escbr(i) = b1+frame(1)-1;
            end
        end
        
        figure
        plot(frame,angb*180/pi,'k')
        hold on
        if isnan(escbr(i))==0
            plot(escbr(i),angb(escbr(i)-frame(1)+1)*180/pi,'ob')
        end    
    else
        figure
        plot(frame, angb*180/pi, 'r')
    end
% end