#### import####
import pandas as pd
import numpy as np
import sys
#ランダムフォレスト
from sklearn.ensemble import RandomForestClassifier
# PCA
from sklearn.decomposition import PCA

#### args setting####
args = sys.argv
args_input_x=args[1]
args_input_y=args[2]
args_input_x_test=args[3]
args_input_dim=args[4]
args_output=args[5]
#### test args####
args_input_dim=int(args_input_dim)

#### train data####
# データ読み込み
x_csv = pd.read_csv(args_input_x)
y_csv = pd.read_csv(args_input_y)
# 実データのベクトルX
X_train = x_csv.values
# 実データのベクトルY
y_train = y_csv["x"].values

#### test data####
x_test_csv = pd.read_csv(args_input_x_test)
# 実データのベクトルX
X_test = x_test_csv.values


#### sci-kit learn####
pca = PCA(n_components=args_input_dim)  # 主成分の数を適切に設定
clf = RandomForestClassifier(random_state=1234, n_estimators=1000)
predicts = [] #予測結果格納

# 訓練データ・PCA
X_train_pca = pca.fit_transform(X_train)

#### 射影&予測####
X_test_pca = pca.transform(X_test)
clf.fit(X_train_pca, y_train)
y_pred = clf.predict(X_test_pca)

# save results
X_pre_df = pd.DataFrame(y_pred)
X_pre_df = X_pre_df.set_axis(['predict_value'], axis=1)
X_pre_df.to_csv(args_output, index=False)