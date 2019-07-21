SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spCteExpressGuardaCto]
 @Cliente VARCHAR(30)
,@Categoria VARCHAR(30) = NULL
,@Regimen VARCHAR(30) = NULL
,@Tipo VARCHAR(50) = NULL
,@Apaterno VARCHAR(100) = NULL
,@Amaterno VARCHAR(100) = NULL
,@Nombres VARCHAR(100) = NULL
,@FechaNac VARCHAR(30)
,@telefono VARCHAR(20)
,@lada VARCHAR(7)
,@Sexo VARCHAR(30)
,@Usuario VARCHAR(20)
,@Parentesco VARCHAR(30)
,@ViveEncalidad VARCHAR(30)
,@ViveConH VARCHAR(30)
,@ViveEnCalidadH VARCHAR(30) = NULL
,@EstadoCivil VARCHAR(30) = NULL
,@CanalV INT = NULL
,@Accion VARCHAR(20) = NULL
,@ID INT = NULL
,@EsCasa BIT = NULL
,@NumCuenta VARCHAR(20) = NULL
,@rfc VARCHAR(30) = NULL
AS
BEGIN
	DECLARE
		@NewID INT
	   ,@OK INT = 0

	IF @Accion = 'Nvo'
	BEGIN

		IF @Tipo = 'COMERCIAL'
			OR @Tipo = 'BANCARIA'
			SET @FechaNac = NULL

		INSERT INTO CteCto (Cliente, Nombre, ApellidoPaterno, ApellidoMaterno, Atencion, Tratamiento, Cargo
		, Grupo, FechaNacimiento, Telefonos, Extencion, eMail, Fax, PedirTono, EnviarA, Tipo
		, Sexo, Usuario, CFD_Enviar, MaviEstatus, TieneMovimientos, CteEnviarAExpress, ViveConMAVI, ViveEnCalidadDeMAVI, EstadocivilMavi, LadaMavi, EsCasa, NumCuenta, RFC)
			VALUES (@Cliente, @Nombres, @Apaterno, @Amaterno, @Parentesco, @ViveEncalidad, NULL, NULL, @FechaNac, @telefono, NULL, NULL, NULL, NULL, @CanalV, @Tipo, @Sexo, @Usuario, 0, NULL, NULL, @CanalV, @ViveConH, @ViveEnCalidadH, @EstadoCivil, @lada, @EsCasa, @NumCuenta, @rfc)
		SELECT @NewID = SCOPE_IDENTITY()
		EXEC SpActualizaTablaContMavi @Tipo
									 ,@NewID
									 ,@Nombres
									 ,@Apaterno
									 ,@Amaterno
									 ,@FechaNac
									 ,@CanalV
									 ,@Sexo
									 ,@Parentesco
									 ,@ViveEncalidad
									 ,@EstadoCivil
									 ,@Lada
									 ,@telefono
		UPDATE CteCto
		SET IDPadreMavi = @NewID
		WHERE ID = @NewID
		SELECT @NewID
	END

	IF @Accion = 'Actualiza'
	BEGIN

		IF @Tipo = 'COMERCIAL'
			OR @Tipo = 'BANCARIA'
			SET @FechaNac = NULL

		UPDATE CteCto
		SET Nombre = @Nombres
		   ,ApellidoPaterno = @Apaterno
		   ,ApellidoMaterno = @Amaterno
		   ,Atencion = @Parentesco
		   ,Tratamiento = @ViveEncalidad
		   ,Cargo = NULL
		   ,Grupo = NULL
		   ,FechaNacimiento = @FechaNac
		   ,Telefonos = @telefono
		   ,Extencion = NULL
		   ,eMail = NULL
		   ,Fax = NULL
		   ,PedirTono = NULL
		   ,EnviarA = @CanalV
		   ,Tipo = @Tipo
		   ,Sexo = @Sexo
		   ,Usuario = @Usuario
		   ,CFD_Enviar = 0
		   ,TieneMovimientos = NULL
		   ,CteEnviarAExpress = @CanalV
		   ,ViveConMAVI = @ViveConH
		   ,ViveEnCalidadDeMAVI = @ViveEnCalidadH
		   ,EstadocivilMavi = @EstadoCivil
		   ,LadaMavi = @lada
		   ,EsCasa = @EsCasa
		   ,NumCuenta = @NumCuenta
		   ,RFC = @rfc
		WHERE Cliente = @Cliente
		AND ID = @ID
		SET @OK = @ID
		SELECT @OK
	END

END
GO