
[Forma]
Clave=RM1107IndicedeRecompraFrm
Icono=0
Modulos=(Todos)
Nombre=RM1107 Indice de Recompra

ListaCarpetas=filtros
CarpetaPrincipal=filtros
PosicionInicialAlturaCliente=164
PosicionInicialAncho=476
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=0
PosicionInicialArriba=0
PosicionSec1=49
ListaAcciones=(Lista)
[filtros]
Estilo=Ficha
Clave=filtros
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata





PermiteEditar=S


[ArtPersonal.Columnas]
PERSONAL=64
Estatus=94
NOMBRE=303
PUESTO=53
DEPARTAMENTO=91
FECHAALTA=70





[Lista.Columnas]
Cliente=104
Veces_compra=115
Total_compras=147
Promedio_por_compra=157




UEN=64
Nombre=604
id=64
Clave=64
Cadena=304
0=20
1=32
Veces_que_han_comprado=133
Numero_de_Clientes=103
Porcentaje_del_total=190
Importe_promedio=196
2=-2
[MaviCanalVentaInstRHVis.Columnas]
0=39
1=76
2=322












[(Variables).Mavi.RM1107UEN]
Carpeta=(Variables)
Clave=Mavi.RM1107UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro







[filtros.Mavi.RM1107UEN]
Carpeta=filtros
Clave=Mavi.RM1107UEN
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro



















[filtros.Mavi.RM1107CANALDEVENTA]
Carpeta=filtros
Clave=Mavi.RM1107CANALDEVENTA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro















[filtros.Mavi.RM1107MOVIMIENTOS]
Carpeta=filtros
Clave=Mavi.RM1107MOVIMIENTOS
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro














[Acciones.Filtrar]
Nombre=Filtrar
Boton=59
NombreEnBoton=S
NombreDesplegar=&Generar reporte
EnBarraHerramientas=S
BtnResaltado=S
TipoAccion=Expresion
Activo=S
Visible=S







Multiple=S
ListaAccionesMultiples=Refrescar


EspacioPrevio=S
[filtros.Mavi.RM1107SUCURSALES]
Carpeta=filtros
Clave=Mavi.RM1107SUCURSALES
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




LineaNueva=N
[Poblaciones.Columnas]
0=19






































1=131
2=-2


3=-2





Poblacion=184
[Acciones.Filtrar.Refrescar]
Nombre=Refrescar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S






[Lista.Veces_que_han_comprado]
Carpeta=Lista
Clave=Veces_que_han_comprado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

Tamano=1
[Lista.Numero_de_Clientes]
Carpeta=Lista
Clave=Numero_de_Clientes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Porcentaje_del_total]
Carpeta=Lista
Clave=Porcentaje_del_total
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Importe_promedio]
Carpeta=Lista
Clave=Importe_promedio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro













[Lista.ListaEnCaptura]
(Inicio)=Veces_que_han_comprado
Veces_que_han_comprado=Numero_de_Clientes
Numero_de_Clientes=Porcentaje_del_total
Porcentaje_del_total=Importe_promedio
Importe_promedio=(Fin)






























































[Forma.ListaCarpetas]
(Inicio)=filtros
filtros=(Variables)
(Variables)=(Fin)




[filtros.Mavi.RM1107POBLACIONES]
Carpeta=filtros
Clave=Mavi.RM1107POBLACIONES
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro






