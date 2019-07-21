[Forma]
Clave=CteCtoExpess
Nombre=Contactos del Cliente
Icono=67
Modulos=(Todos)
ListaCarpetas=Lista<BR>Ficha
CarpetaPrincipal=Ficha
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar<BR>Actualizar<BR>Nuevo<BR>Eliminar<BR>Direcciones<BR>Empleo<BR>Bancos<BR>Comercial<BR>Anexos<BR>actFechas
PosicionInicialIzquierda=262
PosicionInicialArriba=306
PosicionInicialAlturaCliente=378
PosicionInicialAncho=755
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
PosicionColumna1=54
PosicionCol1=384
VentanaEstadoInicial=Normal
AutoGuardar=S
;VentanaEscCerrar=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Info.Copiar, Falso)<BR>Asigna(Mavi.ClienteContactoFecha,nulo)

[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar 
;GuardarAntes=S
EnBarraHerramientas=S
;TipoAccion=Ventana
;ClaveAccion=Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Validando<BR>Guardar Cambios<BR>Guardar<BR>Expresion<BR>direcciona ult mov
;ListaAccionesMultiples=Guardar Cambios<BR>Guardar<BR>Expresion
;GuardarAntes=S

[Acciones.Aceptar.Validando]
Nombre=Validando
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SQL(<T>Sp_ValidadContactosMavi2 :ta,:tb,:tRF,:tc,:td,:te,:tf,:fg,:th,:ti,:tj,:tk,:tl,:tm,:tn<T>,Info.cliente,Info.CategoriaMavi,info.ABC,CteCto:CteCto.Tipo,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno,CteCto:CteCto.Nombre,fechaformatoservidor(CteCto:CteCto.FechaNacimiento),CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.ViveConMAVI,CteCto:CteCto.ViveEnCalidadDeMAVI,CteCto:CteCto.EstadoCivilMavi)<BR><BR>SI  SQL(<T>Sp_ValidadContactosMavi2 :ta,:tb,:tRF,:tc,:td,:te,:tf,:fg,:th,:ti,:tj,:tk,:tl,:tm,:tn<T>,Info.cliente,Info.CategoriaMavi,info.ABC,CteCto:CteCto.Tipo,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno,CteCto:CteCto.Nombre,fechaformatoservidor(CteCto:CteCto.FechaNacimiento),CteCto:CteCto.CteEnv<CONTINUA>
EjecucionCondicion002=<CONTINUA>iarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.ViveConMAVI,CteCto:CteCto.ViveEnCalidadDeMAVI,CteCto:CteCto.EstadoCivilMavi) <> verdadero<BR>Entonces<BR> Asigna(Info.Dialogo,SQL(<T>SELECT Mensaje FROM MensajeErrorMavi<T>))<BR> error(Info.Dialogo)<BR>fin

[Acciones.Aceptar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ConCondicion=S
ClaveAccion=Guardar Cambios
EjecucionCondicion=SQL(<T>Sp_ValidadContactosMavi2 :ta,:tb,:tRF,:tc,:td,:te,:tf,:fg,:th,:ti,:tj,:tk,:tl,:tm,:tn<T>,Info.cliente,Info.CategoriaMavi,info.ABC,CteCto:CteCto.Tipo,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno,CteCto:CteCto.Nombre,fechaformatoservidor(CteCto:CteCto.FechaNacimiento),CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.ViveConMAVI,CteCto:CteCto.ViveEnCalidadDeMAVI,CteCto:CteCto.EstadoCivilMavi)<BR><BR>SI  SQL(<T>Sp_ValidadContactosMavi2 :ta,:tb,:tRF,:tc,:td,:te,:tf,:fg,:th,:ti,:tj,:tk,:tl,:tm,:tn<T>,Info.cliente,Info.CategoriaMavi,info.ABC,CteCto:CteCto.Tipo,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno,CteCto:CteCto.Nombre,fechaformatoservidor(CteCto:CteCto.FechaNacimiento),CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atenc<CONTINUA>
EjecucionCondicion002=<CONTINUA>ion,CteCto:CteCto.Tratamiento,CteCto:CteCto.ViveConMAVI,CteCto:CteCto.ViveEnCalidadDeMAVI,CteCto:CteCto.EstadoCivilMavi) <> verdadero<BR>Entonces<BR> Asigna(Info.Dialogo,SQL(<T>SELECT Mensaje FROM MensajeErrorMavi<T>))<BR> error(Info.Dialogo)<BR>fin



[Acciones.Aceptar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
;Expresion=GuardarCambios<BR><BR>EjecutarSQL(<T>SpActualizaTablaContMavi :ta,:nb,:tc,:td,:te,<T>+comillas(Vacio(fechaformatoservidor(CteCto:CteCto.FechaNacimiento),<T>NULL<T>))+<T>,:tg,:th,:ti,:tj,:tec,:tLada,:tTel<T>,CteCto:CteCto.Tipo,CteCto:CteCto.ID,CteCto:CteCto.Nombre,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno, CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.EstadoCivilMavi,CteCto:CteCto.LadaMavi,CteCto:CteCto.Telefonos)<BR><BR> Si Info.Respuesta1=<T>P<T><BR>Entonces<BR>  EjecutarSQL(<T>SP_InsertaConyugeMavi :ta,:tb,:tc,:td,:te,:tf,:tg,:th,:ti,:tj,:tk,:tl,:nm,:nn<T>,Info.Tipo,Info.cliente,Info.ID,Info.Observaciones,Info.Clase3,Info.clase1,Info.Clase3,Info.Clase4,Info.Clase2,Info.Articulo,Info.ArticuloA,Info.Clase<CONTINUA>
;Expresion002=<CONTINUA>,Info.Desde1,Info.Desde2)<BR>Fin<BR><BR><BR>si Info.Respuesta2=<T>T<T><BR>ENTONCES<BR>    EjecutarSQL(<T>SP_InsertaEDireccionMavi :ta,:tb,:tc<T>,<T>CONYUGE<T>,Info.cliente,Info.ID)<BR>fin

;AGR 23112009 SE QUITA SQL PARA QUE NO INSERTE DATOS DE CONYUGUE
;Expresion=EjecutarSQL(<T>SpActualizaTablaContMavi :ta,:nb,:tc,:td,:te,<T>+comillas(Vacio(fechaformatoservidor(CteCto:CteCto.FechaNacimiento),<T>NULL<T>))+<T>,:tg,:th,:ti,:tj,:tec,:tLada,:tTel<T>,CteCto:CteCto.Tipo,CteCto:CteCto.ID,CteCto:CteCto.Nombre,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno, CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.EstadoCivilMavi,CteCto:CteCto.LadaMavi,CteCto:CteCto.Telefonos)<BR><BR><CONTINUA>
;Expresion002=<CONTINUA><BR><BR>si Info.Respuesta2=<T>T<T><BR>ENTONCES<BR>    EjecutarSQL(<T>SP_InsertaEDireccionMavi :ta,:tb,:tc<T>,CteCto:CteCto.Tipo,Info.cliente,Info.ID)<BR>fin
;<BR>Si<BR>(sql(<T>SELECT Avales=COUNT(*) FROM CteCto WHERE  Cliente=:tcliente and Tipo in (<T>+comillas(<T>AVAL<T>)+<T>,<T>+comillas(<T>CONYUGE<T>)+<T>,<T>+comillas(<T>CONYUGE DEL AVAL<T>)+<T>)<T>,Info.cliente))><BR>(sql(<T>SELECT Empleos =COUNT(*) FROM MaviCteCtoEmpleo  WHERE  Cliente=:tcliente<T>,Info.cliente ))<BR>entonces<BR>informacion(<T>Falta el Empleo de un Contacto tipo Aval<T>)<BR>Sino<BR>    <T><T><BR>Fin

;AGR 30112009 SE COMENTA LINEA
;Expresion=si Info.Respuesta2=<T>T<T><BR>ENTONCES<BR>    EjecutarSQL(<T>SP_InsertaEDireccionMavi :ta,:tb,:tc<T>,CteCto:CteCto.Tipo,Info.cliente,Info.ID)<BR>fin

;AGR 30112009 SE AGREGAN LINEA PARA EJECUTAR SP PARA ACTUALIZAR EL CANAL DE VENTA FUNCION OK HASTA 20110103
;Expresion=EjecutarSQL(<T>SpActualizaTablaContCanalMavi :ta,:nb,:tc,:td,:te,<T>+comillas(Vacio(fechaformatoservidor(CteCto:CteCto.FechaNacimiento),<T>NULL<T>))+<T>,:tg,:th,:ti,:tj,:tec,:tLada,:tTel<T>,CteCto:CteCto.Tipo,CteCto:CteCto.ID,CteCto:CteCto.Nombre,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno, CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.EstadoCivilMavi,CteCto:CteCto.LadaMavi,CteCto:CteCto.Telefonos)<BR>EjecutarSQL(<T>Sp_MaviActualizaTablaContCanalCte :ta,:tc,:tg<T>,CteCto:CteCto.Tipo,CteCto:CteCto.Cliente, CteCto:CteCto.CteEnviarAExpress)<BR><BR><CONTINUA>
;Expresion002=<CONTINUA><BR><BR>si Info.Respuesta2=<T>T<T><BR>ENTONCES<BR>    EjecutarSQL(<T>SP_InsertaEDireccionMavi :ta,:tb,:tc<T>,CteCto:CteCto.Tipo,Info.cliente,Info.ID)<BR>fin

;AGR 20110104 PARA INSERTAR DE NUEVO EL CONYUGE
Expresion=EjecutarSQL(<T>SpActualizaTablaContCanalMavi :ta,:nb,:tc,:td,:te,<T>+comillas(Vacio(fechaformatoservidor(CteCto:CteCto.FechaNacimiento),<T>NULL<T>))+<T>,:tg,:th,:ti,:tj,:tec,:tLada,:tTel<T>,CteCto:CteCto.Tipo,CteCto:CteCto.ID,CteCto:CteCto.Nombre,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno, CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.EstadoCivilMavi,CteCto:CteCto.LadaMavi,CteCto:CteCto.Telefonos)<BR>EjecutarSQL(<T>Sp_MaviActualizaTablaContCanalCte :ta,:tc,:tg<T>,CteCto:CteCto.Tipo,CteCto:CteCto.Cliente, CteCto:CteCto.CteEnviarAExpress)<BR><BR><CONTINUA>
Expresion002=<CONTINUA><BR><BR> Si Info.Respuesta1=<T>P<T><BR>Entonces<BR>  EjecutarSQL(<T>SP_InsertaConyugeMavi :ta,:tb,:tc,:td,:te,:tf,:tg,:th,:ti,:tj,:tk,:tl,:nm,:nn<T>,CteCto:CteCto.Tipo,Info.cliente,CteCto:CteCto.ID,Info.Observaciones,Info.Clase3,Info.clase1,Info.Clase3,Info.Clase4,Info.Clase2,Info.Articulo,Info.ArticuloA,Info.Clase,Info.Desde1,Info.Desde2)<BR>Fin<BR><BR>si Info.Respuesta2=<T>T<T><BR>ENTONCES<BR>    EjecutarSQL(<T>SP_InsertaEDireccionMavi :ta,:tb,:tc<T>,CteCto:CteCto.Tipo,Info.cliente,Info.ID)<BR>fin






[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=EXPResion
Activo=S
Visible=S
ConCondicion=S
Expresion=Informacion(<T>Contactos Guardados<T>)<BR>ActualizarForma
EjecucionCondicion=SQL(<T>sp_validaXCtoMavi :ta,:tb,:tc<T>,info.cliente,Info.CategoriaMavi,Info.ABC )<BR><BR>SI  SQL(<T>sp_validaXCtoMavi :ta,:tb,:tc<T>,info.cliente,Info.CategoriaMavi,Info.ABC ) <> verdadero<BR>Entonces<BR> Asigna(Info.Dialogo,SQL(<T>SELECT Mensaje FROM MensajeErrorMavi<T>))<BR> error(Info.Dialogo)<BR>fin



[Lista.Columnas]
Nombre=185
Cargo=97
FechaNacimiento=88
Telefonos=102
Extencion=51
eMail=147
Grupo=128
Atencion=61
Tratamiento=65
NombreCompleto=204
Tipo=124
ID=64



[Ficha]
Estilo=Ficha
Clave=Ficha
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CteCto
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
ListaEnCaptura=CteCto.Tipo<BR>CteCto.Atencion<BR>CteCto.ApellidoPaterno<BR>CteCto.ApellidoMaterno<BR>CteCto.Nombre<BR>CteCto.CteEnviarAExpress<BR>CteCto.LadaMavi<BR>CteCto.Telefonos<BR>CteCto.FechaNacimiento<BR>CteCto.Sexo<BR>CteCto.EstadocivilMavi<BR>CteCto.Tratamiento<BR>CteCto.ViveConMAVI<BR>CteCto.ViveEnCalidadDeMAVI
CarpetaVisible=S

[Ficha.CteCto.Nombre]
Carpeta=Ficha
Clave=CteCto.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=51
ColorFondo=Blanco
ColorFuente=Negro






[Ficha.CteCto.FechaNacimiento]
Carpeta=Ficha
Clave=CteCto.FechaNacimiento
Nombre=* Fecha Nacimiento
AyudaEnCaptura=N
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=25
EspacioPrevio=S

[Ficha.CteCto.Atencion]
Carpeta=Ficha
Clave=CteCto.Atencion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Tratamiento]
Carpeta=Ficha
Clave=CteCto.Tratamiento
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=CteCto
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CteCto.Tipo<BR>NombreCompleto
CarpetaVisible=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
OtroOrden=S
ListaOrden=CteCto.ID<TAB>(Decendente)
GuardarPorRegistro=S
GuardarAlSalir=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
FiltroGeneral=CteCto.Cliente=<T>{Info.Cliente}<T>


[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
NombreEnBoton=S
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=expresion<BR>Refrescar Controles
ConCondicion=S
EjecucionCondicion=SQL(<T>Sp_AccionNuevoCtoMavi :ta,:tb,:tRF,:tc,:td,:te,:tf,:tg,:th,:ti,:tj,:tk,:tl,:tm,:tn<T>,Info.cliente,Info.CategoriaMavi,info.ABC,CteCto:CteCto.Tipo,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno,CteCto:CteCto.Nombre,fechaformatoservidor(CteCto:CteCto.FechaNacimiento),CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.ViveConMAVI,CteCto:CteCto.ViveEnCalidadDeMAVI,CteCto:CteCto.EstadoCivilMavi)<BR><BR><BR>SI (SQL(<T>Sp_AccionNuevoCtoMavi :ta,:tb,:tRF,:tc,:td,:te,:tf,:tg,:th,:ti,:tj,:tk,:tl,:tm,:tn<T>,Info.cliente,Info.CategoriaMavi,info.ABC,CteCto:CteCto.Tipo,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno,CteCto:CteCto.Nombre,fechaformatoservidor(CteCto:CteCto.FechaNacimiento),CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.A<CONTINUA>
EjecucionCondicion002=<CONTINUA>tencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.ViveConMAVI,CteCto:CteCto.ViveEnCalidadDeMAVI,CteCto:CteCto.EstadoCivilMavi)) <> verdadero<BR>entonces<BR> Asigna(Info.Dialogo,SQL(<T>SELECT Mensaje FROM MensajeErrorMavi<T>))<BR> error(Info.Dialogo)<BR>fin


[Acciones.Nuevo.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.desde2,nulo)<BR>EjecutarSQL(<T>SpActualizaTablaContMavi :ta,:nb,:tc,:td,:te,:df,:tg,:th,:ti,:tj,:tec,:tlada,:ttel<T>,CteCto:CteCto.Tipo,CteCto:CteCto.ID,CteCto:CteCto.Nombre,CteCto:CteCto.ApellidoPaterno,CteCto:CteCto.ApellidoMaterno,fechaformatoservidor(CteCto:CteCto.FechaNacimiento),CteCto:CteCto.CteEnviarAExpress,CteCto:CteCto.Sexo,CteCto:CteCto.Atencion,CteCto:CteCto.Tratamiento,CteCto:CteCto.EstadocivilMavi,CteCto:CteCto.LadaMavi,CteCto:CteCto.Telefonos)




[Acciones.Nuevo.Refrescar Controles]
Nombre=Refrescar Controles
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S



[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreDesplegar=E&liminar
EnBarraHerramientas=S
ConfirmarAntes=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Refrescar Controles<BR>Actualizar Titulos



[Acciones.Anexos]
Nombre=Anexos
Boton=77
NombreDesplegar=Anexos
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=AnexoCta
Activo=S
Antes=S
DespuesGuardar=S
AntesExpresiones=Asigna(Info.Rama, <T>CTO<T>)<BR>Asigna(Info.AnexoCfg, Verdadero)<BR>Asigna(Info.Cuenta, CteCto:CteCto.ID)<BR>Asigna(Info.Descripcion, CteCto:CteCto.Nombre)

[Acciones.Direcciones]
Nombre=Direcciones
Boton=35
NombreEnBoton=S
NombreDesplegar=&Direcciones
EnBarraHerramientas=S
Visible=S
GuardarAntes=S
Antes=S
DespuesGuardar=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Direccion
ActivoCondicion=(MAYUSCULAS(CteCto:CteCto.Tipo) noen(<T>COMERCIAL<T>,<T>BANCARIA<T>))
AntesExpresiones=Asigna(Info.Tipo,CteCto:CteCto.Tipo)<BR>Asigna(Info.ID,CteCto:CteCto.ID)<BR>Asigna(Info.Nombre, CteCto:CteCto.Nombre + <T> <T> + CteCto:CteCto.ApellidoPaterno)<BR>Asigna(Info.Acreedor,<T>Express<T>)



;**** Nueva sub accion de "Direcciones"
[Acciones.Direcciones.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Tipo,CteCto:CteCto.Tipo)<BR>Asigna(Info.ID,CteCto:CteCto.ID)<BR>Asigna(Info.Nombre, CteCto:CteCto.Nombre + <T> <T> + CteCto:CteCto.ApellidoPaterno)
Activo=S
ConCondicion=S
EjecucionCondicion=COnDatos(CteCto:CteCto.ID)
Visible=S



[Acciones.Direcciones.Direccion]
Nombre=Direccion
Boton=0
TipoAccion=Formas
ClaveAccion=CteCtoDireccion
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=COnDatos(CteCto:CteCto.ID)
Visible=S



[Acciones.Empleo]
Nombre=Empleo
Boton=128
NombreEnBoton=S
NombreDesplegar=&Empleo
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MaviCteCtoEmpleo
Visible=S
Antes=S
DespuesGuardar=S
Multiple=S
ListaAccionesMultiples=MaviCteCtoEmpleo
GuardarAntes=S
;ConCondicion=S
;EjecucionConError=S
;EjecucionCondicion=condatos(CteCto:CteCto.Tipo)
;EjecucionMensaje=<T>Es Necesario capturar un Tipo de Contacto<T>
ActivoCondicion=(MAYUSCULAS(CteCto:CteCto.Tipo) noen(<T>COMERCIAL<T>,<T>BANCARIA<T>))
AntesExpresiones=Asigna(Info.ID, CteCto:CteCto.ID)<BR>Asigna(Info.Nombre, CteCto:CteCto.Nombre)<BR>Asigna(Info.Acreedor,<T>Express<T>)



[Acciones.Empleo.MaviCteCtoEmpleo]
Nombre=MaviCteCtoEmpleo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
DespuesGuardar=S
ConCondicion=S
Expresion=Si Forma(<T>MaviCteCtoEmpleo<T>)<BR>Entonces<BR>    Forma.Accion(<T>Nuevo<T>)<BR>    Forma.RegistroAnterior<BR>    Forma.RegistroSiguiente<BR>    Forma.ActualizarForma<BR>Fin
EjecucionCondicion=COnDatos(CteCto:CteCto.ID)





[Lista.NombreCompleto]
Carpeta=Lista
Clave=NombreCompleto
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=200
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.ApellidoPaterno]
Carpeta=Ficha
Clave=CteCto.ApellidoPaterno
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.ApellidoMaterno]
Carpeta=Ficha
Clave=CteCto.ApellidoMaterno
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Tipo]
Nombre=* Tipo
Carpeta=Ficha
Clave=CteCto.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Sexo]
Carpeta=Ficha
Clave=CteCto.Sexo
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N

[Lista.CteCto.Tipo]
Carpeta=Lista
Clave=CteCto.Tipo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Bancos]
Nombre=Bancos
Boton=47
NombreEnBoton=S
NombreDesplegar=&Bancos
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MaviCteCtoBanco
Visible=S
EspacioPrevio=S
Antes=S
DespuesGuardar=S
Multiple=S
ListaAccionesMultiples=MaviCteCtoBanco
GuardarAntes=S
ConCondicion=S
EjecucionConError=S
ActivoCondicion=(MAYUSCULAS(CteCto:CteCto.Tipo)=<T>BANCARIA<T>)
EjecucionCondicion=condatos(CteCto:CteCto.Tipo)
EjecucionMensaje=<T>Es Necesario capturar un Tipo de Contacto<T>
AntesExpresiones=Asigna(Info.ID, CteCto:CteCto.ID)<BR>Asigna(Info.Nombre, CteCto:CteCto.Nombre)<BR>SI(info.CategoriaMavi<>nulo,Asigna(Info.Cliente, CteCto:CteCto.Cliente))
[Acciones.Comercial]
Nombre=Comercial
Boton=47
NombreEnBoton=S
NombreDesplegar=&Comercial
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MaviCteCtoComercial
Visible=S
Antes=S
DespuesGuardar=S
Multiple=S
ListaAccionesMultiples=MaviCteCtoComercial
GuardarAntes=S
ConCondicion=S
EjecucionConError=S
ActivoCondicion=(MAYUSCULAS(CteCto:CteCto.Tipo)=<T>COMERCIAL<T>)
EjecucionCondicion=condatos(CteCto:CteCto.Tipo)
EjecucionMensaje=<T>Es Necesario capturar un Tipo de Contacto<T>
AntesExpresiones=Asigna(Info.ID,CteCto:CteCto.ID)<BR>Asigna(Info.Nombre, CteCto:CteCto.Nombre)<BR>SI(info.CategoriaMavi<>nulo,Asigna(Info.Cliente, CteCto:CteCto.Cliente))

