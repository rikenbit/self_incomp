################【機械学習】ランダムフォレストを理解する################
# https://qiita.com/Hawaii/items/5831e667723b66b46fba#4いよいよ本題データ分割とランダムフォレスト
#### ####

#### package install####
# pip install pandas
import pandas as pd#pandasのインポート
import datetime#元データの日付処理のためにインポート
from sklearn.model_selection import train_test_split #データ分割用
from sklearn.ensemble import RandomForestClassifier #ランダムフォレスト

#### データ読み込み####
df = pd.read_csv("./data/test/ks-projects-201801.csv")

#### データ成形####
df['deadline'] = pd.to_datetime(df["deadline"])
df["launched"] = pd.to_datetime(df["launched"])
df["days"] = (df["deadline"] - df["launched"]).dt.days
# 行方向をフィルタリング by state列の値
df = df[(df["state"] == "successful") | (df["state"] == "failed")]
# state列を0/1に変換
df["state"] = df["state"].replace("failed",0)
df["state"] = df["state"].replace("successful",1)
# 不要な列の削除
df = df.drop(["ID","name","deadline","launched","backers","pledged","usd pledged","usd_pledged_real","usd_goal_real"], axis=1)
# カテゴリ変数処理
df = pd.get_dummies(df,drop_first = True)

#### データ分割####
# state列を削除
train_data = df.drop("state", axis=1)
# 実データのベクトルYに該当
y = df["state"].values
# 実データのベクトルXに該当
X = train_data.values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1234)

#### ランダムフォレスト####
# 数分かかる
clf = RandomForestClassifier(random_state=1234)
clf.fit(X_train, y_train)
print("score=", clf.score(X_test, y_test))
################################################################

####LOOCVについて解説&Pythonで実装する【機械学習入門8】################
# https://datawokagaku.com/loocv/
# pip install seaborn
import seaborn as sns
import numpy as np
df = sns.load_dataset('tips')
X = df['total_bill'].values.reshape(-1, 1)
y = df['tip'].values

from sklearn.model_selection import LeaveOneOut
loo = LeaveOneOut()
for train_index, test_index in loo.split(X):
    print("train index:", train_index, "test index:", test_index)

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import LeaveOneOut
loo = LeaveOneOut()
model = LinearRegression()
mse_list = []
for train_index, test_index in loo.split(X):
#     print("train index:", train_index, "test index:", test_index)
    # get train and test data
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = y[train_index], y[test_index]
    # fit model
    model.fit(X_train, y_train)
    # predict test data
    y_pred = model.predict(X_test)
    # loss
    mse = np.mean((y_pred - y_test)**2)
    mse_list.append(mse)
print(f"MSE(LOOCV): {np.mean(mse_list)}")
print(f"std: {np.std(mse_list)}")
################################################################

####【AIプログラミング】交差検証をもう少し学ぶ、LeaveOneOutCV###########
# https://panda-clip.com/loocv/

#LOOCV(LeaveOneOut CrossValidation)
from sklearn.datasets import load_iris
#ホールドアウトのimport
from sklearn.model_selection import train_test_split
#交差検証のimport
from sklearn.model_selection import cross_val_score
#LeaveOneOutのimport
from sklearn.model_selection import LeaveOneOut
#k-最近傍法のimport
from sklearn.neighbors import KNeighborsClassifier

import numpy as np

panda_box = load_iris()

X = panda_box.data
y = panda_box.target

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.5, stratify=y)

knc = KNeighborsClassifier(n_neighbors = 9)

#LeaveOneOutの作成
loocv = LeaveOneOut()

#LOOCVを行う。
score = cross_val_score(knc, X_train, y_train, cv=loocv)

#結果の表示
print("LOOCVの結果")
print(score)
print("LOOCVの平均")
print("{:.4f}".format(np.mean(score)))

#訓練をする
knc.fit(X_train, y_train)

#評価
print("{:.4f}".format(knc.score(X_test, y_test)))
################################################################
