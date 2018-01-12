function Z=fitness(x)
Z=sum(x.^2); %sphere function
% Z=sum(-x.*sin(sqrt(abs(x)))); % schwefel
end 