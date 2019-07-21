[Forma]
Clave=AsigCtasMavi
Nombre=Asignación de Cuentas Cobranza
Icono=0
Modulos=(Todos)
AccionesTamanoBoton=25x5
ListaAcciones=Movimientos<BR>Cireterios<BR>Cerrar<BR>Procesar<BR>procesarFinal<BR>Resumen<BR>REsumtxt<BR>DetalelTXT<BR>ResumenFinalTXT<BR>DetalleFinalTXT<BR>DetalleApoyoFinalTXT<BR>DetalleEstatusCteFinalTXT<BR>Procesar Apoyo
PosicionInicialAlturaCliente=190
PosicionInicialAncho=893
BarraHerramientas=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=236
PosicionInicialArriba=270
ExpresionesAlMostrar=Asigna(Info.Fecha, FechaDMA(sql(<T>select GETDATE()<T>)))<BR>Asigna(Info.Ejercicio,año(Info.Fecha))<BR>//Asigna(Info.Ejercicio,sql(<T>select datepart(yy,GETDATE())<T>))<BR>Asigna(Info.QuincenaMAVI,si (Dia(Info.Fecha))  >= 15<BR>entonces Mes(Info.Fecha)*2 sino (Mes(Info.Fecha)*2)-1) Fin)
BarraAcciones=S
AccionesCentro=S
AccionesDivision=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnBarraHerramientas=S
EspacioPrevio=S
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
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
ListaEnCaptura=Info.Ejercicio<BR>Info.QuincenaMAVI<BR>Info.Fecha
CarpetaVisible=S
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.QuincenaMAVI]
Carpeta=(Variables)
Clave=Info.QuincenaMAVI
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Fecha]
Carpeta=(Variables)
Clave=Info.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Procesar]
Nombre=Procesar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Procesar Quincena
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>Expresion
Antes=S
AntesExpresiones=asigna(MAVI.DM0268ValidaMensajeError,SQL(<T>SELECT dbo.FN_DM0281PermiteEjecutar(:tMov)<T>, <T>Asignacion Cuenta<T>))<BR>si  MAVI.DM0268ValidaMensajeError=<T>Permite<T><BR>entonces<BR>  verdadero<BR>sino<BR>  Informacion(MAVI.DM0268ValidaMensajeError)<BR>  abortaroperacion<BR>fin
[Acciones.Procesar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Procesar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=ASIGNA(Info.dialogo,SQL(<T>select  dbo.FN_DM0207ValidarEjecucionAsignacion(:nQuincenaA,:nEjercicioA)<T>,Info.QuincenaMAVI,Info.Ejercicio))<BR>Asigna(Info.Ruta, SQL(<T>Select dbo.FN_DM0207ValidaRuta()<T>))<BR><BR>Si (Info.Dialogo=1) o (Info.Dialogo=0)<BR>Entonces<BR>Si<BR>   Info.Ruta <> <T>ok<T><BR>Entonces<BR>    Asigna(Info.Mensaje, SQLenLISTA(<T>select distinct R.division from  ZonaCobranzamen zrc LEFT JOIN DM0214ZonasCobranza R ON zrc.Zona = R.zona<BR>        where Ruta=:tRut AND R.division IN (select distinct Division FROM NivelCobranzaMaviDiv where division not like (:tIns) )<T>,Info.Ruta,<T>INS%<T>))<BR>   Error(<T>La Ruta: <T>+Info.Ruta+<T> tiene 2 o mas Divisioens con diferentes rangos: <T>+Info.Mensaje+<T><T>,BotonAceptar)=BotonAceptar,AbortarOperacion, AbortarOperacion)<BR>Sino<<CONTINUA>
Expresion002=<CONTINUA>BR>    Si(Info.QuincenaMAVI > 24, Si(Error(<T>Numero de Quincena Incorrecto!!<T>,BotonAceptar)=BotonAceptar,AbortarOperacion, AbortarOperacion), Si(Info.QuincenaMAVI < 1, Si(Error(<T>Número de Quincena Incorrecto!!<T>, BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)))<BR>    Si(SQL(<T>SELECT dbo.fnExistenOrdenesCobroMAVI(:nEjer, :nQuincena)<T>, Info.Ejercicio, Info.QuincenaMAVI)=1,Si(Precaucion(<T>Ya fueron generadas ordenes de cobro con la herramienta para el periodo específicado, no se puede realizar la asignación!<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>    EjecutarSQLAnimado(<T>EXEC spAsignacionCuentas :tEmpresa, :nEjercicio, :nQuincena, :fFecha, :nEstacion<T>, Empresa, Info.Ejercicio, Info.QuincenaMAVI, Info.Fecha, EstacionTrabajo)<BR> Si<CONTINUA>
Expresion003=<CONTINUA>(SQL(<T>SELECT COUNT(0) FROM ListaIDOk WHERE ID = 0 AND Estacion =:nEst AND Empresa =:tEmp<T>, EstacionTrabajo, Empresa)>0, Precaucion(SQL(<T>SELECT OkRef FROM ListaIDOk WHERE ID = 0 AND Estacion =:nEst AND Empresa =:Emp<T>, EstacionTrabajo, Empresa)),ReportePantalla(<T>AsigCtasCobMenMavi<T>))<BR>Fin<BR><BR>SINO<BR>Precaucion(<T>Los parametros ingresados no son los correctos<T>)<BR>Fin
EjecucionCondicion=(ConDatos(Info.Ejercicio)) y (ConDatos(Info.QuincenaMAVI)) y (ConDatos(Info.Fecha))
EjecucionMensaje=<T>Todos los datos son requeridos<T>
[Acciones.Resumen]
Nombre=Resumen
Boton=17
NombreEnBoton=S
NombreDesplegar=&Resumen
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar2<BR>ExisteAsignacion
[Acciones.Resumen.Asignar2]
Nombre=Asignar2
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Resumen.ExisteAsignacion]
Nombre=ExisteAsignacion
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
EjecucionConError=S
Expresion=Si(SQL(<T>SELECT COUNT(0) FROM MaviRecuperacion WHERE Quincena =:nQuin AND Ejercicio =:nEjer<T>, Info.QuincenaMAVI, Info.Ejercicio)>0, ReportePantalla(<T>AsigCtasCobMenMavi<T>), Si(Precaucion(<T>Aun no se ha generado la asignación de cuentas del periodo específicado<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))
EjecucionCondicion=(ConDatos(Info.QuincenaMAVI)) y (ConDatos(Info.Ejercicio))
EjecucionMensaje=<T>Los datos de quincena y ejercicio son requeridos<T>
[Acciones.Cireterios]
Nombre=Cireterios
Boton=41
NombreEnBoton=S
NombreDesplegar=Criterios
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0207CriteriosAsignacion
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Movimientos]
Nombre=Movimientos
Boton=18
NombreEnBoton=S
NombreDesplegar=Movimientos
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0207MovsordenAsignacion
Activo=S
Visible=S
[Acciones.REsumtxt]
Nombre=REsumtxt
Boton=0
NombreEnBoton=S
NombreDesplegar=Resumen a TXT
Activo=S
Visible=S
EspacioPrevio=S
EnBarraAcciones=S
Multiple=S
ListaAccionesMultiples=avsr<BR>repores
[Acciones.DetalelTXT]
Nombre=DetalelTXT
Boton=0
NombreEnBoton=S
NombreDesplegar=Detalle a TXT
EspacioPrevio=S
Activo=S
Visible=S
EnBarraAcciones=S
Multiple=S
ListaAccionesMultiples=asivatxt<BR>reptxt
[Acciones.REsumtxt.repores]
Nombre=repores
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=AsigCtasCobMenMaviTXT
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si SQL(<T>SELECT COUNT(0) FROM MaviRecuperacion WHERE Quincena =:nQuin AND Ejercicio =:nEjer<T>, Info.QuincenaMAVI, Info.Ejercicio)>0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Si(Precaucion(<T>Aun no se ha generado la asignación de cuentas del periodo específicado<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)
[Acciones.REsumtxt.avsr]
Nombre=avsr
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.DetalelTXT.reptxt]
Nombre=reptxt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=AsigCtasDetalleMaviTXT
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si SQL(<T>SELECT COUNT(0) FROM MaviRecuperacion WHERE Quincena =:nQuin AND Ejercicio =:nEjer<T>, Info.QuincenaMAVI, Info.Ejercicio)>0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Si(Precaucion(<T>Aun no se ha generado la asignación de cuentas del periodo específicado<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)
[Acciones.DetalelTXT.asivatxt]
Nombre=asivatxt
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ResumenFinalTXT]
Nombre=ResumenFinalTXT
Boton=0
NombreEnBoton=S
NombreDesplegar=Resumen Final TXT
Multiple=S
EnBarraAcciones=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=asigna<BR>reporte
[Acciones.DetalleFinalTXT]
Nombre=DetalleFinalTXT
Boton=0
NombreEnBoton=S
NombreDesplegar=Detalle Final TXT
Multiple=S
EnBarraAcciones=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=asigna<BR>reporte
[Acciones.ResumenFinalTXT.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.DetalleFinalTXT.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ResumenFinalTXT.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0207AsigCtasResumenFinalTXT
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si SQL(<T>SELECT COUNT(0) FROM DM0207MaviRecuperacionCteFinal WHERE Quincena =:nQuin AND Ejercicio =:nEjer<T>, Info.QuincenaMAVI, Info.Ejercicio)>0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Si(Precaucion(<T>Aun no se ha generado la asignación de cuentas Cte Final del periodo específicado<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)
[Acciones.DetalleFinalTXT.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0207AsigCtasDetalleFinalTXT
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si SQL(<T>SELECT COUNT(0) FROM DM0207MaviRecuperacionCteFinal WHERE Quincena =:nQuin AND Ejercicio =:nEjer<T>, Info.QuincenaMAVI, Info.Ejercicio)>0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Si(Precaucion(<T>Aun no se ha generado la asignación de cuentas Cte Final del periodo específicado<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)
[Acciones.procesarFinal.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.procesarFinal.ejecutar]
Nombre=ejecutar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ASIGNA(Info.dialogo,SQL(<T>select  dbo.FN_DM0207ValidarEjecucionAsignacion(:nQuincenaA,:nEjercicioA)<T>,Info.QuincenaMAVI,Info.Ejercicio))<BR>Asigna(Info.Ruta, SQL(<T>Select dbo.FN_DM0207ValidaRuta()<T>))<BR><BR>Si (Info.Dialogo=1) o (Info.Dialogo=0)<BR>Entonces<BR>   <BR>Si(Info.QuincenaMAVI > 24, Si(Error(<T>Numero de Quincena Incorrecto!!<T>,BotonAceptar)=BotonAceptar,AbortarOperacion, AbortarOperacion), Si(Info.QuincenaMAVI < 1, Si(Error(<T>Número de Quincena Incorrecto!!<T>, BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)))<BR>    Si(SQL(<T>SELECT dbo.fnExistenOrdenesCobroMAVI(:nEjer, :nQuincena)<T>, Info.Ejercicio, Info.QuincenaMAVI)=1,Si(Precaucion(<T>Ya fueron generadas ordenes de cobro con la herramienta para el periodo específicado, no se puede realizar la asignación!<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>    EjecutarSQLAnimado(<T>EXEC SP_DM0207AsignacionCteFinal :tEmpresa, :nEjercicio, :nQuincena, :fFecha, :nEstacion<T>, Empresa, Info.Ejercicio, Info.QuincenaMAVI, Info.Fecha, EstacionTrabajo)<BR>    Informacion(<T>La asignacion ha finalizado<T>)<BR>Fin<BR>SINO<BR>Precaucion(<T>Los parametros ingresados no son los correctos<T>)<BR>Fin
[Acciones.procesarFinal]
Nombre=procesarFinal
Boton=7
NombreEnBoton=S
NombreDesplegar=&Procesar Cte Final
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>ejecutar
Activo=S
Visible=S
Antes=S

AntesExpresiones=asigna(MAVI.DM0268ValidaMensajeError,SQL(<T>SELECT dbo.FN_DM0281PermiteEjecutar(:tMov)<T>, <T>Asignacion Cuenta<T>))<BR>si  MAVI.DM0268ValidaMensajeError=<T>Permite<T><BR>entonces<BR>  verdadero<BR>sino<BR>  Informacion(MAVI.DM0268ValidaMensajeError)<BR>  abortaroperacion<BR>fin
[Acciones.DetalleApoyoFinalTXT.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.DetalleApoyoFinalTXT]
Nombre=DetalleApoyoFinalTXT
Boton=0
NombreEnBoton=S
NombreDesplegar=Detalle Apoyo Final
Multiple=S
EnBarraAcciones=S
EspacioPrevio=S
ListaAccionesMultiples=asigna<BR>reporte
Activo=S
Visible=S

[Acciones.DetalleApoyoFinalTXT.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0207CXCAsigCtasDetalleApoyoFinalTXT
Activo=S
Visible=S
ConCondicion=S


EjecucionCondicion=Si SQL(<T>SELECT COUNT(0) FROM DM0207MaviRecuperacionCteFinal WHERE Quincena =:nQuin AND Ejercicio =:nEjer<T>, Info.QuincenaMAVI, Info.Ejercicio)>0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Si(Precaucion(<T>Aun no se ha generado la asignación de cuentas Cte Final del periodo específicado<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)
[Acciones.DetalleEstatusCteFinalTXT]
Nombre=DetalleEstatusCteFinalTXT
Boton=0
NombreEnBoton=S
NombreDesplegar=Detalle Estatus Cte Final
Multiple=S
EnBarraAcciones=S
EspacioPrevio=S
ListaAccionesMultiples=Estatus
Activo=S
Visible=S


[Acciones.DetalleEstatusCteFinalTXT.Estatus]
Nombre=Estatus
Boton=0
TipoAccion=Formas
ClaveAccion=DM0207EstatusCobroBeneficiarioFrm
Activo=S
Visible=S



[Acciones.Procesar Apoyo.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Procesar Apoyo]
Nombre=Procesar Apoyo
Boton=7
NombreEnBoton=S
NombreDesplegar=P&rocesar Apoyo DIMA
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
Activo=S
Visible=S
Antes=S

AntesExpresiones=asigna(MAVI.DM0268ValidaMensajeError,SQL(<T>SELECT dbo.FN_DM0281PermiteEjecutar(:tMov)<T>, <T>Asignacion Cuenta<T>))<BR>si  MAVI.DM0268ValidaMensajeError=<T>Permite<T><BR>entonces<BR>  verdadero<BR>sino<BR>  Informacion(MAVI.DM0268ValidaMensajeError)<BR>  abortaroperacion<BR>fin
[Acciones.Procesar Apoyo.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ASIGNA(Info.dialogo,SQL(<T>select  dbo.FN_DM0207ValidarEjecucionAsignacion(:nQuincenaA,:nEjercicioA)<T>,Info.QuincenaMAVI,Info.Ejercicio))<BR>Asigna(Info.Ruta, SQL(<T>Select dbo.FN_DM0207ValidaRuta()<T>))<BR><BR>Si (Info.Dialogo=1) o (Info.Dialogo=0)<BR>Entonces<BR><BR>Si(Info.QuincenaMAVI > 24, Si(Error(<T>Numero de Quincena Incorrecto!!<T>,BotonAceptar)=BotonAceptar,AbortarOperacion, AbortarOperacion), Si(Info.QuincenaMAVI < 1, Si(Error(<T>Número de Quincena Incorrecto!!<T>, BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion)))<BR>    Si(SQL(<T>SELECT dbo.fnExistenOrdenesCobroMAVI(:nEjer, :nQuincena)<T>, Info.Ejercicio, Info.QuincenaMAVI)=1,Si(Precaucion(<T>Ya fueron generadas ordenes de cobro con la herramienta para el periodo específicado, no se puede realizar la asignación!<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>    EjecutarSQLAnimado(<T>EXEC SPIDM0207_JobAsigCtasBeneFin<T>)<BR>    Informacion(<T>Proceso estatus finalizado<T>)<BR>    EjecutarSQLAnimado(<T>EXEC SPIDM0207_JobAsigApoyoCobDIMAS :tEmpresa, :nEjercicio, :nQuincena, :fFecha, :nEstacion<T>, Empresa, Info.Ejercicio, Info.QuincenaMAVI, Info.Fecha, EstacionTrabajo)<BR>    Informacion(<T>Asignacion apoyo DIMA finalizada<T>)<BR>Fin<BR>SINO<BR>Precaucion(<T>Los parametros ingresados no son los correctos<T>)<BR>Fin
