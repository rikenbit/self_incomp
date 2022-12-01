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

#### トレーニング####
# sklearnを使ってみる1 https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.OneHotEncoder.html
# sklearnを使ってみる2 https://kagglenote.com/ml-tips/onehotencoder-sklearn-vs-pandas/

#### 単体テスト1####
## ヘッダー1つの1文字の.faファイルを読み込み
## ヘッダー1つの1文字の.faファイルを変換
## ヘッダー1つの10文字の.faファイルを読み込み
## ヘッダー1つの10文字の.faファイルを変換

#### 単体テスト2####
## ヘッダー2つの1文字の.faファイルを読み込み
## ヘッダー2つの1文字の.faファイルを変換
## ヘッダー2つの10文字の.faファイルを読み込み
## ヘッダー2つの10文字の.faファイルを変換

#### 単体テスト3####
## ヘッダー2つの1文字の.faファイルを行列に変換
## ヘッダー2つの10文字の.faファイルを行列に変換

#### 結合テスト####
## test.faを読み込み
## test.faを変換
## test.faを行列に変換
## One-hot Vectorの行列をcsvで保存

#### 総合テスト####