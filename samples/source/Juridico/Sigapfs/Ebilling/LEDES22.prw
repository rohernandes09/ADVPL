#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} LEDES21
Geração de arquivos E-billing XML nas versões 2.2

@Param  PARAMIXB      Array com os dados fatura
         PARAMIXB[1]  Código da fatura
         PARAMIXB[2]  Código do escritório da fatura
         PARAMIXB[3]  Código da moeda Ebilling
         PARAMIXB[4]  Nome do arquivo Ebilling
         PARAMIXB[5]  Diretório ONde será gerado o arquivo ebilling
         PARAMIXB[6]  Se .T. indica que veio da automação

@author Abner Fogaça
@since 07/12/2023
/*/
//-------------------------------------------------------------------
User Function LEDES22()
Local oDlg        := Nil
Local ONArquivo   := Nil
Local oDArquivo   := Nil
Local oEscri      := Nil
Local oFatura     := Nil
Local oMoeda      := Nil
Local aButtONs    :={}
Local cDArquivo   := GetSrvProfString("RootPath", "") + "\"
Local cNArquivo   := cEmpAnt + cFilAnt + __cUserId
Local oLayer      := FWLayer():New()
Local cEscri      := Space(TamSx3('NS7_COD')[1])
Local aRetArq     := {.T., ""}
Local cF3         := RetSXB()
Local lWebApp     := GetRemoteType() == 5
Local cFatura     := ""
Local cCodesc     := ""
Local cMoeEbi     := ""
Local cNArq       := ""
Local cDArq       := ""
Local lAutomato   := .F.

Default ParamIXB := {}

If Len(ParamIXB) > 0
	cFatura     := ParamIXB[1]
	cCodesc     := ParamIXB[2]
	cMoeEbi     := ParamIXB[3]
	cNArq       := ParamIXB[4]
	cDArq       := ParamIXB[5]
	lAutomato   := ParamIXB[6]
EndIf

If lAutomato
	aRetArq := RunQuery(cFatura, cCodEsc, cMoeEbi, cNArq, cDArq, lAutomato)
Else
	DEFINE MSDIALOG oDlg TITLE "Geração de Arquivo XML LEDES2.0" FROM 010,0 TO 250,500 PIXEL //"Geração de Arquivo XML LEDES2.x"

	oLayer:init(oDlg, .F.)

	oLayer:addCollumn("MainColl", 100, .F.)

	oDlg:lEscClose := .F.

	ONArquivo := TJurPnlCampo():New(05,20,200,20, oLayer:GetColPanel( 'MainColl' ), "Nome do Arquivo:",, {|| }, {|| cNArquivo := ONArquivo:GetValue() }, Space(50),,,)
	ONArquivo:SetHelp("Indique o nome do arquivo a ser gerado.")
	
	If !lWebApp
		oDArquivo := TJurPnlCampo():New(32,20,130,20, oLayer:GetColPanel( 'MainColl' ), "Informe o caminho",, {|| }, {|| cDArquivo := oDArquivo:GetValue() }, Space(100),,,)
		oDArquivo:SetHelp("Indique o caminho para geração do arquivo.")
	EndIf

	If lWebApp
		oEscri    := TJurPnlCampo():New(32,20,42,20,oLayer:GetColPanel( 'MainColl' ),"Cod.Escrit.:",'NS7_COD',{|| },{|| cEscri := oEscri:GetValue()},,,, 'NS7')
	Else
		oEscri    := TJurPnlCampo():New(59,20,40,20,oLayer:GetColPanel( 'MainColl' ),"Cod.Escrit.:",'NS7_COD',{|| },{|| cEscri := oEscri:GetValue()},,,, 'NS7')
	EndIf
	oEscri:SetValid( {|| Empty(oEscri:GetValue()) .Or. ExistCpo('NS7', oEscri:GetValue(), 1) .And. JEBillMoe(oEscri, oFatura, oMoeda) } )
	oEscri:SetHelp("Código do escritório da fatura para a qual será gerado o arquivo e-billing.")
	
	If lWebApp
		oFatura := TJurPnlCampo():New(32,90,60,20,oLayer:GetColPanel( 'MainColl' ),"Fatura:",'NXA_COD',{|| },{|| },,,, cF3)
	Else
		oFatura := TJurPnlCampo():New(59,90,60,20,oLayer:GetColPanel( 'MainColl' ),"Fatura:",'NXA_COD',{|| },{|| },,,, cF3)
	EndIf	
	oFatura:SetValid( {|| Empty(oFatura:GetValue()) .Or. (ExistCpo('NXA', oEscri:GetValue() + oFatura:GetValue(), 1) .And. JEBillFatCanc(oEscri, oFatura) .And. JEBILLMOE(oEscri, oFatura, oMoeda)) } )
	oFatura:oCampo:bWhen   := {|| !Empty(oEscri:GetValue())}
	oFatura:SetHelp("Código da fatura para a qual será gerado o arquivo e-billing.")
	oFatura:Refresh()

	If lWebApp
		oMoeda := TJurPnlCampo():New(32,179,40,20, oLayer:GetColPanel( 'MainColl' ), "Moeda E-billing:", 'CTO_MOEDA',{|| },{|| },,,, 'CTO')
	Else
		oMoeda := TJurPnlCampo():New(59,180,40,20, oLayer:GetColPanel( 'MainColl' ), "Moeda E-billing:", 'CTO_MOEDA',{|| },{|| },,,, 'CTO')
	EndIf
	oMoeda:SetHelp("Código da moeda com a qual será gerado o arquivo e-billing.")
	oMoeda:SetValid( {|| Empty(oMoeda:GetValue()) .Or. ExistCpo('CTO', oMoeda:GetValue(), 1) } )

	If !lWebApp
		oBtDir :=	TButtON():New( 42,160,"...", oLayer:GetColPanel( 'MainColl' ), {||oDArquivo:SetValue(AllTrim(cGetFile("*.*", "SeleciONe o Diretorio p/ gerar o Arquivo", 0,, .T., GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_NETWORKDRIVE)))},10,10,,,, .T.)
	EndIf

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| Iif(!Empty(oEscri:GetValue()) .And. !Empty(oFatura:GetValue()) .And. !Empty(oMoeda:GetValue()),;
													MsgRun( "Procesando archivo XML.", "Espere...", {|| aRetArq := RunQuery( oFatura:GetValue(), cEscri, oMoeda:GetValue(), ONArquivo:GetValue(), IIF(lWebApp, "", oDArquivo:GetValue()), lAutomato ) } ) ,Alert("Processando arquivo TXT","Aguarde...") )},{||oDlg:End()},,aButtONs)
EndIf

Return (aRetArq)

//-------------------------------------------------------------------
/*/{Protheus.doc} RunQuery
MONtagem das querys com campos dinâmicos.

