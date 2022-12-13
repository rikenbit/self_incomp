#### 次元削減後にモデル構築&Pycaret############################
import pandas as pd
import numpy as np
#ランダムフォレスト
from sklearn.ensemble import RandomForestClassifier
#ホールドアウトのimport
from sklearn.model_selection import train_test_split
#交差検証のimport
from sklearn.model_selection import cross_val_score
# #LeaveOneOutのimport
# from sklearn.model_selection import LeaveOneOut
# PCA
from sklearn.decomposition import PCA
# Pycaret
from pycaret.classification import *

# データ読み込み
x_csv = pd.read_csv("./output/SSI/x_r.csv")
# x_csv = pd.read_csv("./output/SSI/x_s_r.csv")
y_csv = pd.read_csv("./output/SSI/y_r.csv")

#### PCA####
model_pca = PCA(n_components=8)
X_PCA = model_pca.fit_transform(x_csv)
########
#データフレームに変換して
X =pd.DataFrame(X_PCA)
# X_PCAとYを結合してデータフレームに
XY = pd.concat([X, y_csv],axis='columns')

# loocv = LeaveOneOut()
# # Pycaret
# clf1 = setup(data = XY, target = 'x', fold_strategy =loocv)
clf1 = setup(data = XY, target = 'x')

# compare models
compare_models()
df_compare_models = pull()

df_compare_models.to_csv('output/SSI/compare_models.csv')
# df_compare_models.to_csv('output/SSI/compare_models_randamX.csv')
########################################################