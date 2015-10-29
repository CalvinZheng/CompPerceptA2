%  Assignment 2  COMP 546/598  Fall 2015
%
%  Create a simple random dot stereogram with left and right images
%  Ileft and Iright.  Filter the stereo pair with a family of 
%  binocular complex Gabors.  

clear all
close all
N = 256;
disparity = 4;

%  Make a random dot stereogram with a central square protruding from a 
%  plane.  The plane has disparity = 0.  The central square has positive
%  disparity.

Ileft = rand(N,N);
Iright = Ileft;
Iright(N/4:3*N/4, N/4:3*N/4) = Ileft(N/4:3*N/4, N/4  + disparity: ...
        3*N/4 + disparity);
Iright(N/4:3*N/4, 3*N/4+1:3*N/4+disparity) = rand(N/2+1, disparity);

%figure
I = zeros(N,N,3);
I(:,:,1) = Ileft;  % red
I(:,:,2) = Iright; %  cyan
I(:,:,3) = Iright;  % cyan

%image(I);
%title(['disparity is ' num2str(disparity)  ' pixels'])
%axis square
%axis off

%  Here we want the left and right Gabor cells to be shifted relative 
%  to each other.   If the shift is 0, then the cell is tuned to 0 
%  disparity as was the case looked at in the lecture.  If you want 
%  a different disparity then you need to shift by some other amount
%  which I am calling d_Gabor.
%
%  The binocular cell's response at (x,y) is the amplitude of the sum 
%  of responses of the left and right images Gabor cell.   To compute 
%  the binocular response, convolve the left image and right image 
%  complex GaborS.    To have a binocular cell that has a preferred 
%  disparity,  we need to shift the cell in one of the images.
%  Equivalently, we can shift the image (in the opposite direction) and
%  keep the cell position fixed.  The code below does the latter, which
%  is easier to deal with because then the corresponding left and right
%  cells are aligned.

M = 32;   % window width on which Gabor is defined
k = 2;    % frequency
%  wavelength of underlying sinusoid is M/k pixels per cycle.

[cosGabor sinGabor] = make2DGabor(M,0,k);
Gabor = cosGabor + 1i * sinGabor;
 
%  Subtract the mean intensity from the image because a cos Gabor 
%  in fact has a response to the mean intensity 
%  i.e.  (F cosGabor)(k) ~= 0  for k=0.     

Ileft  = Ileft - mean(Ileft(:));
Iright = Iright - mean(Iright(:));

responses = zeros(N,N,9);

%  disparity of Gabors are tuned for  {-8,-7,...7,8}
numdisparities = 17;   %  from -8 to 8

dGabor = zeros(numdisparities,1);
meanResponseCenter = zeros(numdisparities,1);
meanResponseSurround = zeros(numdisparities,1);
centerMask = zeros(N,N);
centerMask(N/4:3*N/4, N/4:3*N/4) = 1;

for j = 1:numdisparities
    d_Gabor = j- (numdisparities+1)/2 ;   
    responses(:,:,j) = ...
        abs( circshift( conv2( Ileft, Gabor, 'same' ), [0 -d_Gabor])  ...
                         + conv2( Iright, Gabor , 'same')) ;
    dGabor(j) = d_Gabor;
    meanResponseCenter(j) = mean2(responses(:,:,j)*centerMask)*4;
    meanResponseSurround(j) = mean2(responses(:,:,j)*~centerMask)/3*4;
end

figure
subplot(1,2,1);
plot(dGabor,meanResponseCenter,dGabor,meanResponseSurround);
axis square
legend('center', 'surrounding');
title(['M=' num2str(M)]);

M = 64;

[cosGabor sinGabor] = make2DGabor(M,0,k);
Gabor = cosGabor + 1i * sinGabor;

for j = 1:numdisparities
    d_Gabor = j- (numdisparities+1)/2 ;   
    responses(:,:,j) = ...
        abs( circshift( conv2( Ileft, Gabor, 'same' ), [0 -d_Gabor])  ...
                         + conv2( Iright, Gabor , 'same')) ;
    dGabor(j) = d_Gabor;
    meanResponseCenter(j) = mean2(responses(:,:,j)*centerMask)*4;
    meanResponseSurround(j) = mean2(responses(:,:,j)*~centerMask)/3*4;
end

subplot(1,2,2);
plot(dGabor,meanResponseCenter,dGabor,meanResponseSurround);
axis square
legend('center', 'surrounding');
title(['M=' num2str(M)]);

%  The images has now been filtered using a family of binocular complex
%  Gabor cells.  Each family has particular peak disparity to which
%  it is sensitive.    To plot the responses in a way that allows us
%  us to compare their magnitudes, we normalize by the largest response
%  of all of the "cells".  

figure
maxResponse = max( responses(:) );

for j = 1:numdisparities
    d_Gabor = j - 1;
    responses(:,:,j) = responses(:,:,j)/maxResponse; 
    if mod(j, 2) == 1
        subplot(3,3,(j+1)/2);
        subimage(squeeze(responses(:,:,j)));
        title( ['Gabor tuned to d=' num2str(d_Gabor-8)  ] );
        axis off
    end
end


