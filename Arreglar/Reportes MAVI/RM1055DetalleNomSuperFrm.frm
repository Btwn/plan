[Forma]
Clave=RM1055DetalleNomSuperFrm
Nombre=RM1055Detalle Reporte Nomina Supervisores
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=121
PosicionInicialAncho=338
PosicionInicialIzquierda=73
PosicionInicialArriba=252
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Info.AgenteD<BR>Info.AgenteA
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.AgenteA]
Carpeta=(Variables)
Clave=Info.AgenteA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.AgenteD]
Carpeta=(Variables)
Clave=Info.AgenteD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[Acciones.Aceptar.Ac]
Nombre=Ac
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Crear Plantilla
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=ACEP<BR>Cerrar
[Acciones.Aceptar.ACEP]
Nombre=ACEP
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SI CONDATOS(Info.FechaD) y CONDATOS(Info.FechaA)<BR>    ENTONCES<BR>                SI ((año(Info.FechaA)*365)+ (mes(Info.FechaA)*30)+dia(Info.FechaA))-((año(Info.FechaD)*365)+ (mes(Info.FechaD)*30)+dia(Info.FechaD))>=0<BR>          ENTONCES<BR>              SI ((año(Info.FechaA)*365)+ (mes(Info.FechaA)*30)+dia(Info.FechaA))-((año(Info.FechaD)*365)+ (mes(Info.FechaD)*30)+dia(Info.FechaD))<32<BR>               Entonces<BR>              verdadero<BR>                 Sino<BR>                     ERROR(<T>El rango de fechas no debe ser mayor a 31 dias<T>)<BR>                 Fin<BR>         SINO<BR>           ERROR(<T>El rango de fechas es erroneo<T>)<BR>        FIN<BR>    SINO<BR>           ERROR(<T>Capture las fechas<T>)<BR>    FIN
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

