[Forma]
Clave=CXCFacturaCteMavi
Nombre=<T>Movimientos Pendientes<T>
Icono=67
Modulos=(Todos)
CarpetaPrincipal=Hoja
PosicionInicialAlturaCliente=352
PosicionInicialAncho=688
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=296
PosicionInicialArriba=317
ListaCarpetas=Hoja
ListaAcciones=Aceptar<BR>QuitarSeleccion<BR>CobroSeguro
BarraHerramientas=S
BarraAyuda=S
BarraAyudaBold=S
VentanaEstadoInicial=Normal
Comentarios=Info.Acreditado
ExpresionesAlMostrar=EjecutarSQL( <T>spOrigenVentaPMMavi :tEmp, :tCte, :nEst, :nTipoCobro<T>,  Empresa,  Info.Acreditado, EstacionTrabajo, Info.Cantidad )<BR>SI(Info.Cantidad2 <> 1,Asigna(Info.Veces,SQL(<T>Select dbo.fn_MaviDM0169cobroSegurosvida(:tCli)<T>,Info.Acreditado)),Asigna(Info.Veces,1))
ExpresionesAlCerrar=Asigna(Info.Cantidad2,2)
[Hoja.Columnas]
0=46
1=94
2=90
3=247
4=-2
Empresa=45
IdCxC=64
IdOrigeN=64
IdCxCOrigen=124
IdCxCOrigenMov=124
Cliente=64
5=-2
6=-2
[Hoja]
Estilo=Iconos
Clave=Hoja
MostrarConteoRegistros=S
Zona=A1
Vista=CXCFacturaCteMavi
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=IdCxCOrigenMov<BR>IdCxCOrigen<BR>Articulo<BR>CteFinal
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
ElementosPorPagina=200
IconosSubTitulo=<T>Reg<T>
IconosSeleccionPorLlave=S
IconosSeleccionMultiple=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
AlineacionAutomatica=S
AcomodarTexto=S
IconosNombre=CXCFacturaCteMavi:IdOrigeN
FiltroGeneral=CXCFacturaCteMavi.Empresa = <T>{Empresa}<T> AND<BR>{Si(ConDatos(Info.Acreditado), <T>Cliente=<T>+Comillas(Info.Acreditado), <T>1=1<T>)}  and<BR>{Si(Info.Veces = 0 , <T> IdCxCOrigenMov=<T>+Comillas(<T>Seguro Vida<T>), <T>1=1<T>)}
[Hoja.IdCxCOrigenMov]
Carpeta=Hoja
Clave=IdCxCOrigenMov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Aceptar<BR>Cerrar
GuardarAntes=S
[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=75
NombreDesplegar=&Quitar Seleccion
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarListaSt(<T>Hoja<T>,<T>IdOrigen<T>)<BR>Asigna(Info.Mensaje, <T>0<T>)<BR>Asigna(Info.Mensaje, SQL(<T>spValidaNumFactSelMAVI :nID, :nEst, :nTipoCobro<T>,  Info.ID, EstacionTrabajo, Info.Cantidad ))<BR>Asigna(Mavi.Folio,SQL(<T>SELECT Clave FROM ListaSt WHERE Estacion=:nEst<T>,EstacionTrabajo))<BR>Asigna(Info.Cantidad,SQL(<T>SELECT C = CASE WHEN DBO.FN_MAVIRM0906CobxPol(:tId) = <T>+Comillas(<T>SI<T>)+<T> THEN 1 ELSE 0 END<T>,Mavi.Folio))<BR>Asigna(Info.Importe,SQL(<T>EXEC SP_MAVIDM0043SugerirMonto :tIDFac, :nEst, :nIdcob,:tImp<T>,Mavi.Folio, EstacionTrabajo,Info.ID,Info.Importe))<BR>Asigna(Info.CanalVentaMAVI,SQL(<T>select V.EnviarA From Venta V With(NoLock) Inner Join Cxc C With(Nolock) ON V.Mov=C.Mov and C.MovID=V.MovID Where C.ID=:nid<T>,Mavi.Folio))<BR>Asigna(Info.Cantidad3,SQL(<T><CONTINUA>
Expresion002=<CONTINUA>Select ID From VentasCanalMAVI Where Cadena=:tVal<T>,<T>VENTA VALE<T>))<BR>Asigna(Info.Respuesta5,SQL(<T>SELECT * FROM  FN_MAVIDM0244ExisteAsignacionCliente (:tOpcion ,:tIdPadre,:tCliente)<T>,1,Mavi.Folio,Info.Acreditado)))<BR>Asigna(Mavi.DM0244IndicaAccion, <T>SI<T>)<BR>Asigna(Info.CantidadInventario,SQL(<T>Select dbo.fnDM0305validaTelCte(:tCte,:tUsr)<T>,Info.Acreditado,Usuario))<BR>Si<BR>  Info.CantidadInventario <> 0<BR>Entonces                             <BR>   Ejecutar(<T>PlugIns\DM0305ValidaTelefono.exe <T>+Info.Acreditado+<T> <T>+ Usuario+<T> <T>+Info.CantidadInventario)<BR>   AbortarOperacion<BR> Fin<BR><BR>Si<BR>  Info.CanalVentaMAVI=Info.Cantidad3<BR>    Entonces<BR>      Si (Info.Mensaje = <T>0<T>)<BR>      Entonces<BR>          Si (Info.Respuesta5 = <T>SI<T>)<BR>              <CONTINUA>
Expresion003=<CONTINUA>entonces<BR>                  Forma(<T>DM0244PreNipCobroFrm<T>)              <BR>              Sino<BR>                  Forma(<T>DM0244NipCobroFrm<T>)<BR>           fin<BR>       sino<BR>          Informacion( Info.Mensaje)<BR>          Asigna(Mavi.DM0244IndicaAccion, <T>NO<T>)<BR>      Fin<BR>    Sino<BR>      Si (Info.Mensaje = <T>0<T>)<BR>      Entonces<BR>          Si (Info.Respuesta5 = <T>NO<T>)<BR>              entonces<BR>                  Forma(<T>NegociaMoratoriosMavi<T>) <BR>              Sino<BR>                  Forma(<T>DM0244PreNipCobroFrm<T>)<BR>           fin<BR>       Sino                          <BR>            Informacion( Info.Mensaje)<BR>            Asigna(Mavi.DM0244IndicaAccion, <T>NO<T>)<BR>      Fin<BR>Fin



[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Mavi.DM0244IndicaAccion <> <T>NO<T>
[Hoja.IdCxCOrigen]
Carpeta=Hoja
Clave=IdCxCOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Hoja.Articulo]
Carpeta=Hoja
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CobroSeguro.forma]
Nombre=forma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0169UsuarioAutorizaCobro
Activo=S
Visible=S
[Acciones.CobroSeguro]
Nombre=CobroSeguro
Boton=83
NombreEnBoton=S
NombreDesplegar=Quitar Cobro Obligado A &Seguro
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=forma<BR>cerrar
Activo=S
Visible=S
[Acciones.CobroSeguro.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Hoja.CteFinal]
Carpeta=Hoja
Clave=CteFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro

