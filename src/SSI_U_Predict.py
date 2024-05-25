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

# import pickle clf
with open(args_input_clf, mode='rb') as fp:
     clf = pickle.load(fp)

# test_X 読み込み
test_X = pd.read_csv(args_input_test)
# 実データのベクトルX
X = test_X.values

# predict
X_pre = clf.predict(X)

# save results
X_pre_df = pd.DataFrame(X_pre)
X_pre_df = X_pre_df.set_axis(['predict_value'], axis=1)
X_pre_df.to_csv(args_output_predict, index=False)