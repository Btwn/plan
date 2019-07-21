SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[spVentaTFiltro]
 @Estacion INT
,@Empresa VARCHAR(5)
,@IDCampana INT
,@RID INT
,@Saldo BIT
,@SaldoTipo VARCHAR(20)
,@FechaED VARCHAR(10)
,@FechaEA VARCHAR(10)
,@FechaUCD VARCHAR(10)
,@FechaUCA VARCHAR(10)
AS
BEGIN
	DECLARE
		@UltCampo VARCHAR(50)
	   ,@Campo VARCHAR(100)
	   ,@Condicion VARCHAR(20)
	   ,@Valor VARCHAR(MAX)
	   ,@op VARCHAR(20)
	   ,@SQL VARCHAR(MAX)
	   ,@WHERE VARCHAR(MAX)
	   ,@TieneEmpresa BIT
	   ,@TieneEstatus BIT
	   ,@TieneMov BIT
	   ,@TieneFechaE BIT
	   ,@TieneFechaUC BIT
	   ,@TieneCobertura BIT
	   ,@Mov VARCHAR(20)
	   ,@MovAux VARCHAR(20)
	   ,@JOIN VARCHAR(MAX)
	   ,@SaldoCond VARCHAR(50)
	   ,@SaldoValor INT
	SELECT @TieneEmpresa = 0
		  ,@TieneEstatus = 0
		  ,@TieneMov = 0
		  ,@TieneFechaE = 0
		  ,@TieneCobertura = 0
		  ,@TieneFechaUC = 0
	DELETE ListaFiltro
	WHERE Estacion = @Estacion
	DELETE ConsultaCampanaMAVI
	WHERE IDCampana = @IDCampana
	SELECT @SaldoValor = ISNULL(CxcSaldoCero, 0)
	FROM EmpresaCFG2
	WHERE Empresa = @Empresa

	IF ISNULL(@Saldo, '') <> ''
	BEGIN

		IF @SaldoTipo = 'Saldo'
			SELECT @SaldoCond = ' AND cs.Saldo > ' + CONVERT(VARCHAR, @SaldoValor)

		IF @SaldoTipo = 'Sin Saldo'
			SELECT @SaldoCond = 'AND cs.Saldo <= ' + CONVERT(VARCHAR, @SaldoValor)

	END
	ELSE
		SELECT @SaldoCond = ' AND 1=1 '

	IF (ISNULL(@FechaED, '') <> '' AND DATEPART(YEAR, @FechaED) > 1900)
		AND (ISNULL(@FechaEA, '') <> '' AND DATEPART(YEAR, @FechaEA) > 1900)
		SELECT @TieneFechaE = 1

	IF (ISNULL(@FechaUCD, '') <> '' AND DATEPART(YEAR, @FechaUCD) > 1900)
		AND (ISNULL(@FechaUCA, '') <> '' AND DATEPART(YEAR, @FechaUCA) > 1900)
		SELECT @TieneFechaUC = 1

	SELECT @JOIN = ''
		  ,@WHERE = ''
		  ,@UltCampo = ''
	SELECT @JOIN = ' Venta v
JOIN VentaD d ON v.ID = d.ID
JOIN Cxc c ON v.Mov = c.Origen AND v.MovID = c.OrigenID
JOIN Cte cte ON v.Cliente = cte.Cliente
JOIN UEN u ON u.UEN = v.UEN
JOIN Sucursal s ON v.Sucursal = s.Sucursal
LEFT OUTER JOIN CteEnviarA cea ON cea.ID = v.EnviarA
LEFT OUTER JOIN VentasCanalMavi vcm ON vcm.ID = v.EnviarA
JOIN Art a ON a.Articulo = d.Articulo
JOIN Empresa e ON e.Empresa = v.Empresa
LEFT OUTER JOIN CxcSaldo cs ON cs.Cliente = v.Cliente
LEFT OUTER JOIN EmpresaCFG2 ecfg ON ecfg.Empresa = e.Empresa
LEFT OUTER JOIN Concepto cpt ON cpt.Concepto = c.Concepto '
	DECLARE
		crTranverza
		CURSOR LOCAL FOR
		SELECT Campo
			  ,UPPER(Condicion)
			  ,Valor
		FROM Tranverza
		WHERE Estacion = @Estacion
		AND IDCampana = @IDCampana
		AND RID = @RID
		AND Bandera = 1
		AND ISNULL(Condicion, '') <> ''
		ORDER BY Campo
	OPEN crTranverza
	FETCH NEXT FROM crTranverza INTO @Campo, @Condicion, @Valor
	WHILE @@FETCH_STATUS <> -1
	BEGIN

	IF @@FETCH_STATUS <> -2
	BEGIN

		IF UPPER(@Campo) = 'EMPREZA'
		BEGIN
			SELECT @Valor = Empresa
			FROM Empresa
			WHERE Nombre = @Valor
			SELECT @TieneEmpresa = 1
				  ,@Campo = 'v.Empresa'
		END

		IF UPPER(@Campo) = 'MOV'
			SELECT @TieneMov = 1
				  ,@Campo = 'v.' + @Campo

		IF UPPER(@Campo) = 'COBERTURA'
		BEGIN
			SELECT @TieneCobertura = 1
			SELECT @JOIN = @JOIN + ' JOIN CoberturaMAVI cm ON cm.Poblacion = cte.Delegacion AND cm.Estado = cte.Estado
