// ÉÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍ»
// º Versao º   2   º
// ÈÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍ¼
#INCLUDE "rwmake.ch"
#INCLUDE "PREFECT2.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PREFECT2 º Autor ³ Microsiga          º Data ³  25/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime resultado do pré-fechamento                        º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PREFECT2()
	Local oReport
	Private aOS     := ParamIXB[1]
	Private cTitulo := STR0001 //Pré-Fechamento

	oReport := ReportDef() // Nesta função nós definimos a estrutura do relatório, por exemplo as seções, campos, totalizadores e etc.
	oReport:PrintDialog()  // Essa função serve para disparar a impressão do TReport, ela que faz com que seja exibida a tela de configuração de impressora e os botões de parâmetros.
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³REPORTDEF º Autor ³ AP6 IDE            º Data ³  11/12/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao de montagem do padrão de impressão das informações  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()
	Local cDesc := ""
	Local oReport
	Local oSection1
	Local oSection2

	cOS  := cEmi := cLib := ""
	cCon := cCP  := cTT  := ""

	cCli := cPla := cEnd := cMod := ""
	cBai := cMar := cCid := cCha := ""
	cTel := cAno := cCPF := cOdo := ""
	cIns := cFro := cCon := cMot := ""

	cRev := cDat := ""

	cOSP := cOSC := ""

	cSer := cSVl := cSCt := ""

	cPec := cPUM := cQtd := cPVU := cPVl := ""

	cTot := cTVl := ""

	// Descrição
	cDesc := STR0002 //Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario. Pré-Fechamento

	// TReport
	oReport := TReport():New(          ;
		"PREFECT2",                    ;
		cTitulo,                       ;
		,                              ;
		{|oReport| RunReport(oReport)},;
		cDesc)

	// Cabeçalho
	oSection1 := TRSection():New(oReport, "oCabecalho")

	oSection1:SetLineStyle()    // Define se imprime as células da seção em linhas
	oSection1:SetLinesBefore(0) // Define a quantidade de linhas que serão saltadas antes da impressão da seção
	oSection1:SetCols(3)        // Define a quantidade de colunas impressas por linha
	oSection1:SetHeaderPage()   // Define se imprime o cabeçalho da seção no topo da página
	oSection1:SetHeaderBreak()  // Define se imprime o cabeçalho da seção na quebra de impressão (TRBreak)
	oSection1:SetPageBreak()    // Define se quebra página após a impressão do totalizador

	TRCell():New(oSection1, "oOS" ,, STR0004 , "@!", 33,, {|| cOS  },,,,,,,,, .t.) // Ordem de Serviço
	TRCell():New(oSection1, "oEmi",, STR0005 , "@!", 33,, {|| cEmi },,,,,,,,, .t.) // Emissão
	TRCell():New(oSection1, "oLib",, STR0006 , "@!", 33,, {|| cLib },,,,,,,,, .t.) // Liberação
	TRCell():New(oSection1, "oCon",, STR0007 , "@!", 33,, {|| cCon },,,,,,,,, .t.) // Consultor
	TRCell():New(oSection1, "oCP" ,, STR0008 , "@!", 33,, {|| cCP  },,,,,,,,, .t.) // Condição de Pagamento
	TRCell():New(oSection1, "oTT" ,, STR0009 , "@!", 33,, {|| cTT  },,,,,,,,, .t.) // Tipo de Tempo

	// Dados Complemento
	oSection2 := TRSection():New(oReport, "oDadosComp")

	oSection2:SetLineStyle()    // Define se imprime as células da seção em linhas
	oSection2:SetLinesBefore(2) // Define a quantidade de linhas que serão saltadas antes da impressão da seção
	oSection2:SetCols(2)        // Define a quantidade de colunas impressas por linha

	TRCell():New(oSection2, "oCli",, STR0011 , "@!", 50,, {|| cCli },,,,,,,,,) // Cliente
	TRCell():New(oSection2, "oPla",, STR0012 , "@!", 50,, {|| cPla },,,,,,,,,) // Placa
	TRCell():New(oSection2, "oEnd",, STR0013 , "@!", 50,, {|| cEnd },,,,,,,,,) // Endereço
	TRCell():New(oSection2, "oMod",, STR0014 , "@!", 50,, {|| cMod },,,,,,,,,) // Modelo
	TRCell():New(oSection2, "oBai",, STR0015 , "@!", 50,, {|| cBai },,,,,,,,,) // Bairro
	TRCell():New(oSection2, "oMar",, STR0016 , "@!", 50,, {|| cMar },,,,,,,,,) // Marca
	TRCell():New(oSection2, "oCid",, STR0017 , "@!", 50,, {|| cCid },,,,,,,,,) // Cidade
	TRCell():New(oSection2, "oCha",, STR0018 , "@!", 50,, {|| cCha },,,,,,,,,) // Chassi
	TRCell():New(oSection2, "oTel",, STR0019 , "@!", 50,, {|| cTel },,,,,,,,,) // Telefone
	TRCell():New(oSection2, "oAno",, STR0020 , "@!", 50,, {|| cAno },,,,,,,,,) // Ano
	TRCell():New(oSection2, "oCPF",, STR0021 , "@!", 50,, {|| cCPF },,,,,,,,,) // CNPJ/CPF
	TRCell():New(oSection2, "oOdo",, STR0022 , "@!", 50,, {|| cOdo },,,,,,,,,) // Odomet.
	TRCell():New(oSection2, "oIns",, STR0023 , "@!", 50,, {|| cIns },,,,,,,,,) // Insc.
	TRCell():New(oSection2, "oFro",, STR0024 , "@!", 50,, {|| cFro },,,,,,,,,) // Frota
	TRCell():New(oSection2, "oCon",, STR0025 , "@!", 50,, {|| cCon },,,,,,,,,) // Contato
	TRCell():New(oSection2, "oMot",, STR0026 , "@!", 50,, {|| cMot },,,,,,,,,) // Motoris

	// Dados (Venda Zero)
	oSection3 := TRSection():New(oReport, "oDadosVZero")

	oSection3:SetLineStyle()    // Define se imprime as células da seção em linhas
	oSection3:SetLinesBefore(1) // Define a quantidade de linhas que serão saltadas antes da impressão da seção
	oSection3:SetCols(2)        // Define a quantidade de colunas impressas por linha

	TRCell():New(oSection3, "oRev",, STR0028 , "@!", 50,, {|| cRev },,,,,,,,,) // Revend.
	TRCell():New(oSection3, "oDat",, STR0029 , "@!", 50,, {|| cDat },,,,,,,,,) // Data

	// Tipo de OS
	oSection4 := TRSection():New(oReport, "oTipoOS")

	oSection4:SetLineStyle()    // Define se imprime as células da seção em linhas
	oSection4:SetLinesBefore(3) // Define a quantidade de linhas que serão saltadas antes da impressão da seção
	oSection4:SetLeftMargin(50) // Define o tamanho da margem a esquerda

	TRCell():New(oSection4, "oOSP",, "", "@!", 50,, {|| cOSP },,,,,,,,,) // OS Preventiva
	TRCell():New(oSection4, "oOSC",, "", "@!", 50,, {|| cOSC },,,,,,,,,) // OS Corretiva

	// Serviços
	oSection5 := TRSection():New(oReport, "oServicos")

	oSection5:SetLinesBefore(2) // Define a quantidade de linhas que serão saltadas antes da impressão da seção
	oSection5:SetLeftMargin(3)  // Define o tamanho da margem a esquerda
	oSection5:SetHeaderBreak()  // Define se imprime o cabeçalho da seção na quebra de impressão (TRBreak)

	TRCell():New(oSection5, "oSer",, STR0033 , "@!"           , 150,, {|| cSer },,,        ,,,,,,) // Serviços Executados
	TRCell():New(oSection5, "oSCt",, STR0034 , "@!"           ,  50,, {|| cSCt },,,        ,,,,,,) // Cortesia
	TRCell():New(oSection5, "oSVl",, STR0035 , "@E 999,999.99", 100,, {|| cSVl },,, "RIGHT",,,,,,) // Vlr. Total

	// Peças
	oSection6 := TRSection():New(oReport, "oPecas")

	oSection6:SetLinesBefore(2) // Define a quantidade de linhas que serão saltadas antes da impressão da seção
	oSection6:SetLeftMargin(3)  // Define o tamanho da margem a esquerda
	oSection6:SetHeaderBreak()  // Define se imprime o cabeçalho da seção na quebra de impressão (TRBreak)

	TRCell():New(oSection6, "oPec",, STR0037 , "@!"           , 100,, {|| cPec },,,        ,,,,,,) // Peças Utilizadas
	TRCell():New(oSection6, "oPUM",, STR0038 , "@!"           ,  10,, {|| cPUM },,,        ,,,,,,) // UM
	TRCell():New(oSection6, "oQtd",, STR0039 , "@R 999.99"    ,  25,, {|| cQtd },,, "RIGHT",,,,,,) // Qtde
	TRCell():New(oSection6, "oPVU",, STR0040 , "@E 999,999.99",  25,, {|| cPVU },,, "RIGHT",,,,,,) // Vlr. Unit.
	TRCell():New(oSection6, "oPVl",, STR0035 , "@E 999,999.99",  40,, {|| cPVl },,, "RIGHT",,,,,,) // Vlr. Total

	// Totais
	oSection7 := TRSection():New(oReport, "oTotais")

	oSection7:SetLineStyle()     // Define se imprime as células da seção em linhas
	oSection7:SetLinesBefore(1)  // Define a quantidade de linhas que serão saltadas antes da impressão da seção
	oSection7:SetLeftMargin(116) // Define o tamanho da margem a esquerda

	TRCell():New(oSection7, "oTot",, "", "@!"               , 25,, {|| cTot },,,        ,,,,,,) // Descrições
	TRCell():New(oSection7, "oTVl",, "", "@E 999,999,999.99", 20,, {|| cTVl },,, "RIGHT",,,,,,) // Valores
Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  10/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao de retorno das informações do banco de dados        º±±
±±º          ³ a serem impressas                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4)
	Local oSection5 := oReport:Section(5)
	Local oSection6 := oReport:Section(6)
	Local oSection7 := oReport:Section(7)
	Local nCntFor
	Local nCntFor2
	Local aValPec
	Local aValSer
	Local cCliCod
	Local cCliLoj
	Local cCGC
	Local dDataDis
	Local aTotaliz := {}
	Local cDescri
	Local nTamDesc
	Local cMascPla := VV1->(x3Picture("VV1_PLAVEI"))

	// OS por Tipo de Tempo
	For nCntFor := 1 to Len(aOS)
		aTotaliz := {}
		Aadd(aTotaliz, {0, 0}) // 1 - Totaliza Serviços
		Aadd(aTotaliz, {0, 0}) // 2 - Totaliza Peças
		Aadd(aTotaliz, {0, 0}) // 3 - Totaliza OS e Descontos

		aValPec := FMX_CALPEC(aOS[nCntFor, 1], aOS[nCntFor, 2],,, .f., .t., .t., .f., .t., .f., .f.,,,, .f.)
		aValSer := FMX_CALSER(aOS[nCntFor, 1], aOS[nCntFor, 2],,, .f., .t., .f., .t., .f., .f.)

		If Len(aValPec) == 0 .And. Len(aValSer) == 0
			Loop
		EndIf

		If Len(aValPec) <> 0
			cTT      := aValPec[1, 3]  // Tipo de Tempo
			cCliCod  := aValPec[1, 15] // Cliente
			cCliLoj  := aValPec[1, 16] // Loja
			dDataDis := aValPec[1, 17] // Data Liberação
		Else
			cTT      := aValSer[1, 4]  // Tipo de Tempo
			cCliCod  := aValSer[1, 20] // Cliente
			cCliLoj  := aValSer[1, 21] // Loja
			dDataDis := aValSer[1, 22] // Data Liberação
		EndIf
		
		VO1->(dbSetOrder(1))
		VO1->(MsSeek(xFilial("VO1") + aOS[nCntFor, 1]))
		
		SA1->(dbSetOrder(1))
		SA1->(MsSeek(xFilial("SA1") + cCliCod + cCliLoj))
		
		VAI->(dbSetOrder(1))
		VAI->(MsSeek(xFilial("VAI") + VO1->VO1_FUNABE))
		
		VV1->(dbSetOrder(1))
		VV1->(dbSeek(xFilial("VV1") + VO1->VO1_CHAINT))
		
		VE1->(dbSetOrder(1))
		VE1->(dbSeek(xFilial("VE1") + VV1->VV1_CODMAR))
		
		VV2->(dbSetOrder(1))
		VV2->(dbSeek(xFilial("VV2") + VV1->VV1_CODMAR + VV1->VV1_MODVEI))

		dbSelectArea("VOO")
		dbSetOrder(1)
		dbSeek(xFilial("VOO") + aOs[nCntFor, 1] + aOs[nCntFor, 2])
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4") + VOO->VOO_CONDPG)

		cCGC := TRANSFORM(SA1->A1_CGC, PicPes(SA1->A1_PESSOA)) // CNPJ/CPF

		// Cabeçalho
		oSection1:Init()

		cOS  := AllTrim(VO1->VO1_NUMOSV)                                  // Ordem de Serviço
		cEmi := DtoC(VO1->VO1_DATABE)                                     // Emissão
		cLib := DtoC(dDataDis)                                            // Liberação
		cCon := AllTrim(VO1->VO1_FUNABE) + " " + AllTrim(VAI->VAI_NOMTEC) // Consultor
		cCP  := SE4->E4_DESCRI                                            // Condição de Pagamento

		oSection1:PrintLine()

		oReport:ThinLine()

		oSection1:Finish()

		// Dados Complemento
		oSection2:Init()

		cCli := PadR(SA1->A1_COD + "-" + SA1->A1_LOJA + " " + SA1->A1_NOME, 38) // Cliente
		cPla := TRANSFORM(VV1->VV1_PLAVEI, cMascPla)      // Placa
		cEnd := PadR(SA1->A1_END, 38)                                           // Endereço
		cMod := PadR(VV2->VV2_DESMOD, 17)                                       // Modelo
		cBai := PadR(SA1->A1_BAIRRO, 38)                                        // Bairro
		cMar := PadR(VE1->VE1_DESMAR, 17)                                       // Marca
		cCid := PadR(SA1->A1_MUN, 38)                                           // Cidade
		cCha := PadR(ALLTRIM(VV1->VV1_CHASSI), 17)                              // Chassi
		cTel := PadR(SA1->A1_TEL, 38)                                           // Telefone
		cAno := TRANSFORM(VV1->VV1_FABMOD, "@R 9999/9999")                      // Ano
		cCPF := PadR(cCGC, 38)                                                  // CNPJ/CPF
		cOdo := TRANSFORM(VO1->VO1_KILOME, "@E 999,999,999")                    // Odomet.
		cIns := PadR(SA1->A1_INSCR, 38)                                         // Insc.
		cFro := PadR(VV1->VV1_CODFRO, 15)                                       // Frota
		cCon := PadR(SA1->A1_CONTATO, 38)                                       // Contato
		cMot := PadR(VO1->VO1_CODMOT, 15)                                       // Motoris

		oSection2:PrintLine()

		oReport:ThinLine()

		oSection2:Finish()

		oReport:SkipLine(1)
		oReport:PrtCenter(STR0042) //"Venda Zero"
		oReport:SkipLine(1)

		// Dados (Venda Zero)
		oSection3:Init()

		cRev := PadR(VV1->VV1_CODCON, 38)        // Contato
		cDat := TRANSFORM(VV1->VV1_DATVEN, "@D") // Motoris

		oSection3:PrintLine()

		oReport:ThinLine()

		oSection3:Finish()

		// Tipo de OS
		oSection4:Init()

		cOSP := STR0043 // OS Preventiva
		cOSC := STR0044  // OS Corretiva

		oSection4:PrintLine()

		oReport:SkipLine(2)
		oReport:ThinLine()

		oSection4:Finish()

		// Serviços
		If Len(aValSer) <> 0
			// Serviços
			oSection5:Init()

			For nCntFor2 := 1 to Len(aValSer)
				cSer := PadR(AllTrim(aValSer[nCntFor2, 1]) + " " + AllTrim(aValSer[nCntFor2, 2]) + " " + AllTrim(aValSer[nCntFor2, 15]), 69) // Serviço
				
				If aValSer[nCntFor2, 6] == "0" // VOK_INCMOB - Mão de Obra Gratuíta
					cSVl := "0,00"               // Vlr. Total
					cSCt := STR0030         // Sim // Cortesia        
				Else
					cSVl := aValSer[nCntFor2, 7] // Vlr. Total
					cSCt := ""                   // Cortesia
				EndIf

				oSection5:PrintLine()

				// Total Serviços
				aTotaliz[1, 1] += aValSer[nCntFor2, 7]
				aTotaliz[1, 2] += aValSer[nCntFor2, 8]

				// Total Geral
				aTotaliz[3, 1] += aValSer[nCntFor2, 7]
				aTotaliz[3, 2] += aValSer[nCntFor2, 8]
			Next

			oReport:ThinLine()

			oSection5:Finish()

			// Totais (Serviços)
			oSection7:Init()

			cTot := STR0045 // Sub-Total de Serviços
			cTVl := aTotaliz[1, 1]          //Sub-Total de Serviços        

			oSection7:PrintLine()

			cTot := STR0041 // Descontos............:
			cTVl := aTotaliz[1, 2]                  // Descontos

			oSection7:PrintLine()

			cTot := STR0036 //Total de Serviços....:
			cTVl := aTotaliz[1, 1] - aTotaliz[1, 2] // Total de Serviços

			oSection7:PrintLine()

			oReport:ThinLine()

			oSection7:Finish()
		EndIf

		// Peças
		If Len(aValPec) <> 0
			// Peças
			oSection6:Init()

			SB1->(dbSetOrder(7))

			For nCntFor2 := 1 to Len(aValPec)
				SB1->(dbSeek(xFilial("SB1") + aValPec[nCntFor2, 1] + aValPec[nCntFor2, 2]))

				cPec := PadR(aValPec[nCntFor2, 1] + " " + AllTrim(aValPec[nCntFor2, 2]) + " " + AllTrim(SB1->B1_DESC), 45) // Peças Utilizadas
				cPUM := SB1->B1_UM                                                                                         // UM
				cQtd := aValPec[nCntFor2, 5]                                                                               // Qtde
				cPVU := aValPec[nCntFor2, 9]                                                                               // Vlr. Unit.
				cPVl := aValPec[nCntFor2, 10]                                                                              // Vlr. Total

				oSection6:PrintLine()

				// Total Peças
				aTotaliz[2, 1] += aValPec[nCntFor2, 10]
				aTotaliz[2, 2] += aValPec[nCntFor2, 7]

				// Total Geral
				aTotaliz[3, 1] += aValPec[nCntFor2, 10]
				aTotaliz[3, 2] += aValPec[nCntFor2, 7]
			Next nCntFor2

			oReport:ThinLine()

			oSection6:Finish()

			// Totais (Peças)
			oSection7:Init()

			cTot := STR0032 //"Sub-Total de Peças...:"
			cTVl := aTotaliz[2, 1]                  // Sub-Total de Peças

			oSection7:PrintLine()

			cTot := STR0041 //"Descontos............:"
			cTVl := aTotaliz[2, 2]                  // Descontos

			oSection7:PrintLine()

			cTot := STR0031 //"Total de Peças.......:"
			cTVl := aTotaliz[2, 1] - aTotaliz[2, 2] // Total de Peças

			oSection7:PrintLine()

			oReport:ThinLine()

			oSection7:Finish()
		EndIf

		// Totais (Peças / Serviços)
		oSection7:Init()

		cTot := STR0027//"Total Peças/Serviços.:"
		cTVl := aTotaliz[3, 1] - aTotaliz[3, 2] // Total de Peças / Serviços

		oSection7:PrintLine()

		oReport:ThinLine()

		oSection7:Finish()

		oReport:SkipLine(1)
		oReport:PrintText(Space(3) + STR0010) //Obs:

		// Observação
		DbSelectArea("SYP")
		DbSetOrder(1)
		DbSeek(xFilial("SYP") + VOO->VOO_OBSMNF)

		While !Eof() .And. xFilial("SYP") == SYP->YP_FILIAL .And. SYP->YP_CHAVE == VOO->VOO_OBSMNF
			cDescri := Alltrim(SYP->YP_TEXTO)
			nTamDesc := AT("\13\10", cDescri)
			If nTamDesc > 0
				cDescri := SubSTR(cDescri, 1, nTamDesc - 1)
			Else
				cDescri := SubSTR(cDescri, 1, Len(cDescri))
			EndIf
			If nTamDesc > 0
				nTamDesc--
			Else
				nTamDesc := Len(cDescri)
			EndIf

			oReport:PrintText(Space(7) + cDescri)

			DbSelectArea("SYP")
			DbSkip()
		EndDo

		oReport:SkipLine(5)
		oReport:PrintText(Space(40) + "_______________________________" + Space(30) + "_______________________________")
		oReport:PrintText(Space(51) + STR0007 + Space(50) + STR0003) //Consultor / Administração
	Next
Return