[Acciones.Filtrar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Refrescar
Refrescar=(Fin)











[Acciones.Asignar]
Nombre=Asignar
Boton=53
NombreEnBoton=S
NombreDesplegar=&Asignar fechas p/ filtros
EnBarraHerramientas=S
BtnResaltado=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




Multiple=S
ListaAccionesMultiples=(Lista)

[Acciones.Asignar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[filtros.Mavi.RM1107ESTADOS]
Carpeta=filtros
Clave=Mavi.RM1107ESTADOS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro








[filtros.Mavi.RM1107CATEGORIASVTA]
Carpeta=filtros
Clave=Mavi.RM1107CATEGORIASVTA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro













[Acciones.Limpiarf.LimpiarForma]
Nombre=LimpiarForma
Boton=0
TipoAccion=Expresion
Expresion=Asigna( Mavi.RM1107UEN, <T><T>)<BR>Asigna( Mavi.RM1107CANALDEVENTA, <T><T>)<BR>Asigna( Mavi.RM1107ESTADOS, <T><T>)<BR>Asigna( Mavi.RM1107POBLACIONES, <T><T>)<BR>Asigna( Mavi.RM1107SUCURSALES, <T><T>)<BR>Asigna( Mavi.RM1107CATEGORIASVTA, <T><T>)<BR>Asigna( Mavi.RM1107POBLACIONES, <T><T>)      <BR>Asigna( Mavi.RM1107MOVIMIENTOS, <T><T>)
Activo=S
Visible=S


[Acciones.Limpiarf.LimpiarVaria]
Nombre=LimpiarVaria
Boton=0
TipoAccion=Expresion
Expresion=Asigna( Mavi.RM1107UEN, <T><T>)<BR>Asigna( Mavi.RM1107CANALDEVENTA, <T><T>)<BR>Asigna( Mavi.RM1107ESTADOS, <T><T>)<BR>Asigna( Mavi.RM1107POBLACIONES, <T><T>)<BR>Asigna( Mavi.RM1107SUCURSALES, <T><T>)<BR>Asigna( Mavi.RM1107CATEGORIASVTA, <T><T>)<BR>Asigna( Mavi.RM1107POBLACIONES, <T><T>)      <BR>Asigna( Mavi.RM1107MOVIMIENTOS, <T><T>)
Activo=S
Visible=S

[Acciones.Limpiarf.RefrescarF]
Nombre=RefrescarF
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Refrescar Controles
Activo=S
Visible=S





Carpeta=(Carpeta principal)


[Acciones.Limpiarf.ListaAccionesMultiples]
(Inicio)=LimpiarVaria
LimpiarVaria=RefrescarF
RefrescarF=(Fin)











[Acciones.Limpiar.Borracontenido]
Nombre=Borracontenido
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna( Mavi.RM1107UEN, <T><T>)<BR>Asigna( Mavi.RM1107CANALDEVENTA, <T><T>)<BR>Asigna( Mavi.RM1107ESTADOS, <T><T>)<BR>Asigna( Mavi.RM1107POBLACIONES, <T><T>)<BR>Asigna( Mavi.RM1107SUCURSALES, <T><T>)<BR>Asigna( Mavi.RM1107CATEGORIASVTA, <T><T>)<BR>Asigna( Mavi.RM1107POBLACIONES, <T><T>)      <BR>Asigna( Mavi.RM1107MOVIMIENTOS, <T><T>)


[Acciones.Limpiar.ListaAccionesMultiples]
(Inicio)=Borracontenido
Borracontenido=RefrescarF
RefrescarF=(Fin)

































































[Acciones.Asignar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Rango de fechas asignado correctamente<T>)


[filtros.Info.FechaA]
Carpeta=filtros
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[filtros.Info.FechaD]
Carpeta=filtros
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro







[Acciones.Asignar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Mensaje
Mensaje=(Fin)




[filtros.ListaEnCaptura]
(Inicio)=Info.FechaD
Info.FechaD=Info.FechaA
Info.FechaA=Mavi.RM1107UEN
Mavi.RM1107UEN=Mavi.RM1107CATEGORIASVTA
Mavi.RM1107CATEGORIASVTA=Mavi.RM1107CANALDEVENTA
Mavi.RM1107CANALDEVENTA=Mavi.RM1107MOVIMIENTOS
Mavi.RM1107MOVIMIENTOS=Mavi.RM1107ESTADOS
Mavi.RM1107ESTADOS=Mavi.RM1107POBLACIONES
Mavi.RM1107POBLACIONES=Mavi.RM1107SUCURSALES
Mavi.RM1107SUCURSALES=(Fin)

[Forma.ListaAcciones]
(Inicio)=Asignar
Asignar=Filtrar
Filtrar=(Fin)

