function[Npic, LongC, posiMaxCourbure,Somduds,SomAbsduds] = metrique_derivative(vec_courbures,abscisse_s)
    Npic = 0;
    Long = [];
    courbure = zeros();
    index_pic =[];
    try    
        duds = derivative2(vec_courbures)./derivative2(abscisse_s);
        for i=1:length(duds)
            if abs(duds(i)) > 50
                Npic = Npic + 1 ; 
                index_pic =[index_pic i];
                Long = [Long abscisse_s(i)];
                courbure(Npic) = vec_courbures(i-1);
            end
        end
        courbure(Npic+1) = vec_courbures(index_pic(end)+1); 
%     catch
%         
%         duds = derivative2(vec_courbures')./derivative2(abscisse_s);
%         for i=1:length(duds)
%             if duds(i) > 100
%                 Npic = Npic + 1 ; 
%                 Long = [Long abscisse_s(i)];
%             end
%         end
%     end
    LongC = zeros(1,Npic+1);
    LongC(1) = Long(1);
    for i =2:Npic
        LongC(i) = Long(i)-Long(i-1);
    end
    LongC(Npic+1) =abscisse_s(end)-Long(Npic);
    if Npic == 1
        LongC(Npic+2) = 0;
    end    
    MaxCourbure = courbure(1);
    posiMaxCourbure = 1;
    for i =2:length(courbure)
       if courbure(i) > MaxCourbure
           MaxCourbure = courbure(i);
           posiMaxCourbure = i;
       end
    end
    
    catch
        LongC = zeros(1,3);
        posiMaxCourbure = 0;
    end
    
    Somduds = sum(duds);
    SomAbsduds = sum(abs(duds));
   
end
