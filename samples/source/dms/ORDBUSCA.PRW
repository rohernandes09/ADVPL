// ÉÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍ»
// º Versao º 20     º
// ÈÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍ¼

#INCLUDE "PROTHEUS.CH"
#INCLUDE "ORDBUSCA.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ORDBUSCA  ºAutor  ³Fabio                º Data ³  07/16/01   º±±
±±ºPrograma  ³ORDBUSCA º Autor ³ Alecsandre Ferreira  º Data ³  13/09/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime ordem de busca                                       º±±
±±ºDesc.     ³10/09/21 - Alteração do Report para utilizar a classe TReportº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ORDBUSCA()
	Local oReport
	Private aVO2NOSNUM := ParamIxb[01]  // aVO2NOSNUM - Todos os VO2_NOSNUM da Requisicao feita
	Private aVetCampos := {}
	Private cTitulo    := STR0006+" - " + DtoS(Date()) // Ordem de Busca - 
	Private cDesc2     := ""
	Private cNomeRel   := "ORDBUSCA_" + Dtos(Date())
	Private nCntDoS2   := 0

    oReport := RptDefOA()
    oReport:nFontBody := 10
    oReport:oPage:nPaperSize := 9
    oReport:PrintDialog()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RptDef OAºAutor  ³Alecsandre Ferreira  º Data ³  14/09/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Define as Sections de Impressão da classe TReport.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Oficina                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RptDefOA()
	Local oReport
    Local oSection1 
    Local oSection2
	Local oSection3

	If !Empty(aVO2NOSNUM)
		If Len(aVO2NOSNUM) > 1
			cTitulo:= STR0001+" "+ VO1->VO1_NUMOSV // OS: 
		Else
			DbSelectArea("VO2")
			DbSetOrder(2)
			DbSeek(xFilial("VO2")+aVO2NOSNUM[1])
			dbSelectArea("VAI")
			dbSetOrder(1)
			dbSeek(xFilial("VAI")+VO2->VO2_FUNREQ)

			cTitulo:= STR0001+VO1->VO1_NUMOSV+" "+STR0020+VO2->VO2_NOSNUM+" "+STR0021+left(VAI->VAI_NOMTEC,10) // OS: | Rq: | At: 
		Endif
	Endif

    oReport := TReport():New(;
        cNomeRel,;
        cTitulo,;
        ,;
        {|oReport| RunRptOA(oReport)},;
        cDesc2;
    )

    oReport:SetLineHeight(45)
    oSection1 := TRSection():New(oReport)
    oSection1:SetHeaderPage()
	
	TRCell():New(oSection1,"A1_NOME"    , "SA1", STR0008,, 40) // Cliente
	TRCell():New(oSection1,"VV1_CHASSI" , "VV1", STR0009,, 25) // Chassi
	TRCell():New(oSection1,"VV1_CODFRO" , "VV1", STR0010,, 12) // Frota
	TRCell():New(oSection1,"VV1_PLAVEI" , "VV1", STR0011,, 12) // Placa
	oSection1:SetLinesBefore(1)

	oSection2 := TRSection():New(oReport)
	TRCell():New(oSection2, "SEQUEN"    , ""   , STR0012,, 12) // Sequência 
	TRCell():New(oSection2, "VOI_TIPTEM", "VOI", STR0013,, 12) // Tipo Tempo
	TRCell():New(oSection2, "B1_GRUPO"  , "SB1", STR0014,, 12) // Grupo
	TRCell():New(oSection2, "B1_CODITE" , "SB1", STR0015,, 65) // Código do Item
	TRCell():New(oSection2, "B1_DESC"   , "SB1", STR0016,, 30) // Descrição
	TRCell():New(oSection2, "B1_LOCALIZ", "SB1", STR0017,, 25) // Locação
	TRCell():New(oSection2, "VO3_QTDREQ", "VO3", STR0018,, 20) // Qtde. Requis.
	TRCell():New(oSection2, "VAI_CODTEC", "VAI", STR0019,, 16) // Mecân.
	TRCell():New(oSection2, "TIPOMOV"   , ""   , STR0007,, 12) // Tp. Movim. 
	oSection2:SetLinesBefore(2)

	oSection3 := TRSection():New(oReport)
    TRCell():New(oSection3,"COL1",    '', '', , 10)
    TrCell():New(oSection3,"COLRESP", '', '', , 40)
    TrCell():New(oSection3,"COL3",    '', '', , 20)
    TrCell():New(oSection3,"COLPREST",'', '', , 40)
    TrCell():New(oSection3,"COL5",    '', '', , 10)
	oSection3:SetLinesBefore(5)
    oSection3:SetHeaderSection(.F.)
