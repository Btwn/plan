
[Forma]
Clave=RM1096AMaxYMinManttoFrm
Icono=0
Modulos=(Todos)
Nombre=RM1096AMaximos Y Mininimos Mantto

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=138
PosicionInicialAncho=343
PosicionInicialIzquierda=312
PosicionInicialArriba=97
BarraAcciones=S
AccionesTamanoBoton=22x5
ListaAcciones=Generar<BR>Cerrar
AccionesCentro=S
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Mavi.RM1096ACategorias,Nulo),<BR>asigna(Info.Accion, Nulo),<BR>asigna(Info.Evento, Nulo),<BR>asigna(Mavi.RM1096ANumero , SQL(<T>SELECT TOP 1 numero FROM INVHUltimoEventoRegis WITH(NOLOCK) order by IdUltimoEventoRegis desc<T>))
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
ListaEnCaptura=Mavi.RM1096ACategorias<BR>Mavi.RM1096ANumero
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
MenuLocal=S
[(Variables).Mavi.RM1096ACategorias]
Carpeta=(Variables)
Clave=Mavi.RM1096ACategorias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1096ANumero]
Carpeta=(Variables)
Clave=Mavi.RM1096ANumero
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Generar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Generar]
Nombre=Generar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Generar Reporte
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Aceptar
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

[area.Columnas]
0=-2




[Acciones.Generar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S



ConCondicion=S


EjecucionCondicion=Si<BR>  ConDatos(Mavi.RM1096ANumero)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>El campo %Máximo es obligatorio<T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>    Si<BR>       (Mavi.RM1096ANumero > 0) y  (Mavi.RM1096ANumero <= 2)<BR>    Entonces<BR>      Verdadero<BR>    Sino<BR>       Error(<T>El % debe ser Mayor a 0 y Menor o igual a 2<T>)<BR>       AbortarOperacion<BR><BR><BR>Fin
[Acciones.Generar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S




[Acciones.cotizaaa.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.cotizaaa.agregar]
Nombre=agregar
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=/*EjecutarSQL(<T>EXEC SpINVGenerarCotizacion :tCat, :nNum, :tUsu<T>,  Comillas(Mavi.RM1096ACategorias)  , (Mavi.RM1096ANumero),  Usuario) */<BR><BR>informacion(Mavi.RM1096ACategorias)<BR>informacion((Mavi.RM1096ANumero)<BR>informacion(Usuario)


