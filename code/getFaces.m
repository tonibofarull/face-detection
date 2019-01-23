function [faces, nofaces, eyepos_m] = getFaces(images,eyepos,num_nofaces,params)
    n = length(eyepos);
    
    faces = zeros(params.face,params.face,n);
    nofaces = zeros(params.face,params.face,num_nofaces*n);
    eyepos_m = zeros(n,4);
    
    for i = 1:n
        lx = ceil(eyepos(i,1)); ly = ceil(eyepos(i,2)); 
        rx = ceil(eyepos(i,3)); ry = ceil(eyepos(i,4));
        im = images(:,:,i);
        
        dist_eye = ceil(lx-rx); % distance between eyes
        w = ceil(2*dist_eye);
        h = ceil(1.2*w); % h/w approx golden ratio
        % upperleft corner of face
        y_ul = max(ceil(ry-h/4*1.5),1);
        x_ul = max(ceil(rx-w/4),1);
        
        % minimum distance to be considered a no-face
        critical_dist = ceil(h/2);
        % face
        f = getFace(im,y_ul,x_ul,w,h,params);
        faces(:,:,i) = imresize(f,[params.face,params.face]);
        
        [hf,wf] = size(f);
        % updates the eyeposition in face image
        eyepos_m(i,1) = (lx-x_ul+1)*params.face/wf; 
        eyepos_m(i,2) = (ly-y_ul+1)*params.face/hf;
        eyepos_m(i,3) = (rx-x_ul+1)*params.face/wf; 
        eyepos_m(i,4) = (ry-y_ul+1)*params.face/hf;

        for j = 1:num_nofaces
            y = randi(params.height-h);
            x = randi(params.width-w);
            overlaps = 0;
            while isOverlapping(y,x,y_ul,x_ul,critical_dist)
                y = randi(params.height-h);
                x = randi(params.width-w);
                overlaps = overlaps + 1;
                if overlaps == params.height
                    critical_dist = critical_dist - 1;
                    overlaps = params.height - 1;
                end
            end
            nofaces(:,:,(i-1)*num_nofaces+j) = ...
                imresize(getFace(im,y,x,w,h,params), ...
                    [params.face,params.face]);
        end
    end
    
    % Crops the face from image.
    % y_ul = y of upperleft corner, same for x_ul
    % w and h are width and height of bounding box
    function [subim] = getFace(im,y_ul,x_ul,w,h,dims)
        ys = y_ul:y_ul+h; ys(ys < 1) = []; ys(ys > dims.height) = [];
        xs = x_ul:x_ul+w; xs(xs < 1) = []; xs(xs > dims.width) = [];
        subim = im(ys,xs);
    end
    
    % Check if overlaps with the real face.
    % Takes into acount the distance between upper-left corner of the face
    % and the random upper-left corner.
    function [inside] = isOverlapping(y,x,y_ul,x_ul,critical_dist)
        dist = pdist2([y,x],[y_ul,x_ul]);
        inside = dist < critical_dist;
    end
end