@author SISJURI
@since 10/05/2010
/*/
//-------------------------------------------------------------------
Static Function RunQuery(cFatura, cCodEsc, cMoeEbi, cNArq, cDArq, lAutomato)
Local aArea           := GetArea()
Local cCodFatura      := ""
Local cCodEscrit      := ""
Local cQryPrin        := ""
Local cTrbPrin        := ""
Local cQryMatter      := ""
Local cTrbMatter      := ""
Local cQryTkSum       := ""
Local cTrbTkSum       := ""
Local cQryFee         := ""
Local cTrbFee         := ""
Local cQryExpens      := ""
Local cTrbExpens      := ""
Local cCodChv         := ""
Local nPercFat        := 0
Local nMTotDetFees    := 0
Local nMTotDetExp     := 0
Local nMNetFees       := 0
Local nMNetExp        := 0
Local nMTotalDue      := 0
Local nMDesconto      := 0
Local nMInvPayTerms   := 0
Local nMInvGenDisc    := 0
Local nMInvTotDue     := 0
Local nPerDesLin      := 0
Local nPerDesFee      := 0

Local cPerDesFee      := "0.00"
Local cMTotDetFees    := ""
Local cMTotDetExp     := ""
Local cMNetFees       := ""
Local cMNetExp        := ""
Local cMTotalDue      := ""


Local cMAdj           := "0"
Local cMAdjFees       := "0"
Local cMAdjEXP        := "0"
Local cExpRate        := ""

Local nFeeUnit        := 0
Local nFeeRate        := 0
Local nFeeBaseAmount  := 0
Local nFeeTotAmount   := 0
Local nExpRate        := 0
Local nValorH         := 0

Local cFeeUnit        := ""
Local cFeeRate        := ""
Local cFeeBaseAmount  := ""
Local cFeeTotAmount   := ""
Local cDescFix        := ""

Local nExpTotAmount  := 0
Local nItemNbr       := 0
Local cExpTotAmount  := ""
Local lTemTS         := .F.
Local lTemDP         := .F.
Local aLog           := {}

Local cMoeFat        := ""
Local cMoeDesc       := ""
Local cDescri        := ""
Local cClientePg     := ""
Local cLojaPg        := ""
Local cCpoGrossH     := IIf(NXA->(ColumnPos("NXA_VGROSH")) > 0, " + NXA.NXA_VGROSH", "") // @12.1.2310
Local cVlrISS        := IIF(JurGetDados("SA1", 1, xFilial("SA1") + NXA->NXA_CLIPG + NXA->NXA_LOJPG, "A1_RECISS") == "1" .And. GetNewPar("MV_DESCISS",.F.), "NXA.NXA_ISS NXA_ISS", "0")
Local nValor         := 0
Local aValor         := {}
Local aPerFat        := JGetPerFT(cFatura, cCodEsc)
Local aRet           := {.T., ""}
Local aFatPag        := JurGetDados('NXA', 1, xFilial('NXA') + cCodEsc + cFatura, {'NXA_CMOEDA','NXA_CLIPG','NXA_LOJPG','NXA_CCLIEN','NXA_CLOJA' })

	If Len(aFatPag) > 0
		cMoeFat := aFatPag[1]
		cQryPrin := "SELECT NRX_COD FROM " + RetSQLName("NRX") 
		cQryPrin += " INNER JOIN " + RetSQLName("NUH") +" ON ( NRX_COD = NUH_CEMP AND NUH_LOJA = '" + aFatPag[3] + "') "
		cQryPrin += " WHERE NUH_COD  = '" + aFatPag[2] + "'"
		
		If Len(JurSQL(cQryPrin, 'NRX_COD')) > 0
			// Cliente Pagador
			cClientePg :=  aFatPag[2]
			cLojaPg    :=  aFatPag[3]
		else
			// Cliente da Fatura
			cClientePg :=  aFatPag[4]
			cLojaPg    :=  aFatPag[5]
		EndIf

		cQryPrin := ""
	EndIf

	cMoeEbi := Iif(Empty(cMoeEbi), cMoeFat, cMoeEbi)

	cCodFatura := cFatura
	cCodEscrit := cCodEsc 

	cQryPrin := " SELECT ( NXA.NXA_VLFATH + NXA.NXA_VLACRE - NXA.NXA_VLDESC - NXA_IRRF - NXA_PIS - NXA_COFINS - NXA_CSLL - NXA_INSS - " + cVlrISS + ") + NXA.NXA_VLFATD " + cCpoGrossH + " AS INV_TOTAL_NET_DUE,"
	cQryPrin +=          " NXA.*, "
	cQryPrin +=          " NS7.*, "
	cQryPrin +=          " NUH.NUH_CLIEBI, "
	cQryPrin +=          " SU5.U5_CONTAT, "
	cQryPrin +=          " CTO.CTO_DESC, "
	cQryPrin +=          " CTO.CTO_CODISO, "
	cQryPrin +=          " RD0.RD0_NOME, "
	cQryPrin +=          " SYA_ESC.YA_DESCR PAIS_ESC, "
	cQryPrin +=          " SYA_CLI.YA_DESCR PAIS_CLI, "
	cQryPrin +=          " NXA.R_E_C_N_O_ AS RECNO_NXA, "
	cQryPrin +=          " CC2.CC2_MUN "
	cQryPrin +=    " FROM  "+ RetSqlName("NXA") + " NXA "
	cQryPrin +=    " INNER JOIN "+RetSqlname("NUH")+" NUH  "
	cQryPrin +=         " ON ( NUH.NUH_FILIAL = '"+xFilial("NUH")+"'"
	cQryPrin +=              " AND NUH.NUH_COD = '" + cClientePg + "'"
	cQryPrin +=              " AND NUH.NUH_LOJA ='" + cLojaPg + "'"
	cQryPrin +=              " AND NUH.D_E_L_E_T_ = ' ')  "
	cQryPrin +=    " INNER JOIN "+RetSqlname("SA1") + " SA1  "
	cQryPrin +=         " ON ( SA1.A1_FILIAL = '" + xFilial("SA1") + "'"
	cQryPrin +=              " AND SA1.A1_COD = NUH.NUH_COD "
	cQryPrin +=              " AND SA1.A1_LOJA = NUH.NUH_LOJA"
	cQryPrin +=              " AND SA1.D_E_L_E_T_ = ' ')  "	
	cQryPrin +=    " INNER JOIN "+RetSqlname("NRX")+" NRX  "
	cQryPrin +=         " ON( NRX.NRX_FILIAL     = '"+xFilial("NRX")+"'"
	cQryPrin +=         " AND NRX.NRX_COD    = NUH.NUH_CEMP "
	cQryPrin +=         " AND NRX.D_E_L_E_T_ = ' ')  "
	cQryPrin +=    " LEFT JOIN " + RetSqlName("SU5") + " SU5 "
	cQryPrin +=          " ON ( SU5.U5_FILIAL  = '" + xFilial("SU5") + "' "
	cQryPrin +=          " AND SU5.U5_CODCONT = NXA.NXA_CCONT "
	cQryPrin +=          " AND SU5.D_E_L_E_T_ = ' ' ) "
	cQryPrin +=    " LEFT JOIN " + RetSqlName("NS7") + " NS7  "
	cQryPrin +=          " ON ( NS7.NS7_FILIAL = '" + xFilial("NS7") + "' "
	cQryPrin +=          " AND NS7.NS7_COD    = NXA.NXA_CESCR "
	cQryPrin +=          " AND NS7.D_E_L_E_T_ = ' ' ) "
	cQryPrin +=    " LEFT JOIN " + RetSqlName("CC2") + " CC2  "
	cQryPrin +=          " ON ( CC2.CC2_FILIAL = '" + xFilial("CC2") + "' "
	cQryPrin +=          " AND CC2.CC2_CODMUN  = NS7.NS7_CMUNIC "
	cQryPrin +=          " AND CC2.CC2_EST = NS7.NS7_ESTADO "
	cQryPrin +=          " AND CC2.D_E_L_E_T_ = ' ') "
	cQryPrin +=    " LEFT JOIN " + RetSqlName("SYA") + " SYA_ESC  "
	cQryPrin +=          " ON ( SYA_ESC.YA_FILIAL  = '" + xFilial("SYA") + "' "
	cQryPrin +=          " AND SYA_ESC.YA_CODGI   = NS7.NS7_CPAIS "
	cQryPrin +=          " AND SYA_ESC.D_E_L_E_T_ = ' ') "
	cQryPrin +=    " LEFT JOIN " + RetSqlName("SYA") + " SYA_CLI  "
	cQryPrin +=          " ON ( SYA_CLI.YA_FILIAL  = '" + xFilial("SYA") + "' "
	cQryPrin +=          " AND SYA_CLI.YA_CODGI   = SA1.A1_PAIS "
	cQryPrin +=          " AND SYA_CLI.D_E_L_E_T_ = ' ') "	
	cQryPrin +=    " LEFT JOIN " + RetSqlName("CTO") + " CTO  "
	cQryPrin +=          " ON ( CTO.CTO_FILIAL = '" + xFilial("CTO") + "' "
	cQryPrin +=          " AND CTO.CTO_MOEDA  = NXA.NXA_CMOEDA "
	cQryPrin +=          " AND CTO.D_E_L_E_T_ = ' ') "
	cQryPrin +=    " LEFT JOIN " + RetSqlName("RD0") + " RD0  "
	cQryPrin +=          " ON ( RD0.RD0_FILIAL = '" + xFilial("RD0") + "' "
	cQryPrin +=          " AND NXA.NXA_CPART  = RD0.RD0_CODIGO "
	cQryPrin +=          " AND RD0.D_E_L_E_T_ = ' ') "
	cQryPrin +=    " where NXA.NXA_FILIAL = '" + xFilial("NXA") + "' "
	cQryPrin +=      " AND NXA.NXA_COD    = '" + cFatura + "' "
	cQryPrin +=      " AND NXA.NXA_CESCR  = '" + cCodEsc + "' "
	cQryPrin +=      " AND NXA.D_E_L_E_T_ = ' ' "

	If Select("TRBPRIN")>0
		DbSelectArea("TRBPRIN")
		TRBPRIN->(DbCloseArea())
	EndIf

	cTRBPRIN := ChangeQuery(cQryPrin)
	cTRBPRIN := StrTran(cTRBPRIN,'#','')
	dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cTRBPRIN ) ,"TRBPRIN", .T., .F.)

	aArqXml:={}
	DbSelectArea("TRBPRIN")
	If TRBPRIN->(!Eof())
		Aadd(aArqXml,"<?xml version='1.0' encoding='UTF-8' ?>")
		Aadd(aArqXml,"<ledesxmlebilling2.2 xmlns='http://www.ledes.org/LEDES22.xsd'>")
		
		Do While TRBPRIN->(!Eof()) .And. aRet[1]
			cCodChv := TRBPRIN->NS7_COD
			
			Do While TRBPRIN->(!Eof()) .And. cCodChv == TRBPRIN->NS7_COD .And. aRet[1]
				//=========================================
				//@FIRM Segment - Informações sobre o escritório cujas faturas foram enviadas
				//=========================================
				nItemNbr ++
				Aadd(aArqXml, Space(3) + "<firm>")
				If !Empty(TRBPRIN->NS7_COD)
					Aadd(aArqXml,Space(6)+"<lf_vendor_id>"+Alltrim(TRBPRIN->NS7_COD)+"</lf_vendor_id>")
					Aadd(aArqXml,Space(6)+"<lf_id>"+Alltrim(TRBPRIN->NS7_COD)+"</lf_id>")
				EndIf
				If !Empty(TRBPRIN->NS7_NOME)
					Aadd(aArqXml,Space(6)+"<lf_name>"+Alltrim(TRBPRIN->NS7_NOME)+"</lf_name>")
				EndIf
				//=========================================
				//@ADDRESS_INFO - Informações sobre o endereço do escritório.
				//=========================================
				Aadd(aArqXml,Space(6)+"<lf_address>")
				If !Empty(TRBPRIN->NS7_END)
					Aadd(aArqXml,Space(12)+"<address_1>"+Alltrim(TRBPRIN->NS7_END)+"</address_1>")
				EndIf
				If !Empty(TRBPRIN->CC2_MUN)
					Aadd(aArqXml,Space(12)+"<city>"+Alltrim(TRBPRIN->CC2_MUN)+"</city>")
				EndIf
				If !Empty(TRBPRIN->NS7_ESTADO)
					Aadd(aArqXml,Space(12)+"<state_province>"+Alltrim(TRBPRIN->NS7_ESTADO)+"</state_province>")
				EndIf
				If !Empty(TRBPRIN->NS7_CEP)
					Aadd(aArqXml,Space(12)+"<zip_postal_code>"+Alltrim(TRBPRIN->NS7_CEP)+"</zip_postal_code>")
				EndIf
				
				Aadd(aArqXml,Space(12)+"<country>" + Alltrim(TRBPRIN->PAIS_ESC) + "</country>")
				
				If !Empty(TRBPRIN->NS7_TEL)
					Aadd(aArqXml,Space(12)+"<phone>"+Alltrim(TRBPRIN->NS7_TEL)+"</phone>")
					Aadd(aArqXml,Space(12)+"<fax>"+Alltrim(TRBPRIN->NS7_TEL)+"</fax>")
				EndIf
				Aadd(aArqXml,Space(6)+"</lf_address>")
				//=========================================
				//@CONTACT_INFO Segment - Informações sobre o(s) contato(s) do escritório.
				//=========================================
				Aadd(aArqXml,Space(6)+"<lf_billing_contact>")
				If !Empty(TRBPRIN->NS7_CTNAC)
					Aadd(aArqXml,Space(6)+"<contact_lname>"+ RetFLName(1, TRBPRIN->NS7_CTNAC)+"</contact_lname>")
					Aadd(aArqXml,Space(6)+"<contact_fname>"+RetFLName(2,TRBPRIN->NS7_CTNAC)+"</contact_fname>")
				EndIf
				If !Empty(TRBPRIN->NXA_CPART)
					Aadd(aArqXml,Space(6)+"<contact_id>"+Alltrim(TRBPRIN->NXA_CPART)+"</contact_id>")
				EndIf
				If !Empty(TRBPRIN->NS7_TEL)
					Aadd(aArqXml,Space(6)+"<contact_phone>"+Alltrim(TRBPRIN->NS7_TEL)+"</contact_phone>")
					Aadd(aArqXml,Space(6)+"<contact_fax>"+Alltrim(TRBPRIN->NS7_TEL)+"</contact_fax>")
				EndIf
				If !Empty(TRBPRIN->NS7_EMAIL)
					Aadd(aArqXml,Space(6)+"<contact_email>"+Alltrim(TRBPRIN->NS7_EMAIL)+"</contact_email>")
				EndIf
				Aadd(aArqXml,Space(6)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
				Aadd(aArqXml,Space(6)+"</lf_billing_contact>")
				Aadd(aArqXml,Space(6)+"<source_app>SIGAPFS</source_app>")
				Aadd(aArqXml,Space(6)+"<app_version>2.0</app_version>")
				nItemNbr ++
				Aadd(aArqXml,Space(6)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
				Do While TRBPRIN->(!Eof()) .And. cCodChv == TRBPRIN->NS7_COD .And. aRet[1]
				//=========================================
				//@CLIENT Segment - Informações sobre o(s) cliente(s) para quem as faturas são enviadas pelo escritório.
				//=========================================
					Aadd(aArqXml,Space(3)+"<client>")
					If !Empty(TRBPRIN->NXA_CCLIEN+TRBPRIN->NXA_CLOJA) .Or. !Empty(TRBPRIN->NUH_CLIEBI)
						Aadd(aArqXml,Space(6)+"<cl_id>"+Alltrim(Iif(Empty(TRBPRIN->NUH_CLIEBI), TRBPRIN->NXA_CCLIEN+TRBPRIN->NXA_CLOJA, TRBPRIN->NUH_CLIEBI))+"</cl_id>") 
						Aadd(aArqXml,Space(6)+"<cl_lf_id>"+Alltrim(Iif(Empty(TRBPRIN->NUH_CLIEBI), TRBPRIN->NXA_CCLIEN+TRBPRIN->NXA_CLOJA, TRBPRIN->NUH_CLIEBI))+"</cl_lf_id>")
					EndIf
					If !Empty(TRBPRIN->NXA_RAZSOC)
						Aadd(aArqXml,Space(6)+"<cl_name>"+Alltrim(TRBPRIN->NXA_RAZSOC)+"</cl_name>")               
					EndIf

					Aadd(aArqXml,Space(9)+"<cl_address>")

					If !Empty(TRBPRIN->NXA_ENDENT)
						Aadd(aArqXml,Space(15)+"<address_1>"+Alltrim(TRBPRIN->NXA_ENDENT)+"</address_1>")
					EndIf
					If !Empty(TRBPRIN->CC2_MUN)
						Aadd(aArqXml,Space(15)+"<city>"+Alltrim(TRBPRIN->CC2_MUN)+"</city>")
					EndIf
					If !Empty(TRBPRIN->NS7_ESTADO)
						Aadd(aArqXml,Space(15)+"<state_province>"+Alltrim(TRBPRIN->NS7_ESTADO)+"</state_province>")
					EndIf
					If !Empty(TRBPRIN->NS7_CEP)
						Aadd(aArqXml,Space(15)+"<zip_postal_code>"+Alltrim(TRBPRIN->NS7_CEP)+"</zip_postal_code>")
					EndIf

					Aadd(aArqXml,Space(12)+"<country>" + Alltrim(TRBPRIN->PAIS_CLI) + "</country>")
					
					If !Empty(TRBPRIN->NS7_TEL)
						Aadd(aArqXml,Space(15)+"<phone>"+Alltrim(TRBPRIN->NS7_TEL)+"</phone>")
						Aadd(aArqXml,Space(15)+"<fax>"+Alltrim(TRBPRIN->NS7_TEL)+"</fax>")
					EndIf
					nItemNbr ++
					Aadd(aArqXml,Space(6)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
					Aadd(aArqXml,Space(9)+"</cl_address>")
					//=========================================
					//@CONTACT_INFO Segment - Informações sobre o(s) contato(s) do cliente.
					//=========================================
					Aadd(aArqXml,Space(9)+"<client_contact>")
					If !Empty(TRBPRIN->U5_CONTAT)
						Aadd(aArqXml,Space(6)+"<contact_lname>"+RetFLName(1, TRBPRIN->U5_CONTAT)+"</contact_lname>")
						Aadd(aArqXml,Space(6)+"<contact_fname>"+RetFLName(2, TRBPRIN->U5_CONTAT)+"</contact_fname>")
					EndIf
					If !Empty(TRBPRIN->NXA_EMAIL)
						Aadd(aArqXml,Space(6)+"<cl_email>"+Alltrim(TRBPRIN->NXA_EMAIL)+"</cl_email>")
					EndIf
					nItemNbr ++
					Aadd(aArqXml,Space(6)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
					Aadd(aArqXml,Space(9)+"</client_contact>")
					nItemNbr ++
					Aadd(aArqXml,Space(6)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
					//=========================================
					//@INVOICE Segment - Informações sobre a fatura
					//=========================================
					Aadd(aArqXml,Space(9)+"<invoice>")
					If !Empty(TRBPRIN->NXA_COD)
						Aadd(aArqXml,Space(12)+"<inv_id>"+Alltrim(TRBPRIN->NXA_COD)+"</inv_id>")
					EndIf
					If !Empty(TRBPRIN->NXA_DTEMI)
						Aadd(aArqXml,Space(12)+"<inv_date>"+JSToFormat(Alltrim(TRBPRIN->NXA_DTEMI), "YYYY-MM-DD")+"</inv_date>")
						Aadd(aArqXml,Space(12)+"<inv_due_date>"+Alltrim(TRBPRIN->NXA_DTEMI)+"</inv_due_date>")
					EndIf
					
					If cMoeEbi != cMoeFat
						cMoeDesc := JurGetDados('CTO',1,xFilial('CTO')+ cMoeEbi, 'CTO_CODISO')
					Else
						cMoeDesc := (TRBPRIN->CTO_CODISO)
					EndIf
					
					If !Empty(cMoeDesc)
						Aadd(aArqXml,Space(12)+"<inv_currency>"+Alltrim(cMoeDesc)+"</inv_currency>")
					EndIf
					If cMoeEbi != cMoeFat
						Aadd(aArqXml,Space(12)+"<inv_other_iso>"+Alltrim(TRBPRIN->CTO_CODISO)+"</inv_other_iso>")
					EndIf
					If !Empty(aPerFat)
						Aadd(aArqXml,Space(12)+"<inv_start_date>" + IIf(Len(aPerFat) > 1, JSToFormat(Alltrim(DtoS(aPerFat[1])), "YYYY-MM-DD"), JSToFormat(aPerFat[1][1], "YYYY-MM-DD")) + "</inv_start_date>")
						Aadd(aArqXml,Space(12)+"<inv_end_date>" + IIf(Len(aPerFat) > 1, JSToFormat(Alltrim(DtoS(aPerFat[2])), "YYYY-MM-DD"), JSToFormat(aPerFat[1][2], "YYYY-MM-DD")) + "</inv_end_date>")
					EndIf
					NXA->( dbGoTo( TRBPRIN->RECNO_NXA ) )
					cDescri := StrTran(NXA->NXA_TXTFAT, CRLF, " ")
					If !Empty(cDescri)
						Aadd(aArqXml,Space(12)+"<inv_desc>"+Alltrim(cDescri)+"</inv_desc>")
					EndIf
					
					Aadd(aArqXml,Space(12)+"<rejected_inv_replacement>" + Iif(!Empty(TRBPRIN->NXA_CFTSUB),"S","N") + "</rejected_inv_replacement>")
					
					dEmiFat :=  StoD(TRBPRIN->NXA_DTEMI)
					
					nMInvPayTerms := TRBPRIN->NXA_VLDESC
					aValor := JA201FConv( cMoeEbi, cMoeFat, nMInvPayTerms, '8', dEmiFat, , , , cCodEsc, cFatura )
					If !Empty(aValor[4])
						IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
						aRet[1] := .F.
						Exit
					Else
						nMInvPayTerms := Round(aValor[1],2)
					EndIf
					
					nMInvTotDue   := TRBPRIN->INV_TOTAL_NET_DUE
					aValor := JA201FConv( cMoeEbi, cMoeFat, nMInvTotDue, '8', dEmiFat, , , , cCodEsc, cFatura )
					If !Empty(aValor[4])
						IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
						aRet[1] := .F.
						Exit
					Else
						nMInvTotDue := Round(aValor[1], 2)
					EndIf
					
					nMInvGenDisc  := TRBPRIN->(NXA_IRRF+NXA_PIS+NXA_COFINS+NXA_CSLL+NXA_INSS+NXA_ISS)
					aValor := JA201FConv( cMoeEbi, cMoeFat, nMInvGenDisc, '8', dEmiFat, , , , cCodEsc, cFatura )
					If !Empty(aValor[4])
						IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
						aRet[1] := .F.
						Exit
					Else
						nMInvGenDisc := Round(aValor[1],2)
					EndIf
					
					Aadd(aArqXml,Space(12)+"<inv_payment_terms>"+Alltrim(Str(nMInvPayTerms))+"</inv_payment_terms>")
					Aadd(aArqXml,Space(12)+"<inv_total_tax>0</inv_total_tax>")
					Aadd(aArqXml,Space(12)+"<inv_total_net_due>"+Alltrim(Str(nMInvTotDue))+"</inv_total_net_due>")
					nItemNbr ++
					Aadd(aArqXml,Space(12)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
					
					cQryMatter := " SELECT NXC.*, NVE.NVE_TITULO, NVE.NVE_CPGEBI, NVE.NVE_MATTER, NVE.NVE_TITEBI, NT7.NT7_TITULO "
					cQryMatter += "   FROM " + RetSqlname("NXC") + " NXC "
					cQryMatter += "  INNER JOIN " + RetSqlname("NVE") + " NVE  "
					cQryMatter += "     ON (NVE.NVE_FILIAL = '" + xFilial("NVE") + "' "
					cQryMatter += "    AND  NXC.NXC_CCLIEN = NVE.NVE_CCLIEN "
					cQryMatter += "    AND  NXC.NXC_CLOJA  = NVE.NVE_LCLIEN "
					cQryMatter += "    AND  NXC.NXC_CCASO  = NVE.NVE_NUMCAS "
					cQryMatter += "    AND  NVE.D_E_L_E_T_ = ' ') "
					cQryMatter += "   LEFT OUTER JOIN " + RetSqlname("NT7") + " NT7  "
					cQryMatter += "     ON (NT7.NT7_FILIAL = '" + xFilial("NT7") + "' "
					cQryMatter += "    AND  NXC.NXC_CCLIEN = NT7.NT7_CCLIEN"
					cQryMatter += "    AND  NXC.NXC_CLOJA  = NT7.NT7_CLOJA"
					cQryMatter += "    AND  NXC.NXC_CCASO  = NT7.NT7_CCASO"
					cQryMatter += "    AND  NT7.NT7_CIDIOM = '" + TRBPRIN->NXA_CIDIO + "' "
					cQryMatter += "    AND  NT7.NT7_REV    = '1'"
					cQryMatter += "    AND  NT7.D_E_L_E_T_ = ' ') "
					cQryMatter += "  WHERE NXC.NXC_FILIAL = '" + xFilial("NXC") + "'  "
					cQryMatter += "    AND NXC.NXC_CESCR  = '" + TRBPRIN->NXA_CESCR + "' "
					cQryMatter += "    AND NXC.NXC_CFATUR = '" + TRBPRIN->NXA_COD + "' "
					cQryMatter += "    AND NXC.D_E_L_E_T_ = ' ' "
					
					If Select("TRBMATT") > 0
						DbSelectArea("TRBMATT")
						TRBMATT->(DbCloseArea())
					EndIf
					
					cTRBMatter := ChangeQuery(cQryMatter)
					dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cTRBMatter ), "TRBMATT", .T., .F.)
					
					//Percentual do pagador da fatura
					nPercFat := (TRBPRIN->NXA_PERFAT / 100)
					
					DbSelectArea("TRBMATT")
					TRBMATT->(dbGoTop())
					
					If TRBMATT->(!Eof())
						//=========================================
						//@MATTER Segment - Informações sobre o(s) caso(s) da fatura.
						//=========================================
						nItemNbr ++
						Aadd(aArqXml,Space(12)+"<matter>")
						
						Do While TRBMATT->(!Eof()) .And. aRet[1]
							If !Empty(TRBMATT->NVE_CPGEBI)
								Aadd(aArqXml,Space(15)+"<cl_matter_id>"+Alltrim(TRBMATT->NVE_CPGEBI)+"</cl_matter_id>")
							EndIf
							If Empty(TRBMATT->NVE_MATTER)
								JurEbilLog(aLog, "<lf_matter_id>", "Cliente/loja/Caso: " + TRBMATT->(NXC_CCLIEN+'/'+NXC_CLOJA+'/'+NXC_CCASO)+ CRLF + "Moeda E-billing:" +"<lf_matter_id>"+ " referente ao campo " +'"'+ RetTitle('NVE_MATTER') +'"'+ " não foi prenchida!" )
							EndIf
							Aadd(aArqXml,Space(15)+"<lf_matter_id>"+Alltrim(TRBMATT->NVE_MATTER)+"</lf_matter_id>")
							
							If !Empty(TRBMATT->NVE_TITEBI)
								Aadd(aArqXml,Space(15)+"<matter_name>"+Alltrim(TRBMATT->NVE_TITEBI)+"</matter_name>")
								Aadd(aArqXml,Space(15)+"<matter_desc>"+Alltrim(TRBMATT->NVE_TITEBI)+"</matter_desc>")
							Else
								If !Empty(TRBMATT->NT7_TITULO)
									Aadd(aArqXml,Space(15)+"<matter_name>"+Alltrim(TRBMATT->NT7_TITULO)+"</matter_name>")
									Aadd(aArqXml,Space(15)+"<matter_desc>"+Alltrim(TRBMATT->NT7_TITULO)+"</matter_desc>")
								Else
									Aadd(aArqXml,Space(15)+"<matter_name>"+Alltrim(TRBMATT->NVE_TITULO)+"</matter_name>")
									Aadd(aArqXml,Space(15)+"<matter_desc>"+Alltrim(TRBMATT->NVE_TITULO)+"</matter_desc>")
								EndIf
							EndIf
							If !Empty(TRBPRIN->NXA_PONUMB)
								Aadd(aArqXml,Space(15)+"<po_number>"+Alltrim(TRBPRIN->NXA_PONUMB)+"</po_number>")
							EndIf
							Aadd(aArqXml,Space(15)+"<account_type>O</account_type>")
							//=========================================
							//@CONTACT_INFO Segment - Informações sobre o(s) contato(s) da fatura
							//=========================================
							Aadd(aArqXml,Space(15)+"<lf_managing_contact>")
							If !Empty(TRBPRIN->RD0_NOME)
								Aadd(aArqXml,Space(15)+"<contact_lname>"+RetFLName(1, TRBPRIN->RD0_NOME)+"</contact_lname>")
								Aadd(aArqXml,Space(15)+"<contact_fname>"+RetFLName(2, TRBPRIN->RD0_NOME)+"</contact_fname>")
							EndIf
							If !Empty(TRBPRIN->NS7_TEL)
								Aadd(aArqXml,Space(15)+"<contact_phone>"+Alltrim(TRBPRIN->NS7_TEL)+"</contact_phone>")
							EndIf
							If !Empty(TRBPRIN->NS7_EMAIL)
								Aadd(aArqXml,Space(15)+"<contact_email>"+Alltrim(TRBPRIN->NS7_EMAIL)+"</contact_email>")
							EndIf
							If !Empty(TRBPRIN->NS7_CTNAC)
								Aadd(aArqXml,Space(15)+"<contact_lname>"+RetFLName(1,TRBPRIN->NS7_CTNAC)+"</contact_lname>")
								Aadd(aArqXml,Space(15)+"<contact_fname>"+RetFLName(2,TRBPRIN->NS7_CTNAC)+"</contact_fname>")
							EndIf
							If !Empty(TRBPRIN->NS7_TEL)
								Aadd(aArqXml,Space(15)+"<contact_phone>"+Alltrim(TRBPRIN->NS7_TEL)+"</contact_phone>")
							EndIf
							If !Empty(TRBPRIN->NS7_EMAIL)
								Aadd(aArqXml,Space(15)+"<contact_email>"+Alltrim(TRBPRIN->NS7_EMAIL)+"</contact_email>")
							EndIf
							Aadd(aArqXml,Space(15)+"</lf_managing_contact>")
							nMTotDetFees := (TRBMATT->NXC_VLHFAT - TRBMATT->NXC_VLTAB)
							aValor := JA201FConv( cMoeEbi, cMoeFat, nMTotDetFees, '8', dEmiFat, , , , cCodEsc, cFatura )
							If !Empty(aValor[4])
								IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
								aRet[1] := .F.
								Exit
							Else
								nMTotDetFees := Round(aValor[1],2)
								cMTotDetFees := Alltrim(Str(nMTotDetFees))
							EndIf
							
							nMTotDetExp  := (TRBMATT->NXC_VLDESP + TRBMATT->NXC_VLTAB)
							aValor := JA201FConv( cMoeEbi, cMoeFat, nMTotDetExp, '8', dEmiFat, , , , cCodEsc, cFatura )
							If !Empty(aValor[4])
								IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
								aRet[1] := .F.
								Exit
							Else
								nMTotDetExp := Round(aValor[1],2)
								cMTotDetExp := Alltrim(Str(nMTotDetExp ))
							EndIf
							
							nMNetFees    := (TRBMATT->NXC_VLHFAT - TRBMATT->NXC_VLTAB)
							aValor := JA201FConv( cMoeEbi, cMoeFat, nMNetFees, '8', dEmiFat, , , , cCodEsc, cFatura )
							If !Empty(aValor[4])
								IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
								aRet[1] := .F.
								Exit
							Else
								nMNetFees := Round(aValor[1],2)
								cMNetFees := Alltrim(Str(nMNetFees   ))
							EndIf
							
							nMNetExp     := (TRBMATT->NXC_VLDESP + TRBMATT->NXC_VLTAB)
							aValor := JA201FConv( cMoeEbi, cMoeFat, nMNetExp, '8', dEmiFat, , , , cCodEsc, cFatura )
							If !Empty(aValor[4])
								IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
								aRet[1] := .F.
								Exit
							Else
								nMNetExp := Round(aValor[1],2)
								cMNetExp := Alltrim(Str(nMNetExp    ))
							EndIf
							
							nMAcresc      := (TRBMATT->NXC_ARATF)
							nMDesconto    := (TRBMATT->NXC_DRATF)
							aValor := JA201FConv( cMoeEbi, cMoeFat, nMDesconto, '8', dEmiFat, , , , cCodEsc, cFatura )
							If !Empty(aValor[4])
								IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
								aRet[1] := .F.
								Exit
							Else
								nMDesconto := Round(aValor[1],2)
								If (nMDesconto > 0 .Or. nMAcresc > 0) .And. TRBMATT->NXC_VLTS <= 0 .And. TRBMATT->NXC_VFIXO <= 0
									cMAdjEXP  := Alltrim(Str(nMDesconto - nMAcresc))
								Else
									cMAdjFees := Alltrim(Str(nMDesconto - nMAcresc))
								EndIf

								cMAdj := Alltrim(Str(nMDesconto - nMAcresc))

								If nMDesconto > 0 .And. (TRBMATT->NXC_VLTS > 0 .Or. TRBMATT->NXC_VFIXO > 0)
									If TRBMATT->NXC_DRATL > 0 .And. (TRBMATT->NXC_DRATP <= 0 .Or. TRBMATT->NXC_DRATE <= 0)
										//Se tiver apenas o desconto linear considera somente o valor de timesheet
										nPerDesLin := Round(TRBMATT->NXC_DRATL / (TRBMATT->NXC_VLHFAT - TRBMATT->NXC_VLTAB - TRBMATT->NXC_VFIXO), 2)
									EndIf
									// Se tiver desconto linear junto com outros descontos (Especial ou Pagador), desconsidera o valor do desconto linear pois o mesmo já
									// foi calculado na variável nPerDesLin.
									If TRBMATT->NXC_DRATP > 0 .Or. TRBMATT->NXC_DRATE > 0
										//Se tiver não tiver o desconto linear considera o valor de timesheet e fixo
										nPerDesFee := Round((TRBMATT->NXC_DRATF - TRBMATT->NXC_DRATL) / (TRBMATT->NXC_VLHFAT - TRBMATT->NXC_VLTAB), 2)
									EndIf

									cPerDesFee := Alltrim(Str(nPerDesLin + nPerDesFee))
								EndIf
							EndIf

							nMTotalDue   := nMNetFees + nMNetExp
							aValor := JA201FConv( cMoeEbi, cMoeFat, nMTotalDue, '8', dEmiFat, , , , cCodEsc, cFatura )
							If !Empty(aValor[4])
								IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
								aRet[1] := .F.
								Exit
							Else
								nMTotalDue := Round(aValor[1],2)
								cMTotalDue := Alltrim(Str(nMTotalDue  ))
							EndIf
							
							Aadd(aArqXml,Space(15)+"<matter_final_bill>N</matter_final_bill>")
							Aadd(aArqXml,Space(15)+"<matter_total_detail_fees>" + cMTotDetFees + "</matter_total_detail_fees>")
							Aadd(aArqXml,Space(15)+"<matter_total_detail_exp>" + cMTotDetExp + "</matter_total_detail_exp>")
							Aadd(aArqXml,Space(15)+"<matter_disc_credit_fees>" + cMAdjFees + "</matter_disc_credit_fees>")
							Aadd(aArqXml,Space(15)+"<matter_disc_credit_exp>" + cMAdjEXP + "</matter_disc_credit_exp>")
							Aadd(aArqXml,Space(15)+"<matter_disc_cred_total>" + cMAdj + "</matter_disc_cred_total>")
							Aadd(aArqXml,Space(15)+"<matter_perc_shar_fees>1.00</matter_perc_shar_fees>")
							Aadd(aArqXml,Space(15)+"<matter_disc_bill_pct_fees>" + cPerDesFee + "</matter_disc_bill_pct_fees>")
							Aadd(aArqXml,Space(15)+"<matter_disc_bill_pct_exp>0.00</matter_disc_bill_pct_exp>")
							Aadd(aArqXml,Space(15)+"<matter_perc_shar_exp>1.00</matter_perc_shar_exp>")
							Aadd(aArqXml,Space(15)+"<matter_tax_on_fees>0.00</matter_tax_on_fees>")
							Aadd(aArqXml,Space(15)+"<matter_tax_on_exp>0.00</matter_tax_on_exp>")
							Aadd(aArqXml,Space(15)+"<matter_net_fees>" + cMNetFees + "</matter_net_fees>")
							Aadd(aArqXml,Space(15)+"<matter_net_exp>" + cMNetExp + "</matter_net_exp>")
							Aadd(aArqXml,Space(15)+"<matter_total_due>" + cMTotalDue + "</matter_total_due>")
							Aadd(aArqXml,Space(15)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
							
							//=========================================
							//@MATTER_DISC_CRED Segment - Todos os descontos, créditos e acréscimos aplicados nos casos da fatura.
							//=========================================

							If 	nMAcresc > 0
								Aadd(aArqXml,Space(15)+"<matter_disc_cred>")
								cDisCred   := "MIA"  // Um ajuste fixo (redução ou crédito) aplicado no nível do caso/fatura (quando utilizado valor fixo no acréscimo ou no desconto da pré-fatura).

								Aadd(aArqXml,Space(18)+"<disc_cred>" + cDisCred + "</disc_cred>")

								If Val(cMAdjFees) > 0
									Aadd(aArqXml,Space(18)+"<disc_cred_category>Fee</disc_cred_category>")
								ElseIf Val(cMAdjEXP) > 0
									Aadd(aArqXml,Space(18)+"<disc_cred_category>Exp</disc_cred_category>")
								EndIf

								Aadd(aArqXml,Space(18)+"<increase_decrease>Increase</increase_decrease>")
								Aadd(aArqXml,Space(18)+"<disc_cred_amount>" + Alltrim(Str(nMAcresc)) + "</disc_cred_amount>")

								nItemNbr ++
								Aadd(aArqXml,Space(18)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
								Aadd(aArqXml,Space(15)+"</matter_disc_cred>")
							EndIf

							If 	nMDesconto > 0
								cDescFix := JurGetDados("NX0", 1, xFilial("NX0") + TRBPRIN->NXA_CPREFT, "NX0_TPDESC")
								Aadd(aArqXml,Space(15)+"<matter_disc_cred>")

								If !Empty(cDescFix) .And. cDescFix == "1" // Desconto especial com valor fixo na pré-fatura.
									cDisCred := "MIA"  // Um ajuste fixo (redução ou crédito) aplicado no nível do caso/fatura (quando utilizado valor fixo no acréscimo ou no desconto da pré-fatura).
								ElseIf Empty(cDescFix) .Or. (!Empty(cDescFix) .And. cDescFix == "2")
									cDisCred   := "MIDB" // Fatura com desconto no caso/fatura - O cliente recebe um desconto percentual avaliado no nível do caso/fatura.
								EndIf

								Aadd(aArqXml,Space(18)+"<disc_cred>" + cDisCred + "</disc_cred>")

								If Val(cMAdjFees) > 0
									Aadd(aArqXml,Space(18)+"<disc_cred_category>Fee</disc_cred_category>")
								ElseIf Val(cMAdjEXP) > 0
									Aadd(aArqXml,Space(18)+"<disc_cred_category>Exp</disc_cred_category>")
								EndIf

								Aadd(aArqXml,Space(18)+"<increase_decrease>Decrease</increase_decrease>")
								
								If cDisCred == "MIDB"
									Aadd(aArqXml,Space(18)+"<pre_post_split>Pre-Split</pre_post_split>")
									Aadd(aArqXml,Space(18)+"<discount_percent>" + cPerDesFee + "</discount_percent>")
								EndIf

								nMDesconto := nMDesconto * -1
								Aadd(aArqXml,Space(18)+"<disc_cred_amount>" + Alltrim(Str(nMDesconto)) + "</disc_cred_amount>")

								nItemNbr ++
								Aadd(aArqXml,Space(18)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
								Aadd(aArqXml,Space(15)+"</matter_disc_cred>")
							EndIf

							cQryTkSum := " SELECT NXD.*, "
							cQryTkSum += "        RD0.RD0_NOME, "
							cQryTkSum += "        NS2.NS2_CCATE, "
							cQryTkSum += "        NRV.NRV_CCATE, "
							cQryTkSum += "        RD0.RD0_SIGLA, "
							cQryTkSum += "        NXA.NXA_PERFAT, "
							cQryTkSum += "        NUH.NUH_CEMP, "
							cQryTkSum += "        NUR.NUR_CCAT "
							cQryTkSum += "   FROM   "+RetSqlname("NXA")+" NXA  "
							cQryTkSum += "        INNER JOIN "+RetSqlname("NXD")+" NXD "
							cQryTkSum += "             ON( NXD.NXD_FILIAL     = '"+xFilial("NXD")+"'"
							cQryTkSum += "                 and NXD.NXD_CESCR  = NXA.NXA_CESCR"
							cQryTkSum += "                 and NXD.NXD_CFATUR = NXA.NXA_COD"
							cQryTkSum += "                 and NXD.NXD_CCLIEN = '" +TRBMATT->NXC_CCLIEN+ "'"
							cQryTkSum += "                 and NXD.NXD_CLOJA  = '" +TRBMATT->NXC_CLOJA+ "'"
							cQryTkSum += "                 and NXD.NXD_CCASO  = '" +TRBMATT->NXC_CCASO+ "'"
							cQryTkSum += "                 and NXD.D_E_L_E_T_ = ' ')"
							cQryTkSum += "        INNER JOIN "+RetSqlname("RD0")+" RD0 "
							cQryTkSum += "             ON( RD0.RD0_FILIAL     = '"+xFilial("RD0")+"'"
							cQryTkSum += "                 and RD0.RD0_CODIGO = NXD.NXD_CPART"
							cQryTkSum += "                 and RD0.D_E_L_E_T_ = ' ')"
							cQryTkSum += "        INNER JOIN "+RetSqlname("NUR")+" NUR "
							cQryTkSum += "             ON( NUR.NUR_FILIAL     = '"+xFilial("NUR")+"'"
							cQryTkSum += "                 and NUR.NUR_CPART  = NXD.NXD_CPART"
							cQryTkSum += "                 and NUR.D_E_L_E_T_ = ' ')"
							cQryTkSum += "        INNER JOIN "+RetSqlname("NUH")+" NUH  "
							cQryTkSum += "             ON( NUH.NUH_FILIAL     = '"+xFilial("NUH")+"'"
							cQryTkSum += "                 and NUH.NUH_COD    = '" +cClientePg+ "'"+ CRLF
							cQryTkSum += "                 and NUH.NUH_LOJA   = '" +cLojaPg+ "'"+ CRLF
							cQryTkSum += "                 and NUH.D_E_L_E_T_ = ' ')  "
							cQryTkSum += "        left JOIN "+RetSqlname("NRX")+" NRX  "
							cQryTkSum += "             ON( NRX.NRX_FILIAL     = '"+xFilial("NRX")+"'"
							cQryTkSum += "                 and NRX.NRX_COD    = NUH.NUH_CEMP"
							cQryTkSum += "                 and NRX.D_E_L_E_T_ = ' ')"
							cQryTkSum += "        left JOIN "+RetSqlname("NS2")+" NS2 "
							cQryTkSum += "             ON( NS2.NS2_FILIAL     = '"+xFilial("NS2")+"'"
							cQryTkSum += "                 and NS2.NS2_CCATEJ = NUR.NUR_CCAT"
							cQryTkSum += "                 and NS2.NS2_CDOC   = NRX.NRX_CDOC"
							cQryTkSum += "                 and NS2.D_E_L_E_T_ = ' ') "
							cQryTkSum += "        left JOIN "+RetSqlname("NRV")+" NRV "
							cQryTkSum += "             ON( NRV.NRV_FILIAL     = '"+xFilial("NRV")+"'"
							cQryTkSum += "                 and NRV.NRV_CDOC   = NS2.NS2_CDOC"
							cQryTkSum += "                 and NRV.NRV_COD    = NS2.NS2_CCATE"
							cQryTkSum += "                 and NRV.D_E_L_E_T_ = ' ')"
							cQryTkSum += " where  NXA.NXA_FILIAL     = '"+xFilial("NXA")+"' "
							cQryTkSum += "        and NXA.NXA_CESCR  = '"+TRBPRIN->NXA_CESCR+"' "
							cQryTkSum += "        and NXA.NXA_COD    = '"+TRBPRIN->NXA_COD+"'"
							cQryTkSum += "        and NXA.D_E_L_E_T_ = ' ' "
							
							If Select("TRBTK")>0
								DbSelectArea("TRBTK")
								TRBTK->(DbCloseArea())
							EndIf
							
							cTRBTkSum := ChangeQuery(cQryTkSum)
							dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cTRBTkSum ) ,"TRBTK", .T., .F.)
							
							DbSelectArea("TRBTK")
							TRBTK->(dbGoTop())
							If TRBTK->(!Eof())
								Do While TRBTK->(!Eof()) .And. aRet[1]
									//=========================================
									//@TKSUM Segment - Informações sobre o(s) participante(s) que lançaram timesheets.
									//=========================================
									nItemNbr ++
									Aadd(aArqXml,Space(15)+"<tk_sum>")
									If !Empty(TRBTK->NXD_CPART)
										Aadd(aArqXml,Space(18)+"<tk_id>"+Alltrim(TRBTK->NXD_CPART)+"</tk_id>")
									EndIf
									If !Empty(TRBTK->RD0_NOME)
										Aadd(aArqXml,Space(18)+"<tk_lname>"+RetFLName(1,TRBTK->RD0_NOME)+"</tk_lname>")
										Aadd(aArqXml,Space(18)+"<tk_fname>"+RetFLName(2,TRBTK->RD0_NOME)+"</tk_fname>")
									EndIf
									If !Empty(TRBTK->NRV_CCATE)
										Aadd(aArqXml,Space(18)+"<tk_level>"+Alltrim(TRBTK->NRV_CCATE)+"</tk_level>")
									EndIf
									
									nValor := (TRBTK->NXD_VLHORA)
									aValor := JA201FConv( cMoeEbi, (TRBTK->NXD_CMOEDT), nValor, '8', dEmiFat, , , , cCodEsc, cFatura )
									If !Empty(aValor[4])
										IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
										aRet[1] := .F.
										Exit
									Else
										nValor := Round(aValor[1],2)
									EndIf

									Aadd(aArqXml,Space(18)+"<tk_rate>"+Alltrim(Str(nValor))+"</tk_rate>")
									Aadd(aArqXml,Space(18)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
									Aadd(aArqXml,Space(15)+"</tk_sum>")
									TRBTK->(DbSkip())
								EndDo
							EndIf
							
							cQryFee := " SELECT"
							cQryFee += "     NUE.*, "
							cQryFee += "     NS0.NS0_CATIV, "
							cQryFee += "     NRZ.NRZ_CTAREF, "
							cQryFee += "     NUHB.NUH_CEMP, "
							cQryFee += "     NUR.NUR_CCAT, "
							cQryFee += "     NRV.NRV_CCATE, "
							cQryFee += "     RD0.RD0_SIGLA, "
							cQryFee += "     NRY.NRY_CFASE,  "
							cQryFee += "     NR2.NR2_DESC, "
							cQryFee += "     NUE.R_E_C_N_O_ NUERECNO  "
							cQryFee += " FROM"
							cQryFee += "     "+RetSqlname("NW0")+" NW0 "
							cQryFee += "     INNER JOIN "+RetSqlname("NUE")+" NUE "
							cQryFee += "         ON( NUE.NUE_FILIAL     = '"+xFilial("NUE")+"'"
							cQryFee += "             and NUE.NUE_COD    = NW0.NW0_CTS"
							cQryFee += "             and NUE.NUE_CCLIEN = '" +TRBMATT->NXC_CCLIEN+ "'"
							cQryFee += "             and NUE.NUE_CLOJA  = '" +TRBMATT->NXC_CLOJA+ "'"
							cQryFee += "             and NUE.NUE_CCASO  = '" +TRBMATT->NXC_CCASO+ "'"
							cQryFee += "             and NUE.NUE_VALOR1 > 0"
							cQryFee += "             and NUE.D_E_L_E_T_ = ' ' )"
							cQryFee += "     INNER JOIN "+RetSqlname("NUR")+" NUR "
							cQryFee += "         ON( NUR.NUR_FILIAL     = '"+xFilial("NUR")+"'"
							cQryFee += "             and NUR.NUR_CPART  = NUE.NUE_CPART2"
							cQryFee += "             and NUR.D_E_L_E_T_ = ' ')"
							cQryFee += "     INNER JOIN "+RetSqlname("NR2")+" NR2 "
							cQryFee += "         ON( NR2.NR2_FILIAL     = '"+xFilial("NR2")+"'"
							cQryFee += "             and NR2.NR2_CATPAR = NUR.NUR_CCAT"
							cQryFee += "             and NR2.NR2_CIDIOM = '" + TRBPRIN->NXA_CIDIO + "' "
							cQryFee += "             and NR2.D_E_L_E_T_ = ' ')"
							cQryFee += "     INNER JOIN "+RetSqlname("RD0")+" RD0 "
							cQryFee += "         ON( RD0.RD0_FILIAL     = '"+xFilial("RD0")+"'"
							cQryFee += "             and RD0.RD0_CODIGO = NUR.NUR_CPART "
							cQryFee += "             and RD0.D_E_L_E_T_ = ' ')"
							cQryFee +=     " left JOIN " + RetSqlName("NUH") + " NUH "
							cQryFee +=         " ON( NUH.NUH_FILIAL = '" + xFilial("NUH") + "'"
							cQryFee +=             " and NUH.NUH_COD =  '" +cClientePg+ "'"+ CRLF
							cQryFee +=             " and NUH.NUH_LOJA = '" +cLojaPg+ "'"+ CRLF
							cQryFee +=             " and NUH.D_E_L_E_T_ = ' ' )"
							cQryFee +=     " left JOIN " + RetSqlName("NUH") + " NUHB  "
							cQryFee +=         "  ON( NUHB.NUH_FILIAL     = '" + xFilial("NUH") + "'"
							cQryFee +=             "  and NUHB.NUH_COD    = NUE.NUE_CCLIEN "
							cQryFee +=             "  and NUHB.NUH_LOJA   = NUE.NUE_CLOJA "
							cQryFee +=             "  and NUHB.NUH_CEMP   = NUH.NUH_CEMP "
							cQryFee +=             "  and NUHB.D_E_L_E_T_ = ' ' ) "
							cQryFee += "     left JOIN "+RetSqlname("NRX")+" NRX "
							cQryFee += "         ON( NRX.NRX_FILIAL     = '"+xFilial("NRX")+"'"
							cQryFee += "             and NRX.NRX_COD    = NUH.NUH_CEMP"
							cQryFee += "             and NRX.D_E_L_E_T_ = ' ' )"
							cQryFee += "     left JOIN "+RetSqlname("NS2")+" NS2 "
							cQryFee += "             ON( NS2.NS2_FILIAL     = '"+xFilial("NS2")+"'"
							cQryFee += "                 and NS2.NS2_CCATEJ = NUR.NUR_CCAT"
							cQryFee += "                 and NS2.NS2_CDOC   = NRX.NRX_CDOC"
							cQryFee += "                 and NS2.D_E_L_E_T_ = ' ') "
							cQryFee += "     left JOIN "+RetSqlname("NRV")+" NRV "
							cQryFee += "             ON( NRV.NRV_FILIAL     = '"+xFilial("NRV")+"'"
							cQryFee += "                 and NRV.NRV_CDOC   = NS2.NS2_CDOC"
							cQryFee += "                 and NRV.NRV_COD    = NS2.NS2_CCATE"
							cQryFee += "                 and NRV.D_E_L_E_T_ = ' ')"
							cQryFee += "     left JOIN "+RetSqlname("NS0")+" NS0 "
							cQryFee += "         ON( NS0.NS0_FILIAL     = '"+xFilial("NS0")+"'"
							cQryFee += "             and NS0.NS0_CDOC   = NRX.NRX_CDOC"
							cQryFee += "             and NS0.NS0_CATIV  = NUE.NUE_CTAREB"
							cQryFee += "             and NS0.D_E_L_E_T_ = ' ' )"
							cQryFee += "     left JOIN "+RetSqlname("NRY")+" NRY "
							cQryFee += "         ON( NRY.NRY_FILIAL     = '"+xFilial("NRY")+"'"
							cQryFee += "             and NRY.NRY_CDOC   = NRX.NRX_CDOC"
							cQryFee += "             and NRY.NRY_CFASE  = NUE.NUE_CFASE"
							cQryFee += "             and NRY.D_E_L_E_T_ = ' ' )"
							cQryFee += "     left JOIN "+RetSqlname("NRZ")+" NRZ "
							cQryFee += "         ON( NRZ.NRZ_FILIAL     = '"+xFilial("NRZ")+"'"
							cQryFee += "             and NRZ.NRZ_CDOC   = NRX.NRX_CDOC"
							cQryFee += "             and NRZ.NRZ_CTAREF = NUE.NUE_CTAREF"
							cQryFee += "             and NRZ.D_E_L_E_T_ = ' ' )"
							cQryFee += " where"
							cQryFee += "     NW0.NW0_FILIAL     = '"+xFilial("NW0")+"'"
							cQryFee += "     and NW0.NW0_CESCR  = '"+TRBPRIN->NXA_CESCR+"'"
							cQryFee += "     and NW0.NW0_CFATUR = '"+TRBPRIN->NXA_COD+"' "
							cQryFee += "     and NW0.D_E_L_E_T_ = ' ' "
							cQryFee += " order by NUE.NUE_DATATS, NUE.NUE_COD "
							
							If Select("TRBFEE")>0
								DbSelectArea("TRBFEE")
								TRBFEE->(DbCloseArea())
							EndIf
							
							cTRBFee := ChangeQuery(cQryFee)
							dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cTRBFee ) ,"TRBFEE", .T., .F.)
							
							DbSelectArea("TRBFEE")
							TRBFEE->(dbGoTop())
							If TRBFEE->(!Eof())
								Do While TRBFEE->(!Eof()) .And. aRet[1]
									//=========================================
									//@FEE Segment - Informações sobre os honorários (timesheets) incluídos na fatura
									//=========================================
									nItemNbr ++
									Aadd(aArqXml,Space(15)+"<fee>")
									If !Empty(TRBFEE->NUE_DATATS)
										Aadd(aArqXml,Space(18)+"<charge_date>" + JSToFormat(Alltrim(TRBFEE->NUE_DATATS), "YYYY-MM-DD") + "</charge_date>")
									EndIf
									If !Empty(TRBFEE->NUE_CPART2)
										Aadd(aArqXml,Space(18)+"<tk_id>"+Alltrim(TRBFEE->NUE_CPART2)+"</tk_id>")
									EndIf
									
									Aadd(aArqXml,Space(18)+"<tk_level>" + Alltrim(TRBFEE->NR2_DESC) + " </tk_level>")
									
									NUE->( dbGoTo(TRBFEE->NUERECNO ))
									cDescri := StrTran(NUE->NUE_DESC, CRLF, " ")
									If !Empty(cDescri)
										Aadd(aArqXml,Space(18)+"<charge_desc>"+Alltrim(cDescri)+"</charge_desc>")
									EndIf
									
									If !Empty(TRBFEE->NUE_CTAREF)
										Aadd(aArqXml,Space(18)+"<task_code>"+Alltrim(TRBFEE->NRZ_CTAREF)+"</task_code>")
									EndIf
									If !Empty(TRBFEE->NS0_CATIV)
										Aadd(aArqXml,Space(18)+"<task_activity>"+Alltrim(TRBFEE->NS0_CATIV)+"</task_activity>")
									EndIf
									
									
									nValor1 := TRBFEE->NUE_VALOR1
									aValor := JA201FConv( cMoeEbi, TRBFEE->NUE_CMOED1, nValor1, '8', dEmiFat, , , , cCodEsc, cFatura )
									If !Empty(aValor[4])
										IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
										aRet[1] := .F.
										Exit
									Else
										nValor1 := aValor[1]
									EndIf
									
									nValorH := TRBFEE->NUE_VALORH
									aValor := JA201FConv( cMoeEbi, TRBFEE->NUE_CMOED1, nValorH, '8', dEmiFat, , , , cCodEsc, cFatura )
									If !Empty(aValor[4])
										IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
										aRet[1] := .F.
										Exit
									Else
										nValorH := aValor[1]
									EndIf
									
									nFeeUnit       := TRBFEE->NUE_TEMPOR * nPercFat
									nFeeRate       := Round(nValorH,4)
									nFeeBaseAmount := Round(nValor1 * nPercFat,2)
									nFeeTotAmount  := nFeeBaseAmount
									
									cFeeUnit       := Alltrim(Str(nFeeUnit      ))
									cFeeUnit       := JURA144C1(2, 3, cFeeUnit)
									cFeeRate       := Alltrim(Str(nFeeRate      ))
									cFeeBaseAmount := Alltrim(Str(nFeeBaseAmount))
									cFeeTotAmount  := Alltrim(Str(nFeeTotAmount ))
									
									Aadd(aArqXml,Space(18)+"<charge_type>U</charge_type>")
									If !Empty(cFeeUnit)
										Aadd(aArqXml,Space(18)+"<units>"+cFeeUnit+"</units>")
									EndIf
									
									Aadd(aArqXml,Space(18)+"<rate>"+cFeeRate+"</rate>")
									Aadd(aArqXml,Space(18)+"<base_amount>"+cFeeBaseAmount+"</base_amount>")
									Aadd(aArqXml,Space(18)+"<item_disc_cred_amount>0</item_disc_cred_amount>")
									Aadd(aArqXml,Space(18)+"<total_amount>"+cFeeTotAmount+"</total_amount>")
									Aadd(aArqXml,Space(18)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
									Aadd(aArqXml,Space(15)+"</fee>")
									
									aLog := LD98VlLanc(TRBFEE->NUE_COD, TRBFEE->NUE_CCLIEN, TRBFEE->NUE_CLOJA, TRBFEE->NUE_CCASO, TRBFEE->NUH_CEMP,;
										TRBFEE->NRV_CCATE , TRBFEE->NUR_CCAT, TRBFEE->RD0_SIGLA, TRBFEE->NRY_CFASE, TRBFEE->NRZ_CTAREF, TRBFEE->NS0_CATIV, "TS", aLog, "cEscEbi", "cEscrit" )
									
									lTemTS := .T.
									
									TRBFEE->(DbSkip())
								EndDo
							Else
								lTemTS := lTemTS .or. .F.
							EndIf

							cQryExpens := " SELECT expenses.*"
							cQryExpens += " FROM"
							cQryExpens += "     (SELECT"
							cQryExpens += "         NVY.NVY_DATA as charge_date,"
							cQryExpens += "         NVY.NVY_CPART as tk_id,"
							cQryExpens += "         NR2NVY.NR2_DESC as tk_level,"
							cQryExpens += "         NS3.NS3_CDESP as task_code,"
							cQryExpens += "         NVY.NVY_CCLIEN||NVY.NVY_CLOJA as cl_code_1,"
							cQryExpens += "         NVY.NVY_CCLIEN||NVY.NVY_CLOJA as cl_code_2,"
							cQryExpens += "         NVY.NVY_QTD as units,"
							cQryExpens += "         NVY.NVY_VALOR as total_amount, "
							cQryExpens += "     	NVY.NVY_COD as Exp_Codigo, "
							cQryExpens += "     	NVY.NVY_CCLIEN as Exp_Cliente, "
							cQryExpens += "     	NVY.NVY_CLOJA as Exp_Loja, "
							cQryExpens += "     	NVY.NVY_CCASO as Exp_Caso, "
							cQryExpens += "     	NUH.NUH_CEMP as Exp_Empresa, "
							cQryExpens += "         NS4.NS4_CDESPJ as Exp_Tipo, "
							cQryExpens += "         'DP' as Exp_Lanc, "
							cQryExpens += "         '1' as Ident, "
							cQryExpens += "         NVY.R_E_C_N_O_ as XXXRECNO, "
							cQryExpens += "     	NVY.NVY_CMOEDA as Exp_Moeda "
							cQryExpens += "      FROM"
							cQryExpens += "         " + RetSqlName("NXA") + " NXA "
							cQryExpens += "         INNER JOIN " + RetSqlName("NVZ") + " NVZ "
							cQryExpens += "             ON( NVZ.NVZ_FILIAL     = '" + xFilial("NVZ") + "'"
							cQryExpens += "                 and NVZ.NVZ_CESCR  = NXA.NXA_CESCR"
							cQryExpens += "                 and NVZ.NVZ_CFATUR = NXA.NXA_COD  "
							cQryExpens += "                 and NVZ.D_E_L_E_T_ = ' ' ) "
							cQryExpens += "         INNER JOIN " + RetSqlName("NVY") + " NVY "
							cQryExpens += "             ON( NVY.NVY_FILIAL     = '" + xFilial("NVY") + "'"
							cQryExpens += "                 and NVY.NVY_COD    = NVZ.NVZ_CDESP"
							cQryExpens += "             	and NVY.NVY_CCLIEN = '" +TRBMATT->NXC_CCLIEN+ "'"
							cQryExpens += "             	and NVY.NVY_CLOJA  = '" +TRBMATT->NXC_CLOJA+ "'"
							cQryExpens += "             	and NVY.NVY_CCASO  = '" +TRBMATT->NXC_CCASO+ "'"
							cQryExpens += "                 and NVY.D_E_L_E_T_ = ' ' )"
							cQryExpens += "         left JOIN " + RetSqlname("NUR") + " NURNVY "
							cQryExpens += "             ON( NURNVY.NUR_FILIAL     = '" + xFilial("NUR") + "'"
							cQryExpens += "                 and NURNVY.NUR_CPART  = NVY.NVY_CPART"
							cQryExpens += "                 and NURNVY.D_E_L_E_T_ = ' ')"
							cQryExpens += "         left JOIN " + RetSqlname("NR2") + " NR2NVY "
							cQryExpens += "             ON( NR2NVY.NR2_FILIAL     = '" + xFilial("NR2") + "'"
							cQryExpens += "                 and NR2NVY.NR2_CATPAR = NURNVY.NUR_CCAT"
							cQryExpens += "                 and NR2NVY.NR2_CIDIOM = '" + TRBPRIN->NXA_CIDIO + "' "
							cQryExpens += "                 and NR2NVY.D_E_L_E_T_ = ' ')"
							cQryExpens += "         INNER JOIN " + RetSqlName("NUH") + " NUH "
							cQryExpens += "             ON( NUH.NUH_FILIAL = '" + xFilial("NUH") + "'"
							cQryExpens += "                 and NUH.NUH_COD =  '" +cClientePg+ "'"+ CRLF
							cQryExpens += "                 and NUH.NUH_LOJA = '" +cLojaPg+ "'"+ CRLF
							cQryExpens += "                 and NUH.D_E_L_E_T_ = ' ' )"
							cQryExpens += "         INNER JOIN " + RetSqlName("NRX") + " NRX "
							cQryExpens += "             ON( NRX.NRX_FILIAL     = '" + xFilial("NRX") + "'"
							cQryExpens += "                 and NRX.NRX_COD    = NUH.NUH_CEMP"
							cQryExpens += "                 and NRX.D_E_L_E_T_ = ' ' )"
							cQryExpens += "          left JOIN " + RetSqlName("NS4") + " NS4 "
							cQryExpens += "             ON( NS4.NS4_FILIAL     = '" + xFilial("NS4") + "'"
							cQryExpens += "                 and NS4.NS4_CDOC   = NRX.NRX_CDOC "
							cQryExpens += "                 and NS4.NS4_CDESPJ = NVY.NVY_CTPDSP"
							cQryExpens += "                 and NS4.D_E_L_E_T_ = ' ' ) "
							cQryExpens += "          left JOIN " + RetSqlName("NS3") + " NS3 "
							cQryExpens += "             ON( NS3.NS3_FILIAL     = '" + xFilial("NS3") + "'"
							cQryExpens += "                 and NS3.NS3_CDOC   = NS4.NS4_CDOC"
							cQryExpens += "                 and NS3.NS3_COD    = NS4.NS4_CDESP "
							cQryExpens += "                 and NS3.D_E_L_E_T_ = ' ' ) "
							cQryExpens += "      where"
							cQryExpens += "         NXA.NXA_FILIAL     = '" + xFilial("NXA") + "' "
							cQryExpens += "         and NXA.NXA_CESCR  = '" + TRBPRIN->NXA_CESCR + "' "
							cQryExpens += "         and NXA.NXA_COD    = '" + TRBPRIN->NXA_COD   + "' "
							cQryExpens += "         and NXA.D_E_L_E_T_ = ' ' "
							cQryExpens += " "
							cQryExpens += "      uniON all"
							cQryExpens += " "
							cQryExpens += "      SELECT"
							cQryExpens += "         NV4.NV4_DTLANC as charge_date,"
							cQryExpens += "         NV4.NV4_CPART  as tk_id,"
							cQryExpens += "         NR2NV4.NR2_DESC as tk_level,"
							cQryExpens += "         NXN.NXN_CSRVTB as task_code,"
							cQryExpens += "         NV4.NV4_CCLIEN||NV4.NV4_CLOJA as cl_code_1,"
							cQryExpens += "         NV4.NV4_CCLIEN||NV4.NV4_CLOJA as cl_code_2,"
							cQryExpens += "         NV4.NV4_QUANT as units,"
							cQryExpens += "         NV4.NV4_VLHFAT as total_amount, "
							cQryExpens += "     	NV4.NV4_COD as Exp_Codigo, "
							cQryExpens += "     	NV4.NV4_CCLIEN as Exp_Cliente, "
							cQryExpens += "     	NV4.NV4_CLOJA as Exp_Loja, "
							cQryExpens += "     	NV4.NV4_CCASO as Exp_Caso, "
							cQryExpens += "     	NUH.NUH_CEMP as Exp_Empresa, "
							cQryExpens += "         NXO.NXO_CSRVTJ as Exp_Tipo, "
							cQryExpens += "         'TB' as Exp_Lanc, "
							cQryExpens += "         '2' as Ident, "
							cQryExpens += "         NV4.R_E_C_N_O_ as XXXRECNO, "
							cQryExpens += "         NV4.NV4_CMOEH as Exp_Moeda "
							cQryExpens += "      FROM"
							cQryExpens += "         " + RetSqlName("NXA") + " NXA "
							cQryExpens += "         INNER JOIN " + RetSqlName("NW4") + " NW4 "
							cQryExpens += "             ON( NW4.NW4_FILIAL     = '" + xFilial("NW4") + "'"
							cQryExpens += "                 and NW4.NW4_CESCR  = NXA.NXA_CESCR"
							cQryExpens += "                 and NW4.NW4_CFATUR = NXA.NXA_COD  "
							cQryExpens += "                 and NW4.D_E_L_E_T_ = ' ' ) "
							cQryExpens += "         INNER JOIN " + RetSqlName("NV4") + " NV4 "
							cQryExpens += "             ON( NV4.NV4_FILIAL     = '" + xFilial("NV4") + "'"
							cQryExpens += "                 and NV4.NV4_COD    = NW4.NW4_CLTAB"
							cQryExpens += "             	and NV4.NV4_CCLIEN = '" +TRBMATT->NXC_CCLIEN+ "'"
							cQryExpens += "             	and NV4.NV4_CLOJA  = '" +TRBMATT->NXC_CLOJA+ "'"
							cQryExpens += "             	and NV4.NV4_CCASO  = '" +TRBMATT->NXC_CCASO+ "'"
							cQryExpens += "                 and NV4.D_E_L_E_T_ = ' ' )"
							cQryExpens += "         INNER JOIN " + RetSqlname("NUR") + " NURNV4 "
							cQryExpens += "             ON( NURNV4.NUR_FILIAL     = '" + xFilial("NUR") + "'"
							cQryExpens += "                 and NURNV4.NUR_CPART  = NV4.NV4_CPART"
							cQryExpens += "                 and NURNV4.D_E_L_E_T_ = ' ')"
							cQryExpens += "         INNER JOIN " + RetSqlname("NR2") + " NR2NV4 "
							cQryExpens += "             ON( NR2NV4.NR2_FILIAL     = '" + xFilial("NR2") + "'"
							cQryExpens += "                 and NR2NV4.NR2_CATPAR = NURNV4.NUR_CCAT"
							cQryExpens += "                 and NR2NV4.NR2_CIDIOM = '" + TRBPRIN->NXA_CIDIO + "' "
							cQryExpens += "                 and NR2NV4.D_E_L_E_T_ = ' ')"
							cQryExpens += "         INNER JOIN " + RetSqlName("NUH") + " NUH "
							cQryExpens += "             ON( NUH.NUH_FILIAL = '" + xFilial("NUH") + "'"
							cQryExpens += "                 and NUH.NUH_COD =  '" +cClientePg+ "'"+ CRLF
							cQryExpens += "                 and NUH.NUH_LOJA = '" +cLojaPg+ "'"+ CRLF
							cQryExpens += "                 and NUH.D_E_L_E_T_ = ' ' )"
							cQryExpens += "         INNER JOIN " + RetSqlName("NRX") + " NRX "
							cQryExpens += "             ON( NRX.NRX_FILIAL     = '" + xFilial("NRX") + "'"
							cQryExpens += "                 and NRX.NRX_COD    = NUH.NUH_CEMP"
							cQryExpens += "                 and NRX.D_E_L_E_T_ = ' ' )"
							cQryExpens += "         left JOIN " + RetSqlName("NXO") + " NXO "
							cQryExpens += "             ON( NXO.NXO_FILIAL     = '" + xFilial("NXO") + "'"
							cQryExpens += "                 and NXO.NXO_CDOC   = NRX.NRX_CDOC "
							cQryExpens += "                 and NXO.NXO_CSRVTJ = NV4.NV4_CTPSRV"
							cQryExpens += "                 and NXO.D_E_L_E_T_ = ' ' ) "
							cQryExpens += "         left JOIN " + RetSqlName("NXN") + " NXN "
							cQryExpens += "             ON( NXN.NXN_FILIAL     = '" + xFilial("NXN") + "'"
							cQryExpens += "                 and NXN.NXN_CDOC   = NRX.NRX_CDOC"
							cQryExpens += "                 and NXN.NXN_COD    = NXO.NXO_CSRVTB"
							cQryExpens += "                 and NXN.D_E_L_E_T_ = ' ' ) "
							cQryExpens += "      where"
							cQryExpens += "         NXA.NXA_FILIAL     = '" + xFilial("NXA") + "' "
							cQryExpens += "         and NXA.NXA_CESCR  = '" + TRBPRIN->NXA_CESCR + "' "
							cQryExpens += "         and NXA.NXA_COD    = '" + TRBPRIN->NXA_COD   + "' "
							cQryExpens += "         and NXA.D_E_L_E_T_ = ' '"
							cQryExpens += "     )expenses"
							cQryExpens += " order by "
							cQryExpens += "     expenses.Ident ,expenses.charge_date, expenses.Exp_Codigo"
							
							If Select("TRBEXP")>0
								DbSelectArea("TRBEXP")
								TRBEXP->(DbCloseArea())
							EndIf
							
							cTRBExpens := ChangeQuery(cQryExpens)
							dbUseArea(.T., 'TOPCONN', TcGenQry( ,, cTRBExpens ) ,"TRBEXP", .T., .F.)
							
							DbSelectArea("TRBEXP")
							TRBEXP->(dbGoTop())
							If TRBEXP->(!Eof())
								Do While TRBEXP->(!Eof()) .And. aRet[1]
									//=========================================
									//@EXP Segment - Informações sobre as despesas (Despesas e Tabelados) incluídos na fatura
									//=========================================
									nItemNbr ++
									Aadd(aArqXml,Space(15)+"<expense>")
									
									If !Empty(TRBEXP->charge_date)
										Aadd(aArqXml,Space(18)+"<charge_date>" + JSToFormat(Alltrim(TRBEXP->charge_date), "YYYY-MM-DD") + "</charge_date>")
									EndIf
									
									If !Empty(TRBEXP->tk_id)
										Aadd(aArqXml,Space(18)+"<tk_id>"+Alltrim(TRBEXP->tk_id)+"</tk_id>")
									EndIf
									
									If !Empty(TRBEXP->tk_level)
										Aadd(aArqXml,Space(18)+"<tk_level>" + Alltrim(TRBEXP->tk_level) + " </tk_level>")
									EndIf
									
									If !Empty(Alltrim(TRBEXP->Ident))
										
										If Alltrim(TRBEXP->Ident) == '1'
											
											NVY->( dbGoTo(TRBEXP->XXXRECNO ))
											cDescri := StrTran(NVY->NVY_DESCRI, CRLF, " ")
											
										ElseIf Alltrim(TRBEXP->Ident) == '2'
											
											NV4->( dbGoTo(TRBEXP->XXXRECNO ))
											cDescri := StrTran(NV4->NV4_DESCRI, CRLF, " ")
											
										EndIf
										
										If !Empty(cDescri)
											Aadd(aArqXml,Space(18)+"<charge_desc>"+Alltrim(cDescri)+"</charge_desc>")
										EndIf
										
									EndIf
									
									nExpTotAmount := (TRBEXP->total_amount) * nPercFat
									aValor := JA201FConv( cMoeEbi, TRBEXP->Exp_Moeda, nExpTotAmount, '8', dEmiFat, , , , cCodEsc, cFatura )
									If !Empty(aValor[4])
										IIF(lAutomato, aRet := {.F., aValor[4]}, Alert(aValor[4]))
										aRet[1] := .F.
										Exit
									Else
										nExpTotAmount := Round(aValor[1],2)
									EndIf
									
									nExpRate      := Round((nExpTotAmount / TRBEXP->units),2)
									
									cExpTotAmount := Alltrim(Str(nExpTotAmount))
									cExpRate := Alltrim(Str(nExpRate))
									
									Aadd(aArqXml,Space(18)+"<charge_type>U</charge_type>")
									Aadd(aArqXml,Space(18)+"<units>"+Alltrim(Str(TRBEXP->units))+"</units>")
									Aadd(aArqXml,Space(18)+"<rate>"+Alltrim(cExpRate)+"</rate>")
									Aadd(aArqXml,Space(18)+"<base_amount>" + Alltrim(cExpTotAmount) + "</base_amount>")
									Aadd(aArqXml,Space(18)+"<total_amount>" + Alltrim(cExpTotAmount) + "</total_amount>")
									Aadd(aArqXml,Space(18)+"<item_disc_cred_amount>0</item_disc_cred_amount>")
									Aadd(aArqXml,Space(18)+"<file_item_nbr>" + Alltrim(Str(nItemNbr)) + "</file_item_nbr>")
									Aadd(aArqXml,Space(15)+"</expense>")
									
									aLog := LD98VlLanc(TRBEXP->Exp_Codigo, TRBEXP->Exp_Cliente, TRBEXP->Exp_Loja, TRBEXP->Exp_Caso, TRBEXP->Exp_Empresa ,;
										"NValdCat", "NValdCat", "NValdCat", "NtemFase", "NtemTarefa", TRBEXP->Exp_Tipo, TRBEXP->Exp_Lanc, aLog, "cEscEbi", "cEscrit" )
									
									lTemDP := .T.
									
									TRBEXP->(DbSkip())
								EndDo
							Else
								lTemDP := lTemDP .Or. .F.
							EndIf
							
							Aadd(aArqXml,Space(12) + "</matter>")
							
							TRBMATT->(DbSkip())
						EndDo
					EndIf
					Aadd(aArqXml, Space(9)+"</invoice>")
					Aadd(aArqXml, Space(6)+"</client>")
					TRBPRIN->(DbSkip())
				EndDo
			EndDo
		EndDo
		
		If aRet[1]
			Aadd(aArqXml,Space(3)+"</firm>")
			Aadd(aArqXml,"</ledesxmlebilling2.2>")
			
			cFatura := "'" + cCodEsc + cFatura+"'"
			
			If (lTemDP .OR. lTemTS)
				aRet := GeraArq(cNArq, cDArq, aArqXml, alog, cFatura, lAutomato)
			Else
				IIF(lAutomato, aRet := {.F., "Não foram encontrados dados para geração do arquivo."}, Alert("Não foram encontrados dados para geração do arquivo."))
			EndIf
		EndIf
		
	Else
		IIF(lAutomato, aRet := {.F., "Não foram encontrados dados para geração do arquivo."}, Alert("Não foram encontrados dados para geração do arquivo."))
	EndIf

	If aRet[1] .And. FindFunction("JLDFlagFat")
		JLDFlagFat(NXA->(Recno()))
	EndIf

	RestArea(aArea)

Return (aRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} GerarArq
Montagem e geração do arquivo XML.

@author SISJURI
@since 10/05/2010
/*/
//-------------------------------------------------------------------
Static Function GeraArq(cNomArq, cCaminho, aArquivo, aLog, cFatura, lAutomato)
Local nX         := 0
Local nY         := 0
Local cDirDocs   := "\ARQUIVOXML\"
Local lWebApp    := GetRemoteType() == 5
Local cPath      := IIf(lWebApp, "/spool/", GetSrvProfString("RootPath", "") + cDirDocs)
Local cArquivo   := cEmpAnt + cFilAnt + __cUserId
Local cMemolog   := ""
Local aRet       := {.T., ""}

