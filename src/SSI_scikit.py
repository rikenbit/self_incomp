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


# #### 次元削減後にモデル構築############################
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
# # PCA
# from sklearn.decomposition import PCA

# # データ読み込み
# x_csv = pd.read_csv("./output/SSI/x_r.csv")
# y_csv = pd.read_csv("./output/SSI/y_r.csv")

# # 実データのベクトルY
# y = y_csv["x"].values
# # 実データのベクトルX
# X = x_csv.values
# #### PCA####
# model_pca = PCA(n_components=8)
# X_PCA = model_pca.fit_transform(x_csv)
# ########

# # ランダムフォレスト
# clf = RandomForestClassifier(random_state=1234, n_estimators=1000)

# # LeaveOneOutの作成
# loocv = LeaveOneOut()

# # LOOCV
# # 時間計測開始
# time_sta = time.time()
# # score = cross_val_score(clf, X, y, cv=loocv)
# score = cross_val_score(clf, X_PCA, y, cv=loocv)
# # 時間計測終了
# time_end = time.time()
# # 経過時間（秒）
# tim = time_end- time_sta
# print(tim)

# # LOOCVの結果 https://panda-clip.com/loocv/
# print("{:.4f}".format(np.mean(score)))
# ################################################################

# #### Pycaret tutorial############################
# # https://zenn.dev/murakamixi/articles/9b7f63f6eb79ad
# # パッケージの読み込み
# import pandas as pd
# from pycaret.regression import *
# from pycaret.datasets import get_data

# data = get_data('boston')

# # PyCaretを起動
# exp1 = setup(data, target = 'medv', ignore_features = None)

# #　第一引数 : 読み込んだデータ
# #　第二引数 : 目的変数
# #　第三引数 : 除外する変数　（option）
# #　最後にnumeric_features　= ['カラム名']のような形で指定することでデータタイプを変更できます。

# # モデルの比較
# compare_models()
# ################################################################


# #### Pycaret tutorial 2 official############################
# # https://pycaret.gitbook.io/docs/get-started/functions/train
# # load dataset
# from pycaret.datasets import get_data
# diabetes = get_data('diabetes')

# # init setup
# from pycaret.classification import *
# clf1 = setup(data = diabetes, target = 'Class variable')

# # # init setup
# # from pycaret.classification import *
# # from sklearn.model_selection import LeaveOneOut
# # loocv = LeaveOneOut()
# # clf1 = setup(data = diabetes, target = 'Class variable', fold_strategy =loocv)

# # compare models
# best = compare_models()
# ################################################################

# #### 次元削減後にモデル構築&Pycaret############################
# import pandas as pd
# import numpy as np
# #ランダムフォレスト
# from sklearn.ensemble import RandomForestClassifier
# #ホールドアウトのimport
# from sklearn.model_selection import train_test_split
# #交差検証のimport
# from sklearn.model_selection import cross_val_score
# # #LeaveOneOutのimport
# # from sklearn.model_selection import LeaveOneOut
# # PCA
# from sklearn.decomposition import PCA
# # Pycaret
# from pycaret.classification import *

# # データ読み込み
# x_csv = pd.read_csv("./output/SSI/x_r.csv")
# y_csv = pd.read_csv("./output/SSI/y_r.csv")

# #### PCA####
# model_pca = PCA(n_components=8)
# X_PCA = model_pca.fit_transform(x_csv)
# ########
# #データフレームに変換して
# X =pd.DataFrame(X_PCA)
# # X_PCAとYを結合してデータフレームに
# XY = pd.concat([X, y_csv],axis='columns')

# # loocv = LeaveOneOut()
# # # Pycaret
# # clf1 = setup(data = XY, target = 'x', fold_strategy =loocv)
# clf1 = setup(data = XY, target = 'x')

# # compare models
# compare_models()
# df_compare_models = pull()

# df_compare_models.to_csv('output/SSI/compare_models.csv')
# ########################################################