[Ficha.CteCto.CteEnviarAExpress]
Carpeta=Ficha
Clave=CteCto.CteEnviarAExpress
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=$00C8D0D4
ColorFuente=Negro


[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Expresion<BR>Aceptar
ConCondicion=S
EjecucionConError=S
;AGR 20100614 CAMBIO
EjecucionCondicion=(Sql(<T>Select Count(*) From CteCto where Cliente=:tCliente<T>,CteCto:CteCto.Cliente)>=2) y<BR><BR>(sql(<T>SP_CuentaContactosMavi :tcat,:treg,:tCte<T>,Info.CategoriaMavi,Info.ABC,CteCto:CteCto.Cliente)<1)
;EjecucionCondicion=Sql(<T>Select Count(*) From CteCto where Cliente=:tCliente<T>,CteCto:CteCto.Cliente)>=2
;EjecucionMensaje=<T>Favor de Capturar al menos 2 Contactos<T>
EjecucionMensaje=Si Info.CategoriaMavi <><T>MAYOREO<T><BR>Entonces<BR><T>Favor de Capturar al menos 2 Contactos y sus direcciones!<T><BR>Sino<BR>Sql(<T>Select Mensaje From MensajeErrorMavi<T>) <BR>Fin
[Acciones.Cancelar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=/*Asigna(Info.Clase,nulo)<BR>Asigna(Info.clase1,nulo)<BR>Asigna(Info.Clase2,nulo)<BR>Asigna(Info.Clase3,nulo)<BR>Asigna(Info.Clase4,nulo)<BR>Asigna(Info.Clase5,nulo)<BR>Asigna(Info.Actividad,nulo)<BR>Asigna(Info.Observaciones,nulo)<BR>Asigna(Info.Articulo,nulo)<BR>Asigna(Info.ArticuloA,nulo)<BR><BR>EjecutarSQL(<T>Sp_AccionCancelarContactosMavi :t<T>,info.cliente )*/
[Acciones.Cancelar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Bancos.MaviCteCtoBanco]
Nombre=MaviCteCtoBanco
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si Forma(<T>MaviCteCtoBanco<T>)<BR>Entonces<BR>    Forma.Accion(<T>Nuevo<T>)<BR>    Forma.RegistroAnterior<BR>    Forma.RegistroSiguiente<BR>Fin
[Acciones.Comercial.MaviCteCtoComercial]
Nombre=MaviCteCtoComercial
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si Forma(<T>MaviCteCtoComercial<T>)<BR>Entonces<BR>    Forma.Accion(<T>Nuevo<T>)<BR>    Forma.RegistroAnterior<BR>    Forma.RegistroSiguiente<BR>Fin<BR>
[Acciones.Eliminar.Refrescar Controles]
Nombre=Refrescar Controles
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>SpAccionEliminarMavi :ta,:nb<T>,Info.cliente,CteCto:CteCto.ID)
Activo=S
Visible=S
[Acciones.Eliminar.Actualizar Titulos]
Nombre=Actualizar Titulos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Direcciones.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
GuardarAntes=S	



[Ficha.CteCto.ViveConMAVI]
Carpeta=Ficha
Clave=CteCto.ViveConMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.CteCto.ViveEnCalidadDeMAVI]
Carpeta=Ficha
Clave=CteCto.ViveEnCalidadDeMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.CteCto.EstadocivilMavi]
Carpeta=Ficha
Clave=CteCto.EstadocivilMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.CteCto.Telefonos]
Carpeta=Ficha
Clave=CteCto.Telefonos
Editar=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.CteCto.LadaMavi]
Carpeta=Ficha
Clave=CteCto.LadaMavi
Editar=S
ValidaNombre=S
3D=S
Tamano=9
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.actFechas]
Nombre=actFechas
Boton=0
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
ConAutoEjecutar=S
Expresion=Asigna(CteCto:CteCto.FechaNacimiento,Mavi.ClienteContactoFecha)<BR>Si(condatos(CteCto:CteCto.FechaNacimiento),Asigna(Mavi.ClienteContactoFecha,nulo),<T><T>)
ConCondicion=S
EjecucionCondicion=condatos(Mavi.ClienteContactoFecha)
AutoEjecutarExpresion=1
[Acciones.Aceptar.direcciona ult mov]
Nombre=direcciona ult mov
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Primero
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=125
NombreDesplegar=&Actualizar
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
TeclaFuncion=F5
EnMenu=S
EnBarraHerramientas=S
