[Forma]
Clave=DM0240CtasQuebranto
Nombre=DM0240 Cuentas Incobrables Fiscal
Icono=0
Modulos=(Todos)
ListaCarpetas=variables
CarpetaPrincipal=variables
PosicionInicialIzquierda=504
PosicionInicialArriba=334
PosicionInicialAlturaCliente=157
PosicionInicialAncho=334
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
ExpresionesAlMostrar=Asigna(Info.ejercicio,(sql(<T>select datepart(yy,getdate())<T>)))<BR>// asigna(info.ejercicio,2014)
[variables]
Estilo=Ficha
Pestana=S
Clave=variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Ejercicio
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Escoja el Ejercicio
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[variables.Info.Ejercicio]
Carpeta=variables
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
NombreDesplegar=Aceptar
Multiple=S
ListaAccionesMultiples=asigna<BR>abreaplicacion<BR>Cerrar
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=si (sql(<T>Select MAX(valor) from tablastd where tablast = :ta and nombre = :tb <T>,<T>DM0240ctasq<T>,Usuario)) >0<BR>entonces<BR>verdadero<BR>sino<BR>falso
EjecucionMensaje=<T>NO TIENE PERMISOS<BR>PARA ESTE REPORTE <T>
[Acciones.Aceptar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.abreaplicacion]
Nombre=abreaplicacion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Info.ABC  ,(sql(<T>Select @@SERVERNAME<T> )) )<BR>asigna(Info.ID,(sql(<T>Select MAX(valor) from tablastd where tablast = :ta and nombre = :tb <T>,<T>DM0240ctasq<T>,Usuario) ) )<BR><BR><BR>Ejecutar(<T>PlugIns\DM0240\DM0240CtasQuebranto.exe <T>+info.abc+<T> <T>+usuario+<T> <T>+Info.ID+<T> <T>+info.ejercicio  )
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S


