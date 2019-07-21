[Forma]
Clave=MaviVenSegVidaFrm
Nombre=RM282 Colocacion de Seguros de Vida
Icono=92
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Expresion1
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=169
PosicionInicialAncho=340
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaRepetir=S
PosicionInicialIzquierda=470
PosicionInicialArriba=410
ExpresionesAlMostrar=Asigna(Mavi.TipoSeguro,<T><T>)<BR>Asigna(Info.FechaD,primerdiames)<BR>Asigna(Info.FechaA,ultimodiames)
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario

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
FichaEspacioEntreLineas=20
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0282VentasSeguros
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
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
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
Efectos=[Negritas]
[Acciones.Preliminar.Asi]
Nombre=Asi
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (vacio(Info.FechaD)y vacio(Info.FechaA)) o (condatos(info.fechad) y vacio(info.fechaa))
EjecucionMensaje=Si  ((Info.FechaA)<(Info.FechaD)) ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>
EjecucionConError=S
Visible=S
[Acciones.Expresion]
Nombre=Expresion
Boton=0
NombreDesplegar=&Expresion
Multiple=S
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
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
Expresion=SI (FechaAMD(info.fechaD) > FechaAMD(Info.FechaA))<BR>ENTONCES<BR>    error(<T>Seleccione Rango de Fechas Valido...<T>)<BR>SINO<BR>    SI Vacio(Mavi.RM0282VentasSeguros)<BR>    ENTONCES<BR>        error(<T>Seleccione un Tipo de Reporte...<T>)<BR>    SINO<BR>        SI Vacio(Mavi.RM0282VentasSeguros)<BR>        ENTONCES<BR>            error(<T>Seleccione un Estatus...<T>)<BR>         sino<BR>         si (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>             y ConDatos(Mavi.RM0282VentasSeguros) //y ConDatos(Mavi.RM1035MenuFiltro)<BR>               y  (Mavi.RM0282VentasSeguros = <T>Relacion_Venta_Seguro<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>MaviVenSegVidaRep<T>)<BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.Fecha<CONTINUA>
Expresion002=<CONTINUA>A)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM0282VentasSeguros)// y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM0282VentasSeguros = <T>Promesa_Pago_Adquirida_Plazo_Total<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>MaviVenSegVidaRep2<T>)<BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM0282VentasSeguro) //y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM0282VentasSeguro = <T>Detalle_Venta<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>MaviVenSegVidaRep3<T>)<BR><BR><BR>                                FIN<BR>                            FIN<BR>                        FIN<BR>                    FIN          <CONTINUA>
Expresion003=<CONTINUA>                                                                                           <BR>                FIN<BR>            FIN<BR>        FIN
[Acciones.Expresion.Cerrar]
Nombre=Cerrar
Boton=0
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Expresion.Variables Asignar1]
Nombre=Variables Asignar1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Expresion1]
Nombre=Expresion1
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI (FechaAMD(info.fechaD) > FechaAMD(Info.FechaA))<BR>ENTONCES<BR>    error(<T>Seleccione Rango de Fechas Valido...<T>)<BR>SINO<BR>    SI Vacio(Mavi.RM1035VentasMenufrm)<BR>    ENTONCES<BR>        error(<T>Seleccione un Tipo de Reporte...<T>)<BR>    SINO<BR>        SI Vacio(Mavi.RM1035MenuFiltro)<BR>        ENTONCES<BR>            error(<T>Seleccione un Estatus...<T>)<BR>         sino<BR>         si (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>             y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>               y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Mes<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035Ventasrep<T>)<BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.Fecha<CONTINUA>
Expresion002=<CONTINUA>D < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Articulo<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035VentasArticulorep<T>)<BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                  y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Art_Analitico<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035VentasArtAnaliticorep<T>)<BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y <CONTINUA>
Expresion003=<CONTINUA>ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>CrediLanas<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>RM1035Creditosrep<T>)<BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Ventas_Devolucion<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035VentaDevolucionrep<T>)<BR><BR>                                                                                                                            <BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y <CONTINUA>
Expresion004=<CONTINUA>ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Cred_Bonificacion<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035CredBonificacionrep<T>)<BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Cheques_Devueltos<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035ChequesDevueltosrep<T>)<BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR><CONTINUA>
Expresion005=<CONTINUA>                 y  (Mavi.RM1035VentasMenufrm = <T>Devoluciones<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035Devolucionesrep<T>)                                                                           <BR><BR><BR>               SINO SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)// y (Info.FechaD < Info.FechaA)<BR>                y ConDatos(Mavi.RM1035VentasMenufrm) y ConDatos(Mavi.RM1035MenuFiltro)<BR>                 y  (Mavi.RM1035VentasMenufrm = <T>Notas_Cargo_Gastos<T>))<BR>     ENTONCES<BR>               reportepantalla(<T>RM1035NotasCargoGastosrep<T>)<BR><BR><BR><BR><BR>                                           FIN<BR>                                        FIN<BR>                                    FIN<BR>                                FIN<BR>             <CONTINUA>
Expresion006=<CONTINUA>               FIN<BR>                        FIN<BR>                    FIN<BR>                FIN<BR>            FIN<BR>        FIN<BR>    FIN<BR>FIN
[Acciones.Expresion1]
Nombre=Expresion1
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
Activo=S
Visible=S
[Acciones.Expresion1.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=si (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>             y ConDatos(Mavi.RM0282VentasSeguros)<BR>               y  (Mavi.RM0282VentasSeguros = <T>Resumen X Código<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>MaviVenSegVidaARep<T>)<BR>SINO<BR>               si (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>             y ConDatos(Mavi.RM0282VentasSeguros)<BR>               y  (Mavi.RM0282VentasSeguros = <T>Resumen X Plazo y Código<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>MaviVenSegVidaBRep<T>)<BR>SINO<BR>si (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>             y ConDatos(Mavi.RM0282VentasSeguros)<BR>               y  (Mavi.RM0282VentasSeguros = <T>Desglose de Movimientos<T>))<BR>      ENTONCES<BR>               reportepantalla(<T>MaviVe<CONTINUA>
Expresion002=<CONTINUA>nSegVidaCRep<T>)<BR><BR>FIN
[Acciones.Expresion1.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[(Variables).Mavi.RM0282VentasSeguros]
Carpeta=(Variables)
Clave=Mavi.RM0282VentasSeguros
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresion1.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar

