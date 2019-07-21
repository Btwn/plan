
[Forma]
Clave=ParPolizasSAT
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
Nombre=Parámetros

ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
PosicionInicialAlturaCliente=458
PosicionInicialAncho=357
PosicionInicialIzquierda=509
PosicionInicialArriba=140
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Tipo, Nulo)<BR>Asigna(Info.Ejercicio, Nulo)<BR>Asigna(Info.Periodo, Nulo)<BR>EjecutarSQL(<T>spContSATAsignaVarPolizas :nEstacion, 0<T>, EstacionTrabajo)
[Lista]
Estilo=Ficha
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ParPolizasSAT
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ParPolizasSAT.Ejercicio<BR>ParPolizasSAT.Periodo<BR>ParPolizasSAT.TipoArchivo<BR>ParPolizasSAT.TipoSolicitud<BR>ParPolizasSAT.NoSolicitud<BR>ParPolizasSAT.CuentaD<BR>ParPolizasSAT.CuentaA<BR>ParPolizasSAT.ProvD<BR>ParPolizasSAT.ProvA<BR>ParPolizasSAT.CteD<BR>ParPolizasSAT.CteA<BR>ParPolizasSAT.AcreedorD<BR>ParPolizasSAT.AcreedorA<BR>ParPolizasSAT.CasatD<BR>ParPolizasSAT.CasatA
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroGeneral={<T>ParPolizasSAT.Estacion = <T>} { EstacionTrabajo }
FiltroRespetar=S
FiltroTipo=General
[Lista.ParPolizasSAT.Ejercicio]
Carpeta=Lista
Clave=ParPolizasSAT.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
ColorFuente=Negro
[Lista.ParPolizasSAT.Periodo]
Carpeta=Lista
Clave=ParPolizasSAT.Periodo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
ColorFuente=Negro
[Lista.ParPolizasSAT.TipoSolicitud]
Carpeta=Lista
Clave=ParPolizasSAT.TipoSolicitud
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=41
ColorFuente=Negro
[Lista.ParPolizasSAT.TipoArchivo]
Carpeta=Lista
Clave=ParPolizasSAT.TipoArchivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=41
EspacioPrevio=S
ColorFuente=Negro
[Lista.ParPolizasSAT.CuentaA]
Carpeta=Lista
Clave=ParPolizasSAT.CuentaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.CuentaD]
Carpeta=Lista
Clave=ParPolizasSAT.CuentaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

EspacioPrevio=S
ColorFuente=Negro
[Lista.ParPolizasSAT.ProvA]
Carpeta=Lista
Clave=ParPolizasSAT.ProvA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.ProvD]
Carpeta=Lista
Clave=ParPolizasSAT.ProvD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.CteA]
Carpeta=Lista
Clave=ParPolizasSAT.CteA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.CteD]
Carpeta=Lista
Clave=ParPolizasSAT.CteD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.AcreedorA]
Carpeta=Lista
Clave=ParPolizasSAT.AcreedorA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.AcreedorD]
Carpeta=Lista
Clave=ParPolizasSAT.AcreedorD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.CasatA]
Carpeta=Lista
Clave=ParPolizasSAT.CasatA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ParPolizasSAT.CasatD]
Carpeta=Lista
Clave=ParPolizasSAT.CasatD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S

NombreEnBoton=S
ConCondicion=S
EjecucionConError=S
Multiple=S
ListaAccionesMultiples=Expresion
EjecucionCondicion=ConDatos(Info.Tipo)
EjecucionMensaje=Debe seleccionar un tipo de solicitud
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar/Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar/Cancelar Cambios
Activo=S
Visible=S

[Lista.Columnas]
Ejercicio=64
Periodo=64
TipoSolicitud=64
TipoArchivo=64
CuentaA=124
CuentaD=124
ProvA=64
ProvD=64
CteA=64
CteD=64
AcreedorA=64
AcreedorD=64
CasatA=244
CasatD=244
0=116
1=266
Proveedor=118
Nombre=300
ClaveSAT=139
Descripcion=152
Rama=117

Cliente=117
RFC=107
[Lista.ParPolizasSAT.NoSolicitud]
Carpeta=Lista
Clave=ParPolizasSAT.NoSolicitud
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=GuardarCambios<BR>Asigna(Info.Mensaje,SQL(<T>spContSATAsignaVarPolizas :tEstacion, 1<T>, EstacionTrabajo))<BR>Si<BR>  Info.Mensaje <> <T><T><BR>Entonces<BR>    Informacion(Info.Mensaje)<BR>Fin

