[Forma]
Clave=RM0187ProveedoresVisFrm
Nombre=Proveedores
Icono=0
Modulos=(Todos)
ListaCarpetas=Proveedores
CarpetaPrincipal=Proveedores
PosicionInicialIzquierda=425
PosicionInicialArriba=151
PosicionInicialAlturaCliente=514
PosicionInicialAncho=427
BarraHerramientas=S
AccionesTamanoBoton=15x5
ListaAcciones=Selec<BR>Buscar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
AccionesIzq=S
[Proveedores]
Estilo=Iconos
Clave=Proveedores
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0187ProveedoresVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteLocalizar=S
ListaEnCaptura=Nombre
IconosNombre=RM0187ProveedoresVis:Proveedor
[Proveedores.Columnas]
0=65
1=329
[Acciones.Selec]
Nombre=Selec
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=ASI<BR>REGI<BR>SEL
UsaTeclaRapida=S
EnMenu=S
Menu=&Seleccionar
TeclaRapida=Ctrl+S
[Acciones.all]
Nombre=all
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.Unmark]
Nombre=Unmark
Boton=0
NombreDesplegar=Desmarcar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Buscar]
Nombre=Buscar
Boton=73
NombreEnBoton=S
NombreDesplegar=&Buscar
EnBarraHerramientas=S
Carpeta=Proveedores
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
Menu=&Buscar
EsDefault=S
[Acciones.Selec.ASI]
Nombre=ASI
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selec.REGI]
Nombre=REGI
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Selec.SEL]
Nombre=SEL
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM0187Proveedor,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Proveedores.Nombre]
Carpeta=Proveedores
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

