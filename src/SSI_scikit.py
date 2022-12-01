# # test
# from fasta_one_hot_encoder import FastaOneHotEncoder
# encoder = FastaOneHotEncoder(
#     nucleotides = "acgt",
#     lower = True,
#     sparse = False,
#     handle_unknown="ignore"
# )
# path = "data/test.fa"
# encoder.transform_to_df(path, verbose=True).to_csv(
#     "output/my_result.csv"
# )
# sklearnを使ってみる1 https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html
# sklearnを使ってみる2 https://kagglenote.com/ml-tips/onehotencoder-sklearn-vs-pandas/

# #### package install####
# # pip install pandas
# import pandas as pd #pandasのインポート
# import numpy as np
# import datetime#元データの日付処理のためにインポート
# from sklearn.model_selection import train_test_split #データ分割用
# from sklearn.ensemble import RandomForestClassifier #ランダムフォレスト

# #### load X####
# # csvdata = pd.read_csv("./output/SSI/x_r.csv")
# # csvdata = pd.read_csv("./output/SSI/x_r.csv", skiprows=1)
# # pprint.pprint(vars(x_csv))
# x_csv = pd.read_csv("./output/SSI/x_r.csv")


# #### load Y####
# # csvdata = pd.read_csv("./output/SSI/x_r.csv", skiprows=1)
# # pprint.pprint(vars(y_csv))
# y_csv = pd.read_csv("./output/SSI/y_r.csv")


# #### CSVから読んだデータをnumpyの行列に入れる####
# # 参考 https://qiita.com/airnanasi_qiita/items/337656cf520de711717e
# #空のオブジェクト
# x_array = np.array
# y_array = np.array
# # 値代入
# x_array = x_csv.values
# y_array = y_csv.values

# ################【機械学習】ランダムフォレストを理解する################
# # https://qiita.com/Hawaii/items/5831e667723b66b46fba#4いよいよ本題データ分割とランダムフォレスト
# # pip install pandas
# import pandas as pd #pandasのインポート
# import numpy as np
# from sklearn.model_selection import train_test_split #データ分割用
# from sklearn.ensemble import RandomForestClassifier #ランダムフォレスト

# #### データ読み込み####
# x_csv = pd.read_csv("./output/SSI/x_r.csv")
# y_csv = pd.read_csv("./output/SSI/y_r.csv")

# # 実データのベクトルYに該当
# # y = y_csv.values
# y = y_csv["x"].values
# # 実データのベクトルXに該当
# X = x_csv.values

# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1234, stratify=y)

# #### ランダムフォレスト####
# clf = RandomForestClassifier(random_state=1234)
# clf.fit(X_train, y_train)
# print("score=", clf.score(X_test, y_test))
# ################################################################

####【機械学習】ランダムフォレストを理解する &【AIプログラミング】#########
# package install
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

# データ読み込み
x_csv = pd.read_csv("./output/SSI/x_r.csv")
y_csv = pd.read_csv("./output/SSI/y_r.csv")

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values

# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=1234, stratify=y) # LOOCV 0.4753 test 0.3889
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1234, stratify=y) # LOOCV 0.4583 test 0.3333
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1234, stratify=y) # LOOCV 0.4762 test 0.3889
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.6, random_state=1234, stratify=y) # LOOCV 0.3611 test 0.4444
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.9, random_state=1234, stratify=y) # LOOCV 0.3889 test 0.5000

# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1234)             # LOOCV 0.333 test 0.5159


# ランダムフォレスト
clf = RandomForestClassifier(random_state=1234)

# LeaveOneOutの作成
loocv = LeaveOneOut()
###########↑↑↑↑ここまで動くの確認済み↑↑↑↑#########
# LOOCVを行う。
score = cross_val_score(clf, X_train, y_train, cv=loocv)

# 訓練をする
clf.fit(X_train, y_train)

# fit結果
# print("score=", clf.score(X_test, y_test))
print("{:.4f}".format(clf.score(X_test, y_test)))

# LOOCVの結果 https://panda-clip.com/loocv/
print("{:.4f}".format(np.mean(score)))

# LOOCVで評価するなら、実際に予測モデルを構築する際は全データ使ったら？
################################################################


####暫定版#########
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

# データ読み込み
x_csv = pd.read_csv("./output/SSI/x_r.csv")
y_csv = pd.read_csv("./output/SSI/y_r.csv")

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1234, stratify=y) # LOOCV 0.4762 test 0.3889
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=1234, stratify=y) # LOOCV 0.4753 test 0.3889
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=1234, stratify=y) # LOOCV 0.4583 test 0.3333
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1234, stratify=y) # LOOCV 0.4762 test 0.3889
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.6, random_state=1234, stratify=y) # LOOCV 0.3611 test 0.4444
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.9, random_state=1234, stratify=y) # LOOCV 0.3889 test 0.5000

# ランダムフォレスト
clf = RandomForestClassifier(random_state=1234)

# LeaveOneOutの作成
loocv = LeaveOneOut()

# LOOCV
score = cross_val_score(clf, X_train, y_train, cv=loocv)

# 訓練
clf.fit(X_train, y_train)

# test結果
print("{:.4f}".format(clf.score(X_test, y_test)))

# LOOCVの結果 https://panda-clip.com/loocv/
print("{:.4f}".format(np.mean(score)))
################################################################

####訓練データ全部使う#########
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

# データ読み込み
x_csv = pd.read_csv("./output/SSI/x_r.csv")
y_csv = pd.read_csv("./output/SSI/y_r.csv")

# 実データのベクトルY
y = y_csv["x"].values
# 実データのベクトルX
X = x_csv.values


# ランダムフォレスト
clf = RandomForestClassifier(random_state=1234)

# LeaveOneOutの作成
loocv = LeaveOneOut()

# LOOCV
score = cross_val_score(clf, X, y, cv=loocv)

# LOOCVの結果 https://panda-clip.com/loocv/
print("{:.4f}".format(np.mean(score)))
################################################################
