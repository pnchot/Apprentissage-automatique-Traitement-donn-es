clear 
close all
%% Parametres d'entrees en unite SI
    E = 70*10^9;   % Module d'Young en GPa
    G = 1130*10^6; % Module de cisaillement en GPa
    D = 0.003;     % Diametre exterieur du tube 1 en m
    F =[0.0001,0.01,0.25,0.50,0.75,1];  % Les differentes charges appliquees pour notre essai
    indx_longeur_tube1 = [50,64,72,88,100]; % Les indexes des differentes longueur choisit pour le tube 1 
    coeff_division_D2 = [10,20,30,40];      % coefficient de division du diametre interieur du tube 2 pour la variation des raideurs
    
    name_feuille = strcat('Modele_Random_Tube_',datestr(now,1)); % concatenation dans le nom de la feuille modele plan/ hors plan et de la date du jour
    
    num_dossier = 0;       % Numero du dossier des bishop et solution traites
    num_ligne_fichier = 2; % Numero de la lige de debut d'enregistrement des valeurs dans le fichier genere
%% boucle de traitement

for i =1:5000 % Verifier la fin de l'indice pour les essais plan ou hors plan  

            solution_struc = load(['solution' num2str(i-1) '.mat']); % Choix du fichier solution a traiter rajouter: '_' num2str(num_dossier) avant '.mat' pour test plan
            bishop_struc = load(['bishop' num2str(i-1) '.mat']);     % Choix du fichier bishop a traiter rajouter: '_' num2str(num_dossier) avant '.mat' pour test plan
                                                                                              
            solution_name =['solution']; % Choix du fichier solution a traiter rajouter: '_' num2str(num_dossier) pour test plan
            bishopf_name = ['bishop' ];   % Choix du fichier solution a traiter rajouter: '_' num2str(num_dossier) pour test plan
            
            solution_name_mat = ['solution' num2str(i-1) '.mat'];
            bishopf_name_mat  = ['bishop' num2str(i-1) '.mat'];

            solution = solution_struc.(solution_name);
            bishopf = bishop_struc.(bishopf_name);

            donnees = metrique_totale_courbe_addm(num_dossier,i-1,bishopf,solution,E,0,G,0,D,F(1),coeff_division_D2(1),indx_longeur_tube1(1),bishopf_name_mat,solution_name_mat); % Le changement des indexes pour faire varier soit la raideur soit les longeurs
            no_erreur = xlswrite('C:\Users\Denis\Documents\STAGE_ETUDE_COMPLIANCE\CODES\compliance_code\compliance_code\Traitements Donnees\Configuration_dapprantissage\metrique_courbe_random_1_tube_torsion.xlsx',donnees,...
                name_feuille,['A' num2str(num_ligne_fichier + i) ':D' num2str(num_ligne_fichier+i)]); % Le dernier numero correspond au dossier plane config 
end 