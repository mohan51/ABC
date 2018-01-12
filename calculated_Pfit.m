function  f=calculated_Pfit(f)
 PF=find(f>0);
 NF=find(f<0);
 
 f(NF)=1+abs(f(NF));
 f(PF)=1./(1+f(PF));
 f=f./sum(f);
end