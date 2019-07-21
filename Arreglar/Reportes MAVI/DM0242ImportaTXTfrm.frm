[Forma]
Clave=DM0242ImportaTXTfrm
Nombre=DM0242ImportaTXT
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=82
PosicionInicialAncho=253
PosicionInicialIzquierda=536
PosicionInicialArriba=334
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Asignar
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.ExaminarArchivoMAVI
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Info.ExaminarArchivoMAVI]
Carpeta=(Variables)
Clave=Info.ExaminarArchivoMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Asignar]
Nombre=Asignar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Aceptar<BR>Expresion<BR>cerrar
[Acciones.Asignar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Asignar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Asignar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ReportePantalla( <T>DM0242EscaneoInventariosRep<T> )<BR> //EjecutarSQLAnimado( <T>exec SP_MAVIDM0242ImportTXT  :tPath,:nEst, :tAlm<T>,Reemplaza( <T>C:<T>, <T>\\<T>+ NT.DireccionIP,Info.ExaminarArchivoMAVI),EstacionTrabajo,<T>A99999<T>) )