Default aArquivo := {}
Default cCaminho := ""
Default cNomArq  := ""

Makedir(cPath)

If Empty(cNomArq)
	cArquivo := Alltrim(cArquivo) + ".xml"
ElseIf At(".XML", Upper(cNomArq)) == 0
	cArquivo := Alltrim(cNomArq) + ".xml"
Else	
	cArquivo := Alltrim(cNomArq)
EndIf
If !Empty(cCaminho)
	cPath := Alltrim(cCaminho)
	If !ExistDir(cPath)
		If !lAutomato
			Help( ,, 'HELP',, "Caminho informado nao existe", 1, 0)
		Else
			aRet := {.F., "Caminho informado nao existe"}
		EndIf
		Return aRet
	EndIf
EndIf

If File(cPath + cArquivo)
	If !lAutomato .And. !MsgYesNo("Já existe um arquivo com este nome. Deseja sobrepor?", "SeleciONe o Diretorio p/ gerar o Arquivo")
		Return 
	Else
		FErase(cPath + cArquivo)
	EndIf
EndIf

nHandle := FCreate(cPath+cArquivo)
If nHandle == -1
	If !lAutomato
		MsgStop("Arquivo Txt não pode ser gerado.")
	Else
		aRet := {.F., "Arquivo Txt não pode ser gerado."}
	EndIf
	Return aRet
