#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ARGATENDVEI³ Autor ³ João Carlos da Silva ³ Data ³ 06/06/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impresión del atención de Argentina.                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ARGATENDVEI() // Impresión del atención de Argentina
	Local oReport
	Local cFilAte  := ParamIXB[1] // Filial do Atendimento
	Local cNumAte  := ParamIXB[2] // Nro do Atendimento
	Local cTitulo  := "Atención " + cNumAte
	Local cNomeRel := "Atención " + cNumAte
	Local cDesc1   := "Este informe imprimirá el atención de Argentina."
	Local cPerg    := ""

	oReport := RptDefOrc(oReport,cFilAte,cNumAte,cTitulo,cNomeRel,cDesc1,cPerg)
	oReport:nFontBody := 10
	oReport:oPage:nPaperSize := 9
	oReport:PrintDialog()
Return
//-----------------------------------------------------------------------------

/*/{Protheus.doc} RptDefOrc
Cria o relatório
@type function
@version 1.0
@author João Carlos da Silva
@since 06/06/2024
@param oReport, object, Objeto do relatório
@param cFilAte, character, Filial do atendimento
@param cNumAte, character, Número do atendimento
@param cTitulo, character, Título do relatório
@param cNomeRel, character, Nome do relatório
@param cDesc1, character, Descrição do relatório
@param cPerg, character, Pergunte do relatório
@return object, Objeto do relatório criado
/*/
Static Function RptDefOrc(oReport,cFilAte,cNumAte,cTitulo,cNomeRel,cDesc1,cPerg)
	Local oSection1

	Pergunte(cPerg, .F.)

	oReport := TReport():New(cNomeRel,cTitulo,cPerg,{|oReport| RunRptOrc(oReport,cFilAte,cNumAte)},cDesc1)

	oReport:SetLineHeight(45)

	oSection1 := TRSection():New(oReport)

Return oReport
//-----------------------------------------------------------------------------

