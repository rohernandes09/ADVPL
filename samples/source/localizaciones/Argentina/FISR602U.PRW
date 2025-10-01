#Include "PROTHEUS.CH"
#Include "REPORT.CH"
#Include "TOPCONN.CH"
#Include "FISR602U.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ FISR602    ³ Autor ³ Luis Samaniego         ³ Data ³ 19/09/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descriçào ³ RG 1122/01 (Operaciones Internacionales)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FISR602()                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIS                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FISR602U()
Local nOpcA    := 0
Local aSays    := {}
Local aButtons := {}
Local aArea    := GetArea()

Private cPerg      := "FISR602"
Private dDeFchCont := ("//")
Private dAFchCont  := ("//")
Private nMoneda    := 0
Private nConvVal   := 0
Private nFilPais   := 0
Private oReport    := Nil
Private oSectionA  := Nil //Seccion Proveedor
Private oSectionB  := Nil //Seccion Numero de Documento
Private oSectionC  := Nil //Seecion Comprobante
Private oSectionD  := Nil //Seccion Cancelacion
Private oSectionE  := Nil //Seccion Anticipos
Private cTmpQry     := GetNextAlias()
Private cPictVlr  := PesqPict("SD1","D1_TOTAL",TamSX3("D1_TOTAL")[1])
	
	Pergunte( cPerg, .F. )
	aAdd(aSays, OemToAnsi( STR0023 ) ) 
	aAdd(aButtons, { 5,.T.,{ || Pergunte(cPerg,.T. ) } } )
	aAdd(aButtons, { 1,.T.,{ |o| IIf(VldParam(), (nOpcA := 1, o:oWnd:End()), Nil) }} )
	aAdd(aButtons, { 2,.T.,{ |o| nOpcA := 2, o:oWnd:End() }} )             
	FormBatch( oemtoansi(STR0023), aSays, aButtons ) 
	
	If nOpcA == 2
		Return
	Else
		dDeFchCont  := MV_PAR01
		dAFchCont   := MV_PAR02
		nMoneda     := MV_PAR03
		nConvVal    := MV_PAR04
		nFilPais    := MV_PAR05
	EndIf 
	
	ReportDef()
	oReport:PrintDialog()
	RestArea(aArea)
	
Return

