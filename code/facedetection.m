function [] = facedetection(predictor_face,predictor_eye,predictor_look,params)
    % Image to identify face, eyes and if is looking
    [filename,pathname] = uigetfile('*.*','Select An Image');
    I = imread(strcat(pathname,filename));

    I = imresize(I,[params.height,params.width]);
    R = execution(I,predictor_face,predictor_eye,predictor_look,params);

    imshow(R,[])
end

