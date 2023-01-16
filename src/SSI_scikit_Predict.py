#!/usr/bin/python
# -*- coding: utf-8 -*-

#### import####
import pandas as pd
import numpy as np
import sys
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import LeaveOneOut
from sklearn.decomposition import PCA

#### args setting####
args = sys.argv
args_input_x=args[1]
args_input_y=args[2]
args_output=args[3]
#### test args####
# args_input_x='output/X_Tensor/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv'
# args_input_y='output/SSI/y_r.csv'
# args_output='output/y_score/MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20.csv'

# ¥Ç©`¥¿Õi¤ßÞz¤ß
x_csv = pd.read_csv(args_input_x)
y_csv = pd.read_csv(args_input_y)

# Œg¥Ç©`¥¿¤Î¥Ù¥¯¥È¥ëY
y = y_csv["x"].values
# Œg¥Ç©`¥¿¤Î¥Ù¥¯¥È¥ëX
X = x_csv.values

# ¥é¥ó¥À¥à¥Õ¥©¥ì¥¹¥È
clf = RandomForestClassifier(random_state=1234, n_estimators=1000)

# LeaveOneOut¤Î×÷³É
loocv = LeaveOneOut()
# LOOCV
score = cross_val_score(clf, X, y, cv=loocv)

# output score by csv
int_score = np.asarray(score, dtype = int)
list_score =list(int_score)

df = pd.DataFrame({'score':list_score})
df.to_csv(args_output)