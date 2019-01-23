function [eyes, noeyes] = getEyes(images,eyepos,num_noeyes,params)
    n = length(eyepos);
    
    eyes = zeros(params.eye,params.eye,2*n);
    noeyes = zeros(params.eye,params.eye,num_noeyes*n);
    
    for i = 1:n
        lx = ceil(eyepos(i,1)); ly = ceil(eyepos(i,2)); 
        rx = ceil(eyepos(i,3)); ry = ceil(eyepos(i,4));
        im = images(:,:,i);
        
        half_d = ceil(0.5*(lx-rx)/2); % half eyes distances
        ly_ul = ceil(ly-half_d); lx_ul = ceil(lx-half_d);
        ry_ul = ceil(ry-half_d); rx_ul = ceil(rx-half_d);
        
        % left eye
        eyes(:,:,2*i-1) = imresize(getEye(im,ly_ul,lx_ul,half_d*2,half_d*2,params), ...
                            [params.eye,params.eye]);
        
        % right eye
        eyes(:,:,2*i)   = imresize(getEye(im,ry_ul,rx_ul,half_d*2,half_d*2,params), ...
                            [params.eye,params.eye]); 
           
        for j = 1:num_noeyes
            y = randi(params.face-half_d*2);
            x = randi(params.face-half_d*2);
            overlaps = 0;
            while isOverlapping(y,x,ly_ul,lx_ul,half_d) || ...
                  isOverlapping(y,x,ry_ul,rx_ul,half_d)
                y = randi(params.face-half_d*2);
                x = randi(params.face-half_d*2);
                overlaps = overlaps + 1;
                if overlaps == params.face
                    critical_dist = critical_dist - 1;
                    overlaps = params.face - 1;
                end
            end
            noeyes(:,:,(i-1)*num_noeyes+j) = ...
                imresize(getEye(im,y,x,half_d*2,half_d*2,params),...
                    [params.eye,params.eye]);
        end
    end
	
    function [subim] = getEye(im,y_ul,x_ul,w,h,dims)
        ys = y_ul:y_ul+h; ys(ys < 1) = []; ys(ys > dims.face) = [];
        xs = x_ul:x_ul+w; xs(xs < 1) = []; xs(xs > dims.face) = [];
        subim = im(ys,xs);
    end

    function [inside] = isOverlapping(y,x,y_ul,x_ul,critical_dist)
        dist = pdist2([y,x],[y_ul,x_ul]);
        inside = dist < critical_dist;
    end
end

