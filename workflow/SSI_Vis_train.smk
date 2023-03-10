# SSI_Vis_train
###################################################
list_LOOCV = [
'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-3-A1G_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-4-A1_r1_20_r2_100_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-4-A1G_r1_6_r2_50_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-5-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-6-A1A3G_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-7-A1A2G_r1_xx_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
'MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx',
'MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx',
'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx',
'MODELS_Model-9-A1A4GLGR_r1_xx_r2_xx_r3_20_r1L_6_r1R_6_r2L_25_r2R_25_r3L_xx_r3R_xx',
'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20',
'MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10',
'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10',
'MODELS_Model-11-A1A4GLGR_r1_xx_r2_xx_r3_xx_r1L_6_r1R_6_r2L_25_r2R_25_r3L_8_r3R_8'
]

rule all:
    input:
        expand('output/Vis_train/train_X/rec_error/{list_l}.png', list_l=list_LOOCV),
        expand('output/Vis_train/train_X/rel_change/{list_l}.png', list_l=list_LOOCV)

rule SSI_Vis_train:
    input:
         'output/train_X/tensor/{list_l}.RData'
    output:
        'output/Vis_train/train_X/rec_error/{list_l}.png',
        'output/Vis_train/train_X/rel_change/{list_l}.png',
    benchmark:
        'benchmarks/Vis_train/train_X/rec_error/{list_l}.txt'
    container:
        "docker://yamaken37/ssi_vis_pairplot:20230106"
    resources:
        mem_gb=200
    log:
        'logs/Vis_train/train_X/rec_error/{list_l}.log'
    shell:
        'src/SSI_Vis_train.sh {input} {output} >& {log}'

#################################################################
# import itertools as it
# import numpy as np
# import pandas as pd
# from snakemake.utils import min_version
# from snakemake.utils import Paramspace

# # N_row
# # pullout_row = list(map(str, range(1, 181)))
# pullout_row = list(map(str, range(1, 4)))

# list_LOOCV = [
# 'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-3-A1G_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-4-A1_r1_20_r2_100_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-4-A1G_r1_6_r2_50_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-5-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-6-A1A3G_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-7-A1A2G_r1_xx_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx',
# 'MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx',
# 'MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx',
# 'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx',
# 'MODELS_Model-9-A1A4GLGR_r1_xx_r2_xx_r3_20_r1L_6_r1R_6_r2L_25_r2R_25_r3L_xx_r3R_xx',
# 'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20',
# 'MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10',
# 'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10',
# 'MODELS_Model-11-A1A4GLGR_r1_xx_r2_xx_r3_xx_r1L_6_r1R_6_r2L_25_r2R_25_r3L_8_r3R_8'
# ]

# list_join = list(it.product(list_LOOCV,pullout_row))
# list_LOOCV_row = ['_row_'.join(v) for v in list_join]

# df_Series= pd.Series(list_LOOCV_row)
# df = df_Series.str.split('_', expand=True)
# df = df.iloc[:,1::2]
# df_test=df.set_axis(['MODELS','r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R', 'row'], axis=1)
# paramspace = Paramspace(df_test, filename_params=['MODELS', 'r1', 'r2', 'r3', 'r1L', 'r1R', 'r2L', 'r2R', 'r3L', 'r3R', 'row'], param_sep="_")

# rule all:
#     input:
#         expand('output/Vis_train/toy/MT_train_X/{params}/rec_error.png', params = paramspace.instance_patterns),
#         expand('output/Vis_train/toy/MT_train_X/{params}/rel_change.png', params = paramspace.instance_patterns)

# rule SSI_Vis_train:
#     input:
#          expand('output/toy/MT_train_X/tensor/{params}.RData', params = paramspace.wildcard_pattern)
#     output:
#          expand('output/Vis_train/toy/MT_train_X/{params}/rec_error.png', params = paramspace.wildcard_pattern),
#          expand('output/Vis_train/toy/MT_train_X/{params}/rel_change.png', params = paramspace.wildcard_pattern)
#     benchmark:
#         f'benchmarks/Vis_train/toy/MT_train_X/{paramspace.wildcard_pattern}/rec_error.txt'
#     container:
#         "docker://yamaken37/ssi_vis_pairplot:20230106"
#     resources:
#         mem_gb=200
#     log:
#         f'logs/Vis_train/toy/MT_train_X/{paramspace.wildcard_pattern}/rec_error.log'
#     shell:
#         'src/SSI_Vis_train.sh {input} {output} >& {log}'
#################################################################