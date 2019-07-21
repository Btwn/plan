[Forma]
Clave=RM1052SimuladorLayoutFRM
Icono=0
Modulos=(Todos)
ListaCarpetas=Layout
CarpetaPrincipal=Layout
PosicionInicialIzquierda=212
PosicionInicialArriba=267
PosicionInicialAlturaCliente=171
PosicionInicialAncho=352
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Ok<BR>Cerrar
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Nombre=RM1052SimuladorLayoutFRM
ExpresionesAlMostrar=Asigna(Info.InstitucionMAVI,Nulo)<BR>Asigna(Info.Ejercicio,Nulo)<BR>Asigna(Info.Periodo,Nulo)<BR>Asigna(Info.Id,0)
[Layout]
Estilo=Ficha
Clave=Layout
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.InstitucionMAVI<BR>Info.Ejercicio<BR>Info.Periodo
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Layout.Info.InstitucionMAVI]
Carpeta=Layout
Clave=Info.InstitucionMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=45
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Ok]
Nombre=Ok
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraAcciones=S
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Exp<BR>Cerrar
[Layout.Info.Ejercicio]
Carpeta=Layout
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Ok.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Ok.Exp]
Nombre=Exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=ReporteExcel(<T>RM1052SimuladorDispercionRep<T>)<BR>Si(Confirmacion( <T>Descea volver consultar Nuevo Periodo<T>, BotonSi,BotonNo) = BotonSi,<BR>Asigna(Info.Id,1)  Forma(<T>RM1052SimuladorLayoutFRM<T>),<BR>Asigna(Info.Id,2)EjecutarSQL(<T>Exec SP_RM1052SimuladorCobroInstituciones :tval1, :tval3, :nval4, :tval5, :nval6<T>,comillas(Empresa),comillas(Info.InstitucionMAVI),Info.Ejercicio,comillas(Info.Periodo),Info.Id))
EjecucionCondicion=condatos(Info.InstitucionMAVI)y condatos(Info.Periodo)y condatos(Info.ImporteMAVI)y condatos(Info.Ejercicio)
EjecucionMensaje=<T>Todos los campos son OBLIGATORIOS<T>
[Acciones.Ok.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Layout.Info.Periodo]
Carpeta=Layout
Clave=Info.Periodo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


