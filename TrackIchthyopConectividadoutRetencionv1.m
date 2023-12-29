clear all
close all
clc
%%Se identifica cuantas de las rutas del dom inio alcanzaron conectividad
%%con otro sistema
l=[5 7 5 5 7 9 9];
dm=[31 28 31 30 31 30 31];
month=char('Enero','Febrero','Marzo','Abril','Octubre','Noviembre','Diciembre');
for z=7:7%7
disp(['Mes: ' month(z,1:l(z))])
disp('···')
matObj=matfile(['.\MatricesIchthyop\matrizconectividad' month(z,1:l(z)) 'v1.mat']);
lon=matObj.lon;
lat=matObj.lat;
time=matObj.time;
part=length(lat(:,1));
puntos=load('.\puntosliberacionIDJF_Nov.txt');
puntos(:,1)=wrapTo180(puntos(:,1));
aux1=find(puntos(:,1)>-79.844 & puntos(:,2)<-31);
aux2=find(puntos(:,1)<-79.844 & puntos(:,2)<-31);
aux3=find(puntos(:,2)>-31);
k = boundary(puntos(aux1,1),puntos(aux1,2));
RCSCboxlon=puntos(aux1(k),1); %RCSCboxlon(length(RCSCboxlon)+1,1)=RCSCboxlon(1,1);
RCSCboxlat=puntos(aux1(k),2); %RCSCboxlat(length(RCSCboxlat)+1,1)=RCSCboxlat(1,1);
k = boundary(puntos(aux2,1),puntos(aux2,2));
ASboxlon=puntos(aux2(k),1); %ASboxlon(length(ASboxlon)+1,1)=ASboxlon(1,1);
ASboxlat=puntos(aux2(k),2); %ASboxlat(length(ASboxlat)+1,1)=ASboxlat(1,1);
k = boundary(puntos(aux3,1),puntos(aux3,2));
IDboxlon=puntos(aux3(k),1); %IDboxlon(length(IDboxlon)+1,1)=IDboxlon(1,1);
IDboxlat=puntos(aux3(k),2); %IDboxlat(length(IDboxlat)+1,1)=IDboxlat(1,1);
clear k aux1 aux2 aux3 puntos
time=time+datenum(1,0,0,0,0,0);
lon(lat==0)=NaN;lat(lat==0)=NaN;
a=0;
% b=0;
lonRCSC=[];
latRCSC=[];
timeRCSC=[];
lonAS=[];
latAS=[];
timeAS=[];
lonID=[];
latID=[];
timeID=[];
for r=1:dm(z)
    disp(['Día : ' num2str(r)])
    for p=1:part
        in=double(inpolygon(squeeze(lon(p,2,r)),squeeze(lat(p,2,r)),RCSCboxlon,RCSCboxlat));
        in2=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),ASboxlon,ASboxlat));
        in3=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),IDboxlon,IDboxlat));
        if isempty(find(double(in)==1))==0 
            if length(find(double(in2))==1)>0 || length(find(double(in3)==1))>0
            lonRCSC=[lonRCSC squeeze(lon(p,:,r))'];
            latRCSC=[latRCSC squeeze(lat(p,:,r))'];
            timeRCSC=[timeRCSC squeeze(time(p,:,r))'];
            end
        end
        in=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),RCSCboxlon,RCSCboxlat));
        in2=double(inpolygon(squeeze(lon(p,2,r)),squeeze(lat(p,2,r)),ASboxlon,ASboxlat));
        in3=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),IDboxlon,IDboxlat));
        if isempty(find(double(in2)==1))==0
            if length(find(double(in)==1))>0 || length(find(double(in3)==1))>0
            lonAS=[lonAS squeeze(lon(p,:,r))'];
            latAS=[latAS squeeze(lat(p,:,r))'];
            timeAS=[timeAS squeeze(time(p,:,r))'];
            end
        end
        in=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),RCSCboxlon,RCSCboxlat));
        in2=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),ASboxlon,ASboxlat));
        in3=double(inpolygon(squeeze(lon(p,2,r)),squeeze(lat(p,2,r)),IDboxlon,IDboxlat));
        if isempty(find(double(in3)==1))==0 
            if length(find(double(in2)==1))>0 || length(find(double(in)==1))>0
            lonID=[lonID squeeze(lon(p,:,r))'];
            latID=[latID squeeze(lat(p,:,r))'];
            timeID=[timeID squeeze(time(p,:,r))'];
            end
        end
        clear in in2 in3
    end

end

save(['.\RutayLlegada\trackconectividadoutsideIDAJF' month(z,1:l(z)) 'v1.mat'],'latID','lonID','timeID','latAS','lonAS','timeAS','latRCSC','lonRCSC','timeRCSC','-v7.3')
clearvars -except l dm z month
end

