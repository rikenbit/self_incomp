#### import####
import pandas as pd
import numpy as np
import sys
# LDA
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
#ホールドアウトのimport
from sklearn.model_selection import train_test_split
#交差検証のimport
from sklearn.model_selection import cross_val_score
#LeaveOneOutのimport
from sklearn.model_selection import LeaveOneOut
# PCA
from sklearn.decomposition import PCA

#### args setting####
args = sys.argv
args_input_x=args[1]
args_input_y=args[2]
args_output=args[3]
args_output_plot=args[4]
#### test args####
# args_input_x='output/X_Tensor/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv'
# args_input_y='output/SSI/y_r.csv'
# args_output='output/LOOCV_LDA/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv'
# args_output_plot='output/OneDim_LDA/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv'

# データ読み込み
x_csv = pd.read_csv(args_input_x)
y_csv = pd.read_csv(args_input_y)

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values

# LDA https://scikit-learn.org/stable/modules/generated/sklearn.discriminant_analysis.LinearDiscriminantAnalysis.html
clf = LinearDiscriminantAnalysis(n_components=1)

# LeaveOneOutの作成
loocv = LeaveOneOut()

# LOOCV
score = cross_val_score(clf, X, y, cv=loocv)

#### SSI_scikit_Predict.py####
# output score by csv
args_output_y_score=args_output.replace('LOOCV_LDA', 'y_score')

int_score = np.asarray(score, dtype = int)
list_score =list(int_score)

df = pd.DataFrame({'score':list_score})
df.to_csv(args_output_y_score)
###################

# args_output
with open(args_output, 'w') as f:
    print("{:.4f}".format(np.mean(score)), file=f)

# args_output_plot
trans_one_dim = clf.fit(X, y).transform(X)
np.savetxt(args_output_plot,trans_one_dim,delimiter=',')
