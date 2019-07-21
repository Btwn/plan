[Forma]
Clave=DM0214exportar
Icono=0
Modulos=(Todos)
ListaCarpetas=variables
CarpetaPrincipal=variables
PosicionInicialIzquierda=409
PosicionInicialArriba=371
PosicionInicialAlturaCliente=168
PosicionInicialAncho=247
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cancelar<BR>Aceptar<BR>repzonas<BR>repagentes<BR>reprutas
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
Nombre=DM0214exportar
[variables]
Estilo=Ficha
Clave=variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214exportarVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Escoger Nivel Cobranza
ListaEnCaptura=DM0214ZonasCobranza.NivelCobranza
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=afectar<BR>variables<BR>cancela<BR>llamrreporte<BR>cierra
EspacioPrevio=S
[Acciones.Aceptar.variables]
Nombre=variables
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Mavi.NivelCobranza,DM0214exportarVis:DM0214ZonasCobranza.NivelCobranza)
[Acciones.Aceptar.cierra]
Nombre=cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Aceptar.afectar]
Nombre=afectar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Registro Afectar
Activo=S
Visible=S
Carpeta=(Carpeta principal)
[Acciones.Aceptar.cancela]
Nombre=cancela
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[variables.DM0214ZonasCobranza.NivelCobranza]
Carpeta=variables
Clave=DM0214ZonasCobranza.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cancelar]
Nombre=Cancelar
Boton=21
NombreEnBoton=S
NombreDesplegar=&Cancelar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=cancelarcambios<BR>Cierra
[Acciones.Cancelar.cancelarcambios]
Nombre=cancelarcambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cancelar.Cierra]
Nombre=Cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.llamrreporte]
Nombre=llamrreporte
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=caso Info.Modulo<BR>es <T>Zonas<T><BR>entonces<BR>//ReportePantalla(<T>DM0214AgrupaZonaCobranzaRep<T>)<BR>Forma.Accion(<T>repzonas<T>)<BR>es <T>Rutas<T><BR>entonces<BR>//ReportePantalla(<T>DM0214RutasRep<T> )<BR>Forma.Accion(<T>reprutas<T>)<BR>es <T>Agentes<T><BR>entonces<BR>Forma.Accion(<T>repagentes<T>)<BR>//ReportePantalla(<T>DM0214ZonaRep<T> )<BR><BR>fin
[Acciones.repzonas]
Nombre=repzonas
Boton=0
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=DM0214AgrupaZonaCobranzaRep
Activo=S
Visible=S
[Acciones.repagentes]
Nombre=repagentes
Boton=0
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=DM0214ZonaRep
Activo=S
Visible=S
[Acciones.reprutas]
Nombre=reprutas
Boton=0
EnBarraHerramientas=S
TipoAccion=Reportes Excel
Activo=S
Visible=S
ClaveAccion=DM0214RutasRep


