[Forma]
Clave=DM0207NuevoNivelFrm
Nombre=DM0207NuevoNivelFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=463
PosicionInicialArriba=408
PosicionInicialAlturaCliente=93
PosicionInicialAncho=295
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=crear<BR>cancelar
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
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=MAvi.DM0207Nivel
[(Variables).MAvi.DM0207Nivel]
Carpeta=(Variables)
Clave=MAvi.DM0207Nivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.cancelar]
Nombre=cancelar
Boton=5
NombreDesplegar=Cancelar&
Multiple=S
EnBarraHerramientas=S
TipoAccion=Ventana
ListaAccionesMultiples=abrir<BR>cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.cancelar.abrir]
Nombre=abrir
Boton=0
TipoAccion=Formas
ClaveAccion=DM0207NivelCobranzaDivFrm
Activo=S
Visible=S
[Acciones.cancelar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.crear]
Nombre=crear
Boton=57
NombreEnBoton=S
NombreDesplegar=Crear Nivel&
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asignar<BR>crear<BR>abrir<BR>cerrar
[Acciones.crear.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.crear.crear]
Nombre=crear
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=EjecutarSQL(<T>EXEC SP_DM0207EliminarDivision :tDiv, :tNom, :nOpc, :tUsr<T>, MAvi.DM0207Division, MAvi.DM0207Nivel,3,Usuario )
EjecucionCondicion=Si Vacio(MAvi.DM0207Nivel)<BR>Entonces<BR>    Error(<T>Debe llenar el campo Nivel<T>)<BR>Sino<BR>    Si SQL(<T>Select COUNT(Nombre) From NivelCobranzaMavi Where Nombre = :tNom<T>,MAvi.DM0207Nivel) > 0<BR>    Entonces<BR>        Si SQL(<T>Select COUNT(Nombre) From NivelCobranzaMaviDiv Where Nombre = :tNom AND Division = :tDiv<T>,MAvi.DM0207Nivel,MAvi.DM0207Division)  > 0<BR>        Entonces<BR>            Error(<T>Ese Nivel ya existe en la division seleccionada, elija otro<T>)<BR>        Sino<BR>            Verdadero<BR>        Fin<BR>    Sino<BR>      Error(<T>El nivel escrito no existe en la tabla NivelCobranzaMavi<T>)<BR>    Fin<BR>Fin
[Acciones.crear.abrir]
Nombre=abrir
Boton=0
TipoAccion=Formas
ClaveAccion=DM0207NivelCobranzaDivFrm
Activo=S
Visible=S
[Acciones.crear.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

