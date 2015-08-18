function [dvx,dvy,rix,riy,dxx,dxy,dyx,dyy]=DiffVecs(ri,N)

% This function calculates the horizontal (dvx) and vertical (dvy) difference vectors between pairs of positions in
% ri.  ri is a column vector of length 2*N.  The vector first contains 
% the horizontal positions and then the vertical positions.  
% The outputs rrx and rry are NxN matrices.
% The convention is that component ij (column i, row j) of the matrix is pointing from
% position i to position j.

rix=ri(1:N); % Horizontal components of positions.
riy=ri(N+1:2*N); % Vertical components of positions.
dxx = ones(N,1)*rix'; % Repeating the horizontal components as N rows.
dxy = rix*ones(1,N); % Repeating the horizontal components as N columns.
dyx = ones(N,1)*riy'; % Repeating the vertical components as N rows.
dyy = riy*ones(1,N); % Repeating the vertical components as N columns.
dvx = dxx-dxy; % Horizontal vector components in a square matrix.
dvy = dyx-dyy; % Vertical vector components in a square matrix.
