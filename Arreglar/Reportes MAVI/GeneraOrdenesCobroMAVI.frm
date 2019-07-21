[Forma]
Clave=GeneraOrdenesCobroMAVI
Nombre=Ordenes de Cobro
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Expresion
PosicionInicialIzquierda=527
PosicionInicialArriba=330
PosicionInicialAlturaCliente=106
PosicionInicialAncho=225
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Ejercicio<BR>Info.QuincenaMAVI
CarpetaVisible=S
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.QuincenaMAVI]
Carpeta=(Variables)
Clave=Info.QuincenaMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Expresion]
Nombre=Expresion
Boton=7
NombreEnBoton=S
NombreDesplegar=Generar OC´s
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
[Acciones.Expresion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si((Info.QuincenaMAVI > 24) o (Info.QuincenaMAVI < 1), Si(Error(<T>El número de quincena es incorrecto!!<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>Si(Info.Ejercicio <= 0, Si(Error(<T>Ejercicio Incorrecto!!<T>, BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>Si(SQL(<T>SELECT dbo.fnExistenOrdenesCobroMAVI(:nEjer, :nQuincena)<T>, Info.Ejercicio, Info.QuincenaMAVI)=1,Si(Precaucion(<T>Ya fueron generadas ordenes de cobro con la herramienta para el periodo seleccionado<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>Si(SQL(<T>SELECT COUNT(0) FROM MaviRecuperacion WHERE Quincena =:nQuincena AND Ejercicio =:nEjer<T>, Info.QuincenaMAVI, Info.Ejercicio)>0,verdadero,Si(Precaucion(<T>No se ha generado la asignacion de cuentas del <CONTINUA>
Expresion002=<CONTINUA>periodo seleccionado!!<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>EjecutarSQLAnimado(<T>spGenerarOrdenesCobroMAVI :tUsuario, :tEmp, :nSuc, :nEjercicio, :nQuincena, :nEstacion<T>, Usuario, Empresa, Sucursal, Info.Ejercicio, Info.QuincenaMAVI, EstacionTrabajo)<BR>Si(SQL(<T>SELECT dbo.fnNumeroOrdenesCobroMAVI(:nEjer, :nQuincena)<T>, Info.Ejercicio, Info.QuincenaMAVI)>0, Informacion(<T>Se generaron <T>+SQL(<T>SELECT dbo.fnNumeroOrdenesCobroMAVI(:nEjer, :nQuincena)<T>, Info.Ejercicio, Info.QuincenaMAVI)+<T> Ordenes de Cobro<T>), Informacion(<T>No se generaron Ordenes de Cobro<T>))
EjecucionCondicion=(ConDatos(Info.Ejercicio)) y (ConDatos(Info.QuincenaMAVI))
EjecucionMensaje=<T>Todos los datos son requeridos!!<T>

