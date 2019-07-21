[Forma]
Clave=CobCampoMavi
Nombre=Cobranza Campo
Icono=101
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=552
PosicionInicialArriba=426
PosicionInicialAlturaCliente=133
PosicionInicialAncho=175
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=12x4
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
VentanaConIcono=S
AccionesDivision=S
PosicionSec1=64
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.NominaMAVI, Nulo)<BR>Asigna(Info.Ejercicio, Nulo)
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
ListaEnCaptura=Info.Ejercicio<BR>Info.NominaMavi
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Arriba
PermiteEditar=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.EnviarNominas.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
Expresion=Caso Info.TipoComisionMavi<BR>  Es <T>Cobranza Campo<T> Entonces<BR>        Si (Vacio(Info.Ejercicio, 0) <> 0) y (Vacio(Info.NominaMavi, 0) <> 0) Entonces<BR>          ProcesarSQL(<T>spCobranzaCampoMAVI :tEmpresa, :nEjercicio, :nNominaMavi, :tAccion, :tUsuario<T>, Empresa, Info.Ejercicio, Info.NominaMavi, <T>AFECTAR<T>, Usuario)<BR>        Fin<BR>Sino<BR>    Informacion(<T>En Desarrollo<T>)<BR>Fin
EjecucionCondicion=(Vacio(Info.Ejercicio, 0) <> 0) y (Vacio(Info.NominaMavi, 0) <> 0)
EjecucionMensaje=Si(Vacio(Info.Ejercicio, 0) = 0, <T>No se ha determinado el Ejercicio<T>, Si(Vacio(Info.NominaMavi, 0) = 0, <T>No ha determinado la Nómina<T>))
[Acciones.EnviarNominas.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(Vacio(Info.NominaMavi, 0) <> 0) y (Vacio(Info.Ejercicio, 0) <> 0)
EjecucionMensaje=Si(Vacio(Info.Ejercicio, 0) = 0, <T>No se ha determinado el Ejercicio<T>, Si(Vacio(Info.NominaMavi, 0) = 0, <T>No ha determinado la Nómina<T>))
[Titulo.Info.Ejercicio]
Carpeta=Titulo
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Titulo.Info.NominaMavi]
Carpeta=Titulo
Clave=Info.NominaMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.EnviarNomina.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.EnviarNomina.Expr]
Nombre=Expr
Boton=0
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=Si SQL(<T>Select Count(Agente) From DeducPromCobCampoMAVI Where Ejercicio=:nEjerc And Quincena=:nNom And InNomina=1<T>,Info.Ejercicio,Info.NominaMavi)>0<BR>Entonces<BR>        Precaucion(<T>Las Deducciones de la Quincena <T>+Info.NominaMAVI+<T>, ya fueron enviadas Anteriormente. No se Pueden Reenviar...<T>)<BR>Sino<BR>    Si SQL(<T>Select Count(Agente) From DeducPromCobCampoMAVI Where Ejercicio=:nEjerc And Quincena=:nQuin<T>,Info.Ejercicio,Info.NominaMAVI)=0<BR>    Entonces<BR>        Precaucion(<T>No se han generado las cuotas de Cobranza Campo para esta Quincena...<T>)<BR>    Sino<BR>        EjecutarSQLAnimado(<T>EXEC sp_DeduccionPromotorCobMAVI :nEjer ,:nQuin, :tUsr, :tOpc <T>,Info.Ejercicio,Info.NominaMavi,Usuario, <T>AFECTAR<T>)<BR>        Informacion(<T>Proceso Terminado...<T>+NuevaL<CONTINUA>
Expresion002=<CONTINUA>inea+<T>Las cuotas del Ejercicio: <T>+Info.Ejercicio+<T>, Quincena: <T>+Info.NominaMavi+<T> se envió a Nómina.<T>)<BR>    Fin<BR>Fin
EjecucionCondicion=(Vacio(Info.NominaMavi, 0) <> 0) y (Vacio(Info.Ejercicio, 0) <> 0)
EjecucionMensaje=Si(Vacio(Info.Ejercicio, 0) = 0, <T>No se ha determinado el Ejercicio<T>, Si(Vacio(Info.NominaMavi, 0) = 0, <T>No ha determinado la Nómina<T>))
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
[(Variables).Info.NominaMavi]
Carpeta=(Variables)
Clave=Info.NominaMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


