#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ARGORCAMTO³ Autor ³ João Carlos da Silva  ³ Data ³ 29/05/24 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impresión del presupuesto de Argentina.                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ARGORCAMTO() // Impresión del presupuesto de Argentina
	Local oReport
	Local cOrc     := ParamIXB[1]
	Local cTitulo  := "Presupuesto " + cOrc
	Local cNomeRel := "Presupuesto " + cOrc
	Local cDesc1   := "Este informe imprimirá el presupuesto de Argentina."
	Local cPerg    := "ORCAMT"

	oReport := RptDefOrc(oReport,cOrc,cTitulo,cNomeRel,cDesc1,cPerg)
	oReport:nFontBody := 10
	oReport:oPage:nPaperSize := 9
	oReport:SetRightAlignPrinter(.T.)
	oReport:PrintDialog()
Return
//-----------------------------------------------------------------------------

/*/{Protheus.doc} RptDefOrc
Cria o relatório
@type function
@version 1.0
@author João Carlos da Silva
@since 05/06/2024
@param oReport, object, Objeto do relatório
@param cOrc, character, Número do orçamento
@param cTitulo, character, Título do relatório
@param cNomeRel, character, Nome do relatório
@param cDesc1, character, Descrição do relatório
@param cPerg, character, Pergunte do relatório
@return object, Objeto do relatório criado
/*/
Static Function RptDefOrc(oReport,cOrc,cTitulo,cNomeRel,cDesc1,cPerg)
	Local oSection1

	Pergunte(cPerg, .F.)

	oReport := TReport():New(cNomeRel,cTitulo,cPerg,{|oReport| RunRptOrc(oReport,cOrc)},cDesc1)

	oReport:SetLineHeight(45)

	oSection1 := TRSection():New(oReport)

Return oReport
//-----------------------------------------------------------------------------

/*/{Protheus.doc} RunRptOrc
Imprime o relatório
@type function
@version 1.0
@author João Carlos da Silva
@since 05/06/2024
@param oReport, object, Objeto do relatório
@param cOrc, character, Número do orçamento
/*/
Static Function RunRptOrc(oReport,cOrc)
	Local oSection1 := oReport:Section(1)
	Local nLin      := 0260
	Local nCol      := 0060

	DbSelectArea("VS1")
	DbSetOrder(1)
	DbSeek(xFilial("VS1")+cOrc)

	DbSelectArea("VV1")
	DbSetOrder(1)
	DbSeek(xFilial("VV1")+VS1->VS1_CHAINT)

	DbSelectArea("VV2")
	DbSetOrder(4)
	DbSeek(xFilial("VV2")+VV1->VV1_MODVEI)

	DbSelectArea("VVC")
	DbSetOrder(1)
	DbSeek(xFilial("VVC")+VV1->VV1_CODMAR+VV1->VV1_CORVEI)

	DbSelectArea("SE4")
	DbSetOrder(1)
	DbSeek(xFilial("SE4")+VS1->VS1_FORPAG)

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+VS1->VS1_CLIFAT+VS1->VS1_LOJA)

	oSection1:Init()
	nLin := fImpEmpre(oReport,nLin,nCol)
	nLin := fImpClien(oReport,nLin,nCol)
	nLin := fImpItens(oReport,nLin,nCol)
	oSection1:Finish()

