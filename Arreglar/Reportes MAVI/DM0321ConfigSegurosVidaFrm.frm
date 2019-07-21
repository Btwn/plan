
[Forma]
Clave=DM0321ConfigSegurosVidaFrm
Icono=34
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal

ListaCarpetas=Config Seguros Vista
CarpetaPrincipal=Config Seguros Vista




PosicionInicialIzquierda=453
PosicionInicialArriba=228
PosicionInicialAlturaCliente=273
PosicionInicialAncho=460
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cerrar
VentanaSinIconosMarco=S
Nombre=DM0321 Configuración de Seguros
[Config Seguros Vista]
Estilo=Hoja
Clave=Config Seguros Vista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0321ConfigSegurosVidaVis
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
ListaEnCaptura=DM0321ConfigSegurosVidaTbl.NombreParametro<BR>DM0321ConfigSegurosVidaTbl.Parametro<BR>DM0321ConfigSegurosVidaTbl.FechaInicioVigencia
CarpetaVisible=S

GuardarPorRegistro=S
[Config Seguros Vista.DM0321ConfigSegurosVidaTbl.NombreParametro]
Carpeta=Config Seguros Vista
Clave=DM0321ConfigSegurosVidaTbl.NombreParametro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Config Seguros Vista.DM0321ConfigSegurosVidaTbl.Parametro]
Carpeta=Config Seguros Vista
Clave=DM0321ConfigSegurosVidaTbl.Parametro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Config Seguros Vista.DM0321ConfigSegurosVidaTbl.FechaInicioVigencia]
Carpeta=Config Seguros Vista
Clave=DM0321ConfigSegurosVidaTbl.FechaInicioVigencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Config Seguros Vista.Columnas]
NombreParametro=207
Parametro=95
FechaInicioVigencia=118

[Acciones.Cerrar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
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
NombreEnBoton=S
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar<BR>Cerrar
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>    Vacio(DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.NombreParametro) o  Vacio(DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.Parametro) o  Vacio(DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.FechaInicioVigencia)<BR>Entonces<BR>    Error(<T>Todos los parámetros son requeridos, no se pueden dejar campos vacios<T>) AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>    DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.NombreParametro=<T>Factor de Prima Mensual al Millar<T><BR>Entonces<BR>    Si<BR>        DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.Parametro >= SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Factor de Prima Mensual al Millar<T>)<BR>    Entonces<BR>        Error(<T>El parámetro <T>+COMILLAS(<T>Factor de Prima Mensual al Millar<T>)+<T> rebaza el limite establecido, debe ser menor o igual a <T>+SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Factor de Prima Mensual al Millar<T>)) AbortarOperacion<BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Fin<BR><BR>Si<BR>    DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.NombreParametro=<T>Prima de Riesgo Mensual al Millar<T> <BR>Entonces    <BR>    Si    <BR>        DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.Parametro >= SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Prima de Riesgo Mensual al Millar<T>)<BR>    Entonces<BR>        Error(<T>El parámetro <T>+COMILLAS(<T>Prima de Riesgo Mensual al Millar<T>)+<T> rebaza el limite establecido, debe ser menor o igual a <T>+SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Prima de Riesgo Mensual al Millar<T>)) AbortarOperacion<BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Fin<BR><BR>Si<BR>    DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.NombreParametro=<T>Porcentaje UDI con IVA Aseguradora<T> <BR>Entonces<BR>    Si<BR>        DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.Parametro >= SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Porcentaje UDI con IVA Aseguradora<T>)<BR>    Entonces<BR>        Error(<T>El parámetro <T>+COMILLAS(<T>Porcentaje UDI con IVA Aseguradora<T>)+<T> rebaza el limite establecido, debe ser menor o igual a <T>+SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Porcentaje UDI con IVA Aseguradora<T>)) AbortarOperacion<BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Fin<BR><BR>Si<BR>    DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.NombreParametro=<T>Porcentaje UDI con IVA Asistencia<T> <BR>Entonces<BR>    Si    <BR>        DM0321ConfigSegurosVidaVis:DM0321ConfigSegurosVidaTbl.Parametro >= SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Porcentaje UDI con IVA Asistencia<T>)<BR>    Entonces<BR>        Error(<T>El parámetro <T>+COMILLAS(<T>Porcentaje UDI con IVA Asistencia<T>)+<T> rebaza el limite establecido, debe ser menor o igual a <T>+SQL(<T>SELECT DISTINCT Valor FROM TABLASTD WHERE TABLAST = :tTabla AND Nombre = :tNombre<T>,<T>DM0321ParametroSegVida<T>,<T>Porcentaje UDI con IVA Asistencia<T>)) AbortarOperacion<BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Fin

