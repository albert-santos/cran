function L = SUI(xx, ht, hr, f, d)

lamb = 3e8/f;
fM = f*1e-6;

L = 20*log10(4*pi*100/lamb) + 10*(xx(1) - xx(2)*ht + xx(3)/ht).*log10(d/100) + xx(4)*log10(fM/2000) - 10.8*log10(hr/2);