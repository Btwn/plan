
[Forma]
Clave=RM0195COMSConsultaComisionTCFrm
Icono=91
Modulos=(Todos)
Nombre=<T>Registro De Porcentaje De Comision De Tarjetas De Credito<T>

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=433
PosicionInicialArriba=161
PosicionInicialAlturaCliente=407
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Reporte<BR>Agregar<BR>Modificar<BR>ClasificarP<BR>Eliminar<BR>Salir<BR>Actualizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaAvanzaTab=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Info.Numero,)
[Principal]
Estilo=Hoja
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0195COMSComisionTCVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM0195COMSComisionTCTbl.Uen<BR>RM0195COMSComisionTCTbl.Mes<BR>RM0195COMSComisionTCTbl.Anio<BR>RM0195COMSComisionTCTbl.TCPU<BR>RM0195COMSComisionTCTbl.TCMSI
CarpetaVisible=S

[Principal.RM0195COMSComisionTCTbl.Uen]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.Uen
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.Mes]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.Mes
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.Anio]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.Anio
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.TCPU]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.TCPU
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.RM0195COMSComisionTCTbl.TCMSI]
Carpeta=Principal
Clave=RM0195COMSComisionTCTbl.TCMSI
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.Columnas]
Uen=89
Mes=94
Anio=88
TCPU=94
TCMSI=93

[Acciones.Agregar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Agregar]
Nombre=Agregar
Boton=11
NombreEnBoton=S
NombreDesplegar=Agregar
EnBarraHerramientas=S

Visible=S
TipoAccion=Formas
ClaveAccion=RM0195COMSRegistrarComisionTCFrm
EspacioPrevio=S
ActivoCondicion=Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM Usuario WITH (NOLOCK)<BR>       WHERE Estatus = :tEstatus<BR>       AND Acceso IN (SELECT<BR>         Nombre<BR>         FROM TablaStD<BR>         WHERE TablaSt = :tTablaConversion)<BR>       AND Usuario = :tUsuario<T>,<T>ALTA<T>,<T>RM0195 ACCESO MODIFICACION PORCENTAJE COMISIONES<T>,Usuario) > 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin
[Acciones.Eliminar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Eliminar.Eliminar]
Nombre=Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Eliminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Seleccionar<BR>Eliminar<BR>Guardar Cambios
EspacioPrevio=S

Visible=S
ActivoCondicion=Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM Usuario WITH (NOLOCK)<BR>       WHERE Estatus = :tEstatus<BR>       AND Acceso IN (SELECT<BR>         Nombre<BR>         FROM TablaStD<BR>         WHERE TablaSt = :tTablaConversion)<BR>       AND Usuario = :tUsuario<T>,<T>ALTA<T>,<T>RM0195 ACCESO MODIFICACION PORCENTAJE COMISIONES<T>,Usuario) > 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin
ConCondicion=S
EjecucionCondicion=Si<BR>  Confirmacion( <T>¿Desea eliminar el registro?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  AbortarOperacion<BR>Fin
[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Expresion=ActualizarForma
Activo=S
Visible=S

[Acciones.Modificar]
Nombre=Modificar
Boton=45
NombreEnBoton=S
NombreDesplegar=Modificar
EnBarraHerramientas=S
Visible=S
EspacioPrevio=S

Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Expresion<BR>Modificar
ActivoCondicion=Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM Usuario WITH (NOLOCK)<BR>       WHERE Estatus = :tEstatus<BR>       AND Acceso IN (SELECT<BR>         Nombre<BR>         FROM TablaStD<BR>         WHERE TablaSt = :tTablaConversion)<BR>       AND Usuario = :tUsuario<T>,<T>ALTA<T>,<T>RM0195 ACCESO MODIFICACION PORCENTAJE COMISIONES<T>,Usuario) > 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin
[Acciones.Modificar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Modificar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Numero,RM0195COMSComisionTCVis:RM0195COMSComisionTCTbl.IDComisionTarjetaCredito)
Activo=S
Visible=S

[Acciones.Modificar.Modificar]
Nombre=Modificar
Boton=0
TipoAccion=Formas
ClaveAccion=RM0195COMSModificarComisionTCFrm
Activo=S
Visible=S

[Acciones.Reporte]
Nombre=Reporte
Boton=9
NombreEnBoton=S
NombreDesplegar=Generar Txt
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM0195COMSHistoricoComisionRep
Activo=S
Visible=S

[Acciones.ClasificarP]
Nombre=ClasificarP
Boton=103
NombreEnBoton=S
NombreDesplegar=Clasificar Plazos
EnBarraHerramientas=S
Visible=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=RM0195ClasificacionPlazosFrm
ActivoCondicion=Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM Usuario WITH (NOLOCK)<BR>       WHERE Estatus = :tEstatus<BR>       AND Acceso IN (SELECT<BR>         Nombre<BR>         FROM TablaStD<BR>         WHERE TablaSt = :tTablaConversion)<BR>       AND Usuario = :tUsuario<T>,<T>ALTA<T>,<T>RM0195 ACCESO MODIFICACION PORCENTAJE COMISIONES<T>,Usuario) > 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin

