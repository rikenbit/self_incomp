# SSI_MT_nwTensor
###################################################
#### import####
import itertools as it
import numpy as np
import pandas as pd
from snakemake.utils import min_version
from snakemake.utils import Paramspace

# N_row
pullout_row = list(map(str, range(1, 181)))

# r1をcommon_dimsのA1, r2をcommon_dimsのA2, に使う
# r1Lを common_iteration-A1  r1Rをcommon_iteration-A2, に使う
# r2Lを common_coretypeに使う
list_LOOCV = [
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_30_r1R_30_r2L_Tucker_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_1_r1R_1_r2L_Tucker_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_1_r1R_30_r2L_Tucker_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_30_r1R_1_r2L_Tucker_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_30_r1R_30_r2L_CP_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_1_r1R_1_r2L_CP_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_1_r1R_30_r2L_CP_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-nwTensor_r1_20_r2_20_r3_xx_r1L_30_r1R_1_r2L_CP_r2R_xx_r3L_xx_r3R_xx'
]

list_join = list(it.product(list_LOOCV,pullout_row))
list_LOOCV_row = ['_row_'.join(v) for v in list_join]


df_Series= pd.Series(list_LOOCV_row)
df = df_Series.str.split('_', expand=True)
df = df.iloc[:,1::2]
df_test=df.set_axis(['MODELS','r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R', 'row'], axis=1)
paramspace = Paramspace(df_test, filename_params=['MODELS', 'r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R', 'row'], param_sep="_")


rule all:
    input:
        expand('output/nwTensor/test_X/predict/{params}.csv', params = paramspace.instance_patterns)

rule preprocess_train:
    input:
        'data/multi_align_gap/sp11alnfinal90seq.aln',
        'data/multi_align_gap/SRKfinal_90seq.aln'
    output:
        'data/train_Tensors.RData'
    resources:
        mem_gb=50
    benchmark:
        'benchmarks/preprocess_train.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    log:
        'logs/preprocess_train.log'
    shell:
        'src/preprocess_train.sh {input} {output} >& {log}'

rule train_u_models:
    input:
        'data/train_Tensors.RData'
    output:
        expand('output/nwTensor/train_X/tensor/{params}.RData', params = paramspace.wildcard_pattern),
        expand('output/nwTensor/train_X/tensor/{params}.csv', params = paramspace.wildcard_pattern),
        expand('output/nwTensor/train_X/one_slice_tensor/{params}.RData', params = paramspace.wildcard_pattern)
    params:
        args0 = lambda w: w["MODELS"],
        args1 = lambda w: w["r1"],
        args2 = lambda w: w["r2"],
        args3 = lambda w: w["r3"],
        args4 = lambda w: w["r1L"],
        args5 = lambda w: w["r1R"],
        args6 = lambda w: w["r2L"],
        args7 = lambda w: w["r2R"],
        args8 = lambda w: w["r3L"],
        args9 = lambda w: w["r3R"],
        args10 = lambda w: w["row"]
    benchmark:
        f'benchmarks/nwTensor/train_X/tensor/{paramspace.wildcard_pattern}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        f'logs/nwTensor/train_X/tensor/{paramspace.wildcard_pattern}.log'
    shell:
        'src/train_{params.args0}.sh {params.args1} {params.args2} {params.args3} {params.args4} {params.args5} {params.args6} {params.args7} {params.args8} {params.args9} {params.args10} {input} {output}  >& {log}'

rule SSI_scikit_rf_fit_MT:
    input:
        expand('output/nwTensor/train_X/tensor/{params}.csv', params = paramspace.wildcard_pattern),
        'output/SSI/y_r.csv'
    output:
        expand('output/nwTensor/train_X/fit/{params}.pickle', params = paramspace.wildcard_pattern)
    params:
        args10 = lambda w: w["row"]
    benchmark:
        f'benchmarks/nwTensor/train_X/fit/{paramspace.wildcard_pattern}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        f'logs/nwTensor/train_X/fit/{paramspace.wildcard_pattern}.log'
    shell:
        'source /opt/conda/etc/profile.d/conda.sh && conda activate sklearn-env && python src/SSI_scikit_rf_fit_MT.py {input} {output} {params.args10} >& {log}'

rule test_u_models:
    input:
        expand('output/nwTensor/train_X/one_slice_tensor/{params}.RData', params = paramspace.wildcard_pattern),
        expand('output/nwTensor/train_X/tensor/{params}.RData', params = paramspace.wildcard_pattern)
    output:
        expand('output/nwTensor/test_X/tensor/{params}.csv', params = paramspace.wildcard_pattern)
    params:
        args0 = lambda w: w["MODELS"]
    benchmark:
        f'benchmarks/nwTensor/test_X/tensor/{paramspace.wildcard_pattern}.txt'
    container:
        'docker://koki/tensor-projects-self-incompatible:20221217'
    resources:
        mem_gb=200
    log:
        f'logs/nwTensor/test_X/tensor/{paramspace.wildcard_pattern}.log'
    shell:
        'src/test_{params.args0}.sh {input} {output} >& {log}'

rule SSI_U_Predict:
    input:
        expand('output/nwTensor/train_X/fit/{params}.pickle', params = paramspace.wildcard_pattern),
        expand('output/nwTensor/test_X/tensor/{params}.csv', params = paramspace.wildcard_pattern)
    output:
        expand('output/nwTensor/test_X/predict/{params}.csv', params = paramspace.wildcard_pattern)
    benchmark:
        f'benchmarks/nwTensor/test_X/predict/{paramspace.wildcard_pattern}.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        f'logs/nwTensor/test_X/predict/{paramspace.wildcard_pattern}.log'
    shell:
        'source /opt/conda/etc/profile.d/conda.sh && conda activate sklearn-env && python src/SSI_U_Predict.py {input} {output} >& {log}'