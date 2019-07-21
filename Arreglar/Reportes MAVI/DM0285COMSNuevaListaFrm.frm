
[Forma]
Clave=DM0285COMSNuevaListaFrm
Icono=62
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=424
PosicionInicialArriba=278
PosicionInicialAlturaCliente=220
PosicionInicialAncho=465
Nombre=Agregar Nueva Lista De Prioridad
IniciarAgregando=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Guardar<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[Principal]
Estilo=Ficha
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0285COMSListaPrioridadVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=10
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0285COMSListaPrioridadTbl.Nombre<BR>DM0285COMSListaPrioridadTbl.UEN<BR>DM0285COMSListaPrioridadTbl.FechaInicio<BR>DM0285COMSListaPrioridadTbl.FechaFin<BR>DM0285COMSListaPrioridadTbl.Familia<BR>DM0285COMSListaPrioridadTbl.Linea
CarpetaVisible=S

[Principal.DM0285COMSListaPrioridadTbl.Nombre]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0285COMSListaPrioridadTbl.FechaInicio]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.FechaInicio
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=50
LineaNueva=S
[Principal.DM0285COMSListaPrioridadTbl.FechaFin]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.FechaFin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=50
[Principal.DM0285COMSListaPrioridadTbl.Familia]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.Familia
Editar=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

LineaNueva=S
[Principal.DM0285COMSListaPrioridadTbl.Linea]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0285COMSListaPrioridadTbl.UEN]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.UEN
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=50



LineaNueva=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
ConCondicion=S
Visible=S

ListaAccionesMultiples=Guardar Cambios<BR>ActualizaForma<BR>Cerrar
EjecucionCondicion=AvanzarCaptura<BR><BR>/*Validar que los campos de la forma esten llenos*/<BR>Si(Vacio(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Nombre),Informacion(<T>Debe llenar el campo <Nombre><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaInicio),Informacion(<T>Debe llenar el campo <Fecha Inicio><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaFin),Informacion(<T>Debe llenar el campo <Fecha Fin><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Familia),Informacion(<T>Debe llenar el campo <Familia><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Linea),Informacion(<T>Debe llenar el campo <Linea><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.UEN),Informacion(<T>Debe llenar el campo <UEN><T>) AbortarOperacion, Verdadero)<BR><BR>/*Validar que la fecha inicial sea mayor o igual a la fecha actual*/<BR>Si<BR>  SQL(<T>SELECT DATEDIFF(dd,CAST(CAST(GETDATE() AS DATE) AS DATETIME), :fInicial)<T>,DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaInicio) >= 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El campo <Fecha Inicio> no puede ser menor a la fecha actual<T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>/*Validar que no se quiera ingresar una fechainicial mayor que la fechafinal*/<BR>Si<BR>  SQL(<T>SELECT DATEDIFF(dd,:fInicio,:fFinal)<T><BR>      ,DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaInicio,<BR>       DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaFin) >= 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El campo <Fecha Inicio> debe ser menor a <Fecha Fin><T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>/*Validar que no se quiera crear una lista de prioridad con caracteristicas similares o parciales a una ya existente*/<BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM COMSCListaPrioridadEcommerce WITH(NOLOCK)<BR>       WHERE UEN = :nUEN<BR>       AND (:fInicio BETWEEN FechaInicio AND FechaFin<BR>       OR<BR>       :fFinal BETWEEN FechaInicio AND FechaFin)<BR>       AND Familia = :tFam<BR>       AND Linea = :tLin<T>,<BR>       DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.UEN,<BR>       DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaInicio,<BR>       DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaFin,<BR>       DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Familia,<BR>       DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Linea) > 0<BR>Entonces<BR>  Informacion(<T>Ya existe una lista de prioridad vigente con caracteristicas parecidas<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>/*Validar que las familias y lineas que se van a guardar sean validas*/<BR>Si<BR><BR>  SQL(<T>SELECT COUNT(*)<BR>  FROM(<BR>  SELECT DISTINCT Familia,Linea<BR>  FROM Art WITH(NOLOCK)<BR>  WHERE LEN(Familia)>0<BR>  AND LEN(Linea)>0<BR>  AND Grupo=:tGrupo<BR>  AND Estatus IN (:tEstatus1,:tEstatus2)<BR>  )tablaDerivada<BR>  WHERE Familia = :tFam<BR>  AND Linea = :tLin<T>,<T>MERCANCIA DE LINEA<T>,<T>ALTA<T>,<T>BLOQUEADO<T>,<BR>  DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Familia,<BR>  DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Linea) > 0<BR><BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>La Familia-Linea ingresada es erronea<T>)<BR>  AbortarOperacion<BR>Fin
[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cancelar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=23
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
ListaAccionesMultiples=Cancelar<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
ConCondicion=S





EjecucionCondicion=AvanzarCaptura<BR><BR>Si<BR>  (ConDatos(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Nombre))<BR>  o<BR>  (ConDatos(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaInicio))<BR>  o                                                                                              <BR>  (ConDatos(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.FechaFin))<BR>    o<BR>  (ConDatos(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Familia))<BR>    o<BR>  (ConDatos(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.Linea))<BR>    o<BR>  (ConDatos(DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.UEN))<BR>Entonces<BR>  Si<BR>    Confirmacion( <T>¿Salir sin guardar cambios?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>  Entonces<BR>    Verdadero<BR>  Sino                                              <BR>    AbortarOperacion<BR>  Fin<BR>Sino<BR> Verdadero<BR>Fin
[Acciones.Guardar.ActualizaForma]
Nombre=ActualizaForma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=OtraForma(<T>DM0285COMSListaPrioridadFrm<T>, Forma.Accion(<T>Actualizar<T>))<BR>Informacion(<T>Datos almacenados con exito<T>)

