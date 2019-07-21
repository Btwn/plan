
[Forma]
Clave=DM0307COMSPermisosVisFrm
Icono=357
Modulos=(Todos)
MovModulo=COMS
Nombre=<T>Permisos<T>

ListaCarpetas=DM0307COMSPermisosVisFrm
CarpetaPrincipal=DM0307COMSPermisosVisFrm
PosicionInicialAlturaCliente=296
PosicionInicialAncho=260
PosicionInicialIzquierda=495
PosicionInicialArriba=339
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar Registro<BR>Salir<BR>Next
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[DM0307COMSPermisosVisFrm]
Estilo=Hoja
Clave=DM0307COMSPermisosVisFrm
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0307COMSAccesoHerramientaCitasProveedorVis
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
ListaEnCaptura=DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre
CarpetaVisible=S

MenuLocal=S
ListaAcciones=VerPermisos
PermiteEditar=S

[DM0307COMSPermisosVisFrm.Columnas]
Nombre=196


[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=Guardar Perfil
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registro Siguiente<BR>Guardar Cambios<BR>Actualizar Vista<BR>Mensaje
Activo=S
Visible=S
NombreEnBoton=S

ConCondicion=S
EjecucionCondicion=Forma.Accion(<T>Next<T>)<BR>Si<BR>(SQL(<T>SELECT COUNT(*) FROM TablaStD WHERE TablaSt = :tTabla AND Nombre = :tNombre<T>,<BR>     DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.TablaSt,<BR>     DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre)) = 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El perfil: <T>+DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre+<T> ya existe<T>)<BR>  AbortarOperacion<BR>Fin                                                                         
[Acciones.VerPermisos]
Nombre=VerPermisos
Boton=0
NombreDesplegar=Ver Permisos
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S


Expresion=Si<BR>  SQL(<T>SELECT Valor FROM TablaStD WHERE TablaSt = <T>+Comillas(<T>AccesoHerramientaCitasProveedor<T>) + <T>AND Nombre = <T> + Comillas(DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre))<BR>  = 1<BR>Entonces<BR>  Si<BR>    DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre <> <T>COMPR_GERA<T><BR>  Entonces<BR>      Informacion(<T>El perfil: <T>+DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre<BR>               +NuevaLinea+<T>Cuenta con permisos de Consultar/Editar/Modificar<T>)<BR>  Sino<BR>      Informacion(<T>El perfil: <T>+DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre<BR>               +NuevaLinea+<T>Cuenta con permisos de Consultar/Editar/Modificar/Administrar_Permisos<T>)<BR>  Fin<BR>Fin
[Acciones.Eliminar Registro.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Eliminar Registro.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Acciones.Eliminar Registro.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Eliminar Registro]
Nombre=Eliminar Registro
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar Perfil
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Vista<BR>Mensaje
Activo=S
Visible=S
ConCondicion=S

EjecucionCondicion=Si<BR>  DM0307COMSAccesoHerramientaCitasProveedorVis:DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre <> <T>COMPR_GERA<T><BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>No esta permitido eliminar al perfil COMPR_GERA<T>)<BR>  AbortarOperacion<BR>Fin
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
Boton=124
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

[Acciones.Guardar.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Guardar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Se agrego el perfil con éxito<T>)
Activo=S
Visible=S

[Acciones.Eliminar Registro.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Se eliminó el perfil con éxito<T>)
Activo=S
Visible=S

[Acciones.Next]
Nombre=Next
Boton=0
NombreDesplegar=Next
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[DM0307COMSPermisosVisFrm.DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre]
Carpeta=DM0307COMSPermisosVisFrm
Clave=DM0307COMSAccesoHerramientaCitasProveedorTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

