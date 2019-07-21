[Forma]
Clave=RM0995CXCFiltroPrincipalfrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Variables<BR>Variablesmes<BR>Categoria
CarpetaPrincipal=Variables
PosicionInicialIzquierda=325
PosicionInicialArriba=153
PosicionInicialAlturaCliente=343
PosicionInicialAncho=212
Nombre=RM0995 Bitacora de Bonificaciones Cobranza
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=TXT<BR>Ok<BR>asignavar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=93
PosicionSec2=195
PosicionCol3=173
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.Mes,Nulo)<BR>Asigna(Info.Ano,Nulo)<BR>Asigna(Mavi.RM0995Categoria,<T>Credito Menudeo<T>)<BR>ASigna(MAVI.RM0995Saldo,<T>Todo<T>)
ExpresionesAlCerrar=SI condatos(Mavi.mes)<BR> Entonces<BR>  Asigna(Info.FechaD,Nulo)<BR>  Asigna(Info.FechaA,Nulo)<BR><BR> FIN
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Arriba
FichaAlineacion=Izquierda
[Variables.Info.FechaD]
Carpeta=Variables
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.FechaA]
Carpeta=Variables
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Ok]
Nombre=Ok
Boton=0
NombreEnBoton=S
NombreDesplegar=&Ok
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsignarVariables<BR>CerrarVentana<BR>Abrir
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Forma.accion(<T>asignavar<T>)<BR><BR> SI ConDatos(info.fechad) y Condatos(Info.fechaa)<BR>  entonces<BR>    verdadero<BR>   sino<BR>     SI ConDatos(Mavi.Mes) y Condatos(Info.ano)<BR>      Entonces<BR>       Verdadero<BR>      SIno<BR>       FALSO<BR>      FIN<BR> FIN<BR><BR><BR>/*SI ConDatos(Mavi.Mes)<BR>   Entonces<BR>    Verdadero<BR>   SIno<BR>    FALSO<BR>   FIN<BR>   */
EjecucionMensaje=SI  Longitud( mavi.RM0995Saldo )< 1<BR>Entonces<BR><BR> <T>Debe especificar el tipo de Saldo<T><BR>SINO<BR><T>Debe seleccionar un rango de fechas<BR> o el mes y el año<T><BR> Fin
[Acciones.Ok.AsignarVariables]
Nombre=AsignarVariables
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Ok.CerrarVentana]
Nombre=CerrarVentana
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Ok.Abrir]
Nombre=Abrir
Boton=0
TipoAccion=Formas
ClaveAccion=RM0995CXCBitacoraBonifCobFRM
Activo=S
Visible=S
[Acciones.TXT]
Nombre=TXT
Boton=70
NombreEnBoton=S
NombreDesplegar=TXT
Multiple=S
EnBarraAcciones=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar / Ventana Aceptar<BR>Rlacion4<BR>Relacion3<BR>relacion2<BR>Relacion5<BR>Aceptar
[Acciones.TXT.Variables Asignar / Ventana Aceptar]
Nombre=Variables Asignar / Ventana Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.TXT.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.TXT.Relacion3]
Nombre=Relacion3
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0995CXCDetallesRep
Activo=S
Visible=S
[Acciones.TXT.relacion2]
Nombre=relacion2
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0995CXCAreasMotorasRep
Activo=S
Visible=S
[Variablesmes]
Estilo=Ficha
Clave=Variablesmes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.Mes<BR>Info.Ano
PermiteEditar=S
[Variablesmes.Mavi.Mes]
Carpeta=Variablesmes
Clave=Mavi.Mes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variablesmes.Info.Ano]
Carpeta=Variablesmes
Clave=Info.Ano
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Categoria]
Estilo=Ficha
Clave=Categoria
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0995Categoria<BR>Mavi.RM0995Saldo
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Acciones.asignavar]
Nombre=asignavar
Boton=0
NombreDesplegar=asignavar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[VariableResumen.Mavi.RM0995CanalVenta]
Carpeta=VariableResumen
Clave=Mavi.RM0995CanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Categoria.Mavi.RM0995Categoria]
Carpeta=Categoria
Clave=Mavi.RM0995Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Categoria.Mavi.RM0995Saldo]
Carpeta=Categoria
Clave=Mavi.RM0995Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[Acciones.TXT.Rlacion4]
Nombre=Rlacion4
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=rm0995ResumenRep
Activo=S
Visible=S
[Acciones.TXT.Relacion5]
Nombre=Relacion5
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0995HistoricoRep
Activo=S
Visible=S




