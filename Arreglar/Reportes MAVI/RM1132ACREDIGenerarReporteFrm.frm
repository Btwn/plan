
[Forma]
Clave=RM1132ACREDIGenerarReporteFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Filtros_Parte1<BR>Filtros_Parte2
CarpetaPrincipal=Filtros_Parte1
PosicionInicialAlturaCliente=380
PosicionInicialAncho=327
PosicionInicialIzquierda=426
PosicionInicialArriba=283
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preeliminar<BR>Cerrar<BR>GenerarTxt<BR>ValoresDefault
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
Nombre=<T>Posibles Beneficiarios Finales Plus<T>








PosicionSec1=226
PosicionSec2=245
ExpresionesAlCerrar=EjecutarSQL(<T>EXEC SpCREDIPosiblesBeneficiariosFinalesPlus :nOpcion, :nSpid, :tParametros<T>,1,SQL(<T>SELECT @@SPID<T>),<T><T>)
ExpresionesAlActivar=Forma.Accion(<T>ValoresDefault<T>)<BR>EjecutarSQL(<T>EXEC SpCREDIPosiblesBeneficiariosFinalesPlus :nOpcion, :nSpid, :tParametros<T>,1,SQL(<T>SELECT @@SPID<T>),<T><T>)
[Captura.Columnas]
IDRM1132ATablaConfiguracion=64
SaldoActual=67
Movimientos=64
Meses=64
MontoAbonos=70
DValDia=60
MHDV=60
MHDVxPeriodo=78
Apoyo_Cobranza=95


[Acciones.ValoresDefault]
Nombre=ValoresDefault
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
NombreDesplegar=ValoresDefault


Expresion=Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.SaldoActual,<T>Todos<T>)<BR>Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.Movimientos,<T>2<T>)<BR>Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.Meses,<T>99<T>)<BR>Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.MontoAbonos,<T>5000<T>)<BR>Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.DValDia,<T>0<T>)<BR>Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.MHDV,<T>15<T>)<BR>Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.MHDVxPeriodo,)<BR>Asigna(RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.ApoyoCobranza,)
[Acciones.Cerrar.Cancelar Cambios]
Nombre=Cancelar Cambios
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
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S

EspacioPrevio=S
[Acciones.Preeliminar]
Nombre=Preeliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=Preeliminar
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Registro Siguiente<BR>Guardar Cambios<BR>Actualizar Forma<BR>CapturarFiltros<BR>Aceptar
Antes=S
AntesExpresiones=Asigna(Info.ID,0)
[Acciones.GenerarTxt]
Nombre=GenerarTxt
Boton=9
NombreEnBoton=S
NombreDesplegar=Generar Txt
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S

TipoAccion=Reportes Impresora
ClaveAccion=RM1132ACREDIPosiblesBFPlusRepTxt
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Registro Siguiente<BR>Guardar Cambios<BR>Actualizar Forma<BR>Expresion<BR>Txt
Antes=S
AntesExpresiones=Asigna(Info.ID,0)
[Filtros_Parte1]
Estilo=Ficha
Clave=Filtros_Parte1
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1132ACREDIFiltrosReporteVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM1132ACREDIFiltrosReporteTbl.SaldoActual<BR>RM1132ACREDIFiltrosReporteTbl.Movimientos<BR>RM1132ACREDIFiltrosReporteTbl.Meses<BR>RM1132ACREDIFiltrosReporteTbl.MontoAbonos<BR>RM1132ACREDIFiltrosReporteTbl.DValDia<BR>RM1132ACREDIFiltrosReporteTbl.MHDV<BR>RM1132ACREDIFiltrosReporteTbl.MHDVxPeriodo<BR>RM1132ACREDIFiltrosReporteTbl.ApoyoCobranza
CarpetaVisible=S




[Filtros_Parte2.RM1132ACREDITablaDeConfiguracionTbl.MontoAbonos]
Carpeta=Filtros_Parte2
Clave=RM1132ACREDITablaDeConfiguracionTbl.MontoAbonos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros_Parte2.RM1132ACREDITablaDeConfiguracionTbl.DValDia]
Carpeta=Filtros_Parte2
Clave=RM1132ACREDITablaDeConfiguracionTbl.DValDia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros_Parte2.RM1132ACREDITablaDeConfiguracionTbl.MHDV]
Carpeta=Filtros_Parte2
Clave=RM1132ACREDITablaDeConfiguracionTbl.MHDV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros_Parte2.RM1132ACREDITablaDeConfiguracionTbl.MHDVxPeriodo]
Carpeta=Filtros_Parte2
Clave=RM1132ACREDITablaDeConfiguracionTbl.MHDVxPeriodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros_Parte2.RM1132ACREDITablaDeConfiguracionTbl.ApoyoCobranza]
Carpeta=Filtros_Parte2
Clave=RM1132ACREDITablaDeConfiguracionTbl.ApoyoCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros_Parte2.Columnas]
MontoAbonos=130
DValDia=109
MHDV=157
MHDVxPeriodo=148
ApoyoCobranza=143




