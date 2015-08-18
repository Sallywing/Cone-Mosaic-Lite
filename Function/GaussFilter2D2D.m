function GaussianFilter2D2D = GaussFilter2D2D(size,sigma)
% GaussianFilter2D2D = GaussFilter2D2D(9,1.6);

% This function outputs a size by size normalized Gaussian filter with standard deviation sigma.

vec = 1:size;
vec = vec - (size+1)/2;
vecx=ones(size,1)*vec; % Horizontal positions (in pixels)
vecy=vecx'; % Vertical positions (in pixels)
GaussianFilter2D2D = exp(-(vecx.^2+vecy.^2)/(2*sigma^2))/(2*pi*sigma^2); % Gaussian filter
