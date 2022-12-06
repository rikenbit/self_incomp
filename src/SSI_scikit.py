# #### default#########
# import pandas as pd
# import numpy as np
# #ランダムフォレスト
# from sklearn.ensemble import RandomForestClassifier
# #ホールドアウトのimport
# from sklearn.model_selection import train_test_split
# #交差検証のimport
# from sklearn.model_selection import cross_val_score
# #LeaveOneOutのimport
# from sklearn.model_selection import LeaveOneOut

# # データ読み込み
# x_csv = pd.read_csv("./output/SSI/x_r.csv")
# y_csv = pd.read_csv("./output/SSI/y_r.csv")

# # 実データのベクトルY
# y = y_csv["x"].values
# # 実データのベクトルX
# X = x_csv.values


# # ランダムフォレスト
# clf = RandomForestClassifier(random_state=1234)

# # LeaveOneOutの作成
# loocv = LeaveOneOut()

# # LOOCV
# score = cross_val_score(clf, X, y, cv=loocv)

# # LOOCVの結果 https://panda-clip.com/loocv/
# print("{:.4f}".format(np.mean(score)))
# ################################################################

# #### ハイパラ選定：RandomForestClassifier############################
# import pandas as pd
# import numpy as np
# #ランダムフォレスト
# from sklearn.ensemble import RandomForestClassifier
# #ホールドアウトのimport
# from sklearn.model_selection import train_test_split
# #交差検証のimport
# from sklearn.model_selection import cross_val_score
# #LeaveOneOutのimport
# from sklearn.model_selection import LeaveOneOut

# # データ読み込み
# x_csv = pd.read_csv("./output/SSI/x_r.csv")
# y_csv = pd.read_csv("./output/SSI/y_r.csv")

# # 実データのベクトルY
# y = y_csv["x"].values
# # 実データのベクトルX
# X = x_csv.values


# # ランダムフォレスト
# clf = RandomForestClassifier(random_state=1234, n_estimators=1000)

# # LeaveOneOutの作成
# loocv = LeaveOneOut()

# # LOOCV
# # 時間計測開始
# time_sta = time.time()
# score = cross_val_score(clf, X, y, cv=loocv)
# # 時間計測終了
# time_end = time.time()
# # 経過時間（秒）
# tim = time_end- time_sta
# print(tim)

# # LOOCVの結果 https://panda-clip.com/loocv/
# print("{:.4f}".format(np.mean(score)))
# ################################################################


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
x_csv = pd.read_csv("./output/SSI/x_r.csv")
y_csv = pd.read_csv("./output/SSI/y_r.csv")

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values
#### PCA####
model_pca = PCA(n_components=5)
X_PCA = model_pca.fit_transform(x_csv)
########

# ランダムフォレスト
clf = RandomForestClassifier(random_state=1234, n_estimators=1000)

# LeaveOneOutの作成
loocv = LeaveOneOut()

# LOOCV
# 時間計測開始
time_sta = time.time()
# score = cross_val_score(clf, X, y, cv=loocv)
score = cross_val_score(clf, X_PCA, y, cv=loocv)
# 時間計測終了
time_end = time.time()
# 経過時間（秒）
tim = time_end- time_sta
print(tim)

# LOOCVの結果 https://panda-clip.com/loocv/
print("{:.4f}".format(np.mean(score)))
################################################################
