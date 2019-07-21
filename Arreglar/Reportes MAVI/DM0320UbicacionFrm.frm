
[Forma]
Clave=DM0320UbicacionFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Ubicacion
CarpetaPrincipal=Ubicacion
PosicionInicialIzquierda=403
PosicionInicialArriba=426
PosicionInicialAlturaCliente=134
PosicionInicialAncho=474
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Agregar<BR>Eliminar<BR>Salir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
Nombre=Layout para Almacén
IniciarAgregando=S
[Ubicacion]
Estilo=Ficha
Clave=Ubicacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0320UbicacionVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0320UbicacionTbl.Articulo<BR>DM0320UbicacionTbl.Descripcion<BR>DM0320UbicacionTbl.Modulo<BR>DM0320UbicacionTbl.Rack<BR>DM0320UbicacionTbl.Nivel<BR>DM0320UbicacionTbl.Otros
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
PermiteEditar=S
[Ubicacion.DM0320UbicacionTbl.Articulo]
Carpeta=Ubicacion
Clave=DM0320UbicacionTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Ubicacion.DM0320UbicacionTbl.Descripcion]
Carpeta=Ubicacion
Clave=DM0320UbicacionTbl.Descripcion
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Ubicacion.DM0320UbicacionTbl.Modulo]
Carpeta=Ubicacion
Clave=DM0320UbicacionTbl.Modulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Ubicacion.DM0320UbicacionTbl.Rack]
Carpeta=Ubicacion
Clave=DM0320UbicacionTbl.Rack
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Ubicacion.DM0320UbicacionTbl.Nivel]
Carpeta=Ubicacion
Clave=DM0320UbicacionTbl.Nivel
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Ubicacion.DM0320UbicacionTbl.Otros]
Carpeta=Ubicacion
Clave=DM0320UbicacionTbl.Otros
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Ubicacion.Columnas]
Articulo=64
Descripcion=304
Modulo=38
Rack=34
Nivel=34
Otros=94

[Articulo.Columnas]
Articulo=125
Descripcion1=604

[Acciones.Salir]
Nombre=Salir
Boton=36
NombreDesplegar=&Salir
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S


Multiple=S
ListaAccionesMultiples=Cancelar<BR>Cerrar
NombreEnBoton=S
BtnResaltado=S
[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Salir.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Ubicación
EnBarraHerramientas=S
BtnResaltado=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S





ConCondicion=S
Multiple=S
ListaAccionesMultiples=Guard<BR>Actualiza
EjecucionCondicion=Si ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Articulo)<BR>    Entonces<BR>        Si SQL(<T>SELECT Disponible FROM V_MAVIDM0135IDTRANSITO WHERE Almacen=<T> + Comillas(<T>V00096<T>) + <T> AND Articulo = :tArticulo AND Descripcion1 = :tDescripcion<T>,DM0320UbicacionVis:DM0320UbicacionTbl.Articulo,DM0320UbicacionVis:DM0320UbicacionTbl.Descripcion) = 0<BR>            Entonces<BR>                Error(<T>No hay existencia de ese artículo<T>)<BR>                AbortarOperacion<BR>            Sino<BR>                Verdadero<BR>        Fin<BR>     Sino<BR>        Informacion(<T>Es necesario especificar un artículo<T>)<BR>        AbortarOperacion<BR>Fin<BR><BR>Si ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Articulo)<BR>    Entonces<BR>        Si SQL(<T>SELECT COUNT(*) FROM Art WHERE Articulo = :tArticulo AND Estatus IN (<T> + Comillas(<T>ALTA<T>) + <T>,<T> + Comillas(<T>BLOQUEADO<T>) + <T>,<T> + Comillas(<T>DESCONTINUADO<T>) + <T>,<T> + Comillas(<T>BAJA<T>) + <T>)<T>,DM0320UbicacionVis:DM0320UbicacionTbl.Articulo) = 0<BR>            Entonces<BR>                Error(<T>Artículo no existe.<T>)<BR>                AbortarOperacion<BR>            Sino<BR>                Verdadero<BR>Fin<BR><BR>Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDAtos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>Entonces<BR>    Informacion(<T>Es necesario especificar Módulo<T>)<BR>Sino<BR>    Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>    Entonces<BR>        Informacion(<T>Es necesario especificar Módulo y Rack<T>)<BR>    Sino<BR>        Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>        Entonces<BR>            Informacion(<T>Es necesario especificar Rack<T>)<BR>        Sino<BR>            Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>            Entonces<BR>                Informacion(<T>Es necesario especificar Rack y Nivel<T>)<BR>            Sino<BR>                Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack)<BR>                Entonces<BR>                    Informacion(<T>Es necesario especificar Nivel<T>)<BR>                Sino<BR>                    Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack)<BR>                    Entonces<BR>                        Informacion(<T>Es necesario especificar Módulo y Nivel<T>)<BR>                    Sino<BR>                        Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Otros)<BR>                        Entonces<BR>                            Informacion(<T>Es necesario especificar los datos: Módulo, Rack y Nivel<T>)<BR>                            AbortarOperacion<BR>                        Sino<BR>                            Verdadero          <BR>Fin                                                       <BR><BR>Si ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>    Entonces<BR>        Asigna(DM0320UbicacionVis:DM0320UbicacionTbl.Ubicacion, <T>Rack <T>+ DM0320UbicacionVis:DM0320UbicacionTbl.Rack  +<T>, Modulo <T>+ DM0320UbicacionVis:DM0320UbicacionTbl.Modulo + <T>, Nivel <T> + DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>    Sino<BR>        Si ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Otros)<BR>            Entonces<BR>                Asigna(DM0320UbicacionVis:DM0320UbicacionTbl.Ubicacion, <T>Otros <T> + DM0320UbicacionVis:DM0320UbicacionTbl.Otros)<BR>Fin
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S




