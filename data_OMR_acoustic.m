function [reaction_time, reaction_time_ms, angle_before, sign_escape,...
    fish_to_consider, escape_matrix, fish_bout_OMR, nb_fish, nb_fish_escape] = ...
    data_OMR_acoustic(nb_frame, xbody, ang_tail, angle_OMR, ang_body, fps, indbout)

frame = nb_frame-55+1:1:nb_frame;

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
reaction_time = nan(1,size(fish_to_consider,2));
reaction_time_ms = reaction_time;
angle_before = reaction_time;
sign_escape = reaction_time;
escape_matrix = reaction_time;
fish_bout_OMR = reaction_time;


%% Determine reaction_time, angle_before, angle_escape and escape matrix

i = 18;
escbr = nan(size(fish_to_consider));
for i = 1:size(fish_to_consider,2)
    f = fish_to_consider(i);
    
    a = size(indbout{f},1);
    
    if a > 0
        
        angtr = ang_tail(f,frame);
        angbOMR = angle_OMR(f,frame);
        angbr = ang_body(f,frame);
        angb = angbr;
        angt = angtr;
        
        for j = 2:size(frame,2)
            d1 = (angbr(j) - angbr(j-1))*180/pi;
            if isnan(d1) == 0
                ta = angle_per_frame(d1);
                if abs(ta) <= 170
                    angb(1,j) = angb(1,j-1) + ta*pi/180;
                else
                    angb(1,j) = angb(1,j-1);
                end
            end
        end
        
        for j = 2:size(frame,2)
            d1 = (angtr(j) - angtr(j-1))*180/pi;
            if isnan(d1) == 0
                ta = angle_per_frame(d1);
                angt(1,j) = angt(1,j-1) + ta*pi/180;
            end
        end
        
        m = prctile(angt(1:6),80);
        d2 = abs(angt-m);
        b2 = find(d2 > 70*pi/180,1);
        
        if isempty(b2)==0 && b2 > 6 && b2 < 25
            
            d1 = abs(diff(angb));
            a(i) = 6*std(d1(1:6));
            if a(i) < 1 && a(i) > 0.2
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
            angle_before(i) = mod(prctile(angbOMR(1:6),80),2*pi);
            sign_escape(i) = sign(angt(b2)-angt(b2-1));
        end
        
        % determine if the fish has moved during OMR
        b = find(indbout{f}(1,:) > 150);
        b3 = find(indbout{f}(1,b) < nb_frame-60);
        if isempty(b3) == 0
            fish_bout_OMR(i) = 1;
        else
            fish_bout_OMR(i) = 0;
        end
        
    end
    
end

reaction_time = escbr;
reaction_time_ms = (escbr-min(escbr)+0.5)/fps*1000;
t = find(angle_before>pi);
angle_before(t) = angle_before(t)-2*pi;
escape_matrix  = -sign(angle_before).*sign_escape;
nb_fish = size(fish_to_consider,2);
a = find(isnan(reaction_time)==0);
nb_fish_escape = size(a,2);