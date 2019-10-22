import sys
import pandas as pd
import matplotlib
import numpy as np 
import scipy as sp
import sklearn 
import random
import time 

import seaborn as sns 
import matplotlib.pyplot as plt

import warnings
from subprocess import check_output
from sklearn.cross_validation import train_test_split
from sklearn.cross_validation import cross_val_score
from sklearn import datasets
from sklearn import svm
from sklearn import ensemble,gaussian_process
from sklearn.metrics import mean_squared_error
from sklearn.metrics import r2_score
from sklearn.metrics import mean_absolute_error

def correlation_heatmap(df,corrtype='spearman'):
	_ , ax = plt.subplots(figsize =(14, 12))
	colormap = sns.diverging_palette(220, 10, as_cmap = True)

	_ = sns.heatmap(
		df.corr(method =corrtype), 
		cmap = colormap,
		square=True,
		cbar_kws={'shrink':.9 },
		ax=ax,
		annot=True,
		linewidths=0.1,vmax=1.0, linecolor='white',
		annot_kws={'fontsize':12 }
		)
	plt.title(corrtype + ' Correlation of Features', y=1.05, size=15)

random.seed(None)

filename = 'Modele_Random_Tube_12-Aug-2019.csv'
filename1 = 'Modele_Random_Tube_19-Aug-2019.csv'
donnees_entrees_nouvelles_metriques =pd.read_csv(filename1)

donnees_entrees = pd.read_csv (filename)

# donnees_entrees.columns = ['Numero_de_dossier','fichier_solution','Charge_en_N','Max','Inter','Min','Tang','Tube_1','Tube_2','Aire_proj','Dist_maxi','Intersec_Plan','Nombre_pic_derive_ux','Long_courbure_1_ux','Long_courbure_2_ux','Long_courbure_3_ux','Pos_courbure_maxi_ux','Nombre_pic_derive_uy','Long_courbure_1_uy','Long_courbure_2_uy','Long_courbure_3_uy','Pos_courbure_maxi_uy','k_1','k_2',
# 'SomResidu','SomDistAxe','SSE','RMSE','RSQUARE','SomUx','SomUy','SomdUxds','SomdUyds','SomU','SomAbsUx','SomAbsUy','SomAbsdUxds','SomAbsdUyds','SomAbsU','Max_ux','Min_ux','Std_ux','Max_uy','Min_uy','Std_uy','Max_u','Min_u','Std_u','RootSqUxUy']

donnees_entrees ['Ratio_Max_Min'] =  donnees_entrees.Max/donnees_entrees.Min


donnees_de_travail_ameliore = donnees_entrees[['SomUx','SomUy','SomdUxds','SomdUyds',
'SomAbsUx','SomAbsUy','SomAbsdUxds','SomAbsdUyds','SomAbsU','Max_ux','Min_ux','Std_ux',
'Max_uy','Min_uy','Std_uy','Max_u','Min_u','Std_u','RootSqUxUy','Aire_proj','Tube_2',
'Dist_maxi','Nombre_pic_derive_ux','SomResidu','SSE','RSQUARE','Pos_courbure_maxi_uy','Ratio_Max_Min']]

# ###################################################
# ########## AJOUT METRIQUE #########################

# nouvelles_metriques = donnees_entrees_nouvelles_metriques[['SomAbsTorsion','SomTorsion']]
# donnees_de_travail_ameliore_reindexe = donnees_de_travail_ameliore.reset_index(drop=True)

# donnees_de_travail = pd.concat([ nouvelles_metriques, donnees_de_travail_ameliore_reindexe], axis=1, join='outer') 


data_train_donnees_de_travail_ameliore = donnees_de_travail_ameliore[0:4500]
# data_test_donnees_de_travail_ameliore = donnees_de_travail[4500:5000]


# fig3 = plt.figure(3)
# correlation_heatmap(donnees_de_travail)


####################################################
########### TRAIN TEST SPLIT #######################
####################################################
feature_names = ['SomUx','SomUy','SomdUxds','SomdUyds',
'SomAbsUx','SomAbsUy','SomAbsdUxds','SomAbsdUyds','SomAbsU','Max_ux','Min_ux','Std_ux',
'Max_uy','Min_uy','Std_uy','Max_u','Min_u','Std_u','RootSqUxUy','Aire_proj','Tube_2',
'Dist_maxi','Nombre_pic_derive_ux','SomResidu','SSE','RSQUARE','Pos_courbure_maxi_uy']

features = data_train_donnees_de_travail_ameliore.iloc[:,:-1]

labels = data_train_donnees_de_travail_ameliore.Ratio_Max_Min

