#Include "PROTHEUS.CH" 
#Include "TopConn.CH" 

User function OM450IMP()
    Local oReport
	Private cTitulo   := "Requisição/Devoluções de Ferramentas"
	Private cDesc2    := ""
	Private cAliasP   := "VO9"
	Private cNomeRel  := "OM450"
    Private cVdpCod := PARAMIXB[1]

    oReport := RptDef()
    oReport:nFontBody := 12
    oReport:oPage:nPaperSize := 9
    oReport:PrintDialog()
Return 

Function RptDef()
    Local oReport
    Local oSection1
    Local oSection2

    oReport := TReport():New(;
        cNomeRel,;
        cTitulo,;
        ,;
        {|oReport| RunReport(oReport)},;
        cDesc2;
    )

    oReport:SetLineHeight(45)
    oSection1 := TRSection():New(oReport)
    oSection1:SetLinesBefore(1)
    oSection1:SetHeaderPage()

	TRCell():New(oSection1,"CODFERR","VD3",'Cód. Ferramenta',,12)
    TrCell():New(oSection1,"FERRA","VO9","Ferramenta",,20)
    TrCell():New(oSection1,"QUANT","VD3","Quantidade",,5)
    TrCell():New(oSection1,"CODPROD","VO9","Cód. Produto",,12)
    TrCell():New(oSection1,"LOCALI","","Localização",,12)
    TrCell():New(oSection1,"NUMOS","VD3","Numero OS",,20)
    TrCell():New(oSection1,"TIPTEM","VD3","Tipo de Tempo",,15)

	DBSelectArea('VDP')
	DBSetOrder(1)
	MSSeek(xFilial('VDP') + cVdpCod)

    oSection2 := TRSection():New(oReport)
    oSection2:SetLinesBefore(5)

    TRCell():New(oSection2,"COL1",'','', ,10)
    TrCell():New(oSection2,"COLRESP",'','', ,40)
    TrCell():New(oSection2,"COL3",'','', ,20)
    TrCell():New(oSection2,"COLPREST",'','',,40)
    TrCell():New(oSection2,"COL5",'','', ,10)
    oSection2:SetHeaderSection(.F.)

Return oReport

Function RunReport(oReport)
    Local cQuery := ""
    Local oSection1 := oReport:Section(1)
    Local oSection2 := oReport:Section(2)

    oSection1:Init()

	cQuery += "   SELECT VD3.VD3_SEQUEN, VD3.VD3_CODFER, VO9.VO9_CODPRO, "
	cQuery += "          VO9.VO9_DESFER, VD3.VD3_DATMOV, VD3.VD3_QTDMOV, VD3_NUMOSV, VD3_TIPTEM, VD3.R_E_C_N_O_ "
	cQuery += "     FROM " + RetSqlName('VD3') + " VD3 " 
	cQuery += "     JOIN " + RetSqlName('VO9') + " VO9 ON VO9_FILIAL = '" + xFilial('VO9') + "' AND VO9_CODFER = VD3_CODFER AND VO9.D_E_L_E_T_ = ' ' "
	cQuery += "    WHERE VD3.VD3_FILIAL = '" + xFilial('VD3')  + "' "
	cQuery += "      AND VD3.VD3_CODIGO = '" + cVdpCod + "' "
	cQuery += "      AND VD3.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY VD3.VD3_SEQUEN ASC "

    If Select("QRYVD3") > 0
        QRYVD3->(DBCloseArea())
    Endif
	TcQuery cQuery New Alias 'QRYVD3'
    DbSelectArea("QRYVD3")
    DBGoTop()

	While !QRYVD3->(EOF()) // Enquanto o cursor da area de trabalho ativa nao indicar fim de arquivo
	    oSection1:Cell("CODFERR"):SetValue(QRYVD3->VD3_CODFER)
        oSection1:Cell("FERRA"):SetValue(QRYVD3->VO9_DESFER)
        oSection1:Cell("QUANT"):SetValue(QRYVD3->VD3_QTDMOV)
        oSection1:Cell("CODPROD"):SetValue(QRYVD3->VO9_CODPRO)
        
		DbSelectArea("SB5")
		DbSeek( xFilial("SB5") + QRYVD3->VO9_CODPRO)
        
        oSection1:Cell("LOCALI"):SetValue(FM_PRODSBZ(QRYVD3->VO9_CODPRO,"SB5->B5_LOCALI2"))
        oSection1:Cell("NUMOS"):SetValue(QRYVD3->VD3_NUMOSV)
        oSection1:Cell("TIPTEM"):SetValue(QRYVD3->VD3_TIPTEM)
        oSection1:PrintLine()

		QRYVD3->(DbSkip())
	End
	QRYVD3->(dbCloseArea())

    oSection1:Print()
    oSection1:Finish()

    oSection2:Init()

    oSection2:Cell("COL1"):SetValue(Replicate(" ", 10))
    oSection2:Cell("COLRESP"):SetValue(Replicate("_", 40))
    oSection2:Cell("COL3"):SetValue(Replicate(" ", 10))
    oSection2:Cell("COLPREST"):SetValue(Replicate("_", 40))
    oSection2:Cell("COL5"):SetValue(Replicate(" ", 10))
    oSection2:PrintLine()

    oReport:SkipLine(2)
    oSection2:Cell('COLRESP'):SetAlign('CENTER')
    oSection2:Cell('COLPREST'):SetAlign('CENTER')

    oSection2:Cell("COL1"):SetValue(Replicate(" ", 10))
    oSection2:Cell("COLRESP"):SetValue('Resposavel')
    oSection2:Cell("COL3"):SetValue(Replicate(" ", 10))
    oSection2:Cell("COLPREST"):SetValue('Prestador')
    oSection2:Cell("COL5"):SetValue(Replicate(" ", 10))
    oSection2:PrintLine()

    oSection2:Finish()
    oSection2:Print()
Return oReport