SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spAspelPresentaDatos]
AS
BEGIN
	DECLARE
		@SrvOrigenSAE VARCHAR(50)
	   ,@BDOrigenSAE VARCHAR(30)
	   ,@OrigenSAE VARCHAR(100)
	   ,@RutaSAE VARCHAR(250)
	   ,@EmpresaSAE INT
	   ,@ImportaCOI BIT
	   ,@SrvOrigenCOI VARCHAR(50)
	   ,@BDOrigenCOI VARCHAR(30)
	   ,@OrigenCOI VARCHAR(100)
	   ,@RutaCOI VARCHAR(250)
	   ,@EmpresaCOI INT
	   ,@BaseDatosPaso VARCHAR(30)
	   ,@SrvIntelisis VARCHAR(50)
	   ,@BaseDatosIntelisis VARCHAR(30)
	   ,@sql NVARCHAR(1000)
	   ,@Cuenta INT
	SET ANSI_WARNINGS ON
	EXEC spAspelBorraPropReg
	SELECT @SrvOrigenSAE = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Servidor SAE'
	SELECT @Cuenta = COUNT(*)
	FROM master.dbo.sysservers
	WHERE srvname = @SrvOrigenSAE

	IF @Cuenta = 0
		EXEC sp_addlinkedserver @SrvOrigenSAE

	SELECT @BDOrigenSAE = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Base De Datos SAE'
	SELECT @OrigenSAE = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Tipo Base De Datos SAE'
	SELECT @RutaSAE = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Ruta SAE'
	SELECT @EmpresaSAE = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Empresa SAE'
	SELECT @ImportaCOI =
	 CASE
		 WHEN Valor = 'Si' THEN 1
		 ELSE 0
	 END
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Importar COI'
	SELECT @SrvOrigenCOI = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Servidor COI'
	SELECT @BDOrigenCOI = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Base De Datos COI'
	SELECT @OrigenCOI = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Tipo Base De Datos COI'
	SELECT @RutaCOI = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Ruta COI'
	SELECT @EmpresaCOI = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Empresa COI'
	SELECT @SrvIntelisis = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Servidor Intelisis'
	SELECT @BaseDatosIntelisis = Valor
	FROM AspelCfgOpcion
	WHERE Descripcion = 'Base De Datos Intelisis'
	UPDATE Aspel_paso
	SET IntegracionVisor = 0
	DELETE FROM AspelLog
	EXEC spAspelImportarTablas @SrvOrigenSAE
							  ,@BDOrigenSAE
							  ,@OrigenSAE
							  ,'SAE'
							  ,@RutaSAE
							  ,@BaseDatosPaso OUTPUT
							  ,@EmpresaSAE

	IF @ImportaCOI = 1
		EXEC spAspelImportarTablas @SrvOrigenCOI
								  ,@BDOrigenCOI
								  ,@OrigenCOI
								  ,'COI'
								  ,@RutaCOI
								  ,@BaseDatosPaso
								  ,@EmpresaCOI

	EXEC spAspelImportarTablasCargaPropReg @SrvIntelisis
										  ,@SrvIntelisis
										  ,@BaseDatosPaso
										  ,@BaseDatosIntelisis
										  ,@ImportaCOI
	UPDATE Aspel_paso
	SET IntegracionVisor = 1
	SET ANSI_WARNINGS OFF
END
GO