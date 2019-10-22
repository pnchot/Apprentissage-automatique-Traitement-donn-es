function [PP] = distance_projete_plan(position_courbe)
    PP = [];
    vecteur_directeur = (position_courbe(:,end) - position_courbe(:,1));
    vecteur_directeur_unitaire = vecteur_directeur./norm(vecteur_directeur);
    for i =1:length(position_courbe)        
        [x_proj,y_proj,z_proj] = projection(vecteur_directeur_unitaire(1),...
            vecteur_directeur_unitaire(2),vecteur_directeur_unitaire(3),0,...
            position_courbe(1,i),position_courbe(2,i),position_courbe(3,i));
        vec_proj =[x_proj,y_proj,z_proj]';
        
        PP = [PP [vec_proj]];
    end
end