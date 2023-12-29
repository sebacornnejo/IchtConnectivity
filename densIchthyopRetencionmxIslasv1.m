clear all
close all
clc
addpath('C:\Users\sebacornnejo\Software\m_map1.4f')
l=[5 7 5 5 7 9 9];
month=char('Enero','Febrero','Marzo','Abril','Octubre','Noviembre','Diciembre');

for z=1:7%7
disp([month(z,1:l(z))])    
disp('...')
%%Lineas de costa AJF e ID
[num,txt,raw] = xlsread('vertices_islas_borde.xlsx');
hxc1=unique(txt(2:end,3));
a=0;
for t=1:length(hxc1(:,1))
hxc2=double(find(strcmp(txt(2:end,3),hxc1(t,:))==1));
hxc3=unique(num(hxc2,1));
for tt=1:length(hxc3)
hxc4=find(num(hxc2,1)==hxc3(tt));
a=a+1;
lonislas(a,1:length(hxc4))=num(hxc2(hxc4),5);latislas(a,1:length(hxc4))=num(hxc2(hxc4),6);
end
end

lonislas(latislas==0)=NaN;latislas(latislas==0)=NaN;

matObj=matfile(['.\RutayLlegada\trackretencionIDAJF' month(z,1:l(z)) 'v1.mat']);    
lonRCSC=matObj.lonRCSC;
latRCSC=matObj.latRCSC;
timeRCSC=matObj.timeRCSC;
lonAS=matObj.lonAS;
latAS=matObj.latAS;
timeAS=matObj.timeAS;
lonID=matObj.lonID;
latID=matObj.latID;
timeID=matObj.timeID;
clear matObj
close all

 
puntos=load('.\puntosliberacionIDJF_Nov.txt');
puntos(:,1)=wrapTo180(puntos(:,1));
aux1=find(puntos(:,1)>-79.844 & puntos(:,2)<-31);
aux2=find(puntos(:,1)<-79.844 & puntos(:,2)<-31);
aux3=find(puntos(:,2)>-31);
k = boundary(puntos(aux1,1),puntos(aux1,2));
RCSCboxlon=puntos(aux1(k),1); RCSCboxlon(length(RCSCboxlon)+1,1)=RCSCboxlon(1,1);
RCSCboxlat=puntos(aux1(k),2); RCSCboxlat(length(RCSCboxlat)+1,1)=RCSCboxlat(1,1);
k = boundary(puntos(aux2,1),puntos(aux2,2));
ASboxlon=puntos(aux2(k),1); ASboxlon(length(ASboxlon)+1,1)=ASboxlon(1,1);
ASboxlat=puntos(aux2(k),2); ASboxlat(length(ASboxlat)+1,1)=ASboxlat(1,1);
k = boundary(puntos(aux3,1),puntos(aux3,2));
IDboxlon=puntos(aux3(k),1); IDboxlon(length(IDboxlon)+1,1)=IDboxlon(1,1);
IDboxlat=puntos(aux3(k),2); IDboxlat(length(IDboxlat)+1,1)=IDboxlat(1,1);
clear k aux1 aux2 aux3 puntos

