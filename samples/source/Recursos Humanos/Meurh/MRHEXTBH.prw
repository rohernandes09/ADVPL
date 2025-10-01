#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWPRINTSETUP.CH" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "MRHEXTBH.CH"

/*/
MRHExtBh
Recebe dados do funcionário, e gera um arquivo .pdf
com o extrato de horas no período informado.
@author alberto.ortiz
@since 27/04/2023
/*/
User Function MRHExtBh()

	Local cBranchVld := PARAMIXB[1] // Filial
	Local cMatSRA	 := PARAMIXB[2] // Matricula
	Local cCodEmp 	 := PARAMIXB[3] // Empresa
	Local dInicio	 := PARAMIXB[4] // Data de inicio para buscar
	Local dFim		 := PARAMIXB[5] // Data fim para busca.
	Local lJob		 := PARAMIXB[6] // Indica se abrirá job ( Somente será .T. caso a empresa do gestor seja diferente do subordinado )
	Local cUID 		 := PARAMIXB[7] // Identificador do Job ( Somente em casos do lJob = .T. )
	
	Local aArea      := GetArea()
	Local aOcorrBH   := {}
	Local aReturn    := {}
	Local cPadrao999 := "9999999.99"
	Local lImpBaixad := .F.
	Local dDtFim	 := cTod("//")
	Local dDtIni	 := dInicio
	Local oFile      := JsonObject():New()
	Local oDetReg    := Nil
	Local oSaldo     := JsonObject():New()

	//Caso a data fim não tenha sido preenchida, preenche com a data de hoje.
	dDtFim := If(!Empty(dFim), dFim, DATE())

	If lJob
		//Instancia o ambiente para a empresa onde a funcao sera executada
		RPCSetType(3)
		RPCSetEnv(cCodEmp, cBranchVld)
	EndIf

	oSaldo["MV_TCFBHVL"] := If(SuperGetMv("MV_TCFBHVL",.F.,.F.) == .F., 1, 0)
	lImpBaixad	         := SuperGetMv("MV_IMPBHBX",,.T.) // Lista horas baixadas?

	dbSelectArea('SRA')
	dbSetOrder(1)

	If SRA->(dbSeek(cBranchVld + cMatSRA))

		//-- Carrega os Totais de Horas e Abonos.
		oSaldo["Horas_positivas"]           := 0
		oSaldo["Horas_negativas"]           := 0
		oSaldo["Saldo"]                     := 0
		oSaldo["Saldo_anterior"]            := 0 
		oSaldo["Saldo_anterior_valorizado"] := 0

		// Verifica lancamentos no Banco de Horas
		dbSelectArea("SPI")
		dbSetOrder(2)
		dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)

		//Caso a data inicial venha em branco, é utilizada a data de admissão.
		dDtIni := If(!Empty(dDtIni), dDtIni, SRA->RA_ADMISSA)

		//Varre a tabela SPI
		While !Eof() .And. SPI->PI_FILIAL+SPI->PI_MAT == SRA->RA_FILIAL + SRA->RA_MAT

			// Totaliza Saldo Anterior.
			// Busca na SP9 - utilizando SPI.
			If SPI->PI_STATUS == " " .And. SPI->PI_DATA < dDtIni
				If PosSP9(SPI->PI_PD, SRA->RA_FILIAL, "P9_TIPOCOD") $ "1*3" 
					If oSaldo["MV_TCFBHVL"] == 1	// Horas Normais
						oSaldo["Saldo_anterior"]             := SomaHoras(oSaldo["Saldo_anterior"], SPI->PI_QUANT)
						oSaldo["Saldo_anterior_valorizado"]  := SomaHoras(oSaldo["Saldo_anterior_valorizado"], SPI->PI_QUANTV)
					Else
						oSaldo["Saldo_anterior"] := SomaHoras(oSaldo["Saldo_anterior"], SPI->PI_QUANTV)
					Endif
				Else
					If oSaldo["MV_TCFBHVL"] == 1
						oSaldo["Saldo_anterior"]            := SubHoras(  oSaldo["Saldo_anterior"], SPI->PI_QUANT)
						oSaldo["Saldo_anterior_valorizado"] := SubHoras(oSaldo["Saldo_anterior_valorizado"], SPI->PI_QUANTV)
					Else
						oSaldo["Saldo_anterior"]   := SubHoras(oSaldo["Saldo_anterior"], SPI->PI_QUANTV)
					Endif
				Endif
				oSaldo["Saldo"] := oSaldo["Saldo_anterior"]
			EndIf
			//Valida as datas.
			If	SPI->PI_DATA < dDtIni .Or. SPI->PI_DATA > dDtFim .Or. (SPI->PI_STATUS == "B" .And. !lImpBaixad) 
				dbSkip()
				Loop
			Endif

			PosSP9(SPI->PI_PD, SRA->RA_FILIAL)

			// Acumula os lancamentos de Proventos/Desconto no array aOcorrBH 
			If !(SPI->PI_STATUS=="B" .And. SPI->PI_DTBAIX <= dDtFim)
				If SP9->P9_TIPOCOD $ "1*3"
					oSaldo["Saldo"] := SomaHoras(oSaldo["Saldo"], If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV))
				Else
					oSaldo["Saldo"] := SubHoras(oSaldo["Saldo"], If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV))
				Endif
			EndIf

			oDetReg                                := JsonObject():New()
			oDetReg["Data"]                        := padr(DTOC(SPI->PI_DATA),10)
			oDetReg["Descricao_do_Evento"]         := Left(DescPdPon(SPI->PI_PD, SPI->PI_FILIAL), 20)
			oDetReg["Quantidade_de_Horas_Debito"]  := Transform(If(SP9->P9_TIPOCOD $ "1*3", 0, If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV)), cPadrao999)
			oDetReg["Quantidade_de_Horas_Credito"] := Transform(If(SP9->P9_TIPOCOD $ "1*3", If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV), 0), cPadrao999)
			oDetReg["Saldo"] 					   := Transform(oSaldo["Saldo"], cPadrao999)

			aAdd(aOcorrBH, oDetReg)

			// Acumula os lancamentos de Proventos/Desconto no array aOcorrBH 
			If !(SPI->PI_STATUS=="B" .And. SPI->PI_DTBAIX <= dDtFim)
				If SP9->P9_TIPOCOD $ "1*3"
					oSaldo["Horas_positivas"] := SomaHoras(oSaldo["Horas_positivas"], If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV))
				Else
					oSaldo["Horas_negativas"] := SomaHoras(oSaldo["Horas_negativas"], If(oSaldo["MV_TCFBHVL"]==1, SPI->PI_QUANT, SPI->PI_QUANTV))
				EndIf
			EndIf

			dbSelectArea( "SPI" )
			SPI->(dbSkip())
		Enddo
	EndIf

	If (Len(aOcorrBH) > 0 )
		oFile                 := fImpGraf(dDtIni, dDtFim, oSaldo, aOcorrBH)
		oFile["error"]        := .F.
		oFile["errorMessage"] := ""
	Else
		oFile["error"]        := .T.
		oFile["errorMessage"] := STR0001 + dToC(dDtIni) + " - " + dToC(dDtFim) //"Não foram encontrados saldo de horas para o período "
	Endif

	RestArea(aArea)

	If lJob
		//Atualiza a variavel de controle que indica a finalizacao do JOB
		PutGlbValue(cUID, "1")
	EndIf

	AADD(aReturn, oFile['content'])
	AADD(aReturn, oFile['fileName'])
	AADD(aReturn, oFile['error'])
	AADD(aReturn, oFile['errorMessage'])

	FreeObj(oDetReg)
	FreeObj(oSaldo)
	FreeObj(oFile)

