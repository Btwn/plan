[Forma]
Clave=RM1142estadosFrm
Icono=0
ListaCarpetas=est
CarpetaPrincipal=est
PosicionInicialIzquierda=57
PosicionInicialArriba=11
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Selec
[est]
Estilo=Iconos
Clave=est
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1142EstadosVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>estados<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
IconosSeleccionMultiple=S
MenuLocal=S
IconosNombre=RM1142EstadosVis:Estado
ListaAcciones=todo<BR>quitar
[est.Columnas]
0=-2
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=Seleccionar &todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=Quitar seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Selec.var]
Nombre=var
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selec.reg]
Nombre=reg
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>est<T>)
[Acciones.Selec]
Nombre=Selec
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=var<BR>reg<BR>selc
Activo=S
Visible=S
[Acciones.Selec.selc]
Nombre=selc
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1142Estados,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
