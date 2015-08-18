clear
close all
clc

filename = 'RP';
fid = fopen([filename '.txt'],'w');
figureFolder = cd;

figureName{1} = '/P25RP-4a';
figureName{2} = '/P25RP-5a';

% type = 'Normal';
dim = [3252,3248;3304,3288];
Scale_bar = 2000./sum(dim,2);
Scale = [1 2];
nbins = 20,

vat = [];
for i = 1:length(figureName)
    figurePath = [figureFolder,figureName{i}];
    [rrt{i},N(i),Area(i),density(i)]=GetCoordsJPGLabeled(figurePath,255,0.5,19,2.5,Scale_bar(Scale(i)));
    [NeighData{i},RegIndex(i)]=NearNeighborsStats(rrt{i},N(i),nbins,Scale_bar(Scale(i)),25,9);
    VDarea{i} = voronoi_domain_stat([rrt{i}(1:length(rrt{i})/2),rrt{i}(length(rrt{i})/2+1:end)], [0 dim(i,1)], [0 dim(i,2)], Scale_bar(Scale(i))*1e-3, 0);
    vat = [vat VDarea{i}];
    CC(i) = locCV(rrt{i}(1:N(i)),rrt{i}(N(i)+1:end),Scale_bar(Scale(i)));
    fprintf(fid, '%s\n', figureName{i});
    fprintf(fid, 'N = %d\n', N(i));
    fprintf(fid, 'ND = %2.3f\n',mean(NeighData{i}));
    fprintf(fid, 'SD = %2.3f\n', std(NeighData{i}));
    fprintf(fid, 'RI = %2.3f\n', RegIndex(i));
    fprintf(fid, 'Area = %1.3f\n', Area(i));
    fprintf(fid, 'density = %.3e\n', density(i));
end

StatN = [mean(N),std(N)/sqrt(length(N))];
StatDen = [mean(density),std(density)/sqrt(length(density))];
% close all

% plotting figures
[mNDRP, IndexRP] = ave_NearNeighborStats(rrt,N,nbins, 40, Scale_bar(Scale), 9,filename);

h2 = figure;
[ndd,xoutd] = hist(vat, 10:20:800);
bar(xoutd,ndd/sum(N)*100,'EdgeColor','k','FaceColor','none','linewidth',2);
hold on;
set(gca,'FontWeight','Bold','FontSize',22,...
    'FontName','Arial','LineWidth',3, 'box', 'off', 'TickDir', 'out');
xlabel('Voronoi Domain Area (\mum^2)');
ylabel('Percentage of Cells');
title(filename,'FontSize',26,'FontName','Arial','FontWeight','bold');
saveas(h2,[filename '_aveVAhist_' num2str(i) 'Samples'],'fig');
saveas(h2,[filename '_aveVAhist_' num2str(i) 'Samples'],'jpeg');

save(filename, 'rrt', 'N', 'StatN', 'StatDen','Area','density','figureName','mNDRP','IndexRP','dim','Scale_bar', 'CC','VDarea');