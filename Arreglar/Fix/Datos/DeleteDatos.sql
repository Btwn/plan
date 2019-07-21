Delete AspelCfg
Delete AspelCfgCatalogo
Delete AspelCfgModuloMayor
Delete AspelCfgMovimiento
Delete AspelCfgOpcion
Delete AutoLocalidad
Delete AutoServicio
Delete CB Where TipoCuenta = 'Accion'
Delete CfgNominaConcepto
Delete Concepto Where Modulo In ('NOM','ASIS','RH') Or Concepto In ('Costo por Staff','Costo por Recurso Humano')
Delete ContratoTipo Where Modulo = 'NOM'
Delete CteTipo Where Tipo = 'Oportunidad'
Delete Departamento
Delete EmpresaCfgMovImp Where Empresa = 'DEMO'
Delete EmpresaConcepto Where Modulo In ('NOM','ASIS','RH')
Delete EmpresaConceptoValidar Where Modulo In ('NOM','ASIS','RH')
Delete Fabricante Where Fabricante ='VERIFONE'
Delete FormaPago Where FormaPago = 'Tarjetas'
Delete From InfoHumanSide
Delete Jornada
Delete JornadaD
Delete MovSituacion Where Mov = 'Prop. Oportunidad'
Delete MovSituacionL Where Mov = 'Prop. Oportunidad'
Delete MovTipoContAuto
Delete MovTipoIncidencias
Delete Nacionalidad
Delete NivelAcademico
Delete NominaConcepto
Delete NominaValidarFecha
Delete NomXCxp
Delete NomXDin
Delete NomXFormula
Delete NomXGasto
Delete NomXPersonal
Delete PedimentoClave
Delete PeriodoTipo
Delete PersonalGrupo
Delete PersonalProp
Delete PersonalPropCat
Delete PersonalPropPais
Delete PersonalPropValor
Delete PersonalTipo
Delete PersonalValuacion
Delete Prov Where Categoria Is null And Pais IS Null
Delete ProvCat Where Categoria = 'NACIONAL'
Delete Puesto
Delete ServicioTipoOperacion
Delete ServicioTipoOrden
Delete Sindicato
Delete TablaImpuesto
Delete TablaImpuestoD
Delete TablaImpuestoHist
Delete TablaNum Where TablaNum = 'Vacaciones'
Delete TablaNumD Where TablaNum = 'Vacaciones'
Delete TablaST Where TablaSt In ('AMC7.1','CFDFLEX_UNIDADES','EDIFACT_D01B_CFDVenta','FEMSA','Orden Columnas','SORIANA')
Delete TablaSTD Where TablaSt In ('AMC7.1','CFDFLEX_UNIDADES','EDIFACT_D01B_CFDVenta','FEMSA','Orden Columnas','SORIANA')
Delete TblAspelCfg
Delete UnidadConversion
Delete ZonaEconomica
Delete ZonaEconomicaHist
Delete Cubo_ArtID
Delete CuboCteId
Delete CuboPERId

IF NOT EXISTS (Select TablaNum From TablaNum Where TablaNum = 'TOPE BF')
	Insert TablaNum Values ('TOPE BF')

IF NOT EXISTS (Select TablaNum From TablaNum Where TablaNum = 'DIAS PCDN')
	Insert TablaNum Values ('DIAS PCDN')

IF NOT EXISTS (Select TablaNum From TablaNumD Where TablaNum = 'TOPE BF')
	Insert TablaNumD Values ('TOPE BF',100,Null)

IF NOT EXISTS (Select TablaNum From TablaNumD Where TablaNum = 'DIAS PCDN')
	Insert TablaNumD Values ('DIAS PCDN',30,Null)

IF NOT EXISTS (Select Usuario From UsuarioD Where Usuario = 'DIREC00008')
	Insert UsuarioD Values ('DIREC00008','MAVI')

IF NOT EXISTS (Select Usuario From UsuarioD Where Usuario = 'DIREC00010')
	Insert UsuarioD Values ('DIREC00010','MAVI')

IF NOT EXISTS (Select Usuario From UsuarioSucursal Where Usuario = 'DIREC00010')
	Insert UsuarioSucursal Values ('DIREC00010',99,'MAVI')