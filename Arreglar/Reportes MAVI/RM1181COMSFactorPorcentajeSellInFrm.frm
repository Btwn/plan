
[Forma]
Clave=RM1181COMSFactorPorcentajeSellInFrm
Icono=131
Modulos=(Todos)
Nombre=<T>Factor Porcentaje Sell In<T>







ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=268
PosicionInicialArriba=393
PosicionInicialAlturaCliente=199
PosicionInicialAncho=744






PosicionSec1=50
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Salir<BR>Guardar<BR>Historial<BR>Next
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

IniciarAgregando=S
VentanaSinIconosMarco=S
ExpresionesAlCerrar=Forma.Accion (<T>Cancelar<T>)
[SeleccionarProveedor.Columnas]
Proveedor=64
Nombre=604

[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Cancelar Cambios<BR>Salir
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Guardar<BR>Refrescar Controles<BR>Mensaje
ConCondicion=S
EjecucionCondicion=/*************************************************************************************************************************************************<BR>** ¿Que se valida a continuación?<BR>** 1.- Que los campos a capturar contengan datos<BR>** 2.- Que la fecha de inicio de vigencia a capturar no sea menor a la ultima fecha de inicio de vigencia que se tiene registrada en el historico<BR>** 3.- Que los Porcentajes de apoyo Sell In a capturar no sea menor o igual a los que se tienen registrados en el historico.<BR>** Nota: Si TODAS las condiciones que aparecen a continuacion se cumplen se procederá con la capturá de datos.<BR>**       Caso contrario se negará la captura de datos y se mostrará el mensaje de error<BR>*************************************************************************************************************************************************/<BR><BR>/*************************************************************************************************************************************************<BR>** Verificar que los campos Proveedor, Apoyo Porcentaje Sell In 1, Apoyo Porcentaje Sell In 1 y Apoyo Porcentaje Sell In 2 tengan datos.<BR>*************************************************************************************************************************************************/<BR>Forma.Accion(<T>Next<T>)<BR>Si(ConDatos(RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor),<BR>            Verdadero,<BR>            Informacion(<T>Debe llenar el campo <Proveedor><T>)AbortarOperacion)<BR>                                                                                      <BR>Si(ConDatos(RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn1),<BR>            Verdadero,<BR>            Informacion(<T>Debe llenar el campo <Porcentaje Apoyo Sell In 1><T>)AbortarOperacion)<BR><BR>Si(ConDatos(RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn2),<BR>            Verdadero,<BR>            Informacion(<T>Debe llenar el campo <Porcentaje Apoyo Sell In 2><T>)AbortarOperacion)<BR><BR>Si(ConDatos(RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.FechaInicioDeVigencia),<BR>            Verdadero,<BR>            Informacion(<T>Debe llenar el campo <Fecha Inicio De Vigencia><T>)AbortarOperacion)<BR><BR>/*************************************************************************************************************************************************<BR>** Verificar que la fecha de inicio de vigencia que se quiere capturar sea por lo menos igual o mayor a la ultima fecha de vigencia que se<BR>** tiene al momento en el historico. Si es menor la fecha que se desea capturar negamos la captura de datos y mandamos mensaje de error.<BR>*************************************************************************************************************************************************/<BR><BR>Si<BR>  (SQL(<T>SELECT DATEDIFF(dd,0,<T>+Comillas(FechaEnTexto(RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.FechaInicioDeVigencia,<T>aaaa/mm/dd<T>,<T>Ingles<T>))+<T>)<T>))<BR>  <<BR>  (SQL(<T>SELECT TOP 1 DATEDIFF(dd,0,FechaInicioDeVigencia) FROM COMSHPorcentajeApoyoSellIn WHERE Proveedor = :tProv ORDER BY IdPorcentajeApoyoSellIn DESC ,FechaInicioDeVigencia DESC<T>,<BR>        RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor))<BR><BR>Entonces<BR>  Informacion(<T>La fecha de inicio de vigencia debe ser mayor o igual a: <T>+ SQL(<T>SELECT TOP 1 FechaInicioDeVigencia FROM COMSHPorcentajeApoyoSellIn WHERE Proveedor = :tProv ORDER BY IdPorcentajeApoyoSellIn DESC ,FechaInicioDeVigencia DESC<T>,<BR>              RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor))<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>/*************************************************************************************************************************************************<BR>** Verificar que el porcentaje Sell In 1 que se quiere registrar sea mayor que al que se tiene registrado en el historico<BR>** Si es menor o igual al Porcentaje Sell In 1 que se tiene en historico negamos la accion de guardar los datos y mandamos mensaje de error<BR>*************************************************************************************************************************************************/<BR><BR>Si<BR>  (SQL(<T>SELECT :nNum<T>,RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn1))<BR>  <=<BR>  (SQL(<T>SELECT TOP 1 PorcentajeApoyoSellIn1 FROM COMSHPorcentajeApoyoSellIn WHERE Proveedor = :tProv ORDER BY IdPorcentajeApoyoSellIn DESC, FechaInicioDeVigencia DESC<T>,<BR>       RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor))<BR>Entonces<BR>  Informacion(<T>El % Porcentaje de apoyo Sell In 1 debe ser mayor a: <T>+SQL(<T>SELECT TOP 1 PorcentajeApoyoSellIn1<BR>               FROM COMSHPorcentajeApoyoSellIn WHERE Proveedor = :tProv ORDER BY IdPorcentajeApoyoSellIn DESC, FechaInicioDeVigencia DESC<T>,<BR>              RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor))<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>/*************************************************************************************************************************************************<BR>** Verificar que el porcentaje Sell In 2 que se quiere registrar sea mayor que al que se tiene registrado en el historico<BR>** Si es menor o igual al Porcentaje Sell In 2 que se tiene en historico negamos la accion de guardar los datos y mandamos mensaje de error<BR>*************************************************************************************************************************************************/<BR>Si<BR>  (SQL(<T>SELECT :nNum<T>,RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn2))<BR>  <=<BR>  (SQL(<T>SELECT TOP 1 PorcentajeApoyoSellIn2 FROM COMSHPorcentajeApoyoSellIn WHERE Proveedor = :tProv ORDER BY IdPorcentajeApoyoSellIn DESC, FechaInicioDeVigencia DESC<T>,<BR>        RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor))<BR>Entonces<BR>  Informacion(<T>El % Porcentaje de apoyo Sell In 2 debe ser mayor a: <T>+SQL(<T>SELECT TOP 1 PorcentajeApoyoSellIn2<BR>               FROM COMSHPorcentajeApoyoSellIn WHERE Proveedor = :tProv ORDER BY IdPorcentajeApoyoSellIn DESC, FechaInicioDeVigencia DESC<T>,<BR>             RM1181COMSHPorcentajeApoyoSellInVis:RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor))<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>/*************************************************************************************************************************************************<BR>** NOTA: Si todas las condiciones anteriores devolvieron verdadero entonces se procedera con la captura de los datos ingresados.<BR>*************************************************************************************************************************************************/
[Acciones.Historial]
Nombre=Historial
Boton=9
NombreEnBoton=S
NombreDesplegar=Historial
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
EspacioPrevio=S
ClaveAccion=RM1181COMSHistorialPorcentajeSellInFrm


[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Salir.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S









[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Vista]
Estilo=Ficha
Clave=Vista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1181COMSHPorcentajeApoyoSellInVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor<BR>Prov.Nombre<BR>RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn1<BR>RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn2<BR>RM1181COMSHPorcentajeApoyoSellInTbl.FechaInicioDeVigencia
CarpetaVisible=S

[Vista.RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor]
Carpeta=Vista
Clave=RM1181COMSHPorcentajeApoyoSellInTbl.Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Vista.Prov.Nombre]
Carpeta=Vista
Clave=Prov.Nombre
LineaNueva=N
ValidaNombre=N
3D=N
Tamano=63
ColorFondo=Blanco

[Vista.RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn1]
Carpeta=Vista
Clave=RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=15
[Vista.RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn2]
Carpeta=Vista
Clave=RM1181COMSHPorcentajeApoyoSellInTbl.PorcentajeApoyoSellIn2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=15
[Vista.RM1181COMSHPorcentajeApoyoSellInTbl.FechaInicioDeVigencia]
Carpeta=Vista
Clave=RM1181COMSHPorcentajeApoyoSellInTbl.FechaInicioDeVigencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=15
[Acciones.Guardar.Refrescar Controles]
Nombre=Refrescar Controles
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Limpiar Carpeta
Activo=S
Visible=S




[Acciones.Next]
Nombre=Next
Boton=0
NombreDesplegar=Next
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.Guardar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Datos capturados con éxito<T>)
Activo=S
Visible=S



