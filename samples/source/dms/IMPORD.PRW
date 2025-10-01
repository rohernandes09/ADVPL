#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³  IMPORD ³ Atual. ³ Alecsandre Ferreira	³ Data ³ 23/11/21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao da Ordem de Servico John Deere                   ³±±
±±³Descricao_2 ³ Adequação a LGPD, alterar rotina de impressão para a     ³±±
±±³              classe TReport	23/11/2021							      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPORD()
	Local oReport
	Private aParam    := ParamIXB
	Private cNroOS 	  := aParam[1]
	Private cDesc     := "Impressao da Ordem de Servico"
	Private cPerg     := "IMPORD"
	Private cNomeRel  := "IMPORD"
	Private cTitulo   := "IMPORD"
	Private aEmp      := FwLoadSM0()
	Private nEmp      := aScan(aEmp, {|i| i[1] == cEmpAnt .AND. i[2] == cFilAnt})

	oReport := RptDefIO()
    oReport:nFontBody := 8
    oReport:oPage:nPaperSize := 9
	oReport:Section(3):SetLineStyle()
	oReport:Section(4):SetLineStyle()
	oReport:Section(5):SetLineStyle()
    oReport:PrintDialog()
Return

Static Function RptDefIO()
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

	oReport := TReport():New(;
        cNomeRel,;
        cTitulo,;
        ,;
        {|oReport| RunRptIO(oReport)},;
        cDesc;
    )

	oReport:SetLineHeight(45)

	// Dados da Empresa
	oSection1 := TRSection():New(oReport)
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

	//Dados de Recepcionista e Data de OS
	oSection2 := TRSection():New(oReport) 
	TRCell():New(oSection2, "RECEPCIONISTA", "",    "",,                25)
	TrCell():New(oSection2, "VAI_CODTEC",    "VAI", "Código",,          15)
	TrCell():New(oSection2, "VAI_NOMTEC",    "VAI", "Nome",,            30)
	TrCell():New(oSection2, "VO1_DATABE",    "VO1", "Dt. Emissao",,     30)
	TrCell():New(oSection2, "VO1_HORABE",    "VO1", "Hr. Emissao",,     30,,, "LEFT",, "LEFT")
	TrCell():New(oSection2, "VO1_DATENT",    "VO1", "Dt. Entr. Prev.",, 30)
	oSection2:SetLinesBefore(2)

	// Dados Cliente
	oSection3 := TRSection():New(oReport)
	TrCell():New(oSection3, "A1_COD",    "SA1", "Cód. Cli.",,     10)
	TrCell():New(oSection3, "A1_NOME",   "SA1", "Cliente",,       25)
	TrCell():New(oSection3, "A1_CGC",    "SA1", "CPF/CNPJ", "@!", 25)
	TrCell():New(oSection3, "A1_TEL",    "SA1", "Fone",,          20)
	TrCell():New(oSection3, "A1_END",    "SA1", "Endereço",,      25)
	TrCell():New(oSection3, "A1_BAIRRO", "SA1", "Bairro",, 	      15)
	TrCell():New(oSection3, "A1_MUN",    "SA1", "Cidade",,        20)
	TrCell():New(oSection3, "A1_EST",    "SA1", "Estado",,        10)
	TrCell():New(oSection3, "A1_EMAIL",  "SA1", "Email",,         20)
	oSection3:SetLinesBefore(2)

	// Tipo de Usuario
	oSection4 := TRSection():New(oReport)
	TrCell():New(oSection4, "COL1", "", " ",, 20,,, "RIGHT")
	TrCell():New(oSection4, "COL2", "", " ",, 20,,, "CENTER")
	TrCell():New(oSection4, "COL3", "", " ",, 25,,, "CENTER")
	TrCell():New(oSection4, "COL4", "", " ",, 25,,, "CENTER")
	TrCell():New(oSection4, "COL5", "", " ",, 25,,, "CENTER")

	//Dados da Máquina
	oSection5 := TRSection():New(oReport)
	TrCell():New(oSection5, "VV2_DESMOD", "VV2", "Modelo",,      30)
	TrCell():New(oSection5, "VE1_DESMAR", "VE1", "Marca",,       30)
	TrCell():New(oSection5, "VV1_CHASSI", "VV1", "Chassi",,      30)
	TrCell():New(oSection5, "VV1_NUMMOT", "VV1", "Motor",, 	     30)
	TrCell():New(oSection5, "VV1_PLAVEI", "VV1", "Placa",, 	     20)
	TrCell():New(oSection5, "VVC_DESCRI", "VVC", "Cor",, 	     15)
	TrCell():New(oSection5, "VO1_KILOME", "VO1", "Km.",, 		 20,,, "LEFT",, "LEFT")
	TrCell():New(oSection5, "VV1_FABMOD", "VV1", "Ano",,         15)
	TrCell():New(oSection5, "VO1_HORTRI", "VO1", "Hora Trilha",, 15,,, "LEFT",, "LEFT")
	TrCell():New(oSection5, "VO1_TPATEN", "VO1", "Tipo Atend.",, 20)
	TrCell():New(oSection5, "VV1_DATVEN", "VV1", "Dt. Venda",, 	 15)
	TrCell():New(oSection5, "M0_NOMECOM", "SM0", "Conc. Venda",, 30)
	oSection5:SetLinesBefore(1)

	//Titulo OS
	oSection6 := TRSection():New(oReport)
	TrCell():New(oSection6, "ORCAMT1", "", "Col1",,        30,,,  "CENTER")
	TrCell():New(oSection6, "ORCAMTO", "", "Numero Orç.",, 180,,, "CENTER")
	TrCell():New(oSection6, "ORCAMT2", "", "Col3",,        30,,,  "CENTER")
	oSection6:SetHeaderSection(.F.)
	oSection6:SetLinesBefore(2)

	//Serviços Solicitados
	oSection7 := TRSection():New(oReport)
	TrCell():New(oSection7, "VO6_CODSER", "VO6", "Código",,           30)
	TrCell():New(oSection7, "VO6_DESSER", "VO6", "Descr. Serviço",,   30)
	TrCell():New(oSection7, "VO4_KILROD", "VO4", "Tempo/KM", "@!",    20,,, "RIGHT")
	TrCell():New(oSection7, "VO4_VALHOR", "VO4", "Vlr. Unit. Serv.",, 20)
	TrCell():New(oSection7, "VOO_TOTSRV", "VOO", "Vlr. Total",,       20)
	oSection7:SetLinesBefore(2)

	//Serviços Executados
	oSection8 := TRSection():New(oReport)
	TrCell():New(oSection8, "VO4_DATINI", "VO4", "Dt. Inic.",,  30)
	TrCell():New(oSection8, "VO4_HORINI", "VO4", "Hr. Inic.",,  30,,, "LEFT",, "LEFT")
	TrCell():New(oSection8, "VO4_DATFIN", "VO4", "Dt. Final",,  30)
	TrCell():New(oSection8, "VO4_HORFIN", "VO4", "Hr. Final",,  30,,, "LEFT",, "LEFT")
	TrCell():New(oSection8, "VAI_CODTEC", "VAI", "Cód. Prod.",, 30)
	TrCell():New(oSection8, "VAI_NOMTEC", "VAI", "Nome",,       30)

	//Total de Serviços
	oSection9 := TRSection():New(oReport)
	TrCell():New(oSection9, "VOO_TOTSRV2", "VOO", " Subtotal de Serviços ",, 25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSection9, "VZ1_VALDES",  "VZ1", " Decontos ",,             25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSection9, "VOO_TOTSRV",  "VOO", " Total de Serviços ",,    25,,, "CENTER",,,,,,,, .T.)
	oSection9:SetLinesBefore(2)
	oSection9:SetLineStyle()

	//Itens
	oSection10 := TRSection():New(oReport)
	TrCell():New(oSection10, "BM_GRUPO",   "SB1", "Grupo",,           30)
	TrCell():New(oSection10, "B1_CODITE",  "SB1", "Código",,          30)
	TrCell():New(oSection10, "B1_DESC",    "SB1", "Descrição",,       30)
	TrCell():New(oSection10, "VO3_QTDREQ", "VO3", "Quant.",,          30)
	TrCell():New(oSection10, "VO3_VALPEC", "VO3", "Vlr. Unit.",,      30)
	TrCell():New(oSection10, "VO3_VALLIQ", "VO3", "Vlr. Total", "@!", 30,,, "RIGHT")
	oSection10:SetLinesBefore(2)

	//Total de Itens
	oSection11 := TRSection():New(oReport)
	TrCell():New(oSection11, "VO3_VALPEC", "VO3", " Subtotal de Peças ",,   25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSection11, "VZ1_VALDES", "VZ1", " Decontos ",,            25,,, "CENTER",,,,,,,, .T.)
	TrCell():New(oSection11, "VO3_VALLIQ", "VO3", " Total de Peças ", "@!", 30,,, "CENTER",,,,,,,, .T.)
	oSection11:SetLinesBefore(2)
	oSection11:SetLineStyle()

	// Total Geral
	oSection12 := TRSection():New(oReport)
	TrCell():New(oSection12, "TOT1", "", " ",,    			    38)
	TrCell():New(oSection12, "TOT2", "", " ",,                  38)
	TrCell():New(oSection12, "TOT3", "", " Total Geral ", "@!", 30,,,"RIGHT",,,,,,,,.T.)
	oSection12:SetLinesBefore(2)
	oSection12:SetLineStyle()

	// Observação
	oSection13 := TRSection():New(oReport)
	TrCell():New(oSection13, "OBS1", "", " ",, 10)
	TrCell():New(oSection13, "OBS2", "", " ",, 60)
	TrCell():New(oSection13, "OBS3", "", " ",, 10,,, "CENTER")
	TrCell():New(oSection13, "OBS4", "", " ",, 60,,, "CENTER")
	TrCell():New(oSection13, "OBS5", "", " ",, 10,,, "CENTER")
	oSection13:SetLinesBefore(2)
	oSection13:SetHeaderSection(.F.)

	oSection14:=TRSection():New(oReport)
	TrCell():New(oSection14, "COL1", "", " ",, 20)
	TrCell():New(oSection14, "OBS1", "", " ",, 160)
	oSection14:SetLinesBefore(2)
	oSection14:SetHeaderSection(.F.)
Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o  ³ RunRptIO ³ Atualiz. ³ Alecsandre Ferriera  ³ Data ³ 23.11.21 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ordem de Serviço.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunRptIO(oReport)
	Local oSection1  := oReport:Section(1)
	Local oSection2  := oReport:Section(2)
	Local oSection3  := oReport:Section(3)
	Local oSection4  := oReport:Section(4)
	Local oSection5  := oReport:Section(5)
	Local oSection6  := oReport:Section(6)
	Local oSection7  := oReport:Section(7)
	Local oSection8  := oReport:Section(8)
	Local oSection9  := oReport:Section(9)
	Local oSection10 := oReport:Section(10)
	Local oSection11 := oReport:Section(11)
	Local oSection12 := oReport:Section(12)
	Local oSection13 := oReport:Section(13)
	Local oSection14 := oReport:Section(14)
	Local lApontSrv := .F.
	Local lNFin     := .F.
	Local lTemApont := .F.
	Local _nTotGer  := 0
	Local _nTotGerP := 0
	Local nValDes   := 0
	Local _nTotSub  := 0
	Local _nTotDes  := 0
	Local _nVlDesP  := 0
	Local nCntFor   := 0
	Local nCntFor2  := 0
	Local cObsVO1   := 0
	Local cTipTem   := ""
	Local _cQuery   := ""
	Local aOSTTPC   := {}
	Local aOSTTSC   := {}
	Local aAuxS     := {}
	Private nTipo       := 18
	Private cTipPrg     := ""	
	Private nTotPec     := 0	
	Private nTotPecRes  := 0
	Private nTotal      := 0
	Private nDesconto   := 0
	Private cTipoTempo  := ""
	Private lVO6_VALSER := VO6->(FieldPos("VO6_VALSER")) > 0

	if Type("nFormul") != "U"
		if nFormul == 2
			if Type("ParamIXB") != "U"
				cTipTem := ParamIxb[03]
			Endif
		Endif
	Endif

	If MsgYesNo("Imprime os Apontamentos dos Serviços?", "Atenção")
		lApontSrv := .T.
	EndIf

	//Calculo Peças
	aOSTTPC := FMX_CALPEC(cNroOs, cTipTem,,,, .T.,,,,,,,,, .F.)

	//Calculo Serviços
	aOSTTSC := FMX_CALSER(cNroOs, cTipTem,,, lApontSrv, .T.)

	DBSelectArea("VO1")
	DbSetOrder(1)
	DbSeek(xFilial("VO1")+cNroOS)

	DbSelectArea("VAI")
	DBSetOrder(1)
	DbSeek(xFilial("VAI")+VO1->VO1_FUNABE)

	DBSelectArea("VV1")
	DBSetOrder(1)
	DBSeek(xFilial("VV1")+VO1->VO1_CHAINT)

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

	// Dados Recepcionista
	oSection2:Init()
	oSection2:Cell("RECEPCIONISTA"):SetValue("Recepcionista:")
	oSection2:Cell("VAI_CODTEC"):SetValue(VAI->VAI_CODTEC)
	oSection2:Cell("VAI_NOMTEC"):SetValue(VAI->VAI_NOMTEC)
	oSection2:Cell("VO1_DATABE"):SetValue(VO1->VO1_DATABE)
	oSection2:Cell("VO1_HORABE"):SetValue(VO1->VO1_HORABE)
	oSection2:Cell("VO1_DATENT"):SetValue(VO1->VO1_DATENT)
	oSection2:PrintLine()
	oSection2:Finish()

	DbSelectArea("SA1")
	DBSetOrder(1)
	If !(DBSeek(xFilial("SA1")+VO1->VO1_FATPAR+VO1->VO1_LOJA))
		DbSeek(xFilial("SA1")+VO1->VO1_PROVEI+VO1->VO1_LOJPRO)
	Endif

	// Dados Cliente
	oSection3:Init()
	oSection3:Cell("A1_COD"):SetValue(SA1->A1_COD)
	oSection3:Cell("A1_NOME"):SetValue(SA1->A1_NOME)
	oSection3:Cell("A1_CGC"):SetValue(Iif(SA1->A1_PESSOA == 'J', Transform(SA1->A1_CGC, "@R 99.999.999/9999-99"), Transform(SA1->A1_CGC, "@R 999.999.999-99")))
	oSection3:Cell("A1_TEL"):SetValue(Iif(!Empty(VAM->VAM_DDD), "(" + VAM->VAM_DDD + ") ", "(  )") + SA1->A1_TEL)
	oSection3:Cell("A1_END"):SetValue(SA1->A1_END)
	oSection3:Cell("A1_BAIRRO"):SetValue(SA1->A1_BAIRRO)
	oSection3:Cell("A1_MUN"):SetValue(SA1->A1_MUN)
	oSection3:Cell("A1_EST"):SetValue(SA1->A1_EST)
	oSection3:Cell("A1_EMAIL"):SetValue(SA1->A1_EMAIL)
	oSection3:PrintLine()
	oSection3:Finish()

	oSection4:Init()
	oSection4:SetHeaderSection(.F.)
	oSection4:Cell("COL1"):SetValue(" ")
	oSection4:Cell("COL2"):SetValue(" ")
	oSection4:Cell("COL3"):SetValue("[ ] Usuário")
	oSection4:Cell("COL4"):SetValue("[ ] Condutor")
	oSection4:Cell("COL5"):SetValue("[ ] Proprietário")
	oSection4:PrintLine()
	oSection4:Finish()

	DbSelectArea("VV1")
	DbSetOrder(1)
	DbSeek(xFilial("VV1")+VO1->VO1_CHAINT)

	DbSelectArea("VV2")
	DbSetOrder(4)
	DbSeek(xFilial("VV2")+VV1->VV1_MODVEI)

	DbSelectArea("VE1")
	DbSetOrder(1)
	DbSeek(xFilial("VE1")+VV2->VV2_CODMAR)

	// Dados Máquina
	oSection5:Init()
	oSection5:Cell("VV2_DESMOD"):SetValue(VV2->VV2_DESMOD)
	oSection5:Cell("VE1_DESMAR"):SetValue(VE1->VE1_DESMAR)
	oSection5:Cell("VV1_CHASSI"):SetValue(VV1->VV1_CHASSI)
	oSection5:Cell("VV1_NUMMOT"):SetValue(VV1->VV1_NUMMOT)
	oSection5:Cell("VV1_PLAVEI"):SetValue(VV1->VV1_PLAVEI)
	oSection5:Cell("VVC_DESCRI"):SetValue(VVC->VVC_DESCRI)
	oSection5:Cell("VO1_KILOME"):SetValue(VO1->VO1_KILOME)
	oSection5:Cell("VV1_FABMOD"):SetValue(VV1->VV1_FABMOD)
	oSection5:Cell("VO1_HORTRI"):SetValue(VO1->VO1_HORTRI)
	If !Empty(VO1->VO1_TPATEN)
		oSection5:Cell("VO1_TPATEN"):SetValue(VO1->VO1_TPATEN + ' - ' + OFIOA560DS("050",VO1->VO1_TPATEN) )
	Else
		oSection5:Cell("VO1_TPATEN"):Hide()
	Endif
	oSection5:Cell("VV1_DATVEN"):SetValue(VV1->VV1_DATVEN)
	oSection5:Cell("M0_NOMECOM"):SetValue(SM0->M0_NOMECOM)
	oSection5:PrintLine()
	oSection5:Finish()

	//Titulo
	oSection6:Init()
	oSection6:Cell("ORCAMT1"):SetValue("")
	oSection6:Cell("ORCAMTO"):SetValue("***** Orçamento: " + VO1->VO1_NUMOSV + " *****")
	oSection6:Cell("ORCAMT2"):SetValue("")
	oSection6:PrintLine()
	oSection6:Finish()

	if Len(aOSTTSC) > 0
		//Seção Serviços
		oSection6:Init()
		oSection6:Cell("ORCAMT1"):SetValue("")
		oSection6:Cell("ORCAMTO"):SetValue("***** SERVIÇOS *****")
		oSection6:Cell("ORCAMT2"):SetValue("")
		oSection6:PrintLine()
		oSection6:Finish()

		//Serviços Executados
		oSection7:Init()
		For nCntFor := 1 to Len(aOSTTSC)
			If lTemApont .AND. nCntFor <> 1
				oSection7:Init()
				lNFin := .T.
			Endif

			If lApontSrv
				lTemApont := Apont(Alltrim(VO1->VO1_NUMOSV), Alltrim(aOSTTSC[nCntFor][2]))
			Endif

			oSection7:Cell("VO6_CODSER"):SetValue(aOSTTSC[nCntFor][2])
			oSection7:Cell("VO6_DESSER"):SetValue(aOSTTSC[nCntFor][15])

			// Pego o NOSNUM através do NUMOSV
			_cQuery := " SELECT "
			_cQuery += " 	VO4_NOSNUM, "
			_cQuery += " 	VO4_KILROD, "
			_cQuery += " 	VO4_PREKIL "
			_cQuery += " FROM "
			_cQuery += " 	" + RetSqlName("VO4") + " VO4 "
			_cQuery += " WHERE "
			_cQuery += " 	VO4_FILIAL = '" + xFilial("VO4") + "' "
			_cQuery += " 	AND VO4_NUMOSV = '" + aOSTTSC[nCntFor][3] + "' "
			_cQuery += " 	AND VO4_CODSER = '" + aOSTTSC[nCntFor][2] + "' "
			_cQuery += " 	AND D_E_L_E_T_ = ' ' "

			TcQuery _cQuery New Alias "TVO4"

			DbSelectArea("TVO4")
			DbGoTop()

			IF !TVO4->(EOF())
				_cNUMOSV := TVO4->VO4_NOSNUM
				_nKilRod := TVO4->VO4_KILROD
				_nVO4Pre := TVO4->VO4_PREKIL
			Endif

			If _nKilRod > 0
				oSection7:Cell("VO4_KILROD"):SetValue(Transform(_nKilRod, GetSX3Cache("VO4_KILROD", "X3_PICTURE")))
				oSection7:Cell("VO4_VALHOR"):SetValue(aOSTTSC[nCntFor, 7] / _nKilRod)
				oSection7:Cell("VOO_TOTSRV"):SetValue(aOSTTSC[nCntFor, 7])
			Else
				oSection7:Cell("VO4_KILROD"):SetValue(Transform((aOSTTSC[nCntFor, 10] / 100), GetSX3Cache("VO4_KILROD", "X3_PICTURE")))
				oSection7:Cell("VO4_VALHOR"):SetValue(aOSTTSC[nCntFor, 7] / (aOSTTSC[nCntFor, 10] / 100))
				oSection7:Cell("VOO_TOTSRV"):SetValue(aOSTTSC[nCntFor, 7])
			Endif

			_nTotSub += aOSTTSC[nCntFor][7]
			_nTotDes += aOSTTSC[nCntFor][8]

			oSection7:PrintLine()

			If lApontSrv .AND. Len(aOSTTSC[nCntFor, 14]) > 0 .AND. lTemApont
				// Imprime Apontamentos de Serviços
				oSection8:Init()
				aAuxS := aClone(aOSTTSC[nCntFor, 14])
				aSort(aAuxS,,, {|x, y| DtoS(x[2]) + StrZero(x[3], 4) < DtoS(y[2]) + StrZero(y[3], 4)}) // Ordem: Data / Hora Inicial
				For nCntFor2 := 1 to len(aAuxS)
					If !Empty(aAuxS[nCntFor2, 2])
						oSection8:Cell("VO4_DATINI"):SetValue(/*Transform(*/aAuxS[nCntFor2, 2]/*,"@D")*/)
						oSection8:Cell("VO4_HORINI"):SetValue(/*Transform(*/aAuxS[nCntFor2, 3]/*,"@R 99:99")*/)
						oSection8:Cell("VO4_DATFIN"):SetValue(/*Transform(*/aAuxS[nCntFor2, 4]/*,"@D")*/)
						oSection8:Cell("VO4_HORFIN"):SetValue(/*Transform(*/aAuxS[nCntFor2, 5]/*,"@R 99:99")*/)
						oSection8:Cell("VAI_CODTEC"):SetValue(aAuxS[nCntFor2, 1])
						oSection8:Cell("VAI_NOMTEC"):SetValue(aAuxS[nCntFor2, 12])
						oSection8:PrintLine()
					Endif
				Next
				oSection8:Finish()
				oSection7:Finish()
			EndIf
			TVO4->(DBCloseArea())
		Next
		If !lNFin
			oSection7:Finish()
		Endif

		nValDes := 0
		DbSelectArea("VZ1")
		DbSetOrder(1)
		DbSeek(xFilial("VZ1")+VO1->VO1_NUMOSV)
		While !VZ1->(EOF()) .and. xFilial("VZ1")==VZ1->VZ1_FILIAL .and. VZ1->VZ1_NUMOSV==VO1->VO1_NUMOSV
			If Alltrim(VZ1->VZ1_PECSER) == "S"
				nValDes += VZ1->VZ1_VALDES
			Endif
			If Alltrim(VZ1->VZ1_PECSER) ==  "P"
				_nVlDesP += VZ1->VZ1_VALDES
			Endif
			VZ1->(DbSkip())
		EndDo

		_nTotGer := _nTotSub - _nTotDes
		oSection9:Init()
		oSection9:Cell("VOO_TOTSRV2"):SetValue(_nTotSub)
		oSection9:Cell("VZ1_VALDES"):SetValue(_nTotDes)
		oSection9:Cell("VOO_TOTSRV"):SetValue(_nTotGer)
		oSection9:PrintLine()
		oSection9:Finish()
	Endif

	// Peças Requisitadas
	If Len(aOSTTPC) > 0
		oSection6:Init()
		oSection6:Cell("ORCAMT1"):SetValue("")
		oSection6:Cell("ORCAMTO"):SetValue("****** PEÇAS ******")
		oSection6:Cell("ORCAMT2"):SetValue("")
		oSection6:PrintLine()
		oSection6:Finish()

		oSection10:Init()
	Endif
	For nCntFor := 1 to Len(aOSTTPC)
		If aOSTTPC[nCntFor, 5] > 0
			oSection10:Cell("BM_GRUPO"):SetValue(aOSTTPC[nCntFor, 1])
			oSection10:Cell("B1_CODITE"):SetValue(aOSTTPC[nCntFor, 2])
			oSection10:Cell("B1_DESC"):SetValue(aOSTTPC[nCntFor, 13])
			oSection10:Cell("VO3_QTDREQ"):SetValue(aOSTTPC[nCntFor, 5])
			oSection10:Cell("VO3_VALPEC"):SetValue(aOSTTPC[nCntFor, 6])
			oSection10:Cell("VO3_VALLIQ"):SetValue(Transform(aOSTTPC[nCntFor, 10], "@E 999,999.99"))
			oSection10:PrintLine()
			nTotPec += aOSTTPC[nCntFor, 10]
		Endif
	Next
	If Len(aOSTTPC) > 0
		oSection10:Finish()

		_nTotGerP := nTotPec - _nVlDesP
		oSection11:Init()
		oSection11:Cell("VO3_VALPEC"):SetValue(nTotPec)
		oSection11:Cell("VZ1_VALDES"):SetValue(_nVlDesP)
		oSection11:Cell("VO3_VALLIQ"):SetValue(Transform(_nTotGerP, "@E 999,999.99"))
		oSection11:PrintLine()
		oSection11:Finish()
	Endif

	oSection12:Init()
	oSection12:Cell("TOT1"):SetValue("")
	oSection12:Cell("TOT2"):SetValue("")
	oSection12:Cell("TOT3"):SetValue(Transform(_nTotGer + _nTotGerP, "@E 999,999.99"))
	oSection12:PrintLine()
	oSection12:Finish()

	oSection4:Init()
	oSection4:Cell("COL1"):SetValue("Pagamento: ")
	oSection4:Cell("COL2"):SetValue("[ ] à Vista")
	oSection4:Cell("COL3"):SetValue("[ ] Cartão de Crédito")
	oSection4:Cell("COL4"):SetValue("[ ] Parcelado")
	oSection4:Cell("COL5"):SetValue(" ")
	oSection4:PrintLine()
	oSection4:Finish()

	cObsVO1 := MSMM(VO1->VO1_OBSMEM, TamSX3('VO1_OBSERV')[1], , , 3, , , 'VO1', 'VO1_OBSMEM') // Recolhe Texto da tabela SYP

	oSection14:Init()

	For nCntFor := 1 To MLCount(cObsVO1)
		oSection14:Cell("COL1"):SetValue("")

		If nCntFor == 1
			oSection14:Cell("OBS1"):SetValue("OBS: " + MemoLine(cObsVO1,, nCntFor))
		Else
			oSection14:Cell("OBS1"):SetValue("     " + MemoLine(cObsVO1,, nCntFor))
		Endif
		oSection14:PrintLine()
	Next
	
	oSection14:Finish()
	oReport:IncRow()

	If !(oReport:nRow < oReport:oPage:nVertRes - (14 * oReport:nXlSRow))
		For nCntFor := 1 To 14 //Incrementar 14 Linhas Definidas pelo parametro do tamanho de linha em pixels
			oReport:IncRow()
		Next
	endif

	oSection13:Init()
	oSection13:Cell("OBS1"):SetValue("")
	oSection13:Cell("OBS2"):SetValue("Autorizo a execução dos serviços acima relacionados:")
	oSection13:Cell("OBS3"):SetValue("")
	oSection13:Cell("OBS4"):SetValue(VO1->VO1_DATABE)
	oSection13:Cell("OBS5"):SetValue("")
	oSection13:PrintLine()
	oReport:IncRow()
	oSection13:Cell("OBS1"):SetValue("")
	oSection13:Cell("OBS2"):SetValue("Cliente:" + SA1->A1_NOME)
	oSection13:Cell("OBS3"):SetValue("")
	oSection13:Cell("OBS4"):SetValue(Replicate("_", 48))
	oSection13:Cell("OBS5"):SetValue("")
	oSection13:PrintLine()
	oSection13:Cell("OBS1"):SetValue("")
	oSection13:Cell("OBS2"):SetValue("")
	oSection13:Cell("OBS3"):SetValue("")
	oSection13:Cell("OBS4"):SetValue("Assinatura do Cliente ou Pessoa Autorizada")
	oSection13:Cell("OBS5"):SetValue("")
	oSection13:PrintLine()

	For nCntFor := 1 to 3
		oReport:IncRow()
	Next

	oSection13:Cell("OBS1"):SetValue("")
	oSection13:Cell("OBS2"):SetValue("Veículo Retirado em: ")
	oSection13:Cell("OBS3"):SetValue("")
	oSection13:Cell("OBS4"):SetValue(Replicate(" ", 5) + "/" + Replicate(" ", 5) + "/" + Replicate(" ", 5))
	oSection13:Cell("OBS5"):SetValue("")
	oSection13:PrintLine()
	oReport:IncRow()
	oSection13:Cell("OBS1"):SetValue("")
	oSection13:Cell("OBS2"):SetValue("Cliente:" + SA1->A1_NOME)
	oSection13:Cell("OBS3"):SetValue("")
	oSection13:Cell("OBS4"):SetValue(Replicate("_", 48))
	oSection13:Cell("OBS5"):SetValue("")
	oSection13:PrintLine()
	oSection13:Cell("OBS1"):SetValue("")
	oSection13:Cell("OBS2"):SetValue("")
	oSection13:Cell("OBS3"):SetValue("")
	oSection13:Cell("OBS4"):SetValue("Assinatura do Cliente ou Pessoa Autorizada")
	oSection13:Cell("OBS5"):SetValue("")
	oSection13:PrintLine()
	oSection13:Finish()

	//Encerramento das Tabelas
	VO1->(DbCloseArea())
	VAI->(DbCloseArea())
	SA1->(DbCloseArea())
	VV1->(DbCloseArea())
	VV2->(DbCloseArea())
	VE1->(DbCloseArea())
	VZ1->(DbCloseArea())
Return

// Alecsandre Ferreira
// Verifica se há apontamentos, caso queira imprimir os apontamentos.
Static Function Apont(cCodOS, cCodServ)
	Local cQryApont := " "
	Local lTemApont := .F.

	cQryApont := " SELECT "
	cQryApont += " 	VO4_DATINI DATA "
	cQryApont += " FROM "
	cQryApont += " 	" + RetSqlName("VO4") + " VO4 "
	cQryApont += " WHERE "
	cQryApont += " 	VO4_FILIAL = '" + xFilial("VO4") + "' "
	cQryApont += " 	AND VO4_NUMOSV = '" + cCodOS + "' "
	cQryApont += " 	AND D_E_L_E_T_ = ' ' "
	cQryApont += " 	AND VO4_CODSER = '" + cCodServ + "' "

	TcQuery cQryApont New Alias "TCAPNT"

	DbSelectArea("TCAPNT")
	DbGoTop()
	While !TCAPNT->(EOF())
		If !Empty(TCAPNT->DATA)
			lTemApont := .T.
			Exit
		Endif
		TCAPNT->(DbSkip())
	EndDo
	TCAPNT->(DBCloseArea())
Return lTemApont
