#Include "PROTHEUS.CH"
#Include "REPORT.CH"
#Include "TOPCONN.CH"
#Include "FISR601U.CH"

/*/   
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ FISR601    ³ Autor ³ Luis Samaniego         ³ Data ³ 11/05/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descriçào ³ Planilla demostrativa de los ingresos brutos totales y gastos ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FISR601()                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIS                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FISR601U()
Local nOpcA    := 0
Local aSays    := {}
Local aButtons := {}
Local aArea    := GetArea()

Private dFchDesde  := CTOD("//")
Private dFchHasta  := CTOD("//")
Private nTipoCamb  := 0
Private nTipReport := 0
Private nSelectSuc := 0
Private nOrden     := 0
Private cPerg      := "FISR601"
Private oReport    := Nil
Private oSectionA  := Nil
Private cQrySD     := GetNextAlias()

Private aCposTmp   := {}
Private cMVDESCSAI := GetNewPar('MV_DESCSAI','1')
Private cTipoinf   := ""
	
	Pergunte( cPerg, .T. )
	aAdd(aSays, OemToAnsi( STR0001 ) ) 
	aAdd(aButtons, { 5,.T.,{ || Pergunte(cPerg,.T. ) } } )
	aAdd(aButtons, { 1,.T.,{ |o| IIf(VldParam(), (nOpcA := 1, o:oWnd:End()), Nil) }} )
	aAdd(aButtons, { 2,.T.,{ |o| nOpcA := 2, o:oWnd:End() }} )             
	FormBatch( oemtoansi(STR0001), aSays, aButtons ) 
	
	If nOpcA == 2
		Return
	Else
		dFchDesde  := MV_PAR01
		dFchHasta  := MV_PAR02
		nTipoCamb  := MV_PAR03
		nTipReport := MV_PAR04
		nSelectSuc := MV_PAR05
		nOrden     := MV_PAR06
		cTipoinf   := cValtochar(MV_PAR07)
		If nSelectSuc == 1
			aFilsCalc := MatFilCalc( nSelectSuc == 1, , , .T., , 0 )
		Else
			aFilsCalc := MatFilCalc( .F., {{.T.,Alltrim(FWGETCODFILIAL)}} , , .T., , 0 )
		EndIf
	EndIf
	
	ReportDef()
	oReport:PrintDialog()
	RestArea(aArea)
	
Return

/*/{Protheus.doc} ReportDef
Inicializa objetos para emitir informe.

