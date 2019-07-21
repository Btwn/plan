[Forma]
Clave=RM1070Conceptofrm
Nombre=RM1070 Concepto
Icono=0
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=list
BarraHerramientas=S
CarpetaPrincipal=list
ListaAcciones=Selecio
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1070concepto,<T><T>)
[list]
Estilo=Iconos
Clave=list
OtroOrden=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1070Conceptovis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Concepto
ListaOrden=Concepto<TAB>(Acendente)
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
[Acciones.Selecio]
Nombre=Selecio
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asigna<BR>expr<BR>sel
[list.Columnas]
Nombre=604
Concepto=604
0=-2
[list.Concepto]
Carpeta=list
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Selecio.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecio.expr]
Nombre=expr
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>list<T>)
Activo=S
Visible=S
[Acciones.Selecio.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1070concepto,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

