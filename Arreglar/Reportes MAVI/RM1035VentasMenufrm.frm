[Forma]
Clave=RM1035VentasMenufrm
Nombre=RM1035 Reportes Cierre Contable
Icono=0
Modulos=(Todos)
ListaCarpetas=RM1035VentasMenuLista
CarpetaPrincipal=RM1035VentasMenuLista
PosicionInicialAlturaCliente=184
PosicionInicialAncho=330
PosicionInicialIzquierda=547
PosicionInicialArriba=407
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Expresion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
[RM1035VentasMenuLista]
Estilo=Ficha
Clave=RM1035VentasMenuLista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1035VentasMenufrm<BR>Mavi.RM1035MenuFiltro
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
PestanaOtroNombre=S
PestanaNombre=Ventas Articulo
Pestana=S
[RM1035VentasMenuLista.Info.FechaD]
Carpeta=RM1035VentasMenuLista
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[RM1035VentasMenuLista.Info.FechaA]
Carpeta=RM1035VentasMenuLista
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[RM1035VentasMenuLista.Mavi.RM1035VentasMenufrm]
Carpeta=RM1035VentasMenuLista
Clave=Mavi.RM1035VentasMenufrm
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[RM1035VentasMenuLista.Mavi.RM1035MenuFiltro]
Carpeta=RM1035VentasMenuLista
Clave=Mavi.RM1035MenuFiltro
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Expresion]
Nombre=Expresion
Boton=7
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
[Acciones.Expresion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=SI (FechaAMD(info.fechaD) > FechaAMD(Info.FechaA))<BR>ENTONCES<BR>    error(<T>Seleccione Rango de Fechas Valido...<T>) <BR>SINO<BR>    SI Vacio(Mavi.RM1035VentasMenufrm)<BR>    ENTONCES<BR>        error(<T>Seleccione un Tipo de Reporte...<T>)<BR>    SINO<BR>        SI Vacio(Mavi.RM1035MenuFiltro)<BR>        ENTONCES<BR>            error(<T>Seleccione un Estatus...<T>)<BR>         sino<BR>         si (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>             y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>               y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Mes<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035Ventasrep<T>)<BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.Fech<CONTINUA>
Expresion002=<CONTINUA>aD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Articulo<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035VentasArticulorep<T>)<BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Art_Analitico<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035VentasArtAnaliticorep<T>)<BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y<CONTINUA>
Expresion003=<CONTINUA> ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>CrediLanas<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035Creditosrep<T>)<BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Devolucion<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035VentaDevolucionrep<T>)<BR><BR>                                                                                                                            <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y<CONTINUA>
Expresion004=<CONTINUA> ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Cred_Bonificacion<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035CredBonificacionrep<T>)<BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Cheques_Devueltos<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035ChequesDevueltosrep<T>)<BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR<CONTINUA>
Expresion005=<CONTINUA>>                 y  (Mavi.RM1035VentasMenufrm = <T>Devoluciones<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035Devolucionesrep<T>)                                                                           <BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Notas_Cargo_Gastos<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035NotasCargoGastosrep<T>)<BR><BR><BR><BR><BR>                                           FIN<BR>                                        FIN<BR>                                    FIN<BR>                                FIN<BR>            <CONTINUA>
Expresion006=<CONTINUA>                FIN<BR>                        FIN<BR>                    FIN<BR>                FIN<BR>            FIN<BR>        FIN<BR>    FIN <BR>FIN<BR><BR><BR>//Caso Mavi.RM1035VentasMenufrm   Es <T>Ventas_Mes<T>  Entonces ReportePantalla(<T>RM1035Ventasrep<T>)    Es <T>Ventas_Articulo<T>  Entonces ReportePantalla(<T>RM1035VentasArticulorep<T>)    Es <T>Ventas_Art_Analitico<T>  Entonces ReportePantalla(<T>RM1035VentasArtAnaliticorep<T>)    Es <T>Credito<T>  Entonces ReportePantalla(<T>RM1035Creditosrep<T>)    Es <T>Ventas_Devolucion<T> Entonces ReportePantalla(<T>RM1035VentaDevolucionrep<T>) fin
EjecucionCondicion=SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA) y (Info.FechaD < Info.FechaA)<BR>             y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>               y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Mes<T>))<BR>      ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035Ventasrep<T>)<BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Articulo<T>))<BR>      ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035VentasArticulorep<T>)<BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>              <CONTINUA>
EjecucionCondicion002=<CONTINUA>  y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Art_Analitico<T>))<BR>      ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035VentasArtAnaliticorep<T>)                                     <BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)                         <BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Credito<T>))<BR>      ENTONCES                                                                                       <BR>               verdadero //reportepantalla(<T>RM1035Creditosrep<T>)<BR>                                                 <CONTINUA>
EjecucionCondicion003=<CONTINUA>                                                                    <BR><BR>      SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Devolucion<T>))<BR>     ENTONCES<BR>               verdadero //reportepantalla(<T>RM1035VentaDevolucionrep<T>)<BR><BR>                            FIN<BR>                        FIN                                                               <BR>                    FIN                                                                  <BR>                FIN<BR>            FIN
EjecucionMensaje=SI (FechaAMD(info.fechaD) > FechaAMD(Info.FechaA))<BR>ENTONCES<BR>    error(<T>Seleccione Rango de Fechas Valido...<T>)<BR>SINO<BR>    SI Vacio(Mavi.RM1035VentasMenufrm)<BR>    ENTONCES<BR>        error(<T>Seleccione un Tipo de Reporte...<T>)<BR>    SINO<BR>        SI Vacio(Mavi.RM1035MenuFiltro)<BR>        ENTONCES<BR>            error(<T>Seleccione un Estatus...<T>)<BR>        FIN<BR>    FIN<BR>FIN
[Acciones.Expresion.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


