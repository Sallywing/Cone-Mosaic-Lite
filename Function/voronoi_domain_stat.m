function voArea = voronoi_domain_stat(r, limX, limY, scale, fig)
%% Voronoi domain area
% r: [x,y]
% scale: unit mm/pixel
% fig: plot VD if 1
% created by Wan-Qing Yu

% Voronoi domain statistics
if fig == 1
    figure;
    voronoi(r(:,1), r(:,2)); % figure
end
[V,C] = voronoin(r);
xlim([limX(1) limX(2)]);
ylim([limY(1) limY(2)]);

%%
delInd = find((V(:,1)>limX(2))+(V(:,1)<limX(1))+(V(:,2)>limY(2))+(V(:,2)<limY(1)));

k = 1;
for i = 1:length(C)
    m = 0;
    for j = 1:length(C{i})
        if ~isempty(find(delInd == C{i}(j)))
            m = m+1;
        end
    end
    if m == 0
        voArea(k) = polyarea(V(C{i},1), V(C{i},2));
        k = k+1;
    end
end

voArea = voArea*scale^2*10^6; %um^2
if fig == 1
    figure;
    hist(voArea);
    xlabel(['Voronoi Domain area (\mum^2)']);
    ylabel(['Frenquency (%)']);
end
end