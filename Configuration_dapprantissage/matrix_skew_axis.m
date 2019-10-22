function A = matrix_skew_axis(u,v)
    p = skew(u);
    try
        A = [p v;[0 0 0 0]];
    catch
        t = v';
        A = [p t;[0 0 0 0]];
    end       
end 