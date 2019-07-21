/*
Update para solucionar cuando se exporta a excel y se cierra algun objeto en el desarrollo y se cierra el excel
*/

UPDATE VersionLista SET Valor = 'No' WHERE Nombre = 'ExportarExcelSegundoPlano'