/*/{Protheus.doc} ReportDef
Inicializa objetos para emitir informe.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   
@Return 
/*/
Static Function ReportDef()
Local cNomeProg := FunName()

	DEFINE REPORT oReport NAME cNomeProg TITLE STR0023 PARAMETER "" ACTION {|oReport| PrintReport() } DESCRIPTION STR0023
		oReport:SetTotalInLine(.F.)
		oReport:SetLandscape(.T.)	
	
	/*Seccion Proveedor*/
	DEFINE SECTION oSectionA  OF oReport   TITLE STR0024 
	DEFINE CELL NAME "CODIGO" OF oSectionA TITLE STR0025  SIZE TamSX3("A2_COD")[1]  HEADER ALIGN LEFT
	DEFINE CELL NAME "NOMBRE" OF oSectionA TITLE STR0026 SIZE TamSX3("A2_NOME")[1]  HEADER ALIGN LEFT
	oSectionA:SetTotalInLine(.F.)
	oSectionA:SetHeaderSection(.F.)
		
	/*Seccion Comprobante*/
	DEFINE SECTION oSectionB      OF oReport   TITLE STR0027 
	DEFINE CELL NAME "ESPECIE"    OF oSectionB TITLE STR0027 SIZE 12                      HEADER ALIGN LEFT
	DEFINE CELL NAME "DOC"        OF oSectionB TITLE STR0028 SIZE TamSX3("D1_DOC")[1]     HEADER ALIGN LEFT
	DEFINE CELL NAME "EMISSAO"    OF oSectionB TITLE STR0029 SIZE 14                      HEADER ALIGN LEFT
	DEFINE CELL NAME "DTLANC"     OF oSectionB TITLE STR0030 SIZE 14                      HEADER ALIGN LEFT
	DEFINE CELL NAME "TPVENT"     OF oSectionB TITLE STR0031 SIZE 16                      HEADER ALIGN LEFT
	DEFINE CELL NAME "VALOR"      OF oSectionB TITLE STR0032 SIZE TamSX3("E2_VALOR")[1]   HEADER ALIGN LEFT
	DEFINE CELL NAME "TXMOEDA"    OF oSectionB TITLE STR0033 SIZE TamSX3("E2_TXMOEDA")[1] HEADER ALIGN LEFT
	DEFINE CELL NAME "VALORTOTAL" OF oSectionB TITLE STR0034 SIZE TamSX3("E2_VALOR")[1]   HEADER ALIGN LEFT
	oSectionB:SetTotalInLine(.F.)
	oSectionB:SetHeaderSection(.F.)
	
	/*Seccion Items*/
	DEFINE SECTION oSectionC      OF oReport   TITLE STR0036 
	DEFINE CELL NAME "CONTA"      OF oSectionC TITLE STR0037 SIZE TamSX3("B1_CONTA")[1]   HEADER ALIGN LEFT
	DEFINE CELL NAME "DESC01"     OF oSectionC TITLE STR0038 SIZE TamSX3("CT1_DESC01")[1] HEADER ALIGN LEFT
	DEFINE CELL NAME "CONHEC"     OF oSectionC TITLE STR0039 SIZE TamSX3("D1_CONHEC")[1]  HEADER ALIGN LEFT
	DEFINE CELL NAME "ORIGEN"     OF oSectionC TITLE STR0040 SIZE 10                      HEADER ALIGN LEFT
	DEFINE CELL NAME "QUANT"      OF oSectionC TITLE STR0041 SIZE TamSX3("D1_QUANT")[1]   HEADER ALIGN LEFT
	DEFINE CELL NAME "VUNIT"      OF oSectionC TITLE STR0042 SIZE TamSX3("D1_VUNIT")[1]   HEADER ALIGN LEFT
	DEFINE CELL NAME "TOTAL"      OF oSectionC TITLE STR0043 SIZE TamSX3("D1_TOTAL")[1]   HEADER ALIGN LEFT
	DEFINE CELL NAME "FOBUNIT"    OF oSectionC TITLE STR0044 SIZE TamSX3("D1_VUNIT")[1]   HEADER ALIGN LEFT
	DEFINE CELL NAME "FOBTOTAL"   OF oSectionC TITLE STR0045 SIZE TamSX3("D1_TOTAL")[1]   HEADER ALIGN LEFT
	oSectionC:SetTotalInLine(.F.)
	oSectionC:SetHeaderSection(.F.)
	
	/*Seccion Cancelacion*/
	DEFINE SECTION oSectionD    OF oReport   TITLE STR0046 
	DEFINE CELL NAME "ORDPAGO"  OF oSectionD TITLE STR0047 SIZE (TamSX3("EK_ORDPAGO")[1])  HEADER ALIGN LEFT
	DEFINE CELL NAME "EMISSAO"  OF oSectionD TITLE STR0048 SIZE TamSX3("EK_EMISSAO")[1]  HEADER ALIGN LEFT
	DEFINE CELL NAME "BANCO"    OF oSectionD TITLE STR0049 SIZE 5                        HEADER ALIGN LEFT
	DEFINE CELL NAME "VALOR1"   OF oSectionD TITLE STR0050 SIZE TamSX3("EK_VALOR")[1]    HEADER ALIGN LEFT
	DEFINE CELL NAME "TAXMOE"   OF oSectionD TITLE STR0051 SIZE TamSX3("EK_TXMOE02")[1]  HEADER ALIGN LEFT
	DEFINE CELL NAME "VALOR2"   OF oSectionD TITLE STR0052 SIZE TamSX3("EK_VALOR")[1]    HEADER ALIGN LEFT
	oSectionD:SetTotalInLine(.F.)
	oSectionD:SetHeaderSection(.F.)
	
	/*Seccion Saldos Anticipados*/
	DEFINE SECTION oSectionE   OF oReport   TITLE STR0053 
	DEFINE CELL NAME "MOEDA"   OF oSectionE TITLE STR0054 SIZE 6                       HEADER ALIGN LEFT
	DEFINE CELL NAME "VALOR1"  OF oSectionE TITLE STR0055 SIZE TamSX3("EK_VALOR")[1]   HEADER ALIGN LEFT
	DEFINE CELL NAME "TAXMOE"  OF oSectionE TITLE STR0056 SIZE TamSX3("EK_TXMOE02")[1] HEADER ALIGN LEFT
	DEFINE CELL NAME "VALOR2"  OF oSectionE TITLE STR0057 SIZE TamSX3("EK_VALOR")[1]   HEADER ALIGN LEFT
	oSectionE:SetTotalInLine(.F.)
	oSectionE:SetHeaderSection(.F.)
		
Return

/*/{Protheus.doc} PrintReport
Obtiene datos y genera el informe.

@Type    Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   
@Return  
/*/
Static Function PrintReport()
Local nLoop     := 0
Local cQuery    := ""
Local cChavNF   := ""		
Local cChavAnt  := ""
Local nTaxMoe   := 0
Local dDatMoe   := CTOD("//")
Local nMoeda    := 1
Local cSerie    := ""
Local cDocum    := ""
Local cCodProv  := ""
Local cCodPais  := ""
Local cDescPais := ""
Local nVUnit    := 0
Local nVTotal   := 0

Private nTotMEX   := 0 //Total MEX
Private nTotPES   := 0 //Total Pesos
Private nTProvM   := 0 //Total Proveedor MEX
Private nTProvP   := 0 //Total Proveedor Pesos
Private nTPaisM   := 0 //Total Pais MEX
Private nTPaisP   := 0 //Total Pais Pesos
Private nTRepoM   := 0 //Total reprote MEX
Private nTRepoP   := 0 //Total reporte Pesos

	/* Obtiene Documentos */
	cQuery := " SELECT F1_FILIAL, F1_FORNECE, F1_LOJA, F1_DOC, F1_SERIE, A2_PAIS, F1_ESPECIE, F1_TPVENT, A2_COD, A2_NOME, F1_ESPECIE, D1_EMISSAO, F1_DTLANC, B1_CONTA, CT1_DESC01, D1_CONHEC, B5_TPORIG, " 
	cQuery += " D1_QUANT,  D1_VUNIT, D1_TOTAL, F1_TXMOEDA, F1_MOEDA "
	cQuery += " FROM " + RetSqlName("SF1") + " SF1 " 
	cQuery += " LEFT JOIN "+RetSqlName("SA2")+ " ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA "
	cQuery += " LEFT JOIN "+RetSqlName("SD1")+ " ON D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE "
	cQuery += " LEFT JOIN "+RetSqlName("SB5")+ " ON B5_COD = D1_COD "
	cQuery += " LEFT JOIN "+RetSqlName("SB1")+ " ON B1_COD = D1_COD "
	cQuery += " LEFT JOIN "+RetSqlName("CT1")+ " ON CT1_CONTA = B1_CONTA "
	cQuery += " WHERE A2_TIPO = 'E' "
	cQuery += " AND (F1_ESPECIE = 'NF' OR F1_ESPECIE = 'NDP' OR F1_ESPECIE = 'NCI' OR F1_ESPECIE = 'NCP' OR F1_ESPECIE = 'NDI') "
	cQuery += " AND F1_DTLANC BETWEEN "+Dtos(dDeFchCont)+" AND "+Dtos(dAFchCont)
	cQuery += " AND (F1_FILIAL = '" + xFilial("SF1") + "') "
	cQuery += " AND (A2_FILIAL = '" + xFilial("SA2") + "') "
	cQuery += " AND (D1_FILIAL = '" + xFilial("SD1") + "') "
	cQuery += " AND (B5_FILIAL = '" + xFilial("SB5") + "') "
	cQuery += " AND (B1_FILIAL = '" + xFilial("SB1") + "') "
	cQuery += " AND (CT1_FILIAL = '" + xFilial("CT1") + "') "
	cQuery += " ORDER BY 1,2,3,4,5,6"
	cQuery := ChangeQuery(cQuery)     
	
	DbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery),cTmpQry,.T.,.T.)
	TcSetField(cTmpQry, "D1_EMISSAO", "D",   TamSX3("D1_EMISSAO")[1], TamSX3("D1_EMISSAO")[2])
	TcSetField(cTmpQry, "F1_DTLANC",  "D",   TamSX3("F1_DTLANC")[1],  TamSX3("F1_DTLANC")[2])
	TcSetField(cTmpQry, "D1_QUANT",   "N",   TamSX3("D1_QUANT")[1],   TamSX3("D1_QUANT")[2])
	TcSetField(cTmpQry, "D1_VUNIT",   "N",   TamSX3("D1_VUNIT")[1],   TamSX3("D1_VUNIT")[2])
	TcSetField(cTmpQry, "D1_TOTAL",   "N",   TamSX3("D1_TOTAL")[1],   TamSX3("D1_TOTAL")[2])
	
	(cTmpQry)->(dbGoTop())
	While (cTmpQry)->(!Eof())
		
		If Empty(cDescPais) .And. nFilPais == 1
			cDescPais := fDescPais((cTmpQry)->(A2_PAIS))
		EndIf
		
		cChavNF := (cTmpQry)->(F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC + F1_SERIE)
		
		If cChavAnt <> cChavNF
			//Encabezado
			oReport:StartPage()
			oReport:SetPageNumber(nLoop)
			If nFilPais == 1
				oReport:SkipLine(1)
				oReport:PrintText(STR0060 + " " + cDescPais)
			EndIf
			oReport:SkipLine(1)
			oReport:PrintText(STR0002)
			
			/*Seccion Proveedor*/
			oSectionA:Init() 
			oSectionA:Cell("CODIGO"):SetTitle("")
			oSectionA:Cell("NOMBRE"):SetTitle("")
			oReport:SkipLine(1)
			oSectionA:Cell("CODIGO"):SetValue(STR0025)
			oSectionA:Cell("NOMBRE"):SetValue(STR0026)
			oSectionA:PrintLine()
			oSectionA:Cell("CODIGO"):SetValue((cTmpQry)->(A2_COD))
			oSectionA:Cell("NOMBRE"):SetValue((cTmpQry)->(A2_NOME))
			oSectionA:PrintLine()
			oReport:SkipLine(1)
			oSectionA:Finish()
			
			fObtComp() //Obtiene Comprobante
		EndIf
		
		If cChavAnt <> cChavNF
			/*Seccion Items*/
			oReport:SkipLine(2)
			oReport:PrintText(STR0035)
			oSectionC:Init() 
			oSectionC:Cell("CONTA"):SetTitle("")
			oSectionC:Cell("DESC01"):SetTitle("")
			oSectionC:Cell("CONHEC"):SetTitle("")
			oSectionC:Cell("ORIGEN"):SetTitle("")
			oSectionC:Cell("QUANT"):SetTitle("")
			oSectionC:Cell("VUNIT"):SetTitle("")
			oSectionC:Cell("TOTAL"):SetTitle("")
			oSectionC:Cell("FOBUNIT"):SetTitle("")
			oSectionC:Cell("FOBTOTAL"):SetTitle("")
			
			oReport:SkipLine(1)
			oSectionC:Cell("CONTA"):SetValue(STR0037)
			oSectionC:Cell("DESC01"):SetValue(STR0038)
			oSectionC:Cell("CONHEC"):SetValue(STR0039)
			oSectionC:Cell("ORIGEN"):SetValue(STR0040)
			oSectionC:Cell("QUANT"):SetValue(STR0041)
			oSectionC:Cell("VUNIT"):SetValue(STR0042)
			oSectionC:Cell("TOTAL"):SetValue(STR0043)
			oSectionC:Cell("FOBUNIT"):SetValue(STR0044)
			oSectionC:Cell("FOBTOTAL"):SetValue(STR0045)
			oSectionC:PrintLine()
			oReport:ThinLine()
		EndIf
		
		nMoeda  := Iif(Empty(nMoneda),1,nMoneda)
		dDatMoe := Iif(nConvVal == 1, (cTmpQry)->D1_EMISSAO, (cTmpQry)->D1_EMISSAO)
		nTaxMoe := Iif(nConvVal == 2, Iif((cTmpQry)->F1_TXMOEDA > 0,(cTmpQry)->F1_TXMOEDA, RecMoeda((cTmpQry)->D1_EMISSAO,(cTmpQry)->F1_MOEDA)), RecMoeda((cTmpQry)->D1_EMISSAO, (cTmpQry)->F1_MOEDA)) 	
		
		nVUnit := xMoeda((cTmpQry)->D1_VUNIT,(cTmpQry)->F1_MOEDA,nMoeda,dDatMoe,, nTaxMoe)
		nVTotal := xMoeda((cTmpQry)->D1_TOTAL,(cTmpQry)->F1_MOEDA,nMoeda,dDatMoe,, nTaxMoe)
		
		oSectionC:Cell("CONTA"):SetValue((cTmpQry)->(B1_CONTA))
		oSectionC:Cell("DESC01"):SetValue((cTmpQry)->(CT1_DESC01))
		oSectionC:Cell("CONHEC"):SetValue((cTmpQry)->(D1_CONHEC))
		oSectionC:Cell("ORIGEN"):SetValue(IIf((cTmpQry)->(B5_TPORIG) == 'F','Fabricado',IIf((cTmpQry)->(B5_TPORIG) == 'R','Reventa','Otros')))
		oSectionC:Cell("QUANT"):SetValue(Transform((cTmpQry)->D1_QUANT, cPictVlr))
		oSectionC:Cell("VUNIT"):SetValue(Transform(nVUnit, cPictVlr))
		oSectionC:Cell("TOTAL"):SetValue(Transform(nVTotal, cPictVlr))
		oSectionC:Cell("FOBUNIT"):SetValue(Transform(nVUnit, cPictVlr))
		oSectionC:Cell("FOBTOTAL"):SetValue(Transform(nVTotal, cPictVlr))
		oSectionC:PrintLine()
			
		cChavAnt := cChavNF
		cSerie := (cTmpQry)->(F1_SERIE)
		cDocum := (cTmpQry)->(F1_DOC)
		cCodProv := (cTmpQry)->(F1_FORNECE + F1_LOJA)
		cCodPais := (cTmpQry)->(A2_PAIS)
		
		(cTmpQry)->(dbSkip())
		
		If cChavNF <> (cTmpQry)->(F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC + F1_SERIE)
			
			//Finaliza Seccion Items
			oReport:SkipLine(1)
			oSectionC:Finish()
			
			fObtCanc(cSerie, cDocum) //Obtiene Cancelaciones
			
			If cCodProv <> (cTmpQry)->(F1_FORNECE + F1_LOJA)
				fTotales(nTProvM, nTProvP, STR0058) //Total por proveedor
				nTProvM := 0
				nTProvP := 0
			EndIf
			If cCodPais <> (cTmpQry)->(A2_PAIS)
				If nFilPais == 1
					cDescPais := fDescPais((cTmpQry)->(A2_PAIS)) //Descripcion de Pais
					fTotales(nTPaisM, nTPaisP, STR0059) //Total por pais
				EndIf
				nTPaisM := 0
				nTPaisP := 0
			EndIf
			
			If (cTmpQry)->(Eof())
				fTotales(nTRepoM, nTRepoP, STR0061) //Total Reporte
			EndIf
			//Finaliza pagina
			oReport:EndPage()
		EndIf
	EndDo
	
	//Finaliza reporte
	oReport:EndReport()
	(cTmpQry)->(dbCloseArea())
	
