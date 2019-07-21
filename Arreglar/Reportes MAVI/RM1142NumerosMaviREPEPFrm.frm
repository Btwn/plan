[Forma]
Clave=RM1142NumerosMaviREPEPFrm
Nombre=RM1142 - LIST NEGRA INT
Icono=97
Modulos=(Todos)
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=535
PosicionInicialArriba=132
PosicionInicialAlturaCliente=465
PosicionInicialAncho=295
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Importar<BR>Guardar<BR>Baja<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=EjecutarSQL(<T>EXEC SP_RM1142NumerosMAVIREPEP 3<T>)
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Registro Siguiente<BR>Guardar<BR>Expresion<BR>Cerrar
[Vista]
Estilo=Hoja
Clave=Vista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1142NumerosMaviREPEPVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM1142NumerosMaviREPEPTbl.Numero
CarpetaVisible=S
[Vista.RM1142NumerosMaviREPEPTbl.Numero]
Carpeta=Vista
Clave=RM1142NumerosMaviREPEPTbl.Numero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Vista.Columnas]
Numero=179
[Acciones.Importar]
Nombre=Importar
Boton=115
NombreEnBoton=S
NombreDesplegar=&Importar
EnBarraHerramientas=S
Activo=S
Visible=S
Carpeta=Vista
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dialogo,SQL(<T>EXEC SP_RM1142NumerosMAVIREPEP 1<T>))<BR>Si<BR>    Info.Dialogo = <T>CORRECTO<T><BR>Entonces<BR>    Informacion(<T>Proceso concluido<T>)<BR>    Verdadero<BR>Sino<BR>    Error(<T>Existen numeros no validos<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.Baja.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Baja.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dialogo,SQL(<T>EXEC SP_RM1142NumerosMAVIREPEP 2<T>))<BR>Si<BR>    Info.Dialogo = <T>CORRECTO<T><BR>Entonces<BR>    Informacion(<T>Proceso concluido<T>)<BR>    Verdadero<BR>Sino<BR>    Error(<T>Existen numeros no validos<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.Baja.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Baja]
Nombre=Baja
Boton=36
NombreEnBoton=S
NombreDesplegar=&Dar de Baja
Multiple=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
ListaAccionesMultiples=Registro Siguiente<BR>Guardar<BR>Expresion<BR>Cerrar
Activo=S
Visible=S
[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Guardar.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S
[Acciones.Baja.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S
[Acciones.Cerrar.Registro Cancelar]
Nombre=Registro Cancelar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Cancelar
Activo=S
Visible=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ListaAccionesMultiples=Registro Cancelar<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S

