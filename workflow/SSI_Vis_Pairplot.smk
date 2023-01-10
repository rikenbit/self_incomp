import pandas as pd

# SSI_Vis_Pairplot
###################################################
# df = pd.read_csv('output/Tensor_viz/X_Tensor_LOOCV_rf.csv')
# list_LOOCV = df['All_Tensor_Params'].to_list()

# top10
list_LOOCV = [
    'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_20_r3R_20',
    'MODELS_Model-9-A1A4_r1_xx_r2_xx_r3_20_r1L_100_r1R_100_r2L_50_r2R_50_r3L_xx_r3R_xx',
    'MODELS_Model-8-A1GLGR_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_xx_r3R_xx',
    'MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_20_r3R_20',
    'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_25_r3L_5_r3R_5',
    'MODELS_Model-11-A1A4_r1_xx_r2_xx_r3_xx_r1L_100_r1R_100_r2L_25_r2R_50_r3L_10_r3R_10',
    'MODELS_Model-8-A1_r1_10_r2_xx_r3_20_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_xx_r3R_xx',
    'MODELS_Model-10-A1_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_20_r3R_10',
    'MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_50_r2R_25_r3L_10_r3R_20',
    'MODELS_Model-10-A1GLGR_r1_10_r2_xx_r3_xx_r1L_xx_r1R_xx_r2L_25_r2R_50_r3L_5_r3R_5']

rule all:
    input:
        expand('output/Vis_Pairplot/{list_l}.png',list_l=list_LOOCV),
        expand('output/Vis_Umap/{list_l}.png',list_l=list_LOOCV)

rule SSI_Vis_Pairplot:
    input:
        'output/X_Tensor/{list_l}.csv',
        'output/SSI/y_r.csv'
    output:
        'output/Vis_Pairplot/{list_l}.png',
        'output/Vis_Umap/{list_l}.png'
    benchmark:
        'benchmarks/Vis_Pairplot/{list_l}.txt'
    container:
        'docker://yamaken37/ssi_vis_pairplot:20230106'
    resources:
        mem_gb=200
    log:
        'logs/Vis_Pairplot/{list_l}.log'
    shell:
        'src/SSI_Vis_Pairplot.sh {input} {output} >& {log}'