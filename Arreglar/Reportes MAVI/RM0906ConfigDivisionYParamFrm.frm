
[Forma]
Clave=RM0906ConfigDivisionYParamFrm
Icono=25
Modulos=(Todos)
Nombre=Configuración de Divisiones y Rangos

ListaCarpetas=RM0906ConfigDivisionYParamVis
CarpetaPrincipal=RM0906ConfigDivisionYParamVis
PosicionInicialAlturaCliente=582
PosicionInicialAncho=689
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=guardar<BR>EnviarExcel<BR>ELIMINAR
PosicionInicialIzquierda=295
PosicionInicialArriba=198
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

VentanaBloquearAjuste=S
ExpresionesAlCerrar=/*Ejecutarsql(<T>EXEC SPIRM0906_HistoricoConfDiv :nOption,:nID,:tUsuario,:tDivision,:nDV,:nDI,:nProA,:nProB<T>,2,0,0,0,0,0,0,0)*/
[RM0906ConfiguraciondeDivyRanVis.Columnas]
Division=214
DV=74
DI=74
ProcdeAbonoFinal=106
ProcdeBonificaciondeInteres=164


ID=74
[Acciones.guardar]
Nombre=guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar y Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

GuardarAntes=S
[Acciones.EnviarExcel]
Nombre=EnviarExcel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar Excel
EnBarraHerramientas=S
Carpeta=RM0906ConfiguraciondeDivyRanXls
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S

[vista.Columnas]
division=214



Division=214
[Acciones.guardar.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Ejecutarsql(<T>EXEC SPIRM0906_HistoricoConfDiv :tUsuario,:tDivision,:nDV,:nDI,:nProA,:nProB<T>,Usuario, RM0906ConfiguraciondeDivyRanVis:RM0906ConfiguraciondeDivyRanTbl.Division,RM0906ConfiguraciondeDivyRanVis:RM0906ConfiguraciondeDivyRanTbl.DV,RM0906ConfiguraciondeDivyRanVis:RM0906ConfiguraciondeDivyRanTbl.DI,RM0906ConfiguraciondeDivyRanVis:RM0906ConfiguraciondeDivyRanTbl.ProcdeAbonoFinal,RM0906ConfiguraciondeDivyRanVis:RM0906ConfiguraciondeDivyRanTbl.ProcdeBonificaciondeInteres)
[Acciones.guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



[Acciones.guardar.guardar]
Nombre=guardar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S



[Acciones.Guardar2.guardar Cambios]
Nombre=guardar Cambios
Boton=0
TipoAccion=controles Captura
ClaveAccion=guardar Cambios
Activo=S
Visible=S



[Acciones.guardar.expresion1]
Nombre=expresion1
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Ejecutarsql(<T>EXEC SPIRM0906_HistoricoConfDiv :tUsuario,:tDivision,:nDV,:nDI,:nProA,:nProB<T>,Usuario, RM0906ConfiguraciondeDivyRanVis:RM0906ConfigDivicionYParamTbl.Division,RM0906ConfiguraciondeDivyRanVis:RM0906ConfigDivicionYParamTbl.DV,RM0906ConfiguraciondeDivyRanVis:RM0906ConfigDivicionYParamTbl.DI,RM0906ConfiguraciondeDivyRanVis:RM0906ConfigDivicionYParamTbl.ProcdeAbonoFinal,RM0906ConfiguraciondeDivyRanVis:RM0906ConfigDivicionYParamTbl.ProcdeBonificaciondeInteres)
[Acciones.guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S



[Acciones.Guardar Cambios.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar Cambios.GuardaHistorial]
Nombre=GuardaHistorial
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

[Acciones.guardar.cerrar1]
Nombre=cerrar1
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S










































[RM0906ConfigDivisionYParamVis]
Estilo=Hoja
Clave=RM0906ConfigDivisionYParamVis
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0906ConfigDivisionYParamVis
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
CarpetaVisible=S






ListaEnCaptura=RM0906ConfigDivisionYParamTbl.Division<BR>RM0906ConfigDivisionYParamTbl.DV<BR>RM0906ConfigDivisionYParamTbl.DI<BR>RM0906ConfigDivisionYParamTbl.PorcdeAbonoFinal<BR>RM0906ConfigDivisionYParamTbl.PorcdeBonificaciondeInteres
GuardarPorRegistro=S
[RM0906ConfigDivisionYParamVis.Columnas]
Division=214
DV=74
DI=74
ProcdeAbonoFinal=106
ProcdeBonificaciondeInteres=164

PorcdeAbonoFinal=106
PorcdeBonificaciondeInteres=164
[RM0906ConfigDivisionYParamVis.RM0906ConfigDivisionYParamTbl.Division]
Carpeta=RM0906ConfigDivisionYParamVis
Clave=RM0906ConfigDivisionYParamTbl.Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[RM0906ConfigDivisionYParamVis.RM0906ConfigDivisionYParamTbl.DV]
Carpeta=RM0906ConfigDivisionYParamVis
Clave=RM0906ConfigDivisionYParamTbl.DV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[RM0906ConfigDivisionYParamVis.RM0906ConfigDivisionYParamTbl.DI]
Carpeta=RM0906ConfigDivisionYParamVis
Clave=RM0906ConfigDivisionYParamTbl.DI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[RM0906ConfigDivisionYParamVis.RM0906ConfigDivisionYParamTbl.PorcdeAbonoFinal]
Carpeta=RM0906ConfigDivisionYParamVis
Clave=RM0906ConfigDivisionYParamTbl.PorcdeAbonoFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[RM0906ConfigDivisionYParamVis.RM0906ConfigDivisionYParamTbl.PorcdeBonificaciondeInteres]
Carpeta=RM0906ConfigDivisionYParamVis
Clave=RM0906ConfigDivisionYParamTbl.PorcdeBonificaciondeInteres
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Acciones.eje.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.eje.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.ELIMINAR.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Ejecutarsql(<T>EXEC SPIRM0906_HistoricoConfDiv :nOption,:nID,:tUsuario,:tDivision,:nDV,:nDI,:nProA,:nProB<T>,3,RM0906ConfigDivisionYParamVis:RM0906ConfigDivisionYParamTbl.ID,USUARIO,0,0,0,0,0)
[Acciones.ELIMINAR]
Nombre=ELIMINAR
Boton=5
NombreDesplegar=E&liminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Expresion<BR>Registro Eliminar
Activo=S
Visible=S
NombreEnBoton=S

ConfirmarAntes=S
[Acciones.ELIMINAR.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

