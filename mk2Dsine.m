function I = mk2Dsine(N,KX,KY)
%  I = mk2Dsine(N,KX,KY);
%
%  This program displays a 2D sine wave sin( 2pi/N (KX x + KY y)).
%  where x,y are in 0,1,..N-1.
%

%display('arguments should be (N,KX,KY)');
if nargin < 3
  return;
end

%  Assumes KX and KY are in -N+1,...,N-1

if KX < 0
    KX = N+KX;
end
if KY < 0
    KY = N+KY;
end

%  Here I compute the sine by making a pair of delta functions
%  in the frequency domain and then taking the inverse Fourier transform.

Ihat = zeros(N,N);

%  MATLAB indexes the matrix I(x,y) using indices from 1 to N, 
%  whereas the Fourier transform indexes from 0 to N-1.   
%  This is the reason why we add 1 to the indices when 
%  computing the x,y coordinates in Ihat() below.

Ihat(KX+1,KY+1) = - 1i/2*N*N;   % Matlab prefers 1i for "i" (easier to debug)

%  Make sure the conjugacy property is satisfied....

if KX > 0 && KY > 0
  Ihat(N+1-KX,N+1-KY) = 1i/2*N*N;
elseif KX == 0  && KY ~= 0 
  Ihat(1,N+1-KY) = 1i/2*N*N;
elseif KX ~= 0  && KY == 0 
  Ihat(N+1-KX,1) = 1i/2*N*N;
end

% Take the real part.  
% There is a small imaginary part which is due to finite precision when taking fft.

I =  real(ifft2(Ihat));

if (0)
    imagesc(I)
    colormap('gray')
    axis('square')
    xlabel('Y (second coordinate i.e. row)')
    ylabel('X (first  coordinate i.e. column)')
end

