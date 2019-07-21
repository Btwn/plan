
[Forma]
Clave=RM1154TipoRespuestaFrm
Icono=17
Modulos=(Todos)
MovModulo=(Todos)
Nombre=Tipo de Respuesta

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=110
PosicionInicialAncho=284
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=498
PosicionInicialArriba=437

VentanaBloquearAjuste=S
[RM1154TipoRespuestaReanalisisVis.Columnas]
0=-2





1=-2
2=-2
[Acciones.selec.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.selec.Regis]
Nombre=Regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>RM1154TipoRespuestaReanalisisVis<T>)

[Acciones.selec.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1154TipoRespuesta,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)





[Vista]
Estilo=Hoja
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1154TipoRespuestaReanalisisVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre
CarpetaVisible=S

HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Vista.Nombre]
Carpeta=Vista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

[Vista.Columnas]
Nombre=245