Return aReturn

/*/
fImpGraf
Faz a impressão do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
/*/

Static Function fImpGraf(dDtIni, dDtFim, oSaldo, aOcorrBH)

	Local cLocal 	   := GetSrvProfString("STARTPATH", "")
	Local cFile	 	   := AllTrim(SRA->RA_FILIAL) + "_" + AllTrim(SRA->RA_MAT)
	Local cFileContent := ""
	Local nLin	 	   := 0
	Local oFile        := Nil
	Local oPrint       := Nil
	Local oFileRet     := JsonObject():New()

	DEFAULT aOcorrBH := {}
	DEFAULT dDtIni   := cToD("//")
	DEFAULT dDtFim   := cToD("//")
	DEFAULT oSaldo   := Nil

	//Remove espaços em branco do nome do arquivo.
	cFile  := StrTran( cFile, " ", "_")
	oPrint := FWMSPrinter():New(cFile +".pdf", IMP_PDF, .F., cLocal, .T., Nil, Nil, Nil, .T., Nil, .F., Nil)
	oPrint:SetPortrait()

	//Cabeçalho
	fCabecGrf(@nLin, oPrint)

	//Dados do Periodo
	fPerGrf(@nLin, dDtIni, dDtFim, oPrint)

	//Cabeçalho dos Valores do BH
	fCabBH(@nLin, oPrint)

	//Valores do BH
	fValBH(@nLin, aOcorrBH, oPrint)

	//Saldos Finais
	fSaldosBH(@nLin, oSaldo, oPrint)

	oPrint:EndPage() // Finaliza a pagina
	oPrint:cPathPDF := cLocal 
	oPrint:lViewPDF := .F.
	oPrint:Print()

	//Avalia o arquivo gerado no servidor
	If File( cFile + ".pdf" )
		oFile := FwFileReader():New( cFile + ".pdf" )
		If (oFile:Open())
			cFileContent         := oFile:FullRead()
			oFileRet['content']  := cFileContent
			oFileRet['fileName'] := cFile +".pdf"
			oFile:Close()
		EndIf
	EndIf

	FreeObj(oFile)
	FreeObj(oPrint)

Return oFileRet

/*/
fCabecGrf
Faz a impressão do cabeçalho do extrato de horas..
@author alberto.ortiz
@since 27/04/2023
/*/

Static Function fCabecGrf(nLin, oPrint)

	Local aInfo			:= {}
	Local aDtHr         := {}
	Local cFile			:= ""
	Local cFilDesc      := ""
	Local cDepDesc      := ""
	Local cFuncDesc     := ""
	Local cNome         := ""
	Local cMat          := ""
	Local cStartPath	:= GetSrvProfString("Startpath","")
	Local cPagText      := "Página: "
	Local lNomeSoc      := SuperGetMv("MV_NOMESOC", NIL, .F.) 
	Local oFont15n      := TFont():New("Arial", 15, 15, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont12n      := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont10       := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.) //Normal s/ negrito

	DEFAULT nLin   := 0
	DEFAULT oPrint := Nil

	fInfo(@aInfo, SRA->RA_FILIAL)

	cMat      := SRA->RA_MAT
	cFilDesc  := aInfo[1]
	cDepDesc  := AllTrim(fDesc('SQB', SRA->RA_DEPTO, 'QB_DESCRIC', Nil, SRA->RA_FILIAL))
	cNome     := If(lNomeSoc .And. !Empty(SRA->RA_NSOCIAL), AllTrim(SRA->RA_NSOCIAL), AllTrim(SRA->RA_NOME))
	cFuncDesc := AllTrim(fDesc('SRJ', SRA->RA_CODFUNC, 'RJ_DESC', Nil, SRA->RA_FILIAL))

	//Inicia uma nova pagina.
	oPrint:StartPage() 

	//Horário da geração do extrato de horas.
	aDtHr := FwTimeUF("SP", Nil, .T.)  
	nLin := 20
	oPrint:Say(nLin, 400, dToC(date()) + Space(1) + Time() + " - " + cPagText + "1", oFont10)
	nLin +=10 
	oPrint:Line(nLin, 10, nLin, 575, 12)

	//Logo
	cFile := cStartPath + "lgrl" + cEmpAnt + ".bmp"
	If File(cFile)
		oPrint:SayBitmap(nLin + 4, 25, cFile, 60, 50) // Tem que estar abaixo do RootPath
		nLin += 40
	Endif
	nLin +=20
	oPrint:Say(nLin,  40, STR0002, oFont15n) //EXTRATO DO BANCO DE HORAS
	nLin +=20
	oPrint:Say(nLin,  40, STR0003, oFont12n) //Empresa
	oPrint:Say(nLin, 200, STR0004, oFont12n) //Filial
	oPrint:Say(nLin, 400, STR0005, oFont12n) //Departamento
	nLin +=10
	oPrint:Say(nLin,  40,  cEmpAnt, oFont10) //Empresa
	oPrint:Say(nLin, 200, cFilDesc, oFont10) //Filial
	oPrint:Say(nLin, 400, cDepDesc, oFont10) //Departamento
	nLin +=30
	oPrint:Say(nLin,  40, STR0006, oFont12n) //Nome
	oPrint:Say(nLin, 200, STR0007, oFont12n) //Matrícula
	oPrint:Say(nLin, 400, STR0008, oFont12n) //Função
	nLin +=10
	oPrint:Say(nLin,  40,     cNome, oFont10) //Nome
	oPrint:Say(nLin, 200,      cMat, oFont10) //Matrícula
	oPrint:Say(nLin, 400, cFuncDesc, oFont10) //Função
	nLin +=10
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin +=25

	FreeObj(oFont15n)
	FreeObj(oFont12n)
	FreeObj(oFont10)

Return .T.

/*/
fPerGrf
Faz a impressão do período do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
/*/

Static Function fPerGrf(nLin, dDtIni, dDtFim, oPrint)

	Local oFont12n := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont10  := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.) //Normal s/ negrito

	DEFAULT nLin   := 0
	DEFAULT dDtIni := cToD("//")
	DEFAULT dDtFim := cToD("//")
	DEFAULT oPrint := Nil

	nLin  += 10
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 10
	oPrint:Say(nLin, 270, STR0009, oFont12n) //Período.
	nLin  += 15
	oPrint:Say(nLin, 245, DtoC(dDtIni) + " - " + dToC(dDtFim), oFont10) //Valores do período informado.
	nLin  += 5
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 40
	
	FreeObj(oFont12n)
	FreeObj(oFont10)

Return .T.

/*/
fCabBH
Faz a impressão do cabeçalho da seção dos eventos do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
@param nLin, oPrint
/*/

Static Function fCabBH(nLin, oPrint)

	Local oFont12n := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito

	DEFAULT nLin   := 0
	DEFAULT oPrint := Nil

	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin += 15
	oPrint:Say(nLin,  40, STR0010, oFont12n) //Data
	oPrint:Say(nLin, 100, STR0011, oFont12n) //Evento
	oPrint:Say(nLin, 300, STR0012, oFont12n) //Positivas
	oPrint:Say(nLin, 400, STR0013, oFont12n) //Negativas
	oPrint:Say(nLin, 500, STR0014, oFont12n) //Saldo
	nLin  += 10
	oPrint:Line(nLin, 10, nLin, 575, 12)

	FreeObj(oFont12n)

Return .T.

/*/
fValBH
Faz a impressão dos eventos do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
@param nLin, aOcorrBH, oPrint
/*/

