function CC = locCV(x,y,scale)
%% Calculating Coefficient of Clustering of a spatial pattern
% x: x coordinates of all points
% y: y coordinates of all points
% scale: um/pixel
% CC: Coeeficient of Clusering defined by = (Global Coefficient of Variance)/mean(LocalCoV);
% Created by Wan-Qing Yu

%% Plot Delaunay Triangulation of cone mosaic
DT = delaunayTriangulation(x,y);
[V,R] = voronoiDiagram(DT);
% triplot(DT(:,:), DT.Points(:,1), DT.Points(:,2));
% figure, voronoi(DT)
%% Plot Convex Hull with DT
k = convexHull(DT); % points consititue of convex hull
xHull = DT.Points(k,1);
yHull = DT.Points(k,2);
% plot(xHull,yHull,'r','LineWidth',2); 

% The convex hull topology duplicates the start
% and end vertex. To remove the duplicate entry:
k(end) = [];

% Now remove the points on the convex hull and their VD
DT.Points(k,:) = [];
R(k,:) = [];
% % Plot the new triangulation
% hold on
% triplot(DT); 
% hold off
k2 = convexHull(DT); k2(end) = [];

[IN ON] = inpolygon(V(:,1),V(:,2),xHull,yHull);
ind = find((IN+ON) == 0);
%% Calculate Global CoV
VD_area = [];
VD_areaD = [];
points = [];
j = 0;
for i = 1:length(R)
    if ~sum(ismember(R{i},ind))
        j = j+1;
        VD_areaD(j) = polyarea(V(R{i},1), V(R{i},2));
    else
        points = [points i];
    end
    VD_area(i) = polyarea(V(R{i},1), V(R{i},2));
end
GCoV = std(VD_areaD)/mean(VD_areaD);

%% Calculate Local CoV
j = 0;
loc_sd = [];
LCoV = [];
for i = 1:length(R)
    if ~ismember(i,k2)
        tmp_nn = unique(DT.ConnectivityList(find(sum(DT.ConnectivityList == i,2)),:));
        if ~sum(ismember(tmp_nn, points))
            j = j+1;
            LCoV(j) = std(VD_area(tmp_nn))/mean(VD_area(tmp_nn));
            loc_sd(j,:) = [polyarea(V(R{i},1), V(R{i},2))*scale^2, std(VD_area(tmp_nn))*scale^2, length(tmp_nn)-1];
        end
    end
end
% figure
% plot((loc_sd(:,1)), (LCoV), '*');
% hold on
% % hist(loc_sd(:,3))
% % figure
% % scatter3(loc_sd(:,1), LCoV, loc_sd(:,3));
% 
% tmpidx = find(loc_sd(:,1) > (median(loc_sd(:,1))+3*mad(loc_sd(:,1))));
% mdl = LinearModel.fit(loc_sd(tmpidx,1),LCoV(tmpidx), 'linear', 'RobustOpt', 'on');
% plot(mdl.Variables(:,1), mdl.Fitted, '-r');
% mdl.Coefficients
% %% scramble the VD
% LCoV_s = [];
% idx = randi(length(LCoV), length(LCoV), round(mean(loc_sd(:,3))));
% for i = 1:length(LCoV)
%     LCoV_s(i) = std([loc_sd(idx(i,:),1);loc_sd(i,1)])/mean([loc_sd(idx(i,:),1);loc_sd(i,1)]);
%     LCoV_swo(i) = std([loc_sd(idx(i,:),1)])/mean([loc_sd(idx(i,:),1)]);
% end
% figure
% plot((loc_sd(:,1)), (LCoV_s), '*');
% hold on
% % figure
% % plot((loc_sd(:,1)), (LCoV_swo), '*');
% 
% tmpidx = find(loc_sd(:,1) > (median(loc_sd(:,1))+3*mad(loc_sd(:,1))));
% mdl_s = LinearModel.fit(loc_sd(tmpidx,1),LCoV_s(tmpidx), 'linear', 'RobustOpt', 'on');
% plot(mdl_s.Variables(:,1), mdl_s.Fitted, '-r');
% mdl_s.Coefficients
%% coefficient of clustering
CC = GCoV/mean(LCoV);

%% 
%plot(loc_sd(loc_sd(:,1) < 0.5e7,1), loc_sd(loc_sd(:,1) < 0.5e7,2), '*');