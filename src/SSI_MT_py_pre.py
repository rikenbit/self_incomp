
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
# 正解率 (Accuracy) https://pythondatascience.plavox.info/scikit-learn/%E5%88%86%E9%A1%9E%E7%B5%90%E6%9E%9C%E3%81%AE%E3%83%A2%E3%83%87%E3%83%AB%E8%A9%95%E4%BE%A1
from sklearn.metrics import accuracy_score
#### args setting####
args = sys.argv
args_input_x=args[1]
args_input_y=args[2]
args_input_dim=args[3]
args_output=args[4]
#### test args####
# args_input_x='output/MT_py_X/matrix/X_180_LR.csv'
# args_input_y='output/y_r.csv'
# args_input_dim='10'
# args_output='output/MT_py_X/accuracy/Model-PCA_5.csv'

args_input_dim=int(args_input_dim)
# データ読み込み
x_csv = pd.read_csv(args_input_x)
y_csv = pd.read_csv(args_input_y)

# 実データのベクトルX
X = x_csv.values
# 実データのベクトルY
y = y_csv["x"].values

#### sci-kit learn####
loo = LeaveOneOut()
pca = PCA(n_components=args_input_dim)  # 主成分の数を適切に設定
clf = RandomForestClassifier(random_state=1234, n_estimators=1000)
accuracies = [] # 各試行（180回）の正解 or 不正解を格納

for train_index, test_index in loo.split(X): # LOOCVを全180行に対して実行
    X_train, X_test = X[train_index], X[test_index]
    y_train, y_test = y[train_index], y[test_index]
    X_train_pca = pca.fit_transform(X_train)
    X_test_pca = pca.transform(X_test)
    clf.fit(X_train_pca, y_train)
    y_pred = clf.predict(X_test_pca)
    acc = accuracy_score(y_test, y_pred) 
    accuracies.append(acc)

average_accuracy = sum(accuracies) / len(accuracies) # 精度 (Precision)
print(f"Average Accuracy: {average_accuracy:.4f}")
########
# average_accuracyの値をデータフレームに変換
df = pd.DataFrame([average_accuracy], columns=['Average Accuracy'])

# データフレームをCSVファイルとして出力
df.to_csv(args_output, index=False)