JOIN TiposCoberturaMAVI tcm ON tcm.Cobertura = cm.Cobertura '
			SELECT @Campo = ' tcm.Cobertura '
		END

		IF UPPER(@Campo) = 'CalificacionGlobal'
			SELECT @Campo = 'ISNULL(CalificacionGlobal,0)'

		IF UPPER(@Campo) = 'PrecioTotal'
			SELECT @Campo = 'ISNULL(PrecioTotal,0)'

		SELECT @Campo =
		 CASE
			 WHEN @Campo = 'Mez' THEN 'DATEPART(MONTH, cte.FechaNacimiento)'
			 ELSE CASE
					 WHEN @Campo = 'Sucurzal' THEN 's.Tipo'
					 ELSE CASE
							 WHEN @Campo = 'Sucursalventa' THEN 's.Sucursal'
							 ELSE CASE
									 WHEN @Campo = 'Dias' THEN 'DATEPART(DAY, cte.FechaNacimiento)'
									 ELSE CASE
											 WHEN @Campo = 'Categoria' THEN 'vcm.' + @Campo
											 ELSE CASE
													 WHEN @Campo = 'Delegacion' THEN 'cte.Delegacion'
													 ELSE CASE
															 WHEN @Campo = 'EnviarA' THEN 'v.' + @Campo
															 ELSE CASE
																	 WHEN @Campo = 'Estado' THEN 'cte.' + @Campo
																	 ELSE CASE
																			 WHEN @Campo = 'UEN' THEN 'u.Nombre'
																			 ELSE @Campo
																		 END
																 END
														 END
												 END
										 END
								 END
						 END
				 END
		 END

		IF @UltCampo = @Campo
		BEGIN

			IF @WHERE <> ''
				SELECT @WHERE = @WHERE + ' OR '

		END
		ELSE
		BEGIN

			IF @WHERE <> ''
				SELECT @WHERE = @WHERE + ') AND '

			SELECT @WHERE = @WHERE + '('
		END

		SELECT @op =
		 CASE UPPER(@Condicion)
			 WHEN 'PARECIDO' THEN 'LIKE'
			 WHEN 'EN' THEN 'IN'
			 ELSE UPPER(@Condicion)
		 END

		IF @Condicion = 'PARECIDO'
			SELECT @Valor = REPLACE(@Valor, '*', '%')

		SELECT @WHERE = @WHERE + @Campo + ' ' + @op + ' ' +
		 CASE
			 WHEN @op = 'IN'
				 OR @Campo IN ('CalificacionGlobal', 'PrecioTotal') THEN CASE
					 WHEN @op = 'IN' THEN '(' + @Valor + ')'
					 ELSE @Valor
				 END
			 ELSE dbo.fnComillas(@Valor)
		 END
		SELECT @UltCampo = @Campo
	END

	FETCH NEXT FROM crTranverza INTO @Campo, @Condicion, @Valor
	END
	CLOSE crTranverza
	DEALLOCATE crTranverza
	SELECT @SQL = 'INSERT ListaFiltro (Estacion, Clave) SELECT DISTINCT ' + CONVERT(VARCHAR, @Estacion) + ', v.Cliente FROM ' + @JOIN + ' WHERE 1=1 AND PublicidadMAVI = 0 AND ISNULL(c.Concepto,'' '') NOT IN (SELECT concepto FROM Concepto WHERE Modulo = ''CXC'' AND(Concepto LIKE ''%ADJ%'' OR Concepto LIKE ''%LOCALIZ%'')) AND c.Mov NOT LIKE ''%INCOB%'' ' + @SaldoCond

	IF @TieneMov = 0
		SELECT @SQL = @SQL + ' AND v.Mov IN (SELECT Mov FROM MovTipo WHERE Modulo = ''VTAS'' AND IncluirEnCampania = 1)'

	IF @TieneFechaE = 1
		SELECT @SQL = @SQL + ' AND v.FechaEmision > ' + CHAR(39) + @FechaED + CHAR(39) + ' AND v.FechaEmision <= ' + CHAR(39) + @FechaEA + CHAR(39)

	IF @TieneFechaUC = 1
		SELECT @SQL = @SQL + ' AND cte.FechaUltimoCobro > ' + CHAR(39) + @FechaUCD + CHAR(39) + ' AND cte.FechaUltimoCobro <= ' + CHAR(39) + @FechaUCA + CHAR(39)

	IF @TieneEmpresa = 0
		SELECT @SQL = @SQL + ' AND v.Empresa = ' + dbo.fnComillas(@Empresa)

	IF @TieneEstatus = 0
		SELECT @SQL = @SQL + ' AND v.Estatus = ' + dbo.fnComillas('CONCLUIDO')

	IF @WHERE <> ''
		SELECT @SQL = @SQL + ' AND ' + @WHERE + ')'

	EXEC (@SQL)
	INSERT INTO ConsultaCampanaMAVI
		VALUES (@IDCampana, @SQL)
	DELETE VentaTFiltroMAVI
	WHERE Estacion = @Estacion
	DELETE Tranverza
	WHERE Estacion = @Estacion
	RETURN
END
GO