Return
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fImpEmpre
Imprime os dados da empresa
@type function
@version 1.0
@author João Carlos da Silva
@since 05/06/2024
@param oReport, object, Objeto do relatório
@param nLin, numeric, Número da linha inicial do relatório
@param nCol, numeric, Número da coluna inicial do relatório
@return numeric, Número da linha atual do relatório
/*/
Static Function fImpEmpre(oReport,nLin,nCol)
	//                  TFont():New(cName        ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
	Local oFont12n   := TFont():New("Courier New",9    ,12     ,.T.  ,.F.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )
	Local oFont12b   := TFont():New("Courier New",9    ,12     ,.T.  ,.T.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )

	Local cNome      := SM0->M0_NOMECOM
	Local cEnd       := SM0->M0_ENDENT
	Local cCid       := SM0->M0_CIDENT
	Local cBai       := SM0->M0_BAIRENT
	Local cEst       := SM0->M0_ESTENT
	Local cCep       := SM0->M0_CEPENT
	Local cTel       := SM0->M0_TEL
	Local cCgc       := SM0->M0_CGC

	Local cMaskCgc   := PesqPict("SA1","A1_CGC")

	oReport:Say(nLin,nCol+0000,"Empresa           :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cNome                   ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Domicilio         :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cEnd                    ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Barrio            :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cBai                    ,oFont12b)
	oReport:Say(nLin,nCol+1000,"Provincia:"            ,oFont12n)
	oReport:Say(nLin,nCol+1240,cEst                    ,oFont12b)
	oReport:Say(nLin,nCol+1700,"Cód.Postal: "          ,oFont12n)
	oReport:Say(nLin,nCol+1960,cCep                    ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Localidad         :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cCid                    ,oFont12b)
	oReport:Say(nLin,nCol+1000,"Teléfono :"            ,oFont12n)
	oReport:Say(nLin,nCol+1240,cTel                    ,oFont12b)
	oReport:Say(nLin,nCol+1700,"C.U.I.T.  :"           ,oFont12n)
	oReport:Say(nLin,nCol+1960,Transform(cCgc,cMaskCgc),oFont12b)
	nLin+=0060

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

Return(nLin)
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fImpClien
Imprime os dados do cliente
@type function
@version 1.0
@author João Carlos da Silva
@since 05/06/2024
@param oReport, object, Objeto do relatório
@param nLin, numeric, Número da linha inicial do relatório
@param nCol, numeric, Número da coluna inicial do relatório
@return numeric, Número da linha atual do relatório
/*/
Static Function fImpClien(oReport,nLin,nCol)
	//                  TFont():New(cName        ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
	Local oFont12n   := TFont():New("Courier New",9    ,12     ,.T.  ,.F.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )
	Local oFont12b   := TFont():New("Courier New",9    ,12     ,.T.  ,.T.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )

	Local cNome      := SA1->A1_NOME
	Local cEnd       := SA1->A1_END
	Local cBairro    := SA1->A1_BAIRRO
	Local cCgc       := SA1->A1_CGC
