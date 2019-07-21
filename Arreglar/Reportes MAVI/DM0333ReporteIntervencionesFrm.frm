
[Forma]
Clave=DM0333ReporteIntervencionesFrm
Icono=104
Modulos=(Todos)
Nombre=Reporte de Intervenciones

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=184
PosicionInicialAncho=329
Menus=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
ListaAcciones=Pre<BR>TXT
PosicionInicialIzquierda=475
PosicionInicialArriba=401
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.DM0333Cliente,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.DM0333BeneficiarioFinal,Nulo )
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
FichaColorFondo=Plata
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.DM0333Cliente<BR>MAVI.DM0333Tipo<BR>Mavi.DM0333BeneficiarioFinal



[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
LineaNueva=S

[Acciones.Pre]
Nombre=Pre
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S

GuardarAntes=S
Multiple=S
ListaAccionesMultiples=control
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR> (ConDatos(Info.FechaD) y ConDatos(Info.FechaA) y Info.FechaD<Info.FechaA)<BR>Entonces<BR>Verdadero<BR>Sino<BR>  Falso<BR>Fin
EjecucionMensaje=<T>Ingrese una Fecha Valida<T>
[Acciones.TXT]
Nombre=TXT
Boton=54
NombreEnBoton=S
NombreDesplegar=TXT
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
EspacioPrevio=S
ListaAccionesMultiples=asignar<BR>reporte<BR>cerrar
ConCondicion=S
EjecucionConError=S
GuardarAntes=S
EjecucionCondicion=Si<BR> (ConDatos(Info.FechaD) y ConDatos(Info.FechaA) y Info.FechaD<Info.FechaA)<BR>Entonces<BR>Verdadero<BR>Sino<BR>  Falso<BR>Fin
EjecucionMensaje=<T>Ingrese una Fecha Valida<T>
[Acciones.TXT.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>   ((Medio( Mavi.DM0333Cliente,1,1)= <T>C<T>) y (MAVI.DM0333Tipo = <T>Dima<T>) o<BR>   (Medio( Mavi.DM0333Cliente,1,1)= <T>c<T>) y (MAVI.DM0333Tipo = <T>Dima<T>) o<BR>   (Mavi.DM0333Cliente = nulo ) y (MAVI.DM0333Tipo = <T>Dima<T>))  o<BR>   ((Medio( Mavi.DM0333BeneficiarioFinal,1,1)= <T>F<T>) y (MAVI.DM0333Tipo = <T>Beneficiario Final<T>)  o<BR>   (Medio( Mavi.DM0333BeneficiarioFinal,1,1)= <T>f<T>) y (MAVI.DM0333Tipo = <T>Beneficiario Final<T>) o<BR>   (Mavi.DM0333BeneficiarioFinal = nulo) y (MAVI.DM0333Tipo = <T>Beneficiario Final<T>))<BR>Entonces<BR>Verdadero<BR>Sino<BR>  Falso<BR>Fin
EjecucionMensaje=<T>El cliente que ingreso no concuerda con el filtro de Tipo<T>
[Acciones.TXT.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0333ReporteIntervencionesRepTxt
Activo=S
Visible=S

[Acciones.TXT.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Lista.Columnas]
Cliente=64
Nombre=293
RFC=107
Canal=64
Domicilio=184



[(Variables).Mavi.DM0333Cliente]
Carpeta=(Variables)
Clave=Mavi.DM0333Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco






[(Variables).MAVI.DM0333Tipo]
Carpeta=(Variables)
Clave=MAVI.DM0333Tipo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0333BeneficiarioFinal]
Carpeta=(Variables)
Clave=Mavi.DM0333BeneficiarioFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.Pre.control]
Nombre=control
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S


EjecucionCondicion=Si<BR>   ((Medio( Mavi.DM0333Cliente,1,1)= <T>C<T>) y (MAVI.DM0333Tipo = <T>Dima<T>) o<BR>   (Medio( Mavi.DM0333Cliente,1,1)= <T>c<T>) y (MAVI.DM0333Tipo = <T>Dima<T>) o<BR>   (Mavi.DM0333Cliente = nulo ) y (MAVI.DM0333Tipo = <T>Dima<T>))  o<BR>   ((Medio( Mavi.DM0333BeneficiarioFinal,1,1)= <T>F<T>) y (MAVI.DM0333Tipo = <T>Beneficiario Final<T>)  o<BR>   (Medio( Mavi.DM0333BeneficiarioFinal,1,1)= <T>f<T>) y (MAVI.DM0333Tipo = <T>Beneficiario Final<T>) o<BR>   (Mavi.DM0333BeneficiarioFinal = nulo) y (MAVI.DM0333Tipo = <T>Beneficiario Final<T>))<BR>Entonces<BR>Verdadero<BR>Sino<BR>  Falso<BR>Fin
EjecucionMensaje=<T>El cliente que ingreso no concuerda con el filtro de Tipo<T>


