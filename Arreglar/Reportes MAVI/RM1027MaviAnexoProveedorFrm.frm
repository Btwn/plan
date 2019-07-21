[Forma]
Clave=RM1027MaviAnexoProveedorFrm
Nombre=RM1027 Anexo Proveedor
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=225
PosicionInicialAncho=261
PosicionInicialIzquierda=762
PosicionInicialArriba=333
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Expresion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Proveedor, nulo)<BR>Asigna(Info.FechaD, nulo)<BR>Asigna(Info.FechaA, nulo)<BR>Asigna(Mavi.RM1027MenuFiltro, nulo)<BR>Asigna(Mavi.RM1027MaviAnexoProvCategoriaVis, nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaA<BR>Info.Proveedor<BR>Mavi.RM1027MenuFiltro<BR>Mavi.RM1027MaviAnexoProvCategoriaVis
CarpetaVisible=S
AlinearTodaCarpeta=S
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Anexo de Proveedores 
[(Variables).Info.Proveedor]
Carpeta=(Variables)
Clave=Info.Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Preliminar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=18
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asig<BR>Cer
Activo=S
Visible=S
[(Variables).Mavi.RM1027MenuFiltro]
Carpeta=(Variables)
Clave=Mavi.RM1027MenuFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Expresion]
Nombre=Expresion
Boton=7
NombreEnBoton=S
NombreDesplegar=Ejecutar
TipoAccion=Expresion
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
Expresion=SI (FechaAMD(info.fechaD) > FechaAMD(Info.FechaA))<BR>ENTONCES        <BR>    error(<T>Seleccione Rango de Fechas Valido...<T>)         <BR>SINO        <BR>    SI Vacio(Mavi.RM1035VentasMenufrm)        <BR>    ENTONCES        <BR>        error(<T>Seleccione un Tipo de Reporte...<T>)        <BR>    SINO        <BR>        SI Vacio(Mavi.RM1035MenuFiltro)        <BR>        ENTONCES        <BR>            error(<T>Seleccione un Estatus...<T>)        <BR>         sino        <BR>         si (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>             y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>               y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Mes<T>))        <BR>      ENTONCES        <BR>               report<CONTINUA>
Expresion002=<CONTINUA>epantalla(<T>RM1035Ventasrep<T>)        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Articulo<T>))<BR>      ENTONCES        <BR>               reportepantalla(<T>RM1035VentasArticulorep<T>)        <BR>        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Art_Analitico<T>))        <BR>      ENTONCES        <BR>               reportepantalla(<<CONTINUA>
Expresion003=<CONTINUA>T>RM1035VentasArtAnaliticorep<T>)        <BR>        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>CrediLanas<T>))        <BR>      ENTONCES        <BR>               reportepantalla(<T>RM1035Creditosrep<T>)        <BR>        <BR>        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Devolucion<T>))        <BR>     ENTONCES        <BR>               r<CONTINUA>
Expresion004=<CONTINUA>eportepantalla(<T>RM1035VentaDevolucionrep<T>)        <BR>        <BR>        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Cred_Bonificacion<T>))        <BR>     ENTONCES        <BR>               reportepantalla(<T>RM1035CredBonificacionrep<T>)        <BR>        <BR>        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Cheques_Devueltos<T>))        <BR>  <CONTINUA>
Expresion005=<CONTINUA>   ENTONCES        <BR>               reportepantalla(<T>RM1035ChequesDevueltosrep<T>)        <BR>        <BR>        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)        <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Devoluciones<T>))        <BR>     ENTONCES        <BR>               reportepantalla(<T>RM1035Devolucionesrep<T>)                                                                                   <BR>        <BR>        <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)        <BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035Menu<CONTINUA>
Expresion006=<CONTINUA>Filtro)        <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Notas_Cargo_Gastos<T>))        <BR>     ENTONCES        <BR>               reportepantalla(<T>RM1035NotasCargoGastosrep<T>)        <BR>        <BR>        <BR>        <BR>        <BR>                                           FIN        <BR>                                        FIN        <BR>                                    FIN        <BR>                                FIN        <BR>                            FIN        <BR>                        FIN        <BR>                    FIN        <BR>                FIN        <BR>            FIN        <BR>        FIN        <BR>    FIN<BR>FIN
EjecucionCondicion=SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA) y (Info.FechaD < Info.FechaA)<BR>             y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>               y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Mes<T>))<BR>      ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035Ventasrep<T>)<BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Articulo<T>))<BR>      ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035VentasArticulorep<T>)<BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>              <CONTINUA>
EjecucionCondicion002=<CONTINUA>  y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Art_Analitico<T>))<BR>      ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035VentasArtAnaliticorep<T>)<BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)                         <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Credito<T>))<BR>      ENTONCES                                                                                       <BR>               verdadero //reportepantalla(<T>RM1035Creditosrep<T>)<BR><BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD <CONTINUA>
EjecucionCondicion003=<CONTINUA>< Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Devolucion<T>))<BR>     ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035VentaDevolucionrep<T>)<BR><BR>                            FIN<BR>                        FIN                                                               <BR>                    FIN<BR>                FIN<BR>            FIN
EjecucionMensaje=SI (FechaAMD(info.fechaD) > FechaAMD(Info.FechaA))<BR>ENTONCES<BR>    error(<T>Seleccione Rango de Fechas Valido...<T>)<BR>SINO<BR>    SI Vacio(Mavi.RM1035VentasMenufrm)<BR>    ENTONCES<BR>        error(<T>Seleccione un Tipo de Reporte...<T>)<BR>    SINO<BR>        SI Vacio(Mavi.RM1035MenuFiltro)<BR>        ENTONCES<BR>            error(<T>Seleccione un Estatus...<T>)<BR>        FIN<BR>    FIN<BR>FIN
[(Variables).Mavi.RM1027MaviAnexoProvCategoriaVis]
Carpeta=(Variables)
Clave=Mavi.RM1027MaviAnexoProvCategoriaVis
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Cer]
Nombre=Cer
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=SI vacio(info.fechaA)<BR>        entonces<BR>            INFORMACION(<T>Ingrese un valor En Campo Fecha...<T>)<BR>        sino<BR>            si ConDatos(Info.FechaA))<BR>                entonces<BR>                    VERDADERO<BR><BR>      FIN<BR>FIN