//	Local cTel       := SA1->A1_TEL
//	Local cEst       := SA1->A1_EST
	Local cTipo      := SA1->A1_TIPO
	Local cCid       := SA1->A1_MUN

	Local dDatOrc    := VS1->VS1_DATORC
	Local cVeic      := AllTrim(VV1->VV1_MODVEI) + " " + AllTrim(VV2->VV2_DESMOD)// + " - " + AllTrim(VV1->VV1_COMVEI) + " - " + Alltrim(OFIOA560DS("076", VV1->VV1_COMVEI))
	Local cSerie     := VV1->VV1_CHASSI
	Local cCondP     := SE4->E4_DESCRI

	Local aComboTipo := {}
	Local nComboTipo := 0
	Local cComboTipo := ""

	Local cMaskCgc   := PesqPict("SA1","A1_CGC")

	aComboTipo := RetSX3Box(GetSX3Cache("A1_TIPO","X3_CBOXSPA"),Nil,1,1,Nil)
	nComboTipo := Ascan(aComboTipo,{|x| x[2] == cTipo})
	If nComboTipo > 0
		cComboTipo := aComboTipo[nComboTipo,3]
	Else
		cComboTipo := "N/D"
	EndIf

	nLin+=0030

	oReport:Say(nLin,nCol+0000,"Cliente           :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cNome                   ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Domicilio         :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cEnd                    ,oFont12b)
	oReport:Say(nLin,nCol+1700,"Fecha     :"           ,oFont12n)
	oReport:Say(nLin,nCol+1960,DtoC(dDatOrc),oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Barrio            :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cBairro                 ,oFont12b)
	oReport:Say(nLin,nCol+1000,"I.V.A.   :"            ,oFont12n)
	oReport:Say(nLin,nCol+1240,cComboTipo              ,oFont12b)
	oReport:Say(nLin,nCol+1700,"C.U.I.T.  :"           ,oFont12n)
	oReport:Say(nLin,nCol+1960,Transform(cCgc,cMaskCgc),oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Localidad         :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cCid                    ,oFont12b)
	oReport:Say(nLin,nCol+1700,"I.Bruto   :"           ,oFont12n)
	oReport:Say(nLin,nCol+1960,cCgc                    ,oFont12b)
	nLin+=0060

	oReport:Say(nLin,nCol+0000,"Condición de Venta:"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cCondP                  ,oFont12b)
	nLin+=0060

	oReport:Say(nLin,nCol+0000,"Vehículo          :"   ,oFont12n)
	oReport:Say(nLin,nCol+0420,cVeic                   ,oFont12b)
	oReport:Say(nLin,nCol+1700,"Serie/Vin :"           ,oFont12n)
	oReport:Say(nLin,nCol+1960,cSerie                  ,oFont12b)
	nLin+=0060

Return(nLin)
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fImpItens
Imprime os itens do orçamento
@type function
@version 1.0
@author João Carlos da Silva
@since 05/06/2024
@param oReport, object, Objeto do relatório
@param nLin, numeric, Número da linha inicial do relatório
@param nCol, numeric, Número da coluna inicial do relatório
@return numeric, Número da linha atual do relatório
/*/
Static Function fImpItens(oReport,nLin,nCol)
	//                  TFont():New(cName        ,uPar2,nHeight,uPar4,lBold,uPar6,uPar7,uPar8,uPar9,lUnderline,lItalic)
	Local oFont12n   := TFont():New("Courier New",9    ,12     ,.T.  ,.F.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )
	Local oFont12b   := TFont():New("Courier New",9    ,12     ,.T.  ,.T.  ,5    ,.T.  ,5    ,.T.  ,.F.       ,.F.    )

	Local nDadosPec  := 0
	Local nDadosSer  := 0

	Local nPerIva    := 0
	Local nPerIvaX   := 0
	Local nValIva    := 0
	Local nValIvaX   := 0
	Local nValSub    := 0
	Local nValDes    := 0
	Local nValGer    := 0
	Local nPerDes    := 0

	Local nQtdIte    := 0
	Local nQtdPro    := 0
	Local nValTot    := 0
	Local nValDol    := 0

	Local nPosGru    := 0
	Local nPosCod    := 0
	Local nPosQtd    := 0
	Local nPosPec    := 0
	Local nPosDes    := 0
	Local nPosTot    := 0
	Local nPosDsc    := 0

	Local dDatOrc    := VS1->VS1_DATORC
	Local dDatVal    := VS1->VS1_DATVAL
	Local nMoeda     := VS1->VS1_MOEDA
	Local nTxMoeda   := VS1->VS1_TXMOED
	Local nDolar     := If(nTxMoeda > 0, nTxMoeda, RecMoeda(dDatOrc,2))
	Local nDias      := dDatVal - dDatOrc

	Local cMaskPec   := PesqPict("VS3","VS3_VALPEC")
	Local cMaskQtd   := PesqPict("VS3","VS3_QTDITE")
	Local cMaskTot   := PesqPict("VS3","VS3_VALTOT")

	Local aObs       :={}
	Local nObs       := 0
	Local cObsMem    := ""
	Local nObsMem    := ""

	If nMoeda > 1 // Dolar
		AAdd(aObs,"Son DÓLARES [nValGer] los cuales podrán ser cancelados en pesos al tipo de cambio vendedor del Banco de la")
		AAdd(aObs,"Nación Argentina vigente al momento de pago. A los fines fiscales: Tipo de cambio: U$S 1 = $ [nDolar]")
	Else
		AAdd(aObs,"Equivale a [nValDol] DÓLARES, al tipo de cambio vendedor del Banco de la Nación Argentina, vigente al")
		AAdd(aObs,"momento de emisión del comprobante.")
	EndIf

	nLin+=0010

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

	nLin+=0020
	oReport:Say(nLin,nCol+0000,"Artículo"            ,oFont12b)
	oReport:Say(nLin,nCol+0400,"Ind."                ,oFont12b)
	oReport:Say(nLin,nCol+0700,"Denominación"        ,oFont12b)
	oReport:Say(nLin,nCol+1400,PadL("Pcio. Final",20),oFont12b)
	oReport:Say(nLin,nCol+1700,PadL("Cant."      ,20),oFont12b)
	oReport:Say(nLin,nCol+2000,PadL("SubTotal"   ,20),oFont12b)
	nLin+=0060

	nLin+=0010
	oReport:SetRow(nLin)
	oReport:FatLine()
	nLin+=0010

	nLin+=0020

	aDadosPec := fDadosPec(VS1->VS1_NUMORC) // Peças
	If Len(aDadosPec) > 0
		nPosGru := Ascan(aDadosPec[1],{|x| x[1] == "VS3_GRUITE"})
		nPosCod := Ascan(aDadosPec[1],{|x| x[1] == "VS3_CODITE"})
		nPosQtd := Ascan(aDadosPec[1],{|x| x[1] == "VS3_QTDITE"})
		nPosPec := Ascan(aDadosPec[1],{|x| x[1] == "VS3_VALPEC"})
		nPosDes := Ascan(aDadosPec[1],{|x| x[1] == "VS3_VALDES"})
		nPosTot := Ascan(aDadosPec[1],{|x| x[1] == "VS3_VALTOT"})
		nPosDsc := Ascan(aDadosPec[1],{|x| x[1] == "B1_DESC"   })
		For nDadosPec := 1 to Len(aDadosPec)
			If MV_PAR04 # 1
				oReport:Say(nLin,nCol+0000,aDadosPec[nDadosPec,nPosCod,2],oFont12n)
				oReport:Say(nLin,nCol+0400,aDadosPec[nDadosPec,nPosGru,2],oFont12n)
			EndIf

			oReport:Say(nLin,nCol+0700,aDadosPec[nDadosPec,nPosDsc,2],oFont12n)

			If MV_PAR03 # 1
				oReport:Say(nLin,nCol+1400,PadL(AllTrim(Transform(aDadosPec[nDadosPec,nPosPec,2],cMaskPec)),20),oFont12n)
			Else
				oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(aDadosPec[nDadosPec,nPosTot,2],cMaskTot)),20),oFont12n)
			EndIf

			oReport:Say(nLin,nCol+1700,PadL(AllTrim(Transform(aDadosPec[nDadosPec,nPosQtd,2],cMaskQtd)),20),oFont12n)
			oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(aDadosPec[nDadosPec,nPosTot,2],cMaskTot)),20),oFont12n)
			nLin+=0060

			nQtdPro++
			nQtdIte += aDadosPec[nDadosPec,nPosQtd,2]
			nValTot += aDadosPec[nDadosPec,nPosTot,2]
			nValDes += aDadosPec[nDadosPec,nPosDes,2]
		Next
	EndIf

	aDadosSer := fDadosSer(VS1->VS1_NUMORC,VS1->VS1_TIPORC) // Serviços
	If Len(aDadosSer) > 0
		nPosGru := Ascan(aDadosSer[1],{|x| x[1] == "VS4_GRUSER"})
		nPosCod := Ascan(aDadosSer[1],{|x| x[1] == "VS4_CODSER"})
		nPosDes := Ascan(aDadosSer[1],{|x| x[1] == "VS4_VALDES"})
		nPosTot := Ascan(aDadosSer[1],{|x| x[1] == "VS4_VALTOT"})
		nPosDsc := Ascan(aDadosSer[1],{|x| x[1] == "VO6_DESSER"})
		For nDadosSer := 1 to Len(aDadosSer)
			If MV_PAR05 # 1
				oReport:Say(nLin,nCol+0000,aDadosSer[nDadosSer,nPosCod,2],oFont12n)
				oReport:Say(nLin,nCol+0400,aDadosSer[nDadosSer,nPosGru,2],oFont12n)
			EndIf
			oReport:Say(nLin,nCol+0700,aDadosSer[nDadosSer,nPosDsc,2]                                      ,oFont12n)
			oReport:Say(nLin,nCol+1400,PadL(AllTrim(Transform(aDadosSer[nDadosSer,nPosTot,2],cMaskTot)),20),oFont12n)
			oReport:Say(nLin,nCol+1700,PadL(AllTrim(Transform(1                             ,cMaskQtd)),20),oFont12n)
			oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(aDadosSer[nDadosSer,nPosTot,2],cMaskTot)),20),oFont12n)
			nLin+=0060
			nQtdIte++
			nQtdPro++
			nValTot += aDadosSer[nDadosSer,nPosTot,2]
			If MV_PAR03 # 1
				nValDes += aDadosSer[nDadosSer,nPosDes,2]
			EndIf
		Next
	EndIf

	If Len(aDadosPec) > 0 .or. Len(aDadosSer) > 0
		nLin+=0010
		oReport:SetRow(nLin)
		oReport:FatLine()
		nLin+=0010
	EndIf

	nPerDes  := Round(nValDes / nValTot * 100,2)
	nValSub  := nValTot -nValDes
	nValIva  := nValTot * nPerIva / 100
	nPerIvaX := nValSub * nPerIvaX / 100
	nValGer  := nValSub + nValIva + nValIvaX

	nLin+=0030
	oReport:Say(nLin,nCol+0100,"Cant.Items"                                        ,oFont12n)
	oReport:Say(nLin,nCol+0300,Str(nQtdIte)                                        ,oFont12b)
	oReport:Say(nLin,nCol+1600,"Gravado . . . . ."                                 ,oFont12n)
	oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(nValTot,cMaskTot)),20)       ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0100,"Cant.Artículos"                                    ,oFont12n)
	oReport:Say(nLin,nCol+0300,Str(nQtdPro)                                        ,oFont12b)
	oReport:Say(nLin,nCol+1600,"Descuento . "                                      ,oFont12n)
	oReport:Say(nLin,nCol+1850,PadL(AllTrim(Transform(nPerDes,cMaskTot)),07) + "%" ,oFont12n)
	oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(nValDes,cMaskTot)),20),oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+1600,"Subtotal . . . . ."                                ,oFont12n)
	oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(nValSub,cMaskTot)),20)       ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+1600,"I.V.A. . . ."                                      ,oFont12n)
	oReport:Say(nLin,nCol+1850,PAdL(AllTrim(Transform(nPerIva,cMaskTot)),07) + "%" ,oFont12n)
	oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(nValIva,cMaskTot)),20)       ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+1600,"Perc. I.V.A. . . ."                                ,oFont12n)
	oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(nPerIvaX,cMaskTot)),20)      ,oFont12b)
	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Válido por " + AllTrim(Str(nDias)) + " días."      ,oFont12b)
	oReport:Say(nLin,nCol+1600,"T O T A L . . . . ."                               ,oFont12n)
	oReport:Say(nLin,nCol+2000,PadL(AllTrim(Transform(nValGer,cMaskTot)),20)       ,oFont12b)
	nLin+=0060

	nValDol := nValGer / nDolar

	For nObs := 1 to Len(aObs)
		aObs[nObs] := StrTran(aObs[nObs],"[nValGer]",AllTrim(Transform(nValGer,cMaskTot)))
		aObs[nObs] := StrTran(aObs[nObs],"[nValDol]",AllTrim(Transform(nValDol,cMaskTot)))
		aObs[nObs] := StrTran(aObs[nObs],"[nDolar]" ,AllTrim(Transform(nDolar ,cMaskTot)))
		oReport:Say(nLin,nCol+0000,aObs[nObs],oFont12n)
		nLin+=0060
	Next

	nLin+=0060
	oReport:Say(nLin,nCol+0000,"Observaciones:",oFont12n)
	nLin+=0060

	cObsMem := MSMM(VS1->VS1_OBSMEM,,,,3,,,"VS1")
	If !Empty(cObsMem)
		nObsMem := MlCount(cObsMem,100,,.T.)
		For nObs := 1 to nObsMem
			oReport:Say(nLin,nCol+0000,MemoLine(cObsMem,100,nObs,,.T.),oFont12n)
			nLin+=0060
		Next
	EndIf

Return(nLin)
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fDadosPec
Monta o array com os dados das peças do orçamento
@type function
@version 1.0
@author João Carlos da Silva
@since 05/06/2024
@param cOrc, character, Número do orçamento
@return array, Dados das peças do orçamento
/*/
Static Function fDadosPec(cOrc) // Peças
	Local aDados    := {}
	Local aDados0   := {}
	Local cAliasQry := "PECORC"

	BeginSql Alias cAliasQry
		SELECT VS3_GRUITE,VS3_CODITE,VS3_QTDITE,VS3_VALPEC,VS3_VALDES,VS3_VALTOT,B1_DESC
		FROM %Table:VS3% VS3

		JOIN %Table:SB1% SB1
		ON SB1.%NotDel%
		AND B1_FILIAL = %xFilial:SB1%
		AND B1_GRUPO = VS3_GRUITE
		AND B1_COD = VS3_CODITE

		WHERE VS3.%NotDel%
		AND VS3_FILIAL = %xFilial:VS3%
		AND VS3_NUMORC = %Exp:cOrc%
		AND VS3_MOTPED = ' '"
		AND VS3_QTDITE > 0"
	EndSql

	While (cAliasQry)->(!Eof())
		aDados0 := {}
		AAdd(aDados0,{"VS3_GRUITE",(cAliasQry)->VS3_GRUITE})
		AAdd(aDados0,{"VS3_CODITE",(cAliasQry)->VS3_CODITE})
		AAdd(aDados0,{"VS3_QTDITE",(cAliasQry)->VS3_QTDITE})
		AAdd(aDados0,{"VS3_VALPEC",(cAliasQry)->VS3_VALPEC})
		AAdd(aDados0,{"VS3_VALDES",(cAliasQry)->VS3_VALDES})
		AAdd(aDados0,{"VS3_VALTOT",(cAliasQry)->VS3_VALTOT})
		AAdd(aDados0,{"B1_DESC"   ,(cAliasQry)->B1_DESC   })
		AAdd(aDados,aDados0)

		(cAliasQry)->(DbSkip())
	End

	(cAliasQry)->(DbCloseArea())

Return(aDados)
//-----------------------------------------------------------------------------

/*/{Protheus.doc} fDadosSer
Monta o array com os dados dos serviços do orçamento
@type function
@version 1.0
@author João Carlos da Silva
@since 05/06/2024
@param cOrc, character, Número do orçamento
@return array, Dados dos serviços do orçamento
/*/
Static Function fDadosSer(cOrc,cTipOrc) // Serviços
	Local aDados    := {}
	Local aDados0   := {}
	Local cAliasQry := "SERVORC"

	If cTipOrc <> "2"
		Return(aDados)
	EndIf

	BeginSql Alias cAliasQry
		SELECT VS4_GRUSER,VS4_CODSER,VS4_VALDES,VS4_VALTOT
		FROM %Table:VS4% VS4

		WHERE VS4.%NotDel%
		AND VS4_FILIAL = %xFilial:VS4%
		AND VS4_NUMORC = %Exp:cOrc%
	EndSql

	While (cAliasQry)->(!Eof())
		DbSelectArea("VO6")
		DbSetOrder(2)
		DbSeek(xFilial("VO6")+FG_MARSRV(VS1->VS1_CODMAR, (cAliasQry)->VS4_CODSER)+(cAliasQry)->VS4_CODSER)

		aDados0 := {}
		AAdd(aDados0,{"VS4_GRUSER",(cAliasQry)->VS4_GRUSER})
		AAdd(aDados0,{"VS4_CODSER",(cAliasQry)->VS4_CODSER})
		AAdd(aDados0,{"VO6_DESSER",VO6->VO6_DESSER        })
		AAdd(aDados0,{"VS4_VALDES",(cAliasQry)->VS4_VALDES})
		AAdd(aDados0,{"VS4_VALTOT",(cAliasQry)->VS4_VALTOT})
		AAdd(aDados,aDados0)

		(cAliasQry)->(DbSkip())
	End

	(cAliasQry)->(DbCloseArea())

Return(aDados)
//-----------------------------------------------------------------------------
