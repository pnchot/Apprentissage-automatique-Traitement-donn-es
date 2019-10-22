function b = bishop(bishopframes)
    % Cette fonction retourne un vecteur contenant l'ensemble des
    % matrices de configuration 
    l = length(bishopframes);
    b = {};
    g = eye(4);
    for j = 1:l
        
        g(1:3,1) = bishopframes(j,1:3)';
        g(1:3,2) = bishopframes(j,4:6)';
        g(1:3,3) = bishopframes(j,7:9)';
        g(1:3,4) = bishopframes(j,10:12)'./1000;
         
        b{1,j} = g;
    end
end

    