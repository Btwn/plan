[Forma]
Clave=RM0167MaviDivisionVIFrm
Nombre=Division
Icono=711
Modulos=(Todos)
CarpetaPrincipal=RM0167MaviDivisionEIVis
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=542
PosicionInicialArriba=288
PosicionInicialAlturaCliente=413
PosicionInicialAncho=196
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
ListaCarpetas=RM0167MaviDivisionEIVis
VentanaAvanzaTab=S
[Lista.Division]
Carpeta=Lista
Clave=Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
Division=170
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna2<BR>Regsitra2<BR>Seleccion2
[Acciones.SelAll]
Nombre=SelAll
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+E
NombreDesplegar=Selecciona &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitaSel]
Nombre=QuitaSel
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
NombreDesplegar=&Quitar Seleccòn
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[RM0167MaviDivisionEIVis]
Estilo=Iconos
Clave=RM0167MaviDivisionEIVis
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0167MaviDivisionEIVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Division<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Negro
ListaAcciones=SelAll<BR>QuitaSel
CarpetaVisible=S
IconosNombre=RM0167MaviDivisionEIVis:Division
[RM0167MaviDivisionEIVis.Columnas]
0=178
[Acciones.Seleccion.asigna1]
Nombre=asigna1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccion.Asigna2]
Nombre=Asigna2
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccion.Regsitra2]
Nombre=Regsitra2
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>vista<T>)
Activo=S
Visible=S
[Acciones.Seleccion.Seleccion2]
Nombre=Seleccion2
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

