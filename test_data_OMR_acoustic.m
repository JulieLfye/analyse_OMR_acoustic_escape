% test code

% function [reaction_time, reaction_time_ms, angle_before, angle_escape,...
%     nb_fish_considered, nb_fish_escape, f_remove] = data_OMR_acoustic(nb_detected_object,...
%     nb_frame, angle_OMR, fps, fig)

close all

frame = nb_frame-60+1:1:nb_frame;

reaction_time = nan(1,nb_detected_object);
angle_before = nan(1,nb_detected_object);
angle_escape = nan(1,nb_detected_object);
ang1 = nan(1,nb_detected_object);

f = 12;
% for f = 1:nb_detected_object
s = sum(isnan(angle_OMR(f,frame(1:30))));
if s == 0
    %         figure
    %         plot(frame,angle_OMR(f,frame)*180/pi);
    %         hold on;
    %         plot(frame,ang_body(f,frame)*180/pi,'r');
    
    a = find(indbout{f}(1,:) > nb_frame-60+1);
    % bout escape?
    if isempty(a) == 0
        %             plot(indbout{f}(1,a),angle_OMR(f,indbout{f}(1,a))*180/pi,'ko')
        
        velang = abs(diff(angle_OMR(f,frame)));
        velangbody = abs(diff(ang_body(f,frame)));
        d = sum(round(velang(1:end-1)-velangbody(1:end-1)));
        
        if d ~= 0
            f;
            b = find(velang>40*pi/180,1);
            bbody = find(velangbody>40*pi/180,1);
            figure
            plot(velang)
            hold on
            plot(b-1,velang(b-1),'ro')
            title({'velang fish n°', num2str(f-1)})
            figure
            plot(velangbody)
            hold on
            plot(bbody-1,velangbody(bbody-1),'ro')
            title({'velangbody fish n°', num2str(f-1)})
            b = b-1+frame(1)
            bbody = bbody-1+frame(1)
        end
    end
end
% end