[Acciones.Preeliminar.CapturarFiltros]
Nombre=CapturarFiltros
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=//Recuperar parametros desde la tabla de paso y asignarlas a las variables, tabla fisica <SpCREDIPosiblesBeneficiariosFinalesPlus><BR>Asigna(Mavi.RM1132ASaldo,SQL(<T>SELECT SaldoActual FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMovimientos,SQL(<T>SELECT CAST(Movimientos AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMeses,SQL(<T>SELECT CAST(Meses AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMinimoAbono,SQL(<T>SELECT CAST(MontoAbonos AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132ADvAlDia,SQL(<T>SELECT CAST(DValDia AS INT)  FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMHDV,SQL(<T>SELECT CAST(MHDV AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMHDVXPeriodo,SQL(<T>SELECT CAST(MHDVxPeriodo AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AApoyoCobranza,SQL(<T>SELECT ApoyoCobranza FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR><BR>//Validar que las siguientes variables tengan datos<BR>Si(Vacio(Mavi.RM1132ASaldo),Informacion(<T>Debe llenar el campo <Sueldo Actual><T>)Asigna(Info.ID,1),verdadero)<BR>Si(Vacio(Mavi.RM1132AMovimientos),Informacion(<T>Debe llenar el campo <A partir de (N) Movimientos><T>)Asigna(Info.ID,1),verdadero)<BR>Si(Vacio(Mavi.RM1132AMeses),Informacion(<T>Debe llenar el campo <En los ultimos (N) meses><T>)Asigna(Info.ID,1),verdadero)
[Acciones.Preeliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S


ConCondicion=S
EjecucionCondicion=Si<BR>  Info.ID <> 1<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  AbortarOperacion<BR>Fin                                                                         
[Acciones.Preeliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S








[Filtros_Parte2]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Ventas Realizadas (Informativo)
Clave=Filtros_Parte2
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

[Filtros_Parte2.Info.FechaD]
Carpeta=Filtros_Parte2
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros_Parte2.Info.FechaA]
Carpeta=Filtros_Parte2
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.SaldoActual]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.SaldoActual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.Movimientos]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.Movimientos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.Meses]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.Meses
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.MontoAbonos]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.MontoAbonos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.DValDia]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.DValDia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.MHDV]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.MHDV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.MHDVxPeriodo]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.MHDVxPeriodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Filtros_Parte1.RM1132ACREDIFiltrosReporteTbl.ApoyoCobranza]
Carpeta=Filtros_Parte1
Clave=RM1132ACREDIFiltrosReporteTbl.ApoyoCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco





[Acciones.clon.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1132ASaldo,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.SaldoActual)<BR>Asigna(Mavi.RM1132AMovimientos,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.Movimientos)<BR>Asigna(Mavi.RM1132AMeses,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.Meses)<BR>Asigna(Mavi.RM1132AMinimoAbono,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.MontoAbonos)<BR>Asigna(Mavi.RM1132ADvAlDia,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.DValDia)<BR>Asigna(Mavi.RM1132AMHDV,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.MHDV)<BR>Asigna(Mavi.RM1132AMHDVXPeriodo,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.MHDVxPeriodo)<BR>Asigna(Mavi.RM1132AApoyoCobranza,RM1132ACREDIFiltrosReporteVis:RM1132ACREDIFiltrosReporteTbl.ApoyoCobranza)
[Acciones.clon.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S








[Acciones.Preeliminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Preeliminar.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.GenerarTxt.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.GenerarTxt.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.GenerarTxt.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.GenerarTxt.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=//Recuperar parametros desde la tabla de paso y asignarlas a las variables, tabla fisica <SpCREDIPosiblesBeneficiariosFinalesPlus><BR>Asigna(Mavi.RM1132ASaldo,SQL(<T>SELECT SaldoActual FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMovimientos,SQL(<T>SELECT CAST(Movimientos AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMeses,SQL(<T>SELECT CAST(Meses AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMinimoAbono,SQL(<T>SELECT CAST(MontoAbonos AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132ADvAlDia,SQL(<T>SELECT CAST(DValDia AS INT)  FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMHDV,SQL(<T>SELECT CAST(MHDV AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AMHDVXPeriodo,SQL(<T>SELECT CAST(MHDVxPeriodo AS INT) FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR>Asigna(Mavi.RM1132AApoyoCobranza,SQL(<T>SELECT ApoyoCobranza FROM CREDIDTablaPasoConfiguracionBF WHERE Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)))<BR><BR>//Validar que las siguientes variables tengan datos<BR>Si(Vacio(Mavi.RM1132ASaldo),Informacion(<T>Debe llenar el campo <Sueldo Actual><T>)Asigna(Info.ID,1),verdadero)<BR>Si(Vacio(Mavi.RM1132AMovimientos),Informacion(<T>Debe llenar el campo <A partir de (N) Movimientos><T>)Asigna(Info.ID,1),verdadero)<BR>Si(Vacio(Mavi.RM1132AMeses),Informacion(<T>Debe llenar el campo <En los ultimos (N) meses><T>)Asigna(Info.ID,1),verdadero)
[Acciones.GenerarTxt.Txt]
Nombre=Txt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1132ACREDIPosiblesBFPlusRepTxt
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>  Info.ID <> 1<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  AbortarOperacion<BR>Fin
[Acciones.Preeliminar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.GenerarTxt.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

