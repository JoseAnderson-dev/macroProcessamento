/*
 * @author José Anderson Amorim Estevão
 * @projeto PIBIC - Análise Quantitativa de Imagem 
 * @date 07-11-2024
 * @version 1.1
 * @description Processamento de imagens de microscopia
 * @param caminho - caminho da pasta onde estão as imagens
 * @param tipoArquivo - tipo de arquivo a ser processado
 * @param localOndeSalva - caminho da pasta onde serão salvos os resultados
 */


caminho = getDirectory("Caminho onde esta as imagens");
resultados = getDirectory("Caminho onde salva os resultado das imagens");
tipoArquivo = '.tif';
localOndeSalva = resultados;
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
areaArrayGeral = newArray(0);
function processarImagem(caminho, localOndeSalva, file, cont) {

    ///////// inicio abrir arquivos ////////////////
    if (file + "" == 'bkg.tif') {
        return;
    }

    open(caminho + file);
    if (aberto) {
        aberto = false;
        run("Close");
        run("Close");
    } else {
        aberto = true;

        open(caminho + "/bkg.tif");
    }
    open(caminho + file);
    fileNoExtension = File.nameWithoutExtension;
    /////////// fim abrir arquivos ////////////

    ////////// inicio processamento ////////////////
   
    imageCalculator("Subtract create 32-bit",  file + "", "bkg.tif");
    selectImage("Result of "+file + "");
    setOption("ScaleConversions", true);
    run("8-bit");
    run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
    run("Unsharp Mask...", "radius=1 mask=0.60");
    run("LoG 3D");
    setAutoThreshold("Triangle dark no-reset");
    run("Threshold...");
    setThreshold(120, 255);
    run("Convert to Mask");
    run("Close");
    run("Directional Filtering", "type=Max operation=Opening line=20 direction=80");
    run("Area Opening", "pixel=75");
    run("Skeletonize (2D/3D)");
    close();
    run("Analyze Skeleton (2D/3D)", "prune=none calculate show display");
    //////////// fim processamento ////////////

    //////// inicio salvamento /////////////////
    saveAs("Tiff", localOndeSalva + file);
    saveAs("Results", localOndeSalva + fileNoExtension + ".xls");

    // print("Processing: " + caminho + File.separator + file);
    // print("Saving to: " + localOndeSalva);
    //////////// fim salvamento /////////
    run("Close");
    run("Close");
}





