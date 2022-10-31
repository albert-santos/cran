function L = ABG(x, ht, hr, f, d)

fr = f/1e9;
X = normrnd(0,9.9,length(d),1);

%L=10*x(1)*log10(d)+x(2)+10*2*log10(fr);  %original  
%L=10*x(1)*log10(d)+x(2);    

L=10*x(1)*log10(d)+x(2)+10*2*log10(fr); %+ X; %modi_jas


