function [A, s] = deformAngPos(bishop,delta_s)
    % cette fonction retourne la matrice [S] contenant ([u] v) 
    % et le vecteur s contenant x y z et ux uy uz   
    s = zeros(); 
    s(1:3,1) = zeros(3,1); % Valeur initiale des positions 
    s(4:6,1) = zeros(3,1); % Valeur initiale des courbure u1 u2 u3 
    indx_bishop = length(bishop);
    
    try
        
        for i = 1:indx_bishop-1
        
            g = bishop{i}; % La transformation précédente 
            A{1,i} = logm(g\bishop{i+1})/delta_s; % [S]
        
            s(1:3,i) = bishop{i}(1:3,end); % Les positions 
        
            t = skew_axis(A{1,i}); % skew axis 
            s(4:6,i) = t(1:3) ;    % les déformées angulaires 
        
        end 
        s(4:6,indx_bishop) = t(1:3) ;
        s(1:3,indx_bishop) = bishop{end}(1:3,end);
        A{1,indx_bishop} = A{1,indx_bishop-1};
        
    catch
        
        for i = 1:indx_bishop-1
        
            g = bishop{i}; % La transformation précédente 
            A{1,i} = logm(g\bishop{i+1})/delta_s(i); % [S]
        
            s(1:3,i) = bishop{i}(1:3,end); % Les positions 
        
            t = skew_axis(A{1,i}); % skew axis 
            s(4:6,i) = t(1:3) ;    % les déformées angulaires 
        
        end 
        s(4:6,indx_bishop) = t(1:3) ;
        s(1:3,indx_bishop) = bishop{end}(1:3,end);
        A{1,indx_bishop} = A{1,indx_bishop-1};
        
    end
end
    