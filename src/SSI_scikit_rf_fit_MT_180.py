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

import pickle

#### args setting####
args = sys.argv
args_input_x = args[1]
args_input_y = args[2]
args_output_fit = args[3]


# データ読み込み
x_csv = pd.read_csv(args_input_x)
y_csv = pd.read_csv(args_input_y)

# drop pullout_row pythonは0がスタート行
# pullout_row=int(pullout_row)
# y_csv = y_csv.drop(pullout_row-1, axis=0)

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values

# ランダムフォレスト
clf = RandomForestClassifier(random_state=1234, n_estimators=1000)
# モデルをトレーニングする
clf.fit(X, y)

# https://blog.amedama.jp/entry/2018/05/08/033909
# 学習済みモデルを保存
with open(args_output_fit, mode='wb') as fp:
     pickle.dump(clf, fp)
