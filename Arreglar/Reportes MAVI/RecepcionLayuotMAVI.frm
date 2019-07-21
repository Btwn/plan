[Forma]
Clave=RecepcionLayuotMAVI
Nombre=Recepcion de Layouts
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=RecepcionLayuotMAVI
CarpetaPrincipal=RecepcionLayuotMAVI
PosicionInicialIzquierda=517
PosicionInicialArriba=394
PosicionInicialAlturaCliente=197
PosicionInicialAncho=245
ListaAcciones=Cerrar<BR>Aceptar<BR>Verificar
[RecepcionLayuotMAVI]
Estilo=Ficha
Clave=RecepcionLayuotMAVI
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0235Empresa<BR>Mavi.DM0235InsLayoutMavi<BR>Info.Ejercicio<BR>Mavi.DM0169FiltroPeriodo<BR>Mavi.DM0169FiltroQuincena<BR>Info.ExaminarArchivoMAVI
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=5
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
[RecepcionLayuotMAVI.Info.Ejercicio]
Carpeta=RecepcionLayuotMAVI
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[RecepcionLayuotMAVI.Info.ExaminarArchivoMAVI]
Carpeta=RecepcionLayuotMAVI
Clave=Info.ExaminarArchivoMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=Cargar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.DM0169FiltroPeriodo, Reemplaza(ASCII(39),<T><T> , Mavi.DM0169FiltroPeriodo) )<BR>Asigna(Mavi.DM0169FiltroQuincena, Reemplaza(ASCII(39),<T><T> , Mavi.DM0169FiltroQuincena) )<BR>Asigna(info.cantidad, SQL(<T>spValidaCobSituacionMavi :tEmp, :tInst, :nEjer, :tPer, :nEst<T>, Mavi.DM0235Cuenta, Reemplaza(ASCII(39),<T><T>, Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, EstacionTrabajo))<BR>//Informacion(Info.Cantidad)<BR>Si Info.Cantidad>0 Entonces<BR>  Si<BR>    SQL(<T>spValidarRecepcionMavi :tEmp, :tInst, :nEjer, :tPer, :nEst, :tQui<T>, Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>,Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, EstacionTrabajo, Mavi.DM0169FiltroQuincena ) > 0<BR>  Entonces<BR>    SI<BR>      Precaucion(<T>La información<T><CONTINUA>
Expresion002=<CONTINUA>+<T> <T>+Mavi.DM0235Empresa+<T> <T>+Mavi.DM0235InsLayoutMavi+<T> <T>+Info.Ejercicio+<T> <T>+Mavi.DM0169FiltroPeriodo+<T> <T>+Mavi.DM0169FiltroQuincena+<T> <T>+<T>ya existe. Desea reemplazarla?<T>, BotonAceptar, BotonCancelar ) =  BotonAceptar<BR>    Entonces<BR>      Si(SQL(<T>spValidarExistenCobrosEnEnteroMavi :tEmp, :tInst, :nEjer, :tPer, :tQui, :nEst<T>, Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>, Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, Mavi.DM0169FiltroQuincena, EstacionTrabajo) > 0, Si(Precaucion(<T>No se pudo reemplazar el layout porque ya se generaron aplicaciones de cobros<T>,BotonAceptar )=BotonAceptar, AbortarOperacion, AbortarOperacion ))<BR>      EjecutarSQLAnimado(<T>spArchivosRecepcionMavi :tEmp, :tInst, :nEjer, :tPer, :tQui,  :tExam, :nEst<T><CONTINUA>
Expresion003=<CONTINUA>,Mavi.DM0235Empresa , reemplaza(ASCII(39),<T><T>,Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, Mavi.DM0169FiltroQuincena, Info.ExaminarArchivoMAVI, EstacionTrabajo)<BR>      EjecutarSQLAnimado(<T>SpVerificaCargaLayoutMAVI :tEmp, :tInst, :nEjer, :tPer, :nEst, :tQui<T>, Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>,Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, EstacionTrabajo, Mavi.DM0169FiltroQuincena)<BR>      //ReportePantalla(<T>noCoincidencias<T>)<BR><BR>      INFORMACION(<T>El layout se cargo correctamente!<T>)<BR>    FIN<BR>  Sino<BR>   Si(SQL(<T>spValidarExistenCobrosEnEnteroMavi :tEmp, :tInst, :nEjer, :tPer, :tQui, :nEst<T>,Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>, Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriod<CONTINUA>
Expresion004=<CONTINUA>o, Mavi.DM0169FiltroQuincena, EstacionTrabajo) > 0, Si(Precaucion(<T>No se pudo reemplazar el layout porque ya se generaron aplicaciones de cobros<T>,BotonAceptar )=BotonAceptar, AbortarOperacion, AbortarOperacion ))<BR>   EjecutarSQLAnimado(<T>spArchivosRecepcionMavi :tEmp, :tInst, :nEjer, :tPer, :tQui,  :tExam, :nEst<T>, Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>,Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, Mavi.DM0169FiltroQuincena, Info.ExaminarArchivoMAVI, EstacionTrabajo)<BR>   EjecutarSQLAnimado(<T>SpVerificaCargaLayoutMAVI :tEmp, :tInst, :nEjer, :tPer, :nEst, :tQui<T>,Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>,Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, EstacionTrabajo, Mavi.DM0169FiltroQuincena)<BR>    //ReportePantalla(<T>n<CONTINUA>
Expresion005=<CONTINUA>oCoincidencias<T>)<BR>     <BR>    INFORMACION(<T>El layout se cargo correctamente!<T>)<BR>  Fin<BR>Sino<BR> INFORMACION(<T>No se puede cargar el layout porque no existen Contra Recibos Inst. o los que existen tienen una situación no válida<T>)<BR>Fin
EjecucionCondicion=(ConDatos(Mavi.DM0235InstitucionMavi)) y (ConDatos(Mavi.DM0169FiltroPeriodo)) y (ConDatos(Info.Ejercicio)) y (ConDatos(Mavi.DM0169FiltroQuincena))  y (ConDatos(Mavi.DM0235Empresa)) y (ConDatos(Info.ExaminarArchivoMAVI))<BR><BR>SI(SQL(<T>Select dbo.fn_MaviDM0169VALIDAQUINCENA(:tPe,:tQui)<T>, Reemplaza(ASCII(39),<T><T>, Mavi.DM0169FiltroPeriodo), Reemplaza(ASCII(39),<T> <T>, Mavi.DM0169FiltroQuincena )  )=1, Verdadero,Precaucion(<T>La quincena debe corresponder al periodo<T>))
EjecucionMensaje=<T>Todos los datos son requeridos<T>
[Acciones.Verificar]
Nombre=Verificar
Boton=95
NombreEnBoton=S
NombreDesplegar=Verificar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
[Acciones.Verificar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Verificar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.DM0169FiltroPeriodo, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroPeriodo) )<BR>Asigna(Mavi.DM0169FiltroQuincena, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroQuincena) )<BR>Si(SQL(<T>spValidarExistenCobrosEnEnteroMavi :tEmp, :tInst, :nEjer, :tPer, :tQui, :nEst<T>, Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>,Mavi.DM0235InsLayoutMavi), Info.Ejercicio, Mavi.DM0169FiltroPeriodo, Mavi.DM0169FiltroQuincena, EstacionTrabajo) > 0, Si(Precaucion(<T>No se puede realizar la coincidencia del layout porque ya se han generado aplicaciones de cobros<T>,BotonAceptar)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>ProcesarSQL(<T>SpVerificaCargaLayoutMAVI :tEmp, :tInst, :nEjer, :tPer, :nEst, :tQui<T>, Mavi.DM0235Empresa, Reemplaza(ASCII(39),<T><T>,Mavi.DM0235InsLayoutMavi), Info.E<CONTINUA>
Expresion002=<CONTINUA>jercicio, Mavi.DM0169FiltroPeriodo, EstacionTrabajo, Mavi.DM0169FiltroQuincena)
EjecucionCondicion=(ConDatos(Mavi.DM0235InsLayoutMavi)) y (ConDatos(Mavi.DM0169FiltroPeriodo)) y (ConDatos(Mavi.DM0169FiltroQuincena)) y (ConDatos(Info.Ejercicio)) y (ConDatos(Mavi.DM0235Empresa))
EjecucionMensaje=<T>Faltan Datos Requeridos<T>
[Acciones.noCoincidencias.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.noCoincidencias.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=noCoincidencias
Activo=S
ConCondicion=S
EjecucionCondicion=(ConDatos(Info.InstitucionMAVI)) y (ConDatos(Info.Periodo)) y (ConDatos(Info.Ejercicio)) y (ConDatos(Info.Empresa))
EjecucionMensaje=<T>Faltan Datos Requeridos<T>
EjecucionConError=S
Visible=S
[RecepcionLayuotMAVI.Mavi.DM0169FiltroPeriodo]
Carpeta=RecepcionLayuotMAVI
Clave=Mavi.DM0169FiltroPeriodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RecepcionLayuotMAVI.Mavi.DM0169FiltroQuincena]
Carpeta=RecepcionLayuotMAVI
Clave=Mavi.DM0169FiltroQuincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RecepcionLayuotMAVI.Mavi.DM0235InsLayoutMavi]
Carpeta=RecepcionLayuotMAVI
Clave=Mavi.DM0235InsLayoutMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RecepcionLayuotMAVI.Mavi.DM0235Empresa]
Carpeta=RecepcionLayuotMAVI
Clave=Mavi.DM0235Empresa
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


