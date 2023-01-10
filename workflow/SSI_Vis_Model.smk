# SSI_Vis_Model
###################################################
rule all:
    input:
        'output/Vis_Model/Acc_Dens_plot.png',
        'output/Vis_Model/Acc_Dens_plot_FW.png'

rule SSI_Vis_Model:
    # input:
    #     'output/X_Tensor/{list_l}.csv',
    #     'output/SSI/y_r.csv'
    output:
        'output/Vis_Model/Acc_Dens_plot.png',
        'output/Vis_Model/Acc_Dens_plot_FW.png'
    params:
        input_dir = 'output/LOOCV_rf'
    benchmark:
        'benchmarks/Vis_Model/Acc_Dens_plot.txt'
    container:
        'docker://yamaken37/ssi_vis_pairplot:20230106'
    resources:
        mem_gb=200
    log:
        'logs/Vis_Model/Acc_Dens_plot.log'
    shell:
        'src/SSI_Vis_Model.sh {params.input_dir} {output} >& {log}'