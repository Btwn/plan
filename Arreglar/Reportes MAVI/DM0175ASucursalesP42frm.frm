[Forma]
Clave=DM0175ASucursalesP42frm
Nombre=DM0175 sucursales P42
Icono=0
Modulos=(Todos)
ListaCarpetas=P42
CarpetaPrincipal=P42
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=selec
[P42]
Estilo=Iconos
Clave=P42
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0175ApuestosP42vis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre
CarpetaVisible=S
MenuLocal=S
ListaAcciones=selc<BR>quitar
IconosNombre=DM0175ApuestosP42vis:Sucursal
IconosSubTitulo=<T>Sucursal<T>
[P42.Columnas]
0=-2
1=217
[Acciones.selec.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.selec.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>P42<T>)
Activo=S
Visible=S
[Acciones.selec]
Nombre=selec
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>regis<BR>seleciona
Activo=S
Visible=S
[Acciones.selec.seleciona]
Nombre=seleciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0175Asuc,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.selc]
Nombre=selc
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Quitar Seleccion 
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[P42.Nombre]
Carpeta=P42
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
