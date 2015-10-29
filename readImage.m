%  read in an image and crop out the top left NxN part, where N is 
%  the largest power of 2 possible that fits into the image.

IName = 'stones.jpg';
Iread = imread(IName);
%Iread = squeeze( (Iread(:,:,1) + Iread(:,:,2) + Iread(:,:,3))/3 );
Iread = squeeze( Iread(:,:,1) );

sizeI = size(Iread);
N = power(2, floor(log2( min(sizeI(1),sizeI(2)))) );
I = Iread(1:N, 1:N);

if (N > 512)   %  N is already a power of 2    
    I = double(subSampleImage( I , N/512));   % subsample it down to 512x512
    N = 512;
end
    
%I = I(1:N,1:N);   %  assumes image is at least this big