function [Gcoordonnees,Gdistance] = grandAxe(points)
    
    Gcoordonnees = [points(:,1)];
    maximum = 0;
    index = 0;
    for i =2:length(points)-1
        a = norm(points(:,i)-points(:,1));
        if maximum < a
            maximum = a;
            index = i;
        end
    end 
    
    Gdistance = maximum ; 
    Gcoordonnees =[Gcoordonnees points(:,index)];
end
    
    