@Type    Function
@Author  Luis Arturo Samaniego Guzman
@Since   11/05/2018
@Version P12.1.07
@Param   
@Return  oReport: Objeto del informe.
/*/
Static Function ReportDef()
Local cNomeProg := FunName()

	DEFINE REPORT oReport NAME cNomeProg TITLE STR0001 PARAMETER "" ACTION {|oReport| PrintReport(oReport) } DESCRIPTION STR0001
		oReport:SetTotalInLine(.F.)
		oReport:SetLandscape(.T.)	
	
	DEFINE SECTION oSectionA OF oReport TITLE STR0001 TABLE cQrySD
		DEFINE CELL NAME "ESPECIE" OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_ESPECIE") SIZE TamSX3("D1_ESPECIE")[1] HEADER ALIGN LEFT
		DEFINE CELL NAME "SERIE"   OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_SERIE")   SIZE TamSX3("D1_SERIE")[1]   HEADER ALIGN LEFT
		DEFINE CELL NAME "DOC"     OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_DOC")     SIZE TamSX3("D1_DOC")[1]     HEADER ALIGN LEFT
		DEFINE CELL NAME "EMISSAO" OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_EMISSAO") SIZE TamSX3("D1_EMISSAO")[1] HEADER ALIGN LEFT
		DEFINE CELL NAME "ACTDEC"  OF oSectionA ALIAS cQrySD TITLE fGetTitulo("B1_ACTDEC")  SIZE TamSX3("B1_ACTDEC")[1]  HEADER ALIGN LEFT
		DEFINE CELL NAME "CONTA"   OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_CONTA")   SIZE TamSX3("D1_CONTA")[1]   HEADER ALIGN LEFT
		DEFINE CELL NAME "CF"      OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_CF")      SIZE TamSX3("D1_CF")[1]      HEADER ALIGN LEFT
		DEFINE CELL NAME "TP"      OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_TP")      SIZE TamSX3("D1_TP")[1]      HEADER ALIGN LEFT
		DEFINE CELL NAME "GRUPO"   OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_GRUPO")   SIZE TamSX3("D1_GRUPO")[1]   HEADER ALIGN LEFT
		DEFINE CELL NAME "EST"     OF oSectionA ALIAS cQrySD TITLE fGetTitulo("A1_EST")     SIZE TamSX3("A1_EST")[1]     HEADER ALIGN LEFT
		DEFINE CELL NAME "PROVENT" OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_PROVENT") SIZE TamSX3("D1_PROVENT")[1] HEADER ALIGN LEFT
		DEFINE CELL NAME "ESTCOB"  OF oSectionA ALIAS cQrySD TITLE STR0002                  SIZE TamSX3("A1_EST")[1]     HEADER ALIGN LEFT
		DEFINE CELL NAME "FILIAL"  OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_FILIAL")  SIZE TamSX3("D1_FILIAL")[1]  HEADER ALIGN LEFT
		DEFINE CELL NAME "TOTAL"   OF oSectionA ALIAS cQrySD TITLE fGetTitulo("D1_TOTAL")   SIZE TamSX3("D1_TOTAL")[1] + TamSX3("D1_TOTAL")[2]   HEADER ALIGN CENTER
		oSectionA:SetTotalInLine(.T.)
		oSectionA:SetHeaderSection(.T.)
		
Return oReport

/*/{Protheus.doc} PrintReport
Obtiene datos y genera el informe.

