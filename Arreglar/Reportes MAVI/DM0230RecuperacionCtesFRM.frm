[Forma]
Clave=DM0230RecuperacionCtesFRM
Nombre=Importar Cuentas
Icono=0
Modulos=(Todos)
ListaCarpetas=Recuperacion
CarpetaPrincipal=Recuperacion
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cargar<BR>Guardar<BR>Regresar
PosicionInicialAlturaCliente=388
PosicionInicialAncho=952
BarraHerramientas=S
PosicionInicialIzquierda=138
PosicionInicialArriba=203
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
ExpresionesAlMostrar=EjecutarSQL(<T>Exec SP_MaviDM0230ListadoRecuperacion :bval, :btruncate<T>, 0, 1)
[Recuperacion]
Estilo=Hoja
Pestana=S
Clave=Recuperacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0230RecuperacionCtesVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Datos a Importar
ListaEnCaptura=DM0230RecuperacionCtesTbl.Fecha<BR>DM0230RecuperacionCtesTbl.Clave<BR>DM0230RecuperacionCtesTbl.Telefono<BR>DM0230RecuperacionCtesTbl.Calificacion<BR>DM0230RecuperacionCtesTbl.Login<BR>DM0230RecuperacionCtesTbl.Agente<BR>DM0230RecuperacionCtesTbl.Error
HojaPermiteInsertar=S
PermiteEditar=S
[Acciones.Cargar]
Nombre=Cargar
Boton=72
NombreEnBoton=S
NombreDesplegar=&Cargar
EnBarraAcciones=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
EnBarraHerramientas=S
[Recuperacion.Columnas]
Fecha=152
Clave=64
Telefono=83
Transferencia=196
Dialogo=196
Espera=196
TiempoNotas=196
Calificacion=176
Extension=64
Login=99
Agente=101
Campania=124
Min_Facturados=196
Costo=64
IVA=64
Total=64
Pstn=184
Tipo=184
TipoMarcacion=184
ResulMarcacion=184
QuienColgo=124
SubCalificacion=184
Error=604
[Acciones.Cambiar.Reasignar]
Nombre=Reasignar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=guardarcambios
EjecucionCondicion=condatos(DM0230RecuperacionCtesVis:DM0230RecuperacionCtesTbl.Clave)
EjecucionMensaje=<T>Debe incluir el archivo<T>
[Acciones.Cambiar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Validar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=Guardar Cambios<BR>Actualizar Vista
ConCondicion=S
GuardarConfirmar=S
EjecucionCondicion=Si ConDatos(DM0230RecuperacionCtesVis:DM0230RecuperacionCtesTbl.Fecha)<BR>Entonces<BR>    GuardarCambios<BR>    Asigna(Info.dialogo,SQL(<T>Exec SpIDM0230_ValRegistros :opc,:fecha<T>,2,0))<BR>    Si (Info.dialogo=0)<BR>    Entonces<BR>        Asigna(Info.dialogo,SQL(<T>Exec SP_MaviDM0230ListadoRecuperacion :tval,:trun<T>,1,0))<BR>        Si (Info.dialogo=0)<BR>        Entonces<BR>            Informacion(<T>Todos los registros son validos<T>)<BR>            Caso Confirmacion(<T>Deseas guardar los cambios<T>, BotonSi,BotonNo)<BR>            Es BotonSi Entonces<BR>               EjecutarSQL(<T>Exec SP_MaviDM0230ListadoRecuperacion :tval,:trun<T>,0,0)<BR>               Verdadero<BR>            Es BotonNo Entonces<BR>               Falso<BR>            Fin<BR>        Sino<BR>            Informacion(<T>Los siguientes registros no son validos<T>)<BR>            ActualizarVista<BR>            Falso<BR>        Fin<BR>    Sino<BR>        Si (Info.dialogo=1)<BR>        Entonces<BR>            Informacion(<T>El archivo no contiene información<T>)<BR>            Falso<BR>        Sino<BR>            Si (Info.dialogo=2)<BR>            Entonces<BR>                Informacion(<T>El archivo no puede tener registros con diferente fecha<T>)<BR>                Falso<BR>            Fin<BR>        Fin<BR>    Fin<BR>Sino<BR>    Error(<T>Ingrese datos en el campo fecha<T>)<BR>Fin
[Acciones.Regresar]
Nombre=Regresar
Boton=24
NombreEnBoton=S
NombreDesplegar=&Regresar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=DM0230RecuperacionTelFRM
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Cancelar/Cancelar Cambios<BR>Cerrar<BR>Regresar
[Acciones.Regresar.Regresar]
Nombre=Regresar
Boton=0
TipoAccion=Formas
ClaveAccion=DM0230RecuperacionTelFRM
Activo=S
Visible=S
[Acciones.Regresar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Guardar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Recuperacion.DM0230RecuperacionCtesTbl.Fecha]
Carpeta=Recuperacion
Clave=DM0230RecuperacionCtesTbl.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Recuperacion.DM0230RecuperacionCtesTbl.Clave]
Carpeta=Recuperacion
Clave=DM0230RecuperacionCtesTbl.Clave
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Recuperacion.DM0230RecuperacionCtesTbl.Telefono]
Carpeta=Recuperacion
Clave=DM0230RecuperacionCtesTbl.Telefono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=0
ColorFondo=Blanco
ColorFuente=Negro
[Recuperacion.DM0230RecuperacionCtesTbl.Calificacion]
Carpeta=Recuperacion
Clave=DM0230RecuperacionCtesTbl.Calificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Recuperacion.DM0230RecuperacionCtesTbl.Login]
Carpeta=Recuperacion
Clave=DM0230RecuperacionCtesTbl.Login
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Recuperacion.DM0230RecuperacionCtesTbl.Agente]
Carpeta=Recuperacion
Clave=DM0230RecuperacionCtesTbl.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Recuperacion.DM0230RecuperacionCtesTbl.Error]
Carpeta=Recuperacion
Clave=DM0230RecuperacionCtesTbl.Error
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Cargar.RevisaArchivo]
Nombre=RevisaArchivo
Boton=0
TipoAccion=Expresion
Expresion=GuardarCambios //Aqui se indica que se almacenarán los datos en la tabla DM0230RecuperacionCtesTbl<BR>Asigna(Info.dialogo,SQL(<T>Exec SP_MaviDM0230ValidacionRegistros :opc,:fecha<T>,2,0))  //Para validar los registros<BR>Si (Info.dialogo=1)<BR>Entonces<BR>    Informacion(<T>El archivo no contiene información<T>)<BR>Sino<BR>    Si (Info.dialogo=2)<BR>    Entonces<BR>        Informacion(<T>Las fechas no coinciden entre los registros<T>)<BR>    Fin<BR>Fin
Activo=S
Visible=S

[Acciones.Cargar.Cargar]
Nombre=Cargar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Regresar.Cancelar/Cancelar Cambios]
Nombre=Cancelar/Cancelar Cambios
Boton=0
TipoAccion=Ventana
ClaveAccion=Cancelar/Cancelar Cambios
Activo=S
Visible=S

