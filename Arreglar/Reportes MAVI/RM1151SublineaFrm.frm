[Forma]
Clave=RM1151SublineaFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Sublinea
CarpetaPrincipal=Sublinea
PosicionInicialIzquierda=162
PosicionInicialArriba=82
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Selec
[Sublinea]
Estilo=Iconos
Clave=Sublinea
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1151SublineaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Sublinea<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
IconosSeleccionMultiple=S
MenuLocal=S
IconosNombre=RM1151SublineaVis:Propiedad
ListaAcciones=todo<BR>quitar
[Sublinea.Columnas]
0=-2
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=&seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Selec.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selec.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Sublinea<T>)
[Acciones.Selec]
Nombre=Selec
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>regis<BR>acepta
Activo=S
Visible=S
[Acciones.Selec.acepta]
Nombre=acepta
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1151Sublinea,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