Return oReport


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunRptOA ºAutor  ³Alecsandre Ferreira  º Data ³  14/09/21   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime relatorio de ordem de busca para pecas requisitadas.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Oficina                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunRptOA(oReport)
	Local i        := 0
	Local cQuery   := ""
	Local cQAlias  := "SQLSDB"
	Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	Local cMascPla  := VV1->(x3Picture("VV1_PLAVEI"))

	SetPrvt("nLin , i , nTotal ")
	SetPrvt("cbTxt , cbCont , cString , Li , m_Pag , wnRel , cTitulo , cabec1 , cabec2 , nomeprog , ctamanho , nCaracter ")

	DbSelectArea("VO1")

	// Cria Arquivo de Trabalho - LISTAGEM
	aadd(aVetCampos,{"TRB_TIPTEM", "C", 04, 0})  // TIPO DE TEMPO
	aadd(aVetCampos,{"TRB_GRUPO",  "C", 04, 0})  // GRUPO
	aadd(aVetCampos,{"TRB_CODITE", "C", 48, 0})  // CODIGO
	aadd(aVetCampos,{"TRB_DESCRI", "C", 40, 0})  // DESCRICAO
	aadd(aVetCampos,{"TRB_LOCPAD", "C", 02, 0})  // LOCACAO
	aadd(aVetCampos,{"TRB_LOCALI", "C", 15, 0})  // LOCALIZACAO
	aadd(aVetCampos,{"TRB_QTDREQ", "N", 08, 2})  // REQUISITADA
	aadd(aVetCampos,{"TRB_VALPEC", "N", 12, 2})  // VALOR DE PECA
	aadd(aVetCampos,{"TRB_VALTOT", "N", 12, 2})  // VALOR TOTAL
	aadd(aVetCampos,{"TRB_PROREQ", "C", 06, 0})  // REQUISITANTE
	aadd(aVetCampos,{"TRB_QTDDIS", "N", 14, 2})  // QTD. DISPONIVEL
	aadd(aVetCampos,{"TRB_CHAINT", "C", 06, 0})  // CHASSI INTERNO

	oObjTempTable := OFDMSTempTable():New()
	oObjTempTable:cAlias := "TRB"
	oObjTempTable:aVetCampos := aVetCampos
	oObjTempTable:AddIndex(, {"TRB_LOCALI","TRB_CODITE"} )
	oObjTempTable:CreateTable()

	nCaracter := 0
	nLin := 1
	nTotal := 0

	if Funname() <> "OFIOR700"
		cPlaca  := ""
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek( xFilial("SA1") + VO1->VO1_PROVEI+VO1->VO1_LOJPRO )
		DbSelectArea("VV1")
		DbSetOrder(2)
		If DbSeek( xFilial("VV1") + VO1->VO1_CHASSI )
			cPlaca := Transform(VV1->VV1_PLAVEI,cMascPla)
		EndIf
	
		For i:=1 to Len(aVO2NOSNUM)
			DbSelectArea("VO2")
			DbSetOrder(2)
			DbSeek(xFilial("VO2")+aVO2NOSNUM[i])

			DbSelectArea("VO3")
			DbSetOrder(1)
			DbSeek( xFilial("VO3") + VO2->VO2_NOSNUM)
		
			Do While !Eof() .and. VO3->VO3_FILIAL == xFilial("VO3") .and. VO3->VO3_NOSNUM == VO2->VO2_NOSNUM
				DbSelectArea("SB1")
				DbSetOrder(7)
				DbSeek( xFilial("SB1") + VO3->VO3_GRUITE + VO3->VO3_CODITE )
			
				DbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek( xFilial("SB2") + SB1->B1_COD + FM_PRODSBZ(SB1->B1_COD,"SB1->B1_LOCPAD") )

				If Localiza(SB1->B1_COD)
					If cReqDev=="1" // Requisicao
						cQuery := "SELECT SDB.DB_LOCAL, SDB.DB_LOCALIZ, SDB.DB_QUANT FROM "+RetSqlName("SDB")+" SDB WHERE SDB.DB_FILIAL = '"+xFilial("SDB")+"' AND "
						cQuery += "SDB.DB_PRODUTO = '"+SB1->B1_COD+"' AND SDB.DB_DOC = '"+VO3->VO3_NUMDOC+"' AND SDB.DB_QUANT > 0 AND SDB.DB_TM > '500' AND "
						cQuery += "SDB.D_E_L_E_T_ = ' ' ORDER BY SDB.R_E_C_N_O_"
					Else
						cQuery := "SELECT SDB.DB_LOCAL, SDB.DB_LOCALIZ, SDB.DB_QUANT FROM "+RetSqlName("SDB")+" SDB WHERE SDB.DB_FILIAL = '"+xFilial("SDB")+"' AND "
						cQuery += "SDB.DB_PRODUTO = '"+SB1->B1_COD+"' AND SDB.DB_DOC = '"+VO3->VO3_NUMDOC+"' AND SDB.DB_QUANT > 0 AND SDB.DB_TM < '500' AND "
						cQuery += "SDB.D_E_L_E_T_ = ' ' ORDER BY SDB.R_E_C_N_O_"
					Endif
					dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cQAlias, .F., .T. )
			
					If !( cQAlias )->( Eof() )		
						Do While !( cQAlias )->( Eof() )
							RecLock("TRB",.t.)
								TRB->TRB_TIPTEM := VO3->VO3_TIPTEM
								TRB->TRB_GRUPO  := VO3->VO3_GRUITE
								TRB->TRB_CODITE := VO3->VO3_CODITE
								TRB->TRB_DESCRI := Substr(SB1->B1_DESC,1,15)
								TRB->TRB_LOCPAD := ( cQAlias )->( DB_LOCAL )
								TRB->TRB_LOCALI := ( cQAlias )->( DB_LOCALIZ )
								TRB->TRB_QTDREQ := ( cQAlias )->( DB_QUANT )
								TRB->TRB_VALPEC := VO3->VO3_VALPEC
								TRB->TRB_VALTOT := ( ( cQAlias )->( DB_QUANT ) * VO3->VO3_VALPEC )
								TRB->TRB_PROREQ := VO3->VO3_PROREQ
								TRB->TRB_QTDDIS := SB2->B2_QATU
								TRB->TRB_CHAINT := VO1->VO1_CHAINT
							MsunLock()
							nTotal := nTotal + ( ( cQAlias )->( DB_QUANT ) * VO3->VO3_VALPEC )
							( cQAlias )->( DbSkip() )						
						Enddo
					Else
						DbSelectArea("SB5")
						DbSetOrder(1)
						DbSeek( xFilial("SB5") + SB1->B1_COD )
					
						RecLock("TRB",.t.)
							TRB->TRB_TIPTEM := VO3->VO3_TIPTEM
							TRB->TRB_GRUPO  := VO3->VO3_GRUITE
							TRB->TRB_CODITE := VO3->VO3_CODITE
							TRB->TRB_DESCRI := Substr(SB1->B1_DESC,1,15)
							TRB->TRB_LOCPAD := FM_PRODSBZ(SB1->B1_COD,"SB1->B1_LOCPAD")

							If FunName() == "#M_AREQPEC"
								TRB->TRB_LOCALI := SB5->B5_LOC2
							Else
								TRB->TRB_LOCALI := FM_PRODSBZ(SB1->B1_COD,"SB5->B5_LOCALI2")
							Endif

							TRB->TRB_QTDREQ := VO3->VO3_QTDREQ
							TRB->TRB_VALPEC := VO3->VO3_VALPEC
							TRB->TRB_VALTOT := ( VO3->VO3_QTDREQ * VO3->VO3_VALPEC )
							TRB->TRB_PROREQ := VO3->VO3_PROREQ
							TRB->TRB_QTDDIS := SB2->B2_QATU
							TRB->TRB_CHAINT := VO1->VO1_CHAINT
						MsunLock()
						nTotal := nTotal + ( VO3->VO3_QTDREQ * VO3->VO3_VALPEC )
					Endif
					( cQAlias )->( DbCloseArea() )
				Else
					DbSelectArea("SB5")
					DbSetOrder(1)
					DbSeek( xFilial("SB5") + SB1->B1_COD )

					RecLock("TRB",.t.)
						TRB->TRB_TIPTEM := VO3->VO3_TIPTEM
						TRB->TRB_GRUPO  := VO3->VO3_GRUITE
						TRB->TRB_CODITE := VO3->VO3_CODITE
						TRB->TRB_DESCRI := Substr(SB1->B1_DESC,1,15)
						TRB->TRB_LOCPAD := FM_PRODSBZ(SB1->B1_COD,"SB1->B1_LOCPAD")

						If FunName() == "#M_AREQPEC"
							TRB->TRB_LOCALI := SB5->B5_LOC2
						Else
							TRB->TRB_LOCALI := FM_PRODSBZ(SB1->B1_COD,"SB5->B5_LOCALI2")
						Endif

						TRB->TRB_QTDREQ := VO3->VO3_QTDREQ
						TRB->TRB_VALPEC := VO3->VO3_VALPEC
						TRB->TRB_VALTOT := ( VO3->VO3_QTDREQ * VO3->VO3_VALPEC )
						TRB->TRB_PROREQ := VO3->VO3_PROREQ
						TRB->TRB_QTDDIS := SB2->B2_QATU
						TRB->TRB_CHAINT := VO1->VO1_CHAINT
					MsunLock()
					nTotal := nTotal + ( VO3->VO3_QTDREQ * VO3->VO3_VALPEC )
				Endif
				dbSelectArea("VO3")
				dbSkip()
			EndDo
		Next
	Else
		cPlaca  := ""
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek( xFilial("SA1") + VO1->VO1_PROVEI+VO1->VO1_LOJPRO )
		DbSelectArea("VV1")
		DbSetOrder(2)

		If DbSeek( xFilial("VV1") + VO1->VO1_CHASSI )
			cPlaca := Transform(VV1->VV1_PLAVEI,cMascPla)
		EndIf
	
		For i:=1 to Len(aVO2NOSNUM)
			DbSelectArea("VO2")
			DbSetOrder(2)
			DbSeek(xFilial("VO2")+aVO2NOSNUM[i])

			dbSelectArea("VO3")
			dbSetOrder(1)
			dbSeek(xFilial("VO3")+VO2->VO2_NOSNUM)
			While !Eof() .and. xFilial("VO3") == VO3->VO3_FILIAL .and. VO2->VO2_NOSNUM == VO3->VO3_NOSNUM
				DbSelectArea("SB1")
				DbSetOrder(7)
				DbSeek( xFilial("SB1") + VO3->VO3_GRUITE + VO3->VO3_CODITE)
				DbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek( xFilial("SB2") + SB1->B1_COD + FM_PRODSBZ(SB1->B1_COD,"SB1->B1_LOCPAD") )

				If Localiza(SB1->B1_COD)			
					If cReqDev=="1" // Requisicao
						cQuery := "SELECT SDB.DB_LOCAL, SDB.DB_LOCALIZ, SDB.DB_QUANT FROM "+RetSqlName("SDB")+" SDB WHERE SDB.DB_FILIAL = '"+xFilial("SDB")+"' AND "
						cQuery += "SDB.DB_PRODUTO = '"+SB1->B1_COD+"' AND SDB.DB_DOC = '"+VO3->VO3_NUMDOC+"' AND SDB.DB_QUANT > 0 AND SDB.DB_TM > '500' AND "
						cQuery += "SDB.D_E_L_E_T_ = ' ' ORDER BY SDB.R_E_C_N_O_"
					Else
						cQuery := "SELECT SDB.DB_LOCAL, SDB.DB_LOCALIZ, SDB.DB_QUANT FROM "+RetSqlName("SDB")+" SDB WHERE SDB.DB_FILIAL = '"+xFilial("SDB")+"' AND "
						cQuery += "SDB.DB_PRODUTO = '"+SB1->B1_COD+"' AND SDB.DB_DOC = '"+VO3->VO3_NUMDOC+"' AND SDB.DB_QUANT > 0 AND SDB.DB_TM < '500' AND "
						cQuery += "SDB.D_E_L_E_T_ = ' ' ORDER BY SDB.R_E_C_N_O_"
					Endif
					dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cQAlias, .F., .T. )
				
					If !( cQAlias )->( Eof() )
						Do While !( cQAlias )->( Eof() )
							RecLock("TRB",.t.)
								TRB->TRB_TIPTEM := VO3->VO3_TIPTEM
								TRB->TRB_GRUPO  := VO3->VO3_GRUITE
								TRB->TRB_CODITE := VO3->VO3_CODITE
								TRB->TRB_DESCRI := Substr(SB1->B1_DESC,1,15)
								TRB->TRB_LOCPAD := ( cQAlias )->( DB_LOCAL )
								TRB->TRB_LOCALI := ( cQAlias )->( DB_LOCALIZ )
								TRB->TRB_QTDREQ := ( cQAlias )->( DB_QUANT )
								TRB->TRB_VALPEC := VO3->VO3_VALPEC
								TRB->TRB_VALTOT := ( cQAlias )->( DB_QUANT )*VO3->VO3_VALPEC
								TRB->TRB_PROREQ := VO3->VO3_PROREQ
								TRB->TRB_QTDDIS := SB2->B2_QATU
								TRB->TRB_CHAINT := VO1->VO1_CHAINT
							MsunLock()
							nTotal := nTotal + (( cQAlias )->( DB_QUANT )*VO3->VO3_VALPEC)
							( cQAlias )->( DbSkip() )
						Enddo
					Else
						DbSelectArea("SB5")
						DbSetOrder(1)
						DbSeek( xFilial("SB5") + SB1->B1_COD )
					
						RecLock("TRB",.t.)
							TRB->TRB_TIPTEM := VO3->VO3_TIPTEM
							TRB->TRB_GRUPO  := VO3->VO3_GRUITE
							TRB->TRB_CODITE := VO3->VO3_CODITE
							TRB->TRB_DESCRI := Substr(SB1->B1_DESC,1,15)
							TRB->TRB_LOCPAD := FM_PRODSBZ(SB1->B1_COD,"SB1->B1_LOCPAD")
							TRB->TRB_LOCALI := FM_PRODSBZ(SB1->B1_COD,"SB5->B5_LOCALI2")
							TRB->TRB_QTDREQ := VO3->VO3_QTDREQ
							TRB->TRB_VALPEC := VO3->VO3_VALPEC
							TRB->TRB_VALTOT := VO3->VO3_QTDREQ*VO3->VO3_VALPEC
							TRB->TRB_PROREQ := VO3->VO3_PROREQ
							TRB->TRB_QTDDIS := SB2->B2_QATU
							TRB->TRB_CHAINT := VO1->VO1_CHAINT
						MsunLock()
						nTotal := nTotal + (VO3->VO3_QTDREQ*VO3->VO3_VALPEC)
					Endif
					( cQAlias )->( DbCloseArea() )
				Else
					DbSelectArea("SB5")
					DbSetOrder(1)
					DbSeek( xFilial("SB5") + SB1->B1_COD )
					
					RecLock("TRB",.t.)
						TRB->TRB_TIPTEM := VO3->VO3_TIPTEM
						TRB->TRB_GRUPO  := VO3->VO3_GRUITE
						TRB->TRB_CODITE := VO3->VO3_CODITE
						TRB->TRB_DESCRI := Substr( SB1->B1_DESC,1,15) //55
						TRB->TRB_LOCPAD := FM_PRODSBZ(SB1->B1_COD,"SB1->B1_LOCPAD")
						TRB->TRB_LOCALI := FM_PRODSBZ(SB1->B1_COD,"SB5->B5_LOCALI2")
						TRB->TRB_QTDREQ := VO3->VO3_QTDREQ
						TRB->TRB_VALPEC := VO3->VO3_VALPEC
						TRB->TRB_VALTOT := VO3->VO3_QTDREQ*VO3->VO3_VALPEC
						TRB->TRB_PROREQ := VO3->VO3_PROREQ
						TRB->TRB_QTDDIS := SB2->B2_QATU
						TRB->TRB_CHAINT := VO1->VO1_CHAINT
					MsunLock()
					nTotal := nTotal + (VO3->VO3_QTDREQ*VO3->VO3_VALPEC)
				Endif
				
				dbSelectArea("VO3")
				dbSkip()
			Enddo
		Next
	Endif

	oSection1:Init()
	oSection1:Cell("A1_NOME"):SetValue(VO1->VO1_PROVEI + " - " + left(SA1->A1_NOME, 15))
	oSection1:Cell("VV1_CHASSI"):SetValue(VV1->VV1_CHASSI)
	oSection1:Cell("VV1_CODFRO"):SetValue(VV1->VV1_CODFRO)
	oSection1:Cell("VV1_PLAVEI"):SetValue(cPlaca)
	oSection1:PrintLine()
	oSection1:Finish()

	oSection2:Init()
	DBSelectArea("TRB")
	DBGoTop()
	nCntDoS2 := 1
	Do while !TRB->(EOF())
		If FS_GARANTIA(TRB->TRB_CHAINT, TRB->TRB_TIPTEM, substr(TRB->TRB_CODITE, 1, 4), substr(TRB->TRB_CODITE, 5, 27), dDataBase)
			oSection2:Cell("SEQUEN"):SetValue("*"+StrZero(nCntDoS2, 2))
		Else
			oSection2:Cell("SEQUEN"):SetValue(" "+StrZero(nCntDoS2, 2))
		Endif
		
		oSection2:Cell("VOI_TIPTEM"):SetValue(TRB->TRB_TIPTEM)
		oSection2:Cell("B1_GRUPO"):SetValue(TRB->TRB_GRUPO)
		oSection2:Cell("B1_CODITE"):SetValue(TRB->TRB_CODITE)
		oSection2:Cell("B1_DESC"):SetValue(alltrim(TRB->TRB_DESCRI))
		oSection2:Cell("B1_LOCALIZ"):SetValue(TRB->TRB_LOCALIZ)
		oSection2:Cell("VO3_QTDREQ"):SetValue(TRB->TRB_QTDREQ)
		oSection2:Cell("VAI_CODTEC"):SetValue(TRB->TRB_PROREQ)
		oSection2:Cell("TIPOMOV"):SetValue(IIF(cReqDev == "1", STR0004, STR0005)) // Requisiçao | Devolução
		oSection2:PrintLine()
		nCntDoS2 += 1
		TRB->(DbSkip())
	EndDo
	oSection2:Finish()

	oSection3:Init()
    oSection3:Cell("COL1"):SetValue(Replicate(" ", 10))
    oSection3:Cell("COLRESP"):SetValue(Replicate("_", 40))
    oSection3:Cell("COL3"):SetValue(Replicate(" ", 10))
    oSection3:Cell("COLPREST"):SetValue(Replicate("_", 40))
    oSection3:Cell("COL5"):SetValue(Replicate(" ", 10))
    oSection3:PrintLine()

    oReport:SkipLine(2)
    oSection3:Cell('COLRESP'):SetAlign('CENTER')
    oSection3:Cell('COLPREST'):SetAlign('CENTER')

    oSection3:Cell("COL1"):SetValue(Replicate(" ", 10))
    oSection3:Cell("COLRESP"):SetValue( STR0002 ) //Atendente
    oSection3:Cell("COL3"):SetValue(Replicate(" ", 10))
    oSection3:Cell("COLPREST"):SetValue(STR0003) //Mecânico
    oSection3:Cell("COL5"):SetValue(Replicate(" ", 10))
    oSection3:PrintLine()
	
    oSection3:Print()
    oSection3:Finish()
	oObjTempTable:CloseTable()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARANTIA  ºAutor  ³Fabio               º Data ³  03/29/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica garantia                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Oficina                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_GARANTIA(cChaInt, cTipTem, cGruIte, cCodIte, dDataGar, nKmGar, lTela)
	Local nVar := 0
	Local dDataPesq := Ctod("  /  /  ")
	Local nKmReq := 0
	Local aArea := {}
	Local aVetGar := {}
	Local lRetorno := .f.
	Local cVerificacao := ""
	Local bTitulo := {|cCampo| If(SX3->(DbSeek(cCampo)), X3Titulo(), "")}
	Local bConteudo := {|x,cCampo| Ascan(aVetGar[x], cCampo)}
	Local lAchou := .f.
	Default cGruIte := ""
	Default cCodIte := ""
	Default dDataGar := Ctod("  /  /  ")
	Default nKmGar := 0
	Default lTela := .t.

	// Salva posicoes do arquivo
	aArea := sGetArea(aArea,Alias())
	aArea := sGetArea(aArea,"VV1")
	aArea := sGetArea(aArea,"VO5")
	aArea := sGetArea(aArea,"VV2")
	aArea := sGetArea(aArea,"VE4")
	aArea := sGetArea(aArea,"VVL")
	aArea := sGetArea(aArea,"VEC")
	aArea := sGetArea(aArea,"SBM")
	aArea := sGetArea(aArea,"VO1")
	aArea := sGetArea(aArea,"VOI")
	aArea := sGetArea(aArea,"VSC")
	aArea := sGetArea(aArea,"VOU")
	aArea := sGetArea(aArea,"VOP")

	Aadd(aVetGar, {}) // Cabecalho do veiculo
	Aadd(aVetGar, {}) // Conteudo do veiculo
	Aadd(aVetGar, {}) // Cabecalho do list box
	Aadd(aVetGar, {}) // Conteudo do list box

	// Verifica a garantia do veiculo

	Aadd(aVetGar[2], {})

	DbSelectArea("VV1")
	DbSetOrder(1)
	DbSeek(xFilial("VV1")+cChaInt)

	For nVar := 1 to FCount()
		Aadd(aVetGar[1], FieldName(nVar))
	Next

	For nVar := 1 to FCount()
		Aadd(aVetGar[2,Len(aVetGar[2])], FieldGet(nVar))
	Next

	DbSelectArea("VO5")
	DbSetOrder(1)
	DbSeek( xFilial("VO5")+cChaInt)

	For nVar := 1 to FCount()
		Aadd(aVetGar[1], FieldName(nVar))
	Next

	For nVar := 1 to FCount()
		Aadd(aVetGar[2,Len(aVetGar[2])], FieldGet(nVar))
	Next

	DbSelectArea("VV2")
	DbSetOrder(1)
	DbSeek( xFilial("VV2") + VV1->VV1_CODMAR + VV1->VV1_MODVEI + VV1->VV1_SEGMOD )

	DbSelectArea("VE4")
	DbSetOrder(1)
	DbSeek( xFilial("VE4") + VV1->VV1_CODMAR )

	If VE4->VE4_VDAREV == "1" // 1 - Data da venda do veiculo
		dDataPesq := VO5->VO5_DATVEN
	ElseIf VE4->VE4_VDAREV == "2" // 2 - Data da primeira revisao do veiculo
		dDataPesq := VO5->VO5_PRIREV
	Else // 3 - Data da entrega do veiculo
		dDataPesq := VO5->VO5_DATSAI
	EndIf

	DbSelectArea("VVL")
	DbSetOrder(1)
	If !DbSeek(xFilial("VVL")+VV1->VV1_CODMAR+VV1->VV1_MODVEI+VV1->VV1_SEGMOD+Dtos(dDataPesq), .t.);
		.And. (VVL->VVL_FILIAL+VVL->VVL_CODMAR+VVL->VVL_MODVEI+VVL->VVL_SEGMOD # xFilial("VVL")+VV1->VV1_CODMAR+VV1->VV1_MODVEI+VV1->VV1_SEGMOD;
		.Or. VVL->VVL_DATGAR > dDataPesq)
		DbSkip(-1)
	EndIf

	// Valida garantia por data
	If VVL->VVL_FILIAL+VVL->VVL_CODMAR+VVL->VVL_MODVEI+VVL->VVL_SEGMOD == xFilial("VVL")+VV1->VV1_CODMAR+VV1->VV1_MODVEI+VV1->VV1_SEGMOD
		If !Empty(dDataGar)
			If (dDataPesq+VVL->VVL_PERGAR) >= dDataGar
				lRetorno := .t.
			EndIf
		EndIf
		// Valida garantia por kilometro
		If !Empty(nKmGar)
			If VVL->VVL_KILGAR >= nKmGar
				lRetorno := .t.
			EndIf
		EndIf
	EndIf

	// Verifica a garantia da peca ou da venda balcao
	DbSelectArea("VEC")

	For nVar := 1 to FCount()
		Aadd(aVetGar[3], FieldName(nVar))
	Next

	Aadd(aVetGar[3], "VSC_KILROD")   // Armazenara o kilometro da aplicacao do item VSC

	DbSelectArea("SBM")
	DbSetOrder(1)
	DbSeek(xFilial("SBM")+cGruIte)

	DbSelectArea("VE4")
	DbSetOrder(1)
	DbSeek(xFilial("VE4")+SBM->BM_CODMAR)

	DbSelectArea("VO1")
	DbSetOrder(4)
	DbSeek(xFilial("VO1")+cChaInt+"F")

	Do While !Eof() .And. VO1->VO1_CHAINT+VO1->VO1_STATUS == cChaInt+"F" .And. VO1->VO1_FILIAL == xFilial("VO1")
		// Valida garantia por data
		If !Empty( dDataGar )
			DbSelectArea("VEC")
			DbSetOrder(5)
			DbSeek( xFilial("VEC") + VO1->VO1_NUMOSV )
		
			Do While !Eof() .And. VEC->VEC_NUMOSV == VO1->VO1_NUMOSV .And. VEC->VEC_FILIAL == xFilial("VEC")
				lCondicao := (Alltrim(VEC->VEC_GRUITE) == alltrim(cGruIte) .And. alltrim(VEC->VEC_CODITE) == alltrim(cCodIte))
				If lCondicao
					DbSelectArea("VOI")
					DbSetOrder(1)
					DbSeek(xFilial("VOI")+VEC->VEC_TIPTEM)
				
					If VEC->VEC_BALOFI == "O"  // Verifica garantia de peca
						If !Empty(dDataGar) //renata
							If  VEC->VEC_DATVEN+VE4->VE4_PERPEC >= dDataGar
								dDataPesq := VEC->VEC_DATVEN
								aVetGar[4] := {}
								lAchou := .t.
							EndIf
						EndIf
					
						// Valida garantia por kilometro
						DbSelectArea("VSC")
						DbSetOrder(1)
						If DbSeek(xFilial("VSC")+VO1->VO1_NUMOSV)
							nKmReq := VSC->VSC_KILROD
						EndIf
					
						// Adiciona no vetor
						DbSelectArea("VEC")
						Aadd(aVetGar[4], {})
						For nVar := 1 to FCount()
							Aadd(aVetGar[4,Len(aVetGar[4])], FieldGet(nVar))
						Next
						Aadd(aVetGar[4,Len(aVetGar[4])], VSC->VSC_KILROD)
					ElseIf VEC->VEC_BALOFI == "B"  // Verifica garantia de peca balcao
						// Salva a data da aplicadacao da peca balcao nao garantia
						If VOI->VOI_SITTPO # "2" .Or.;
						 		Empty(dDataPesq) .Or.;
						  		(dDataPesq+VE4->VE4_PERBAL) < VEC->VEC_DATVEN
							dDataPesq := VEC->VEC_DATVEN
							aVetGar[4] := {}
						EndIf
						// Adiciona no vetor
						DbSelectArea("VEC")
						Aadd(aVetGar[4], {})
						For nVar := 1 to FCount()
							Aadd(aVetGar[4,Len(aVetGar[4])], FieldGet(nVar))
						Next
						Aadd(aVetGar[4,Len(aVetGar[4])], 0)
					EndIf
					cVerificacao := VEC->VEC_BALOFI
					EndIf
				DbSelectArea("VEC")
				DbSkip()
			EndDo		
		EndIf
		DbSelectArea("VO1")
		DbSkip()
	EndDo

	If cVerificacao == "O"  // Verifica garantia de peca
		// Valida garantia por kilometro
		If !Empty(nKmGar)
			If (nKmReq+VE4->VE4_KILPEC) >= nKmGar
				lRetorno := .t.
			EndIf
		EndIf
	ElseIf cVerificacao == "B" // Verifica garantia de peca BALCAO
		// Valida garantia por data
		If !Empty(dDataGar)
			If (dDataPesq + VE4->VE4_PERBAL) >= dDataGar
				lRetorno := .t.
			EndIf
		EndIf
	EndIf

	DbSelectArea("VOI")
	DbSetOrder(1)
	DbSeek(xFilial("VOI") + cTipTem)
	If VOI->VOI_SITTPO # "2" // Se o tipo de tempo nao for de garantia e a peca esta na garantia mostra historico da peca
		If lTela .And. lRetorno
			If Len(aVetGar[4]) == 0
				Aadd(aVetGar[4], {})
				For nVar := 1 to Len(aVetGar[3])
					Aadd(aVetGar[4,Len(aVetGar[4])], CriaVar(aVetGar[3,nVar]))
				Next
			EndIf
			lAchou := .t.
		EndIf
		lRetorno := .t.
	Else
		// Verifica campanha
		DbSelectArea("VOU")
		DbSetOrder(2)
		DbSeek(xFilial("VOU")+VV1->VV1_CHASSI)
		Do While !Eof() .And. VOU->VOU_FILIAL+VOU->VOU_CHASSI == xFilial("VOU")+VV1->VV1_CHASSI
			DbSelectArea("VOP")
			DbSetOrder(1)
			If DbSeek(xFilial("VOP")+VOU->VOU_NUMINT);
				.And. (Empty(VOP->VOP_DATCAM) .Or. dDataGar >= VOP->VOP_DATCAM) ;
				.And. (Empty(VOP->VOP_DATVEN) .Or. dDataGar <= VOP->VOP_DATVEN)
			
				lRetorno := .t.
				Exit
			EndIf
			DbSelectArea("VOU")
			DbSkip()
		EndDo
	EndIf

	If !VO1->(Found()) .Or. !VEC->(Found())
		lRetorno := .t.
	EndIf
	// Volta posicoes originais
	sRestArea(aArea)

	If !lRetorno .And. lTela
		Help(" ",1,"VGARNEXIST")
	EndIf
Return(lAchou)