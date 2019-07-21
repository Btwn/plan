
[Forma]
Clave=TarjetaSerieMovMAVIAplicar
Icono=67
Modulos=(Todos)
Nombre=Seleccione Monedero
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=379
PosicionInicialArriba=447
PosicionInicialAlturaCliente=91
PosicionInicialAncho=522
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
AccionesDivision=S
VentanaSinIconosMarco=S
IniciarAgregando=S
[Lista]
Estilo=Ficha
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=TarjetaSerieMovMAVI
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
ListaEnCaptura=TarjetaSerieMovMavi.Serie<BR>Saldo
CarpetaVisible=S

[Lista.TarjetaSerieMovMavi.Serie]
Carpeta=Lista
Clave=TarjetaSerieMovMavi.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.Saldo]
Carpeta=Lista
Clave=Saldo
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Plata

Tamano=20
Efectos=[Negritas]

[Lista.Columnas]
0=430

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
Activo=S
Visible=S

ListaAccionesMultiples=Aceptar<BR>Cerrar
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=SI (SQL(<T>SELECT COUNT(1)<BR>        FROM dbo.Venta V WITH(NOLOCK)<BR>        JOIN dbo.VentasCanalMAVI VC WITH(NOLOCK) ON VC.ID=V.EnviarA<BR>        JOIN dbo.TablaRangoStD MV WITH(NOLOCK) ON Mv.TablaRangoSt=<T>+Comillas(<T>MODALIDAD MONEDERO VIRTUAL<T>)+<T><BR>            AND (CASE ISNULL(MV.NumeroD,0) WHEN 0 THEN V.UEN ELSE MV.NumeroD END) = V.UEN<BR>            AND (CASE WHEN ISNULL(MV.NumeroA,0) < 1 THEN V.Sucursal ELSE MV.NumeroA END) = V.Sucursal<BR>            AND (CASE ISNULL(MV.Nombre,<T>+Comillas(<T><T>)+<T>) WHEN <T>+Comillas(<T><T>)+<T> THEN VC.Categoria ELSE MV.Nombre END) = VC.Categoria<BR>            AND V.ID=:nId<T>,Info.ID)=0)<BR>ENTONCES<BR>    SI (SQL(<T>SELECT N=COUNT(ID) FROM DM0173UsrValidoMonedero WHERE ID=:tN<T>,Info.ID)>0)<BR>    ENTONCES<BR>        SI (SQL(<T>SELE<CONTINUA>
EjecucionCondicion002=<CONTINUA>CT dbo.fnMonederoDV(:tSerie,0)<T>,TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie))=<T>1<T> y<BR>           (SQL(<T>SELECT COUNT(m.UEN) FROM MonederoMAVID md INNER JOIN MonederoMAVI m on m.ID = md.ID and m.Mov=:tMov AND m.UEN=:nUen AND Serie=:tSerie<T>,<T>Activacion Tarjeta<T>,Usuario.UEN,Izquierda(TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie,8)))>0<BR>        ENTONCES<BR>            Asigna(Mavi.NSerie,Izquierda(TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie,8))<BR>            Asigna(TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie,Izquierda(TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie,8))<BR>            GuardarCambios<BR>            Verdadero<BR>        SINO<BR>            Asigna(TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie,<T><T>)<BR>            Falso<BR>        FIN<BR>    SINO<BR>       SI<CONTINUA>
EjecucionCondicion003=<CONTINUA> SQL(<T>Select count(*) From Venta With(NoLock) Where EnviarA=76 and ID=:Nid<T>,Info.ID) = 0<BR>        entonces<BR>         Forma(<T>DM0173ValidaUsrMone<T>)<BR>         Falso<BR>        sino<BR>         falso<BR>       Fin<BR>    FIN<BR>SINO<BR>    GuardarCambios<BR>    Verdadero<BR>FIN
EjecucionMensaje=SI (SQL(<T>SELECT N=COUNT(ID) FROM DM0173UsrValidoMonedero WHERE ID=:tN<T>,Info.ID)>0)<BR>ENTONCES<BR>    SI (SQL(<T>SELECT COUNT(m.UEN) FROM MonederoMAVID md INNER JOIN MonederoMAVI m on m.ID = md.ID and m.Mov=:tMov AND m.UEN=:nUen AND Serie=:tSerie<T>,<T>Activacion Tarjeta<T>,Usuario.UEN,Izquierda(TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie,8)))=<T>0<T><BR>    ENTONCES<BR>        <T>Monedero no Aplica en esta Unidad de Negocio<T><BR>    SINO<BR>        <T>Monedero Incorrecto<T><BR>    FIN<BR>SINO<BR>    <T>Validar Monedero...<T><BR>FIN
AntesExpresiones=Asigna(Mavi.NSerie,Izquierda(TarjetaSerieMovMAVI:TarjetaSerieMovMavi.Serie,8))
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Visible=S
Multiple=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar

ActivoCondicion=Si<BR>  (SQL(<T>SELECT COUNT(1)<BR>  FROM dbo.Venta V WITH(NOLOCK)<BR>  JOIN dbo.VentasCanalMAVI VC WITH(NOLOCK) ON VC.ID=V.EnviarA<BR>  JOIN dbo.TablaRangoStD MV WITH(NOLOCK) ON Mv.TablaRangoSt=<T>+Comillas(<T>MODALIDAD MONEDERO VIRTUAL<T>)+<T><BR>      AND (CASE ISNULL(MV.NumeroD,0) WHEN 0 THEN V.UEN ELSE MV.NumeroD END) = V.UEN<BR>      AND (CASE ISNULL(MV.NumeroA,0) WHEN 0 THEN V.Sucursal ELSE MV.NumeroA END) = V.Sucursal<BR>      AND (CASE ISNULL(MV.Nombre,<T>+Comillas(<T><T>)+<T>) WHEN <T>+Comillas(<T><T>)+<T> THEN VC.Categoria ELSE MV.Nombre END) = VC.Categoria<BR>      AND V.ID=:nId<T>,Info.ID)=0)<BR>Entonces<BR>  Si ConDatos(Info.ID)<BR>  Entonces<BR>    Si (SQL(<T>SELECT Mov FROM Venta WITH(NOLOCK) WHERE ID=:nId<T>,Info.ID)=<T>Solicitud Credito<T>)<BR>    Entonces<BR>      Asigna(Info.Dato,SQL(<T>SELECT EnviarA FROM Venta WITH(NOLOCK) WHERE ID=:nId<T>,Info.ID))<BR>      Caso  Info.Dato<BR>        Es 76 Entonces Falso<BR>        Es 3 Entonces Falso<BR>      Sino<BR>        Verdadero<BR>      Fin<BR>    Sino<BR>      Verdadero<BR>    Fin<BR>  Sino<BR>    Verdadero<BR>  Fin<BR>Sino<BR>  Falso      <BR>Fin
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC spGenerarMovMonederoMAVI :nid<T>, Info.ID)

[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