Return

/*/{Protheus.doc} fObtComp
Obtiene información de comprobantes.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   
@Return  
/*/
Static Function fObtComp()
Local nMoeda  := 1
Local dDatMoe := CTOD("//")
Local nTaxMoe := 1
Local nVlrMEX := 0
Local nVlrPES := 0
Local nTipCam := 0

	dbSelectArea("SE2")
	dbSetOrder(6)
	If MsSeek(xFilial('SE2') + (cTmpQry)->(F1_FORNECE + F1_LOJA + F1_SERIE + F1_DOC))
	
		/*Seccion Comprobante*/
		oReport:SkipLine(2)
		oReport:PrintText(STR0010)
		oSectionB:Init() 
		oSectionB:Cell("ESPECIE"):SetTitle("")
		oSectionB:Cell("DOC"):SetTitle("")
		oSectionB:Cell("EMISSAO"):SetTitle("")
		oSectionB:Cell("DTLANC"):SetTitle("")
		oSectionB:Cell("TPVENT"):SetTitle("")
		oSectionB:Cell("VALOR"):SetTitle("")
		oSectionB:Cell("TXMOEDA"):SetTitle("")
		oSectionB:Cell("VALORTOTAL"):SetTitle("")
		
		oReport:SkipLine(1)
		oSectionB:Cell("ESPECIE"):SetValue(STR0027)
		oSectionB:Cell("DOC"):SetValue(STR0028)
		oSectionB:Cell("EMISSAO"):SetValue(STR0029)
		oSectionB:Cell("DTLANC"):SetValue(STR0030)
		oSectionB:Cell("TPVENT"):SetValue(STR0031)
		oSectionB:Cell("VALOR"):SetValue(STR0032)
		oSectionB:Cell("TXMOEDA"):SetValue(STR0033)
		oSectionB:Cell("VALORTOTAL"):SetValue(STR0034)
		oSectionB:PrintLine()
		oReport:ThinLine()
		
		While SE2->(!EOF())	.And. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == xFilial('SE2') + (cTmpQry)->(F1_FORNECE + F1_LOJA + F1_SERIE + F1_DOC)
			
			nMoeda  := Iif(Empty(nMoneda), 1, nMoneda)
			dDatMoe := Iif(nConvVal == 1, SE2->E2_EMIS1, SE2->E2_EMIS1) 
			nTaxMoe := Iif(nConvVal == 2, Iif(SE2->E2_TXMOEDA > 0, SE2->E2_TXMOEDA, RecMoeda(SE2->E2_EMIS1, SE2->E2_MOEDA)), RecMoeda(dDatMoe, SE2->E2_MOEDA))
			nTipCam := Iif(nConvVal == 2, Iif(SE2->E2_TXMOEDA > 0, SE2->E2_TXMOEDA, RecMoeda(SE2->E2_EMIS1, SE2->E2_MOEDA)), RecMoeda(dDatMoe, nMoeda))
			nVlrMEX := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoeda,dDatMoe,, nTaxMoe)
			nVlrPES := xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,nMoeda,dDatMoe,, nTaxMoe)
			
			oSectionB:Cell("ESPECIE"):SetValue((cTmpQry)->F1_ESPECIE)
			oSectionB:Cell("DOC"):SetValue((cTmpQry)->F1_DOC)
			oSectionB:Cell("EMISSAO"):SetValue((cTmpQry)->D1_EMISSAO)
			oSectionB:Cell("DTLANC"):SetValue((cTmpQry)->F1_DTLANC)
			oSectionB:Cell("TPVENT"):SetValue(IIf((cTmpQry)->F1_TPVENT == "B", "Bienes", IIf((cTmpQry)->F1_TPVENT == "S", "Servicios", "Bienes/Servicios")))
			oSectionB:Cell("VALOR"):SetValue(Transform(nVlrMEX, cPictVlr))
			oSectionB:Cell("TXMOEDA"):SetValue(Transform(nTipCam, cPictVlr))
			oSectionB:Cell("VALORTOTAL"):SetValue(Transform(nVlrPES, cPictVlr))
			oSectionB:PrintLine()
			
			//Totalizadores
			nTotMEX += nVlrMEX
			nTotPES += nVlrPES
			nTProvM += nVlrMEX
			nTProvP += nVlrPES
			nTPaisM += nVlrMEX
			nTPaisP += nVlrPES
			nTRepoM += nVlrMEX
			nTRepoP += nVlrPES
			
			SE2->(dbskip())
		EndDo
		oReport:SkipLine(1)
		oSectionB:Finish()
		
	EndIf
