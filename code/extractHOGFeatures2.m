function [H] = extractHOGFeatures2(Im)
    win_x = 8;
    win_y = 8;
    nbins = 9;

    [F,C] = size(Im);

    H = zeros(1,win_x*win_y*nbins);

    Im = double(Im);
    step_x = floor(C/(win_x+1));
    step_y = floor(F/(win_y+1));

    i = 0;
    Hx = [-1,0,1];
    Hy = -Hx';

    grad_x = imfilter(double(Im),Hx);
    grad_y = imfilter(double(Im),Hy);

    ang = atan2(grad_y,grad_x);
    mag = ((grad_y.^2)+(grad_x.^2)).^.5;

    for n = 0:win_y-1
        for m = 0:win_x-1
            i = i+1;
            int1 = n*step_y+1:(n+2)*step_y;
            int2 = m*step_x+1:(m+2)*step_x;
            angles2 = ang(int1,int2); 
            magnit2 = mag(int1,int2);
            vector_ang = angles2(:);    
            vector_mag = magnit2(:);
            K = max(size(vector_ang));

            bin = 0;
            H2 = zeros(1,nbins);
            for ang_limit = -pi+2*pi/nbins:2*pi/nbins:pi
                bin = bin+1;
                for k = 1:K
                    if vector_ang(k) < ang_limit
                        vector_ang(k) = Inf;
                        H2(bin) = H2(bin) + vector_mag(k);
                    end
                end
            end
            H2 = H2/(norm(H2)+0.01);        
            H((i-1)*nbins+1:i*nbins) = H2;
        end
    end
end
