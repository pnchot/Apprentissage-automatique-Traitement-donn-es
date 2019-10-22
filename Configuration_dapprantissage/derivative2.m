function out = derivative2(vec)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

        if length(vec)>=3
            out = diff(vec);
            out2 = derivative(vec);
            out(length(out2)) = out2(end);
        elseif length(vec)== 2
            out = diff(vec);
        else
            out = diff([0 vec(1)]);
        end

end

