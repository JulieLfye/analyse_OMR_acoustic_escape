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

i = 16;
for i = 1:size(fish_to_consider,2)
    f = fish_to_consider(i);
    
    ang1 = ang_body(f,frame);
    ang = ang1;
    
    for j = 2:size(frame,2)
        d1 = (ang1(j) - ang1(j-1))*180/pi;
        if isnan(d1) == 0
            ta = angle_per_frame(d1);
            if abs(ta) <= 170
                ang(1,j) = ang(1,j-1) + ta*pi/180;
            else
                ang(1,j) = ang(1,j-1);
            end
        end
    end
    
    m = mean(ang(1:6));
    d2 = abs(ang-m);
    b2 = find(d2 > 80*pi/180,1);
    if isempty(b2) == 0
        %         d = abs(diff(angle_OMR(f,frame)));
        figure
        plot(angle_OMR(f,frame))
        %         b = find(d > 60*pi/180,1);
        %         hold on
        %         plot(b,angle_OMR(f,b+frame(1)-1),'ko')
        
        d1 = abs(diff(ang));
        b1 = find(d1(7:end) > 10*std(d1(1:6)),1)+6;
        hold on
        plot(b1, angle_OMR(f,b1+frame(1)-1),'ro')
        if isempty(b1) == 0
        esc(i) = b1+frame(1)-1;
        %         figure
        %         plot(d1)
        %         hold on
        %         plot(b1,(b1),'o')
        end
    end
end