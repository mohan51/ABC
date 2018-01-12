clc 
clear 
close all 
format shortG

%% parameters setting 
nvar =10;                 %number of variable 
lb=-10*ones(1,nvar); %lower bound 
ub=10*ones(1,nvar); %upper bound 

NB=100; %number of bee
SN=round(NB/2); %source number
N_unlooker=NB-SN; %unlooker number 
MCN=100; %max of cycle number 

Trial = zeros(SN,1);
Limit=60;

ndim=1;

%%Initialization
tic 

emp.x=[];
emp.fit=[];

food=repmat(emp,SN,1);

for i=1:SN
food(i).x=lb+rand(1,nvar).*(ub-lb);
food(i).fit=fitness(food(i).x);
end

[value,index]=min([food(i).fit]);
gfood=food(index); %global food

%%main loop 

best =zeros(MCN,1);
AVR=zeros(MCN,1);

for cycle=1:MCN

%employed bee section
 for i=1:SN
  k=randsample([1:i-1 i+1:SN],1);
  XK=food(k).x; %neighbor
  j=randsample(nvar,ndim)';
  x=food(i).x;
  NEWX=X;
  
  NEWX(j)=X(j)+unifrnd(-1,1,size(j)).*(X(j)-XK(j)));
  NEWX=min(NEWX,ub);
  NEWFIT=fitness(NEWX);
  
 if NEWFIT<food(i).fit
  food(i).fit =NEWFIT;
  food(i).x=NEWX;
  Trial(i)=0;
 else
 Trial(i)=Trial(i)+1;
 end
 
 end
 
 % unlooker bee section 
 
 f=calculated_Pfit([food.fit]);
 f=cumsum(f);
 
 for n=1:N_unlooker
 i=RouletteWheel(f);
 k=randsample([1:i-1 i+1:SN],1);
 XK = food(k).x;%neighbor
 j=randsample(nvar,ndim)';
 X=food(i).x;
 NEWX=X;
 NEWX(j)=X(j)+unifrnd(-1,1,size(j)).*(X(j)-XK(j));
 
 NEWX=max(NEWX,lb);
 NEWX=min(NEWX,ub);
 
 NEWFIT=fitness(NEWX);
 
 if NEWFIT<food(i).fit
  food(i).fit=NEWFIT;
  food(i).x=NEWX;
  Trial(i)=0;
 else
  Trial(i)=Trial(i)+1
 end
 end
 
 %scout bee section 
 Q=find(Trial>Limit);
 
 for j=1:length(Q)
 i=Q(j);
 food(i).x=lb+rand(1,nvar).*(ub-lb);
 food(i).fit=fitness(food(i).x);
 Trial(i)=0;
 end
 [value,index]=min([food.fit]);
 if value<gfood.fit
  gfood=food(index);
  end
  best(cycle)=gfood.fit;
  AVR(cycle)=mean([food.fit]);
  disp(['   cycle= 'num2str(cycle) '  BEST = ' num2str(best(cycle))])
  end 
  
  %%results 
  disp('===================================================')
  disp([ '   BEST SOLUTION=' num2str(gfood.x)]);
  disp(['BEST fitness = ' num2str(gfood.fit)]);
  disp(['   Time  =   ' num2str(toc)]);
  
  
  figure(1)
  plot(best(1:cycle),'r', 'LineWidth',2);
  hold on
  plot(AVR(1:cycle),'b','LineWidth',2);
  
  xlabel('CYCLE')
  ylabel('Fitness')
  
  legend(' BEST ', '  MEAN')
  title('ABC')
  
  
 
  