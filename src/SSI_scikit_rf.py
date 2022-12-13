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

#### args setting####
args = sys.argv
args_input_x=args[0]
args_input_y=args[1]
args_output=args[2]
# =args[]
#### test args####
args_input_x='./output/SSI/X_Tensor/Model1_AA10_Gene10_sL10_sR10.csv'
args_input_y='./output/SSI/y_r.csv'
args_output='./output/SSI/LOOCV_rf/model1_aa10_gene10_sL10_sR10.csv'

# データ読み込み
# x_csv = pd.read_csv("./output/SSI/x_r.csv")
# y_csv = pd.read_csv("./output/SSI/y_r.csv")
x_csv = pd.read_csv(args_input_x)
y_csv = pd.read_csv(args_input_y)

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values

# ランダムフォレスト
clf = RandomForestClassifier(random_state=1234, n_estimators=1000)

# LeaveOneOutの作成
loocv = LeaveOneOut()

# LOOCV
score = cross_val_score(clf, X, y, cv=loocv)

# LOOCVの結果 https://panda-clip.com/loocv/
# print("{:.4f}".format(np.mean(score)))

with open(args_output, 'w') as f:
    print("{:.4f}".format(np.mean(score)), file=f)
################################################################