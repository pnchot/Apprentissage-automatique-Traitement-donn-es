function g = transformation_g(F,delta_s)
    % F est un objet contenant toutes les matrices [S]=([u] v)
    g{1,1} = eye(4);
    indx_F = length(F);
    
    try 
        for i=1:indx_F-1
            g{1,i+1} = g{1,i}*expm(F{1,i}*delta_s);
        end
    catch
        for i=1:indx_F-1
            g{1,i+1} = g{1,i}*expm(F{1,i}*delta_s(i));
        end
    end
           
end
        