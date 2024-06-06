close all; clear all;    
xy=[linspace(73.5,69,23).' linspace(7,20,23).'];
ab=[linspace(75.5,71,23).' linspace(7,20,23).'];
cd=[linspace(74.5,70,23).' linspace(7,20,23).'];

C = cat(1,xy,ab,cd);
    fileName = fopen('Lagrangian_1.dat','w');
    
    fprintf(fileName, 'ASSOCIATE_BEACH_PROB      : 1\n');
    fprintf(fileName, 'DEFAULT_BEACHING_PROB     : 0.7\n');
    fprintf(fileName, 'BEACHING                  : 1\n');
    fprintf(fileName, 'BEACHING_LIMIT            : 5.0\n\n');
    fprintf(fileName, 'OUTPUT_TIME               : 0    86400\n');
    fprintf(fileName, 'OUTPUT_CONC               : 2\n');
    fprintf(fileName, 'DT_PARTIC                 : 3600\n\n');
    l=0;
    for i=1:23
        l=l+1;
    fprintf(fileName, '<BeginOrigin>\n');
    fprintf(fileName, 'ORIGIN_NAME               : OilSpill-%d\n',l);
    fprintf(fileName, 'GROUP_ID                  : 1\n');
    fprintf(fileName, 'NBR_PARTIC                : 2000\n');
    fprintf(fileName, 'EMISSION_SPATIAL          : Point\n');
    fprintf(fileName, 'EMISSION_TEMPORAL         : Instantaneous\n');
    fprintf(fileName, 'POINT_VOLUME              : 10000\n\n');
    fprintf(fileName, 'FLOAT                     : 0 \n');
    fprintf(fileName, 'MOVEMENT                  : SullivanAllen\n');
    fprintf(fileName, 'VARVELHX                  : 0.05\n');
    fprintf(fileName, 'VARVELH                   : 0.001\n\n');
    fprintf(fileName, 'TURB_V                    : Constant\n');
    fprintf(fileName, 'VARVELVX                  : 0.005\n');
    fprintf(fileName, 'POSITION_COORDINATES	   : %f   %f\n',xy(i,1),xy(i,2));
    fprintf(fileName, 'DEPTH_METERS              : 0\n\n');
    fprintf(fileName, 'ADVECTION                 : 1\n');
    fprintf(fileName, 'THEORIC_AREA              : 1\n');
    fprintf(fileName, 'BEACHING                  : 1\n');
    fprintf(fileName, 'AREA_METHOD               : 3\n');
    fprintf(fileName, '! METHOD_BW_DROPLETS_DIAMETER :3\n\n');
    fprintf(fileName, ' DENSITY_METHOD             : 2\n');
    fprintf(fileName, '! ADVECTION_Z              : 1\n\n');
    fprintf(fileName, '! METHOD_FLOAT_VEL         : 1\n');
    fprintf(fileName, 'OIL_BEACHING               : 1\n');

    
    fprintf(fileName, '! WINDDRIFTCORRECTION       : 1\n');
    fprintf(fileName, '! WINDDRIFTANGLE            : 15.\n');
   
    fprintf(fileName, '<<BeginOil>>\n');
    fprintf(fileName, 'DT_OIL_INTPROCESSES       : 60\n\n');
    fprintf(fileName, 'OIL_SPREADING             : 1\n');
    fprintf(fileName, 'SPREADINGMETHOD           : ThicknessGradient\n');
    fprintf(fileName, 'USERCOEFVELMANCHA         : 8\n\n');
    fprintf(fileName, 'OIL_EVAPORATION           : 1\n');
    fprintf(fileName, 'EVAPORATIONMETHOD         : EvaporativeExposure\n\n');
    fprintf(fileName, 'OIL_DISPERSION            : 1\n');
    fprintf(fileName, 'DISPERSIONMETHOD          : Mackay\n\n');
    fprintf(fileName, 'OIL_EMULSIFICATION        : 1\n');
    fprintf(fileName, 'EMULSIFICATIONMETHOD      : Mackay\n\n\n');
    fprintf(fileName, 'OILTYPE                   : Crude\n');
    fprintf(fileName, 'API                       : 27.4\n');
    fprintf(fileName, 'POURPOINT                 : -28\n');
    fprintf(fileName, 'CEMULS                    : 0\n');
    fprintf(fileName, 'MAXVWATERCONTENT          : 90\n');
    fprintf(fileName, 'TEMPVISCREF               : 16\n');
    fprintf(fileName, 'VISCREF                   : 1\n');
    fprintf(fileName, 'OWINTERFACIALTENSION      : 20\n');
    fprintf(fileName, 'OIL_TIMESERIE             : OilOutput-%d\n',i);
    fprintf(fileName, 'DT_OUTPUT_TIME            : 3600\n');
    fprintf(fileName, '! OIL_DISSOLUTION           : 1\n');
    fprintf(fileName, '<<EndOil>>\n\n');
    fprintf(fileName, '<<BeginProperty>>\n');
    fprintf(fileName, 'NAME                      : oil\n');
    fprintf(fileName, 'UNITS                     : m3\n');
    fprintf(fileName, 'AMBIENT_CONC              : 0.0\n');
    fprintf(fileName, 'CONCENTRATION             : 1.0\n');
    fprintf(fileName, '<<EndProperty>>\n\n');
    fprintf(fileName, '<EndOrigin>\n\n');
    end
    fclose(fileName);
    
    
  plot(C)  
    hold on
    
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
xlim([65 78]);
ylim([6 25 ]);
axis on
set(gca,'XTick',[65 67 69  71  73  75  77]);
%      set(gca,'YTick',[6 10 15 20 25]);
      set(gca,'YTick',[6 8 10 12 14 16 18 20 22 24]);
     xlabel('Longitude(^{\circ} E)');
     ylabel('Latitude(^{\circ} E)');
     
     
     xlim([65 78]);
ylim([6 25 ]);
      borders('India','facecolor','(0.5 0.5 0.5)')
%        [lat,lon] = borders('India');
        [xlim,ylim] = borders('India');
%        pgon = polyshape(lon,lat,'simplify',false);
       pgon = polyshape(xlim,ylim,'simplify',false);