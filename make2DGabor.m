function [cosGabor sinGabor] = make2DGabor(N,k0,k1)
%
% This function returns a 2D cosine and sine Gabor with standard 
% deviation center frequency (k0,k1) cycles per N samples.   
%
% The Gabor is fftshifted so that their origin is in the middle of the
% 2D matrix.   If you want to filter an image with a Gabor, then you
% need to fftshift the Gabor again, which brings the origin to matrix 
% position (1,1).

%  The sigma of the Gaussian is chosen to be one quarter cycle of the
%  underlying sinusoidal wave.
%  The Fourier transform of a Gaussian with standard deviation sigma
%  is a Gaussian with standard deviation N/(2*pi*sigma).

k =sqrt(k0*k0 + k1*k1);
sigmaX = N/k/2;
sigmaK = N / (2*pi * sigmaX);

%  The bandwidth of a filter is sometimes defined by half height.  
%  However, when the filter has a Gaussian shape in the frequency domain  
%  one often defines the bandwidth by the standard deviation.  
%  Say  k =sqrt(k0*k0 + k1*k1)).   Then the "octavebandwidth"
%  (which is just the log2 of the bandwidth) is:
% 

%display(['octavebandwidth = ',...
%    num2str(log2( (k + sigmaK) / (k - sigmaK) )),' octave']);

if  ((round(k0) ~= k0) || (round(k1) ~= k1))
    display('WARNING:   frequencies are not integers.. rounding');
    k0 = round(k0);
    k1 = round(k1);
end
cos2D = fftshift( mk2Dcosine(N,k0,k1) );
sin2D = fftshift( mk2Dsine(N,k0,k1) );

%  Define the Gabor to be centered at (N/2+1).   
%  This is why you need to fftshift the Gabor if you want to 
%  filter an image with it.

shiftx = ((1:N) - (N/2 + 1));
Gaussian = 1/(sqrt(2*pi)*sigmaX) * ...
    exp(- shiftx.*shiftx/ (2 * sigmaX*sigmaX) );
Gaussian2D = Gaussian' * Gaussian;

cosGabor = Gaussian2D .* cos2D;
sinGabor = Gaussian2D .* sin2D;

