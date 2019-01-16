% analyse file tracking from fishy tracking
% need fucntions: frame_open, cropped_im, get_orientation_distmap,
clear;
clc;
close all;

disp('Select the tracking file');
[file,path] = uigetfile('*.txt');
t = readtable(fullfile(path,file),'Delimiter','\t');
s = table2array(t);
disp('Select the first frame');
[file,path] = uigetfile('*.tif');

%% -------------------------------------------------------------------------
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
    hold on
    plot(ang_body(f,:))
end

% turn
