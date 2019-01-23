function [features] = getFeatures(samples,params)
    n = length(samples);
    if length(size(samples)) == 2
        n = 1;
    end
    % test length to allocate mem
    len_hog = length(getHOG(zeros(params.size_f,params.size_f)));
    len_lbp = length(getLBP(zeros(params.size_f,params.size_f)));
    
    if params.features == 1
        len = len_hog;
    elseif params.features == 2
        len = len_lbp;
    else
        len = len_hog + len_lbp;
    end
    
    features = zeros(n,len);
    
    for i = 1:n
        if params.features == 1
            features(i,:) = getHOG(imresize(samples(:,:,i), ...
                [params.size_f,params.size_f]));
        elseif params.features == 2
            features(i,:) = getLBP(imresize(samples(:,:,i), ...
                [params.size_f,params.size_f]));
        else
            hog = getHOG(imresize(samples(:,:,i), ...
                [params.size_f,params.size_f]));
            lbp = getLBP(imresize(samples(:,:,i), ...
                [params.size_f,params.size_f]));
            features(i,:) = [hog, lbp];
        end
    end
    
    function [hog] = getHOG(im)
        hog = extractHOGFeatures2(im);
    end
    
    function [lbp] = getLBP(im)
        cs = [20 20];
        nn = 8;
        lbp = extractLBPFeatures(uint8(im),'CellSize',cs,'NumNeighbors',nn);
    end
    
end