X =[]

for index,row in  features.iterrows():
    X.append(list(row)) 

y = list(labels)

X_train,X_test,y_train,y_test = train_test_split(X,y,test_size = 0.25)


a = np.where(np.isnan(X_train))
if a[0] != []:
	print(a[0][0])
	print(len(X_train))
	print(X_train[a[0][0]])
	del X_train[a[0][0]]
	del y_train[a[0][0]]
	print(len(X_train))
	print(len(y_train))

b = np.where(np.isnan(X_test))
if b[0] != []:
	print(b[0][0])
	print(len(X_test))
	print(X_test[b[0][0]])
	del X_test[b[0][0]]
	del y_test[b[0][0]]
	print(len(X_test))
	print(len(y_test))

scores = []
for k in range(3):
	
	# Choix de l'algo d'apprentissage
	random.seed()
	# Parametres 
	#params = {'n_estimators':1000, 'max_depth':8, 'learning_rate':0.09, 'loss':'lad', 'alpha':0.95}
	params = {'n_estimators':2500, 'max_features':None,'max_depth':None,'min_samples_split':2,'oob_score':True}
	# Modele 
	clf = ensemble.RandomForestRegressor(**params)#GradientBoostingRegressor(**params)#
	
	start_time = time.time()
	# Apprentissage 
	clf.fit(X_train, y_train) 

	intervale_time = time.time()-start_time

	#Valeurs prédite après apprentissage
	y_pred = clf.predict(X_test)

	# Erreur y_test à chaque iterations 
	# erreur_ytest = []
	# for i,y_pre in enumerate(clf.staged_predict(X_test)):
	# 	erreur_ytest.append(clf.loss_(y_test,y_pre))

	# Erreur y_train à chaque iterations
	#erreur_ytrain = clf.train_score_ # pour un GradientBoosting
	
	# affichages 

	plt.figure()
	plt.scatter(y_test,y_pred, label = 'valeurs prédites')
	plt.plot(y_test,y_test, label = 'valeurs attendues')
	plt.yscale('log')
	plt.xscale('log')
	plt.xlabel('Valeurs réelles')
	plt.ylabel('Valeurs prédites')
	plt.legend()

# 	#########################################################
	
	# Plot feature importance
	feature_importance = clf.feature_importances_
	
	# make importances relative to max importance
	feature_importance = 100.0 * (feature_importance / feature_importance.max())
	sorted_idx = np.argsort(feature_importance)
	feature_names_sorted =[]
	for i in sorted_idx:
		feature_names_sorted.append(feature_names[i])
	pos = np.arange(sorted_idx.shape[0]) + .5

	plt.figure()
	plt.barh(pos, feature_importance[sorted_idx], align='center')
	plt.yticks(pos, feature_names_sorted)
	plt.xlabel('Relative Importance')
	plt.title('Variable Importance')
	plt.show()
	
	erreur_absolu =[]
	for m in range(len(y_test)):
		erreur_absolu.append(abs(y_pred[m]-y_test[m]))
	plt.figure()
	plt.hist(erreur_absolu, normed = False,bins=10,label='Erreurs absolus')
	plt.legend()
	plt.xlabel('Erreurs absolus')
	plt.ylabel('Effectifs')
	plt.title('Erreur absolu de prédiction')

	erreur_relative = []

	for j in range(len(y_test)):
		erreur_relative.append(abs(y_pred[j]-y_test[j])/y_test[j])
	plt.figure()
	plt.hist(erreur_relative,label='Erreur relative')
	plt.yscale('log')
	plt.xlabel('Erreus relative de prédiction')
	plt.ylabel('Effectifs')
	plt.title('Modèle RandomForestRegressor')
	################################################
	############### CALCUL DES ERREURS #############
	
	square_error = []
	for j in range(len(y_test)):
		square_error.append((y_pred[j]-y_test[j])**2)
	sse = sum(square_error)

	mae =  mean_absolute_error(y_test,y_pred)

	rmse = mean_squared_error(y_test,y_pred)

	r_square = r2_score(y_test,y_pred)

	oob_score = clf.oob_score_ # Pour RandomForestRegressor 

	# performances = pd.DataFrame({'Temps Apprentissage':intervale_time,'RMSE': rmse, 'R-SQUARE':r_square,'SSE':sse},index =[1])
	if k == 0:
		performances = pd.DataFrame({'Temps Apprentissage':intervale_time,'RMSE': rmse, 'R-SQUARE':r_square,'SSE':sse,'OOB':oob_score},index =[k])
	else:
		performances.loc[k] = [oob_score, r_square, rmse, sse, intervale_time]

print(performances)