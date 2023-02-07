#### import####
import pandas as pd
import numpy as np
import sys
#ランダムフォレスト
from sklearn.ensemble import RandomForestClassifier
#ホールドアウトのimport
from sklearn.model_selection import train_test_split
#交差検証のimport
from sklearn.model_selection import cross_val_score
#LeaveOneOutのimport
from sklearn.model_selection import LeaveOneOut
# PCA
from sklearn.decomposition import PCA
# save pickle
import pickle

#### args setting####
args = sys.argv
args_input_clf=args[1]
args_input_test=args[2]
args_output_predict=args[3]
#### test args####
# args_input_clf='output/train_X/fit/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.pickle'
# args_input_test='output/test_X/tensor/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv'
# args_output_predict='output/test_X/predict/MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv'

# import pickle clf
with open(args_input_clf, mode='rb') as fp:
     clf = pickle.load(fp)

# test_X 読み込み
test_X = pd.read_csv(args_input_test)
# 実データのベクトルX
X = test_X.values

X_pre = clf.predict(X)
X_pre_df = pd.DataFrame(X_pre)
X_pre_df = X_pre_df.set_axis(['predict_value'], axis=1)
# save
X_pre_df.to_csv(args_output_predict, index=False)