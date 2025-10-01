#Include "PROTHEUS.CH"
#INCLUDE "ORDBUSCC.CH"

Static lInconveniente := (GetNewPar("MV_INCORC","N") == "S")

/*/{Protheus.doc} ORDBUSCC
	Impressao da Transferencia de Peças entre OSs

	@author Andre Luis Almeida
	@since 12/04/2021
/*/
User Function ORDBUSCC()
Local oReport
Local aArea   := GetArea()
Private cNrOSVO3 := ParamIxb[01] // Nro da OS Destino
Private aColsVO3 := ParamIxb[02] // aCols do VO3 (Tela de Transferencia)
Private aHeadVO3 := ParamIxb[03] // aHeader do VO3 (Tela de Transferencia)
Private aCposIte := { "VO3_GRUITE" , "VO3_CODITE" , "VO3_DESITE" }
Private aCposDev := { "VO3_QTDREQ" , "VO3_NUMOSV" , "VO3_TIPTEM" }
Private aCposReq := {}
If lInconveniente
	aCposReq := { "VO3_NUMOSV" , "VO3_TIPTEM" , "VO3_GRUINC" , "VO3_CODINC" , "VO3_DESINC" , "VO3_SEQINC" , "VO3_OPER" , "VO3_CODTES" , "VO3_PROREQ" }
Else
	aCposReq := { "VO3_NUMOSV" , "VO3_TIPTEM" , "VO3_OPER" , "VO3_CODTES" , "VO3_PROREQ" }
EndIf
//
oReport := ReportDef()
oReport:PrintDialog()
RestArea( aArea )
//
Return

/*/{Protheus.doc} ReportDef
	ReportDef

	@author Andre Luis Almeida
	@since 26/01/2021
/*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oSection2
Local oSection3
Local nPosCpo := 0
Local nCntFor := 0
Local cTitCpo := ""
//
oReport := TReport():New("ORDBUSCC",STR0001,nil,{|oReport| OBUSCC_Impressao(oReport)}) // Transferencia de Peças entre OSs
oSection1 := TRSection():New(oReport,STR0002,{}) // Item
oSection2 := TRSection():New(oReport,STR0003,{}) // Transferência
oSection3 := TRSection():New(oReport,STR0004,{}) // Usuário
//
For nCntFor := 1 to len(aCposIte) // Campos do Item
	nPosCpo := FG_POSVAR(aCposIte[nCntFor],"aHeadVO3")
	TRCell():New(oSection1,aCposIte[nCntFor],,aHeadVO3[nPosCpo,1],aHeadVO3[nPosCpo,3],aHeadVO3[nPosCpo,4]*2,,&("{|| c"+aCposIte[nCntFor]+" }") )
Next
//
For nCntFor := 1 to len(aCposDev) // Campos da Origem - Devolucao
	nPosCpo := FG_POSVAR(aCposDev[nCntFor],"aHeadVO3")
	cTitCpo := aHeadVO3[nPosCpo,1]
	If aCposDev[nCntFor] == "VO3_NUMOSV"
		cTitCpo := STR0005 // OS Origem
	EndIf
	TRCell():New(oSection2,"D"+aCposDev[nCntFor],,cTitCpo,aHeadVO3[nPosCpo,3],aHeadVO3[nPosCpo,4],,&("{|| cD"+aCposDev[nCntFor]+" }") )
Next
For nCntFor := 1 to len(aCposReq) // Campos do Destino - Requisicao
	nPosCpo := FG_POSVAR(aCposReq[nCntFor],"aHeadVO3")
	cTitCpo := aHeadVO3[nPosCpo,1]
	If aCposReq[nCntFor] == "VO3_NUMOSV"
		cTitCpo := STR0006 // OS Destino
	EndIf
	TRCell():New(oSection2,"R"+aCposReq[nCntFor],,cTitCpo,aHeadVO3[nPosCpo,3],aHeadVO3[nPosCpo,4],,&("{|| cR"+aCposReq[nCntFor]+" }") )
Next
TRCell():New(oSection2,STR0007,,STR0008,"@!",25,,&("{|| cRNomProReq }")) // Nome | Nome Produtivo |
TRFunction():New(oSection2:Cell("DVO3_QTDREQ"),NIL,"SUM") // Totalizador
//
TRCell():New(oSection3,STR0004,,STR0004,"@!",100,,&("{|| cObsUsuario }")) // Codigo Usuário / Nome Usuario / Data / Hora || Usuário 	
//
oReport:SetTotalInLine(.t.)
oReport:SetLandScape()
oReport:DisableOrientation()
//
Return oReport

/*/{Protheus.doc} OBUSCC_Impressao
	Carrega variaveis para serem utilizadas nos Filtros dos Browse's para a Consulta

	@author Andre Luis Almeida
	@since 11/01/2021