aux1=colormap_cpt('temperature');
aux2=linspace(1,100,18);
aux3=1:100;
R=interp1(aux2,aux1(:,1),aux3,'cubic');
G=interp1(aux2,aux1(:,2),aux3,'cubic');
B=interp1(aux2,aux1(:,3),aux3,'cubic');
cmap=[R' G' B'];
clear aux1 aux2 aux3 R G B

lonID(lonID==0)=NaN;latID(latID==0)=NaN;
lonAS(lonAS==0)=NaN;latAS(latAS==0)=NaN;
lonRCSC(lonRCSC==0)=NaN;latRCSC(latRCSC==0)=NaN;

%% RCSC
if isempty(lonRCSC)==0

nlon=-82.5:.0025:-77;
nlat=-34.8:.0025:-25.7;
ctrs={nlon nlat};
clear x y N
for i1=1:length(latRCSC(:,1))
    disp(['RC-SC: Día ' num2str(i1) ' of ' num2str(length(latRCSC(:,1)))])
    x=lonRCSC(i1,:);
    y=latRCSC(i1,:);
    N(:,:,i1)=hist3([x(:),y(:)],'Ctrs',ctrs);
end
[gridlonRCSC,gridlatRCSC]=meshgrid(nlon,nlat);
Ntot=sum(N,3);
gridTracersRCSC=Ntot'; clear x y N Ntot i1 ctrs

% gridTracersRCSC(gridTracersRCSC==0)=NaN;
clong=-78.87;clat=-33.64;
figure('visible','off')
m_proj('mercator','lat',[clat-0.5 clat+0.5],'lon',[clong-0.5 clong+0.5]);
m_pcolor(gridlonRCSC,gridlatRCSC,log1p(gridTracersRCSC));
shading interp
hold on
m_plot(RCSCboxlon,RCSCboxlat,'k','linewidth',0.1)
for m=1:length(lonislas(:,1))  
hxc3=lonislas(m,:);hxc4=latislas(m,:);
m_patch(hxc3(isnan(hxc3)==0),hxc4(isnan(hxc3)==0),[.73 .73 .73])
end
m_grid('linestyle',':','fontsize',6);
clim(log1p([0 10000]));
colormap(cmap);
h=colorbar;
set(get(h,'ylabel'),'String','$Density$ $Tracers$ $per$ $km^2$','interpreter','latex')
set(h,'ytick',log1p([0 10 50 100 500 1000 5000 10000]),'yticklabel',[0 10 50 100 500 1000 5000 10000],'tickdir','out')
print('-dpng', ['.\figMatrizRetention\densidad' month(z,1:l(z)) 'RutasRetentionRCSCv1'], '-r600');
close all

save(['.\densMatrix\densityRetentionSMiVe_' month(z,1:l(z)) 'RCSCv1.mat'],'gridlatRCSC','gridlonRCSC','gridTracersRCSC','-v7.3')
clear gridlonRCSC gridlatRCSC gridTracersRCSC b
end

%% AS

if isempty(lonAS)==0

nlon=-82.5:.0025:-77;
nlat=-34.8:.0025:-25.7;
ctrs={nlon nlat};
clear x y N
for i1=1:length(latAS(:,1))
    disp(['AS: Día ' num2str(i1) ' of ' num2str(length(latAS(:,1)))])
    x=lonAS(i1,:);
    y=latAS(i1,:);
    N(:,:,i1)=hist3([x(:),y(:)],'Ctrs',ctrs);
end
[gridlonAS,gridlatAS]=meshgrid(nlon,nlat);
Ntot=sum(N,3);
gridTracersAS=Ntot'; clear x y N Ntot i1 ctrs

% gridTracersAS(gridTracersAS==0)=NaN;
clong=-80.79;clat=-33.77;
figure('visible','off')
m_proj('mercator','lat',[clat-0.5 clat+0.5],'lon',[clong-0.5 clong+0.5]);
m_pcolor(gridlonAS,gridlatAS,log1p(gridTracersAS));
shading interp
hold on
m_plot(ASboxlon,ASboxlat,'k','linewidth',0.1)
for m=1:length(lonislas(:,1))  
hxc3=lonislas(m,:);hxc4=latislas(m,:);
m_patch(hxc3(isnan(hxc3)==0),hxc4(isnan(hxc3)==0),[.73 .73 .73])
end
m_grid('linestyle',':','fontsize',6);
clim(log1p([0 10000]));
colormap(cmap);
h=colorbar;
set(get(h,'ylabel'),'String','$Density$ $Tracers$ $per$ $km^2$','interpreter','latex')
set(h,'ytick',log1p([0 10 50 100 500 1000 5000 10000]),'yticklabel',[0 10 50 100 500 1000 5000 10000],'tickdir','out')
print('-dpng', ['.\figMatrizRetention\densidad' month(z,1:l(z)) 'RutasRetantionASv1'], '-r600');
close all

save(['.\densMatrix\densityRetentionSMiVe_' month(z,1:l(z)) 'ASv1.mat'],'gridlatAS','gridlonAS','gridTracersAS','-v7.3')
clear gridlonAS gridlatAS gridTracersAS b
end


%% ID

if isempty(lonID)==0

nlon=-82.5:.0025:-77;
nlat=-34.8:.0025:-25.7;
ctrs={nlon nlat};
clear x y N
for i1=1:length(latID(:,1))
    disp(['ID: Día ' num2str(i1) ' of ' num2str(length(latID(:,1)))])
    x=lonID(i1,:);
    y=latID(i1,:);
    N(:,:,i1)=hist3([x(:),y(:)],'Ctrs',ctrs);
end
[gridlonID,gridlatID]=meshgrid(nlon,nlat);
Ntot=sum(N,3);
gridTracersID=Ntot'; clear x y N Ntot i1 ctrs

% gridTracersID(gridTracersID==0)=NaN;
clong=-79.99;clat=-26.32;
figure('visible','off')
m_proj('mercator','lat',[clat-0.5 clat+0.5],'lon',[clong-0.5 clong+0.5]);
m_pcolor(gridlonID,gridlatID,log1p(gridTracersID));
shading interp
hold on
m_plot(IDboxlon,IDboxlat,'k','linewidth',0.1)
for m=1:length(lonislas(:,1))  
hxc3=lonislas(m,:);hxc4=latislas(m,:);
m_patch(hxc3(isnan(hxc3)==0),hxc4(isnan(hxc3)==0),[.73 .73 .73])
end
m_grid('linestyle',':','fontsize',6);
clim(log1p([0 10000]));
colormap(cmap);
h=colorbar;
set(get(h,'ylabel'),'String','$Density$ $Tracers$ $per$ $km^2$','interpreter','latex')
set(h,'ytick',log1p([0 10 50 100 500 1000 5000 10000]),'yticklabel',[0 10 50 100 500 1000 5000 10000],'tickdir','out')
print('-dpng', ['.\figMatrizRetention\densidad' month(z,1:l(z)) 'RutasRetentionIDv1'], '-r600');
close all

save(['.\densMatrix\densityRetantionSMiVe_' month(z,1:l(z)) 'IDv1.mat'],'gridlatID','gridlonID','gridTracersID','-v7.3')
clear gridlonID gridlatID gridTracersID b
end
clearvars -except z l month gridlon gridlat gridTracers boxlon boxlat
end