@Type    Function
@Author  Luis Arturo Samaniego Guzman
@Since   11/05/2018
@Version P12.1.07
@Param   
@Return  
/*/
Static Function PrintReport(oReport)
Local nLoop     := 0
Local oTmpTable := Nil
Local aFiliAct  := { FWGETCODFILIAL }
Local cESTCOB   := ""
Local cFilialSB1 := ""
Local cFilialSA1 := ""
Local cFilialSA2 := ""
Local cFilialSD1 := ""
Local cFilialSF1 := ""
Local cFilialSD2 := ""
Local cFilialSF2 := ""
Local cFchIni    := DTOS(dFchDesde)
Local cFchFin    := DTOS(dFchHasta)
Local cAliasQry  := ""
Local cQryVentD1 := ""
Local cQryVentD2 := ""
Local cQryCompD1 := "" 
Local cQryCompD2 := "" 
Local cCondVenD1 := ""
Local cCondVenD2 := ""
Local cFromVenD1 := ""
Local cFromVenD2 := ""
Local cCondComD1 := ""
Local cCondComD2 := ""
Local cFromComD1 := ""
Local cFromComD2 := ""

	FISRTAB()
	
	dbSelectArea("SM0")
	dbSetOrder(1)
	
	For nLoop := 1 To Len(aFilsCalc)
		If aFilsCalc[nLoop][1] .And. (SM0->(msSeek(FwGrpCompany() + aFilsCalc[nLoop][2])))

			cFilialSB1 := xFilial("SB1", aFilsCalc[nLoop][2])
			cFilialSA1 := xFilial("SA1", aFilsCalc[nLoop][2])
			cFilialSA2 := xFilial("SA2", aFilsCalc[nLoop][2])
			cFilialSD1 := xFilial("SD1", aFilsCalc[nLoop][2])
			cFilialSF1 := xFilial("SF1", aFilsCalc[nLoop][2])
			cFilialSD2 := xFilial("SD2", aFilsCalc[nLoop][2])
			cFilialSF2 := xFilial("SF2", aFilsCalc[nLoop][2])

			cESTCOB := Alltrim(SM0->M0_ESTCOB)
			cAliasQry  := GetNextAlias()

			/*CAMPOS SD1 - VENTAS*/
			cQryVentD1 := "% SD1.D1_ESPECIE AS ESPECIE, SD1.D1_SERIE AS SERIE, SD1.D1_DOC AS DOC, SD1.D1_EMISSAO AS EMISSAO, SD1.D1_CONTA AS CONTA, SD1.D1_CF AS CF, SD1.D1_TP AS TP, "
			cQryVentD1 += " SD1.D1_GRUPO AS GRUPO, SD1.D1_PROVENT AS PROVENT, SD1.D1_FILIAL AS FILIAL, SB1.B1_ACTDEC AS ACTDEC, SA1.A1_EST AS EST, '" + cESTCOB + "' AS ESTCOB, "
			cQryVentD1 += " CASE WHEN '" + cMVDESCSAI + "' = '1' THEN (SD1.D1_TOTAL * -1) ELSE ((SD1.D1_TOTAL - SD1.D1_VALDESC) * -1) END AS TOTAL, "
			cQryVentD1 += " SF1.F1_MOEDA AS MOEDA, SF1.F1_TXMOEDA AS TXMOEDA %"

			/*CAMPOS SD2 - VENTAS*/
			cQryVentD2 := "% SD2.D2_ESPECIE AS ESPECIE, SD2.D2_SERIE AS SERIE, SD2.D2_DOC AS DOC, SD2.D2_EMISSAO AS EMISSAO, SD2.D2_CONTA AS CONTA, SD2.D2_CF AS CF, SD2.D2_TP AS TP, "
			cQryVentD2 += " SD2.D2_GRUPO AS GRUPO, SD2.D2_PROVENT AS PROVENT, SD2.D2_FILIAL AS FILIAL, SB1.B1_ACTDEC AS ACTDEC, SA1.A1_EST AS EST, '" + cESTCOB + "' ESTCOB, "
			cQryVentD2 += " CASE WHEN '" + cMVDESCSAI + "' = '1' THEN SD2.D2_TOTAL ELSE (SD2.D2_TOTAL) END AS TOTAL, "
			cQryVentD2 += " SF2.F2_MOEDA AS MOEDA, SF2.F2_TXMOEDA AS TXMOEDA %"

			/*CONDICIONES SD1 - VENTAS*/
			cCondVenD1 := " (SD1.D1_ESPECIE IN ('NDE', 'NCC') "
			cCondVenD1 += " AND (SD1.D1_EMISSAO BETWEEN '" + cFchIni + "' AND '" + cFchFin + "') "
			cCondVenD1 += "	AND SD1.D1_FILIAL = '" + cFilialSD1 + "') "
			cCondVenD1 += "	AND (SD1.D1_COD = SB1.B1_COD "
			cCondVenD1 += "	AND SB1.B1_FILIAL = '" + cFilialSB1 + "') "
			cCondVenD1 += "	AND (SD1.D1_FORNECE = SA1.A1_COD "
			cCondVenD1 += "	AND SD1.D1_LOJA = SA1.A1_LOJA "
			cCondVenD1 += "	AND SA1.A1_FILIAL = '" + cFilialSA1 + "') "
			cCondVenD1 += "	AND ((SF1.F1_FILIAL = '" + cFilialSF1 + "') "
			cCondVenD1 += "	AND (SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE) "
			cCondVenD1 += "	AND (SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA)) "
			cCondVenD1 += "	AND SD1.D_E_L_E_T_ = '' "
			cCondVenD1 += "	AND SB1.D_E_L_E_T_ = '' "
			cCondVenD1 += "	AND SA1.D_E_L_E_T_ = '' "
			cCondVenD1 += "	AND SF1.D_E_L_E_T_ = '' "
			cCondVenD1 := "%" + cCondVenD1 + "%"

			/*CONDICIONES SD2 - VENTAS*/
			cCondVenD2 := " (SD2.D2_ESPECIE IN ('NF', 'NDC', 'NCE') "
			cCondVenD2 += "	AND (SD2.D2_EMISSAO BETWEEN '" + cFchIni + "' AND '" + cFchFin + "') "
			cCondVenD2 += "	AND SD2.D2_FILIAL = '" + cFilialSD2 + "') "
			cCondVenD2 += "	AND (SD2.D2_COD = SB1.B1_COD "
			cCondVenD2 += "	AND SB1.B1_FILIAL = '" + cFilialSB1 + "') "
			cCondVenD2 += "	AND (SD2.D2_CLIENTE = SA1.A1_COD "
			cCondVenD2 += "	AND SD2.D2_LOJA = SA1.A1_LOJA "
			cCondVenD2 += "	AND SA1.A1_FILIAL = '" + cFilialSA1 + "') "
			cCondVenD2 += "	AND ((SF2.F2_FILIAL = '" + cFilialSF2 + "') "
			cCondVenD2 += "	AND (SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE) "
			cCondVenD2 += "	AND (SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA)) "
			cCondVenD2 += "	AND SD2.D_E_L_E_T_ = '' "
			cCondVenD2 += "	AND SB1.D_E_L_E_T_ = '' "
			cCondVenD2 += "	AND SA1.D_E_L_E_T_ = '' "
			cCondVenD2 += "	AND SF2.D_E_L_E_T_ = '' "
			cCondVenD2 := "%" + cCondVenD2 + "%"
			
			/*TABLAS - VENTAS*/
			cFromVenD1 := "% " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SA1") + " SA1, " + RetSqlName("SF1") + " SF1 %"

			/*TABLAS - VENTAS*/
			cFromVenD2 := "% " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SA1") + " SA1, " + RetSqlName("SF2") + " SF2 %"

			/*=============================================================================================================================================*/

			/*CAMPOS SD2 - COMPRAS*/
			cQryCompD2 := "% SD2.D2_ESPECIE AS ESPECIE, SD2.D2_SERIE AS SERIE, SD2.D2_DOC AS DOC, SD2.D2_EMISSAO AS EMISSAO, SD2.D2_CONTA AS CONTA, SD2.D2_CF AS CF, SD2.D2_TP AS TP, "
			cQryCompD2 += " SD2.D2_GRUPO AS GRUPO, SD2.D2_PROVENT AS PROVENT, SD2.D2_FILIAL AS FILIAL, SB1.B1_ACTDEC AS ACTDEC, SA2.A2_EST AS EST, '" + cESTCOB + "' AS ESTCOB, "
			cQryCompD2 += " CASE WHEN '" + cMVDESCSAI + "' = '1' THEN (SD2.D2_TOTAL * -1) ELSE ((SD2.D2_TOTAL - SD2.D2_DESC) * -1) END AS TOTAL, "
			cQryCompD2 += " SF2.F2_MOEDA AS MOEDA, SF2.F2_TXMOEDA AS TXMOEDA %"

			/*CAMPOS SD1 - COMPRAS*/
			cQryCompD1 := "% SD1.D1_ESPECIE AS ESPECIE, SD1.D1_SERIE AS SERIE, SD1.D1_DOC AS DOC, SD1.D1_EMISSAO AS EMISSAO, SD1.D1_CONTA AS CONTA, SD1.D1_CF AS CF, SD1.D1_TP AS TP, "
			cQryCompD1 += " SD1.D1_GRUPO AS GRUPO, SD1.D1_PROVENT AS PROVENT, SD1.D1_FILIAL AS FILIAL, SB1.B1_ACTDEC AS ACTDEC, SA2.A2_EST AS EST, '" + cESTCOB + "' ESTCOB, "
			cQryCompD1 += " CASE WHEN '" + cMVDESCSAI + "' = '1' THEN SD1.D1_TOTAL ELSE (SD1.D1_TOTAL - SD1.D1_VALDESC) END AS TOTAL, "
			cQryCompD1 += " SF1.F1_MOEDA AS MOEDA, SF1.F1_TXMOEDA AS TXMOEDA %"

			/*CONDICIONES SD2 - COMPRAS*/
			cCondComD2 := " (SD2.D2_ESPECIE IN ('NDI', 'NCP') "
			cCondComD2 += " AND (SD2.D2_EMISSAO BETWEEN '" + cFchIni + "' AND '" + cFchFin + "') "
			cCondComD2 += " AND SD2.D2_FILIAL = '" + cFilialSD2 + "') "
			cCondComD2 += " AND (SD2.D2_COD = SB1.B1_COD "
			cCondComD2 += " AND SB1.B1_FILIAL = '" + cFilialSB1 + "') "
			cCondComD2 += " AND (SD2.D2_CLIENTE = SA2.A2_COD AND SD2.D2_LOJA = SA2.A2_LOJA "
			cCondComD2 += " AND SA2.A2_FILIAL = '" + cFilialSA2 + "') "
			cCondComD2 += " AND ((SF2.F2_FILIAL = '" + cFilialSF2 + "') "
			cCondComD2 += " AND (SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE) "
			cCondComD2 += " AND (SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA)) "
			cCondComD2 += " AND SD2.D_E_L_E_T_ = '' "
			cCondComD2 += " AND SB1.D_E_L_E_T_ = '' "
			cCondComD2 += " AND SA2.D_E_L_E_T_ = '' "
			cCondComD2 += " AND SF2.D_E_L_E_T_ = '' "
			cCondComD2 := "%" + cCondComD2 + "%"

			/*CONDICIONES SD1 - COMPRAS*/
			cCondComD1 := " (SD1.D1_ESPECIE IN ('NF', 'NCI', 'NDP') "
			cCondComD1 += " AND (SD1.D1_EMISSAO BETWEEN '" + cFchIni + "' AND '" + cFchFin + "') "
			cCondComD1 += " AND SD1.D1_FILIAL = '" + cFilialSD1 + "') "
			cCondComD1 += " AND (SD1.D1_COD = SB1.B1_COD "
			cCondComD1 += " AND SB1.B1_FILIAL = '" + cFilialSB1 + "') "
			cCondComD1 += " AND (SD1.D1_FORNECE = SA2.A2_COD AND SD1.D1_LOJA = SA2.A2_LOJA "
			cCondComD1 += " AND SA2.A2_FILIAL = '" + cFilialSA2 + "') "
			cCondComD1 += " AND ((SF1.F1_FILIAL = '" + cFilialSF1 + "') "
			cCondComD1 += " AND (SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE) "
			cCondComD1 += " AND (SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA)) "
			cCondComD1 += " AND SD1.D_E_L_E_T_ = '' "
			cCondComD1 += " AND SB1.D_E_L_E_T_ = '' "
			cCondComD1 += " AND SA2.D_E_L_E_T_ = '' "
			cCondComD1 += " AND SF1.D_E_L_E_T_ = '' "
			cCondComD1 := "%" + cCondComD1 + "%"

			/*TABLAS - COMPRAS*/
			cFromComD2 := "% " + RetSqlName("SD2") + " SD2, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SA2") + " SA2, " + RetSqlName("SF2") + " SF2 %"

			/*TABLAS - COMPRAS*/
			cFromComD1 := "% " + RetSqlName("SD1") + " SD1, " + RetSqlName("SB1") + " SB1, " + RetSqlName("SA2") + " SA2, " + RetSqlName("SF1") + " SF1 %"

			If 	cTipoinf $ "1"

				BeginSql Alias cAliasQry
					Column EMISSAO As Date

					SELECT %Exp:cQryVentD1%
					FROM %Exp:cFromVenD1%
					WHERE %Exp:cCondVenD1%
					UNION ALL
					SELECT %Exp:cQryVentD2%
					FROM %Exp:cFromVenD2%
					WHERE %Exp:cCondVenD2%
				EndSql
	
			ElseIf cTipoinf $ "2"

				BeginSql Alias cAliasQry
					Column EMISSAO As Date

					SELECT %Exp:cQryCompD2%
					FROM %Exp:cFromComD2%
					WHERE %Exp:cCondComD2%
					UNION ALL 
					SELECT %Exp:cQryCompD1%
					FROM %Exp:cFromComD1%
					WHERE %Exp:cCondComD1%
				EndSql
				
			Elseif cTipoinf $ "3"

				BeginSql Alias cAliasQry
					Column EMISSAO As Date

					SELECT %Exp:cQryVentD1%
					FROM %Exp:cFromVenD1%
					WHERE %Exp:cCondVenD1%
					UNION ALL
					SELECT %Exp:cQryVentD2%
					FROM %Exp:cFromVenD2%
					WHERE %Exp:cCondVenD2%
					UNION ALL
					SELECT %Exp:cQryCompD2%
					FROM %Exp:cFromComD2%
					WHERE %Exp:cCondComD2%
					UNION ALL
					SELECT %Exp:cQryCompD1%
					FROM %Exp:cFromComD1%
					WHERE %Exp:cCondComD1%
				EndSql
					
			Endif
			If Select(cAliasQry) > 0
				SqlToTable(cAliasQry, cQrySD)
				(cAliasQry)->(dbCloseArea())
			EndIf
		EndIf		
	Next nLoop
	
	//Se posiciona sobre la filial activa
	SM0->(DbSeek(FwGrpCompany() + aFiliAct[1]))
	
 	If nTipReport == 2
 		oSectionA:Cell("ESPECIE"):Disable()
 		oSectionA:Cell("SERIE"):Disable()
 		oSectionA:Cell("DOC"):Disable()
 		oSectionA:Cell("EMISSAO"):Disable()
 	EndIf
 	oSectionA:Cell("TOTAL"):SetBlock({|| fTipoCam()})
  	oSectionA:Print() 
  	
  	(cQrySD)->(dbCloseArea())
  	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	EndIf
	
