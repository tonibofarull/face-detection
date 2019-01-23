function [eyepos, images, looking] = readData(path,params)
    eye_dir = dir(strcat(path,'*.eye'));
    image_dir = dir(strcat(path,'*.pgm'));
    n = numel(eye_dir); % number of photos
    eyepos = zeros(n,4);
    images = zeros(params.height,params.width,n);
    for i = 1:n
        % Eye images
        images(:,:,i) = imread(strcat(path,image_dir(i).name));
        % Eye pos
        fid = fopen(strcat(path,eye_dir(i).name));
        textscan(fid, '%s', 1, 'delimiter', '\n');
        d = textscan(fid, '%d', 4, 'delimiter', ' ');
        lx = d{1}(1); ly = d{1}(2); rx = d{1}(3); ry = d{1}(4);
        fclose(fid);
        % left eye [ly,lx], right eye [ry,rx]. left eye (physically)
        eyepos(i,:) = [lx, ly, rx, ry];
    end
    looking = fscanf(fopen('..\data\looking.txt','r'),'%d');
end