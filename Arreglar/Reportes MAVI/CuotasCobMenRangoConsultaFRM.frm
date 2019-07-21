
[Forma]
Clave=CuotasCobMenRangoConsultaFRM
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
Nombre=CuotasCobMenRangoConsultaFRM

ListaCarpetas=(Lista)
CarpetaPrincipal=GridRango
Menus=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=10
PosicionInicialArriba=156
PosicionInicialAlturaCliente=612
PosicionInicialAncho=1262
PosicionSec1=93
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=(Lista)
ExpresionesAlMostrar=Asigna(Mavi.DM0500BIDTMP,Nulo)<BR>Asigna(Mavi.DM0500BTipoComisionTMP,<T>%<T>)<BR>Asigna(Mavi.DM0500BTipoAgenteTMP,<T>%<T>)<BR>Asigna(Mavi.DM0500BNivelCobranzaTMP,<T>%<T>)<BR>Asigna(Mavi.DM0500BTipoCuotaTMP,<T>%<T>)<BR>Asigna(Mavi.DM0500BLocalidadTMP,<T>%<T>)<BR>Asigna(Mavi.DM0500BPremioTMP,0)<BR>Asigna(Mavi.DM0500BActivaTMP,<T>%<T>)
MenuPrincipal=&Archivo
[GridRango]
Estilo=Hoja
Pestana=S
Clave=GridRango
OtroOrden=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=CuotasCobMenRVVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)

ListaOrden=(Lista)
CarpetaVisible=S


PestanaOtroNombre=S
PestanaNombre=Cuotas
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática















[GridRango.Columnas]
TipoComision=107
TipoAgente=76
NivelCobranza=124
TipoCuota=104
Localidad=111
IN_RangoInicial=82
IN_RangoFinal=78
DV_Inicial=51
DV_Final=61
Requerido=56
SaldoMinimo=64
Cuota_Fija=64
Cuota_Porcentaje=88
PremioDeduccion=88
Activa=43





RangoInicial=64
RangoFinal=64
PremioDeduccion_1=85
Apoyo=64


ID=64
PremioDeduccion_V=97
CUOTA_%_CAPITAL=104
CAPITAL_PROMEDIO=106
DV_PROMEDIO=77
DI_PROMEDIO=75
DIAS_REGULARIZACION=123
CUOTA_PORC_CAPITAL=99



PremioDeduccionV=91
[Variables.ListaEnCaptura]
(Inicio)=Mavi.DM0500BTipoComision
Mavi.DM0500BTipoComision=Mavi.DM0500BTipoAgente
Mavi.DM0500BTipoAgente=Mavi.DM0500BNivelCobranza
Mavi.DM0500BNivelCobranza=Mavi.DM0500BTipoCuota
Mavi.DM0500BTipoCuota=Mavi.DM0500BLocalidad
Mavi.DM0500BLocalidad=Mavi.DM0500BActiva
Mavi.DM0500BActiva=(Fin)


[(Variables)]
Estilo=Ficha
Pestana=S
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)

CarpetaVisible=S
PermiteEditar=S

PestanaOtroNombre=S
PestanaNombre=Filtros






[Lista.Columnas]
TipoComisionMavi=304

TipoCuotaMavi=236
Tipo=197
Nombre=282
Opcion=174
[vAgenteTipo.Columnas]
Tipo=124

[NivelCobBasicoyEspMaviFRM.Columnas]
Nombre=282

[vLocalidadAgenteMaviFRM.Columnas]
Opcion=218






[Acciones.Filtrar]
Nombre=Filtrar
Boton=82
NombreDesplegar=Actualizar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S







ListaAccionesMultiples=(Lista)

[Acciones.Filtrar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Filtrar.Refresh]
Nombre=Refresh
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S





Expresion=Forma.ActualizarVista(<T>GridRango<T>)
[Acciones.Exportar]
Nombre=Exportar
Boton=67
NombreDesplegar=Exportar Cuotas
EnBarraHerramientas=S
Carpeta=GridRango
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S







EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Alt+F4
NombreDesplegar=Cerrar
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S










