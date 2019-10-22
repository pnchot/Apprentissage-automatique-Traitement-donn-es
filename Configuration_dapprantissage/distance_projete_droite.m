function [DP, DM, A] =  distance_projete_droite(position_courbe)
    % On considere une droite dans l'espace parametrisée de vecteur
    % directeur (a,b,c)  qui passe par le point initiale
    % et le point finale de la courbe et dont l'equation de la droite est  
    % x = x0 + k*a
    % y = y0 + k*b
    % z = z0 + k*c
    % On cherche le projete des points de la courbe sur cette droite 
    DP = [[0 0 0]';0];
    vecteur_directeur = (position_courbe(:,end) - position_courbe(:,1));
    vecteur_directeur_unitaire = vecteur_directeur./norm(vecteur_directeur);
    for i = 2: length(position_courbe)-1
        k = ( vecteur_directeur_unitaire(1)*(-position_courbe(1,1)+position_courbe(1,i))...
            + vecteur_directeur_unitaire(2)*(-position_courbe(2,1)+position_courbe(2,i))...
            + vecteur_directeur_unitaire(3)*(-position_courbe(3,1)+position_courbe(3,i)))/...
           ( vecteur_directeur_unitaire(1)^2+vecteur_directeur_unitaire(2)^2+ vecteur_directeur_unitaire(3)^2);
        vec_proj = k*vecteur_directeur_unitaire;
        
    % Deuxieme manniere de calculer        
    %         d = -vecteur_directeur_unitaire(1)*position_courbe(1,i)...
    %             -vecteur_directeur_unitaire(2)*position_courbe(2,i)...
    %             -vecteur_directeur_unitaire(3)*position_courbe(3,i);
    %         [x_proj,y_proj,z_proj] = projection(vecteur_directeur_unitaire(1),...
    %             vecteur_directeur_unitaire(2),vecteur_directeur_unitaire(3),-d,...
    %             0,0,0);
    %         vec_proj =[x_proj,y_proj,z_proj]';
    
        distance_au_projete = norm(position_courbe(:,i)-vec_proj );% sqrt((vec_proj(1)- position_courbe(1,i))^2 +(vec_proj(2)- position_courbe(2,i))^2 +(vec_proj(1)- position_courbe(3,i))^2);
        DP = [DP [vec_proj;distance_au_projete]];
    end 
    DP = [DP [position_courbe(:,end);0]];
    A = 0;
    
    for j = 1:length(DP)-1
        A = A + norm((DP(1:3,j+1) - DP(1:3,j)))*DP(4,j);
    end
    DM = max (DP(4,:));
end
         
        