Return

/*/{Protheus.doc} fTipoCam
Valor de Ítem en SD1/SD2 en moneda 1.

@Type    Function
@Author  Luis Arturo Samaniego Guzman
@Since   11/05/2018
@Version P12.1.07
@Param   
@Return  nVlrTotal: Valor de ítem.
/*/
Static Function fTipoCam()
Local nVlrTotal := 0
	
	If (cQrySD)->MOEDA != 1
		If nTipoCamb == 1 //Historico
			nVlrTotal := xMoeda((cQrySD)->TOTAL,(cQrySD)->MOEDA,1,(cQrySD)->EMISSAO,,)
		Else //Informado
			nVlrTotal := xMoeda((cQrySD)->TOTAL,(cQrySD)->MOEDA,1,,,(cQrySD)->TXMOEDA)
		EndIf
	Else
		nVlrTotal := (cQrySD)->TOTAL
	EndIf
	
Return nVlrTotal

/*/{Protheus.doc} fGetTitulo
Retorna el título del campo.

@Type    Function
@Author  Luis Arturo Samaniego Guzman
@Since   11/05/2018
@Version P12.1.07
@Param   cCampoSX3: Campo (SX3)
@Return  cTitulo: Título del campo.
/*/
Static Function fGetTitulo(cCampoSX3)
Local cTitulo := ""

	DbSelectArea("SX3")
	DbSetOrder(2)
	If SX3->(MsSeek(cCampoSX3))
		cTitulo := Alltrim(X3Titulo())
	EndIf
