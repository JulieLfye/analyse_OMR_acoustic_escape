% analyse file tracking from fishy tracking
% need fucntions: frame_open, cropped_im, get_orientation_distmap,
clear;
clc;
close all;

disp('Select the first frame of the binarized movie');
[file,path] = uigetfile('*.tif');
t = readtable(fullfile(path,'Tracking_Result\tracking.txt'),'Delimiter','\t');
s = table2array(t);

%% -------------------------------------------------------------------------
tic
% determine number of tracked object
n = 0;
i = 1;
nb_tracked_object = 0;
while n~=1
    if s(i,1) == 0
        nb_tracked_object = nb_tracked_object + 1;
        i = i+1;
    else
        n = 1;
    end
end

% determine number of frame
nb_frame = max(s(:,end));

% determine number of detected object
n = 0;
i = 1;
nb_detected_object = 0;
while n~=1
    if isnan(s(nb_frame*nb_tracked_object + i,1)) == 0
        nb_detected_object = nb_detected_object + 1;
        i = i+1;
    else
        n = 1;
    end
end

% extract parameters of interest
for f = 1:nb_detected_object
    for i = 1:nb_frame
        xbody(f,i) = s(i*nb_tracked_object + f, 7);
        ybody(f,i) = s(i*nb_tracked_object + f, 8);
    end
end
clear t s
% -------------------------------------------------------------------------

%% ----- Analyse ----
% determine angle
ang_body = nan(f,nb_frame);
for f = 1:nb_detected_object
    for i = 1:nb_frame
        w = 50;
        h = 50;
        if isnan(xbody(f,i)) == 0
            im = frame_open(file,path,i+1);
            [im_bw] = cropped_im(xbody(f,i),ybody(f,i),w,h,im);
            se = strel('square',2);
            im_bw = imdilate(im_bw,se);
            [~,n] = bwlabel(im_bw);
            if n ~= 0
                while n > 1 && w >= 0 && h >=0
                    w = w - 10;
                    h = h - 10;
                    [im_bw] = cropped_im(xbody(f,i),ybody(f,i),w,h,im);
                    se = strel('square',2);
                    im_bw = imdilate(im_bw,se);
                    [~,n] = bwlabel(im_bw);
                end
                [~,~,ang] = get_orientation_distmap(im_bw);
                ang_body(f,i) = ang*pi/180;
            end
        end
    end
    %     hold on
    %     plot(ang_body(f,:));
end

% correct head tail problem
for f = 1:nb_detected_object
    %     figure
    %     plot(ang_body(f,:));
    for i = 2:nb_frame-1
        diff_g = ang_body(f,i) - ang_body(f,i-1);
        diff_d = ang_body(f,i+1) - ang_body(f,i);
        t = diff_g - diff_d;
        if abs(diff_g) > 150*pi/180 && abs(diff_d) > 150*pi/180
            
            if abs(t) > 5
                ang_body(f,i) = (ang_body(f,i-1) + ang_body(f,i+1))/2;
            end
        end
        
    end
    %     hold on
    %     plot(ang_body(f,:));
end

% angle with no 0/360° edge
angle = ang_body;
for f = 1:nb_detected_object
%     figure
%     plot(ang_body(f,:));
    for i = 2:nb_frame
        d = (ang_body(f,i) - ang_body(f,i-1))*180/pi;
        if isnan(d) == 0
            t = angle_per_frame(d)*pi/180;
            angle(f,i) = angle(f,i-1) + t;
        end
    end
%     hold on
%     plot(angle(f,:))
end

toc