/*/{Protheus.doc} RunRptOrc
Imprime o relatório
@type function
@version 1.0
@author João Carlos da Silva
@since 06/06/2024
@param oReport, object, Objeto do relatório
@param cFilAte, character, Filial do atendimento
@param cNumAte, character, Número do atendimento
/*/
Static Function RunRptOrc(oReport,cFilAte,cNumAte)
	Local oSection1  := oReport:Section(1)

	Local nLin       := 0260
	Local nCol       := 0060

	Local nLinIni    := nLin
	Local nLinLog    := 0
	Local nLinEmp    := 0
	Local nLinCli    := 0
	Local nLinIte    := 0

	Local cCliNom    := ""
	Local cCliEnd    := ""
	Local cCliCgc    := ""
	Local cCliCid    := ""

	Local nMoeda     := 0
	Local dEmissao   := CtoD("")
	Local cVendNom   := ""
	Local cVendCel   := ""
	Local cObs       := ""

	VV9->(DbSetOrder(1))
	VV9->(DbSeek(cFilAte+cNumAte))
	VV0->(DbSetOrder(1))
	VV0->(DbSeek(VV9->VV9_FILIAL+VV9->VV9_NUMATE))
	If !Empty(VV9->VV9_CODCLI+VV9->VV9_LOJA)
		SA1->(dbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+VV9->VV9_CODCLI+VV9->VV9_LOJA))
	EndIf
	SA3->(dbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3")+VV0->VV0_CODVEN))

	cCliNom  := SA1->A1_NOME
	cCliEnd  := SA1->A1_END
	cCliCgc  := SA1->A1_CGC
	cCliCid  := SA1->A1_MUN

	nMoeda   := VV0->VV0_MOEDA
	dEmissao := VV0->VV0_DATMOV
	cObs     := VV0->VV0_OBSMNF
	cVendNom := SA3->A3_NOME
	cVendCel := "+" + AllTrim(SA3->A3_DDI) + AllTrim(SA3->A3_CEL)

	oSection1:Init()
	nLinLog := fImpCabec(oReport,nLinIni,nCol,cNumAte,dEmissao)
	nLinEmp := fImpEmpre(oReport,nLinLog,nCol,cVendNom,cVendCel)
	nLinCli := fImpClien(oReport,nLinLog,nCol + 1300,cCliNom,cCliEnd,cCliCgc,cCliCid)
	nLinIte := fImpItens(oReport,Max(nLinEmp,nLinCli),nCol,cFilAte,cNumAte,nMoeda,cObs)
	oSection1:Finish()

	oReport:SetRow(nLinIte)

Return
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fImpCabec
Imprime os dados da empresa
@type function
@version 1.0
@author João Carlos da Silva
@since 06/06/2024
@param oReport, object, Objeto do relatório
@param nLin, numeric, Número da linha inicial do relatório
@param nCol, numeric, Número da coluna inicial do relatório
@param cNumAte, character, Número do atendimento
@param dEmissao, date, Data do atendimento
@return numeric, Número da linha atual do relatório
/*/
Static Function fImpCabec(oReport,nLin,nCol,cNumAte,dEmissao)
	//                  TFont():New(cName        ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
	Local oFont12b   := TFont():New("Courier New",9    ,12     ,.T.  ,.T.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )

	oReport:Say(nLin,nCol+1700,"Presupuesto Nro.: " + cNumAte       ,oFont12b)
	nLin+=0060
	nLin+=0030

	oReport:Say(nLin,nCol+1700,"Fecha de Emisión: " + DtoC(dEmissao),oFont12b)
	nLin+=0060
	nLin+=0060

Return(nLin)
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fImpEmpre
Imprime os dados da empresa
@type function
@version 1.0
@author João Carlos da Silva
@since 06/06/2024
@param oReport, object, Objeto do relatório
@param nLin, numeric, Número da linha inicial do relatório
@param nCol, numeric, Número da coluna inicial do relatório
@param cVendNom, character, Nome do vendedor
@param cVendCel, character, Celular do vendedor
@return numeric, Número da linha atual do relatório
/*/
Static Function fImpEmpre(oReport,nLin,nCol,cVendNom,cVendCel)
	//                  TFont():New(cName        ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
	Local oFont12n   := TFont():New("Courier New",9    ,12     ,.T.  ,.F.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )
	Local oFont12b   := TFont():New("Courier New",9    ,12     ,.T.  ,.T.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )

	Local cNome      := SM0->M0_NOMECOM
	Local cEnd       := SM0->M0_ENDENT
	Local cCid       := SM0->M0_CIDENT
	Local cTel       := SM0->M0_TEL
	Local cCgc       := SM0->M0_CGC

	Local cEndereco  := AllTrim(cEnd) + ", " + AllTrim(cCid)

	Local cMaskCgc   := PesqPict("SA1","A1_CGC")

	oReport:Say(nLin,nCol+0000,"Datos del concesionario"          ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,cNome                              ,oFont12n)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"CUIT: " + Transform(cCgc,cMaskCgc),oFont12n)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Tel: " + cTel                     ,oFont12n)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Dir: " + cEndereco                ,oFont12n)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Vendedor: " + cVendNom            ,oFont12n)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Cel. vendedor: " + cVendCel       ,oFont12n)
	nLin+=0060

