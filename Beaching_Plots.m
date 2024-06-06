clear all; clc; close all;

path='./';
filename=([path,'Lagrangian_1.hdf5']);
lon_grid = h5read(filename,'/Grid/Longitude');
lat_grid = h5read(filename,'/Grid/Latitude');

addpath('"C:\tESTING_MOHID_simulations\Mohid Simulations-19\res\latandlong.xlsx"');
coast = 'latandlong.xlsx';
A = xlsread(coast);
%load('lat&lon');
clat=A(:,1);  %lat;
clon=A(:,2);  %long;
lonl=[51 85];
latl=[1 25];
[clatc,clonc] = maptrimp(clat,clon,latl,lonl);
[F,V]=poly2fv(clonc,clatc);
% xlim([65 78]);
xlim([64 78]);
ylim([6 25 ]);
axis on
set(gca,'XTick',[65 67 69  71  73  75  77]);
%      set(gca,'YTick',[6 10 15 20 25]);
     set(gca,'YTick',[6 8 10 12 14 16 18 20 22 24]);
     xlabel('Longitude(^{\circ} E)');
     ylabel('Latitude(^{\circ} E)');
     addpath('C:\tESTING_MOHID_simulations\Mohid Simulations-8\res');
     borders('India','facecolor','(0.5 0.5 0.5)')
%        [lat,lon] = borders('India');
      [xlim,ylim] = borders('India');
%        pgon = polyshape(lon,lat,'simplify',false);
      pgon = polyshape(xlim,ylim,'simplify',false);
       
xy=[linspace(73.5,69,23).' linspace(7,20,23).'];
ab=[linspace(75.5,71,23).' linspace(7,20,23).'];
cd=[linspace(74.5,70,23).' linspace(7,20,23).'];

C = cat(1,xy,ab,cd);

%hold on
for i=1:28

Filelat = sprintf('/Results/Group_1/Data_1D/Latitude/Latitude_%05d',i);
Filelon = sprintf('/Results/Group_1/Data_1D/Longitude/Longitude_%05d',i);
Filevol = sprintf('/Results/Group_1/Data_1D/Volume/Volume_%05d',i);
Filebeach=sprintf('/Results/Group_1/Data_1D/Beached/Beached_%05d',i);

path='./'
filename=([path,'Lagrangian_1.hdf5']);
plon2004 = h5read(filename,Filelon);
plat2004 = h5read(filename,Filelat);
vol2004 =  h5read(filename,Filevol);
bch2004 =  h5read(filename,Filebeach);

   
beached_indices = find(bch2004 == 2);
%hold on
plot(plon2004(beached_indices), plat2004(beached_indices), '.', 'MarkerSize',10, 'MarkeredgeColor','r' );
%hold on
end


%joined_table = join(plon2004, plat2004);