Static Function fValBH(nLin, aOcorrBH, oPrint)

	Local nX	      := 0
	Local nPagina     := 1
	Local nTamPriPag  := 50
	Local nTamPagina  := 75
	Local nRegistros  := 0
	Local cPagText    := "Página: "
	Local oFont10     := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.)	//Normal negrito

	DEFAULT aOcorrBH := {}
	DEFAULT nLin     := 0
	DEFAULT oPrint   := Nil

	nRegistros := Len(aOcorrBH)
	nLin +=10

	For nX := 1 To nRegistros

		//Controle da paginação - Situações em que ocorrem a quebra da página:
		//1 - Não coube na primeira página: - nRegistros > 50 e nPagina ==1
		//2 - Relatório tem mais de uma página e não coube na página atual (mais de 75 registros):
		//    nPagina > 1 .And. nX > (nTamPriPag + (nPagina - 1) * (nTamPagina))
		//3 - Está na última página do relatório e o rodapé não vai caber:
		//    Exemplos onde a o rodapé não cabe na página atual:
		//    40  < nRegistros <= 50  - primeira página
		//    115 < nRegistros <= 125 - segunda página
		//    190 < nRegistros <= 200 - terceira página
		//    3a - (nTamPriPag - 10 + (nPagina - 1) * (nTamPagina)) < nRegistros <= (nTamPriPag + (nPagina - 1) * (nTamPagina))
		//    3b - Faz a quebra quando for o primeiro registro da página seguinte: nX == nTamPriPag - 9 + (nPagina - 1) * (nTamPagina)  

		If (nPagina == 1 .And. nX > nTamPriPag) .Or. ; // - 1.
		   (nPagina > 1 .And. nX > (nTamPriPag + (nPagina - 1) * (nTamPagina))) .Or. ; // - 2.
		   ((nTamPriPag - 10 + (nPagina - 1) * (nTamPagina) < nRegistros) .And. ; // - 3a.
		    (nRegistros <= nTamPriPag + (nPagina - 1) * (nTamPagina)) .And. ;// - 3a.
			nX == nTamPriPag - 9 + (nPagina - 1) * (nTamPagina))// - 3b.
			
			//Encerra a página e começa outra
			oPrint:EndPage()
			oPrint:StartPage()
			nPagina++
			nLin := 20
			//Imprime horário e numeração da página.
			oPrint:Say(nLin, 400, dToC(date()) + Space(1) + Time() + Space(1) + " - " + cPagText + Alltrim(Str(nPagina)), oFont10)
			nLin := 40
			//Imprime o cabeçalho do Banco de horas novamente
			fCabBH(@nLin, @oPrint)
			nLin += 20
		EndIf

		// Impressão da linha
		oPrint:Say(nLin,  40,                        AllTrim(aOcorrBH[nX]["Data"]), oFont10) // Data
		oPrint:Say(nLin, 100,         AllTrim(aOcorrBH[nX]["Descricao_do_Evento"]), oFont10) // Evento
		oPrint:Say(nLin, 300, AllTrim(aOcorrBH[nX]["Quantidade_de_Horas_Credito"]), oFont10) // Positivas
		oPrint:Say(nLin, 400,  AllTrim(aOcorrBH[nX]["Quantidade_de_Horas_Debito"]), oFont10) // Negativas
		oPrint:Say(nLin, 500,                       AllTrim(aOcorrBH[nX]["Saldo"]), oFont10) // Saldo
		nLin += 10
	Next nX

	nLin +=20

	FreeObj(oFont10)
Return .T.

/*/
fSaldosBH
Faz a impressão dos saldos do extrato de horas.
@author alberto.ortiz
@since 27/04/2023
@param nLin, oSaldo, oPrint
/*/

Static Function fSaldosBH(nLin, oSaldo, oPrint)

	Local cSaldoAnterior  := ""
	Local cHorasPositivas := ""
	Local cHorasNegativas := ""
	Local cSaldo          := ""
	Local cPadrao999      := "9999999.99"
	Local oFont12n        := TFont():New("Arial", 12, 12, Nil, .T., Nil, Nil, Nil, .T., .F.) //Normal negrito
	Local oFont10         := TFont():New("Arial", 10, 10, Nil, .F., Nil, Nil, Nil, .T., .F.) //Normal s/ negrito

	DEFAULT nLin   := 0
	DEFAULT oSaldo := Nil
	DEFAULT oPrint := Nil

	cSaldoAnterior  := If(oSaldo["MV_TCFBHVL"] == 1, Transform(oSaldo["Saldo_anterior"], cPadrao999), Transform(oSaldo["Saldo_anterior_valorizado"],cPadrao999))
	cHorasPositivas := Transform(oSaldo["Horas_positivas"], cPadrao999)
	cHorasNegativas := Transform(oSaldo["Horas_negativas"], cPadrao999)
	cSaldo          := Transform(          oSaldo["Saldo"], cPadrao999)

	nLin  += 10
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 10

	oPrint:Say(nLin,  40, STR0015, oFont12n) // Saldo Anterior
	oPrint:Say(nLin, 250, STR0016, oFont12n) // Valores do Período
	oPrint:Say(nLin, 500, STR0017, oFont12n) // Saldo Final

	nLin += 10
    oPrint:Say(nLin,     40,            cSaldoAnterior, oFont10) // Saldo Anterior
	oPrint:Say(nLin,    250, STR0018 + cHorasPositivas, oFont10) // Horas positivas: 
	oPrint:Say(nLin+10, 250, STR0019 + cHorasNegativas, oFont10) // Horas Negativas: 
	oPrint:Say(nLin,    500,                    cSaldo, oFont10) // Saldo

	nLin  += 20
	oPrint:Line(nLin, 10, nLin, 575, 12)
	nLin  += 10

	FreeObj(oFont12n)
	FreeObj(oFont10)

Return .T.