[GridRango.ID]
Carpeta=GridRango
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.TipoComision]
Carpeta=GridRango
Clave=TipoComision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.TipoAgente]
Carpeta=GridRango
Clave=TipoAgente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.NivelCobranza]
Carpeta=GridRango
Clave=NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.TipoCuota]
Carpeta=GridRango
Clave=TipoCuota
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.Localidad]
Carpeta=GridRango
Clave=Localidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.IN_RangoInicial]
Carpeta=GridRango
Clave=IN_RangoInicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.IN_RangoFinal]
Carpeta=GridRango
Clave=IN_RangoFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.DV_Inicial]
Carpeta=GridRango
Clave=DV_Inicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.DV_Final]
Carpeta=GridRango
Clave=DV_Final
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.Requerido]
Carpeta=GridRango
Clave=Requerido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.SaldoMinimo]
Carpeta=GridRango
Clave=SaldoMinimo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.Cuota_Fija]
Carpeta=GridRango
Clave=Cuota_Fija
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.Cuota_Porcentaje]
Carpeta=GridRango
Clave=Cuota_Porcentaje
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.PremioDeduccion]
Carpeta=GridRango
Clave=PremioDeduccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.CUOTA_PORC_CAPITAL]
Carpeta=GridRango
Clave=CUOTA_PORC_CAPITAL
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.CAPITAL_PROMEDIO]
Carpeta=GridRango
Clave=CAPITAL_PROMEDIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.DV_PROMEDIO]
Carpeta=GridRango
Clave=DV_PROMEDIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.DI_PROMEDIO]
Carpeta=GridRango
Clave=DI_PROMEDIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.DIAS_REGULARIZACION]
Carpeta=GridRango
Clave=DIAS_REGULARIZACION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.Activa]
Carpeta=GridRango
Clave=Activa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.RangoInicial]
Carpeta=GridRango
Clave=RangoInicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.RangoFinal]
Carpeta=GridRango
Clave=RangoFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.PremioDeduccionV]
Carpeta=GridRango
Clave=PremioDeduccionV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[GridRango.Apoyo]
Carpeta=GridRango
Clave=Apoyo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro



[GridRango.ListaEnCaptura]
(Inicio)=ID
ID=TipoComision
TipoComision=TipoAgente
TipoAgente=NivelCobranza
NivelCobranza=TipoCuota
TipoCuota=Localidad
Localidad=IN_RangoInicial
IN_RangoInicial=IN_RangoFinal
IN_RangoFinal=DV_Inicial
DV_Inicial=DV_Final
DV_Final=Requerido
Requerido=SaldoMinimo
SaldoMinimo=Cuota_Fija
Cuota_Fija=Cuota_Porcentaje
Cuota_Porcentaje=PremioDeduccion
PremioDeduccion=CUOTA_PORC_CAPITAL
CUOTA_PORC_CAPITAL=CAPITAL_PROMEDIO
CAPITAL_PROMEDIO=DV_PROMEDIO
DV_PROMEDIO=DI_PROMEDIO
DI_PROMEDIO=DIAS_REGULARIZACION
DIAS_REGULARIZACION=Activa
Activa=RangoInicial
RangoInicial=RangoFinal
RangoFinal=PremioDeduccionV
PremioDeduccionV=Apoyo
Apoyo=(Fin)

[GridRango.ListaOrden]
(Inicio)=Activa	(Acendente)
Activa	(Acendente)=ID	(Acendente)
ID	(Acendente)=TipoComision	(Acendente)
TipoComision	(Acendente)=TipoAgente	(Acendente)
TipoAgente	(Acendente)=NivelCobranza	(Acendente)
NivelCobranza	(Acendente)=TipoCuota	(Acendente)
TipoCuota	(Acendente)=Localidad	(Acendente)
Localidad	(Acendente)=IN_RangoInicial	(Acendente)
IN_RangoInicial	(Acendente)=IN_RangoFinal	(Acendente)
IN_RangoFinal	(Acendente)=(Fin)













[(Variables).ListaEnCaptura]
(Inicio)=Mavi.DM0500BTipoComisionTMP
Mavi.DM0500BTipoComisionTMP=Mavi.DM0500BTipoAgenteTMP
Mavi.DM0500BTipoAgenteTMP=Mavi.DM0500BNivelCobranzaTMP
Mavi.DM0500BNivelCobranzaTMP=Mavi.DM0500BTipoCuotaTMP
Mavi.DM0500BTipoCuotaTMP=Mavi.DM0500BLocalidadTMP
Mavi.DM0500BLocalidadTMP=Mavi.DM0500BActivaTMP
Mavi.DM0500BActivaTMP=(Fin)

[(Variables).Mavi.DM0500BTipoComisionTMP]
Carpeta=(Variables)
Clave=Mavi.DM0500BTipoComisionTMP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0500BTipoAgenteTMP]
Carpeta=(Variables)
Clave=Mavi.DM0500BTipoAgenteTMP
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0500BNivelCobranzaTMP]
Carpeta=(Variables)
Clave=Mavi.DM0500BNivelCobranzaTMP
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0500BTipoCuotaTMP]
Carpeta=(Variables)
Clave=Mavi.DM0500BTipoCuotaTMP
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0500BLocalidadTMP]
Carpeta=(Variables)
Clave=Mavi.DM0500BLocalidadTMP
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0500BActivaTMP]
Carpeta=(Variables)
Clave=Mavi.DM0500BActivaTMP
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro





































[Acciones.Filtrar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Refresh
Refresh=(Fin)











[Forma.ListaCarpetas]
(Inicio)=GridRango
GridRango=(Variables)
(Variables)=(Fin)

[Forma.ListaAcciones]
(Inicio)=Filtrar
Filtrar=Exportar
Exportar=Cerrar
Cerrar=(Fin)


