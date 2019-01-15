% % analyse file tracking from fishy tracking
% clear;
% clc;
%
% disp('Select the tracking file');
% [file,path] = uigetfile('*.txt');
% t = readtable(fullfile(path,file),'Delimiter','\t');
% s = table2array(t);
%
% % -------------------------------------------------------------------------
% % determine number of tracked object
% n = 0;
% i = 1;
% nb_tracked_object = 0;
% while n~=1
%     if s(i,1) == 0
%         nb_tracked_object = nb_tracked_object + 1;
%         i = i+1;
%     else
%         n = 1;
%     end
% end
%
% % determine number of frame
% nb_frame = max(s(:,end));
%
% % determine number of detected object
% n = 0;
% i = 1;
% nb_detected_object = 0;
% while n~=1
%     if isnan(s(nb_frame*nb_tracked_object + i,1)) == 0
%         nb_detected_object = nb_detected_object + 1;
%         i = i+1;
%     else
%         n = 1;
%     end
% end
%
% % extract parameters of interest
% for f = 1:nb_detected_object
%     for i = 1:nb_frame
%         xbody(f,i) = s(i*nb_tracked_object + f, 7);
%         ybody(f,i) = s(i*nb_tracked_object + f, 8);
%         ang_body(f,i) = s(i*nb_tracked_object + f, 9); %in rad
%     end
% end
% clear t s
% -------------------------------------------------------------------------

% ----- Analyse ----
% check if angle is always good

% for f = 1:nb_detected_object
% close
f = 4;
ang_body_corr = ang_body(f,:);
plot(ang_body(f,:)*180/pi)
% for i = 2:nb_frame-1
%     d = (ang_body_corr(1,i+1)-ang_body_corr(1,i));
%     if d > 3
%         ang_body_corr(1,i+1) = ang_body_corr(1,i);
%     elseif d < -3
%         ang_body_corr(1,i+1) = ang_body_corr(1,i);
%     end
% end
%
% hold on
% plot(ang_body_corr(1,:)*180/pi)

% with my code
ang_body_me = nan(1,nb_frame);
% disp('Select the first frame');
% [im_name,path] = uigetfile('*tif');
for i = 1:nb_frame
    if isnan(xbody(f,i)) == 0
        im = frame_open(im_name,path,i+1);
        
        lmin = round(ybody(f,i))-25;
        if lmin <= 0
            lmin = 1;
        end
        lmax = round(ybody(f,i))+25;
        if lmax > size(im,1)
            lmax = size(im,1);
        end
        cmin = round(xbody(f,i))-25;
        if cmin <= 0
            cmin = 1;
        end
        cmax = round(xbody(f,i))+25;
        if cmax > size(im,2)
            lmin = size(im,2);
        end
        
        im_bw = im(lmin:lmax,cmin:cmax);        
        [~,~,ang_body_me(i)] = get_orientation_distmap(im_bw);
    end
end
hold on
plot(ang_body_me)





% figure, plot(d)
% end

% turn_body = zeros(f,nb_frame-1);
% for f = 1:nb_detected_object
%     for i = 1:nb_frame-1
%         d = (ang_body(f,i+1)-ang_body(f,i))*180/pi;
%         if isnan(d) == 0
%             turn_body(f,i) = angle_per_frame(d)*pi/180;
%         end
%     end
%     hold on
%     plot(cumsum(turn_body(f,:)))
% end