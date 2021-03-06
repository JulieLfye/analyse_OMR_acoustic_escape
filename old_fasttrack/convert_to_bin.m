%% convert movie into binarize movie (0-255)
clear;
clc;

j = 1;
all_file = [];
all_path = [];
n = 0;
while j~= 0
    
    disp('Select the first frame');
    [f,p] = uigetfile('*.pgm',[],'C:\Users\LJP\Documents\MATLAB\these\data_OMR_acoustic\');
    
    all_file = [all_file '/' f];
    all_path = [all_path '/' p];
    n = n + 1;
    
    j = input('Other file to binarize? yes:1   no:0     ');
end

all_file = [all_file '/'];
all_path = [all_path '/'];

f_file = strfind(all_file,'/');
f_path = strfind(all_path,'/');

tic
for k = 1:n
    file = all_file(f_file(k)+1:f_file(k+1)-1);
    path = all_path(f_path(k)+1:f_path(k+1)-1);
    
    im = imread(fullfile(path,file));
    movie = zeros(size(im,1),size(im,2));
    
    imshow(movie);
    
    mkdir(path(1:end-6),'movie_bin');
    a = fullfile(path(1:end-6),'movie_bin');
    im_name = 'movie_bin_0000.tif';
    imwrite(movie,fullfile(a,im_name));
    
    w = waitbar(0,sprintf('Conversion, movie %d / %d', k, n));
    imexist = 1;
    nb = 1;
    while imexist == 1
        
        [p, f] = frame_open(file,path,nb);
        if isfile(fullfile(p,f)) == 1
            im = imread(fullfile(p,f));
            movie = uint8(frame_process(im)*255);
            
            m = floor(nb/1000);
            c = floor((nb-m*1000)/100);
            d = floor((nb-m*1000-c*100)/10);
            u = floor(nb-m*1000-c*100-d*10);
            s = size(im_name,2);
            im_name(s-7) = num2str(m);
            im_name(s-6) = num2str(c);
            im_name(s-5) = num2str(d);
            im_name(s-4) = num2str(u);
            imwrite(movie,fullfile(a,im_name));
            delete(fullfile(p,f));
            nb = nb + 1;
        else
            imexist = 0;
        end
    end
    close(w);
    close all
    rmdir(p)
end
toc