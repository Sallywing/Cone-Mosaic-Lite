function dd=Dists(drxx,drxy,dryx,dryy,N)

% This function calculates all the distances between pairs of positions in
% ri.  ri is a column vector of length 2*N.  The vector first contains 
% the horizontal positions and then the vertical positions.
% The diagonal is set to 1 to avoid zeros in later checks.

dd = eye(N)+sqrt((drxx-drxy).^2+(dryx-dryy).^2); % Distances in a square matrix.
