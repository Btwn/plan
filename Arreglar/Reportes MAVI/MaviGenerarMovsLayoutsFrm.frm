[Forma]
Clave=MaviGenerarMovsLayoutsFrm
Nombre=Generar Movimientos
Icono=139
Modulos=(Todos)
MovModulo=(Todos)
AccionesTamanoBoton=15x5
ListaCarpetas=Generar
CarpetaPrincipal=Generar
ListaAcciones=Cerrar<BR>Aceptar
PosicionInicialAlturaCliente=181
PosicionInicialAncho=256
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=512
PosicionInicialArriba=404
AccionesCentro=S
BarraHerramientas=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.NumCanalVenta,Nulo)<BR>ASigna(Info.Ejercicio,SQL(<T>SELECT Ej=YEAR(GETDATE())<T>))<BR>Asigna(Info.Periodo,SQL(<T>SELECT Per=MONTH(GETDATE())<T>))<BR>Asigna(Info.Quincena,SQL(<T>SELECT Qui=CASE WHEN DAY(GETDATE()) < 16 THEN 1 ELSE 2 END<T>))<BR>Asigna(Info.Reemplazar,<T>Si<T>)<BR>Asigna(Info.CategoriaCanal,<T>INSTITUCIONES<T>)<BR>Asigna(Info.Nombre,<T> de Instituciones<T>)<BR>Asigna(Mavi.CierrePeriodo,<T>No<T>)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=&Generar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
NombreEnBoton=S
EnBarraAcciones=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
EspacioPrevio=S
Activo=S
Visible=S
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si Mavi.CierrePeriodo=<T>No<T><BR>Entonces<BR>    Si SQL(<T>SELECT COUNT(Enviado) FROM dbo.MaviEnvDispElectHist WHERE IDCanalVenta=:nCan AND Enviado=0<T>,Mavi.NumCanalVenta) = 0<BR>    Entonces<BR>        EjecutarSQLAnimado(<T>EXEC dbo.SP_MaviLayoutInstituciones :tCanal, :tUsr, :tProc<T>,Mavi.NumCanalVenta,Usuario,0)<BR>        Informacion(<T>Proceso Terminado.<BR>Se Generaron <T><BR>    &SQL(<T>Select Count(Mov) From dbo.MaviEnvDispElectHist Where Ejercicio=:nEje And Periodo=:nPer And Quincena=:nQui And IDCanalVenta=:nCan And Enviado=0<T>,<BR>    Info.Ejercicio,Info.Periodo,Info.Quincena,Mavi.NumCanalVenta)& <T> Movimientos.<T>)<BR>    Sino<BR>        EjecutarSQLAnimado(<T>EXEC dbo.SP_MaviLayoutInstituciones :tCanal, :tUsr, :tProc<T>,Mavi.NumCanalVenta,Usuario,0)<BR>        Informacion(<T<CONTINUA>
Expresion002=<CONTINUA>>Proceso Terminado.<BR>Se Generaron <T><BR>    &SQL(<T>Select Count(Mov) From dbo.MaviEnvDispElectHist Where Ejercicio=:nEje And Periodo=:nPer And Quincena=:nQui And IDCanalVenta=:nCan And Enviado=0<T>,<BR>    Info.Ejercicio,Info.Periodo,Info.Quincena,Mavi.NumCanalVenta)& <T> Movimientos.<T>)<BR>    Fin<BR>Sino<BR>    Si SQL(<T>SELECT COUNT(Enviado) FROM dbo.MaviEnvDispElectHist WHERE Ejercicio=:nEje AND Periodo=:nPer AND Quincena=:nQui AND IDCanalVenta=:nCan AND Enviado=1<T>,<BR>        Info.Ejercicio,Info.Periodo,Info.Quincena,Mavi.NumCanalVenta) > 0<BR>    Entonces<BR>        Precaucion(<T>El Periodo ya se fue cerrado anteriormente...<T>)<BR>    Sino<BR>      Si SQL(<T>SELECT COUNT(Enviado) FROM dbo.MaviEnvDispElectHist WHERE IDCanalVenta=:nCan AND Enviado=0<T>,Mavi.NumCanalVenta) = 0<B<CONTINUA>
Expresion003=<CONTINUA>R>      Entonces<BR>          EjecutarSQLAnimado(<T>EXEC dbo.SP_MaviLayoutInstituciones :tCanal, :tUsr, :tProc<T>,Mavi.NumCanalVenta,Usuario,1)<BR>          Asigna(Info.Numero,SQL(<T>Select Count(Mov) From dbo.MaviEnvDispElectHist Where Ejercicio=:nEje And Periodo=:nPer And Quincena=:nQui And IDCanalVenta=:nCan And Enviado=1<T>,<BR>          Info.Ejercicio,Info.Periodo,Info.Quincena,Mavi.NumCanalVenta))<BR>          Informacion(<T>Proceso Terminado.<BR><T>+Si(Info.Numero>0,<T>Se realizó el cierre del Periodo.<T>,<T><T>)+<T><BR>Se Generaron <T>&Info.Numero& <T> Movimientos.<T>)<BR>      Sino<BR>          EjecutarSQLAnimado(<T>EXEC dbo.SP_MaviLayoutInstituciones :tCanal, :tUsr, :tProc<T>,Mavi.NumCanalVenta,Usuario,1)<BR>          Asigna(Info.Numero,SQL(<T>Select Count(Mov) From dbo.MaviEnvDi<CONTINUA>
Expresion004=<CONTINUA>spElectHist Where Ejercicio=:nEje And Periodo=:nPer And Quincena=:nQui And IDCanalVenta=:nCan And Enviado=1<T>,<BR>          Info.Ejercicio,Info.Periodo,Info.Quincena,Mavi.NumCanalVenta))<BR>          Informacion(<T>Proceso Terminado.<BR><T>+Si(Info.Numero>0,<T>Se realizó el cierre del Periodo.<T>,<T><T>)+<T><BR>Se Generaron <T>&Info.Numero& <T> Movimientos.<T>)<BR>      Fin<BR>    Fin<BR>Fin
EjecucionCondicion=ConDatos(Mavi.NumCanalVenta) y ConDatos(Mavi.CierrePeriodo) y<BR>(No Vacio(SQL(<T>Select ID From dbo.VentasCanalMavi Where ID=:nNum And Categoria = :tCat<T>,<BR>Mavi.NumCanalVenta,Info.CategoriaCanal)))
EjecucionMensaje=Si Vacio(Mavi.NumCanalVenta)<BR>    Entonces <T>Es Requerido el Canal de Venta<T><BR>Sino Si Vacio(Mavi.CierrePeriodo)<BR>        Entonces <T>En necesario especificar si se realizará el cierre.<T><BR>     Sino <T>El Canal de Venta no es de Instituciones<T><BR>     Fin<BR>Fin
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
[Generar]
Estilo=Ficha
Clave=Generar
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=$FFFFFFFF
CampoColorFondo=Blanco
ListaEnCaptura=Info.Ejercicio<BR>Info.Periodo<BR>Info.Quincena<BR>Mavi.NumCanalVenta<BR>Mavi.CierrePeriodo
CarpetaVisible=S
[Generar.Mavi.NumCanalVenta]
Carpeta=Generar
Clave=Mavi.NumCanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Generar.Info.Ejercicio]
Carpeta=Generar
Clave=Info.Ejercicio
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=$FFFFFFFF
Efectos=[Negritas]
[Generar.Info.Periodo]
Carpeta=Generar
Clave=Info.Periodo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Generar.Info.Quincena]
Carpeta=Generar
Clave=Info.Quincena
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Cierre.AsignaVar]
Nombre=AsignaVar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cierre.Expresa]
Nombre=Expresa
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si SQL(<T>SELECT COUNT(Enviado) FROM dbo.MaviEnvDispElectHist WHERE IDCanalVenta=:nCan AND Enviado=0<T>,Mavi.NumCanalVenta) = 0<BR>Entonces<BR>    EjecutarSQLAnimado(<T>EXEC dbo.SP_MaviLayoutInstituciones :tCanal, :tUsr, :tProc<T>,Mavi.NumCanalVenta,Usuario,1)<BR>    Informacion(<T>Proceso Terminado.<BR>Se realizó el cierre del Periodo.<T>)<BR>Sino<BR>    Si Precaucion(<T>Ya se generaron movimientos de la Institución.<BR>¿Desea volver a generar los movimientos y hacer el cierre?. <T>,botonsi,botonno)=6<BR>    Entonces<BR>        EjecutarSQLAnimado(<T>EXEC dbo.SP_MaviLayoutInstituciones :tCanal, :tUsr, :tProc<T>,Mavi.NumCanalVenta,Usuario,1)<BR>    Sino<BR>        Informacion(<T>Se canceló la generación de movimientos.<T>)<BR>    Fin<BR>Fin
EjecucionCondicion=ConDatos(Mavi.NumCanalVenta)
EjecucionMensaje=<T>Es Requerido el Canal de Venta<T>
[Generar.Mavi.CierrePeriodo]
Carpeta=Generar
Clave=Mavi.CierrePeriodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]


