[Forma]
Clave=AsignaCodigoAgrupador
Nombre=Asigna Código
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
PosicionInicialAlturaCliente=99
PosicionInicialAncho=301
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna(Info.CuentaA,SQL(<T>SELECT MAX(Cuenta) FROM Cta WHERE Rama = :tRama<T>,Info.Rama))
PosicionInicialIzquierda=532
PosicionInicialArriba=315
[(Variables)]
Estilo=Ficha
PestanaOtroNombre=S
PestanaNombre=Asigna Código
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
ListaEnCaptura=Info.CuentaD<BR>Info.CuentaA
CarpetaVisible=S
[(Variables).Info.CuentaD]
Carpeta=(Variables)
Clave=Info.CuentaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.CuentaA]
Carpeta=(Variables)
Clave=Info.CuentaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.AsignaVariables]
Nombre=AsignaVariables
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Aceptar.AsignaCodigo]
Nombre=AsignaCodigo
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
Expresion=Asigna(Info.Mensaje, SQL(<T>spAsignaCodigoAgrupador :tCuentaD,:tCuentaA,:tClaveSAT<T>, Info.CuentaD, Info.CuentaA, Info.Valor ))<BR>Informacion(Info.Mensaje)<BR>Asigna(Info.Estatus, <T>OK<T>)
EjecucionCondicion=ConDatos(Info.CuentaD) y ConDatos(Info.CuentaA) y ConDatos(Info.Valor)
EjecucionMensaje=<T>Debe asignar valores a todos los campos<T>
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Info.Estatus = <T>OK<T>
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsignaVariables<BR>AsignaCodigo<BR>Aceptar
Activo=S
Visible=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

