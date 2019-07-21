
[Forma]
Clave=DM0207EstCobroCteFinalFrm
Icono=340
BarraHerramientas=S
Modulos=(Todos)
Nombre=Estatus Cobro Beneficiario
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Seleccionar
PosicionInicialIzquierda=434
PosicionInicialArriba=257
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaCarpetas=Estatus
CarpetaPrincipal=Estatus
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>SeleccionaRes
[Acciones.Seleccionar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Estatus<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.SeleccionaRes]
Nombre=SeleccionaRes
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0207EstatusCobroCteFinal,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)<BR>Reemplaza( Comillas(<T>,<T>),<T>,<T>, Mavi.DM0207EstatusCobroCteFinal)

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Estatus]
Estilo=Iconos
Clave=Estatus
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0207EstCobroCteFinalVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaAcciones=SeleccionarTodo<BR>QuitarSeleccion
CarpetaVisible=S

ListaEnCaptura=TcIDM0207_DescEstatusCobroCteFinalTBL.Descripcion
IconosSubTitulo=<T>Estatus<T>
IconosNombre=DM0207EstCobroCteFinalVis:TcIDM0207_DescEstatusCobroCteFinalTBL.Estatus
[Estatus.Columnas]
0=52

1=-2
2=-2

[Estatus.TcIDM0207_DescEstatusCobroCteFinalTBL.Descripcion]
Carpeta=Estatus
Clave=TcIDM0207_DescEstatusCobroCteFinalTBL.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
