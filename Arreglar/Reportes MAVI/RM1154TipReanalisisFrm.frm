
[Forma]
Clave=RM1154TipReanalisisFrm
Icono=9
Modulos=(Todos)

CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=474
PosicionInicialArriba=259
PosicionInicialAlturaCliente=212
PosicionInicialAncho=417
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardarn<BR>Cerrar
MovModulo=(Todos)
Nombre=REANALISIS

VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaCarpetas=(Variables)

VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM1154TReanalisis, nulo)<BR>Asigna(Mavi.RM1154TipoRespuesta, nulo)<BR>Asigna(Mavi.RM1154Observaciones, nulo)<BR>Asigna(Mavi.RM1154UsuarioSol, nulo)
[RM1154Tipos.Columnas]
0=404

1=-2
[RM1154TipoRespuestaReanalisisVis.Columnas]
0=-2





1=-2
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Registro.RM1154TiposReanalisis.TipoRespuesta]
Carpeta=Registro
Clave=RM1154TiposReanalisis.TipoRespuesta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Registro.RM1154TiposReanalisis.Notas]
Carpeta=Registro
Clave=RM1154TiposReanalisis.Notas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Registro.RM1154TiposReanalisis.Fecha]
Carpeta=Registro
Clave=RM1154TiposReanalisis.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=
[Registro.RM1154TiposReanalisis.TipoEventos]
Carpeta=Registro
Clave=RM1154TiposReanalisis.TipoEventos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Registro.Columnas]
TipoEventos=304
TipoRespuesta=304
Notas=604
Fecha=94


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
ListaEnCaptura=Mavi.RM1154TReanalisis<BR>Mavi.RM1154UsuarioSol<BR>Mavi.RM1154TipoRespuesta<BR>Mavi.RM1154Observaciones<BR>Mavi.RM1154FechaHora
CarpetaVisible=S

FichaEspacioEntreLineas=8
FichaEspacioNombres=111
FichaColorFondo=Plata
FichaAlineacionDerecha=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
PermiteEditar=S
[(Variables).Mavi.RM1154TReanalisis]
Carpeta=(Variables)
Clave=Mavi.RM1154TReanalisis
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

EditarConBloqueo=S
[(Variables).Mavi.RM1154TipoRespuesta]
Carpeta=(Variables)
Clave=Mavi.RM1154TipoRespuesta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[(Variables).Mavi.RM1154Observaciones]
Carpeta=(Variables)
Clave=Mavi.RM1154Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=55
ColorFondo=Blanco

ConScroll=S
[(Variables).Mavi.RM1154FechaHora]
Carpeta=(Variables)
Clave=Mavi.RM1154FechaHora
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco


[Acciones.Guardar.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=EjecutarSQL(<T>Exec SpIRM1154_RegisReanalisis :nID,:tEvento,:tSucursal,:tUsuario,:tMovEstatus,:tMovSituacion,:fMovSituacionFecha,:tMovSituacionUsuario,:tMovSituacionNota,:tTipoRespuesta<T>,Info.ID,Info.Evento,Info.Sucursal,Info.Usuario,Mavi.RM1154MovEstatus,Mavi.RM1154MovSituacion,Mavi.RM1154MovSituacionFecha,Mavi.RM1154MovSituacionUsuario,Mavi.RM1154MovSituacionNota,Mavi.RM1154TipoRespuesta)                                    <BR> Informacion(Info.ID)<BR> Informacion(Info.Evento)<BR> Informacion(Mavi.RM1154MovEstatus)
[Acciones.Guardar.actualizar variables]
Nombre=actualizar variables
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Guardarn]
Nombre=Guardarn
Boton=3
NombreDesplegar=&Guardar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S

ListaAccionesMultiples=Actua<BR>expresion<BR>cerrar
[Acciones.Guardarn.Actua]
Nombre=Actua
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Guardarn.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

ConCondicion=S
Expresion=Si ConDatos(Mavi.RM1154TReanalisis)<BR>Entonces<BR>    Si (SQL(<T>SELECT COUNT(Valor) FROM TablaStD WHERE Valor= :tVAL and LEFT(Valor,3)= :tValor<T>,Mavi.RM1154TReanalisis,<T>MEN<T>)>0)<BR>    Entonces<BR>        EjecutarSQL(<T>Exec SpIRM1154_RegisReanalisis :nID,:tUsuario,:tEvento,:Agente,:tTipoRespuesta,:tObservacion<T>,Info.Numero,Info.Usuario,Mavi.RM1154TReanalisis,Mavi.RM1154UsuarioSol,Mavi.RM1154TipoRespuesta,Mavi.RM1154Observaciones)<BR>    Sino<BR>        informacion(<T>Error en la Clave de Evento<T>)<BR>fin
EjecucionCondicion=Si Vacio(Mavi.RM1154TReanalisis)<BR>Entonces<BR>    Error(<T>Ingrese un Tipo de Re Analisis.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si Vacio(Mavi.RM1154TipoRespuesta)<BR>Entonces<BR>    Error(<T>Ingrese un Tipo de Respuesta de Re Analisis.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>    Mavi.RM1154TReanalisis = <T>MEN05330<T> y Vacio(Mavi.RM1154UsuarioSol)<BR>Entonces<BR>    Error(<T>Debe ingresar al usuario que solicita el Re Analisis.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>    Mavi.RM1154TReanalisis = <T>MEN05330<T> y ConDatos(Mavi.RM1154UsuarioSol)<BR>Entonces<BR>    Si<BR>       (SQL(<T>SELECT UPPER(Estatus) FROM Agente WHERE Agente = :tAgente<T>,Mavi.RM1154UsuarioSol) = <T>ALTA<T>)<BR>       y (SQL(<T>SELECT LEFT(Agente,1) FROM Agente WHERE Agente = :tAgente<T>,Mavi.RM1154UsuarioSol) = <T>E<T>)<BR>       y (SQL(<T>SELECT Tipo FROM Agente WHERE Agente = :tAgente<T>,Mavi.RM1154UsuarioSol) en (<T>VENDEDOR<T>,<T>GERENTE<T>,<T>SUBGERENTE<T>,<T>SUPERVISOR<T>))<BR>       y (SQL(<T>SELECT Categoria FROM Agente WHERE Agente = :tAgente<T>,Mavi.RM1154UsuarioSol) = <T>VENTAS PISO<T>)<BR>    Entonces<BR>        Verdadero<BR>    Sino<BR>        Error(<T>El agente no es valido.<T>)<BR>        AbortarOperacion<BR>    Fin    <BR>Fin<BR><BR>Si<BR>    Mavi.RM1154TReanalisis en (<T>MEN05340<T>,<T>MEN05341<T>) y ConDatos(Mavi.RM1154UsuarioSol)<BR>Entonces<BR>    Error(<T>El agente no corresponde al tipo de Re Analisis.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin
[Acciones.Guardarn.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Vista.Columnas]
Nombre=346
0=88
1=-2
Valor=103

Agente=64
[(Variables).Mavi.RM1154UsuarioSol]
Carpeta=(Variables)
Clave=Mavi.RM1154UsuarioSol
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


