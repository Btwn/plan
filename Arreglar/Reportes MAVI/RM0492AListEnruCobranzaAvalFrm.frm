[Forma]
Clave=RM0492AListEnruCobranzaAvalFrm
Nombre=RM0492A Listado de  Cobranza Avales
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
PosicionInicialIzquierda=512
PosicionInicialArriba=281
VentanaAvanzaTab=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=asigna(info.cliente,nulo)<BR>asigna(Mavi.AAgentesCob,nulo)<BR>asigna(Mavi.Ejercicio,EjercicioTrabajo)<BR>asigna(Mavi.QuincenaCobranza,si (Dia( Hoy ))  >= 15 entonces Mes(hoy)*2 sino (Mes(hoy)*2)-1) Fin))<BR>asigna(Mavi.RM0492ANivelesLista,nulo)<BR>asigna(Info.RM0492Zona,nulo)
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
ListaEnCaptura=Info.Cliente<BR>Mavi.AAgentesCob<BR>Mavi.Ejercicio<BR>Mavi.QuincenaCobranza<BR>Mavi.RM0492ANivelesLista<BR>Info.RM0492Zona
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
ColorFuente=Negro
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
ColorFuente=Negro
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
ColorFuente=Negro
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
Expresion=ReporteImpresora(<T>RM0492AListEnruCobranzaAvalRepImp<T>)
[Acciones.Imprimir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.RM0492ANivelesLista]
Carpeta=(Variables)
Clave=Mavi.RM0492ANivelesLista
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.AAgentesCob]
Carpeta=(Variables)
Clave=Mavi.AAgentesCob
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
ClaveAccion=RM0492AListEnruCobranzaAvalRepXLS
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
ClaveAccion=RM0492AListEnruCobranzaAvalRepTxt
Activo=S
Visible=S
[(Variables).Info.RM0492Zona]
Carpeta=(Variables)
Clave=Info.RM0492Zona
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


