[Forma]
Clave=RM0164ConveniosInstFrm
Nombre=RM0164 Convenios Instituciones
Icono=94
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=500
PosicionInicialArriba=439
PosicionInicialAlturaCliente=119
PosicionInicialAncho=280
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Ejercicio,Año(Ahora))<BR>Asigna(Info.NominaMavi,Nulo))
ListaAcciones=Pre<BR>Cerrar
AccionesTamanoBoton=15x5
AccionesCentro=S
BarraHerramientas=S
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
ListaEnCaptura=Info.Ejercicio<BR>Info.NominaMavi
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Arriba
PermiteEditar=S
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
EspacioPrevio=S
[(Variables).Info.NominaMavi]
Carpeta=(Variables)
Clave=Info.NominaMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.EnviarNominas.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.EnviarNominas.Ejecutar]
Nombre=Ejecutar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si<BR>        Vacio(SQL(<T>SELECT Top 1 InNomina FROM MaviPADJefesInst WHERE  Periodo=:nquincena AND Ejercicio=:nejercicio AND InNomina=:nestado<T>, Info.NominaMavi, Info.Ejercicio, 1))<BR>    Entonces<BR>        EjecutarSQLAnimado(<T>Sp_MaviEvaluacionConveniosInst2 :nejercicio, :nnomina<T>, Info.Ejercicio, Info.NominaMavi )<BR>    Sino<BR>        Informacion(<T>La Nómina <T> +  Info.NominaMavi + <T> Ya Fue Generada Anteriormete, no se puede Enviar.<T>)<BR>    Fin
EjecucionCondicion=(ConDatos(Info.Ejercicio)) y (ConDatos(Info.NominaMAVI)) y (Info.NominaMAVI>0) y (Info.NominaMAVI < 25)
EjecucionMensaje=<T>Todos los datos son requeridos<T>
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Pre.As]
Nombre=As
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
[Acciones.Pre.asi]
Nombre=asi
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Pre]
Nombre=Pre
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
ListaAccionesMultiples=As<BR>asi
Activo=S
Visible=S
EnBarraHerramientas=S
GuardarConfirmar=S
GuardarAntes=S


