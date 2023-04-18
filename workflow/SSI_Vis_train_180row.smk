# SSI_Vis_train_180row
###################################################
list_LOOCV = [
'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-3-A1G_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-4-A1_r1_20_r2_100_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-4-A1G_r1_6_r2_50_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-5-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-6-A1A3G_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-7-A1A2G_r1_xx_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
'MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx_row',
'MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx_row',
'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx_row',
'MODELS_Model-9-A1A4GLGR_r1_xx_r2_xx_r3_20_r1L_6_r1R_6_r2L_25_r2R_25_r3L_xx_r3R_xx_row',
'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20_row',
'MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10_row',
'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10_row',
'MODELS_Model-11-A1A4GLGR_r1_xx_r2_xx_r3_xx_r1L_6_r1R_6_r2L_25_r2R_25_r3L_8_r3R_8_row'
]

rule all:
    input:
        expand('output/MT_train_X/rec_error/{list_l}.png', list_l=list_LOOCV),
        expand('output/MT_train_X_F1/rec_error/{list_l}.png', list_l=list_LOOCV),
        expand('output/MT_train_X/rel_change/{list_l}.png', list_l=list_LOOCV),
        expand('output/MT_train_X_F1/rel_change/{list_l}.png', list_l=list_LOOCV)

rule SSI_Vis_train:
    output:
        'output/MT_train_X/rec_error/{list_l}.png',
        'output/MT_train_X_F1/rec_error/{list_l}.png',
        'output/MT_train_X/rel_change/{list_l}.png',
        'output/MT_train_X_F1/rel_change/{list_l}.png'
    params:
        input_dir = 'output/MT_train_X/tensor',
        input_dir2 = 'output/MT_train_X/tensor/',
    benchmark:
        'benchmarks/MT_train_X/rec_error/{list_l}.txt'
    container:
        "docker://yamaken37/ssi_vis_pairplot:20230106"
    resources:
        mem_gb=200
    log:
        'logs/MT_train_X/rec_error/{list_l}.log'
    shell:
        'src/SSI_Vis_train_180row.sh {wildcards.list_l} {params} {output} >& {log}'


# SSI_Vis_train_180row toy
###################################################
# list_LOOCV = [
# 'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-2-A1G_r1_xx_r2_10_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-3-A1_r1_10_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-3-A1G_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-4-A1_r1_20_r2_100_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-4-A1G_r1_6_r2_50_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-5-A1_r1_20_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-6-A1A3G_r1_xx_r2_10_r3_xx_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-7-A1A2G_r1_xx_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# 'MODELS_Model-8-A1_r1_20_r2_xx_r3_8_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx_row',
# 'MODELS_Model-8-A1GLGR_r1_6_r2_xx_r3_10_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx_row',
# 'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx_row',
# 'MODELS_Model-9-A1A4GLGR_r1_xx_r2_xx_r3_20_r1L_6_r1R_6_r2L_25_r2R_25_r3L_xx_r3R_xx_row',
# 'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20_row',
# 'MODELS_Model-10-A1GLGR_r1_6_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10_row',
# 'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10_row',
# 'MODELS_Model-11-A1A4GLGR_r1_xx_r2_xx_r3_xx_r1L_6_r1R_6_r2L_25_r2R_25_r3L_8_r3R_8_row'
# ]
# # list_LOOCV = [
# # 'MODELS_Model-1-A1_r1_20_r2_100_r3_5_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row',
# # 'MODELS_Model-1-A1G_r1_10_r2_20_r3_10_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx_row'
# # ]

# rule all:
#     input:
#         expand('output/toy/Vis_train/rec_error/{list_l}.png', list_l=list_LOOCV),
#         expand('output/toy/Vis_train_F1/rec_error/{list_l}.png', list_l=list_LOOCV),
#         expand('output/toy/Vis_train/rel_change/{list_l}.png', list_l=list_LOOCV),
#         expand('output/toy/Vis_train_F1/rel_change/{list_l}.png', list_l=list_LOOCV)

# rule SSI_Vis_train:
#     output:
#         'output/toy/Vis_train/rec_error/{list_l}.png',
#         'output/toy/Vis_train_F1/rec_error/{list_l}.png',
#         'output/toy/Vis_train/rel_change/{list_l}.png',
#         'output/toy/Vis_train_F1/rel_change/{list_l}.png'
#     params:
#         input_dir = 'output/toy/MT_train_X/tensor',
#         input_dir2 = 'output/toy/MT_train_X/tensor/',
#     benchmark:
#         'benchmarks/toy/Vis_train/rec_error/{list_l}.txt'
#     container:
#         "docker://yamaken37/ssi_vis_pairplot:20230106"
#     resources:
#         mem_gb=200
#     log:
#         'logs/toy/Vis_train/rec_error/{list_l}.log'
#     shell:
#         'src/SSI_Vis_train_180row.sh {wildcards.list_l} {params} {output} >& {log}'