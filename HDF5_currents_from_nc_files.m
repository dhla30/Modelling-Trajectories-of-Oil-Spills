clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%LOOP TO READ TIME FROM MULTPILE FILES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 88888
ncinfo('bathymetry_2024.nc')
depthrs=ncread('bathymetry_2024.nc','elevation');
grid_lon=ncread('bathymetry_2024.nc','lon');
grid_lat=ncread('bathymetry_2024.nc','lat');

% % XX=grid_lon(201:1601,1);
% % YY=grid_lat(201:1601,:);
% % depthrs=depthrs(201:1601,:);
% % depthrs(depthrs==0)=nan;
 xx=grid_lon(1:19:end,:);
 yy=grid_lat(1:19:end,:);
 depthrs=depthrs(1:19:end,1:19:end);
 zz=depthrs;
 depthrs(depthrs==0)=nan;

[XX YY]=meshgrid(double(xx),double(yy));
% 88888888

% dirname='/project/k1254/';
% output_path='/project/k1450/currents_bathymetry_MITgcm/';
dirname= './'
output_path= './'
%%%%%%%%%%%%%create hdf5 current files
dataname=([output_path,'2004_01_to_12_currents_with ones_test.hdf5']);
% dataname=([output_path,'currents_2022.hdf5']);
% delete (dataname)   
fid = H5F.create(dataname);
plist = 'H5P_DEFAULT';
%%%%%%%%%%%%create groups in hdf5 based on the MOHID format
gid = H5G.create(fid,'/Results',plist,plist,plist);
H5G.close(gid);
gid = H5G.create(fid,'/Results/velocity U',plist,plist,plist);
H5G.close(gid);
gid = H5G.create(fid,'/Results/velocity V',plist,plist,plist);
H5G.close(gid);
gid = H5G.create(fid,'/Time',plist,plist,plist);
H5G.close(gid);
H5F.close(fid);

%%%%%%%%%%%%%%write group attitude
fid=(dataname);

h5writeatt(fid,'/Results','Minimum',-5);
h5writeatt(fid,'/Results','Maximum',5);
h5writeatt(fid,'/Results/velocity U','Minimum',-5);
h5writeatt(fid,'/Results/velocity U','Maximum',5);
h5writeatt(fid,'/Results/velocity V','Minimum',-5);
h5writeatt(fid,'/Results/velocity V','Maximum',5);
h5writeatt(fid,'/Time','Minimum',-0.000000);
h5writeatt(fid,'/Time','Maximum',2022.000000);
disp('group created')

% tc=0;
% start_time = 11908800 %0013654080;
% timestep = 960;
% noofsteps=30;
% end_time=start_time+(noofsteps-1)*timestep;
% for i=start_time:timestep:end_time
% tc=tc+1
% num_job=num2str(i,'%10.10d');

tc=0;
% d='01/01/2013';   %MM/DD/YYYY
% start_time=datenum(d);

d='2008-06-01 00:00:00'; % 737669
formatIn = 'yyyy-mm-dd HH:MM:SS';
start_time = datenum(d,formatIn);

noofsteps=3176;
 for i=1:noofsteps
date_str=datestr(start_time+(i-1),'yyyy-mm-dd HH:MM:SS');

ncinfo('200806_currents.nc');
Filename  = sprintf('200806_currents.nc');
disp(Filename);

time=ncread(Filename,'time');
%  base_date=datevec(datenum(1979,1,15,0,0,0)+i*90/86400)     % i is the number in each file name

base_date = ncreadatt(Filename,'time','units');
base_date=[str2num(base_date(13:16)) str2num(base_date(18:19)) str2num(base_date(21:22))...
str2num(base_date(24:25)) str2num(base_date(27:28)) str2num(base_date(30:31))]
daten=datevec(datenum(base_date)+double(time)/double(24));
% date=(base_date)';
% date=(start_time);
%days_range = daten ( 1 : 24 : end , 3 );

% Yp=[5:0.01:25];
% Xp=[68:0.01:75];

%%%% Grid demension Lon=[68 75] lat=[5 25];?

Yp=[6:0.08:25];
Xp=[64:0.08:78];

 [XC YC]=meshgrid(double(Xp),double(Yp));
 
start=[1,1,1,1];
count=[inf,inf,5,inf]
 u=ncread('200806_currents.nc','water_u',start,count);
 v=ncread('200806_currents.nc','water_v',start,count);
 
 un(:,:,1,:)=u(:,:,5,:);
 un(:,:,2,:)=u(:,:,4,:);
 un(:,:,3,:)=u(:,:,3,:);
 un(:,:,4,:)=u(:,:,2,:);
 un(:,:,5,:)=u(:,:,1,:);
