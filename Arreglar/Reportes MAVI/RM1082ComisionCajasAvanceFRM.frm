[Forma]
Clave=RM1082ComisionCajasAvanceFRM
Nombre=RM1082 Comision Cajas Cartera Vencida
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=49
PosicionInicialAncho=372
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
ListaAcciones=Act<BR>Ant
PosicionInicialIzquierda=482
PosicionInicialArriba=300
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
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.Quincena
CondicionVisible=1=0
[Acciones.Ant.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Ant]
Nombre=Ant
Boton=24
NombreDesplegar=ANTERIOR
EnBarraHerramientas=S
TipoAccion=EXPRESION
Activo=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=Expr<BR>Asi
VisibleCondicion=SQL(<T>Select Valor from TablaStD<BR>     Where TablaSt = <T>+Comillas(<T>RM1092ACCESOS<T>)+<T><BR>     AND Nombre = (Select Acceso From Usuario u Where u.Usuario = :tUsr)<T>,Usuario) = 1
[Acciones.Act]
Nombre=Act
Boton=25
NombreEnBoton=S
NombreDesplegar=ACTUAL
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Expp<BR>Cerr
[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=0
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Ant.Expr]
Nombre=Expr
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.Quincena, 0 )<BR>ReportePantalla( <T>RM1082ComisionCajasAvanceREP<T> )
[Acciones.Act.Expp]
Nombre=Expp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.Quincena, 1 )<BR>ReportePantalla( <T>RM1082ComisionCajasAvanceREP<T> )
[Acciones.Act.Cerr]
Nombre=Cerr
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
[Acciones.Ant.Asi]
Nombre=Asi
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S