/*/
Static Function OBUSCC_Impressao( oReport )
Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(2)
Local oSection3 := oReport:Section(3)
Local nCntFor   := 0
Local cQuebra   := "INICIAL"
Local nPosGrp   := FG_POSVAR("VO3_GRUITE","aHeadVO3")
Local nPosCod   := FG_POSVAR("VO3_CODITE","aHeadVO3")
Local nPosDes   := FG_POSVAR("VO3_DESITE","aHeadVO3")
Local nPosQtd   := FG_POSVAR("VO3_QTDREQ","aHeadVO3")
Local nPosNOS   := FG_POSVAR("VO3_NUMOSV","aHeadVO3")
Local nPosTTp   := FG_POSVAR("VO3_TIPTEM","aHeadVO3")
Local nPosOpe   := FG_POSVAR("VO3_OPER","aHeadVO3")
Local nPosTES   := FG_POSVAR("VO3_CODTES","aHeadVO3")
Local nPosPro   := FG_POSVAR("VO3_PROREQ","aHeadVO3")
Local nPosGrI   := FG_POSVAR("VO3_GRUINC","aHeadVO3")
Local nPosCdI   := FG_POSVAR("VO3_CODINC","aHeadVO3")
Local nPosDsI   := FG_POSVAR("VO3_DESINC","aHeadVO3")
Local nPosSqI   := FG_POSVAR("VO3_SEQINC","aHeadVO3")
//
Local nTamOSV  := GetSX3Cache("VO3_NUMOSV","X3_TAMANHO")
Local nTamTTp  := GetSX3Cache("VO3_TIPTEM","X3_TAMANHO")
//
oReport:SetMeter(len(aColsVO3))
//
Asort(aColsVO3,1,,{ |x,y| x[nPosGrp]+x[nPosCod] < y[nPosGrp]+y[nPosCod] })
//
For nCntFor := 1 to len(aColsVO3)
	oReport:IncMeter()
	If !aColsVO3[nCntFor,len(aColsVO3[nCntFor])]
		If cQuebra <> ( aColsVO3[nCntFor,nPosGrp] + aColsVO3[nCntFor,nPosCod] )
			If cQuebra <> "INICIAL"
				oSection2:Finish()
				oSection1:Finish()
			EndIf
			cVO3_GRUITE := aColsVO3[nCntFor,nPosGrp]
			cVO3_CODITE := aColsVO3[nCntFor,nPosCod]
			cVO3_DESITE := aColsVO3[nCntFor,nPosDes]
			oSection1:Init()
			oSection1:PrintLine()
			oSection2:Init()
			cQuebra := ( cVO3_GRUITE + cVO3_CODITE )
		EndIf
		cDVO3_QTDREQ := aColsVO3[nCntFor,nPosQtd]
		cDVO3_NUMOSV := left(aColsVO3[nCntFor,nPosNOS],nTamOSV)
		cDVO3_TIPTEM := right(aColsVO3[nCntFor,nPosNOS],nTamTTp)
		cRVO3_NUMOSV := cNrOSVO3 // Nro da OS de Destino ( Requisição )
		cRVO3_TIPTEM := aColsVO3[nCntFor,nPosTTp]
		If lInconveniente
			cRVO3_GRUINC := aColsVO3[nCntFor,nPosGrI]
			cRVO3_CODINC := aColsVO3[nCntFor,nPosCdI]
			cRVO3_DESINC := aColsVO3[nCntFor,nPosDsI]
			cRVO3_SEQINC := aColsVO3[nCntFor,nPosSqI]
		EndIf
		cRVO3_OPER   := aColsVO3[nCntFor,nPosOpe]
		cRVO3_CODTES := aColsVO3[nCntFor,nPosTES]
		cRVO3_PROREQ := aColsVO3[nCntFor,nPosPro]
		cRNomProReq  := FM_SQL("SELECT VAI_NOMTEC FROM "+RetSQLName("VAI")+" WHERE VAI_FILIAL='"+xFilial("VAI")+"' AND VAI_CODTEC='"+cRVO3_PROREQ+"' AND D_E_L_E_T_ = ' '")
		oSection2:PrintLine()
	EndIf
Next
If cQuebra <> "INICIAL"
	oSection2:Finish()
	oSection1:Finish()
EndIf
cObsUsuario := __cUserID+" - "
cObsUsuario += FM_SQL("SELECT VAI_NOMTEC FROM "+RetSQLName("VAI")+" WHERE VAI_FILIAL='"+xFilial("VAI")+"' AND VAI_CODUSR='"+__cUserID+"' AND D_E_L_E_T_ = ' '")+" "
cObsUsuario += Transform(dDataBase,"@D")+" "+time()
oSection3:Init()
oSection3:PrintLine()
oSection3:Finish()
//
Return Nil