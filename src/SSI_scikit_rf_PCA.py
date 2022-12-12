#### 次元削減後にモデル構築############################
import pandas as pd
import numpy as np
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

# データ読み込み
# x_csv = pd.read_csv("./output/SSI/x_r.csv")
x_csv = pd.read_csv("./output/SSI/x_s_r.csv")
y_csv = pd.read_csv("./output/SSI/y_r.csv")

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values
#### PCA####
model_pca = PCA(n_components=8)
X_PCA = model_pca.fit_transform(x_csv)
########

# ランダムフォレスト
clf = RandomForestClassifier(random_state=1234, n_estimators=1000)

# LeaveOneOutの作成
loocv = LeaveOneOut()

# LOOCV
score = cross_val_score(clf, X_PCA, y, cv=loocv)

# LOOCVの結果 https://panda-clip.com/loocv/
print("{:.4f}".format(np.mean(score)))
################################################################