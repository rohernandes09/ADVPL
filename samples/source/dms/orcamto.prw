#include "Protheus.ch"
#Include "TopConn.Ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ORCAMTO  ³ Autor ³ Andre                 ³ Data ³ 01/08/00 ³±±
±±³Funcao    ³ ORCAMTO  ³ Autor ³ Alecsandre Ferreira   ³ Data ³ 12/11/21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Orcamento                                     ³±±
±±³Descricao ³ *12/11/2021* - Adaptação de relatório para TReport, afim   ³±±
±±³            de atender a demanda da LGPD(Lei Geral de Proteção de Dados)±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ORCAMTO()
	Local oReport
	Private cOrc := ParamIXB[1]
	Private cTitulo  := "Orcamento " + cOrc
	Private cNomeRel := "Orcamento " + cOrc
	Private cDesc1   := "Este Relatório irá imprimir o Orçamento."
	Private cPerg := "ORCAMT"
	Private aEmp := FwLoadSM0()
	Private nEmp := aScan(aEmp, {|i| i[1] == cEmpAnt .AND. i[2] == cFilAnt})
	
	oReport := RptDefOrc()
    oReport:nFontBody := 10
    oReport:oPage:nPaperSize := 9
    oReport:PrintDialog()
Return

Static Function RptDefOrc()

	Local oReport
    Local oSection1 
    Local oSection2
	Local oSection3
	Local oSection4
	Local oSection5
	Local oSection6
	Local oSection7
	Local oSection8
	Local oSection9
	Local oSection10
	Local oSection11
	Local oSection12
	Local oSection13
	Local oSection14
	Local oSection15
	Local oSection16
	Local oSection17
	Local oSection18
	Local oSection19

	Pergunte(cPerg, .F.)

    oReport := TReport():New(;
        cNomeRel,;
        cTitulo,;
        cPerg,;
        {|oReport| RunRptOrc(oReport)},;
        cDesc1;
    )

    oReport:SetLineHeight(45)
    oSection1 := TRSection():New(oReport)

	// Dados da Empresa
	TrCell():New(oSection1, "M0_NOMECOM", "SM0", "Nome",,      40)
	If !Empty(SM0->M0_ENDENT) // Endereço de Entrega
		TRCell():New(oSection1, "M0_ENDENT",  "SM0", "Endereço",,  30)
	Endif
	If !Empty(SM0->M0_CIDENT) // Cidade de Entrega
		TRCell():New(oSection1, "M0_CIDENT",  "SM0", "Cidade",,    12)
	Endif
	If !Empty(SM0->M0_ESTENT) // Estado de Entrega
		TRCell():New(oSection1, "M0_ESTENT",  "SM0", "Estado",,    10)
	Endif
	If !Empty(SM0->M0_CEPENT) // CEP Entrega
		TRCell():New(oSection1, "M0_CEPENT",  "SM0", "CEP",,       15)
	Endif
	TRCell():New(oSection1, "M0_TEL",     "SM0", "Telefone",,  15)
	TRCell():New(oSection1, "M0_CGC",     "SM0", "CNPJ",,      20)
	TRCell():New(oSection1, "M0_INSC",    "SM0", "IE",,        20)
	If !Empty(SM0->M0_CODMUN)
		TRCell():New(oSection1, "M0_CODMUN",  "SM0", "Cód. Mun.",, 10)
	Endif
	oSection1:SetLinesBefore(1)

	// Dados de Data
	oSection2 := TRSection():New(oReport)
	TRCell():New(oSection2, "VS1_DATORC", "VS1", "Data",,       12)
	TRCell():New(oSection2, "VS1_DATVAL", "VS1", "Validade",,   12)
	TRCell():New(oSection2, "A3_COD",     "SA3", "Cód. Vend.",, 12)
	TRCell():New(oSection2, "A3_NOME",    "SB1", "Vendedor",,   30)
	oSection2:SetLinesBefore(2)

	// Dados Cliente
	oSection3 := TRSection():New(oReport)
	TrCell():New(oSection3, "A1_COD",  "SA1", "Cód. Cli.",, 15)
	TrCell():New(oSection3, "A1_NOME", "SA1", "Cliente",,   30)
	TrCell():New(oSection3, "A1_CGC",  "SA1", "CNPJ",,      35)
	TrCell():New(oSection3, "A1_TEL",  "SA1", "Fone",,      18)
	TrCell():New(oSection3, "A1_END",  "SA1", "Endereço",,  30)
	TrCell():New(oSection3, "A1_MUN",  "SA1", "Cidade",,    20)
	TrCell():New(oSection3, "A1_EST",  "SA1", "Estado",,    12)
	oSection3:SetLinesBefore(2)

	// Dados de Veículo
	oSection4 := TRSection():New(oReport)
	TrCell():New(oSection4, "VV1_CHASSI", "VV1", "Chassi",,      40)
	TrCell():New(oSection4, "VV1_PLAVEI", "VV1", "Placa",,       20)
	TrCell():New(oSection4, "VV1_CORVEI", "VV1", "Cor",,         20)
	TrCell():New(oSection4, "VV1_COMVEI", "VV1", "Combustível",, 40)
	TrCell():New(oSection4, "VV1_MODVEI", "VV1", "Modelo",,      40)
	TrCell():New(oSection4, "VV1_FABMOD", "VV1", "Fab/Mod",,     20)
	TrCell():New(oSection4, "VO1_KILOME", "VO1", "Últ. Km.",,    16)
	oSection4:SetLinesBefore(2)

	// Obs de Texto
	oSection5 := TRSection():New(oReport)
	TrCell():New(oSection5, "OBS0", "", "Obs0",, 10,,, "CENTER", .T.)
	TrCell():New(oSection5, "OBS1", "", "Obs1",, 320,,, "CENTER", .T.)
	TrCell():New(oSection5, "OBS2", "", "Obs2",, 10,,, "CENTER", .T.)
	oSection5:SetLinesBefore(2)
	oSection5:SetHeaderSection(.F.)

	// Titulo Peças
	oSection6 := TRSection():New(oReport)
	TrCell():New(oSection6, "TIT1", "", "",,      40,,,  "CENTER")
	TrCell():New(oSection6, "TIT",  "", "Title",, 320,,, "CENTER")
	TrCell():New(oSection6, "TIT2", "", "",,      40,,,  "CENTER")
	oSection6:SetHeaderSection(.F.)
	oSection6:SetLinesBefore(2)

	// Peças
	oSection7 := TRSection():New(oReport)
	TrCell():New(oSection7, "B1_GRUPO",   "SB1", "Grupo",,40)
	TrCell():New(oSection7, "B1_CODITE",  "SB1", "Código do Item",,40)
	TrCell():New(oSection7, "B1_DESC",    "SB1", "Descrição",,  40)
	TrCell():New(oSection7, "B5_LOCALI2", "SB5", "Local",,      20)
	TrCell():New(oSection7, "OBSQTDE",    "",    "",,           10)
	TrCell():New(oSection7, "VS3_QTDITE", "VS3", "Qtde.",,      16)
	TrCell():New(oSection7, "VS3_VALPEC", "VS3", "Vlr. Unit.",, 20)
	TrCell():New(oSection7, "VS3_VALDES", "VS3", "Desconto",,   20)
	TrCell():New(oSection7, "VS3_VALTOT", "VS3", "Vlr. Total",, 20)
	oSection7:SetLinesBefore(1)

	// SubTotal de Peças
	oSection8 := TRSection():New(oReport)
	TrCell():New(oSection8, "SUBDES",     "",    "Total de Desc.:",,    80)
	TrCell():New(oSection8, "VS3_VALDES", "VS3", "Valor Total",,        80)
	TrCell():New(oSection8, "SUBTOT",     "",    "Subtotal de Peças:",, 80)
	TrCell():New(oSection8, "VS3_VALTOT", "VS3", "Valor Total",,        80)
	//oSection8:SetLinesBefore(2)
	oSection8:SetHeaderSection(.F.)

	// Titulo Serviços
	oSection9 := TRSection():New(oReport)
	TrCell():New(oSection9, "TIT1", "", "",,      40,,,  "CENTER")
	TrCell():New(oSection9, "TIT",  "", "Title",, 320,,, "CENTER")
	TrCell():New(oSection9, "TIT2", "", "",,      40,,,  "CENTER")
	oSection9:SetHeaderSection(.F.)
	oSection9:SetLinesBefore(2)

	// Serviços
	oSection10 := TRSection():New(oReport)
	TrCell():New(oSection10, "VOS_CODGRU", "VOS", "Grupo",,       20)
	TrCell():New(oSection10, "VO6_CODSER", "VO6", "Cód. Serv.",,  20)
	TrCell():New(oSection10, "VO6_DESSER", "VO6", "Descrição",,   20)
	TrCell():New(oSection10, "VOK_TIPSER", "VOK", "Tipo Serv.",,  20)
	TrCell():New(oSection10, "VS4_VALDES", "VS4", "Valor Desc.",, 20)
	TrCell():New(oSection10, "VS4_VALTOT", "VS4", "Valor Total",, 20)
	oSection10:SetLinesBefore(1)

	// SubTotal de Serviços
	oSection11 := TRSection():New(oReport)
	TrCell():New(oSection11, "SUBDES",     "",    "Total de Desc.:",,    80)
	TrCell():New(oSection11, "VS4_VALDES", "VS4", "Valor Total",,        80)
	TrCell():New(oSection11, "SUBTOT",     "",    "Subtotal em Peças:",, 80)
	TrCell():New(oSection11, "VS4_VALTOT", "VS4", "Valor Total",,        80)
	//oSection11:SetLinesBefore(2)
	oSection11:SetHeaderSection(.F.)

	// Obs
	oSection12 := TRSection():New(oReport)
	TrCell():New(oSection12, "OBS1", "", "",, 40,,,  "CENTER")
	TrCell():New(oSection12, "OBS",  "", "",, 320,,, "CENTER")
	TrCell():New(oSection12, "OBS2", "", "",, 40,,,  "CENTER")
	oSection12:SetLinesBefore(2)
	oSection12:SetHeaderSection(.F.)

	// Sem Estoque
	oSection13 := TRSection():New(oReport)
	TrCell():New(oSection13, "OBS1", "", "",, 320)
	oSection13:SetHeaderSection(.F.)

	// Titulo Totais
	oSection14 := TRSection():New(oReport)
	TrCell():New(oSection14, "TIT2",  "", "",, 40)
	TrCell():New(oSection14, "TIT",  "", "",, 320,,, "CENTER")
	TrCell():New(oSection14, "TIT1",  "", "",, 40)
	oSection14:SetHeaderSection(.F.)
	oSection14:SetLinesBefore(2)

	// Totais
	oSection15 := TRSection():New(oReport)
    TRCell():New(oSection15, "VS3_VALTOT", "VS3", "Peças",,            25,,, "LEFT",, "LEFT")
	TRCell():New(oSection15, "VS4_VALTOT", "VS4", "Serviços",,         25)
	TRCell():New(oSection15, "VS1_VALFRE", "VS1", "Frete",,            25)
	TRCell():New(oSection15, "VS1_DESACE", "VS1", "Desp. Acessorias",, 25)
	TRCell():New(oSection15, "TOTAL",      "",    "Orçamento",,        25)
	DbSelectArea("VS1")
	DbSetOrder(1)
	DbSeek(xFilial("VS1")+cOrc)
	If !Empty(VS1->VS1_FORPAG)
		TrCell():New(oSection15, "E4_CODIGO",  "SE4", "Cond. Pgto",, 25)
		TrCell():New(oSection15, "E4_DESCRI",  "SE4", "",,           40)
	Endif
	VS1->(DbCloseArea())
	oSection15:SetLinesBefore(1)

	// Assinaturas
	oSection16 := TRSection():New(oReport)
    TRCell():New(oSection16, "COL1", "", "",, 80,,, "LEFT")
	oSection16:SetLinesBefore(3)
    oSection16:SetHeaderSection(.F.)

	oSection17 := TRSection():New(oReport)
    TRCell():New(oSection17, "COL1", "", "",, 80,,, "CENTER")
	oSection17:SetLinesBefore(3)
    oSection17:SetHeaderSection(.F.)

	oSection18 := TRSection():New(oReport)
	TRCell():New(oSection18, "ASS1", "", "",,           160,,, "CENTER")
    TRCell():New(oSection18, "ASS",  "", "Assinatura",, 160,,, "CENTER")
	TRCell():New(oSection18, "ASS2", "", "",,           160,,, "CENTER")
	oSection18:SetLinesBefore(2)
    oSection18:SetHeaderSection(.F.)

	// Impressão da Observação Memo VS1_OBSERV
	oSection19 := TRSection():New(oReport)
	TrCell():New(oSection19, "OBS1", "", "",,320,,,"CENTER")
	oSection19:SetHeaderSection(.F.)

Return oReport

Static Function RunRptOrc(oReport)
	Local cEstq := "  "
	Local nUltKil := 0
	Local nSemEstoque := 0
	Local nMenEstoque := 0
	Local nValPec := 0
	Local nTotPec  := 0
	Local nTotDesP := 0
	Local nQtdIte := 0
	Local nPerDes := 0
	Local nTotDes := 0
	Local nTotDesS := 0
	Local nTotSer := 0
	Local nTotal := 0
	Local cQuery := ""
	Local nCntFor := 0
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local oSection4 := oReport:Section(4)
	Local oSection5 := oReport:Section(5)
	Local oSection6 := oReport:Section(6)
	Local oSection7 := oReport:Section(7)
	Local oSection8 := oReport:Section(8)
	Local oSection9 := oReport:Section(9)
	Local oSection10 := oReport:Section(10)
	Local oSection11 := oReport:Section(11)
	Local oSection12 := oReport:Section(12)
	Local oSection13 := oReport:Section(13)
	Local oSection14 := oReport:Section(14)
	Local oSection15 := oReport:Section(15)
	Local oSection16 := oReport:Section(16)
	Local oSection17 := oReport:Section(17)
	Local oSection18 := oReport:Section(18)
	Local oSection19 := oReport:Section(19)

	//Posicionamento dos Arquivos
	DbSelectArea("VS1")
	DbSetOrder(1)
	DbSeek(xFilial("VS1")+cOrc)

	DbSelectArea("VV1")
	FG_SEEK("VV1","VS1->VS1_CHAINT",1,.f.)

	DbSelectArea("VVC")
	FG_SEEK("VVC","VV1->VV1_CODMAR+VV1->VV1_CORVEI",1,.F.)

	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+VS1->VS1_CLIFAT+VS1->VS1_LOJA)

	if VS1->VS1_KILOME != 0
		nUltKil := VS1->VS1_KILOME
	else
		nUltKil := FG_UltKil(VV1->VV1_CHAINT)
	endif

	// Dados da Empresa
	oSection1:Init()
	oSection1:Cell("M0_NOMECOM"):SetValue(aEmp[nEmp, SM0_NOMECOM]) // Nome Comercial 
	If !Empty(SM0->M0_ENDENT)
		oSection1:Cell("M0_ENDENT"):SetValue(SM0->M0_ENDENT) 
	Endif
	If !Empty(SM0->M0_CIDENT)
		oSection1:Cell("M0_CIDENT"):SetValue(SM0->M0_CIDENT) //Cidade de Entrega
	Endif
	If !Empty(SM0->M0_ESTENT)
		oSection1:Cell("M0_ESTENT"):SetValue(SM0->M0_ESTENT) // Estado de Entrega
	Endif
	If !Empty(SM0->M0_CEPENT)
		oSection1:Cell("M0_CEPENT"):SetValue(SM0->M0_CEPENT) // CEP Entrega
	Endif
	oSection1:Cell("M0_TEL"):SetValue(SM0->M0_TEL) //Telefone
	oSection1:Cell("M0_CGC"):SetValue(aEmp[nEmp, SM0_CGC])
	oSection1:Cell("M0_INSC"):SetValue(SM0->M0_INSC)
	If !Empty(SM0->M0_CODMUN)
		oSection1:Cell("M0_CODMUN"):SetValue(SM0->M0_CODMUN)
	Endif
	oSection1:PrintLine()
	oSection1:Finish()
	
	// Dados de Data Orc
	SA3->(DbSetOrder(1))
	SA3->(dbgotop())
	SA3->(DbSeek(xFilial("SA3")+VS1->VS1_CODVEN))

	oSection2:Init()
	oSection2:Cell("VS1_DATORC"):SetValue(VS1->VS1_DATORC) // Nome Comercial 
	oSection2:Cell("VS1_DATVAL"):SetValue(VS1->VS1_DATVAL) 
	oSection2:Cell("A3_COD"):SetValue(VS1->VS1_CODVEN) //Cidade de Entrega
	oSection2:Cell("A3_NOME"):SetValue(SA3->A3_NOME)
	oSection2:PrintLine()
	oSection2:Finish()

	//Dados de Cliente
	cCGCCPF1  := Subs(Transform(SA1->A1_CGC, PicPes(RetPessoa(SA1->A1_CGC))), 1, At("%", Transform(SA1->A1_CGC, PicPes(RetPessoa(SA1->A1_CGC)))) - 1)
	cCGCPro   := cCGCCPF1 + space(18 - len(cCGCCPF1))
	VAM->(DbSeek(xFilial("VAM")+SA1->A1_IBGE))

	oSection3:Init()
	oSection3:Cell("A1_COD"):SetValue(VS1->VS1_CLIFAT)
	oSection3:Cell("A1_NOME"):SetValue(SA1->A1_NOME)
	oSection3:Cell("A1_CGC"):SetValue(SA1->A1_CGC)
	oSection3:Cell("A1_TEL"):SetValue(IIF(!Empty(VAM->VAM_DDD), "(" + VAM->VAM_DDD + ") ", "(  )") + SA1->A1_TEL)
	oSection3:Cell("A1_END"):SetValue(SA1->A1_END)
	oSection3:Cell("A1_MUN"):SetValue(SA1->A1_MUN)
	oSection3:Cell("A1_EST"):SetValue(SA1->A1_EST)
	oSection3:PrintLine()
	oSection3:Finish()
	
	//Dados do Veiculo
	if VS1->VS1_TIPORC == "2"
		oSection4:Init()
		oSection4:Cell("VV1_CHASSI"):SetValue(VV1->VV1_CHASSI)
		oSection4:Cell("VV1_PLAVEI"):SetValue(/*Alltrim(Transform(*/VV1->VV1_PLAVEI/*,"@R AAA-9999"))*/)
		oSection4:Cell("VV1_CORVEI"):SetValue(VVC->VVC_DESCRI)
		oSection4:Cell("VV1_COMVEI"):SetValue(VV1->VV1_COMVEI + " - " + Alltrim(OFIOA560DS("076", VV1->VV1_COMVEI)))
		oSection4:Cell("VV1_MODVEI"):SetValue(Alltrim(VV1->VV1_MODVEI) + " " + VV2->VV2_DESMOD)
		oSection4:Cell("VV1_FABMOD"):SetValue(VV1->VV1_FABMOD + "/" + VV1->VV1_FABMOD)
		oSection4:Cell("VO1_KILOME"):SetValue(nUltKil)
		oSection4:PrintLine()
		oSection4:Finish()
	End
	// Dados de Obs
	// Daniele - 28/09/2006 Mensagem 
	oSection5:Init()
	oSection5:Cell("OBS0"):SetValue(" ")
	oSection5:Cell("OBS1"):SetValue("Atendendo solicitacao de V.Sa.(s), temos a satisfacao de fornecer a relacao de pecas e servicos necessarios para o veiculo acima especificado.  Estimativa de orcamento sujeito a alteracao apos desmontagem.")
	oSection5:Cell("OBS2"):SetValue(" ")
	oSection5:PrintLine()
	oSection5:Finish()

	cQuery := " SELECT * FROM " + retSqlName("VS3") + " VS3 WHERE VS3.D_E_L_E_T_ = ' ' AND VS3_FILIAL = '" + xFilial("VS3") + "' AND VS3_NUMORC = '" + Alltrim(cOrc) + "' AND VS3_MOTPED = ' ' "

	If Select("PECORC") > 0
		PECORC->(DBCloseArea())
	Endif

	TcQuery cQuery New Alias "PECORC"
	DbSelectArea("PECORC")
	PECORC->(DbGoTop())

	//Pecas
	nQtdIte := 0
	nPerDes := 0                     
	nTotDes := 0
	If !(PECORC->(EOF()))
		oSection6:Init()
		oSection6:Cell("TIT1"):SetValue(" ")
		oSection6:Cell("TIT"):SetValue("****** PEÇAS ******")
		oSection6:Cell("TIT2"):SetValue(" ")
		oSection6:PrintLine()
		oSection6:Finish()

		oSection7:Init()
		While !(PECORC->(EOF())) .and. PECORC->VS3_NUMORC == cOrc .AND. PECORC->VS3_FILIAL == xFilial("VS3")
			DbSelectArea("SB1")
			DBSetOrder(7)
			If !(DbSeek(xFilial("SB1")+PECORC->VS3_GRUITE+PECORC->VS3_CODITE)) // Se não existe o Produto não Verifica nada
				PECORC->(DbSkip())
				Loop
			Endif
		
			DbSelectArea("SB5")
			DbSeek(xFilial("SB5")+SB1->B1_COD)
		
			DbSelectArea("SBM")
			DbSeek(xFilial("SBM")+PECORC->VS3_GRUITE)
		
			DbSelectArea("SB2")
			DbSeek(xFilial("SB2")+SB1->B1_COD+If(!Empty(PECORC->VS3_LOCAL),PECORC->VS3_LOCAL,SB1->B1_LOCPAD))
			nSaldo := SaldoSB2()

			If PECORC->VS3_QTDITE == 0 //Pedido de venda cancelado parcialmente (Painel do Orçamento)
				PECORC->(DbSkip())
				Loop
			EndIf

			cEstq := "  "
			if nSaldo <= 0
				nSemEstoque++
				cEstq := "**"
			Elseif nSaldo < PECORC->VS3_QTDITE
				nMenEstoque++
				cEstq := " *"
			Endif
			
			If MV_PAR04 # 1
				oSection7:Cell("B1_GRUPO"):SetValue(PECORC->VS3_GRUITE) 
				oSection7:Cell("B1_CODITE"):SetValue(PECORC->VS3_CODITE)
			Else
				oSection7:Cell("B1_GRUPO"):Disable(.F.)
				oSection7:Cell("B1_CODITE"):Disable(.F.)
			EndIf	

			If MV_PAR03 # 1
				nValPec := ( PECORC->VS3_VALPEC + ( PECORC->VS3_VICMSB / PECORC->VS3_QTDITE ) )
			Else
				nValPec := ( ( PECORC->VS3_VALTOT + PECORC->VS3_VICMSB ) / PECORC->VS3_QTDITE )
			EndIf

			oSection7:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
			oSection7:Cell("B5_LOCALI2"):SetValue(FM_PRODSBZ(SB1->B1_COD,"SB5->B5_LOCALI2"))
			oSection7:Cell("OBSQTDE"):SetValue(cEstq)
			oSection7:Cell("VS3_QTDITE"):SetValue(/*Transform(*/PECORC->VS3_QTDITE/*,"@E 99999"*/)
			oSection7:Cell("VS3_VALPEC"):SetValue(/*Transform(*/nValPec/*,"@E 99999,999.99"*/)
			oSection7:Cell("VS3_VALDES"):SetValue(/*Transform(*/PECORC->VS3_VALDES/*,"@E 999,999.99"*/)
			oSection7:Cell("VS3_VALTOT"):SetValue(/*Transform(*/PECORC->VS3_VALTOT + PECORC->VS3_VICMSB/*,"@E 99999,999.99"*/)
		
			nTotPec  += (nValPec * PECORC->VS3_QTDITE)
			nTotDesP += PECORC->VS3_VALDES
			nQtdIte  += PECORC->VS3_QTDITE
			nPerDes  += PECORC->VS3_PERDES
			nTotDes  += PECORC->VS3_VALDES

			DbSelectArea("VS3")
			PECORC->(DbSkip())
			oSection7:PrintLine()
		EndDo
		oSection7:Finish()
		
		//SubTotal de Peças
		oSection8:Init()
		if nTotDesP > 0 .and. MV_PAR03 # 1
			oSection8:Cell("SUBDES"):SetValue("Descontos em Peças:")
			oSection8:Cell("VS3_VALDES"):SetValue(/*Transform(*/nTotDesP/*, "@E 99999999,999.99")*/)
		Else
			oSection8:Cell("VS3_VALDES"):Hide()
		endif

		oSection8:Cell("SUBTOT"):SetValue("Subtotal de Peças:")
		if MV_PAR03 == 2
			oSection8:Cell("VS3_VALTOT"):SetValue(/*Transform(*/nTotPec - nTotDesP/*,"@E 99999999,999.99")*/)
    	Else
			oSection8:Cell("VS3_VALTOT"):SetValue(/*Transform(*/nTotPec/*,"@E 99999999,999.99")*/)
		Endif
		oSection8:PrintLine()
		oSection8:Finish()
	Endif

	//Serviços

	cQuery := " SELECT * FROM " + retSqlName("VS4") + " VS4 WHERE VS4.D_E_L_E_T_ = ' ' AND VS4_FILIAL = '" + xFilial("VS4") + "' AND VS4_NUMORC = '" + Alltrim(cOrc) + "' "

	If Select("SERVORC")
		SERVORC->(DbCloseArea())
	Endif

	TcQuery cQuery New Alias "SERVORC"
	DbSelectArea("SERVORC")
	SERVORC->(DbGoTop())

	aTipoSer := {}
	aVetSer  := {}
	if VS1->VS1_TIPORC == "2" .AND. !(SERVORC->(EOF()))
		oSection9:Init()
		oSection9:Cell("TIT1"):SetValue(" ")
		oSection9:Cell("TIT"):SetValue("***** SERVICOS *****")
		oSection9:Cell("TIT2"):SetValue(" ")
		oSection9:PrintLine()
		oSection9:Finish()

		cTipSer := SERVORC->VS4_TIPSER
		oSection10:Init()
		Do While !(SERVORC->(EOF())) .and. SERVORC->VS4_NUMORC == cOrc
			DbSelectArea("VO6")
			DbSetOrder(2)
			DbSeek(xFilial("VO6")+FG_MARSRV(VS1->VS1_CODMAR, SERVORC->VS4_CODSER)+SERVORC->VS4_CODSER)
			
			DbSelectArea("VOK")
			DbSetOrder(1)
			DbSeek(xFilial("VOK")+SERVORC->VS4_TIPSER)

			If MV_PAR05 # 1
				oSection10:Cell("VOS_CODGRU"):SetValue(SERVORC->VS4_GRUSER)			
				oSection10:Cell("VO6_CODSER"):SetValue(SERVORC->VS4_CODSER)
			Else
				oSection10:Cell("VOS_CODGRU"):Disable(.F.)
				oSection10:Cell("VO6_CODSER"):Disable(.F.)
			EndIf

			oSection10:Cell("VO6_DESSER"):SetValue(VO6->VO6_DESSER)
			oSection10:Cell("VOK_TIPSER"):SetValue(SERVORC->VS4_TIPSER)
			oSection10:Cell("VS4_VALDES"):SetValue(IIf(MV_PAR03 # 1,/*Transform(*/SERVORC->VS4_VALDES/*,"@E 999,999.99")*/," "))
			oSection10:Cell("VS4_VALTOT"):SetValue(/*Transform(*/SERVORC->VS4_VALTOT/*,"@E 99999,999.99")*/)

			nTotSer  += SERVORC->VS4_VALTOT
			nTotDesS += SERVORC->VS4_VALDES

			SERVORC->(DbSkip())
			oSection10:PrintLine()
		EndDo
		oSection10:Finish()

		//SubTotal de Peças
		oSection11:Init()
		if nTotDesP > 0 .and. MV_PAR03 # 1
			oSection11:Cell("SUBDES"):SetValue("Descontos em Serviços:")
			oSection11:Cell("VS4_VALDES"):SetValue(/*Transform(*/nTotDesS/*, "@E 99999999,999.99")*/)
		Else
			oSection11:Cell("VS4_VALDES"):Hide()
		endif

		oSection11:Cell("SUBTOT"):SetValue("Subtotal em Serviços:")
		if MV_PAR03 == 2
			oSection11:Cell("VS4_VALTOT"):SetValue(/*Transform(*/nTotSer - nTotDesS/*,"@E 99999999,999.99")*/)
    	Else
			oSection11:Cell("VS4_VALTOT"):SetValue(/*Transform(*/nTotSer/*,"@E 99999999,999.99")*/)
		Endif
		oSection11:PrintLine()
		oSection11:Finish()
	Endif

	nTotal := nTotPec + nTotSer

	//Mais Observações
	oSection12:Init()
	oSection12:Cell("OBS1"):SetValue(" ")
	oSection12:Cell("OBS"):SetValue("**** OBSERVAÇÃO ****")
	oSection12:Cell("OBS2"):SetValue(" ")
	oSection12:PrintLine()
	oSection12:Finish()

	//Observações do campo VS1->VS1_OBSERV
	oSection19:Init()
	ImpMemoOBS(oReport)
	oSection19:Finish()

	if (nSemEstoque + nMenEstoque) > 0 .OR. VS1->VS1_TIPORC == "2"
		oSection13:Init()
		if nSemEstoque > 0
			oSection13:Cell("OBS1"):SetValue("ITENS ASSINALADOS COM '**' AO LADO DA QUANTIDADE ESTAO COM SALDO ZERO NO MOMENTO.")
			oSection13:PrintLine()
		Endif
		if nMenEstoque > 0
			oSection13:Cell("OBS1"):SetValue("ITENS ASSINALADOS COM ' *' AO LADO DA QUANTIDADE ESTAO INSUFICIENTES NO MOMENTO.")
			oSection13:PrintLine()
		Endif
		if VS1->VS1_TIPORC == "2"
			dbSelectArea("VOI")
			dbSetOrder(1)
			dbSeek(xFilial("VOI")+VS1->VS1_TIPTEM)
			If (nSemEstoque + nMenEstoque) > 0
				oSection13:Cell("OBS1"):SetValue(" ")
				oSection13:PrintLine()
			Endif
			If !Empty(VS1->VS1_NUMOSV)
				oSection13:Cell("OBS1"):SetValue("Ordem de Servico: " + Alltrim(VS1->VS1_NUMOSV) + " - TpTempo: " + Alltrim(VS1->VS1_TIPTEM) + " - " + Alltrim(VOI->VOI_DESTTE))
			Else
				oSection13:Cell("OBS1"):SetValue("TpTempo: " + Alltrim(VS1->VS1_TIPTEM) + " - " + Alltrim(VOI->VOI_DESTTE))
			Endif
			oSection13:PrintLine()
		EndIf
		oSection13:Finish()
	EndIf

	// Titulo Totais
	oSection14:Init()
	If oReport:nRow < oReport:oPage:nVertRes - (4 * oReport:nXlSRow) // Não imprimir Total se não houver impressão
		oSection14:Cell("TIT1"):SetValue(" ")	
		oSection14:Cell("TIT"):SetValue("****** TOTAIS ******")
		oSection14:Cell("TIT2"):SetValue(" ")
	Else
		For nCntFor := 1 To 4 //Incrementar 6 Linhas de 66px
			oReport:IncRow()
		Next
		oSection14:Cell("TIT1"):SetValue(" ")
		oSection14:Cell("TIT"):SetValue("****** TOTAIS ******")
		oSection14:Cell("TIT2"):SetValue(" ")
	Endif
	oSection14:PrintLine()
	oSection14:Finish()

	// Totais
	oSection15:Init()
	if MV_PAR03 == 2
		oSection15:Cell("VS3_VALTOT"):SetValue(/*Transform(*/nTotPec - nTotDesP/*, "@E 9999,999,999.99")*/)
	Else
		oSection15:Cell("VS3_VALTOT"):SetValue(/*Transform(*/nTotPec/*, "@E 9999,999,999.99")*/)
	Endif

	oSection15:Cell("VS4_VALTOT"):SetValue(/*Transform(*/nTotSer/*,"@E 9999,999,999.99")*/)
	oSection15:Cell("VS1_VALFRE"):SetValue(/*Transform(*/VS1->VS1_VALFRE/*,"@E 9999,999,999.99")*/)
	oSection15:Cell("VS1_DESACE"):SetValue(/*Transform(*/VS1->VS1_DESACE/*,"@E 9999,999,999.99")*/)
	if MV_PAR03 == 2
		oSection15:Cell("TOTAL"):SetValue(/*Transform(*/nTotPec+nTotSer+VS1->(VS1_DESACE+VS1_VALFRE)-nTotDesP/*,"@E 9999,999,999.99")*/)
		oSection15:Cell("TOTAL"):SetPicture(PesqPict("VS3", "VS3_VALTOT"))
	Else
		oSection15:Cell("TOTAL"):SetValue(nTotPec+nTotSer+VS1->(VS1_DESACE+VS1_VALFRE))
		oSection15:Cell("TOTAL"):SetPicture(PesqPict("VS3", "VS3_VALTOT"))
	Endif
	If !Empty(VS1->VS1_FORPAG)
		oSection15:Cell("E4_CODIGO"):SetValue(VS1->VS1_FORPAG)
		oSection15:Cell("E4_DESCRI"):SetValue(RtCondPg(VS1->VS1_FORPAG))
	Endif
	oSection15:PrintLine()
	oSection15:Finish()

	oSection16:Init()
	If oReport:nRow < oReport:oPage:nVertRes - (12 * oReport:nXlSRow) // Não imprimir se não houver espaço
		oSection16:Cell("COL1"):SetValue("AUTORIZO(AMOS) O FATURAMENTO DESTE ORCAMENTO.")
	Else
		For nCntFor := 1 To 12 //Incrementar 8 Linhas Definidas pelo parametro do tamanho de linha em pixels
			oReport:IncRow()
		Next
		oSection16:Cell("COL1"):SetValue("AUTORIZO(AMOS) O FATURAMENTO DESTE ORCAMENTO.")
	Endif
	oSection16:PrintLine()
	oSection16:Finish()

	// Assinaturas
	oSection17:Init()
	oSection17:Cell("COL1"):SetValue("Local:_______________________________________, Data:______/_____________/_______")
	oSection17:PrintLine()
	oSection17:Cell("COL1"):SetValue("  ")
	oSection17:PrintLine()
	oSection17:Finish()

	oSection18:Init()
	oSection18:Cell("ASS1"):SetValue(" ")
	oSection18:Cell("ASS"):SetValue("Ass.:________________________________________")
	oSection18:Cell("ASS2"):SetValue(" ")
	oSection18:PrintLine()
	oSection18:Finish()

Return

Static Function RtCondPg(cCondPgto)
	Local cDescri := ""

	DbSelectArea("SE4")
	DbSetOrder(1)
	If DbSeek(xFilial("SE4")+VS1->VS1_FORPAG)
		cDescri := Alltrim(SE4->E4_DESCRI)
	Endif
	SE4->(DbCloseArea())
Return cDescri

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ FG_Seek  ³ Autor ³Alvaro/Andre           ³ Data ³ 05/07/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Posiciona Reg e permanece nele. Atribui Valor a outro Campo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ (Alias,Chave,Ordem,.t./.f.-p/softseek on/off,CpoDes,CpoOri)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Sintaxe: FG_Seek( <ExpC1>, <ExpC2>, [ExpN], [ExpL], <ExpC3>, <ExpC4> )
Funcao.: Executa pesquisa em tabelas
ExpC1 = arquivo alvo
ExpC2 = chave de pesquisa
ExpN  = numero do indice associado a ExpC1  (Opcional)
Se nao informado assume 1
ExpL  = se .t. softseek ON                  (Opcional)
Se nao informado assume .f.
ExpC3 = Campo Destino (que recebera conteudo)
ExpC4 = Campo Origem do conteudo
Retorna: .t. se o reg. existir, deixando posicionado no mesmo
.f. se o reg. nao existir, deixando posic. no final do Arquivo
*/

Static Function FG_Seek(cAlias, Chv_, Ord_, Sss_, cCpoDest, cCpoOrig)
	Local Atu_ := SELECT(), Ind_, Sem_dbf := ALIAS(), Achou_
	Local i := 0

	Ord_ := IF(Ord_ == NIL, 1, Ord_)
	Sss_ := IF(Sss_ == NIL, .f., Sss_)
	cCom := IF(cCpoOrig == NIL, " ", cAlias + "->" + cCpoOrig)

	Select(cAlias)
	Ind_ := IndexOrd()
	DbSetOrder(Ord_)
	Set SoftSeek (Sss_)

	if Type("aCols") == "A" && Modelo 3
		cChave := ""
		if type(readvar()) == "U"
			cUlCpo := ""
		Else
			cUlCpo := &(readvar())
		Endif
		k := at("M->", chv_)
		if k > 0 .and. (Subs(chv_, k - 1, 1) == "+" .or. (k - 1 == 0) .or. !SX2->(dbSeek(Subs(chv_, k - 2, 3))) )
			bCampo := {|x| aHeader[x, 2]}
			w1 := READVAR()
			For i := 1 to Len(aHeader)
				wVar := "M->" + (EVAL(bCampo, i))
				If wVar != w1
					Private &wVar := aCols[n, i]
				Endif
			Next
		Endif
	
		While .t.
			k := at("+", chv_)
			if k > 0
				cCPO := substr(chv_, 1, k-1)
				chv_ := substr(chv_, k+1)
				if at("->", cCpo) == 0 .and. type(cCpo) == "U"
					cChave := cChave + FieldGet(FieldPos(cCPO))
				else
					cChave := cChave + &cCpo
				endif
			Else
				if !Chv_ == readvar()
					cUlCpo := &Chv_
				endif
				Exit
			endif
		Enddo
		cChv_ := cChave + cUlCpo
	Else
		cChv_ := (&Chv_)
	Endif
	DbGotop()
	DbSeek(xFilial(cAlias)+cChv_)
	Achou_ := FOUND()

	DbSetOrder(ind_)
	IF Empty(sem_dbf)
		Sele 0
	ELSE
		Sele (Atu_)
	ENDIF
	Set SoftSeek(.f.)
	if cCom != " "
		M->&cCpoDest := &cCom
	endif
Return Achou_

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  13/07/01   º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i, j

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := Left(cPerg + Space(15), Len(SX1->X1_GRUPO))
	If DBSeek(cPerg + "01") .and. (Alltrim(SX1->X1_PERGUNT) <> "Ordem Itens")
		While !EOF() .and. SX1->X1_GRUPO == cPerg
			RecLock("SX1", .F., .T.)
			SX1->(DBDelete())
			MsUnLock()
			DbSelectArea("SX1")
			SX1->(DbSkip())
		EndDo
	EndIf

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Ordem Itens"        ,"","","mv_ch1","N",1,0,1,"C","","MV_PAR1","Sequencia","","","","","Grupo+Codigo","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Ordem Servicos"     ,"","","mv_ch2","N",1,0,1,"C","","MV_PAR2","Sequencia","","","","","Tipo de Servico","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Mostra Desconto"    ,"","","mv_ch3","N",1,0,2,"C","","MV_PAR3","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Imprime Cod Item   ","","","mv_ch4","N",1,0,2,"C","","MV_PAR4","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Imprime Cod Servico","","","mv_ch5","N",1,0,2,"C","","MV_PAR5","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i := 1 to Len(aRegs)
		If !DBSeek(cPerg+aRegs[i, 2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i, j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	// Alteração da Descrição do Primeiro Parâmetro
	If DBSeek(cPerg+aRegs[1,2]) .and. Alltrim(SX1->X1_DEF02) <> "Grupo+Codigo"
		RecLock("SX1",.f.)
		SX1->X1_DEF02 := "Grupo+Codigo"
		MsUnlock()
	Endif

	DBSelectArea(_sAlias)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao ³IMPMEMOOBS º Imprime campo Memo VS1_OBSERV º Data ³ 20/09/2022 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ImpMemoOBS(oReport)

	Local i	:= 0
	Local oSection19 := oReport:Section(19)

	cVar	:= MSMM(VS1->VS1_OBSMEM,,,,3,,,"VS1")
	nLinha 	:= MlCount(cVar,100,,.T.)

	For i := 1 to nLinha
		oSection19:Cell("OBS1"):SetValue(MemoLine(cVar,100,i,,.T.))
		oSection19:PrintLine()
	Next i

Return
