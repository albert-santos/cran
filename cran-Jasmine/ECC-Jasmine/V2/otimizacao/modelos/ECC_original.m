function L = ECC(x, ht, hr, f, d)

fG = f*1e-9;
dkm = d/1000;

L = 92.4 + 20*log10(dkm) + 20*log10(fG) + 20.41 + 9.83*log10(dkm) + 7.894*log10(fG) + 9.56*(log10(fG))^2 - log10(ht/200)*(x(1) + x(2)*log10(dkm).^2) - x(3)*hr + x(4);
