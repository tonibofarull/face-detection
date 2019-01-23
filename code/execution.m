function [R] = execution(I,pred_face,pred_eye,pred_look,params)
    R = I;
    if size(I,3) == 1
       R = cat(3,I,I,I); 
    else
       I = rgb2gray(I); 
    end
    pixel_step = 2;
    [sizey,sizex] = size(I);
    fx = 0; fy = 0;
    fw = 0; fh = 0;
    fscore = -1;
    for scale = 1:2
        w = 128+(scale-1)*20; h = floor(w*1.2); % ## FACE WINDOWS ##
        for i = 1:pixel_step:sizey-h
           for j = 1:pixel_step:sizex-w
               M = I(i:i+h-1,j:j+w-1);
               features = getFeatures(M,params);
               [l,score] = predict(pred_face,features);
               scorep = score(2);
               if l == 1 && fscore < scorep 
                   fscore = scorep;
                   fx = j; fy = i;
                   fw = w; fh = h;
               end
           end
        end
    end
    if fscore == -1
       return 
    end

    lx = 0; ly = 0; rx = 0; ry = 0; % position of eye
    lscore = -1; rscore = -1; % maximum score
    llook = 0; rlook = 0;
    lr = 0; rr = 0; % radio of left and right eye
    for ws = [32,48] % ## EYE WINDOWS ##
        for i = fy:pixel_step:fy+fw
            for j = fx:pixel_step:fx+fw
                M = I(i:i+ws-1,j:j+ws-1);
                features = getFeatures(M,params);
                [l,score] = predict(pred_eye,features);
                scorep = score(2); % positive
                if l == 1
                    newx = j;
                    newy = i;
                    if lscore < rscore && lscore < scorep && ...
                            (rscore == -1 || pdist2([newx,newy],[rx,ry]) > ws/2)
                        [lookyes,~] = predict(pred_look,features);
                        llook = lookyes;
                        lscore = scorep;
                        lr = ws;
                        lx = newx;
                        ly = newy;
                    elseif rscore < scorep && ...
                            (lscore == -1 || pdist2([newx,newy],[lx,ly]) > ws/2)
                        [lookyes,~] = predict(pred_look,features);
                        rlook = lookyes;
                        rscore = scorep;
                        rr = ws;
                        rx = newx;
                        ry = newy;
                    end
                end
            end
        end
    end
    R = uint8(insertShape(uint8(R),'Rectangle',[fx fy fw fh],'Color','yellow'));
    R = uint8(insertShape(uint8(R),'Rectangle',[lx ly lr lr],'Color','green'));
    R = uint8(insertShape(uint8(R),'Rectangle',[rx ry rr rr],'Color','red'));
    looking = llook + rlook >= 0;
    if looking
    	R = insertText(R,[1 1],'LOOKING',...
                'TextColor','green','BoxColor','black','FontSize',20);
    else
    	R = insertText(R,[1 1],'NOT LOOKING',...
                'TextColor','red','BoxColor','black','FontSize',20);
    end
end

