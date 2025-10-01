#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "FISR005U.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FISR005  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 04.11.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Declaracao Jurada - 1879 - Chile                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³ Manutencao Efetuada                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±³ Uso      ³ Fiscal - Chile                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data    ³ BOPS     ³ Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jonathan Glz³08/07/15³PCREQ-4256³Se elimina la funcion AjustaSX1() que ³±±
±±³            ³        ³          ³hace modificacion a SX1 por motivo de ³±±
±±³            ³        ³          ³adecuacion a fuentes a nuevas estruc- ³±±
±±³            ³        ³          ³turas SX para Version 12.             ³±±
±±³M.Camargo   ³09.11.15³PCREQ-4262³Merge sistemico v12.1.8		           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FISR005U()

	Local cPerg    := "FISR005"
	Local aFiliais := {}

	
	If Pergunte(cPerg,.T.)
	
		//Seleciona Filiais
		aFiliais := MatFilCalc(MV_PAR03 == 1)
	
		FRPrint(aFiliais)
	EndIf

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FRPrint  ³ Autor ³ Ivan Haponczuk      ³ Data ³ 04.11.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Carrega informacoes e efetua a impressao da declaracao.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aFiliais - Array com as filiais selecionadas.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISR005                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FRPrint(aFiliais)

	Local nI    := 0
	Local nLin  := 0
	Local nTot1 := 0
	Local nTot2 := 0
	Local nTot3 := 0
	Local nTot4 := 0
	Local nItem := 0
	Local cQry  := ""
	Local cAnos := ""
		
	Private oFont1 := TFont():New("Verdana",,10,,.F.,,,,,.F.)
	Private oFont2 := TFont():New("Verdana",,10,,.T.,,,,,.F.)
	Private oFont3 := TFont():New("Verdana",,15,,.T.,,,,,.F.)
	
	oPrint := TmsPrinter():New(STR0001)//"Relatorio para preenchimento da declaracao jurada 1879"
	oPrint:SetPaperSize(9)
	oPrint:SetPortrait()
	oPrint:StartPage()

	oPrint:Say(0050,0050,STR0002,oFont3)//"Relatorio para preenchimento da declaracao jurada 1879"
	cAnos := AllTrim(Str(Year(MV_PAR01)))
	For nI:=(Year(MV_PAR01)+1) To Year(MV_PAR02)
		cAnos += "/"+AllTrim(Str(nI))
	Next nI
	oPrint:Say(0120,0050,STR0003+cAnos,oFont1)//"Ano Tributario "
	
	oPrint:Box(0200,0020,0280,0520)
	oPrint:Say(0220,0040,STR0004,oFont1)//"ROL UNICO TRIBUTARIO"
	oPrint:Box(0200,0520,0280,2355)
	oPrint:Say(0220,0540,STR0005,oFont1)//"Nombre o razon Social"
	
	oPrint:Box(0280,0020,0360,0520)
	oPrint:Say(0300,0040,Transform(SM0->M0_CGC,X3Picture("A2_CGC")),oFont1)	
	//oPrint:Box(0280,0390,0360,0520)
	oPrint:Box(0280,0520,0360,2355)
	oPrint:Say(0300,0540,SM0->M0_NOMECOM,oFont1)
	
	oPrint:Box(0360,0020,0440,2000)
	oPrint:Say(0380,0040,STR0006,oFont1)//"Domicio Fiscal"
	oPrint:Box(0360,2000,0440,2355)
	oPrint:Say(0380,2020,STR0007,oFont1)//"Comuna"
	
	oPrint:Box(0440,0020,0520,2000)
	oPrint:Say(0460,0040,SM0->M0_ENDCOB,oFont1)
	oPrint:Box(0440,2000,0520,2355)
	oPrint:Say(0460,2020,SM0->M0_CIDCOB,oFont1)
	
	oPrint:Box(0520,0020,0600,1700)
	oPrint:Say(0540,0040,STR0008,oFont1)//"Correo Electronico"
	oPrint:Box(0520,1700,0600,2000)
	oPrint:Say(0540,1720,STR0009,oFont1)//"Fax"
	oPrint:Box(0520,2000,0600,2355)
	oPrint:Say(0540,2020,STR0010,oFont1)//"Telefono"
	
	oPrint:Box(0600,0020,0680,1700)
	oPrint:Say(0620,0040,MV_PAR08,oFont1)
	oPrint:Box(0600,1700,0680,2000)
	oPrint:Say(0620,1720,SM0->M0_TEL,oFont1)
	oPrint:Box(0600,2000,0680,2355)
	oPrint:Say(0620,2020,SM0->M0_FAX,oFont1)
	
	oPrint:Box(0680,0020,0760,2355)
	oPrint:Say(0700,0040,STR0011,oFont2)//"Datos de los informados"

	oPrint:Box(0760,0020,1000,0150)
	oPrint:Say(0940,0040,STR0012,oFont1)//"No."
	
	oPrint:Box(0760,0150,1000,0620)
	oPrint:Say(0880,0170,STR0013,oFont1)//"Rut del Receptor"
	oPrint:Say(0940,0170,STR0014,oFont1)//"de la Renta"
	
	oPrint:Box(0760,0620,0840,2000)
	oPrint:Say(0780,0640,STR0015+DTOC(MV_PAR01)+STR0016+DTOC(MV_PAR02),oFont1)//"Monto Retenido Anual Actualizado (Del"###"ate"
	
	oPrint:Box(0840,0620,0920,1220)
	oPrint:Say(0860,0640,STR0017,oFont1)//"Honorario y Otros (Art 42 No.)"
	oPrint:Box(0840,1220,0920,2000)
	oPrint:Say(0860,1240,STR0018,oFont1)//"Remuneraciones de Directores (Art 48)"
	
	oPrint:Box(0920,0620,1000,1220)
	oPrint:Say(0940,0640,STR0019,oFont1)//"Tasa 10%"
	
	oPrint:Box(0920,1220,1000,1610)
	oPrint:Say(0940,1240,STR0020,oFont1)//"Tasa 10%"
	oPrint:Box(0920,1610,1000,2000)
	oPrint:Say(0940,1630,STR0021,oFont1)//"Tasa 20%"
	
	oPrint:Box(0760,2000,1000,2355)
	oPrint:Say(0880,2020,STR0022,oFont1)//"Numero de"
	oPrint:Say(0940,2020,STR0023,oFont1)//"Certificado"
	
	cQry := " SELECT"
	cQry += "  SA2.A2_CGC"
	cQry += " ,SA2.A2_ARTHON"
	cQry += " ,FE_ALIQ"
	cQry += " ,FE_RETATU"
	cQry += " ,FE_NROCERT"
	cQry += " FROM "+RetSqlName("SA2")+" SA2"
	cQry += " INNER JOIN "+RetSqlName("SFE")+" SFE ON"
	cQry += " ("
	cQry += "  SFE.D_E_L_E_T_ = ' '"
	If !(MV_PAR03 == 1)
		cQry += "  AND ( SFE.FE_FILIAL = '"+Space(TamSX3("F3_FILIAL")[1])+"'"
		For nI:=1 To Len(aFiliais)
			If aFiliais[nI,1]
				cQry += " OR SFE.FE_FILIAL = '"+aFiliais[nI,2]+"'"
			EndIf
		Next nI
		cQry += "  )"
	Else
		cQry += " AND SFE.FE_FILIAL = '"+xFilial("SFE")+"'"
	EndIf
	cQry += "  AND SFE.FE_EMISSAO >= '"+DTOS(MV_PAR01)+"'"
	cQry += "  AND SFE.FE_EMISSAO <= '"+DTOS(MV_PAR02)+"'"
	cQry += "  AND FE_RETATU > 0"
	cQry += "  AND SFE.FE_FORNECE = SA2.A2_COD"
	cQry += "  AND SFE.FE_LOJA = SA2.A2_LOJA"
	cQry += "  AND SFE.FE_REGHIST = ' '"
	cQry += " )"
	cQry += " WHERE SA2.D_E_L_E_T_ = ' '"
	cQry += " AND SA2.A2_COD >= '"+MV_PAR04+"'"
	cQry += " AND SA2.A2_LOJA >= '"+MV_PAR05+"'"
	cQry += " AND SA2.A2_COD <= '"+MV_PAR06+"'"
	cQry += " AND SA2.A2_LOJA <= '"+MV_PAR07+"'""
	
	TcQuery cQry New Alias "QRY"
	
	nLin  := 1000
	nItem :=1
	
	dbSelectArea("QRY")
	Do While QRY->(!EOF())
	
		nLin := FMudaPag(nLin)
	
		oPrint:Box(nLin,0020,nLin+80,0150)
		oPrint:Box(nLin,0150,nLin+80,0620)
		oPrint:Box(nLin,0620,nLin+80,1220)
		oPrint:Box(nLin,1220,nLin+80,1610)
		oPrint:Box(nLin,1610,nLin+80,2000)
		
		oPrint:Say(nLin+20,0040,Transform(nItem,"@E 999"),oFont1)
		oPrint:Say(nLin+20,0170,Transform(QRY->A2_CGC,X3Picture("A2_CGC")),oFont1)
		
		If QRY->A2_ARTHON == "1"
			oPrint:Say(nLin+20,0880,AliDir(QRY->FE_RETATU),oFont1)
			nTot1 += QRY->FE_RETATU
		Else
			If QRY->FE_ALIQ == 10
				oPrint:Say(nLin+20,1280,AliDir(QRY->FE_RETATU),oFont1)
				nTot2 += QRY->FE_RETATU
			Else
				oPrint:Say(nLin+20,1670,AliDir(QRY->FE_RETATU),oFont1)
				nTot3 += QRY->FE_RETATU
			EndIf
		EndIf
		nTot4++
		
		oPrint:Box(nLin,2000,nLin+80,2355)
		oPrint:Say(nLin+20,2020,QRY->FE_NROCERT,oFont1)
		
		nLin  += 80
		nItem += 1
		QRY->(dbSkip())
	EndDo
	QRY->(dbCloseArea())

	If nLin > 2760
		nLin := 10000
	EndIf
	
	nLin := FMudaPag(nLin)
	oPrint:Box(nLin,0020,nLin+80,2355)
	oPrint:Say(nLin+20,0040,STR0024,oFont1)//"Cuadro Resumen Final da Decalarcion"
	
	nLin := FMudaPag(nLin+80)
	oPrint:Box(nLin,0020,nLin+80,2355)
	oPrint:Say(nLin+20,0040,STR0025+DTOC(MV_PAR01)+STR0026+DTOC(MV_PAR02),oFont1)//"Monto Retenido Actualizado"###"al"
	
	nLin := FMudaPag(nLin+160)
	If nLin <> 50
		nLin -= 80
	EndIf
	oPrint:Box(nLin,0020,nLin+80,0620)
	oPrint:Say(nLin+20,0040,STR0027,oFont1)//"Honorarios y Otros (Art 42 No.)"
	oPrint:Box(nLin,0620,nLin+80,2000)
	oPrint:Say(nLin+20,0640,STR0028,oFont1)//"Remuneraciones de Directores (Art 48)"
	
	oPrint:Box(nLin,2000,nLin+160,2355)
	oPrint:Say(nLin+40,2020,STR0029,oFont1)//"Total de"
	oPrint:Say(nLin+100,2020,STR0030,oFont1)//"Casos Informados"
	
	nLin += 80
	oPrint:Box(nLin,0020,nLin+80,0620)
	oPrint:Say(nLin+20,0040,STR0031,oFont1)//"Tasa 10%"
	oPrint:Box(nLin,0620,nLin+80,1320)
	oPrint:Say(nLin+20,0640,STR0032,oFont1)//"10%"
	oPrint:Box(nLin,1320,nLin+80,2000)
	oPrint:Say(nLin+20,1340,STR0033,oFont1)//"20%"
	
	nLin := FMudaPag(nLin+80)
	oPrint:Box(nLin,0020,nLin+80,0620)
	oPrint:Say(nLin+20,0180,AliDir(nTot1),oFont1)
	oPrint:Box(nLin,0620,nLin+80,1320)
	oPrint:Say(nLin+20,0880,AliDir(nTot2),oFont1)
	oPrint:Box(nLin,1320,nLin+80,2000)
	oPrint:Say(nLin+20,1670,AliDir(nTot3),oFont1)
	oPrint:Box(nLin,2000,nLin+80,2355)
	oPrint:Say(nLin+20,2020,AliDir(nTot4),oFont1)
	
	nLin := FMudaPag(nLin+80)	
	oPrint:Say(nLin+20,0050,STR0034,oFont1)//"RUT REPRESENTANTE LEGAL"
	
	nLin := FMudaPag(nLin+80)
	oPrint:Box(nLin,0020,nLin+80,0620)
	oPrint:Say(nLin+20,0040,Transform(MV_PAR09,PesqPict("SA2","A2_CGC")),oFont1)
       
	oPrint:EndPage()
	oPrint:Preview()
	oPrint:End()
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FMudaPag ³ Autor ³ Ivan Haponczuk      ³ Data ³ 04.11.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Efetua a quebra da pagina se nescessario.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nLin - Linha atual da impressao.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ nLin - Retorna a linha onde a impressao deve continuar.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISR005                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FMudaPag(nLin)

	If (nLin+80) >= 3350
		nLin := 50
		oPrint:EndPage()
		oPrint:StartPage()
	EndIf
		
Return nLin

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ AliDir   ³ Autor ³ Ivan Haponczuk      ³ Data ³ 06.10.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Faz alinhamento do valor a direita.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nVal - Valor a ser alinhado.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ cRet - Valor alinhado.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Fiscal - FISA032                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AliDir(nVal)

	Local cRet  := ""
	Local cPict := "@E 999,999,999"
	
	If Len(Alltrim(Str(Int(nVal))))==9                    
		cRet:=PADL(" ",1," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==8                    
		cRet:=PADL(" ",3," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==7                    
		cRet:=PADL(" ",5," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==6                    
		cRet:=PADL(" ",8," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==5                     
		cRet:=PADL(" ",10," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==4                       
		cRet:=PADL(" ",12," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==3                    
		cRet:=PADL(" ",15," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==2               
		cRet:=PADL(" ",17," ")+alltrim(Transform(nVal,cPict))
	ElseIf Len(Alltrim(Str(Int(nVal))))==1         
		cRet:=PADL(" ",19," ")+alltrim(Transform(nVal,cPict))
	EndIf

Return cRet
