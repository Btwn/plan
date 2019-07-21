[Forma]
Clave=RM1161ValidaReporteSFRM
Nombre=Valida Reporte
Icono=357
Modulos=(Todos)
ListaCarpetas=validacion
CarpetaPrincipal=validacion
PosicionInicialIzquierda=450
PosicionInicialArriba=340
PosicionInicialAlturaCliente=165
PosicionInicialAncho=343
AccionesTamanoBoton=15x5
ListaAcciones=Validar<BR>Cancelar
BarraAcciones=S
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1161Usuario,<T><T>)<BR>Asigna(Mavi.RM1161Contra,<T><T>)<BR>Asigna(Mavi.RM1161ReporteServicio,NULO)
[validacion]
Estilo=Ficha
Clave=validacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1161ReporteServicio<BR>Mavi.RM1161Usuario<BR>Mavi.RM1161Contra
CarpetaVisible=S
FichaEspacioEntreLineas=7
FichaEspacioNombres=102
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
PermiteEditar=S
[validacion.Mavi.RM1161Usuario]
Carpeta=validacion
Clave=Mavi.RM1161Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[validacion.Mavi.RM1161Contra]
Carpeta=validacion
Clave=Mavi.RM1161Contra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Validar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Validar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Si//1<BR>    Vacio(Mavi.RM1161Usuario)<BR>Entonces//1<BR>    Informacion(<T>El campo usuario esta vacio<T>)<BR>    AbortarOperacion<BR>Sino //1<BR>    Si//2<BR>        Vacio(Mavi.RM1161Contra)<BR>    Entonces//2<BR>        Informacion(<T>El campo contraseña esta vacio<T>)<BR>        AbortarOperacion<BR>    Sino//2<BR>        Si//3<BR>            SQL(<T>SELECT Contrasena FROM Usuario WHERE Usuario=<T>+Comillas(Mavi.RM1161Usuario)) = MD5(Mavi.RM1161Contra,<T>p<T>)<BR>        Entonces//3<BR>             Si//4<BR>                SQL(<T>SELECT U.Contrasena FROM Usuario U INNER JOIN TablaStD D ON U.ACCESO=D.NOMBRE WHERE D.TablaSt =<T>+Comillas(<T>USUARIOVALIDAREPORTES<T>)<BR>               +<T>And U.Estatus=<T>+comillas(<T>Alta<T>) +<T>AND U.Usuario=<T>+Comillas(Mavi.RM1161Usuario)) = MD5(Mavi.RM1161Contra,<T>p<T>)<BR>            Entonces//4<BR>                   EjecutarSQL(<T>SP_RM1161AfectacionRepServicio :nIDVenta,:nIDSoporte,:nOPC<T>, Mavi.RM1161IDVenta,Mavi.RM1161ReporteServicio,1)<BR>                    Asigna(Mavi.RM1161Bandera,<T>FALSO<T>)<BR>                    Informacion(<T>Validación correcta, puede continuar...<T>)<BR>                    Verdadero<BR><BR>            Sino//4<BR>                Error(<T>El usuario no tiene permisos para concluir el movimiento.<T>)<BR>                AbortarOperacion<BR>            Fin//4<BR>        Sino//3<BR>             Error(<T>Usuario ó Contraseña Incorrectos<T>)<BR>             AbortarOperacion<BR>        Fin//3<BR>    Fin//2<BR>Fin//1
EjecucionCondicion=Si<BR>    Vacio(Mavi.RM1161ReporteServicio)<BR>Entonces<BR>    Informacion(<T>El campo Reporte Servicio esta vacio<T>)<BR>    AbortarOperacion<BR>Fin<BR> <BR>Si<BR>        SQL(<T>SELECT  Count(S.ID) FROM VENTA V INNER JOIN VENTAD VD ON   V.ID=VD.ID<BR>        INNER JOIN  Soporte S ON VD.Articulo=S.Articulo<BR>        WHERE S.ID=<T>+Comillas(Mavi.RM1161ReporteServicio) +<T>  AND v.Sucursal=<T>+Comillas(Mavi.RM1161Sucursal)   +<T><BR>        and S.Estatus=<T>+Comillas(<T>CONCLUIDO<T>))=0<BR>Entonces<BR>        Informacion(<T>Ingrese un valor valido de Reporte Servicio.<T>)<BR>        AbortarOperacion<BR>Fin
[Acciones.Validar]
Nombre=Validar
Boton=29
NombreDesplegar=Validacion
Multiple=S
TipoAccion=Expresion
ListaAccionesMultiples=Asigna<BR>Expresion<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraAcciones=S
[Acciones.Validar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[validacion.Mavi.RM1161ReporteServicio]
Carpeta=validacion
Clave=Mavi.RM1161ReporteServicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=INFORMACION (Mavi.RM1161ReporteServicio)
[Acciones.Expresion.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.prueba.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.prueba.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Informacion(Mavi.RM1161ReporteServicio)<BR><BR>Si<BR>    SQL(<T>Select Count(id) FROM Soporte WHERE ID= :tSID<T>,Mavi.RM1161ReporteServicio) >0<BR>Entonces<BR>    Informacion(<T>Todo bien<T>)<BR>Sino<BR>    Informacion(<T>No esta bien<T>)<BR>Fin
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cancelar
Multiple=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ListaAccionesMultiples=Expresion<BR>Cerrar
[Acciones.Cancelar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Informacion(<T>Esta seguro que desea cancelar?<T>,BotonSI,BotonNO)=  BotonSI, Asigna(Mavi.RM1161Bandera,<T>FALSO<T>), AbortarOperacion
[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


