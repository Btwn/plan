
[Forma]
Clave=DM0277RepClienteFrm
Icono=0
Modulos=(Todos)
Nombre=&Reporte Por Cliente
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Cerrar<BR>TxT<BR>Excel
PosicionInicialAlturaCliente=118
PosicionInicialAncho=316
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=520
PosicionInicialArriba=375
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


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
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Info.Cliente<BR>Mavi.DM0277FechaInicial<BR>Mavi.DM0277FechaFinal

PermiteEditar=S
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.Columnas]
Cliente=64
Nombre=293
Tipo=94
RFC=107
Telefonos=604
Categoria=304
Estatus=94
Agente=75
EnviarA=145

[(Variables).Mavi.DM0277FechaInicial]
Carpeta=(Variables)
Clave=Mavi.DM0277FechaInicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0277FechaFinal]
Carpeta=(Variables)
Clave=Mavi.DM0277FechaFinal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
EspacioPrevio=N

[Acciones.TxT]
Nombre=TxT
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Exportar<BR>Cerrar
[Acciones.TxT.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Exportar<BR>Cerrar
[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Excel.Exportar]
Nombre=Exportar
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=DM0277RepClienteRepXls
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si ConDatos(Mavi.DM0277FechaInicial))<BR>Entonces<BR>    Si ConDatos(Mavi.DM0277FechaFinal)<BR>    Entonces<BR>        Si Mavi.DM0277FechaInicial>Mavi.DM0277FechaFinal<BR>        Entonces<BR>            Informacion(<T>Las fechas son incorrectas<T>)<BR>        Sino<BR>            Verdadero<BR>        Fin<BR>    Sino<BR>        Informacion(<T>Especifica la fecha final<T>)<BR>        Falso<BR>    Fin<BR>Sino<BR>    Informacion(<T>Especifica la fecha inicial<T>)<BR>    Falso<BR>Fin
[Acciones.TxT.Exportar]
Nombre=Exportar
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
ClaveAccion=DM0277RepClienteRepTxt

ConCondicion=S
EjecucionCondicion=Si ConDatos(Mavi.DM0277FechaInicial))<BR>Entonces<BR>    Si ConDatos(Mavi.DM0277FechaFinal)<BR>    Entonces<BR>        Si Mavi.DM0277FechaInicial>Mavi.DM0277FechaFinal<BR>        Entonces<BR>            Informacion(<T>Las fechas son incorrectas<T>)<BR>        Sino<BR>            Verdadero<BR>        Fin<BR>    Sino<BR>        Informacion(<T>Especifica la fecha final<T>)<BR>        Falso<BR>    Fin<BR>Sino<BR>    Informacion(<T>Especifica la fecha inicial<T>)<BR>    Falso<BR>Fin
[Acciones.TxT.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

