
                         %%%%%% TO CREATE A BATHYMETRY FILE IN MOHID'S FORMAT %%%%%
clear all; close all; clc;

%Read the attributes/variables from .nc file(s)
 ncdisp('bathymetry_2024.nc')
 lat_grid = ncread('bathymetry_2024.nc', 'lat');
 lon_grid = ncread('bathymetry_2024.nc', 'lon');
 depth = ncread('bathymetry_2024.nc', 'elevation');
%  bb=1520;aa=1040;cc=1;
%  bb=153;aa=105;cc=1;
 bb=239;aa=177;cc=5;
 
%Grid size redution
 A=lat_grid(1:19:end,:);
 B=lon_grid(1:19:end,:);
 D=depth(1:19:end,1:19:end);
 

% Specifying dimensions of data points
aaa=num2str(aa-1,'%03d');  
bbb=num2str(bb-1,'%03d');
ccc=num2str(cc,'%03d');

%Data points for MOHID 
chunk_size_2D=[bb-1,aa-1];
chunk_size_3D=[bb-1,aa-1,cc];
start_lon=num2str(B(1,1),'%8f');
start_lat=num2str(A(1,1),'%8f');


% da_lon=permute(A,[2,1]);
% da_lat=permute(B,[2,1]);
% da_depth=permute(D,[2,1]);
% imagesc(A,B,D);

%Create the grid and bathymetry file for MOHID
fid=fopen('bathymetry_0.08_2024.dat','wt');
fprintf(fid,'%s\n','COORD_TIP     : 4');
fprintf(fid,'%s\n',['ILB_IUB       : 1 ',bbb]);
fprintf(fid,'%s\n',['JLB_JUB       : 1 ',aaa]);
fprintf(fid,'%s\n','LATITUDE      : 0');
fprintf(fid,'%s\n','LONGITUDE     : 0');
fprintf(fid,'%s\n','GRID_ANGLE    : 0');
fprintf(fid,'%s',['ORIGIN        : ',start_lon,' ',start_lat]);
fprintf(fid,'%s\n','');
fprintf(fid,'%s','FILL_VALUE    : -99.00');
fprintf(fid,'%s\n','');


%Write grid corners
fprintf(fid,'%s\n','<BeginXX>');

for i=0:aa-1
    dx=(78-64)/(aa-1);
    %dx=(78-65)/(aa-1);
    fprintf(fid,'%f',i*dx);
    fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','<EndXX>');
fprintf(fid,'%s\n','');

fprintf(fid,'%s\n','<BeginYY>');
for j=0:bb-1
    dy=(25-6)/(bb-1);
    %dy=(25-6)/(bb-1);
    fprintf(fid,'%f',j*dy);
    fprintf(fid,'%s\n','');
end
fprintf(fid,'%s\n','<EndYY>');
fprintf(fid,'%s\n','');

%Write depth data and set land points to -99
 DEPTH=(-1*D);
    DEPTH(DEPTH <= 0) = -99;
  mask = DEPTH <= 1000 & DEPTH >= 0;
   DEPTH(mask) = 1010;
%  DEPTH(DEPTH > 0) = 20;

fprintf(fid,'%s\n','<BeginGridData2D>');

for y=1:bb-1;
    for x=1:aa-1;
        fprintf(fid,'%f\n',DEPTH(x,y));
    end;
end;
fprintf(fid,'%s\n','<EndGridData2D>');

fclose(fid);

Max_value = max(DEPTH,[],'all'); 

%surf(Y,X,DEPTH)
contourf(X,Y,DEPTH);
% 
 [X,Y]=meshgrid(A,B);
%  ddd=flip(DEPTH,3);
% axis off
% 
% 
%    set(gca,'XTick',[65 67  69  71  73  75  77]);
%       set(gca,'YTick',[6 9 12 15 18 21 24]);
%      xlabel('Longitude(^{\circ}E)');
%      ylabel('Latitude(^{\circ}N)');
%    hold on


% % patch
%    borders('India','facecolor','blue');
%   borders('India','facecolor','white')
%     [lat,lon] = borders('India');
%      pgon = polyshape(lon,lat,'simplify',false);
%      xlabel Longitude
%      ylabel Latitude
% %     title Arabian sea-Depths
% %     hold on;
% % % % 
% %   X=[65.00208:0.0125:77.9771];
% %   Y=[6.00208:0.0125:24.9771];
% %    axis([min(min(y)) max(max(y)) min(min(x)) max(max(x))]);
%  xlim(65,78);
%  ylim(6,25);
%  axis([min(min(y)) max(max(y)) min(min(x)) max(max(x))]);
 
%Plot 
 imagesc(x,y,DEPTH) 
 camroll(90)
 colormap(jet(256));
 shading faceted
 hold on
 set(gca,'XTick',[65 67  69  71  73  75  77]);
 set(gca,'YTick',[6 9 12 15 18 21 24]);
 
 

% %%%%%%%%%%%%%%%%%%OR%%%%%%%%%%%%%%%%%%%
%Border patch   
   borders('India','facecolor','blue');
   borders('India','facecolor','white','linewidth',3)
   [lat,lon] = borders('India');
   pgon = polyshape(lon,lat,'simplify',false);
   xlabel Longitude
   ylabel Latitude
%      title Arabian sea-Depths
   hold on;
   axis([min(min(X)) max(max(X)) min(min(Y)) max(max(Y))]);

