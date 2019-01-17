function [nb_tracked_object, nb_frame, nb_detected_object, xbody, ybody]...
    = extract_parameters_from_fast_track(s)

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