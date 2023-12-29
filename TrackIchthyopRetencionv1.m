clear all
close all
clc
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
lon(lat==0)=NaN;lat(lat==0)=NaN;
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
        in=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),RCSCboxlon,RCSCboxlat));
        in2=find(in==1);
        %%Estadío larval de 12 meses según Porobic et al., 2013 y Phillips et al., 2006
        if length(in2)>=360 && squeeze(lon(p,2,r))>-80 && squeeze(lat(p,2,r))<-32 && not(squeeze(lon(p,2,r))==squeeze(lon(p,end,r)))
            lonRCSC=[lonRCSC squeeze(lon(p,2:end,r))'];
            latRCSC=[latRCSC squeeze(lat(p,2:end,r))'];
            timeRCSC=[timeRCSC squeeze(time(p,2:end,r))'];
        end
        in=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),ASboxlon,ASboxlat));
        in2=find(in==1);
        if length(in2)>=360 && squeeze(lon(p,2,r))<-80 && squeeze(lat(p,2,r))<-32 && not(squeeze(lon(p,2,r))==squeeze(lon(p,end,r)))
            lonAS=[lonAS squeeze(lon(p,2:end,r))'];
            latAS=[latAS squeeze(lat(p,2:end,r))'];
            timeAS=[timeAS squeeze(time(p,2:end,r))'];
        end
        in=double(inpolygon(squeeze(lon(p,:,r)),squeeze(lat(p,:,r)),IDboxlon,IDboxlat));
        in2=find(in==1);
        if length(in2)>=360 && squeeze(lat(p,2,r))>-32 && not(squeeze(lon(p,2,r))==squeeze(lon(p,end,r)))
            lonID=[lonID squeeze(lon(p,2:end,r))'];
            latID=[latID squeeze(lat(p,2:end,r))'];
            timeID=[timeID squeeze(time(p,2:end,r))'];
        end
    end

end

save(['.\RutayLlegada\trackretencionIDAJF' month(z,1:l(z)) 'v1.mat'],'latID','lonID','timeID','latAS','lonAS','timeAS','latRCSC','lonRCSC','timeRCSC','-v7.3')
end

% TrackIchthyopRetencionMiVev3;