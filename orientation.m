%  orientation.m
%
%  author:  Michael Langer  COMP 546  2015
%  Assignment 2  Question 1
%
%  This code reads in an image (or synthesizes an image) and analyzes
%  the orientation structure at each pixel.   It uses an HSV coding:
%  hue is peak orientation,  saturation is the dominance within the
%  pixel of the response at the best vs worst orientations.
%  The value is the peak response relative to the largest peak response in
%  the image.

clear;  close all

%  Test code.   
%  Create an image which is an annulus (ring).
%  The orientation detector will annulus from red (at horizontal) 
%  around the hue circle (ROYGBV), back to red (at 180 degrees
%  away, i.e. horizontal again.

if (0)
    readImage  ; 
else
    N = 512;
    I = zeros(N,N);
    minRadius = 110;
    maxRadius = 115;    % thickness = 6
    
    Iannulus = sqrt(power((-N/2:N/2-1)' * ones(1,N),2) + ...
             power(ones(N,1) * (-N/2:N/2-1),2));
    Iannulus = double( (Iannulus >= minRadius) & (Iannulus <= maxRadius) );
    I = Iannulus;
    I(N/2 - maxRadius: N/2 + maxRadius, N/2-1:N/2+1) = 1;  % thickness = 3
    I(N/2-1:N/2+1, N/2 - maxRadius: N/2 + maxRadius) = 1;  
    
end

%  Show the image (or the green channel only, if the image is color)

figure(1); imagesc(I); colormap(gray(256)); axis square % colorbar;

%  Filter the image with N_THETA orientations, 0, 180/N_THETA, 
%  2*(180/N_THETA),  ... (N_THETA-1)*180/N_THETA  degrees.
%
N_THETA = 8;     %  Do not change this

k = 32;     %  peak frequency  

%display(['wavelength is ' num2str(N/k)]);

thetaRange = pi/N_THETA*(0:N_THETA-1);

peakTheta   = zeros(N,N);
maxResponse = zeros(N,N);
minResponse = 10000*ones(N,N);

%  Hint:  I suggest you use the following trick to find the max
%         response (and other required quantities).
%
%     for each theta
%        filter the image with a Gabor tuned to that theta
%  Matlab-->   mask = (filterResponse > maxResponse);
%  Matlab-->   maxResponse = mask .* filterResponse + ~mask .* maxResponse
%     end

%---------------  BEGIN SOLUTION ------------------

figure

axisImage = zeros(N,N);
axisImage(:,N/2) = 255;
axisImage(N/2,:) = 255;

for i = 1:N_THETA
    
    [cosG, sinG] = make2DGabor(N, round(k*cos(thetaRange(i))), round(k*sin(thetaRange(i))));
    
    cosGImage = (cosG/max(cosG(:))+0.5)*255;
    cosGImage = cosGImage(N/2-32:N/2+32,N/2-32:N/2+32);
    cosGImage(N,N) = 0;
    
    gaborAmp = abs(fftshift(fft2(cosG+sinG*1i)));
    gaborAmpImage = gaborAmp/max(gaborAmp(:))*255;
    
    gImage = gaborAmpImage + cosGImage + axisImage;
    
    subplot(2,4,i);
    colormap(gray(256));
    image(gImage);
    axis square
    
    response = abs(ifft2(fft2(fftshift(cosG+sinG*1i)).*fft2(I)));
    
    mask = (response > maxResponse);
    peakTheta = mask * thetaRange(i)/pi*180 + ~mask .* peakTheta;
    maxResponse = mask .* response + ~mask .* maxResponse;
    mask = (response < minResponse);
    minResponse = mask .* response + ~mask .* minResponse;
end

%---------------  END SOLUTION ------------------

figure
%
hsvImage = zeros(N,N,3);
%  hue is orientation
hsvImage(:,:,1) = peakTheta/180;  
%  saturation indicates whether there is a big difference between 
%  max and min
hsvImage(:,:,2) = (maxResponse-minResponse)./(maxResponse + minResponse);  % 
%  value indicates whether the response is large compared to the max
%  response over the image
hsvImage(:,:,3) = maxResponse/max(maxResponse(:));
image(hsv2rgb(hsvImage));
axis square

print('annulusCrossSolution', '-djpeg ')
