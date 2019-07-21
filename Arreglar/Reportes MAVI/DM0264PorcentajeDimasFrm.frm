[Forma]
Clave=DM0264PorcentajeDimasFrm
Nombre=DM0264 Porcentaje Dimas
Icono=0
Modulos=(Todos)
ListaCarpetas=Porc
CarpetaPrincipal=Porc
PosicionInicialAlturaCliente=251
PosicionInicialAncho=744
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cerrar<BR>FormaConfig
PosicionInicialIzquierda=311
PosicionInicialArriba=239
Plantillas=S
PermiteCopiarDoc=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaAjustarZonas=S
[Porc]
Estilo=Hoja
Clave=Porc
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0264PorcentajeDimasVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
ListaEnCaptura=DM0264PorcentajeDimasTbl.Linea<BR>DM0264PorcentajeDimasTbl.Grupo<BR>DM0264PorcentajeDimasTbl.ComisionN1<BR>DM0264PorcentajeDimasTbl.TiempoDiasN1<BR>DM0264PorcentajeDimasTbl.ComisionN2<BR>DM0264PorcentajeDimasTbl.TiempoDiasN2
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Porc.Columnas]
Linea=288
Nivel1=64
Nivel2=64
Nivel3=64
Nivel4=64
Nivel5=64
CUOTA=64
0=-2
1=-2
2=-2
3=-2
4=-2
5=-2
6=144
Cuota=64
Familia=159
Grupo=140
Bloqueo=43
Capital=44
ComisionN1=64
ComisionN2=64
ComisionN3=64
ComisionN4=64
ComisionN5=64
TiempoDiasN1=71
TiempoDiasN2=71
TiempoDiasN3=71
TiempoDiasN4=71
TiempoDiasN5=71
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
ConCondicion=S
Multiple=S
ListaAccionesMultiples=Guardar<BR>Historico
EjecucionCondicion=Si Vacio(DM0264PorcentajeDimasVis:DM0264PorcentajeDimasTbl.Grupo)<BR>Entonces<BR>    Si DM0264PorcentajeDimasVis:DM0264PorcentajeDimasTbl.Familia en (<T>CALZADO<T>)<BR>    Entonces<BR>        Informacion(<T>Se necesita especificar Grupo para Calzado.<T>)<BR>        AbortarOperacion<BR>    Sino<BR>        Si SQL(<T>SELECT COUNT(*) FROM TcIDM0264_ConfMonederoRedDima WHERE Familia = :tLinea<T>,DM0264PorcentajeDimasVis:DM0264PorcentajeDimasTbl.Linea) > 1<BR>        Entonces<BR>            Informacion(<T>Ya existe esta configuración.<T>)<BR>            AbortarOperacion<BR>    Fin<BR>Fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Canc<BR>Cerrar
[Acciones.PorcExt.Frm]
Nombre=Frm
Boton=0
TipoAccion=Formas
ClaveAccion=DM0264PorcentajeExtraFrm
Activo=S
Visible=S
[Acciones.PorcExt.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Fam.Columnas]
Familia=304


[Porc.DM0264PorcentajeDimasTbl.Grupo]
Carpeta=Porc
Clave=DM0264PorcentajeDimasTbl.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Porc.DM0264PorcentajeDimasTbl.ComisionN1]
Carpeta=Porc
Clave=DM0264PorcentajeDimasTbl.ComisionN1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Porc.DM0264PorcentajeDimasTbl.ComisionN2]
Carpeta=Porc
Clave=DM0264PorcentajeDimasTbl.ComisionN2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco




[Linea.Columnas]
Linea=304


[Acciones.FormaConfig]
Nombre=FormaConfig
Boton=65
NombreEnBoton=S
NombreDesplegar=&Configuración DIMAR
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0264ConfigRedDimaFrm
Activo=S
Visible=S



[Acciones.Cerrar.Canc]
Nombre=Canc
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

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si Vacio(DM0264PorcentajeDimasVis:DM0264PorcentajeDimasTbl.Grupo)<BR>Entonces<BR>    Si DM0264PorcentajeDimasVis:DM0264PorcentajeDimasTbl.Familia en (<T>CALZADO<T>)<BR>    Entonces<BR>        Informacion(<T>Se necesita especificar Grupo para Calzado.<T>)<BR>        AbortarOperacion<BR>    Sino<BR>        Si SQL(<T>SELECT COUNT(*) FROM TcIDM0264_ConfMonederoRedDima WHERE Familia = :tFamilia<T>,DM0264PorcentajeDimasVis:DM0264PorcentajeDimasTbl.Familia) > 1<BR>        Entonces<BR>            Informacion(<T>Ya existe esta configuración.<T>)<BR>            AbortarOperacion<BR>    Fin<BR>Fin

[Porc.DM0264PorcentajeDimasTbl.TiempoDiasN1]
Carpeta=Porc
Clave=DM0264PorcentajeDimasTbl.TiempoDiasN1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1
ColorFondo=Blanco

[Porc.DM0264PorcentajeDimasTbl.TiempoDiasN2]
Carpeta=Porc
Clave=DM0264PorcentajeDimasTbl.TiempoDiasN2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1
ColorFondo=Blanco




[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Historico]
Nombre=Historico
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL( <T>EXEC SpCrediHistoricoPorcentajes<T> )

[Porc.DM0264PorcentajeDimasTbl.Linea]
Carpeta=Porc
Clave=DM0264PorcentajeDimasTbl.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Lin.Columnas]
Linea=304



