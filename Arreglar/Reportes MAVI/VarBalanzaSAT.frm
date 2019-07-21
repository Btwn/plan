[Forma]
Clave=VarBalanzaSAT
Nombre=Seleccione el Periodo
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=211
PosicionInicialAncho=202
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
PosicionInicialIzquierda=578
PosicionInicialArriba=317



VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Info.Empresa, Empresa)











































[Acciones.Aceptar.AsignaVariables]
Nombre=AsignaVariables
Boton=0
TipoAccion=Expresion

Activo=S
Visible=S
Expresion=GuardarCambios<BR>Asigna( Info.Ejercicio, ContSatPeriodoBalanza:ContSatPeriodoBalanza.Ejercicio)<BR>Asigna( Info.Periodo, ContSatPeriodoBalanza:ContSatPeriodoBalanza.Periodo)<BR>Asigna( Info.CtaNivel, ContSatPeriodoBalanza:ContSatPeriodoBalanza.Nivel)<BR>Si<BR>  ContSatPeriodoBalanza:ContSatPeriodoBalanza.ConMovtos = 1<BR>Entonces<BR>  Asigna( Info.ConMovimientos, <T>Si<T>)                                          <BR>Sino<BR>  Asigna( Info.ConMovimientos, <T>No<T>)<BR>Fin
[Acciones.Aceptar.MuestraBalanza]
Nombre=MuestraBalanza
Boton=0
TipoAccion=Formas
ClaveAccion=BalanzaCompSAT
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsignaVariables<BR>MuestraBalanza<BR>Cerrar
Activo=S
Visible=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Lista]
Estilo=Ficha
PestanaOtroNombre=S
PestanaNombre=Ejercicio y Periodo
Clave=Lista
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSatPeriodoBalanza
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ContSatPeriodoBalanza.Ejercicio<BR>ContSatPeriodoBalanza.Periodo<BR>ContSatPeriodoBalanza.Nivel<BR>ContSatPeriodoBalanza.ConMovtos
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S

FiltroGeneral={<T>ContSatPeriodoBalanza.Estacion = <T>& Comillas(EstacionTrabajo)}<BR>AND<BR>{<T>ContSatPeriodoBalanza.Empresa = <T>& Comillas(Empresa)}
[Lista.ContSatPeriodoBalanza.Ejercicio]
Carpeta=Lista
Clave=ContSatPeriodoBalanza.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.ContSatPeriodoBalanza.Periodo]
Carpeta=Lista
Clave=ContSatPeriodoBalanza.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.ContSatPeriodoBalanza.Nivel]

Carpeta=Lista
Clave=ContSatPeriodoBalanza.Nivel

Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.ContSatPeriodoBalanza.ConMovtos]
Carpeta=Lista
Clave=ContSatPeriodoBalanza.ConMovtos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=20

