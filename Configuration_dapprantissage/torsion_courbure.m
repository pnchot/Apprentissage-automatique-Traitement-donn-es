function [somAbsTorsion,somTorsion,torsion] = torsion_courbure(fichier_bishop,fichier_solution)

    bishop_struc = load(fichier_bishop);     
    list_bishop = bishop(bishop_struc.bishop);
    list_solution = load(fichier_solution);
    tetha = zeros();
    tetha(1) =0;
%%
for i =2:length(list_bishop)
    t = list_bishop{i}(1:3,end);
    n1 = list_bishop{i}(1:3,end-1);
    n2 = list_bishop{i}(1:3,end-2);
    u1 = list_solution.solution(2,i)';
    u2 = list_solution.solution(3,i)';
    u3 = 0;
    A = [n1 n2;-t -t];
    B =[n1*u3-u2*t;(u2-u3)*n2+u2*t-u1*n1];
    K = A\B;
    tetha(i) = atan(K(2)/K(1));
end

torsion = derivative2(tetha)./derivative2(list_solution.solution(1,:));
somAbsTorsion = sum(abs(torsion));
somTorsion = sum(torsion);
