/*
 * @author José Anderson Amorim Estevão
 * @projeto PIBIC
 * @date 2024-06-06
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
    selectImage(file + "");
    imageCalculator("Subtract create 32-bit", file + "", "bkg.tif");
    setOption("ScaleConversions", true);
    run("8-bit");
    run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1- 48 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] normalize");
    run("Median...", "radius=1");
    setOption("BlackBackground", true);
    run("Convert to Mask");
    run("Dilate");
    run("Fill Holes");
    Stack.setXUnit("um");
    run("Coordinates...", "left=0 right=1360 top=0 bottom=1024");
    run("Scale Bar...", "width=200 height=200 horizontal bold overlay");
    run("In [+]");
    run("In [+]");
    run("In [+]");
    makeLine(1137, 972, 1336, 972);
    run("Set Scale...", "distance=199 known=200 unit=µm global");
    makeLine(1286, 898, 1286, 898);
    makeLine(1286, 898, 1286, 898);
    run("Out [-]");
    run("Out [-]");
    run("Out [-]");
    run("Set Measurements...", "area mean standard min centroid perimeter shape feret's median skewness area_fraction redirect=None decimal=3");
   
    run("Analyze Particles...", "size=10-Infinity display exclude clear include overlay");
    
    //////////// fim do processamento ////////////

    //////// inicio salvamento /////////////////
    saveAs("Results", "C:/pibic/imagens/Resultados/resultsxls/"+fileNoExtension+".xls");
   
     saveAs("Jpeg", "C:/pibic/imagens/Resultados/res_" + file + ".jpg");
    // print("Processing: " + caminho + File.separator + file);
    // print("Saving to: " + localOndeSalva);
    //////////// fim salvamento /////////
    //run("Read and Write Excel", "file_mode=write_and_close");
    run("Close");
    run("Close");
}





