clear all
close all
clc
%%1024000/2000=512 %%37
l=[5 7 5 5 7 9 9];
p=[5489 3451 2353 1725 6274 15684 9410]; %%Número de partículas
dm=[31 28 31 30 31 30 31];
month=char('Enero','Febrero','Marzo','Abril','Octubre','Noviembre','Diciembre');%,'Noviembre'
for z=7:7%7
disp([month(z,1:l(z))])
disp('···')
fileichthyop=['.\IchthyopNC\romsPrueba' month(z,1:l(z)) '.nc'];
%%Se genera una matriz donde la tercera dimesión es el realese
b=1;c=1;
for d=1:dm(z)
disp(['Realese: ' num2str(d)])
aux=double(ncread(fileichthyop,'lon',[c b],[p(z) 365]));
if z==1
a=length(find(isnan(aux(:,2))==0));    
else
a=length(find(isnan(aux(:,1))==0));    
end
time(:,:,d)=repmat(datenum(1950,1,1,0,0,double(ncread(fileichthyop,'time',[b],[365]))),1,a)';
disp(['Date: ' datestr(time(1,1,d))])
lon(:,:,d)=double(ncread(fileichthyop,'lon',[c b],[a 365]));%292
lat(:,:,d)=double(ncread(fileichthyop,'lat',[c b],[a 365]));%(d:d+36,t1:t2);
mort(:,:,d)=double(ncread(fileichthyop,'mortality',[c b],[a 365]));%(d:d+36,t1:t2);
depth(:,:,d)=double(ncread(fileichthyop,'depth',[c b],[a 365]));%(d:d+36,t1:t2);
v(:,:,d)=double(ncread(fileichthyop,'v',[c b],[a 365]));
u(:,:,d)=double(ncread(fileichthyop,'u',[c b],[a 365]));
b=b+1;
c=c+a;
close all
end
mort(mort<0 | 0<mort)=NaN;
mort(isnan(mort)==0)=1;
mort(isnan(mort)==1)=0;
lon(mort==0)=0;
lat(mort==0)=0;
depth(mort==0)=0;
v(mort==0)=0;
u(mort==0)=0;
time(mort==0)=0;
save(['.\MatricesIchthyop\matrizconectividad' month(z,1:l(z)) 'v1.mat'],'mort','lon','lat','depth','u','v','time','-v7.3')
clearvars -except z l p dm month a
end
