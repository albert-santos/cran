function [EnbsPosition] = Smalls_position(Micros)

horas = size(Micros, 1);
total_smalls = size(Micros, 2);

for j = 1:horas
    a = 1;
    for l = 1:total_smalls
        if (Micros(j,l).D == 1)
            EnbsPosition(a,1,j) = Micros(j,l).X;
            EnbsPosition(a,2,j) = Micros(j,l).Y;
            a = a + 1;
        end
    end
end




end