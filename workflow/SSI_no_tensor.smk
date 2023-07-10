# SSI_no_tensor
###################################################
# r1
p_r1 = ["20"]
p_r2 = ["100"]
p_r3 = ["5"]

rule all:
    input:
     expand('output/test_X/no_tensor/predict/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv',
            r1=p_r1,
            r2=p_r2,
            r3=p_r3
            )
#### preprocess trainXはSSI_aln_to_onehot.Rで実行済み
rule SSI_scikit_rf_fit:
    input:
        'output/x_r.csv',
        'output/y_r.csv'
    output:
        'output/train_X/no_tensor/fit/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.pickle'
    benchmark:
        'benchmarks/train_X/no_tensor/fit/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.pickle.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/train_X/no_tensor/fit/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.pickle.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_scikit_rf_fit.py {input} {output} >& {log}'
#### preprocess testXはSSI_aln_to_onehot_TEST.Rを作成して実行####
rule SSI_U_Predict:
    input:
        'output/train_X/no_tensor/fit/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.pickle',
        'output/x_r_test.csv'
    output:
        'output/test_X/no_tensor/predict/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.csv'
    benchmark:
        'benchmarks/test_X/no_tensor/predict/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.txt'
    container:
        "docker://yamaken37/ssi_sklearn_env:202212141249"
    resources:
        mem_gb=200
    log:
        'logs/test_X/no_tensor/predict/MODELS_Model-1-A1_r1_{r1}_r2_{r2}_r3_{r3}_r1L_xx_r1R_xx_r2L_xx_r2R_xx_r3L_xx_r3R_xx.log'
    shell:
        'source .bashrc && conda activate sklearn-env && python src/SSI_U_Predict.py {input} {output} >& {log}'