Return

/*/{Protheus.doc} fObtCanc
Obtiene información de cancelaciones.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   cSerie: Serie del comprobante
         cDocum: Número de documento
@Return  
/*/
Static Function fObtCanc(cSerie, cDocum)//Obtiene Cancelaciones
Local cQuery    := ""
Local cQryCanc  := GetNextAlias()
Local nMoeda	:= Iif(Empty(nMoneda),1,nMoneda)
Local nTaxMoe 	:= 0
Local nMoedaSEK := 0
Local aSldPA	:= {}
Local nTipCam := 0

	BEGINSQL Alias cQryCanc
		SELECT 
			SEK.EK_ORDPAGO, SEK.EK_NUM, SEK.EK_VALOR, SEK.EK_TIPODOC, SEK.EK_TIPO,SEK.EK_EMISSAO,
			SEK.EK_MOEDA, SEK.EK_TXMOE02, SEK.EK_TXMOE03, SEK.EK_TXMOE04, SEK.EK_TXMOE05,
			SEK.EK_BANCO, SEK.EK_AGENCIA, SEK.EK_CONTA
		FROM 
			%Table:SEK% SEK	
		WHERE 
			(SEK.EK_TIPODOC = %Exp:'CP'% OR (SEK.EK_TIPO IN (%Exp:'PA'%, %Exp:'NCP'%, %Exp:'NDI'%))) AND 
			SEK.%NotDel% AND
		 	SEK.EK_ORDPAGO IN 
		 		(
		 		SELECT 
		 			DISTINCT SE2.E2_ORDPAGO	
		 		FROM 
		 			%Table:SE2% SE2 
		 		WHERE 
		 			SE2.E2_FILIAL = %Exp:xFilial("SEK") % AND 
		 			SE2.E2_PREFIXO = %Exp:PadR(cSerie,TamSX3("E2_PREFIXO")[1])% AND 
		 			SE2.E2_NUM = %Exp:PadR(cDocum,TamSX3("E2_NUM")[1])% AND 
		 			SE2.E2_ORDPAGO <> %Exp:''% AND 
		 			SE2.E2_BAIXA <> %Exp:''% AND 
		 			SE2.%NotDel%
		 		)
	EndSQL   
	
	If !(cQryCanc)->(Eof())
		/*Seccion Cancelacion*/
		oReport:SkipLine(2)
		oReport:PrintText(STR0014)
		oSectionD:Init() 
		oSectionD:Cell("ORDPAGO"):SetTitle("")
		oSectionD:Cell("EMISSAO"):SetTitle("")
		oSectionD:Cell("BANCO"):SetTitle("")
		oSectionD:Cell("VALOR1"):SetTitle("")
		oSectionD:Cell("TAXMOE"):SetTitle("")
		oSectionD:Cell("VALOR2"):SetTitle("")
		
		oReport:SkipLine(1)
		oSectionD:Cell("ORDPAGO"):SetValue(STR0047)
		oSectionD:Cell("EMISSAO"):SetValue(STR0048)
		oSectionD:Cell("BANCO"):SetValue(STR0049)
		oSectionD:Cell("VALOR1"):SetValue(STR0050)
		oSectionD:Cell("TAXMOE"):SetValue(STR0051)
		oSectionD:Cell("VALOR2"):SetValue(STR0052)
		oSectionD:PrintLine()
		oReport:ThinLine()
	EndIF
		
	While !(cQryCanc)->(Eof())
		nMoedaSEK := IIf((cQryCanc)->EK_MOEDA == "1",1,(cQryCanc)->&("EK_TXMOE0"+AllTrim((cQryCanc)->EK_MOEDA)))
		dDatMoe := Iif(nConvVal == 1, StoD((cQryCanc)->EK_EMISSAO), StoD((cQryCanc)->EK_EMISSAO))
		nTaxMoe := Iif(nConvVal == 2, Iif(nMoedaSEK > 0, nMoedaSEK, RecMoeda((cQryCanc)->EK_EMISSAO, (cQryCanc)->EK_MOEDA)), RecMoeda(dDatMoe, (cQryCanc)->EK_MOEDA))
		nTipCam := Iif(nConvVal == 2, Iif(nMoedaSEK > 0, nMoedaSEK, RecMoeda((cQryCanc)->EK_EMISSAO, (cQryCanc)->EK_MOEDA)), RecMoeda(dDatMoe, nMoeda))
		
		If (cQryCanc)->EK_TIPO $ MVPAGANT
			aAdd(aSldPA,{AllTrim(STR(nMoeda)),xMoeda((cQryCanc)->EK_VALOR,Val((cQryCanc)->EK_MOEDA),nMoeda,dDatMoe,, nTaxMoe),nTaxMoe,xMoeda((cQryCanc)->EK_VALOR,Val((cQryCanc)->EK_MOEDA),nMoeda,dDatMoe,, nTaxMoe)})
			(cQryCanc)->(dbSkip())
			Loop
		EndIf
		
		oSectionD:Cell("ORDPAGO"):SetValue((cQryCanc)->(EK_ORDPAGO))
		oSectionD:Cell("EMISSAO"):SetValue((cQryCanc)->(EK_EMISSAO))
		oSectionD:Cell("BANCO"):SetValue((cQryCanc)->EK_BANCO)
		oSectionD:Cell("VALOR1"):SetValue(Transform(xMoeda((cQryCanc)->EK_VALOR,Val((cQryCanc)->EK_MOEDA),nMoeda,dDatMoe,, nTaxMoe), cPictVlr))
		oSectionD:Cell("TAXMOE"):SetValue(Transform(nTipCam, cPictVlr))
		oSectionD:Cell("VALOR2"):SetValue(Transform(xMoeda((cQryCanc)->EK_VALOR,Val((cQryCanc)->EK_MOEDA),nMoeda,dDatMoe,, nTaxMoe), cPictVlr))
		oSectionD:PrintLine()
		(cQryCanc)->(dbSkip())
	EndDo
	oReport:SkipLine(1)
	oSectionD:Finish()
	fObtSald(aSldPA) // Saldos Anticipos
	
	(cQryCanc)->(DbCloseArea())
Return

/*/{Protheus.doc} fObtSald
Obtiene saldo de anticipos.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   aInfo: Saldo del anticipo
@Return  
/*/
Static Function fObtSald(aInfo) //Obtiene saldo anticipos
Local nX	:= 0
	
	If Len(aInfo) > 0
		/*Seccion Saldos Anticipados*/
		oReport:SkipLine(2)
		oReport:PrintText(STR0018)
		oSectionE:Init() 
		oSectionE:Cell("MOEDA"):SetTitle("")
		oSectionE:Cell("VALOR1"):SetTitle("")
		oSectionE:Cell("TAXMOE"):SetTitle("")
		oSectionE:Cell("VALOR2"):SetTitle("")
		
		oReport:SkipLine(1)
		oSectionE:Cell("MOEDA"):SetValue(STR0054)
		oSectionE:Cell("VALOR1"):SetValue(STR0055)
		oSectionE:Cell("TAXMOE"):SetValue(STR0056)
		oSectionE:Cell("VALOR2"):SetValue(STR0057)
		oSectionE:PrintLine()
		oReport:ThinLine()
	EndIf
	
	For nX := 1 To Len(aInfo)
		oSectionE:Cell("MOEDA"):SetValue(aInfo[nX][1])
		oSectionE:Cell("VALOR1"):SetValue(Transform(aInfo[nX][2], cPictVlr))
		oSectionE:Cell("TAXMOE"):SetValue(Transform(aInfo[nX][3], cPictVlr))
		oSectionE:Cell("VALOR2"):SetValue(Transform(aInfo[nX][4], cPictVlr))
		oSectionE:PrintLine()
	Next nX
	oReport:SkipLine(1)
	oSectionE:Finish()
