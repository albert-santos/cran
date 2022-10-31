function L = ECC(x, ht, hr, f, d)

fG = f*1e-9;
dkm = d/1000;

L = 92.4 + 20*log10(dkm) + 20*log10(fG) + x(1) + x(2)*log10(dkm) + x(3)*log10(fG) + x(4)*(log10(fG))^2 - log10(ht/200)*(13.958 + 5.8*log10(dkm).^2) - x(3)*hr + x(4);
