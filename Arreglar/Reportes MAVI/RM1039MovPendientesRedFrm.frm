
[Forma]
Clave=RM1039MovPendientesRedFrm
Icono=126
Modulos=(Todos)
Nombre=Movimientos pendientes redimidos

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=248
PosicionInicialAncho=1057
PosicionInicialIzquierda=225
PosicionInicialArriba=83
[Vista]
Estilo=Hoja
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1039MovPendientesRedVis
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
ListaEnCaptura=Cliente<BR>Nombre<BR>Fecha<BR>Sucursal<BR>Movimiento<BR>Canal<BR>Condicion<BR>ImporteVta<BR>Redimido<BR>Generado
CarpetaVisible=S

[Vista.Cliente]
Carpeta=Vista
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Vista.Nombre]
Carpeta=Vista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Vista.Fecha]
Carpeta=Vista
Clave=Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Vista.Sucursal]
Carpeta=Vista
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Vista.Movimiento]
Carpeta=Vista
Clave=Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco

[Vista.Canal]
Carpeta=Vista
Clave=Canal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Vista.Condicion]
Carpeta=Vista
Clave=Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Vista.ImporteVta]
Carpeta=Vista
Clave=ImporteVta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Vista.Columnas]
Cliente=64
Nombre=279
Fecha=123
Sucursal=45
Movimiento=147
Canal=34
Condicion=105
ImporteVta=84
Importe=87

Redimido=64
Generado=64
[Vista.Redimido]
Carpeta=Vista
Clave=Redimido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Vista.Generado]
Carpeta=Vista
Clave=Generado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