ConCondicion=S






[Acciones.Agregar]
Nombre=Agregar
Boton=35
NombreEnBoton=S
NombreDesplegar=&Agregar Ubicaciones
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0320ConfigLayoutFrm
Activo=S
Visible=S

BtnResaltado=S
Multiple=S
ListaAccionesMultiples=Cancelar<BR>Abrir<BR>Cerrar
[Acciones.Guardar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Articulo)<BR>    Entonces<BR>        Si SQL(<T>SELECT Disponible FROM V_MAVIDM0135IDTRANSITO WHERE Almacen=<T> + Comillas(<T>V00096<T>) + <T> AND Articulo = :tArticulo AND Descripcion1 = :tDescripcion<T>,DM0320UbicacionVis:DM0320UbicacionTbl.Articulo,DM0320UbicacionVis:DM0320UbicacionTbl.Descripcion) = 0          <BR>            Entonces<BR>                Error(<T>No hay existencia de ese artículo<T>)<BR>                AbortarOperacion<BR>            Sino<BR>                Verdadero<BR>        Fin<BR>     Sino<BR>        Informacion(<T>Es necesario especificar un artículo<T>)<BR>        AbortarOperacion<BR>Fin<BR><BR>Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDAtos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>Entonces<BR>    Informacion(<T>Es necesario especificar Módulo<T>)<BR>Sino<BR>    Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>    Entonces<BR>        Informacion(<T>Es necesario especificar Módulo y Rack<T>)<BR>    Sino<BR>        Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>        Entonces<BR>            Informacion(<T>Es necesario especificar Rack<T>)<BR>        Sino<BR>            Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>            Entonces<BR>                Informacion(<T>Es necesario especificar Rack y Nivel<T>)<BR>            Sino<BR>                Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack)<BR>                Entonces<BR>                    Informacion(<T>Es necesario especificar Nivel<T>)<BR>                Sino<BR>                    Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack)<BR>                    Entonces<BR>                        Informacion(<T>Es necesario especificar Módulo y Nivel<T>)<BR>                    Sino<BR>                        Si Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y  Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel) y Vacio(DM0320UbicacionVis:DM0320UbicacionTbl.Otros)<BR>                        Entonces<BR>                            Informacion(<T>Es necesario especificar los datos: Módulo, Rack y Nivel<T>)<BR>                            AbortarOperacion<BR>                        Sino<BR>                            Verdadero<BR>Fin<BR><BR>Si ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Modulo) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Rack) y ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>    Entonces<BR>        Asigna(DM0320UbicacionVis:DM0320UbicacionTbl.Ubicacion, <T>Rack <T>+ DM0320UbicacionVis:DM0320UbicacionTbl.Rack  +<T>, Modulo <T>+ DM0320UbicacionVis:DM0320UbicacionTbl.Modulo + <T>, Nivel <T> + DM0320UbicacionVis:DM0320UbicacionTbl.Nivel)<BR>    Sino<BR>        Si ConDatos(DM0320UbicacionVis:DM0320UbicacionTbl.Otros)                                                                                                                    <BR>            Entonces<BR>                Asigna(DM0320UbicacionVis:DM0320UbicacionTbl.Ubicacion, <T>Otros <T> + DM0320UbicacionVis:DM0320UbicacionTbl.Otros)<BR>Fin
[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S


[Acciones.Guardar.Guard]
Nombre=Guard
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar Ubicación
EnBarraHerramientas=S
BtnResaltado=S
TipoAccion=Formas
ClaveAccion=DM0320ModUbicacionFrm
Activo=S
Visible=S

[Acciones.Agregar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Agregar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Agregar.Abrir]
Nombre=Abrir
Boton=0
TipoAccion=Formas
ClaveAccion=DM0320ConfigLayoutFrm
Activo=S
Visible=S

