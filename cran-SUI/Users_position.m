function [User] = Users_position(UE,Sim)

b = length(UE);
for j = 1:24
    a = 1;
    for l = 1:b
        if (UE(Sim, l).M == j)
            User(a,1,j) = UE(Sim, l).X;
            User(a,2,j) = UE(Sim, l).Y;
            a = a + 1;
        end
    end
end


end