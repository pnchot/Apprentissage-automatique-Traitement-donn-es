function [U, position_f, s_] = courbure_position(fichier_bishop,fichier_solution,parametres)
    %# Cette fonction prend entré un ficher contenant les bishops d'une config 
    %# la valeur de la charge à papliquer et les caractéristique mécanique du tube 
    %# Elle retourne la courbure et la position 
    %# parametres = [E1,I1,E2,I2,J1,G1,J2,G2,F,alpha,tetha,split]

    delta_s = derivative2(fichier_solution(1,:))./10^3; % Conversion en m
    l = fichier_solution(1,end)./10^3;
    s_= fichier_solution(1,:)./10^3;                    % Discrétisation de la longueur du tube
    l_indx = size(s_,2);                                % Index de la longueur totale du tube
    
    if parametres(12) > 0 && parametres(3) ~=0 && parametres(8) ~= 0
        for i = 1:l_indx 
             if i < parametres(12)
                kx(i) = parametres(1)*parametres(2)+ parametres(3)*parametres(4);
                kz(i) = parametres(5)*parametres(6)+ parametres(7)*parametres(8);
            else
                kx(i) = parametres(3)*parametres(4);
                kz(i) = parametres(7)*parametres(8);
             end
        end
    else
        for i = 1:l_indx 
            kx(i) = parametres(1)*parametres(2);
            kz(i) = parametres(5)*parametres(6);
        end
    end
        
    
    dkxds = derivative2(kx);
    dkzds = derivative2(kz);
    
    
    % Définition d'une courbure initiale û

    bishop_f_i = bishop(fichier_bishop); 
    
    [S, posiCourbure] = deformAngPos(bishop_f_i,delta_s);
    
    % Définition de u_hat
    
    u_hat = posiCourbure(4:6,:);
   
    % Définition de du_hatds
    
    du_hatds = [derivative2(u_hat(1,:))./derivative2(s_);...
    derivative2(u_hat(2,:))./derivative2(s_);...
    derivative2(u_hat(3,:))./derivative2(s_)];

    %  Composantes de l'effort 
    n1 = parametres(9)*cosd(parametres(10))*cosd(parametres(11));% la représentation des forces 
    n2 = parametres(9)*cosd(parametres(10))*sind(parametres(11));% dans le repère cartésien normale
    n3 = -parametres(9)*sind(parametres(10));% n1 <==> X n2 <==> Y et le n3 <==> Z

    %  Moment du à la charge appliquées à l'extrémité 
    
    m = skew([posiCourbure(1,end) posiCourbure(2,end) posiCourbure(3,end)])*[n1 n2 n3]';
  
    %  Courbures u1(l) u2(l) u3(l)
    U(1,l_indx) = (m(1)/kx(1))+ u_hat(1,l_indx);
    U(2,l_indx) = (m(2)/kx(1))+ u_hat(2,l_indx);
    U(3,l_indx) = (m(3)/kz(1))+ u_hat(3,l_indx);
  
    %  composante des efforts
    N(1,l_indx) = n1;
    N(2,l_indx) = n2;
    N(3,l_indx) = n3;   
    
%     K ={};
%     dKds = {};
%     K_inv = {};

    for i = 1:l_indx
     
        K{i} = eye(3,3)*[kx(i),0,0;0,kx(i),0;0,0,kz(i)]; % Matrice de raideur

        dKds{i} = eye(3,3)*[dkxds(i),0,0;0,dkxds(i),0;0,0,dkzds(i)]; % dérivée de la matrice de raideur 

        K_inv{i} =  eye(3,3)*[1.0/kx(i),0,0;0,1.0/kx(i),0;0,0,1.0/kz(i)];
     end 
    
    for h = l_indx :-1:2
        
        Kc = K{h};
        dKdsc = dKds{h};
        K_invc = K_inv{h};
        
        N(:,h-1) = N(:,h)-(-skew(U(:,h))*N(:,h))*delta_s(h-1);
        
        U(:,h-1) = U(:,h)-(du_hatds(:,h-1) - K_invc*(skew(U(:,h))...
            *Kc*(U(:,h)-u_hat(:,h-1))+skew([0 0 1])*N(:,h)+ dKdsc*(U(:,h)-u_hat(:,h-1))))*delta_s(h-1); 
        
        U(3,h-1) = U(3,h) - delta_s(h)*(du_hatds(3,h) + Kc(1,2)/Kc(3,3))*(U(1,h)*u_hat(2,h)-...
            U(2,h)*u_hat(1,h));
      
    end
    
    %  Calcul des matrices skews axis et x y et z à partir des u calculés 

    for p = 1:l_indx
        F{1,p} = matrix_skew_axis(U(1:3,p),[0 0 1]);
    end

    bishop_f_f = transformation_g(F,delta_s);

    [Sf, posifCourbure] = deformAngPos(bishop_f_f,delta_s); 
    
    position_f = posifCourbure(1:3,:);
end 
    
    
    
    

    

    