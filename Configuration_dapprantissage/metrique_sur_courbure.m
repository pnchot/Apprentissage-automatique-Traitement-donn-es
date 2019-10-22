function [StatUx,StatUy,SomUx,SomUy,SomAbsUx,SomAbsUy,RsUxUy,StatU,SomU,SomAbsU] = metrique_sur_courbure(courbures)
    [StatUx,StatUy] = datastats(courbures(1,:)',courbures(2,:)');
    SomUx =  sum(courbures(1,:));
    SomUy =  sum(courbures(2,:));
    SomAbsUx = sum(abs(courbures(1,:)));
    SomAbsUy = sum(abs(courbures(2,:)));
    
    som=0;
    for i =1:length(courbures)
        som = som + (courbures(1,i)-courbures(2,i))^2;
    end
    RsUxUy =  sqrt(som/length(courbures));
    
    U = zeros();
    for  j = 1:length(courbures)
        U(j) = sqrt(courbures(1,j)^2 + courbures(2,j)^2);
    end
    StatU = datastats(U');
    
    SomU = sum(U);
    SomAbsU = sum(abs(U));

end
        