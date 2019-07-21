[Forma]
Clave=ProspectoAClienteMAVI
Nombre=Cambias Prospecto a Cliente
Icono=36
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Cambiar<BR>Cancelar
PosicionInicialIzquierda=426
PosicionInicialArriba=284
PosicionInicialAlturaCliente=85
PosicionInicialAncho=284
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.ProspectoACambiar, Nulo)
ExpresionesAlCerrar=Asigna(Info.ProspectoACambiar, Nulo)
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
ListaEnCaptura=Info.ProspectoACambiar
CarpetaVisible=S
[Acciones.Cambiar]
Nombre=Cambiar
Boton=0
NombreDesplegar=Cambiar
EnBarraAcciones=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asiganar<BR>CambiarCte<BR>Cerrar
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Info.ProspectoACambiar]
Carpeta=(Variables)
Clave=Info.ProspectoACambiar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cambiar.CambiarCte]
Nombre=CambiarCte
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=SI (Contiene(Usuario,<T>VENTP<T>))<BR>Entonces<BR><BR>      SI (SQL(<T>SELECT DISTINCT CASE WHEN  Count(CteEnviarA.id) >0 THEN 1 ELSE 0 END resultado FROM Cte INNER JOIN CteEnviarA ON Cte.Cliente = CteEnviarA.Cliente<BR>            WHERE CteEnviarA.id IN (1,2,5,6) AND Cte.Cliente = (:Tcte)<T>, Info.ProspectoACambiar)>0)<BR>      ENTONCES<BR>           Si (SQL(<T>SELECT * FROM  DBO.FN_DM0296ValidaCambioACtaPorEstado(:Tcte)<T>, Info.ProspectoACambiar)= 1)<BR>           Entonces<BR>             Asigna(Temp.Reg,SQL(<T>SET ANSI_NULLS ON SET ANSI_WARNINGS ON Exec spCambiarProspectoACteMAVI :tProsp, :nDig, :tus<T>, Info.ProspectoACambiar, General.CteExpressDigitos, Usuario.Usuario))<BR>             INFORMACION(Temp.Reg[1])<BR>             SI<BR>                (Temp.Reg[2] = 1) y (SQL(<T>SELECT a<CONTINUA>
Expresion002=<CONTINUA>cceso FROM usuario WHERE usuario = :tUs<T>,Usuario.Usuario) en (<T>CREDI_GERB<T>,<T>CREDI_ANAA<T>,<T>CREDI_USRA<T>,<T>CREDI_GERA<T>))<BR>             ENTONCES<BR>                asigna(Mavi.DM0192CERRAR2,falso)<BR>                ASIGNA(Mavi.DM0192ProspACliente,Temp.Reg[3])<BR>                FORMA(<T>DM0192CapturaLinCreditoFrm<T>)<BR>             FIN<BR>          SiNo<BR>              Error(<T>No se Puede Cambiar el Prospecto a Cliente<T>)<BR><BR>         Fin<BR>      SINO<BR><BR>              Error(<T>Usuario sin permiso en este canal para asignar cuenta.<T>)<BR>         AbortarOperacion<BR>      Fin<BR><BR>SiNo<BR><BR>     Si (SQL(<T>SELECT * FROM  DBO.FN_DM0296ValidaCambioACtaPorEstado(:Tcte)<T>, Info.ProspectoACambiar)= 1)<BR>     Entonces<BR>         Asigna(Temp.Reg,SQL(<T>SET ANSI_N<CONTINUA>
Expresion003=<CONTINUA>ULLS ON SET ANSI_WARNINGS ON Exec spCambiarProspectoACteMAVI :tProsp, :nDig, :tus<T>, Info.ProspectoACambiar, General.CteExpressDigitos, Usuario.Usuario))<BR>         INFORMACION(Temp.Reg[1])<BR>         SI<BR>            (Temp.Reg[2] = 1) y (SQL(<T>SELECT acceso FROM usuario WHERE usuario = :tUs<T>,Usuario.Usuario) en (<T>CREDI_GERB<T>,<T>CREDI_ANAA<T>,<T>CREDI_USRA<T>,<T>CREDI_GERA<T>))<BR>         ENTONCES<BR>            asigna(Mavi.DM0192CERRAR2,falso)<BR>            ASIGNA(Mavi.DM0192ProspACliente,Temp.Reg[3])<BR>            FORMA(<T>DM0192CapturaLinCreditoFrm<T>)<BR>         FIN<BR>     SiNo<BR>      Error(<T>No se Puede Cambiar el Prospecto a Cliente<T>)<BR>    <BR>     Fin<BR>Fin
EjecucionCondicion=SQL(<T>SELECT Resul = COUNT(*) FROM (<BR>         SELECT Estatus FROM dbo.MaviSupervision MS<BR>        INNER JOIN MaviRutaD  MR ON MS.ID = MR.SupervisionID<BR>         WHERE MR.Estado <> <T>+ Comillas(<T>EN ESPERA<T>) +<T> AND Cliente =:TEst)i<BR>         WHERE i.Estatus =:TPen<T>, Info.ProspectoACambiar,<T>Pendiente<T>)=0
EjecucionMensaje=<T>No se puede convertir a cliente hasta concluir las superviones Pendientes<T>
[Acciones.Cambiar.Asiganar]
Nombre=Asiganar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cambiar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