Return(nLin)
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fImpClien
Imprime os dados do cliente
@type function
@version 1.0
@author João Carlos da Silva
@since 06/06/2024
@param oReport, object, Objeto do relatório
@param nLin, numeric, Número da linha inicial do relatório
@param nCol, numeric, Número da coluna inicial do relatório
@param cCliNom, character, Nome do cliente
@param cCliEnd, character, Endereço do cliente
@param cCliCgc, character, CGC do cliente
@param cCliCid, character, Cidade do cliente
@return numeric, Número da linha atual do relatório
/*/
Static Function fImpClien(oReport,nLin,nCol,cCliNom,cCliEnd,cCliCgc,cCliCid)
	//                  TFont():New(cName        ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
	Local oFont12n   := TFont():New("Courier New",9    ,12     ,.T.  ,.F.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )
	Local oFont12b   := TFont():New("Courier New",9    ,12     ,.T.  ,.T.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )

	Local cMaskCgc   := PesqPict("SA1","A1_CGC")

	oReport:Say(nLin,nCol+0000,"Datos del cliente"                                 ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Nombre: " + cCliNom                                ,oFont12n)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"CUIT: " + Transform(cCliCgc,cMaskCgc)              ,oFont12n)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Loc: " + AllTrim(cCliEnd) + ", " + AllTrim(cCliCid),oFont12n)
	nLin+=0060

Return(nLin)
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fImpItens
Imprime os itens do orçamento
@type function
@version 1.0
@author João Carlos da Silva
@since 06/06/2024
@param oReport, object, Objeto do relatório
@param nLin, numeric, Número da linha inicial do relatório
@param nCol, numeric, Número da coluna inicial do relatório
@param cFilAte, character, Filial do atendimento
@param cNumAte, character, Número do atendimento
@param nMoeda, numeric, Moeda do atendimento
@param cObs, character, Observação do atendimento
@return numeric, Número da linha atual do relatório
/*/
Static Function fImpItens(oReport,nLin,nCol,cFilAte,cNumAte,nMoeda,cObs)
	//                  TFont():New(cName        ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
	Local oFont12n   := TFont():New("Courier New",9    ,12     ,.T.  ,.F.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )
	Local oFont12b   := TFont():New("Courier New",9    ,12     ,.T.  ,.T.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )

	Local lVVACODMAR := ( VVA->(FieldPos("VVA_CODMAR")) > 0 )
	Local cSQLAlias  := "SQLVS9"
	Local nVlNeg     := 0
	Local cQuery     := ""

	Local nValVei    := 0
	Local nValIva    := 0
	Local nValTot    := 0
	Local nValVeiT   := 0
	Local nValIvaT   := 0
	Local nValTotT   := 0
	Local nPerIva    := 0

	Local nValPag    := 0
	Local nValPen    := 0
	Local nParcelas  := 0

	Local cCodMar    := ""
	Local cDesMar    := ""
	Local cModelo    := ""
	Local cMoeda     := GetMV("MV_SIMB" + If(nMoeda<=1,"1",StrZero(nMoeda,1)))
	Local cModVei    := ""

	Local nObs       := 0
	Local cObsMem    := ""
	Local nObsMem    := ""

	Local cMaskVal   := "@E 999,999,999,999.99"

	nLin+=0030
	oReport:Say(nLin,nCol+0000,"PRODUCTOS COTIZADOS" ,oFont12n)
	nLin+=0060

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

	nLin+=0020

	nValVeiT := 0
	nValIvaT := 0
	nValTotT := 0

	VVA->(DbSetOrder(1))
	VVA->(DbSeek(cFilAte+cNumAte))
	While VVA->(!Eof() .and. VVA_FILIAL == cFilAte .and. VVA_NUMTRA == cNumAte)

		If !Empty(VVA->VVA_CHAINT)
			VV1->(DbSetOrder(1))
			VV1->(DbSeek(xFilial("VV1")+VVA->VVA_CHAINT))
		EndIf

		If lVVACODMAR
			cCodMar := VVA->VVA_CODMAR
			cModVei := VVA->VVA_MODVEI
		Else
			cCodMar := VV0->VV0_CODMAR
			cModVei := VV0->VV0_MODVEI
		EndIf

		VE1->(dbSetOrder(1))
		VE1->(dbSeek(xFilial("VE1") + cCodMar)) // Posiciona no VE1
		cDesMar := VE1->VE1_DESMAR

		VV2->(DbSetOrder(1))
		VV2->(DbSeek(xFilial("VV2") + cCodMar + cModVei)) // Posiciona no VV2
		cModelo := VV2->VV2_DESMOD

		nPerIva := 0

		nValVei := VVA->VVA_VALMOV
		nValIva := nValVei * nPerIva / 100
		nValTot := nValVei + nValIva

		nValVeiT += nValVei
		nValIvaT += nValIva
		nValTotT += nValTot

		nLin+=0020
		oReport:Say(nLin,nCol+0000,"Marca: " + cCodMar + " " + cDesMar                         ,oFont12b)
		oReport:Say(nLin,nCol+1500,"Precio:"                                                   ,oFont12b)
		oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValVei,cMaskVal),20)         ,oFont12b)
		nLin+=0060
		oReport:Say(nLin,nCol+0000,"Modelo: " + cModelo                                        ,oFont12b)
		oReport:Say(nLin,nCol+1500,"Monto IVA (" + AllTrim(Transform(nPerIva,cMaskVal)) + "%):",oFont12b)
		oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValIva,cMaskVal),20)         ,oFont12b)
		nLin+=0060
		oReport:Say(nLin,nCol+1500,"Precio Final: "                                            ,oFont12b)
		oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValTot,cMaskVal),20)         ,oFont12b)
		nLin+=0060

		nLin+=0020

		VVA->(DbSkip())
	EndDo

	nLin+=0030
	oReport:Say(nLin,nCol+0000,"Condiciones Gerales" ,oFont12n)
	nLin+=0060

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

	nLin+=0020

	nLin+=0020
	oReport:Say(nLin,nCol+1500,"Subtotal Máquinas:"                                        ,oFont12b)
	oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValVeiT,cMaskVal),20)        ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+1500,"Total IVA (" + AllTrim(Transform(nPerIva,cMaskVal)) + "%):",oFont12b)
	oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValIvaT,cMaskVal),20)        ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+1500,"Total IVA Incluido: "                                      ,oFont12b)
	oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValTotT,cMaskVal),20)        ,oFont12b)
	nLin+=0060

	nLin+=0020

	nVlNeg := VV0->VV0_VALFPR // Financiamento Proprio - Utilizar Valor Total (VV0_VALFPR), pois o VS9 esta com o Juros embutido no Valor

	cQuery := "SELECT VS9.VS9_TIPPAG , VS9.VS9_DATPAG , VS9.VS9_VALPAG , VS9.VS9_REFPAG , VS9.VS9_SEQUEN , VSA.VSA_DESPAG , VSA.VSA_TIPO FROM "+RetSQLName("VS9")+" VS9 "
	cQuery += "INNER JOIN "+RetSQLName("VSA")+" VSA ON ( VSA.VSA_FILIAL='"+xFilial("VSA")+"' AND VSA.VSA_TIPPAG=VS9.VS9_TIPPAG AND VSA.D_E_L_E_T_=' ' ) "
	cQuery += "WHERE VS9.VS9_FILIAL='"+xFilial("VS9")+"' AND VS9.VS9_NUMIDE='"+cNumAte+"' AND VS9.VS9_TIPOPE='V' AND VS9.D_E_L_E_T_=' '"
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cSQLAlias , .F. , .T. )

	nLin+=0030
	oReport:Say(nLin,nCol+0000,"FORMA DE PAGO" ,oFont12n)
	nLin+=0060

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

	nLin+=0020

	nLin+=0020
	oReport:Say(nLin,nCol+0000,"Forma de Pago"                                             ,oFont12b)
	oReport:Say(nLin,nCol+2000,PadL("Monto",20)                                            ,oFont12b)
	nLin+=0060

	nValPag   := 0
	nParcelas := 0

	While !(cSQLAlias)->(Eof())

		nValPag += (cSQLAlias)->VS9_VALPAG
		nParcelas++

		oReport:Say(nLin,nCol+0000,Transform(stod((cSQLAlias)->VS9_DATPAG),"@D") + " " + (cSQLAlias)->VS9_TIPPAG + "-" + Alltrim((cSQLAlias)->VSA_DESPAG),oFont12b)
		oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform((cSQLAlias)->VS9_VALPAG,cMaskVal),20)                                                   ,oFont12b)
		nLin+=0060

		(cSQLAlias)->(dbSkip())
	EndDo
	(cSQLAlias)->(dbCloseArea())

	nValPen := nValTotT - nValPag

	oReport:Say(nLin,nCol+0000,"TOTAL Forma de Pago:"                                          ,oFont12b)
	oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValPag,cMaskVal),20)             ,oFont12b)
	nLin+=0060

	nLin+=0060
	oReport:Say(nLin,nCol+1500,"Pendiente:"                                                    ,oFont12b)
	oReport:Say(nLin,nCol+2000,PadL(cMoeda + " " + Transform(nValPen,cMaskVal),20)             ,oFont12b)
	nLin+=0060

	nLin+=0020

	nLin+=0030
	oReport:Say(nLin,nCol+0000,"Condiciones de pago: " + AllTrim(Str(nParcelas)),oFont12n)
	nLin+=0060

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

	nLin+=0030
	oReport:Say(nLin,nCol+0000,"OBSERVACIONES" ,oFont12n)
	nLin+=0060

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

	nLin+=0030

	cObsMem := MSMM(cObs,,,,3,,,"VV0")
	If !Empty(cObsMem)
		nObsMem := MlCount(cObsMem,100,,.T.)
		For nObs := 1 to nObsMem
			oReport:Say(nLin,nCol+0000,MemoLine(cObsMem,100,nObs,,.T.),oFont12n)
			nLin+=0060
		Next
	EndIf

	nLin+=0020

Return(nLin)
//-----------------------------------------------------------------------------
