[Forma]
Clave=RM0187UENVISFRM
Nombre=RM0187UENVISFRM
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=RM0187UENVIS
CarpetaPrincipal=RM0187UENVIS
PosicionInicialIzquierda=659
PosicionInicialArriba=230
PosicionInicialAlturaCliente=173
PosicionInicialAncho=176
ListaAcciones=Selecccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
[RM0187UENVIS]
Estilo=Iconos
Clave=RM0187UENVIS
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0187UENVIS
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
ListaEnCaptura=UEN
CarpetaVisible=S
IconosNombre=RM0187UENVIS:Nombre
[RM0187UENVIS.Columnas]
0=130
1=34
[Acciones.Selecccionar]
Nombre=Selecccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Selecccionar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Var<BR>regi<BR>secc
[Acciones.Selecccionar.CAP]
Nombre=CAP
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecccionar.Var]
Nombre=Var
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecccionar.regi]
Nombre=regi
Boton=0
TipoAccion=expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Selecccionar.secc]
Nombre=secc
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM0187uEN,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[RM0187UENVIS.UEN]
Carpeta=RM0187UENVIS
Clave=UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=0
ColorFondo=Blanco
ColorFuente=Negro

