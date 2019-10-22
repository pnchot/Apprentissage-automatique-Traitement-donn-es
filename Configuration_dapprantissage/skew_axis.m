function v = skew_axis(A)
    v(1) = A(3,2);
    v(2) =-A(3,1);
    v(3) = A(2,1);
    v(4) = A(1,4);
    v(5) = A(2,4);
    v(6) = A(3,4);
end