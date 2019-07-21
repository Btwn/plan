[Forma]
Clave=RM1128MotivadorFrm
Nombre=RM1128Motivador
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=motiv
CarpetaPrincipal=motiv
PosicionInicialIzquierda=341
PosicionInicialArriba=250
PosicionInicialAlturaCliente=387
PosicionInicialAncho=293
ListaAcciones=Busca<BR>Selec
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[motiv]
Estilo=Iconos
Clave=motiv
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1128MotivadorVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteLocalizar=S
ListaEnCaptura=NombreMotivador
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosNombre=RM1128MotivadorVis:Motivador
[motiv.Columnas]
Motivador=64
Nombre=304
0=-2
1=-2
NombreMotivador=604
[Acciones.Busca]
Nombre=Busca
Boton=68
NombreEnBoton=S
NombreDesplegar=&Buscar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
[Acciones.Selec]
Nombre=Selec
Boton=23
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=Asig<BR>regis<BR>sele
[Acciones.Selec.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selec.Selec]
Nombre=Selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
[motiv.NombreMotivador]
Carpeta=motiv
Clave=NombreMotivador
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Selec.Asig]
Nombre=Asig
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
Expresion=RegistrarSeleccion(<T>Motiv<T>)
[Acciones.Selec.sele]
Nombre=sele
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1128AgeMoti,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

