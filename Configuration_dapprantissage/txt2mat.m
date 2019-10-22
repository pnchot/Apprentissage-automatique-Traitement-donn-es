function [] = txt2mat(nombre_de_fichier)
% Le nombre de fichier + 1 
    for i =1:nombre_de_fichier

        %solution_struc = load([num2str(0) '_solution.txt']);
        solution_name =[num2str(i-1) '_solution.txt' ];

        %bishop_struc = load([num2str(0) '_bishop.txt']); 
        bishopf_name = [num2str(i-1) '_bishop.txt' ];


        %bishopf = bishop_struc.(bishopf_name);
        bishop = importdata(bishopf_name);
        save(['bishop' num2str(i-1) '.mat'],'bishop');

        %solution = solution_struc.(solution_name);
        solution = importdata(solution_name);
        save('solution.mat','solution');

        filename = {'solution.mat'};
        data = cell(3,1);
        var = load(filename{1});

        data{1} = var.solution(1,:);
        data{2} = var.solution(14,:);
        data{3} = var.solution(15,:);

        solution = cell2mat(data);
        save(['solution' num2str(i-1) '.mat'],'solution');

        delete solution.mat
        clear 
    end