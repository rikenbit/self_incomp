# SSI_Vis_Model
###################################################
rule all:
    input:
        'output/Vis_Model/Dens.png',
        'output/Vis_Model/Dens_FW.png',
        'output/Vis_Model/DimX.png',
        'output/Vis_Model/NumPara.png',
        'output/Vis_Model/Hist_Id.png',
        'output/Vis_Model/Hist_Fill.png',
        'output/Vis_Model/Hist_Id_FW.png'

rule SSI_Vis_Model:
    output:
        'output/Vis_Model/Dens.png',
        'output/Vis_Model/Dens_FW.png',
        'output/Vis_Model/DimX.png',
        'output/Vis_Model/NumPara.png',
        'output/Vis_Model/Hist_Id.png',
        'output/Vis_Model/Hist_Fill.png',
        'output/Vis_Model/Hist_Id_FW.png'
    params:
        input_dir = 'output/LOOCV_rf'
    benchmark:
        'benchmarks/Vis_Model/Dens.txt'
    container:
        'docker://yamaken37/ssi_vis_pairplot:20230106'
    resources:
        mem_gb=200
    log:
        'logs/Vis_Model/Dens.log'
    shell:
        'src/SSI_Vis_Model.sh {params.input_dir} {output} >& {log}'