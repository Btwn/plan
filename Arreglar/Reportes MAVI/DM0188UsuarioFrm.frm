[Forma]
Clave=DM0188UsuarioFrm
Nombre=DM0188Usuario
Icono=0
Modulos=(Todos)
ListaCarpetas=Usuarios
CarpetaPrincipal=Usuarios
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=sel
PosicionInicialIzquierda=350
PosicionInicialArriba=224
[Usuarios]
Estilo=Iconos
Clave=Usuarios
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0188UsuarioSinRepetirvis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=sele<BR>quita
OtroOrden=S
ListaEnCaptura=Usuario
ListaOrden=Usuario<TAB>(Acendente)
[Usuarios.Columnas]
0=-2
[Acciones.sel.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.sel.reg]
Nombre=reg
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Usuarios<T>)
[Acciones.sel]
Nombre=sel
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asignar<BR>reg<BR>selec
Activo=S
Visible=S
[Acciones.sel.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0188UsuarioFrm,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.sele]
Nombre=sele
Boton=0
NombreDesplegar=&Seleccionar todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quita]
Nombre=quita
Boton=0
NombreDesplegar=&Deseleccionar todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S
[Usuarios.Usuario]
Carpeta=Usuarios
Clave=Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=111
ColorFondo=Blanco
ColorFuente=Negro
