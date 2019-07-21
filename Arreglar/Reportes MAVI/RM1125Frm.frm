[Forma]
Clave=RM1125Frm
Icono=126
Modulos=(Todos)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=99
PosicionInicialAncho=269
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Imprimir<BR>aExcel<BR>Cerrar
ListaCarpetas=(Variables)
Nombre=Estado de cuenta DIMA
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
PosicionInicialIzquierda=548
PosicionInicialArriba=321
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Info.Cliente, Nulo)<BR>Asigna(Mavi.RM0351TipoFactura, Nulo)<BR>Asigna(Mavi.RM0351Folio, Nulo)<BR>Asigna(Mavi.RM0351TipoMovimiento, Nulo)
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Verifica.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Verifica.Cierra]
Nombre=Cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
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
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaAlineacion=Izquierda
FichaColorFondo=Plata
ListaEnCaptura=Info.Cliente
PermiteEditar=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
RefrescarDespues=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Cerrar
UsaTeclaRapida=S
TeclaRapida=Ctrl+P
EnMenu=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnMenu=S
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=CONDATOS(info.cliente)
EjecucionMensaje=<T>INGRESE UN CLIENTE POR FAVOR<T>
[Acciones.Imprimir.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Imprimir.Impr]
Nombre=Impr
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=ReporteImpresora(<T>RM1125RepImp<T>)
EjecucionCondicion=CONDATOS(info.cliente)
EjecucionMensaje=<T>INGRESE UN CLIENTE POR FAVOR<T>
[Acciones.Imprimir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=&Imprimir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Impr<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.aExcel]
Nombre=aExcel
Boton=115
NombreDesplegar=&Excel
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Excel
ClaveAccion=RM0351EdoCtaxCteAsocRepXls
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=asigna<BR>Excel
[Acciones.aExcel.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.aExcel.Excel]
Nombre=Excel
Boton=0
TipoAccion=Reportes Excel
Activo=S
Visible=S
ClaveAccion=RM1125RepXls
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=CONDATOS(info.cliente)
EjecucionMensaje=<T>INGRESE UN CLIENTE POR FAVOR<T>

[Lista.Columnas]
Cliente=117
Nombre=293
RFC=107