Return cTitulo

/*/{Protheus.doc} VldParam
Valida que sean informados los parámetros de fecha.

@Type    Function
@Author  Luis Arturo Samaniego Guzman
@Since   11/05/2018
@Version P12.1.07
@Param   
@Return  lRet: Verdadero si se informaron todos los parámetros.
/*/
Static Function VldParam()
Local lRet := .T.

	If Empty(MV_PAR01) .Or. Empty(MV_PAR02)
		lRet := .F.
	EndIf
	
Return lRet

/*/{Protheus.doc} FISRTAB
Cria as tabela temporaria.

@Type    Function
@Author  Danilo Santos
@Since   16/10/2018
@Version P12.1.17
@Param   
@Return  
/*/
Static Function FISRTAB()

 //Crea estructura de la tabla
	aAdd(aCposTmp, { "ESPECIE",   "C", TamSX3("D1_ESPECIE")[1],   TamSX3("D1_ESPECIE")[2] })
	aAdd(aCposTmp, { "SERIE",     "C", TamSX3("D1_SERIE")[1],     TamSX3("D1_SERIE")[2] })
	aAdd(aCposTmp, { "DOC",       "C", TamSX3("D1_DOC")[1],       TamSX3("D1_DOC")[2] })
	aAdd(aCposTmp, { "EMISSAO",   "D", TamSX3("D1_EMISSAO")[1],   TamSX3("D1_EMISSAO")[2] })
	aAdd(aCposTmp, { "ACTDEC",    "C", TamSX3("B1_ACTDEC")[1],    TamSX3("B1_ACTDEC")[2] })
	aAdd(aCposTmp, { "CONTA",     "C", TamSX3("D1_CONTA")[1],     TamSX3("D1_CONTA")[2] })
	aAdd(aCposTmp, { "CF",        "C", TamSX3("D1_CF")[1],        TamSX3("D1_CF")[2] })
	aAdd(aCposTmp, { "TP",        "C", TamSX3("D1_TP")[1],        TamSX3("D1_TP")[2] })
	aAdd(aCposTmp, { "GRUPO",     "C", TamSX3("D1_GRUPO")[1],     TamSX3("D1_GRUPO")[2] })
	aAdd(aCposTmp, { "EST",       "C", TamSX3("A1_EST")[1],       TamSX3("A1_EST")[2] })
	aAdd(aCposTmp, { "PROVENT",   "C", TamSX3("D1_PROVENT")[1],   TamSX3("D1_PROVENT")[2] })
	aAdd(aCposTmp, { "ESTCOB",    "C", TamSX3("A1_EST")[1],       TamSX3("A1_EST")[2]  })
	aAdd(aCposTmp, { "FILIAL",    "C", TamSX3("D1_FILIAL")[1],    TamSX3("D1_FILIAL")[2] })
	aAdd(aCposTmp, { "TOTAL",     "N", TamSX3("D1_TOTAL")[1],     TamSX3("D1_TOTAL")[2] })
	aAdd(aCposTmp, { "MOEDA",     "N", TamSX3("F1_MOEDA")[1],     TamSX3("F1_MOEDA")[2] })
	aAdd(aCposTmp, { "TXMOEDA",   "N", TamSX3("F1_TXMOEDA")[1],   TamSX3("F1_TXMOEDA")[2] })
	
	oTmpTable := FWTemporaryTable():New(cQrySD) 
	oTmpTable:SetFields( aCposTmp ) 
	If nOrden == 1
		oTmpTable:AddIndex("IN1", {"ESPECIE"})
	ElseIf nOrden == 2
		oTmpTable:AddIndex("IN2", {"SERIE"})
	ElseIf nOrden == 3
		oTmpTable:AddIndex("IN3", {"DOC"})
	EndIf
	oTmpTable:Create()

Return

/*/{Protheus.doc} SqlToTable
	Inserta información a estructura de tabla temporal.
	@type  Function
	@author luis.samaniego
	@since 09/05/2023
	@param cTmpQry - Query con información.
	@return cTmpTrb - Tabla temporal.
	/*/
Static Function SqlToTable(cTmpQry, cTmpTrb)
Local aStruQry := {}
Local nCpos    := 0
Local nI       := 0

	aStruQry := (cTmpQry)->(DbStruct())
	nCpos    := Len(aStruQry)

	(cTmpQry)->(dbGoTop())
	While !(cTmpQry)->(Eof())
		RecLock(cTmpTrb, .T.)
		For nI := 1 To nCpos
			If aStruQry[nI,2] <> 'M'
				(cTmpTrb)->(FieldPut(FieldPos(aStruQry[nI,1]), (cTmpQry)->(FieldGet((cTmpQry)->(FieldPos(aStruQry[nI,1]))))))
			Endif
		Next nI
		MsUnlock()
		(cTmpQry)->(DbSkip())
	End

Return
