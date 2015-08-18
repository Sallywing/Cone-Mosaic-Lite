function [mND, Index] = ave_NearNeighborStats(rrt,Nt,nbins, Maxx, Scale, Fign,figname)
%% average NN stats for a group
% Created by Wan-Qing Yu

No = length(rrt);
NeighData = [];
for i = 1:No
    [ND{i},Index(i)] = NearNeighborsStats(rrt{i},Nt(i),nbins,Scale(i),Maxx,i);
    mND(i) = mean(ND{i});
    NeighData = cat(2,NeighData, ND{i});
end

MNeigh = max(NeighData)/median(Scale);
dx = MNeigh/nbins;
x=median(Scale)*(dx:dx:Maxx/median(Scale)-dx);
figure(Fign); % The figure containing the distribution of nearest-neighbor distances.
freq=hist(NeighData,x);
Total=sum(freq)*dx*median(Scale)/length(Nt);
w = hist(NeighData,x)./length(Nt);
bar(x,w,'EdgeColor','k','FaceColor','none','linewidth',2);
RegIndex = mean(NeighData)/std(NeighData),
hold on;
meanN = mean(NeighData),
SD = std(NeighData),
rho = 1/(2*meanN)^2;
Model =Total*(2*pi*rho*x.*exp(-(pi*rho*x.^2)));
plot(x,Model,'-k','LineWidth',3);
key{1} = ['N = ' num2str(ceil(mean(Nt))) '\pm' num2str(ceil(std(Nt)/sqrt(No)))];
key{2} = ['ND = ' num2str(mean(mND),'%.2f') '\pm' num2str(std(mND)/sqrt(No),'%.2f')];
key{3} = ['RI = ' num2str(mean(Index),'%.2f') '\pm' num2str(std(Index)/sqrt(No),'%.2f')];
text(13,max(w)*0.85,key,'fontsize',24,'FontName','Arial','FontWeight','bold')
set(gca,'FontWeight','bold','FontSize',22,...
    'FontName','Arial','LineWidth',3, 'box', 'off', 'TickDir', 'out');
xlabel(['Nearest-neighbor Distance (\mum)']);
ylabel('Number of Cells');
title(figname,'FontSize',26,'FontName','Arial','FontWeight','bold');
hold off;
saveas(gcf,['TotalNearestNeighborDis_' figname], 'fig');
saveas(gcf,['TotalNearestNeighborDis_' figname], 'jpg');