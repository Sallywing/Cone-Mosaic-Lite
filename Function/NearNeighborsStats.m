function [NeighData,RegIndex]=NearNeighborsStats(rr,N,nbins,Scale,Maxx,Fign)
% [NeighData,RegIndex]=NearNeighborsStats(rr,N,20,.125,25,9); % Normal Divya

% This function gets the positions of N cells in vector rr and calculates
% the histogram of near-neighbor distances.
% nbins is the number of bins.
% RegIndex is the Regularity Index, i.e., the inverse of the coefficient of variation of the near neighbor distances.
% Scale = micrometers per pixel.
% In Divya's data, roughly 800 pixels = 100 micrometers
% Roughly 1 pixel = .125 micrometer
% The red line in the plot is the fit of the salt-and-pepper model: 
% P(r)=2*pi*r*rho*exp(-pi*rho*r^2), where rho is density
% mean = 1/(2*sqrt(rho)) 
% std = sqrt((1/pi-1/4)/rho)
% Regularity index = mean/std = sqrt(pi/(4*pi))=1.91
% Because of this plot, we set the largest value of x in the histogram to
% Maxx.
% The plot is placed in Figure(Fign);

% We can these next two lines to get statistics on the index of regularity.
% Choosing the first line estimates RI for the first half of the data.
% Choosing the second line estimates RI for the second half of the data.
% Commenting out the lines uses all the data at once.
    % N=N/2;rr=[rr(1:N);rr(2*N+1:3*N)];
    % N=N/2;rr=[rr(N+1:2*N);rr(3*N+1:4*N)];
% Created by Norberto M. Grzywacz
% Modified by Wan-Qing Yu
    
[uvx,uvy,rrx,rry,drxx,drxy,dryx,dryy]=DiffVecs(rr,N); % Difference vectors from position ri (column) to position rj (row).
dd=Dists(drxx,drxy,dryx,dryy,N); % Matrix of distances.
dd=dd+10^300*eye(N); % Matrix of distances, avoiding zeros at the diagonal.

NeighData = min(dd); % The near-neighbor distances.

% Next we remove outliers from the data
MedND = median(NeighData);
MADND = median(abs(NeighData-MedND));
OutND = (NeighData - MedND)/MADND < 5;
IndND = find(OutND);
NeighData=NeighData(IndND);

MNeigh = max(NeighData);
dx = MNeigh/nbins;

x=Scale*(dx:dx:Maxx/Scale-dx);
NeighData=Scale*NeighData;

figure(Fign); % The figure containing the distribution of nearest-neighbor distances.
freq=hist(NeighData,x);
Total=sum(freq)*dx*Scale;
hist(NeighData,x);
RegIndex = mean(NeighData)/std(NeighData),
hold on;
meanN = mean(NeighData),
rho = 1/(2*meanN)^2;
Model =Total*(2*pi*rho*x.*exp(-(pi*rho*x.^2)));
plot(x,Model,'-k');
hold off;
