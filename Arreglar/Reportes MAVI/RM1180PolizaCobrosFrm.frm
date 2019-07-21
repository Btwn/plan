
[Forma]
Clave=RM1180PolizaCobrosFrm
Icono=0
Modulos=(Todos)
Nombre=RM1180PolizaCobros
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=496
PosicionInicialArriba=306
PosicionInicialAlturaCliente=118
PosicionInicialAncho=374
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=aTxt<BR>Cerrar<BR>Preliminar
ExpresionesAlMostrar=Asigna(Mavi.RM1180ConceptoFitro,COMILLAS(<T>POLIZA COBRO<T>))<BR>Asigna(Mavi.RM1180EstatusFitro,<T><T>)          <BR>Asigna(Mavi.RM1180FechaIni,HOY)<BR>Asigna(Mavi.RM1180FechaFin,HOY)
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
PermiteEditar=S




ListaEnCaptura=Mavi.RM1180FechaIni<BR>Mavi.RM1180FechaFin<BR>Mavi.RM1180ConceptoFitro<BR>Mavi.RM1180EstatusFitro
[EstatusVis.Columnas]
0=-2

[ConceptoVis.Columnas]
0=-2

[Acciones.aTxt]
Nombre=aTxt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Txt
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Exportar<BR>Cerrar
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S

[Acciones.aTxt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.aTxt.Exportar]
Nombre=Exportar
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1180PolizaCobrosRepTxt
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=SI Vacio(Mavi.RM1180FechaIni) o Vacio(Mavi.RM1180FechaFin) ENTONCES<BR>     INFORMACION(<T>Es necesario especificar un rango de fecha.<T>)<BR>     ABORTAROPERACION<BR> FIN<BR><BR> SI (Mavi.RM1180FechaFin < Mavi.RM1180FechaIni ) ENTONCES<BR>     INFORMACION(<T>El rango de fecha proporcionado es inválido<T>)<BR>     ASIGNA(Mavi.RM1180FechaFin, Mavi.RM1180FechaIni)<BR>     ABORTAROPERACION<BR> FIN<BR><BR> SI Vacio(Mavi.RM1180ConceptoFitro) ENTONCES<BR>     INFORMACION(<T>El campo Concepto Póliza es obligatorio.<T>)<BR>     ABORTAROPERACION<BR> FIN<BR><BR> SI (Posicion(<T>POLIZA COBRO<T>,Mavi.RM1180ConceptoFitro)=0) y<BR> (Posicion(<T>COBRO INSTITUCIONES<T>,Mavi.RM1180ConceptoFitro)=0)<BR> ENTONCES<BR>     INFORMACION(<T>Valor inválido en campo Concepto Póliza.<T>)<BR>     Asigna(Mavi.RM1180ConceptoFitro,COMILLAS(<T>POLIZA COBRO<T>))<BR>     ABORTAROPERACION<BR> FIN<BR><BR> SI (Posicion(<T>POLIZA COBRO<T>,Mavi.RM1180ConceptoFitro)<>0) y<BR> (Posicion(<T>COBRO INSTITUCIONES<T>,Mavi.RM1180ConceptoFitro)<>0)<BR> ENTONCES<BR>     Asigna(Mavi.RM1180ConceptoFitro,COMILLAS(<T>POLIZA COBRO,COBRO INSTITUCIONES<T>))<BR> SINO<BR>     SI (Posicion(<T>POLIZA COBRO<T>,Mavi.RM1180ConceptoFitro)<>0)<BR>     ENTONCES<BR>         Asigna(Mavi.RM1180ConceptoFitro,COMILLAS(<T>POLIZA COBRO<T>))<BR>     SINO<BR>         Asigna(Mavi.RM1180ConceptoFitro,COMILLAS(<T>COBRO INSTITUCIONES<T>))<BR>     FIN<BR> FIN<BR><BR> Asigna(Mavi.RM1180EstatusFitro, Reemplaza( <T>SIN AFECTAR<T>, <T>SINAFECTAR<T>, Mavi.RM1180EstatusFitro ))<BR><BR> SI (Posicion(<T>CONCLUIDO<T>,Mavi.RM1180EstatusFitro)<>0) y<BR> (Posicion(<T>SINAFECTAR<T>,Mavi.RM1180EstatusFitro)<>0)<BR> ENTONCES<BR>     Asigna(Mavi.RM1180EstatusFitro,COMILLAS(<T>CONCLUIDO,SINAFECTAR<T>))<BR> SINO                                                         <BR>     SI (Posicion(<T>CONCLUIDO<T>,Mavi.RM1180EstatusFitro)=0) y<BR>     (Posicion(<T>SINAFECTAR<T>,Mavi.RM1180EstatusFitro)=0)<BR>     ENTONCES<BR>         Asigna(Mavi.RM1180EstatusFitro,NULO)                              <BR>     FIN<BR>     SI (Posicion(<T>CONCLUIDO<T>,Mavi.RM1180EstatusFitro)<>0)<BR>     ENTONCES<BR>         Asigna(Mavi.RM1180EstatusFitro,COMILLAS(<T>CONCLUIDO<T>))<BR>     FIN<BR>     SI (Posicion(<T>SINAFECTAR<T>,Mavi.RM1180EstatusFitro)<>0)<BR>     ENTONCES<BR>         Asigna(Mavi.RM1180EstatusFitro,COMILLAS(<T>SINAFECTAR<T>))<BR>     FIN<BR> FIN                                                                               <BR><BR><BR> VERDADERO
[Acciones.aTxt.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[(Variables).Mavi.RM1180FechaIni]
Carpeta=(Variables)
Clave=Mavi.RM1180FechaIni
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1180FechaFin]
Carpeta=(Variables)
Clave=Mavi.RM1180FechaFin
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1180ConceptoFitro]
Carpeta=(Variables)
Clave=Mavi.RM1180ConceptoFitro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1180EstatusFitro]
Carpeta=(Variables)
Clave=Mavi.RM1180EstatusFitro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista.Columnas]
0=-2


