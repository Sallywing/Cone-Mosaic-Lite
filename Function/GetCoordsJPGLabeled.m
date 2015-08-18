function [rr,N,Area,Density,imsize]=GetCoordsJPGLabeled(imag,thresholdraw,thresholdfilt,sizecell,sigma,micronsperpixel)
% Created by Norberto M. Grzywacz
% Modified by Wan-Qing Yu

% For Divya's files (the first three above)
% Roughly 800 pixels = 100 micrometers
% Roughly 1 pixel = .125 micrometer

% This function gets an jpeg image with cells labeled by hand and returns their
% coordinates.  The jpeg file must RGB.
% imag = a string with the name of the image.  Don't forget to include its path.
% thresholdraw is where we cut the cells from the background.
% Thresholdfilt is where we cut after convolving with a Gaussian.  This
% threshold is important to eliminate spurious background signals, which
% get weakened by Gaussian convolution.
% rr = is a column vector with length = twice the number of cells (N).  The
% first N components are horizontal and the second, vertical.
% The image is convolved with a Gaussian filter of sizecell and sigma. Sizecell
% should be odd and sigma should be small.  The idea is to transform a
% potential white dot with something that has a peak.
% micronsperpixel is the number of micrometers per pixel.  We chose this
% callibration, as two images of a certain size can have different number of pixels.  
% This information can be obtained in Photoshop. 
% When we run the code, we must make sure that all dots (white) in Fig. 1 appear
% in Fig. 2 (Gaussian) and that every Gaussian is painted with one or two
% black dots (the coordinates of the estimated cell centers).
% For Divya's data, size = 39, sigma = 7.
% For Eun Jin's data, size = 13, sigma = 2.3.  (Sigma is roughly the size
% of an isolated cells)
% The file prints the number of cells (N), the Area (in mm^2), and the density
% in number of cells per mm^2.

im = imread(imag,'jpg'); % Read the image.
figure(1);imagesc(im);
imsize = size(im);
if  length(imsize) == 3
imgray=im(:,:,1)+im(:,:,2)+im(:,:,3);
else
    imgray = im*3;
end
imthr=imgray>=thresholdraw;
ImageSize = size(imthr),
GaussianFilter2D2D = GaussFilter2D2D(sizecell,sigma);
imfilt=filter2(GaussianFilter2D2D,imthr);
figure(2);imagesc(imfilt);
% imfilt=imfilt.*(imfilt>=thresholdfilt);
imfilt=imfilt.*(1+.001*rand(size(imfilt))).*(imfilt>=thresholdfilt); % The noise here is much smaller than the signal and serves to break up ties.
M=floor(sizecell/4); % The idea is to find maxima in regions that are almost the radius of the cell.
locmax=ones(size(imfilt));
for i = -M:M
    for j = -M:M
        if ~(i==0 & j==0)
            ii=i;jj=j;% Use this if the simulation is going too slow and
            % you want to see where you're.
            locmax=locmax & imfilt>circshift(imfilt,[i j]);
        end
    end
end

[i,j]=find(locmax);
rr=[j;i];
N=length(i),
Area=ImageSize(1)*ImageSize(2)*micronsperpixel^2/1000000,
Density=N/Area,

% The following lines help convince us that all the dots are being
% localized and only them.
figure(3);imagesc(imfilt);
hold on;
plot(rr(1:N),rr(N+1:2*N),'k.'); % Paint the cell center in black.
hold off;