% 
  vn(:,:,1,:)=v(:,:,5,:);
  vn(:,:,2,:)=v(:,:,4,:);
  vn(:,:,3,:)=v(:,:,3,:);
  vn(:,:,4,:)=v(:,:,2,:);
  vn(:,:,5,:)=v(:,:,1,:);

lonsize=length(xx(:,1));
latsize=length(yy(:,1));
cc=5;


[XC YC]=meshgrid(double(Xp),double(Yp));
%%%% data points are 1 less than grid points. data are arranged at the
%%%% center of grid cells as default settings.

chunk_size_2D=[latsize-1,lonsize-1];
chunk_size_3D=[latsize-1,lonsize-1,cc];


% uwnd = griddata(XC',YC',uwind(:,:,t),XX,YY);
% vwnd = griddata(XC',YC',vwind(:,:,t),XX,YY);

%%%%%%%%%%%%Write u v w to the hdf5         
    % read in date here
    % I just give an example date here, input format for data is just the
    % "yyyy mm dd hh mm ss", which can be generrate with datevec command
time=length(time);
%%%%%begin time of your necdf file, or you can set time in your ways
date_begin=datenum(daten(1,:));
    
    
    
 for t=1:time;
     tcf=tc+t;
% 
     date=daten(t,:);
    
    
    time_counter=num2str(tcf,'%05d')
    directory=['/Time/Time_',time_counter];
    h5create(fid,directory,6,'ChunkSize',6,'Deflate',6);
    h5writeatt(fid,directory,'Minimum',-0.000000);
    h5writeatt(fid,directory,'Maximum',2020.000000);
    h5writeatt(fid,directory,'Units','YYYY/MM/DD HH:MM:SS');
    h5write(fid,directory,date);
    
    
      for z=1:5


          
      uz(:,:)=(un(:,:,z));
      vz(:,:)=(vn(:,:,z));
   uvel(:,:,z)=griddata(XC',YC',uz(:,:),XX,YY);
   vvel(:,:,z)=griddata(XC',YC',vz(:,:),XX,YY);
      end
  
    UF=un(1:end,1:end,:,t);
    VF=vn(1:end,1:end,:,t);
    
 longdata = linspace(64,78,176);
 latdata = linspace(6,25,238);
 uvel=un(:,1:end-1,:,:);
 vvel=vn(:,1:end-1,:,:);
 
% % 152 points)
 longdata_new = linspace(64,78,112);
 latdata_new = linspace(6,25,152);
% % Build new grid
 [longq,latq] = meshgrid(longdata_new,latdata_new);
 uveldata_new = zeros(numel(longdata_new),numel(latdata_new),5,248);
 vveldata_new = zeros(numel(longdata_new),numel(latdata_new),5,248);
 
 for iz = 1:5
     for it = 1:240
         uveldata_cut = uvel(:,:,iz,it);
         vveldata_cut = vvel(:,:,iz,it);
         uveldata_new(:,:,iz,it) = interp2(longdata,latdata,uveldata_cut.',longq,latq).';
         vveldata_new(:,:,iz,it) = interp2(longdata,latdata,vveldata_cut.',longq,latq).';
     end
 end


    UF=uveldata_new(1:end,1:end,:,t);
    VF=vveldata_new(1:end,1:end,:,t);

   %UF=permute(UF,[2 1 3 4]);
   %VF=permute(VF,[2 1 3 4]);
   
   directory=['/Results/velocity U/velocity U_',time_counter];
   h5create(fid,directory,chunk_size_3D,'ChunkSize',chunk_size_3D,'Deflate',6);
   h5writeatt(fid,directory,'Minimum',-5);
   h5writeatt(fid,directory,'Maximum',5);
   h5writeatt(fid,directory,'Units','m/s');
   h5writeatt(fid,directory,'FillValue',0);
   h5write(fid,directory,UF);
      
     directory=['/Results/velocity V/velocity V_',time_counter];
     h5create(fid,directory,chunk_size_3D,'ChunkSize',chunk_size_3D,'Deflate',6);
     h5writeatt(fid,directory,'Minimum',-5);
     h5writeatt(fid,directory,'Maximum',5);
     h5writeatt(fid,directory,'Units','m/s');
     h5writeatt(fid,directory,'FillValue',0); 
    h5write(fid,directory,VF);
     
 end
 
 end