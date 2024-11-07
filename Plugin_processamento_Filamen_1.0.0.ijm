/*
 * @author José Anderson Amorim Estevão
 * @projeto PIBIC
 * @date 2024-10-26
 * @version 1.0.0
 * @description Processamento de imagens de microscopia
 * @param caminho - caminho da pasta onde estão as imagens
 * @param tipoArquivo - tipo de arquivo a ser processado
 * @param localOndeSalva - caminho da pasta onde serão salvos os resultados
 */


caminho = getDirectory("Caminho onde esta as imagens");
tipoArquivo = '.tif';
localOndeSalva = "C:/pibic/imagens/Resultados/";
processarPasta(caminho);

// function para scanear pastas/subpastas/arquivos para procurar imagens .tif
function processarPasta(caminho) {


    list = getFileList(caminho);
    list = Array.sort(list);
    for (i = 0; i < list.length; i++) {
        if (File.isDirectory(caminho + File.separator + list[i]))
            processarPasta(caminho + File.separator + list[i]);
        if (endsWith(list[i], tipoArquivo))
            processarImagem(caminho, localOndeSalva, list[i], i);
    }
}
var aberto = false;
function processarImagem(caminho, localOndeSalva, file, cont) {
    //run("Read and Write Excel", "file=[" + localOndeSalva + "resultsxls/Processed_All.xlsx] file_mode=read_and_open");
    ///////// inicio abrir arquivos ////////////////
    if (file + "" == 'bkg.tif') {
        return;
    }
    open("C:/pibic/imagens/1/" + file);
    if (aberto) {
        aberto = false;
        run("Close");
        run("Close");
    } else {
        aberto = true;

        open("C:/pibic/imagens/1/bkg.tif");
    }
    open("C:/pibic/imagens/1/" + file);
    fileNoExtension = File.nameWithoutExtension;
    /////////// fim abrir arquivos ////////////

    ////////// inicio do processamento ////////////////
   
    imageCalculator("Subtract create 32-bit",  file + "", "bkg.tif");
    selectImage("Result of "+file + "");
    setOption("ScaleConversions", true);
    run("8-bit");
    run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=None fast_(less_accurate)");
    run("Unsharp Mask...", "radius=1 mask=0.60");
    run("LoG 3D");
    setAutoThreshold("Triangle dark no-reset");
    //run("Threshold...");
    //setThreshold(120, 255);
    run("Convert to Mask");
    run("Close");
    run("Directional Filtering", "type=Max operation=Opening line=20 direction=80");
    run("Area Opening", "pixel=75");
    run("Skeletonize (2D/3D)");
    close();
    run("Analyze Skeleton (2D/3D)", "prune=none calculate show display");
    //////////// fim do processamento ////////////

    //////// inicio salvamento /////////////////
    saveAs("Results", "C:/pibic/imagens/Resultados/resultsxls/" + fileNoExtension + ".xls");

    saveAs("Jpeg", "C:/pibic/imagens/Resultados/res_" + file + ".jpg");
    // print("Processing: " + caminho + File.separator + file);
    // print("Saving to: " + localOndeSalva);
    //////////// fim salvamento /////////
    //run("Read and Write Excel", "file_mode=write_and_close");
    run("Close");
    run("Close");
}





