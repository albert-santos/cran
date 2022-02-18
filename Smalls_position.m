function [EnbsPosition] = Smalls_position(Micros, Sim)

horas = size(Micros, 1);
total_smalls = size(Micros, 2);

for j = 1:horas
    a = 1;
    for l = 1:total_smalls
        if (Micros(j,l,Sim).D == 1)
            EnbsPosition(a,1,j) = Micros(j,l,Sim).X;
            EnbsPosition(a,2,j) = Micros(j,l,Sim).Y;
            a = a + 1;
        end
    end
end




end