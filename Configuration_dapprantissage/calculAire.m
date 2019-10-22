function [surfaceArea] = calculAire(points)
    try
        tri = delaunay(points(1,:)',points(3,:)');
        P = [points(1,:)',points(2,:)',points(3,:)'];
    
        v1 = P(tri(:,2), :) - P(tri(:,1), :);
        v2 = P(tri(:,3), :) - P(tri(:,2), :);
    
        cp = 0.5*cross(v1,v2);
    
        surfaceArea =  sum(sqrt(dot(cp,cp, 2)));
        
    catch
        tri = delaunay(points(1,:),points(3,:));
        P = [points(1,:),points(2,:),points(3,:)];
    
        v1 = P(tri(:,2), :) - P(tri(:,1), :);
        v2 = P(tri(:,3), :) - P(tri(:,2), :);
    
        cp = 0.5*cross(v1,v2);
    
        surfaceArea =  sum(sqrt(dot(cp,cp, 2)));
    end
        
end 