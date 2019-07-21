SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMovCopiarAnexos]
 @Sucursal INT
,@OModulo CHAR(5)
,@OID INT
,@DModulo CHAR(5)
,@DID INT
,@CopiarBitacora BIT = 0
AS
BEGIN
	DECLARE
		@MovTipo VARCHAR(20)
	   ,@SubMovTipo VARCHAR(20)

	IF @OModulo IS NOT NULL
		AND @OID IS NOT NULL
		AND @DModulo IS NOT NULL
		AND @DID IS NOT NULL
	BEGIN
		INSERT AnexoMov (Sucursal, Rama, ID, Nombre, Direccion, Icono, Tipo, Orden, Comentario)
			SELECT @Sucursal
				  ,@DModulo
				  ,@DID
				  ,Nombre
				  ,Direccion
				  ,Icono
				  ,Tipo
				  ,Orden
				  ,Comentario
			FROM AnexoMov
			WHERE Rama = @OModulo
			AND ID = @OID
			AND Nombre <> 'Comprobante Fiscal Digital'

		IF @OModulo IN ('VTAS', 'INV', 'COMS', 'PROD')
			AND @DModulo IN ('VTAS', 'INV', 'COMS', 'PROD')
			INSERT AnexoMovD (Sucursal, Rama, ID, Cuenta, Nombre, Direccion, Icono, Tipo, Orden, Comentario)
				SELECT @Sucursal
					  ,@DModulo
					  ,@DID
					  ,Cuenta
					  ,Nombre
					  ,Direccion
					  ,Icono
					  ,Tipo
					  ,Orden
					  ,Comentario
				FROM AnexoMovD
				WHERE Rama = @OModulo
				AND ID = @OID

		IF @CopiarBitacora = 1
			INSERT MovBitacora (Sucursal, Modulo, ID, Fecha, Evento, Usuario, Agente, Clave)
				SELECT @Sucursal
					  ,@DModulo
					  ,@DID
					  ,Fecha
					  ,Evento
					  ,Usuario
						,Agente
						,Clave
				FROM MovBitacora
				WHERE Modulo = @OModulo
				AND ID = @OID

		IF @OModulo = 'VTAS'
			AND @DModulo = 'VTAS'
		BEGIN
			SELECT @MovTipo = mt.Clave
				  ,@SubMovTipo = mt.SubClave
			FROM Venta v
			JOIN MovTipo mt
				ON mt.Mov = v.Mov
				AND mt.Modulo = @OModulo
				AND v.ID = @OID
			INSERT VentaDAgente (ID, Renglon, RenglonSub, Agente, Fecha, HoraD, HoraA, Minutos, Actividad, Estado, Comentarios, CantidadEstandar, CostoActividad, FechaConclusion)
				SELECT @DID
					  ,Renglon
					  ,RenglonSub
					  ,Agente
					  ,Fecha
					  ,HoraD
					  ,HoraA
					  ,Minutos
					  ,Actividad
					  ,Estado
					  ,Comentarios
					  ,CantidadEstandar
					  ,CostoActividad
					  ,FechaConclusion
				FROM VentaDAgente
				WHERE ID = @OID
			INSERT VentaEntrega (ID, Sucursal, Embarque, EmbarqueFecha, EmbarqueReferencia, Recibo, ReciboFecha, ReciboReferencia,
			Direccion, DireccionNumero, DireccionNumeroInt, CodigoPostal, Delegacion, Colonia, Poblacion, Estado, Telefono, TelefonoMovil)
				SELECT @DID
					  ,@Sucursal
					  ,Embarque
					  ,EmbarqueFecha
					  ,EmbarqueReferencia
					  ,Recibo
					  ,ReciboFecha
					  ,ReciboReferencia
					  ,Direccion
					  ,DireccionNumero
					  ,DireccionNumeroInt
					  ,CodigoPostal
					  ,Delegacion
					  ,Colonia
					  ,Poblacion
					  ,Estado
					  ,Telefono
					  ,TelefonoMovil
				FROM VentaEntrega
				WHERE ID = @OID
			INSERT INTO VentaValeMAVI (ID, Vale)
				SELECT @DID
					  ,VV.Vale
				FROM VentaValeMAVI VV
				WHERE ID = @OID
		END

	END

END

