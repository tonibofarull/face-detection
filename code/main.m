%% Parameters

rng(44);
path_eyes = '..\data\BioID-FaceDatabase-V1.2\';

params = struct(        ... 
    'width',	384,	... % images width
    'height',	286,	... % images height
    ...
    'face',     64,     ... % face size: face x face
    'eye',      32,     ... % eye size: eye x eye
    ...
    'size_f',   32,     ... % hog/lbp size: size_f x size_f
    ...
    'features', 0       ... % 1 -> HOG | 2 -> LBP | 0 -> all
);

%% Reading data

disp('-> Reading information ...')
tic

[eyepos,images,looking] = readData(path_eyes,params);

toc
disp('done.')

%% Generating data for trainig

disp('-> Generating information for training ...')
tic

noFacesPerFace = 20; % for each face
noEyesPerEye = 40; % for each eye

[faces,nofaces,eyepos_m] = getFaces(images,eyepos,noFacesPerFace,params);
[eyes,noeyes] = getEyes(faces,eyepos_m,noEyesPerEye,params);
toc

disp('done.')

%% Getting features for SVM

disp('-> Getting features SVM ...')
tic

% faces
num_faces = length(faces); num_nofaces = length(nofaces);
trainLabelFace = ones(num_faces+num_nofaces,1); 
trainLabelFace(num_faces+1:end,1) = -1;
trainFeatureFace  = [getFeatures(faces,params); getFeatures(nofaces,params)];

% eyes
num_eyes = length(eyes); nun_noeyes = length(noeyes);
trainLabelEye = ones(num_eyes+nun_noeyes,1); 
trainLabelEye(num_eyes+1:end,1) = -1;

eyesF = getFeatures(eyes,params);
trainFeatureEye = [eyesF; getFeatures(noeyes,params)];

% looking
trainLabelLook = [looking, looking]';
trainLabelLook = trainLabelLook(:);
trainFeatureLook = eyesF;

toc
disp('done.')

%% Testing

disp('-> Testing SVM ...')
tic

k = 10;
prop = 0.9;

% [recall,precision]

[recall_face,precision_face] = ...
    testing(trainFeatureFace,trainLabelFace,num_faces,k,prop,'Face')

[recall_eyes,precision_eyes] = ...
    testing(trainFeatureEye,trainLabelEye,num_eyes,k,prop,'Eyes')

[recall_look,precision_look] = ...
    testing(trainFeatureLook,trainLabelLook,num_eyes,k,prop,'Look')

toc
disp('done.')

%% Execution

disp('-> Training SVM ...')
tic

predictor_face = fitcsvm(trainFeatureFace,trainLabelFace,'ClassName',[-1,1]);
save predictor_face predictor_face

predictor_eye = fitcsvm(trainFeatureEye,trainLabelEye,'ClassName',[-1,1]);
save predictor_eye predictor_eye

predictor_look = fitcsvm(trainFeatureLook,trainLabelLook,'ClassName',[-1,1]);
save predictor_look predictor_look

toc
disp('done.')

%% Test a single image

disp('-> Test a single image ...')
tic

facedetection(predictor_face,predictor_eye,predictor_look,params);

toc
disp('done.')

