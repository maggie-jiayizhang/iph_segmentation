# iph_segmentation

This is an image segmentation project with neural-net designed to differentiate IPH (intra-pillow-hyroclastic lava) on a field image. The downstream of this pipeline (not currently in the folder) is analysis + calculation of %IPH and permeability feature of the basalt (read more about why %IPH is important to the estimation of basalt permeability: [Fisher 1998](https://agupubs.onlinelibrary.wiley.com/doi/pdf/10.1029/97RG02916), [Gills & Sap 1997](https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/96JB03909)). The code of the pipeline is based on the [semantic segmentation example](https://www.mathworks.com/help/vision/examples/semantic-segmentation-using-deep-learning.html) provided by Matlab.

The existing methods of annotating IPH on field images requires arduous manual labour. The annotations are also influenced by skechers' fatigue & experience. An automated pipeline can speed up the process and will perform consistently through time and samples. Therefore, this pipeline will be a useful tool to geologists who are interested in estimating permeability of rocks. This is very much a *basic, skeletal* draft of the pipeline, which can hopefully serve as an inspiration to future projects.

by Maggie Zhang, MGRGX20; Supervisor: Professor Lisa Gilbert, Williams-Mystic

**LANGUAGE**: MATLAB

**KEY WORDS**: Semantic segmentation, pillow lava, intra-pillow-hyroclastic (IPH), geoscience

## Description of model
The model used is based on DeepLab3 with resnet18. Input layer is 600x600x3 (600x600 pixels RGB image).

## Usage
Before running the main pipeline, unzip labels.zip and images.zip *(alternatively, use the commands written in main.m to unzip)*. Then run the pipeline with command $main in the Matlab window.

*Important Note*: Matlab tends to freeze on the training step. you could run the *SETTING-UP DATASETS* steps first to check if folders/the directory is set up properly.

## Directory Description
**Data**
- images.zip
- labels.zip

**Preping Data**
- preprocess.m: preprocesses the original image (raw_1.png) into 600x600
- partition_data.m: cuts an input image into specified dimensions
- anno2label.m: turns annotation to labeling mask. It is to be used after preprocessing the annotated image into 600x600 sub-images

**Pipeline**
- main.m: defines the main pipeline
- color_map.m: corresponds to *camvidColorMap* in the Matlab example
- label_colorbar.m: corresponds to *pixelLabelColorbar* in the Matlab example
- pixel_label_ids.m: corresponds to *camvidPixelIDs* in the Matlab example
- visualize.m: visualizes the test result on a specified image

**Other**
- README
- raw_1.png
- pro_1.png: manual annotation of IPH on raw_1.png
- wholeMapSketch-withLiDAR.psd: psd version of the photos + sketch

## Notes
1. Currently the data set is really limited. It would be amazing if you have a collection of field images (on IPH/pillow lava) that can be added towards the training set. Please contact the author if you are interested in collaboration.
2. Neural-networks have many dials to turn and moving parts to tweak. The other direction to further this project is to adjust the network for this specific task.
3. For Mac users: a *_MACOSX* folder might be created after unzipping with commands. You can manually delete it or manually unzip the files (which wouldn't create this folder) to get rid of it.
