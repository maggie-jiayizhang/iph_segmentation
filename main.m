clearvars;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Please take a look at the README file before running the platform.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Based on Deeplab3 example on CamVid Dataset
% https://www.mathworks.com/help/vision/examples/semantic-segmentation-using-deep-learning.html

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% SETTING UP DATASETS %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

outputFolder = pwd;

% Unzip folders.
labels = fullfile(outputFolder,'labels');
images = fullfile(outputFolder,'images');

labelsZip = fullfile(outputFolder,'labelsZip.zip');
imagesZip = fullfile(outputFolder,'imagesZip.zip');

if ~exist(labels, 'file') || ~exist(images, 'file')
    disp('Unzipping labels...');
    unzip(labelsZip);

    disp('Unzipping images...');
    unzip(imagesZip);
end

% Load images
imgDir = fullfile(outputFolder,'images');
imds = imageDatastore(imgDir);

% Display the first image (a test to see if the directory set up is working)
% You can comment this block out in later runs.
I = readimage(imds,1);
I = histeq(I);
imshow(I)

% Load labels
% we only have 2 classes: IPH and non-IPH
classes = [
    "IPH"
    "NonIPH"
    ];

labelIDs = pixel_label_ids();

labelDir = fullfile(outputFolder,'labels');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);

% Example of label masking its corresponding image.
% You can comment this block out in later runs.
C = readimage(pxds,1);
cmap = color_map;
B = labeloverlay(I,C,'ColorMap',cmap);
imshow(B)
label_colorbar(cmap,classes);

% Stat on the distribution of each class.
tbl = countEachLabel(pxds)

% Split data into train, validation, test
[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = partition_data(imds,pxds);
numTrainingImages = numel(imdsTrain.Files)
numValImages = numel(imdsVal.Files)
numTestingImages = numel(imdsTest.Files)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% CREATING THE NETWORK %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Specify the network image size.
imageSize = [600 600 3];

% Specify the number of classes.
numClasses = numel(classes);

% Create DeepLab v3+.
lgraph = deeplabv3plusLayers(imageSize, numClasses, "resnet18");

% Select training options
% Define validation data.
pximdsVal = pixelLabelImageDatastore(imdsVal,pxdsVal);

% Define training options.
options = trainingOptions('sgdm', ...
    'LearnRateSchedule','piecewise',...
    'LearnRateDropPeriod',10,...
    'LearnRateDropFactor',0.1,...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.005, ...
    'ValidationData',pximdsVal,...
    'MaxEpochs',15, ... % defining number of epochs
    'MiniBatchSize',4, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',2,...
    'Plots','training-progress',...
    'ValidationPatience',5);

% Data augmentation
augmenter = imageDataAugmenter('RandXReflection',true,...
    'RandXTranslation',[-10 10],'RandYTranslation',[-10 10]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% START TRAINING %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pximds = pixelLabelImageDatastore(imdsTrain,pxdsTrain, ...
    'DataAugmentation',augmenter);

[net, info] = trainNetwork(pximds,lgraph,options);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TESTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test network on one image (idx=10)
% Note: idx goes from 1-11 (since there are only 11 images in the testing set)
idx = 10;
visualize(idx, net, imdsTest, cmap, classes, pxdsTest)
