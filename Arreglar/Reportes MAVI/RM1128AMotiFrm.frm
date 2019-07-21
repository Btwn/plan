[Forma]
Clave=RM1128AMotiFrm
Nombre=Motivadores
Icono=0
Modulos=(Todos)
ListaCarpetas=amoti
CarpetaPrincipal=amoti
PosicionInicialIzquierda=205
PosicionInicialArriba=387
PosicionInicialAlturaCliente=160
PosicionInicialAncho=304
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Buscar<BR>Selec
[amoti]
Estilo=Iconos
Clave=amoti
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1128AMotiVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteLocalizar=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosNombre=RM1128AMotiVis:Motivador
ListaEnCaptura=NombreMotivador
[amoti.NombreMotivador]
Carpeta=amoti
Clave=NombreMotivador
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[amoti.Columnas]
0=-2
1=-2
[Acciones.Buscar]
Nombre=Buscar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Buscar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
[Acciones.Selec.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selec]
Nombre=Selec
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
ListaAccionesMultiples=Asigna<BR>Regis<BR>Selec
Activo=S
Visible=S
[Acciones.Selec.Regis]
Nombre=Regis
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>amoti<T>)
Activo=S
Visible=S
[Acciones.Selec.Selec]
Nombre=Selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1128AMoti,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

