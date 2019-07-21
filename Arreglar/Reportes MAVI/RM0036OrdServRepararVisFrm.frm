[Forma]
Clave=RM0036OrdServRepararVisFrm
Nombre=Ordenes de Servicio a Reparar
Icono=643
Modulos=(Todos)
PosicionInicialAlturaCliente=295
PosicionInicialAncho=565
ListaCarpetas=vista
CarpetaPrincipal=vista
PosicionInicialIzquierda=357
PosicionInicialArriba=315
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[MaviOrdServRepararVis.Columnas]
0=-2
1=234
2=118
3=146
[Acciones.SelAll]
Nombre=SelAll
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+E
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitarSel]
Nombre=QuitarSel
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registra<BR>Seleccion
Activo=S
Visible=S
[vista]
Estilo=Iconos
Clave=vista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0036OrdServRepararVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Ordenes<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Articulo<BR>Delegacion<BR>Colonia
ListaAcciones=SelAll<BR>QuitarSel
CarpetaVisible=S
IconosNombre=RM0036OrdServRepararVis:OrdSer
[vista.Articulo]
Carpeta=vista
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[vista.Delegacion]
Carpeta=vista
Clave=Delegacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[vista.Colonia]
Carpeta=vista
Clave=Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[vista.Columnas]
0=-2
1=-2
2=-2
3=-2

