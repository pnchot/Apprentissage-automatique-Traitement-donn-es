% % Parametres d'entree
E = 70*10^9;   %
G = 1130*10^6; %
% % D = 0.003;     %
% % F = 0.01;      % 
% % coeff_division_D2 = 10 ; %
% % indx_longeur_tube1 = 64; %


%% boucle de traitement

 % Parametres d'entrees en unite SI
    E = 70*10^9;   % Module d'Young en GPa
    G = 1130*10^6; % Module de cisaillement en GPa
    D = 0.003;     % Diametre exterieur du tube 1 en m
    F =[0.0001,0.01,0.25,0.50,0.75,1];  % Les differentes charges appliquees pour notre essai
    indx_longeur_tube1 = [50,64,72,88,100]; % Les indexes des differentes longueur choisit pour le tube 1 
    coeff_division_D2 = [10,20,30,40];      % coefficient de division du diametre interieur du tube 2 pour la variation des raideurs
    
    name_feuille = strcat('Modele_H_P_2_Tube_',datestr(now,1)); % concatenation dans le nom de la feuille modele plan/ hors plan et de la date du jour
    
    num_dossier = 0;       % Numero du dossier des bishop et solution traites
    num_ligne_fichier = 9; % Numero de la lige de debut d'enregistrement des valeurs dans le fichier genere
    
for i =1:5001 % Verifier la fin de l'indice pour les essais plan ou hors plan  

    for k=1:4  % Cette boucle peut etre retirer en fonction de si on travail sur un tube ou sur deux tubes 

        for j = 1:6
            solution_struc = load(['solution' num2str(i-1) '.mat']); % Choix du fichier solution a traiter rajouter: '_' num2str(num_dossier) avant '.mat' pour test plan
            bishop_struc = load(['bishop' num2str(i-1) '.mat']);     % Choix du fichier bishop a traiter rajouter: '_' num2str(num_dossier) avant '.mat' pour test plan
                                                                                              
            solution_name =['solution' ];
            bishopf_name = ['bishop' ];

            solution = solution_struc.(solution_name);
            bishopf = bishop_struc.(bishopf_name);

            donnees = etude_compliance(num_dossier,i-1,bishopf,solution,E,E,G,G,D,F(j),coeff_division_D2(4),indx_longeur_tube1(k)); % Le changement des indexes pour faire varier soit la raideur soit les longeurs
            no_erreur = xlswrite('C:\Users\Denis\Documents\STAGE_ETUDE_COMPLIANCE\CODES\compliance_code\compliance_code\Traitements Donnees\txt_hors_plan\test_etude_compliance_2_tube_hors_plan_longueur_raideurs_40_test_auto.xlsx',donnees,...
                name_feuille,['A' num2str(num_ligne_fichier+j) ':AE' num2str(num_ligne_fichier+j)]); % Le dernier numero correspond au dossier plane config 
         end

         num_ligne_fichier = num_ligne_fichier + 6;

    end

end 