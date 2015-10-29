function [ subsampleI ] = subSampleImage(I, step)
%  [ subsampleI ] = subSampleImage(I, step)
%
% This function takes an image of size numRows x numCols, 
% and subsamples to give an image of size 
% (numRows/step, numCols/step)
% Before subsampling, it blurs the image with a 2D Gaussian  
% G(x,y,sigma) where sigma = step.  This reduces "aliasing"
% effects.

 sizeI = size(I);
 numRows = sizeI(1);
 numCols = sizeI(2);
 if (0)
    gaussian = make2DGaussian(step);
    blurredI =  conv2( double(I), gaussian, 'same');
    subsampleI = uint8(floor(blurredI(1:step:numRows,1:step:numCols)));
 else
    subsampleI = I(1:step:numRows,1:step:numCols); 
 end