Return

/*/{Protheus.doc} fTotales
Muestra totales en informe.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   nVlrM: Valor moneda extranjera
		 nVlrP: Valor en pesos
		 cDescTotal: Descripción
@Return  
/*/
Static Function fTotales(nVlrM, nVlrP, cDescTotal)

	oSectionB:Init() 
	oSectionB:Cell("ESPECIE"):SetTitle("")
	oSectionB:Cell("DOC"):SetTitle("")
	oSectionB:Cell("EMISSAO"):SetTitle("")
	oSectionB:Cell("DTLANC"):SetTitle("")
	oSectionB:Cell("TPVENT"):SetTitle("")
	oSectionB:Cell("VALOR"):SetTitle("")
	oSectionB:Cell("TXMOEDA"):SetTitle("")
	oSectionB:Cell("VALORTOTAL"):SetTitle("")
	//oReport:SkipLine(1)
	
	oSectionB:Cell("ESPECIE"):SetValue("")
	oSectionB:Cell("DOC"):SetValue(cDescTotal)
	oSectionB:Cell("EMISSAO"):SetValue("")
	oSectionB:Cell("DTLANC"):SetValue("")
	oSectionB:Cell("TPVENT"):SetValue("")
	oSectionB:Cell("VALOR"):SetValue()
	oSectionB:Cell("TXMOEDA"):SetValue("")
	oSectionB:Cell("VALORTOTAL"):SetValue()
	oSectionB:PrintLine()
	oReport:ThinLine()
