function [donnees] = etude_compliance(nbreTube,numFi,bishopf,solution,val_E1,val_E2,val_G1,val_G2,diam_Mst_outer,F,coeff_division_D2,index_longeur_tub1)
  
   % Cette fonction retourne un fichier csv contenant différentes paramètre
   % à analyser
   % numF : le numéro du fichier traité;
   % indx_longeur: index de la longueur de séparation des deux tubes
   % bishopf : fichier contenant les bishop frames à traiter
   % solution : fichier contenant les courbures associées aux bishopframe
   % val_E : Module d'Young en SI ; val_G : Module de cisaillement en SI
   % diam_Mst_outer : diamètre extérieur du premier tube SI
   % F : intensité en SI de la charge;
   % coeff_division_D2 : ce coeeficient permet d'avoir des raideurs diff
   % index_longeur_tub1 : il donne l'index de la longueur maximale du tube1
    
   %%%%%%%%%%%%%%%%%% PARAMETRE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global E1 I1 E2 I2 J1 G1 J2 G2 D1 D2 d1 d2 F_b alpha tetha
       
    E1 = val_E1;    % Module d'Younge en GPa 
    E2 = val_E2;
    G1 = val_G1;    % Module de cisaillement GPa
    G2 = val_G2;
    D1 = diam_Mst_outer;           % Diametre exterieur du outer tube
    d1 = D1 - D1/10;               % Diametre interieur du outer tube 
    D2 = d1;                       % Diametre exterieur du inner tube
    d2 = D2 - D2/coeff_division_D2; % Diametre interieur du inner tube

    I1 = (pi/32)*(D1^4-d1^4); % Moment d'inertie m^4
    J1 = (pi/32)*(D1^4-d1^4); %

    I2 = (pi/32)*(D2^4-d2^4); % Moment d'inertie m^4
    J2 = (pi/32)*(D2^4-d2^4); %

    F_b = F;                  % Intensite de la charge applique
    alpha = [90,0,0];         % latitude
    tetha = [0,0,90];         % Longitude
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    [Ci,Pi,s_] = courbure_position(bishopf,solution,[E1 I1 E2 I2 J1 G1 J2 G2 0 0 0 index_longeur_tub1]); % Resolution du system sans charge initiale
    dgdf = zeros(3,3); % Initialisation de la matrice de compliance 
    
    for j = 1:3
        [C,P,s_] = courbure_position(bishopf,solution,[E1 I1 E2 I2 J1 G1 J2 G2 F_b alpha(j) tetha(j) index_longeur_tub1]);
        dgdf(:,j) = (P(1:3,end)-Pi(1:3,end))./F_b;
    end 
    %%%%%%%%% Determination du vecteur tangent à la courbe %%%%%%%%%%%%%%%%

    g = (bishop(bishopf)); % le vecteur tangent à la courbe corresponds à l'axe z
    
    g_end = g{end};        % On recupere la derniere matrice homogene 
    
    t = g_end(1:3,end-1);  % Donc la troisième conposant da la matrice de rotation
    
    %%%%%%%%% Calcul des valeurs singuliere de la matrice de compliance %%%%
    
    [S,U,V] = svd(dgdf); % Decomposition en valeurs singulieres

    lambda = [U(1,1) U(2,2) U(3,3)]; % Les valeurs propres 

    %     ratio1 = lambda(1)/lambda(3);    % Max/Min
    % 
    %     ratio2 = lambda(1)/lambda(2);    % Max/Inter
    % 
    %     ratio3 = lambda(2)/lambda(3);    % Inter/Min
    
    vect = [S(:,1) S(:,2) S(:,3)]; % Vecteurs propres 
     
    chg_coord_t = vect\t; % Changement de base 

    C_t = sqrt(1/((chg_coord_t(1)/U(1,1))^2 +(chg_coord_t(2)/U(2,2))^2 + (chg_coord_t(3)/U(3,3))^2));
    
    %%%%%%%%%%% Calcul de l'angle entre l vecteur tangent et de compliance  minimum %%%%%%%%%%%%%%%
    
    %     Cos_m_t = dot(S(:,3),-t)/(norm(S(:,3))*norm(t)); 
    %     
    %     Angle_m_t = acosd(Cos_m_t);
    
    % Syst=@(x)[U(1,1)*cosd(x(1))*cosd(x(2))-x(3)*chg_coord_t(1);...
    %           U(2,2)*cosd(x(1))*sind(x(2))-x(3)*chg_coord_t(2);...
    %           U(3,3)*cosd(x(1))-x(3)*chg_coord_t(3)];
    % 
    % x0 = [0,0,0];
    % xroot = fsolve(Syst,x0);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tube1 = s_(index_longeur_tub1);
    tube2 = s_(end);
    k1 = E1*I1;
    k2 = E2*I2;
    
    donnees = [nbreTube,numFi,F,U(1,1),U(2,2),U(3,3),C_t,S(1,1),S(2,1),...
        S(3,1),S(1,2),S(2,2),S(3,2),S(1,3),S(2,3),S(3,3),t(1),t(2),t(3),...
        D1,d1,D2,d2,I1,I2,tube1,tube2,k1,k2,coeff_division_D2,index_longeur_tub1]; % Donnee de sortie du fichier excel generer
        