EndIf  

For nX := 1 To Len(aArquivo)
	FWrite(nHandle, EncodeUTF8(StrTran(aArquivo[nX], '&', '&#38;')) + Chr(13) + Chr(10))
Next

FClose(nHandle)

If (!lAutomato .Or. !IsBlind()) .And. !lWebApp // Não deve executar o comando CpyS2T quando for via automação
	CpyS2T(SubStr(cPath, AT(":\", cPath) + 2, Len(cPath) - AT(":\",cPath)) + Alltrim(cArquivo), cPath, .T.) // copia o arquivo do servidor para o remote
ElseIf (!lAutomato .Or. !IsBlind()) .And. lWebApp
	CpyS2TW(cPath + cArquivo)
EndIf

For nX := 1 To Len(aLog)
	For nY := 1 To Len(aLog[nX])
		cMemolog += aLog[nX][nY][2]
	Next nY
Next nX

If !Empty(cMemolog)
	cMemolog := "O Arquivo " + AllTrim(cCaminho) + Alltrim(cArquivo) + " da fatura " + cFatura + " foi gerado com as seguintes incONsistências: " + cMemolog
	If !lAutomato
		JurErrLog(cMemolog, "Geração de Arquivo XML LEDES2.0")
	Else
		aRet := {.T., cMemolog}
	EndIf
Else
	If !lAutomato
		MsgInfo("Arquivo Xml processado com sucesso.", "Arquivo Gerado")
	Else
		aRet := {.T., "Arquivo Gerado" + " - " + "Arquivo Xml processado com sucesso."}
	EndIf
EndIf

Return aRet

//-------------------------------------------------------------------
/*/{Protheus.doc} RetSXB
Retorna qual SXB a ser usado

@Return cRet		Codigo da CONsulta Padrão

@author fabiana.silva
@since 06/04/2020
/*/
//-------------------------------------------------------------------
Static Function RetSXB()
Local cRet     := "NXA1"
Local aAreaSXB := SXB->(GetArea())
Local nTamSXB  := Len(SXB->XB_ALIAS)

SXB->(DbSetOrder(1)) //XB_ALIAS

If 	SXB->(DbSeek(PadR("NXA2", nTamSXB)))
	cRet := "NXA2"
EndIf

RestArea(aAreaSXB)

Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} RetFLName
Retorna o First ou o LastName
@param nOption  -   1 Last Name
					2 First Name

@Return cRet	 First ou LastName

@author fabiana.silva
@since 02/10/2020
/*/
//-------------------------------------------------------------------
Static Function RetFLName(nOption, cNome)
Local nTamRD0LNm := 30 
Local nTamRD0FNm := 20
Local nPos := 0

cNome := AllTrim(cNome)

If nOption == 1
	If (nPos := Rat(" ", cNome) ) > 0
		cNome := Left( AllTrim( Right(cNome,  Len(cNome) - nPos ) ), nTamRD0LNm)
	Else
		cNome := ""
	EndIf
ElseIf nOption == 2
	If (nPos := At(" ", cNome)-1) > 0
		cNome := Left( AllTrim( Left(cNome,nPos) ), nTamRD0FNm)
	EndIf
EndIf

Return cNome