[Forma]
Clave=RM0492AListEnrCobMaviCobAvalFrm
Nombre=RM0492A Listado de  Cobranza Avales MaviCob
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=168
PosicionInicialAncho=336
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Imprimir<BR>AExcel<BR>atxt
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=472
PosicionInicialArriba=409
VentanaAvanzaTab=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=asigna(info.cliente,nulo)<BR>asigna(Mavi.AAgentesMaviCob,nulo)<BR>asigna(Mavi.Ejercicio,EjercicioTrabajo)<BR>asigna(Mavi.QuincenaCobranza,si (Dia( Hoy ))  >= 15 entonces Mes(hoy)*2 sino (Mes(hoy)*2)-1) Fin))<BR>asigna(Mavi.RM0492ANivelesListaMaviCob,nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Cliente<BR>Mavi.Ejercicio<BR>Mavi.QuincenaCobranza<BR>Mavi.RM0492ANivelesListaMaviCob<BR>Mavi.AAgentesMaviCob
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
GuardarAntes=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Cerrar
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>(ConDatos(Mavi.Ejercicio) y (Mavi.Ejercicio <> 0 ) y ConDatos(Mavi.QuincenaCobranza))<BR>entonces<BR>verdadero<BR>sino<BR>falso<BR>fin
EjecucionMensaje=<T>Ingrese  Ejercicio y Quincena<T>
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
Efectos=[Negritas]
[(Variables).Mavi.Ejercicio]
Carpeta=(Variables)
Clave=Mavi.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.QuincenaCobranza]
Carpeta=(Variables)
Clave=Mavi.QuincenaCobranza
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=&Imprimir
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Imp<BR>Cerrar
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Imprimir.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Imprimir.Imp]
Nombre=Imp
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=ReporteImpresora(<T>RM0492AListEnrCobMaviCobAvalRepImp<T>)
[Acciones.Imprimir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.AExcel]
Nombre=AExcel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=asignarvar<BR>EXELAZO<BR>cierraxls
EspacioPrevio=S
[Acciones.AExcel.ASignar]
Nombre=ASignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.AExcel.excelporfuera]
Nombre=excelporfuera
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0492AListEnruCobranzaAvalRepXLS
Activo=S
Visible=S
[Acciones.AExcel.asignarvar]
Nombre=asignarvar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.AExcel.EXELAZO]
Nombre=EXELAZO
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0492AListEnrCobMaviCobAvalRepXLS
Activo=S
Visible=S
[Acciones.atxt]
Nombre=atxt
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=asinava<BR>archivotxt
[Acciones.AExcel.cierraxls]
Nombre=cierraxls
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.atxt.asinava]
Nombre=asinava
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.atxt.archivotxt]
Nombre=archivotxt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0492AListEnrCobMaviCobAvalRepTXT
Activo=S
Visible=S


[(Variables).Mavi.RM0492ANivelesListaMaviCob]
Carpeta=(Variables)
Clave=Mavi.RM0492ANivelesListaMaviCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[SeleccionarNivelFrm.Columnas]
nombre=604

[(Variables).Mavi.AAgentesMaviCob]
Carpeta=(Variables)
Clave=Mavi.AAgentesMaviCob
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Agente.Columnas]
Agente=64
Nombre=604
Tipo=94
Estatus=94