//	oReport:SkipLine(1)
	oSectionB:Cell("ESPECIE"):SetValue("")
	oSectionB:Cell("DOC"):SetValue("")
	oSectionB:Cell("EMISSAO"):SetValue("")
	oSectionB:Cell("DTLANC"):SetValue("")
	oSectionB:Cell("TPVENT"):SetValue("")
	oSectionB:Cell("VALOR"):SetValue(nVlrM)
	oSectionB:Cell("TXMOEDA"):SetValue("")
	oSectionB:Cell("VALORTOTAL"):SetValue(nVlrP)
	oSectionB:PrintLine()
	oReport:SkipLine(1)
	oSectionB:Finish()
		
Return

/*/{Protheus.doc} fDescPais
Obtiene descripción del pais.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   cCodigo: Codigo del país
@Return  cDescPais: Descripción del país
/*/
Static Function fDescPais(cCodigo)
Local cDescPais := ""

	dbSelectArea("SYA")
	SYA->(dbSetOrder(1))
	If SYA->(MsSeek(xFilial("SYA") + cCodigo))
		cDescPais := Alltrim(SYA->YA_DESCR)
	EndIf
Return cDescPais

/*/{Protheus.doc} VldParam
Valida grupo de preguntas.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   
@Return  lRet: Verdadero si se informaron las fechas
/*/
Static Function VldParam()//Valida Grupo de preguntas
Local lRet := .T.

	If Empty(MV_PAR01) .Or. Empty(MV_PAR02)
		lRet := .F.
	EndIf
Return lRet

/*/{Protheus.doc} fGetTitulo
Obtiene título de campo.

@Type    Static Function
@Author  Luis Arturo Samaniego Guzman
@Since   19/09/2018
@Version P12.1.17
@Param   cCampoSX3: Nombre del campo en SX3
@Return  cTitulo: Titulo del campo en SX3
/*/
Static Function fGetTitulo(cCampoSX3)//Obtiene Titulo de Campo
Local cTitulo := ""

	DbSelectArea("SX3")
	DbSetOrder(2)
	If SX3->(MsSeek(cCampoSX3))
		cTitulo := Alltrim(X3Titulo())
	EndIf
Return cTitulo
