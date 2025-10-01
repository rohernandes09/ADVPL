#INCLUDE "IMPRECPAR.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE Imp_Spool      	2
#DEFINE ALIGN_H_LEFT   	0
#DEFINE ALIGN_H_RIGHT  	1
#DEFINE ALIGN_H_CENTER 	2
#DEFINE ALIGN_V_CENTER 	0
#DEFINE ALIGN_V_TOP	   	1
#DEFINE ALIGN_V_BOTTON 	2
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER030  ³ Autor ³ Cristian E. Franco      ³ Data ³                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Recibos de Pagamento                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER030PAR(void)                                                          ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß        
*/

User Function IMPRECPAR(lTerminal,cFilTerminal,cMatTerminal,cProcTerminal, nRecTipo, cPerTerminal, cSemanaTerminal)                 
Local cString :="SRA"        // alias do arquivo principal (Base)
Local cIndCond
Local cRotBlank := Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))

Private nOrdem := 1 //Orden del Informe
Private cBaseAux 	:= "S"
Private cMes	:= ""
Private cAno    := ""
Private cPerg    :="GPER030PAR"
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe
Private aLanca 		:= {}
Private aProve 		:= {}
Private aDesco 		:= {}
Private aBases 		:= {}
Private aInfo  		:= {}
Private aCodFol		:= {}
Private li     		:= _PROW()
Private Titulo 		:= STR0011		//"EMISSO DE RECIBOS DE PAGAMENTOS"
Private aPerAberto	:= {}
Private aPerFechado	:= {}
Private cProcesso	:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
Private cRoteiro	:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo	:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).
Private cRot		:= ""
Private oPrinter		:= ""
Private oPrint
Private oArial07	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)//Normal
Private oFont08		:= TFont():New("Courier New",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)//Negrito
Private oArial10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)//Negriot 
Private oFont3 			:=	TFont():New( "Arial", 12, 12, , .T., , , , .T., .F. )//Titulo Interno
Private lPDFEmail		:= .T. //PDF é por Email quando for .F. Visualizar o PDF no remote
Private aEmail  := {}
Private Semana
Private cSemana 
Private Mensag1     
Private Mensag2     
Private Mensag3       


Default lTerminal := .F. //³ Verifica se o programa foi chamado do terminal - TCF         ³             

if !Pergunte(cPerg, .t.)
    Return
endif    


cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
cProcesso  := IF( !( lTerminal ), mv_par01 , cProcTerminal		)   //Processo
cRoteiro   := IF( !( lTerminal ), mv_par02 , nRecTipo			)	//Emitir Recibos(Roteiro)
cPeriodo   := IF( !( lTerminal ), mv_par03 , cPerTerminal		)   //Periodo
Semana     := IF( !( lTerminal ), mv_par04 , cSemanaTerminal	)	//Numero da Semana
cSemana    := Semana

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se o sistema esta trabalhando com ou sem roteiro   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "RCH" )
DbSetOrder( 4 )
If !RCH->(DbSeek(  xFilial( "RCH" ) + cProcesso + cRoteiro + cPeriodo + Semana, .F. ))
	RCH->(DbSeek(  xFilial( "RCH" ) + cProcesso + cRotBlank + cPeriodo + Semana, .F. ))
Else
	cRotBlank := cRoteiro
EndIf

//Carregar os periodos abertos (aPerAberto) e/ou 
// os periodos fechados (aPerFechado), dependendo 
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
				cRotBlank	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				Semana		,; // Numero de Pagamento selecionado na Pergunte.
				NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
				NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
				@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
				@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
				
// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
			cRotBlank	,; // Roteiro selecionado na Pergunte.
			cPeriodo	,; // Periodo selecionado na Pergunte.
			@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
			@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
			Semana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
dDataRef := CTOD("01/" + cMes + "/" + cAno)

nTipRel    := IF( !( lTerminal ), mv_par05 , 3				)	//Tipo de Recibo (Pre/Pdf Mail/EMail)
cFilDe     := IF( !( lTerminal ), mv_par06,cFilTerminal		)	//Filial De
cFilAte    := IF( !( lTerminal ), mv_par07,cFilTerminal		)	//Filial Ate
cCcDe      := IF( !( lTerminal ), mv_par08,SRA->RA_CC		)	//Centro de Custo De
cCcAte     := IF( !( lTerminal ), mv_par09,SRA->RA_CC		)	//Centro de Custo Ate
cDeptoDe   := IF( !( lTerminal ),mv_par10,SRA->RA_DEPTO 		)	//Depto. De
cDeptoAte  := IF( !( lTerminal ),mv_par11,SRA->RA_DEPTO 		)	//Depto. Ate
cMatDe     := IF( !( lTerminal ), mv_par12,cMatTerminal		)	//Matricula Des
cMatAte    := IF( !( lTerminal ), mv_par13,cMatTerminal		)	//Matricula Ate
Mensag1    := mv_par14										 	//Mensagem 1
Mensag2    := mv_par15											//Mensagem 2
Mensag3    := mv_par16											//Mensagem 3
cSituacao  := IF( !( lTerminal ),mv_par17, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !( lTerminal ),mv_par18, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := If(mv_par19 == 1,"S","N")							//Imprimir Bases
lQuebraFun := IIF( !( lTerminal ) .And. !Empty(mv_par20),(mv_par20 == 1),.F.) 


If nTipRel ==2 //Visualiza PDF
	lPDFEmail	:= .F.
EndIf

limpArqPdf() //Limpar Recibos que por ventura ainda estejam no servidor
cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)

DbSelectArea( "SRA" )

RptStatus({|lEnd| R030Imp(@lEnd,cString,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(lEnd,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function R030Imp(lEnd,cString,cMesAnoRef,lTerminal)


Local cAcessaSR1  := &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  := &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRD  := &("{ || " + ChkRH("GPER030","SRD","2") + "}")
Local cNroHoras   := &("{ || If(aVerbasFunc[nReg,5] > 0 .And. cIRefSem == 'S', aVerbasFunc[nReg,5], aVerbasFunc[nReg,6]) }")
Local nHoras      := 0
Local nReg		  := 0
Local cKey		  := ""
Local cInicio	  := ""
Local dDataLibRh
Local cPerCorrente	:= ""
Local cSemCorrente	:= ""
Local cMesCorrente 	:= ""
Local cAnoCorrente 	:= ""
Local nTcfDadt		:= if(lTerminal,getmv("MV_TCFDADT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF 
Local nTcfDfol		:= if(lTerminal,getmv("MV_TCFDFOL",,0),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= if(lTerminal,getmv("MV_TCFD131",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= if(lTerminal,getmv("MV_TCFD132",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= if(lTerminal,getmv("MV_TCFDEXT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nDec
Private ORDEMZ     	:= 0

Private cTipoRot 	:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_TIPO")
Private aVerbasFunc := {}
Private cRotBlank


//-Ordem 1 -> RCA_FILIAL+RCA_MNEMON
If FPOSREG("RCA", 1, XFILIAL("RCA")+"RHDECIMAIS")
	nDec := Val(Alltrim(RCA->RCA_CONTEU))
Else
	nDec := MsDecimais(1)
EndIf

//If nDec = 0 
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E  9,999,999,999"
	cPict3 	:=	"@E 999,999,999"
//Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(nTcfDadt)=="C",val(nTcfDadt),nTcfDadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(nTcfDfol)=="C",val(nTcfDfol),nTcfDfol)
nTcfDext	:= if(valtype(nTcfDext)=="C",val(nTcfDext),nTcfDext)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se o Mes solicitado esta liberado para consulta no  |
//| terminal de consulta do funcionario.                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTerminal

	dbSelectArea("RCH")
	dbSetOrder(6)
	cKey    := "xFilial('RCH') + cProcesso" + IIf(cRoteiro == "EXT", "", " + cRoteiro")
	cInicio := "RCH_FILIAL + RCH_PROCES" + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
	
	If !DbSeek( &(cKey))
		cRotBlank 	:= Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
		cKey := "xFilial('RCH') + cProcesso " + IIf(cRoteiro == "EXT", "", " + cRotBlank")
		cInicio := "RCH_FILIAL + RCH_PROCES " + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
		DbSeek( &(cKey))
	EndIf
	If DbSeek( &(cKey))
		While RCH->( !Eof() .and. &(cInicio) == &(cKey))
			If Empty(RCH->RCH_DTFECH)
				cPerCorrente := RCH->RCH_PER
				cSemCorrente := RCH->RCH_NUMPAG
				cMesCorrente := RCH->RCH_MES
				cAnoCorrente := RCH->RCH_ANO
				Exit
			EndIf		
			RCH->( dbSkip() )
		EndDo
	EndIf

	If	(cPerCorrente == cPeriodo .AND. cSemCorrente == Semana)  .OR. ;
		( MesAno(dDataRef) >= (cAnoCorrente + cMesCorrente) )

		If  cTipoRot == "2" //Adiantamento
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfDadt,.F.) )
				Return
			EndIf
		ElseIf cTipoRot == "1" .and. !empty(nTCFDFOL) //Folha
			dDataLibRh := fMontaDtTcf(cMesCorrente + cAnoCorrente,nTCFDFOL)
			If Date() < dDataLibRh
				Return
			Endif
		ElseIf cTipoRot == "5" //1a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
  			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfD131,.F.) )
				Return
			Endif
		ElseIf cTipoRot == "6" //2a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfD132,.F.) )
				Return
			Endif
		ElseIf cRoteiro == "EXT"  // Valores Extras
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTcfDext,.F.) )
				Return
			Endif
		EndIf
	Endif
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
IF !( lTerminal )
	If nOrdem == 1			//"Matricula"
		dbSetOrder(1)
	ElseIf nOrdem == 2		//"Nome"
		dbSetOrder(3)
	ElseIf nOrdem == 3		//"C.Custo"
		dbSetOrder(2)
	Elseif nOrdem == 4		//"C.Custo + Nome"
		dbSetOrder(8)
	Endif
	dbGoTop()
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	IF !( lTerminal )
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	Else
		cFim    := &(cInicio)
	EndIf
EndIf	
dbSelectArea("SRA")

SetRegua(RecCount())	// Total de elementos da regua

TOTVENC:= TOTDESC:= TOTBAS:=   0 
Desc_Fil := Desc_End :=   ""
Desc_CGC := Desc_Comp:= Desc_Est := Desc_Cid:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := Space(FwGetTamFilial)

If nTipRel == 1 .and. !( lTerminal ) //Vista previa
	
		oPrint:= TMSPrinter():New(Titulo)//Emissao de Recibos de Pagamentos
		oPrint:SetPortrait()            //Define que a impressao deve ser RETRATO//
		oPrint:setPaperSize(DMPAPER_LETTER) //Defino Tamaño de Papel A4
	
Endif

While SRA->( !Eof()  .And. &cInicio <= cFim )
	IF !( lTerminal )

		IncRegua()  // Anda a regua
		
		If  (SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)      .Or. ;
			(SRA->RA_DEPTO < cDeptoDe) .Or. (SRA->RA_DEPTO > cDeptoAte)
			SRA->(dbSkip(1))     
			Loop 
		EndIf
	EndIF
	
	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	IF !( lTerminal )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste situacao e categoria dos funcionarios			     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			dbSkip()
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			dbSkip()
			Loop
		EndIf
		
	EndIF
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Exit
		Endif      
		Desc_Fil := aInfo[3]
		Desc_End := aInfo[4]                // Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Substr(fDesc("SX5","12"+aInfo[6],"X5DESCRI()"),1,12)
		Desc_Comp:= aInfo[14]        			// Complemento Cobranca
		Desc_Cid := aInfo[05]
		// MENSAGENS
		If !Empty(Mensag1)
			If FPHIST82(SRA->RA_FILIAL, "06", Mensag1)
				DESC_MSG1 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If !Empty(Mensag2)
			If FPHIST82(SRA->RA_FILIAL, "06", Mensag2)
				DESC_MSG2 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		If !Empty(Mensag3)
			If FPHIST82(SRA->RA_FILIAL, "06", Mensag3)
				DESC_MSG3 := Left(SRX->RX_TXT,30)
			Endif
		Endif
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	            
	//Retorna as verbas do funcionario, de acordo com os periodos selecionados
	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
										SRA->RA_MAT	  					,; // Matricula do funcionario corrente
										NIL								,; // 
										cRoteiro	  					,; // Roteiro selecionado na pergunte
										NIL			  					,; // Array com as verbas que deverão ser listadas. Se NIL retorna todas as verbas.
										aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
										aPerFechado	 	 				 ) // Array com os Periodos e Numero de pagamento fechados

	If cRoteiro <> "EXT"
		For nReg := 1 to Len(aVerbasFunc)
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD)) .Or.;
			   ( aVerbasFunc[nReg,7] <= 0 )
				dbSkip()
				Loop
			EndIf
			
			If cBaseAux = "N"
				if PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) $ "34"
					dbSkip()
		   			Loop
				Endif
			Endif
			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				
					nHoras := Eval(cNroHoras)
				
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]   
				
				
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],Eval(cNroHoras),aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD $ "3/4"   
			    if (aVerbasFunc[nReg,3] == aCodFol[047,1])
					fSomaPdRec("B",aVerbasFunc[nReg,3],Eval(cNroHoras),aVerbasFunc[nReg,7])
				Endif
			Endif
		
			If (aVerbasFunc[nReg,3] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1])
				nBaseIr += aVerbasFunc[nReg,7]
			ElseIf (aVerbasFunc[nReg,3] $ aCodFol[13,1]+'*'+aCodFol[19,1])
				nAteLim += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[108,1]+'*'+aCodFol[17,1])
				nBaseFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[109,1]+'*'+aCodFol[18,1])
				nFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] == aCodFol[16,1])
				nBaseIrFe += aVerbasFunc[nReg,7]
			Endif
		Next nReg
	Elseif cRoteiro == "EXT"
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif
				If !Eval(cAcessaSR1)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR  
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD $ "3/4" .and. ALLTRIM(SRV->RV_IMPRIPD) == "1"     
				   //TOTBAS += TOTBAS + SR1->R1_VALOR
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif             
	
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	             
	If nTipRel == 1 .and. !( lTerminal )
	    
		fImpreGraf()
		    
	ElseIf (nTipRel == 2 .OR. nTipRel == 3) .and. !( lTerminal ) //2 Visualizar o PDF 3 Enviar PDF por email
		fImprPDF(lPDFEmail)
		fEnvPDFEmail()
		ASize(aProve,0)
		ASize(aDesco,0)
		ASize(aBases,0)    
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	if(lQuebraFun) //.AND. aReturn[5] <> 3  /*Se desejar imprimir um comprovante por folha...ignorada quando impresso direto na porta (formulario continuo)*/
		__Eject()
	   	LI := 4
		SetPrc(LI,0)
	EndIf
	TOTDESC := TOTVENC := 0
	
EndDo

If nTipRel == 1 .and. !( lTerminal )  
	oPrint:Preview()  
Endif               

If nTipRel == 2 .and. !( lTerminal ) //Visuaiza PDF
	IF ( Type( "oPrinter" ) == "O" )
		oPrinter:Preview()
		oPrinter:EndPage()                                                          
		FreeObj(oPrinter)
		oPrinter := Nil
	Else
		MSGALERT( "STR0203", "STR0202" ) //"Não foram localizados demonstrativos de pagamentos disponíveis para esta consulta."  -  "Atenção!"	
	EndIf
ElseIf nTipRel == 3 .and. !( lTerminal ) //Envia PDF x Mail	
	fEnvPDFEmail()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpreGraf³ Autor ³ SSERVICE				³ Data ³ 05.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO FORMULARIO GRAFICO                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImpreGraf()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpreGraf()

Local nConta    := 0  
Private nRe2    := 1650

fcabecg()
fLancaG(nConta)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabecG   ³ Autor ³ SSERVICE              ³ Data ³ 04.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabe‡alho Grafico                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabecG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCabecG()   // Cabecalho do Recibo Zebrado
Local cCodFunc		:= ""		//-- codigo da Funcao do funcionario
Local cDescFunc		:= ""		//-- Descricao da Funcao do Funcionario
Local cStartPath	:= GetSrvProfString("Startpath","")
Local cNome         := ""
Local cDoc          := fRCC()
Local cFECVAC       := fSRF(SRA->RA_FILIAL,SRA->RA_MAT,IIF(ALLTRIM(DTOS(SRA->RA_DTREC))<>"",DTOS(SRA->RA_DTREC),DTOS(SRA->RA_ADMISSA)))
Local nAux01 		:= 0
Local cTipCot		:= ''
Local cPluriEmp		:= ''
Local cDemissa		:= ''	
Local cTeImss		:= ''
Local cJubilac		:= ''
Local cQuery := ""
Local cAliasTab := GetNextAlias()
Local cDesFil  := RTRIM(SM0->M0_FILIAL)
Local cCGC     := RTRIM(SM0->M0_CGC)


oPrint:StartPage()
oPrint:Box(20,15,200,2400 )
oPrint:SayBitmap(030,060,cStartPath+"lgrl"+FwCodEmp("SM0")+".bmp",200,100) // Tem que estar abaixo do RootPath

oPrint:Say(030,0900,UPPER("RECIBO DE PAGO - ")+UPPER(fDesc("SRY", cRoteiro, "RY_DESC", , xFilial("SRY"))),oFont3)
oPrint:Say(080,1000,ALLTRIM(cDesFil),oFont3)
oPrint:Say(130,1050,ALLTRIM(cCGC),oFont3)
cDataBase:=Substr(Dtos(Date()),7,2)+"/"+Substr(Dtos(Date()),5,2)+"/"+Substr(Dtos(Date()),1,4)
oPrint:Box(0210,0015,0290,2400)

ORDEMZ ++
cNome := Alltrim(SRA->RA_PRISOBR) + " " +Alltrim(SRA->RA_SECSOBR) + " " +Alltrim(SRA->RA_PRINOME)+ " " +Alltrim(SRA->RA_SECNOME)
oPrint:Line(0250,0015,0250,2400)   
oPrint:Say(0260,030,UPPER(STR0220)+cPeriodo,oArial07)
oPrint:Say(0260,400,UPPER(STR0221)+ mv_par04,oArial07)
oPrint:Say(0260,800,UPPER(STR0222)+DTOC(RCH->RCH_DTINI)+ "-" +DTOC(RCH->RCH_DTFIM),oArial07)
oPrint:Say(0260,1400,UPPER(STR0223)+DTOC(RCH->RCH_DTPAGO),oArial07) 
oPrint:Say(0260,2100,UPPER(STR0224)+StrZero(ORDEMZ,4),oArial08N) 
oPrint:Box(0290,0015,0370,2400) 
oPrint:Say(0300,0030,UPPER(GetSX3Cache("RC_FILIAL","X3_TITSPA"))+": "+SRC->RC_FILIAL,oArial07)
oPrint:Say(0300,0400,UPPER(GetSX3Cache("RA_MAT","X3_TITSPA"))+": "+SRA->RA_MAT,oArial07)   
oPrint:Say(0300,800,UPPER(GetSX3Cache("RA_NOME","X3_TITSPA"))+": "+IIF(!EMPTY(SRA->RA_NOMECMP),UPPER(SRA->RA_NOMECMP),UPPER(SRA->RA_NOME)),oArial07)
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
oPrint:Say(0300,1400,UPPER(GetSX3Cache("RA_CODFUNC","X3_TITSPA"))+(STR0219)+SRA->RA_CODFUNC+ space(10)+cDescFunc,oArial07)
oPrint:Say(0300,1900,UPPER(GetSX3Cache("RA_ADMISSA","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_ADMISSA),oArial07)
oPrint:Line(0330,0015,0330,2400) 
oPrint:Say(0340,030,UPPER(GetSX3Cache("RA_CC","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CC) + space(12) + POSICIONE("CTT",1,XFILIAL("CTT") + SRA->RA_CC,"CTT_DESC01") ,oArial07)    
oPrint:Say(0340,800,UPPER(GetSX3Cache("RA_DEPTO","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_DEPTO)+ space(12)+POSICIONE("SQB",1,XFILIAL("SQB") + SRA->RA_DEPTO,"QB_DESCRIC"),oArial07)
oPrint:Say(0340,1400,UPPER(GetSX3Cache("RA_CARGO","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CARGO)+ space(12)+POSICIONE("SQ3",1,XFILIAL("SQ3") + SRA->RA_CARGO,"Q3_DESCSUM"),oArial07)
oPrint:Say(0340,1900,UPPER(GetSX3Cache("RA_HRSMES","X3_TITSPA"))+(STR0219)+TRANSFORM(SRA->RA_HRSMES,"@E 99,999,999.99"),oArial07)  
oPrint:Box(0370,0015,0450,2400)  
oPrint:Say(0380,030,UPPER(GetSX3Cache("RA_TPCIC","X3_TITSPA"))+SRA->RA_TPCIC,oArial07) 
oPrint:Say(0380,400,UPPER(GetSX3Cache("RA_CIC","X3_TITSPA"))+SRA->RA_CIC,oArial07) 

nAux01:= fPosTab("S023",SRA->RA_TIPCOT, "=", 4) 
IF  nAux01>0
	cTipCot := fTabela("S023",nAux01,5)
endif

oPrint:Say(0380,0800,UPPER(GetSX3Cache("RA_TIPCOT","X3_TITSPA"))+cTipCot,oArial07)
oPrint:Say(0380,1400,UPPER(GetSX3Cache("RA_REGISTR","X3_TITSPA"))+(STR0219) +SRA->RA_REGISTR,oArial07)

If(SRA->RA_TEIMSS=="1")
	cTeImss= ' Supervisores'
EndIf	

If(SRA->RA_TEIMSS=="2")
	cTeImss= ' Empleados'
EndIf		

If(SRA->RA_TEIMSS=="3")
	cTeImss= ' Obreros'
EndIf	

If(SRA->RA_TEIMSS=="4")
	cTeImss= ' Menores'
EndIf	

oPrint:Say(0380,1900,UPPER(GetSX3Cache("RA_TEIMSS","X3_TITSPA"))+cTeImss,oArial07)   
oPrint:Box(0410,0015,0410,2400) 
oPrint:Say(0420,0030,UPPER(GetSX3Cache("RA_CODRPAT","X3_TITSPA"))+(STR0219)+SRA->RA_CODRPAT,oArial07)
oPrint:Say(0420,0400,UPPER(GetSX3Cache("RA_RG","X3_TITSPA"))+(STR0219)+SRA->RA_RG,oArial07)
cPluriEmp := IIF(SRA->RA_INSSSC=="1","Si","No")
oPrint:Say(0420,0800,UPPER(GetSX3Cache("RA_INSSSC","X3_TITSPA"))+(STR0219)+cPluriEmp,oArial07) 

If (SRA->RA_JUBILAC=="0")
	cJubilac="No Aplica"
Else
	cJubilac= IIf (SRA->RA_JUBILAC=="1"," Jubilado Vejez"," Jubilado Invalidez")
EndIf
oPrint:Say(0420,1400,UPPER(GetSX3Cache("RA_JUBILAC","X3_TITSPA"))+cJubilac,oArial07)
oPrint:Say(0420,1900,UPPER(GetSX3Cache("RA_OPCAO","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_OPCAO),oArial07)  
oPrint:Box(0450,0015,0530,2400)   
oPrint:Say(0460,030,UPPER(GetSX3Cache("RA_BCDEPSA","X3_TITSPA"))+(STR0219)+SRA->RA_BCDEPSA,oArial07)
oPrint:Say(0460,0400,UPPER(STR0225)+POSICIONE("SA6",1,XFILIAL("SA6")+SUBSTR(SRA->RA_BCDEPSA,1,3)+SUBSTR(SRA->RA_BCDEPSA,4,5),"A6_NREDUZ"),oArial07)  
oPrint:Say(0460,0800,UPPER(GetSX3Cache("RA_BCOHAB","X3_TITSPA"))+(STR0219)+SRA->RA_BCOHAB,oArial07)
oPrint:Say(0460,1400,UPPER(STR0225)+POSICIONE("SA6",1,XFILIAL("SA6")+SUBSTR(SRA->RA_BCOHAB,1,3)+SUBSTR(SRA->RA_BCOHAB,4,5),"A6_NREDUZ"),oArial07) 
oPrint:Say(0460,1900,UPPER(GetSX3Cache("RA_CTDEPSA","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CTDEPSA),oArial07)
oPrint:Box(0490,0015,0490,2400)  
oPrint:Say(0500,0030,UPPER(GetSX3Cache("RA_SALMES","X3_TITSPA"))+(STR0232)+TRANSFORM(SRA->RA_SALMES,"@E 999,999,999.99"),oArial07) 
oPrint:Say(0500,0400,UPPER(GetSX3Cache("RA_SALDIA","X3_TITSPA"))+(STR0232)+TRANSFORM(SRA->RA_SALDIA,"@E 999,999,999.99"),oArial07) 
oPrint:Say(0500,0800,UPPER(GetSX3Cache("RA_MOEDAPG","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_MOEDAPG) +"-" + POSICIONE("CTO",1,XFILIAL("CTO") + SRA->RA_MOEDAPG,"CTO_DESC") ,oArial07)
oPrint:Say(0500,1400,UPPER(GetSX3Cache("RA_DTREC","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_DTREC),oArial07)
					
If SRA->RA_SITFOLH == "D"  
	oPrint:Say(0500,1800,UPPER(GetSX3Cache("RA_DEMISSA","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_DEMISSA),oArial07)
	nAux01:= fPosTab("S005",SRA->RA_TIPOFIN ,"=", 4)
	IF  nAux01>0
		cDemissa := fTabela("S005",nAux01,5)
	Endif
	oPrint:Say(0500,2100,UPPER(GetSX3Cache("RA_TIPOFIN","X3_TITSPA"))+(STR0219)+cDemissa,oArial07)
EndIf

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

cCodSeg:=""

DbSelectArea("RCC")
RCC->(DbSetOrder(RetOrder("RCC","RCC_FILIAL+RCC_CODIGO")))
RCC->(DbGoTop())
If RCC->(DbSeek(xFilial("RCC")+"S021"))
	Do While RCC->(!Eof()).And. RCC->RCC_CODIGO=="S021"
		If SUBSTR(RCC->RCC_CONTEU,1,FwGetTamFilial)==SRA->RA_FILIAL
			cCodSeg:=SUBSTR(RCC->RCC_CONTEU,FwGetTamFilial+1,2)
			Exit
		Endif
		RCC->(DbSkip())
	End
Endif

//Cadastro da Seguradora

cDescSeg:=""
cNumApol:=""
cDescSeg:=""//RGI->RGI_DESCRI
cNumApol:=""//RGI->RGI_NRAPOL

// Recibo 2

oPrint:Box(20 + nRe2,15,200 +  nRe2,2400 )
oPrint:SayBitmap(030 + nRe2,060,cStartPath+"lgrl"+FwCodEmp("SM0")+".bmp",200,100) // Tem que estar abaixo do RootPath
oPrint:Say(030 + nRe2,0900,UPPER ("RECIBO DE PAGO - ")+UPPER(fDesc("SRY", cRoteiro, "RY_DESC", , xFilial("SRY"))),oFont3)
oPrint:Say(080 + nRe2,1000, ALLTRIM(cDesFil),oFont3)
oPrint:Say(130 + nRe2,1050,ALLTRIM(cCGC),oFont3)
oPrint:Box(0210+ nRe2,0015,0290+ nRe2,2400)
cNome := Alltrim(SRA->RA_PRISOBR) + " " +Alltrim(SRA->RA_SECSOBR) + " " +Alltrim(SRA->RA_PRINOME)+ " " +Alltrim(SRA->RA_SECNOME)
oPrint:Line(0250+ nRe2,0015,0250+ nRe2,2400)   
oPrint:Say(0260+ nRe2,030,UPPER(STR0220)+cPeriodo,oArial07)
oPrint:Say(0260+ nRe2,400,UPPER(STR0221)+ mv_par04,oArial07)
oPrint:Say(0260+ nRe2,800,UPPER(STR0222)+DTOC(RCH->RCH_DTINI)+ "-" +DTOC(RCH->RCH_DTFIM),oArial07)
oPrint:Say(0260+ nRe2,1400,UPPER(STR0223)+DTOC(RCH->RCH_DTPAGO),oArial07) 
oPrint:Say(0260+ nRe2,2100,UPPER(STR0224)+StrZero(ORDEMZ,4),oArial08N) // Orden 
oPrint:Box(0290+ nRe2,0015,0370+ nRe2,2400) 
oPrint:Say(0300+ nRe2,0030,UPPER(GetSX3Cache("RC_FILIAL","X3_TITSPA"))+": "+SRC->RC_FILIAL,oArial07)
oPrint:Say(0300+ nRe2,0400,UPPER(GetSX3Cache("RA_MAT","X3_TITSPA"))+": "+SRA->RA_MAT,oArial07)   
oPrint:Say(0300+ nRe2,0800,UPPER(GetSX3Cache("RA_NOME","X3_TITSPA"))+": "+IIF(!EMPTY(SRA->RA_NOMECMP),UPPER(SRA->RA_NOMECMP),UPPER(SRA->RA_NOME)),oArial07)
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )
oPrint:Say(0300+ nRe2,1400,UPPER(GetSX3Cache("RA_CODFUNC","X3_TITSPA"))+(STR0219)+SRA->RA_CODFUNC+ space(10)+cDescFunc,oArial07)
oPrint:Say(0300+ nRe2,1900,UPPER(GetSX3Cache("RA_ADMISSA","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_ADMISSA),oArial07)  
oPrint:Line(0330+ nRe2,0015,0330+ nRe2,2400) 
oPrint:Say(0340+ nRe2,030,UPPER(GetSX3Cache("RA_CC","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CC) +space(12) + POSICIONE("CTT",1,XFILIAL("CTT") + SRA->RA_CC,"CTT_DESC01") ,oArial07) 
oPrint:Say(0340+ nRe2,0800,UPPER(GetSX3Cache("RA_DEPTO","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_DEPTO)+ space(12)+POSICIONE("SQB",1,XFILIAL("SQB") + SRA->RA_DEPTO,"QB_DESCRIC"),oArial07)
oPrint:Say(0340+ nRe2,1400,UPPER(GetSX3Cache("RA_CARGO","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CARGO)+ space(12)+POSICIONE("SQ3",1,XFILIAL("SQ3") + SRA->RA_CARGO,"Q3_DESCSUM"),oArial07) 
oPrint:Say(0340+ nRe2,1900,UPPER(GetSX3Cache("RA_HRSMES","X3_TITSPA"))+(STR0219)+TRANSFORM(SRA->RA_HRSMES,"@e 9,999,999.99"),oArial07)
oPrint:Box(0370+ nRe2,0015,0450+ nRe2,2400)
oPrint:Say(0380+ nRe2,030,UPPER(GetSX3Cache("RA_TPCIC","X3_TITSPA"))+SRA->RA_TPCIC,oArial07) 
oPrint:Say(0380+ nRe2,0400,UPPER(GetSX3Cache("RA_CIC","X3_TITSPA"))+SRA->RA_CIC,oArial07) 
 
nAux01:= fPosTab("S023",SRA->RA_TIPCOT, "=", 4) 
IF  nAux01>0
	cTipCot := fTabela("S023",nAux01,5)
endif

oPrint:Say(0380+ nRe2,0800,UPPER(GetSX3Cache("RA_TIPCOT","X3_TITSPA"))+cTipCot,oArial07)
oPrint:Say(0380+ nRe2,1400,UPPER(GetSX3Cache("RA_REGISTR","X3_TITSPA"))+(STR0219)+SRA->RA_REGISTR,oArial07)
If(SRA->RA_TEIMSS=="1")
	cTeImss= ' Supervisores'
EndIf	

If(SRA->RA_TEIMSS=="2")
	cTeImss= ' Empleados'
EndIf		

If(SRA->RA_TEIMSS=="3")
	cTeImss= ' Obreros'
EndIf	

If(SRA->RA_TEIMSS=="4")
	cTeImss= ' Menores'
EndIf	
oPrint:Say(0380+ nRe2,1900,UPPER(GetSX3Cache("RA_TEIMSS","X3_TITSPA"))+cTeImss,oArial07)
oPrint:Box(0410+ nRe2,0015,0410+ nRe2,2400)
oPrint:Say(0420+ nRe2,0030,UPPER(GetSX3Cache("RA_CODRPAT","X3_TITSPA"))+(STR0219)+SRA->RA_CODRPAT,oArial07)
oPrint:Say(0420+ nRe2,0400,UPPER(GetSX3Cache("RA_RG","X3_TITSPA"))+(STR0219)+SRA->RA_RG,oArial07)
cPluriEmp := IIF(SRA->RA_INSSSC=="1","Si","No")
oPrint:Say(0420+ nRe2,0800,UPPER(GetSX3Cache("RA_INSSSC","X3_TITSPA"))+(STR0219)+cPluriEmp,oArial07)

If (SRA->RA_JUBILAC=="0")
	cJubilac="No Aplica"
Else
	cJubilac= IIf (SRA->RA_JUBILAC=="1"," Jubilado Vejez"," Jubilado Invalidez")
EndIf

oPrint:Say(0420+ nRe2,1400,UPPER(GetSX3Cache("RA_JUBILAC","X3_TITSPA"))+cJubilac,oArial07) 
oPrint:Say(0420+ nRe2,1900,UPPER(GetSX3Cache("RA_OPCAO","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_OPCAO),oArial07)
oPrint:Box(0450+ nRe2,0015,0530+ nRe2,2400)   
oPrint:Say(0460+ nRe2,030,UPPER(GetSX3Cache("RA_BCDEPSA","X3_TITSPA"))+(STR0219)+SRA->RA_BCDEPSA,oArial07)
oPrint:Say(0460+ nRe2,0400,UPPER(STR0225)+POSICIONE("SA6",1,XFILIAL("SA6")+SUBSTR(SRA->RA_BCDEPSA,1,3)+SUBSTR(SRA->RA_BCDEPSA,4,5),"A6_NREDUZ"),oArial07)  
oPrint:Say(0460+ nRe2,0800,UPPER(GetSX3Cache("RA_BCOHAB","X3_TITSPA"))+(STR0219)+SRA->RA_BCOHAB,oArial07)
oPrint:Say(0460+ nRe2,1400,UPPER(STR0225)+POSICIONE("SA6",1,XFILIAL("SA6")+SUBSTR(SRA->RA_BCOHAB,1,3)+SUBSTR(SRA->RA_BCOHAB,4,5),"A6_NREDUZ"),oArial07)  
oPrint:Say(0460+ nRe2,1900,UPPER(GetSX3Cache("RA_CTDEPSA","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CTDEPSA),oArial07)
oPrint:Box(0490+ nRe2,0015,0490+ nRe2,2400)  
oPrint:Say(0500+ nRe2,0030,UPPER(GetSX3Cache("RA_SALMES","X3_TITSPA"))+(STR0232)+TRANSFORM(SRA->RA_SALMES,"@E 999,999,999.99"),oArial07) 
oPrint:Say(0500+ nRe2,0400,UPPER(GetSX3Cache("RA_SALDIA","X3_TITSPA"))+(STR0232)+TRANSFORM(SRA->RA_SALDIA,"@E 999,999,999.99"),oArial07)
oPrint:Say(0500+ nRe2,0800,UPPER(GetSX3Cache("RA_MOEDAPG","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_MOEDAPG) +"-" + POSICIONE("CTO",1,XFILIAL("CTO") + SRA->RA_MOEDAPG,"CTO_DESC") ,oArial07)  
oPrint:Say(0500+ nRe2,1400,UPPER(GetSX3Cache("RA_DTREC","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_DTREC),oArial07)

If SRA->RA_SITFOLH == "D"  
	oPrint:Say(0500+ nRe2,1800,UPPER(GetSX3Cache("RA_DEMISSA","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_DEMISSA),oArial07) 
	nAux01:= fPosTab("S005",SRA->RA_TIPOFIN ,"=", 4) 
	IF  nAux01>0
		cDemissa := fTabela("S005",nAux01,5)
	Endif
	oPrint:Say(0500+ nRe2,2100,UPPER(GetSX3Cache("RA_TIPOFIN","X3_TITSPA"))+(STR0219)+cDemissa,oArial07)
Endif
cDescFunc := ""
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLancaG() ³ Autor ³ SSERVICE              ³ Data ³ 04.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Detalhe do Grafico                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±             
±±³Sintaxe   ³ flancaG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLancaG()
Local nCont     := 0
Local nValidos  := 0
Local nPREST       := 0
Local cPrinome :='' 
Local cSecnome :='' 
Local cPrisobr :='' 
Local cSecsobr :=''   
Local cTipoId  :='' 
Local cNumId   :=''  
Local nAux01   :=0

nAux01:=fPosTab("S006",SM0->M0_CGC,"=",6)
If nAux01>0
   cTipoID  := RTRIM(fTabela("S006",nAux01,9))
   cNumID   := RTRIM(fTabela("S006",nAux01,10))
   cPrisobr := RTRIM(fTabela("S006",nAux01,11))
   cSecsobr := RTRIM(fTabela("S006",nAux01,12))
   cPrinome := RTRIM(fTabela("S006",nAux01,13))
   cSecnome := RTRIM(fTabela("S006",nAux01,14))
EndIf	

nPREST  := fSRK(SRA->RA_FILIAL,SRA->RA_MAT)

nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))

oPrint:Box(0540,0015,1300,2400)
oPrint:Say(0550,0230,UPPER(STR0226),oArial08N)//P R O V E N T O S
oPrint:Say(0550,0980,UPPER(STR0227),oArial08N)//D E S C O N T O S
oPrint:Say(0550,1810,UPPER(STR0228),oArial08N)//B A S E S
oPrint:Line(0590,0015,0590,2400)
oPrint:Say(0600,0025,UPPER(STR0229),oArial08)//REMUNERACIONES
oPrint:Say(0600,0440,UPPER(STR0230),oArial08)//REMUNERACIONES
oPrint:Say(0600,0630,UPPER(STR0231),oArial08)//REMUNERACIONES
oPrint:Say(0600,0840,UPPER(STR0229),oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600,1370,UPPER(STR0231),oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600,1600,UPPER(STR0229),oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600,1985,UPPER(STR0230),oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600,2210,UPPER(STR0231),oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Line(0640,0015,0640,2400)

oPrint:Line(0640,0450,1300,0450) //oPrint:Line(0640,0470,1300,0470)
oPrint:Line(0640,0580,1340,0580) //oPrint:Line(0640,0600,1340,0600)
oPrint:Line(0640,0815,1380,0815) //oPrint:Line(0640,0800,1380,0800)
oPrint:Line(0640,1340,1380,1340) //oPrint:Line(0640,1400,1380,1400)
oPrint:Line(0640,1580,1380,1580) //oPrint:Line(0640,1600,1380,1600)
oPrint:Line(0640,1980,1300,1980) //oPrint:Line(0640,2030,1300,2030)
oPrint:Line(0640,2140,1340,2140) //oPrint:Line(0640,2190,1340,2190)

// Recibo 2

oPrint:Box(0540+nRe2,0015,1300+nRe2,2400)
oPrint:Say(0550+nRe2,0230,UPPER(STR0226),oArial08N)//P R O V E N T O S
oPrint:Say(0550+nRe2,0980,UPPER(STR0227),oArial08N)//D E S C O N T O S
oPrint:Say(0550+nRe2,1810,UPPER(STR0228),oArial08N)//B A S E S
oPrint:Line(0590+nRe2,0015,0590+nRe2,2400)
oPrint:Say(0600+nRe2,0025,UPPER(STR0229),oArial08)//REMUNERACIONES
oPrint:Say(0600+nRe2,0440,UPPER(STR0230),oArial08)//REMUNERACIONES
oPrint:Say(0600+nRe2,0630,UPPER(STR0231),oArial08)//REMUNERACIONES
oPrint:Say(0600+nRe2,0840,UPPER(STR0229),oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600+nRe2,1370,UPPER(STR0231),oArial08)//APORTACIONES Y DESCUENTO
oPrint:Say(0600+nRe2,1600,UPPER(STR0229),oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600+nRe2,1985,UPPER(STR0230),oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Say(0600+nRe2,2210,UPPER(STR0231),oArial08)//APORTACIONES DEL EMPLEADOR
oPrint:Line(0640+nRe2,0015,0640+nRe2,2400)
oPrint:Line(0640+nRe2,0450,1300+nRe2,0450)
oPrint:Line(0640+nRe2,0580,1340+nRe2,0580)
oPrint:Line(0640+nRe2,0815,1380+nRe2,0815)
oPrint:Line(0640+nRe2,1340,1380+nRe2,1340)
oPrint:Line(0640+nRe2,1580,1380+nRe2,1580)
oPrint:Line(0640+nRe2,1980,1300+nRe2,1980)
oPrint:Line(0640+nRe2,2140,1340+nRe2,2140)

nLinDet:=645
For nCont := 1 To nTermina
	IF nCont <= Len(aProve)
		oPrint:Say(nLinDet,020,aProve[nCont,1],oArial08)
		oPrint:Say(nLinDet,460,TRANSFORM(aProve[nCont,2],'999.99'),oFont08) //oPrint:Say(nLinDet,480,TRANSFORM(aProve[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet,590,TRANSFORM(aProve[nCont,3],cPict3),oFont08)   //oPrint:Say(nLinDet,610,TRANSFORM(aProve[nCont,3],cPict3),oFont08)
		
		//Recibo 2
		
		oPrint:Say(nLinDet + nRe2,0020,aProve[nCont,1],oArial08)
		oPrint:Say(nLinDet + nRe2,460,TRANSFORM(aProve[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet + nRe2,0590,TRANSFORM(aProve[nCont,3],cPict3),oFont08)

	ENDIF
	IF nCont <= Len(aDesco)
		oPrint:Say(nLinDet,0820,aDesco[nCont,1],oArial08)
		oPrint:Say(nLinDet,1355,TRANSFORM(aDesco[nCont,3],cPict3),oFont08) //oPrint:Say(nLinDet,1400,TRANSFORM(aDesco[nCont,3],cPict3),oFont08)
		
		//Recibo 2
		
		oPrint:Say(nLinDet + nRe2,0820,aDesco[nCont,1],oArial08)
		oPrint:Say(nLinDet + nRe2,1355,TRANSFORM(aDesco[nCont,3],cPict3),oFont08)
	ENDIF
	IF nCont <= Len(aBases)
		oPrint:Say(nLinDet,1590,aBases[nCont,1],oArial08)
		oPrint:Say(nLinDet,2005,TRANSFORM(aBases[nCont,2],'999.99'),oFont08) //oPrint:Say(nLinDet,2050,TRANSFORM(aBases[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet,2175,TRANSFORM(aBases[nCont,3],cPict3),oFont08)   //oPrint:Say(nLinDet,2210,TRANSFORM(aBases[nCont,3],cPict3),oFont08)
		
		//Recibo 2
		
		oPrint:Say(nLinDet + nRe2,1590,aBases[nCont,1],oArial08)
		oPrint:Say(nLinDet + nRe2,2005,TRANSFORM(aBases[nCont,2],'999.99'),oFont08)
		oPrint:Say(nLinDet + nRe2,2175,TRANSFORM(aBases[nCont,3],cPict3),oFont08)  
		
		TOTBAS += aBases[nCont,3]
	Endif
	//====================================================
	//---- Soma 1 nos nValidos e Linha
	//====================================================
	nValidos ++
	nLinDet+=40

	If nLinDet>=1285
		nLinDet+=40
		oPrint:Box(1300,0015,1380,2400)
		oPrint:Box(1300+nRe2,0015,1380+nRe2,2400)
		oPrint:Box(1340,0015,1340,2400)
		oPrint:Box(1340+nRe2,0015,1340+nRe2,2400)
		oPrint:Say(1460,0910,"C O N T I N U A    R E C I B O No." + StrZero(ORDEMZ,4) ,oArial10N)//TOTAL DESCUENTOS
		oPrint:Say(1460+nRe2,0910,"C O N T I N U A    R E C I B O No." + StrZero(ORDEMZ,4) ,oArial10N)//TOTAL DESCUENTOS
	
		ORDEMZ --
		oPrint:EndPage()
		fCabecG()
		oPrint:Box(0540,0015,1300,2400)
		oPrint:Say(0550,0230,UPPER(STR0226),oArial08N)//H A B E R E S 
		oPrint:Say(0550,0980,UPPER(STR0227),oArial08N)//D E S C O N T O S
		oPrint:Say(0550,1810,UPPER(STR0228),oArial08N)//B A S E S
		oPrint:Line(0590,0015,0590,2400)
		oPrint:Say(0600,0040,UPPER(STR0229),oArial08)//REMUNERACIONES
		oPrint:Say(0600,0470,UPPER(STR0230),oArial08)//REMUNERACIONES
		oPrint:Say(0600,0630,UPPER(STR0231),oArial08)//REMUNERACIONES
		oPrint:Say(0600,0840,UPPER(STR0229),oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600,1400,UPPER(STR0231),oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600,1610,UPPER(STR0229),oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600,2040,UPPER(STR0228),oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600,2210,UPPER(STR0231),oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Line(0640,0015,0640,2400)
	
		oPrint:Line(0640,0450,1300,0450) //oPrint:Line(0640,0470,1300,0470)
		oPrint:Line(0640,0580,1340,0580) //oPrint:Line(0640,0600,1340,0600)
		oPrint:Line(0640,0815,1380,0815) //oPrint:Line(0640,0800,1380,0800)
		oPrint:Line(0640,1340,1380,1340) //oPrint:Line(0640,1400,1380,1400)
		oPrint:Line(0640,1580,1380,1580) //oPrint:Line(0640,1600,1380,1600)
		oPrint:Line(0640,1980,1300,1980) //oPrint:Line(0640,2030,1300,2030)
		oPrint:Line(0640,2140,1340,2140) //oPrint:Line(0640,2190,1340,2190)
		
		// Recibo 2
		
		oPrint:Box(0540+nRe2,0015,1300+nRe2,2400)
		oPrint:Say(0550+nRe2,0230,UPPER(STR0226),oArial08N)//P R O V E N T O S
		oPrint:Say(0550+nRe2,0980,UPPER(STR0227),oArial08N)//D E S C O N T O S
		oPrint:Say(0550+nRe2,1810,UPPER(STR0228),oArial08N)//B A S E S
		oPrint:Line(0590+nRe2,0015,0590+nRe2,2400)
		oPrint:Say(0600+nRe2,0040,UPPER(STR0229),oArial08)//REMUNERACIONES
		oPrint:Say(0600+nRe2,0470,UPPER(STR0230),oArial08)//REMUNERACIONES
		oPrint:Say(0600+nRe2,0630,UPPER(STR0231),oArial08)//REMUNERACIONES
		oPrint:Say(0600+nRe2,0840,UPPER(STR0229),oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600+nRe2,1400,UPPER(STR0231),oArial08)//APORTACIONES Y DESCUENTO
		oPrint:Say(0600+nRe2,1610,UPPER(STR0229),oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600+nRe2,2040,UPPER(STR0228),oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Say(0600+nRe2,2210,UPPER(STR0231),oArial08)//APORTACIONES DEL EMPLEADOR
		oPrint:Line(0640+nRe2,0015,0640+nRe2,2400)
		

		oPrint:Line(0640+nRe2,0450,1300+nRe2,0450)
		oPrint:Line(0640+nRe2,0580,1340+nRe2,0580)
		oPrint:Line(0640+nRe2,0815,1380+nRe2,0815)
		oPrint:Line(0640+nRe2,1340,1380+nRe2,1340)
		oPrint:Line(0640+nRe2,1580,1380+nRe2,1580)
		oPrint:Line(0640+nRe2,1980,1300+nRe2,1980)
		oPrint:Line(0640+nRe2,2140,1340+nRe2,2140)
		nLinDet:=645
		
		nValidos := 0
	Endif
	
Next nCont

oPrint:Box(1300,0015,1380,2400)
oPrint:Say(1310,0040,UPPER(STR0094),oArial08)//TOTAL REMUNERACIONES
oPrint:Say(1310,0590,TRANS(TOTVENC,cPict3),oFont08)
oPrint:Say(1310,0840,UPPER(STR0066),oArial08)//TOTAL DESCUENTOS
oPrint:Say(1310,1355,TRANS(TOTDESC,cPict3),oFont08)
oPrint:Box(1340,0015,1340,2400)
oPrint:Say(1350,0840,UPPER(STR0233),oArial08)//NETO RECIBIDO
oPrint:Say(1350,1355,TRANS(TOTVENC - TOTDESC,cPict3),oFont08)
oPrint:Say(1430,0040,UPPER(fQuery(Mensag1)), oArial08)
oPrint:Say(1470,0040,UPPER(fQuery(Mensag2)), oArial08)
oPrint:Say(1510,0040,UPPER(fQuery(Mensag3)), oArial08)
oPrint:Say(1490,0840,UPPER(STR0234), oArial08)
oPrint:Say(1530,0840,UPPER( RTRIM(cPrinome) + " "+ RTRIM(cSecnome)+ " " + RTRIM(cPrisobr)+" "+ RTRIM(cSecsobr))+" "+cTipoId+" "+cNumId,oArial08)
oPrint:Say(1450,1600,UPPER(STR0235)+ DTOC(RCH->RCH_DTPAGO),oArial08)
oPrint:Say(1490,1600,UPPER(STR0236),oArial08)//EMPLEADO
oPrint:Say(1530,1600,UPPER( RTRIM(SRA->RA_PRINOME) + " "+ RTRIM(SRA->RA_SECNOME)+ " " + RTRIM(SRA->RA_PRISOBR)+" "+ RTRIM(SRA->RA_SECSOBR))+" "+SRA->RA_TPCIC+" "+SRA->RA_CIC,oArial08)
//oPrint:Box(1440,1500,1440,2200)



//Recibo 2

oPrint:Box(1300 + nRe2,0015,1380+ nRe2,2400)
oPrint:Say(1310+ nRe2,0040,UPPER(STR0094),oArial08)//TOTAL REMUNERACIONES
oPrint:Say(1310 + nRe2,0590,TRANS(TOTVENC,cPict3),oFont08)
oPrint:Say(1310+ nRe2,0840,UPPER(STR0066),oArial08)//TOTAL DESCUENTOS
oPrint:Say(1310+ nRe2,1355,TRANS(TOTDESC,cPict3),oFont08)
oPrint:Box(1340+ nRe2,0015,1340+ nRe2,2400)
oPrint:Say(1350+ nRe2,0840,UPPER(STR0233),oArial08)//NETO RECIBIDO
oPrint:Say(1350+ nRe2,1355,TRANS(TOTVENC - TOTDESC,cPict3),oFont08)
oPrint:Say(1430+ nRe2,0040,UPPER(fQuery(Mensag1)), oArial08)
oPrint:Say(1470+ nRe2,0040,UPPER(fQuery(Mensag2)), oArial08)
oPrint:Say(1510+ nRe2,0040,UPPER(fQuery(Mensag3)), oArial08)
//oPrint:Say(1380+ nRe2,1500,1300+ nRe2,2200)
oPrint:Say(1490+ nRe2,0840,UPPER(STR0234), oArial08)

oPrint:Say(1530+ nRe2,0840,UPPER( RTRIM(cPrinome) + " "+ RTRIM(cSecnome)+ " " + RTRIM(cPrisobr)+" "+ RTRIM(cSecsobr))+" "+cTipoId+" "+cNumId,oArial08)
oPrint:Say(1450+ nRe2,1600,UPPER(STR0235)+ DTOC(RCH->RCH_DTPAGO),oArial08)
oPrint:Say(1490+ nRe2,1600,UPPER(STR0236),oArial08)//EMPLEAD
oPrint:Say(1530+ nRe2,1600,UPPER(RTRIM(SRA->RA_PRINOME) + " "+ RTRIM(SRA->RA_SECNOME)+ " " + RTRIM(SRA->RA_PRISOBR)+" "+ RTRIM(SRA->RA_SECSOBR))+" "+SRA->RA_TPCIC+" "+SRA->RA_CIC,oArial08)


oPrint:EndPage()
Return Nil


/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³fMontaDtTcf 	³Autor³Ricardo Duarte     ³ Data ³13/08/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Retorna a data valida para a consulta do Terminal Consulta  ³
³          ³do Funcionario                                         		³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³         												³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso	   ³GPER030COL       										    	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fMontaDtTcf(cMesAno,nDia)

Local dDataValida

Default nDia := 0

dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+"01")
dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+strzero(f_UltDia(dDataValida),2))+nDia

return(dDataValida)



Static Function fRCC()

Local cCodDoc 	:=	 ""
Local aArea   	:=	 RCC->(GetArea())
Local cFilRCC	:=	xFilial("RCC")

DbSelectArea("RCC")
RCC->(DbSetOrder(RetOrder("RCC","RCC_FILIAL+RCC_CODIGO")))
RCC->(DbGoTop())
If RCC->(DbSeek(cFilRCC+"S028"))
	Do While RCC->(!Eof()).And. cFilRCC==RCC->RCC_FILIAL .and. RCC->RCC_CODIGO=="S028"
		If SUBSTR(RCC->RCC_CONTEU,1,2)==SRA->RA_TPCIC
			cCodDoc:=ALLTRIM(SUBSTR(RCC->RCC_CONTEU,Len(xFilial("RCC"))+1,60))
			Exit
		Endif
		RCC->(DbSkip())
	End
Endif

RestArea(aArea)

Return cCodDoc


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Funcion calculo de fechas de Vacaciones del Empleado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù
*/


Static Function fSRF(cFil,cMAT,CADMISSA)

Local cDatas := ""
Local TRB6		 := GetNextAlias()
Local cQuery6    := ""
Local cDta       := substr(cPeriodo,1,4) + substr(CADMISSA,5,4)

//-->Query para sacar la informacion de fechas de vacaciones
cQuery6 := "SELECT RF_FILIAL, RF_MAT, RF_DATABAS, RF_DATAFIM "
cQuery6 += " FROM " + RetSQLName("SRF")+" SRF "
cQuery6 += "WHERE RF_MAT = '" + cMAT + "' AND RF_FILIAL ='"+cFil+"' "
cQuery6 += "AND RF_DATAFIM <= '" + cDta + "' "
cQuery6 += "AND SRF.D_E_L_E_T_ = ' ' "
cQuery6 += "Order By RF_MAT,RF_DATABAS "
cQuery6 := ChangeQuery(cQuery6)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery6),TRB6,.F.,.T.)

DbSelectArea(TRB6)

While !(TRB6)->(Eof())
	
	cDatas := dtoc(stod((TRB6)->RF_DATABAS)) + "-" + dtoc(stod((TRB6)->RF_DATAFIM))
	
	(TRB6)->(dbSkip())
EndDo

(TRB6)->(DBCLOSEAREA())

Return cDatas  



/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcion para calcular el saldo de conceptos de prestamo estatus 2 en la SRK³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

Static Function fSRK(cFil,cMAT)

Local cDatas := ""

Local TRB6		 := GetNextAlias()
Local TRB7		 := GetNextAlias()

Local cQuery6    := ""
Local cQuery7    := ""
Local cPros      := cProcesso
Local cPer       := cPeriodo
Local cRot       := cRoteiro
Local cSem       := mv_par04
Local aPres      := {}
Local nToPre     := 0
Local nQ	     := 0


//-->Query para sacar la informacion de prestamos
cQuery6 := "SELECT RK_FILIAL, RK_MAT, RK_PD, RK_PROCES, RK_STATUS, RK_VLSALDO,RK_NUMID"
cQuery6 += " FROM " + RetSQLName("SRK") +" SRK "
cQuery6 += "WHERE RK_MAT = '" + cMAT + "' AND RK_FILIAL ='"+cFil+"' "
cQuery6 += "AND RK_PROCES = '" + cPros + "' "
cQuery6 += "AND RK_STATUS = '2' "
cQuery6 += "AND SRK.D_E_L_E_T_ = ' ' "
cQuery6 += "Order By RK_MAT,RK_PD "
cQuery6 := ChangeQuery(cQuery6)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery6),TRB6,.F.,.T.)

DbSelectArea(TRB6)
While !(TRB6)->(Eof())
	aAdd(aPres,{(TRB6)->RK_MAT,(TRB6)->RK_PD,(TRB6)->RK_NUMID,(TRB6)->RK_PROCES,(TRB6)->RK_STATUS,(TRB6)->RK_VLSALDO,0,0})
	(TRB6)->(dbSkip())
EndDo

(TRB6)->(DBCLOSEAREA())

If Len(aPres) > 0
	
	nToPre := 0
	
	For nQ:=1 to Len(aPres)
		
		nToPre +=  (aPres[nQ,6])
		
		//-->Query para sacar la informacion de fechas de vacaciones
		cQuery7 := "SELECT RC_FILIAL, RC_MAT, RC_PD, RC_VALOR, RC_NUMID"
		cQuery7 += " FROM " + RetSQLName("SRC")+" SRC "
		cQuery7 += "WHERE RC_MAT = '" + cMAT + "' AND RC_FILIAL ='"+cFil+"' "
		cQuery7 += "AND RC_PROCES = '" + cPros + "' "
		cQuery7 += "AND RC_ROTEIR = '" + cRot + "' "
		cQuery7 += "AND RC_PERIODO = '" + cPer + "' "
		cQuery7 += "AND RC_SEMANA = '" + cSem + "' "
		cQuery7 += "AND RC_NUMID = '" + aPres[nQ,3] + "'  "
		cQuery7 += "AND SRC.D_E_L_E_T_ = ' ' "
		cQuery7 += "Order By RC_MAT,RC_PD "
		cQuery7 := ChangeQuery(cQuery7)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery7),TRB7,.F.,.T.)
		
		DbSelectArea(TRB7)
		While !(TRB7)->(Eof())
			nToPre -= (TRB7)->RC_VALOR
			(TRB7)->(dbSkip())
		EndDo
		
		(TRB7)->(DBCLOSEAREA())
				
	Next nQ
Endif


Return nToPre

/************Impressão PDF**********************************************************************************************/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImprPDF  ³ Autor ³ Cesar Bautista          Data ³25/03/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO EM PDF                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImprPDF()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImprPDF(lPDFEmail)
Local nConta 		:= 0
Local cPath		:= ""
Local cFile		:= ""
Local cEmail		:= ""
Local cIdentUni	:= ""

//Gerar o PDF na Tela
If ! lPDFEmail .AND. Empty(oPrinter)
	oPrinter	:= FWMSPrinter():New("GPER030"  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter:lViewPDF 	:= .T.
EndIf

//Gerar o PDF no Servidor para enviar via email
If lPDFEmail
	cIdentUni	:= DtoS(date())+SUBSTR(TIME()	, 1, 2) +SUBSTR(TIME(), 4, 2) +SUBSTR(TIME(), 7, 2)+AllTrim(Str(Int(Seconds()))) 
	cFile		:= SRA->RA_FILIAL+SRA->RA_MAT+dtos(dDataRef)+cIdentUni+"RecPag"  
	oPrinter	:= FWMSPrinter():New(cFile  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter:lInJob 		:= .T.
	cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"")
	aAdd(aEmail, {{SRA->RA_NOME, cEmail,If(SRA->RA_RECMAIL=="S",.T.,.F.)},SRA->RA_FILIAL,SRA->RA_MAT,dtos(dDataRef),cIdentUni})
EndIf

oPrinter:lServer 			:= .T.
oPrinter:SetResolution() 
oPrinter:SetPortrait() 
oPrinter:SetPaperSize(DMPAPER_LETTER)
oPrinter:SetMargin(10,10,10,10)
oPrinter:nDevice 			:= IMP_PDF
oPrinter:StartPage()

If li >= 60
	li := 0
Endif
//Cabeçalho


CabMailPDF(oPrinter)
//Corpo

LanMailPDF(oPrinter, nConta)
If lPDFEmail
	oPrinter:Preview()
	oPrinter:EndPage()
                                                           
	FreeObj(oPrinter)
	oPrinter := Nil
Else
	oPrinter:EndPage()
EndIF

Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabPDF   ³ Autor ³ Cesar Bautista 				25/03/19  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabecalho em PDF                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabPDF()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CabMailPDF(oPrinter)
Local cCodFunc	:= ""		//-- Codigo da Funcao do funcionario
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario

Local nLi			:= 0

Local cStartPath	:= GetSrvProfString("Startpath","")
Local cNome         := ""
Local cDoc          := fRCC()
Local cFECVAC       := fSRF(SRA->RA_FILIAL,SRA->RA_MAT,IIF(ALLTRIM(DTOS(SRA->RA_DTREC))<>"",DTOS(SRA->RA_DTREC),DTOS(SRA->RA_ADMISSA)))
Local cTeImss		:=""
Local cDesFil  := RTRIM(SM0->M0_FILIAL)
Local cCGC     := RTRIM(SM0->M0_CGC)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

nLi += 6
oPrinter:Box(  nLi, 003, nLi+43, 596, "-4" )			// Caixa da linha 
nLi += 10

oPrinter:SayAlign(nLi+0,004,UPPER ("RECIBO DE PAGO - ")+UPPER(fDesc("SRY", cRoteiro, "RY_DESC", , xFilial("SRY"))),oArial10N,596,005,,2,2)
oPrinter:SayAlign(nLi+8,004,ALLTRIM(cDesFil),oArial10N,596,005, /**/, 2, 2 )
oPrinter:SayAlign(nLi+16,004,ALLTRIM(cCGC),oArial10N,596,005, /**/, 2, 2 )
nLi += 35
oPrinter:Box(  nLi, 003, nLi+80, 596, "-4" )			// Caixa da linha
nLi += 10

cDataBase:=Substr(Dtos(Date()),7,2)+"/"+Substr(Dtos(Date()),5,2)+"/"+Substr(Dtos(Date()),1,4)
ORDEMZ ++
cNome := Alltrim(SRA->RA_PRISOBR) + " " +Alltrim(SRA->RA_SECSOBR) + " " +Alltrim(SRA->RA_PRINOME)+ " " +Alltrim(SRA->RA_SECNOME)
oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" )
nLi += 10
oPrinter:Say(nLi-2,004,Space(1)+UPPER(STR0220)+cPeriodo,oArial07)
oPrinter:Say(nLi-2,004,Space(58)+UPPER(STR0221)+ mv_par04,oArial07)
oPrinter:Say(nLi-2,004,Space(100)+UPPER(STR0222)+DTOC(RCH->RCH_DTINI)+ "-" +DTOC(RCH->RCH_DTFIM),oArial07)
oPrinter:Say(nLi-2,004,Space(185)+UPPER(STR0223)+DTOC(RCH->RCH_DTPAGO),oArial07) 
oPrinter:Say(nLi-2,510,UPPER(STR0224)+StrZero(ORDEMZ,4),oArial08N) // Orden
oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" )
nLi += 10

oPrinter:Say(nLi-2,004,Space(1)+UPPER(GetSX3Cache("RC_FILIAL","X3_TITSPA"))+": "+SRC->RC_FILIAL,oArial07)
oPrinter:Say(nLi-2,004,Space(58)+UPPER(GetSX3Cache("RA_MAT","X3_TITSPA"))+": "+SRA->RA_MAT,oArial07)   
oPrinter:Say(nLi-2,004,Space(100)+UPPER(GetSX3Cache("RA_NOME","X3_TITSPA"))+": "+IIF(!EMPTY(SRA->RA_NOMECMP),UPPER(SRA->RA_NOMECMP),UPPER(SRA->RA_NOME)),oArial07)
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc )
oPrinter:Say(nLi-2,004,Space(185)+UPPER(GetSX3Cache("RA_CODFUNC","X3_TITSPA"))+(STR0219)+SRA->RA_CODFUNC+ space(7)+cDescFunc,oArial07)
oPrinter:Say(nLi-2,004,Space(275)+UPPER(GetSX3Cache("RA_ADMISSA","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_ADMISSA),oArial07)
oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" )
nLi += 10

oPrinter:Say(nLi-2,004,Space(1)+UPPER(GetSX3Cache("RA_CC","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CC) +space(12)+ POSICIONE("CTT",1,XFILIAL("CTT") + SRA->RA_CC,"CTT_DESC01") ,oArial07)    
oPrinter:Say(nLi-2,004,Space(100)+UPPER(GetSX3Cache("RA_DEPTO","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_DEPTO)+ space(12)+POSICIONE("SQB",1,XFILIAL("SQB") + SRA->RA_DEPTO,"QB_DESCRIC"),oArial07)
oPrinter:Say(nLi-2,004,Space(185)+UPPER(GetSX3Cache("RA_CARGO","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CARGO)+ space(12)+POSICIONE("SQ3",1,XFILIAL("SQ3") + SRA->RA_CARGO,"Q3_DESCSUM"),oArial07) 
oPrinter:Say(nLi-2,004,Space(275)+UPPER(GetSX3Cache("RA_HRSMES","X3_TITSPA"))+(STR0219)+TRANSFORM(SRA->RA_HRSMES,"@E 99,999,999.99"),oArial07)
oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" ) 
nLi += 10

oPrinter:Say(nLi-2,004,Space(1)+UPPER(GetSX3Cache("RA_TPCIC","X3_TITSPA"))+SRA->RA_TPCIC,oArial07) 
oPrinter:Say(nLi-2,004,Space(58)+UPPER(GetSX3Cache("RA_CIC","X3_TITSPA"))+SRA->RA_CIC,oArial07)

nAux01:= fPosTab("S023",SRA->RA_TIPCOT, "=", 4) 
IF  nAux01>0
	cTipCot := fTabela("S023",nAux01,5)
endif  

oPrinter:Say(nLi-2,004,Space(100)+UPPER(GetSX3Cache("RA_TIPCOT","X3_TITSPA"))+cTipCot,oArial07)
oPrinter:Say(nLi-2,004,Space(185)+UPPER(GetSX3Cache("RA_REGISTR","X3_TITSPA"))+(STR0219)+SRA->RA_REGISTR,oArial07)

If(SRA->RA_TEIMSS=="1")
	cTeImss= ' Supervisores'
EndIf	

If(SRA->RA_TEIMSS=="2")
	cTeImss= ' Empleados'
EndIf		

If(SRA->RA_TEIMSS=="3")
	cTeImss= ' Obreros'
EndIf	

If(SRA->RA_TEIMSS=="4")
	cTeImss= ' Menores'
EndIf	
oPrinter:Say(nLi-2,004,Space(275)+UPPER(GetSX3Cache("RA_TEIMSS","X3_TITSPA"))+cTeImss,oArial07)

oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" ) 
nLi += 10

oPrinter:Say(nLi-2,004,Space(1)+UPPER(GetSX3Cache("RA_CODRPAT","X3_TITSPA"))+(STR0219)+SRA->RA_RG,oArial07)
oPrinter:Say(nLi-2,004,Space(58)+UPPER(GetSX3Cache("RA_RG","X3_TITSPA"))+(STR0219)+SRA->RA_CODRPAT,oArial07)

cPluriEmp := IIF(SRA->RA_INSSSC=="1","Si","No")

oPrinter:Say(nLi-2,004,Space(100)+UPPER(GetSX3Cache("RA_INSSSC","X3_TITSPA"))+(STR0219)+cPluriEmp,oArial07)

If (SRA->RA_JUBILAC=="0")
	cJubilac="No Aplica"
Else
	cJubilac= IIf (SRA->RA_JUBILAC=="1"," Jubilado Vejez"," Jubilado Invalidez")
EndIf

oPrinter:Say(nLi-2,004,Space(185)+UPPER(GetSX3Cache("RA_JUBILAC","X3_TITSPA"))+cJubilac,oArial07)  
oPrinter:Say(nLi-2,004,Space(275)+UPPER(GetSX3Cache("RA_OPCAO","X3_TITSPA"))+(STR0219)+ DTOC(SRA->RA_OPCAO),oArial07) 
oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" ) 
nLi += 10

oPrinter:Say(nLi-2,004,Space(1)+UPPER(GetSX3Cache("RA_BCDEPSA","X3_TITSPA"))+(STR0219)+SRA->RA_BCDEPSA,oArial07)
oPrinter:Say(nLi-2,004,Space(58)+UPPER(STR0225)+POSICIONE("SA6",1,XFILIAL("SA6")+SUBSTR(SRA->RA_BCDEPSA,1,3)+SUBSTR(SRA->RA_BCDEPSA,4,5),"A6_NREDUZ"),oArial07)  
oPrinter:Say(nLi-2,004,Space(110)+UPPER(GetSX3Cache("RA_BCOHAB","X3_TITSPA"))+(STR0219)+SRA->RA_BCOHAB,oArial07)
oPrinter:Say(nLi-2,004,Space(185)+UPPER(STR0225)+POSICIONE("SA6",1,XFILIAL("SA6")+SUBSTR(SRA->RA_BCOHAB,1,3)+SUBSTR(SRA->RA_BCOHAB,4,5),"A6_NREDUZ"),oArial07)  
oPrinter:Say(nLi-2,004,Space(275)+UPPER(GetSX3Cache("RA_CTDEPSA","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_CTDEPSA),oArial07)
oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" ) 
nLi += 10

oPrinter:Say(nLi-2,004,Space(1)+UPPER(GetSX3Cache("RA_SALMES","X3_TITSPA"))+(STR0232)+TRANSFORM(SRA->RA_SALMES,"@E 999,999,999.99"),oArial07) 
oPrinter:Say(nLi-2,004,Space(61)+UPPER(GetSX3Cache("RA_SALDIA","X3_TITSPA"))+(STR0232)+TRANSFORM(SRA->RA_SALDIA,"@E 999,999,999.99"),oArial07)
oPrinter:Say(nLi-2,004,Space(115)+UPPER(GetSX3Cache("RA_MOEDAPG","X3_TITSPA"))+(STR0219)+Alltrim(SRA->RA_MOEDAPG)+ space(2)+POSICIONE("CTO",1,XFILIAL("CTO")+SRA->RA_MOEDAPG,"CTO_DESC"),oArial07) 
oPrinter:Say(nLi-2,004,Space(185)+UPPER(GetSX3Cache("RA_DTREC","X3_TITSPA"))+ DTOC(SRA->RA_DTREC),oArial07)


If SRA->RA_SITFOLH == "D"
	oPrinter:Say(nLi-2,004,Space(230)+UPPER(GetSX3Cache("Fecha Salida:"))+(STR0219)+ DTOC(SRA->RA_DEMISSA),oArial07)
	nAux01:= fPosTab("S005",SRA->RA_TIPOFIN ,"=", 4)
	IF  nAux01>0
		cDemissa := fTabela("S005",nAux01,5)
	Endif
	oPrinter:Say(nLi-2,004,Space(275)+UPPER(GetSX3Cache("RA_TIPOFIN","X3_TITSPA"))+(STR0219)+cDemissa,oArial07) 
EndIf
nLi += 2

oPrinter:Box(  nLi, 003, nLi+25, 596, "-4" )			// Caixa da linha
nLi += 10

oPrinter:Say(nLi-2,004,Space(30)+UPPER(STR0226),oArial08N)//P R O V E N T O S
oPrinter:Say(nLi-2,004,Space(120)+UPPER(STR0227),oArial08N)//D E S C O N T O S
oPrinter:Say(nLi-2,004,Space(235)+UPPER(STR0228),oArial08N)//B A S E S
oPrinter:Line(nLi+1, 004, nLi+1, 596,005, "-4" ) 
nLi += 15

oPrinter:Say(nLi-2,004,Space(2)+(STR0229),oArial07)//REMUNERACIONES
oPrinter:Say(nLi-2,004,Space(54)+(STR0230),oArial07)//REMUNERACIONES
oPrinter:Say(nLi-2,004,Space(85)+(STR0231),oArial07)//REMUNERACIONES
oPrinter:Say(nLi-2,004,Space(140)+(STR0229),oArial07)//APORTACIONES Y DESCUENTO
oPrinter:Say(nLi-2,004,Space(200)+"PAGO",oArial07)//APORTACIONES Y DESCUENTO
oPrinter:Say(nLi-2,004,Space(240)+(STR0229),oArial07)//APORTACIONES DEL EMPLEADOR
oPrinter:Say(nLi-2,004,Space(277)+(STR0230),oArial07)//APORTACIONES DEL EMPLEADOR
oPrinter:Say(nLi-2,004,Space(310)+(STR0231),oArial07)//APORTACIONES DEL EMPLEADOR

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³LanMailPDF  ³ Autor ³ Cesar Bautista             ³25/03/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) PDF                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ LanMailPDF()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function LanMailPDF(oPrinter, nConta)   // Impressao dos Lancamentos

Local nTermina  	:= 0
Local nCont    	:= 0
Local nValidos  	:= 0
Local aPos     	:= {}
Local nPosFCab	:= 155 
Local nLi			:= nPosFCab
Local cPict4 := ""
Local cPrisobr := ""
Local cSecsobr := ""
Local cPrinome := ""
Local cSecnome := ""
Local cTipoId  :=""
Local cNumId   :=""
Local nAux01   :=0	

  cPict3 := "@E 99,999,999.99"
  cPict4 := "@E 999,999,999.99"
  aPos := {003,006,200,204,392,396,596}  

	nTermina := Max(Max(LEN(aProve),LEN(aDesco)),LEN(aBases))
	
	oPrinter:Box(  nLi+3, aPos[1], nLi+520, aPos[7], "-4" )
	oPrinter:Box(  nLi+3, 110, nLi+520, 142, "-4" )
	
	oPrinter:Box(  nLi+3, aPos[3], nLi+520, aPos[5], "-4" )
	oPrinter:Box(  nLi+3, aPos[3]+136, nLi+520, aPos[5], "-4" )
	oPrinter:Box(  nLi+3, aPos[5]+100, nLi+520, aPos[5]+136, "-4" )	
	
	For nCont := 1 To nTermina
		
		//Quebrar pagina
		// somente imprime CONTINUA e quebra o recibo em dois se houver mais verbas a serem impressas
		If nValidos == 50 .and. nTermina > nValidos
			nLi += 20
			oPrinter:Box(  nLi+5, aPos[1], nLi+40, aPos[7], "-4" )
			nLi += 20		
			oPrinter:SayAlign(nLi-5,aPos[1],STR0030,oFont3,aPos[7],005, /**/, ALIGN_H_CENTER, ALIGN_V_CENTER ) // "CONTINUA !!!"
			nLi += 20
			
			oPrinter:EndPage()
			oPrinter:StartPage()
			
	
			ORDEMZ --
			CabMailPDF(oPrinter)
			nValidos := 0
			
			If nLi >= 614
				nLi := nPosFCab   //Posição final do cabeçalho fCabPDF()
			Endif	
			
			
			oPrinter:Box(  nLi+3, aPos[1], nLi+520, aPos[7], "-4" )
			oPrinter:Box(  nLi+3, 110, nLi+520, 142, "-4" )
		
			oPrinter:Box(  nLi+3, aPos[3], nLi+520, aPos[5], "-4" )
			oPrinter:Box(  nLi+3, aPos[3]+136, nLi+520, aPos[5], "-4" )
			oPrinter:Box(  nLi+3, aPos[5]+100, nLi+520, aPos[5]+136, "-4" )	
					
		EndIf
	 
	 	nLi += 10	
		//Imprime Proventos
		IF nCont <= LEN(aProve)	
			oPrinter:SayAlign(nLi,aPos[2],aProve[nCont,1],oArial08,195,005,,ALIGN_H_LEFT)
			oPrinter:SayAlign(nLi,aPos[2],TRANSFORM(aProve[nCont,2],'999.99'),oFont08,130,005,,ALIGN_H_RIGHT)
			oPrinter:SayAlign(nLi,aPos[2],TRANSFORM(aProve[nCont,3] , cPict3 ),oFont08,192,005,,ALIGN_H_RIGHT)                                 
		ENDIF
		//Imprime Descontos
		IF nCont <= LEN(aDesco)
			oPrinter:SayAlign(nLi,aPos[4],aDesco[nCont,1],oArial08,390,005,,ALIGN_H_LEFT)
		
			oPrinter:SayAlign(nLi,aPos[4],TRANSFORM(aDesco[nCont,3] , cPict3 ),oFont08,188,005,,ALIGN_H_RIGHT)
		ENDIF
		//Imprime Base
		IF nCont <= LEN(aBases)
			If cBaseAux = "S" 
				oPrinter:SayAlign(nLi,aPos[6],aBases[nCont,1],oArial08,390,005,,ALIGN_H_LEFT)
				oPrinter:SayAlign(nLi,aPos[6],TRANSFORM(aBases[nCont,2],'999.99'),oFont08,128,005,,ALIGN_H_RIGHT)
				oPrinter:SayAlign(nLi,aPos[6],TRANSFORM(aBases[nCont,3] , cPict3 ),oFont08,194,005,,ALIGN_H_RIGHT)
			TOTBAS += aBases[nCont,3]
			EndIf
		ENDIF	
		
		//---- Soma 1 nos nValidos e Linha
		nValidos ++	
	Next nCont
	
	//Quando o total de verbas não atinge o total máximo, seta nlin para começar o cabeçalho.
	nLi	+= (52 - nValidos) * 10
	
	oPrinter:Box(  nLi, aPos[1], nLi+25, aPos[3], "-4" )
	oPrinter:Box(  nLi, 142    , nLi+25, aPos[3], "-4" )

	oPrinter:Box(  nLi, aPos[3]    , nLi+25, aPos[5], "-4" )
	oPrinter:Box(  nLi, aPos[3]+136, nLi+25, aPos[5], "-4" )
	oPrinter:Box(  nLi, aPos[5], nLi+25, aPos[7], "-4" )
	nLi += 20
  	
	oPrinter:SayAlign(nLi-10,aPos[2],Space(2)+UPPER("TOTAL HABERES:"),oArial08,196,005, , 0, 1 ) 
	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+UPPER(STR0066),oArial08,196,005, , 0, 1 )     //" TOTAL DESCONTOS     "
	//oPrinter:SayAlign(nLi-10,aPos[6],Space(2)+UPPER("TOTAL BASES:"),oArial08,196,005, , 0, 1 )     //" TOTAL DESCONTOS     "

	
    oPrinter:SayAlign(nLi-10,aPos[2],TRANSFORM( TOTVENC , cPict3 ),oFont08,192,005, ,1,1)  
	oPrinter:SayAlign(nLi-10,aPos[4],TRANSFORM( TOTDESC , cPict3 ),oFont08,188,005, , 1, 1 )   //"| TOTAL BRUTO    "
	//oPrinter:SayAlign(nLi-10,aPos[6],TRANSFORM(TOTBAS   , cPict4 ),oFont08,194,005, , 1, 1 )     //" TOTAL DESCONTOS     "


	
	oPrinter:Box(  nLi+3, aPos[1], nLi+25, aPos[3], "-4" )
	oPrinter:Box(  nLi+3, aPos[3], nLi+25, aPos[5], "-4" )
	
	oPrinter:Box(  nLi+3, aPos[3]+136, nLi+25, aPos[5], "-4" )
	oPrinter:Box(  nLi+3, aPos[5], nLi+25, aPos[7], "-4" )
		
	nLi += 20

	oPrinter:SayAlign(nLi-10,aPos[4],Space(2)+UPPER("NETO RECIBIDO: "),oArial08,196,005, , 0, 1 )   //"| LIQUIDO A RECEBER     "
	oPrinter:SayAlign(nLi-10,aPos[4],TRANSFORM(TOTVENC-TOTDESC , cPict3 ),oFont08,188,005, , 1, 1 )   //"| LIQUIDO A RECEBER     "
	

	
	//oPrinter:SayAlign(nLi-10,aPos[6],Space(2)+UPPER(STR0040)+ Space(2)+SRA->RA_CTDEPSA,oArial08,196,005, , 0, 1 )   //"| CONTA:"
		
	oPrinter:Box(  nLi+3, aPos[1], nLi+50, aPos[7], "-4" )
	nLi += 40
	oPrinter:SayAlign(nLi-30,004,UPPER(fQuery(Mensag1)),oArial08,200,005, , , 0 )//"| Recebi o valor acima em ___/___/___ "
	oPrinter:SayAlign(nLi-20,004,UPPER(fQuery(Mensag2)),oArial08,596,005,,,0)
	oPrinter:SayAlign(nLi-10,004,UPPER(fQuery(Mensag3)),oArial08,596,005,,,0)
	
	oPrinter:SayAlign(nLi-20,205,"REPRESENTANTE LEGAL",oArial08,596,005,,,0)
	nAux01:=fPosTab("S006",SM0->M0_CGC,"=",6)
	If nAux01>0
	   cTipoID  := RTRIM(fTabela("S006",nAux01,9))
	   cNumID   := RTRIM(fTabela("S006",nAux01,10))
	   cPrisobr := RTRIM(fTabela("S006",nAux01,11))
	   cSecsobr := RTRIM(fTabela("S006",nAux01,12))
	   cPrinome := RTRIM(fTabela("S006",nAux01,13))
	   cSecnome := RTRIM(fTabela("S006",nAux01,14))
	EndIf		
	
	oPrinter:SayAlign(nLi-10,195,UPPER( RTRIM(cPrinome) + " "+ RTRIM(cSecnome)+ " " + RTRIM(cPrisobr)+" "+ RTRIM(cSecsobr))+" "+cTipoId+" "+cNumId,oArial08,596,005,,,0)	
	//oPrinter:Line(nLi-15,250,nLi-15,450,,"-4")

	oPrinter:SayAlign(nLi-20,400,"RECIBI EL VALOR ANTERIOR EL   "+ DTOC(RCH->RCH_DTPAGO),oArial08,596,005,,,0)
	oPrinter:SayAlign(nLi-10,400,"EMPLEADO",oArial08,596,005,,,0)
	oPrinter:SayAlign(nLi-0,400,UPPER( RTRIM(SRA->RA_PRINOME) + " "+ RTRIM(SRA->RA_SECNOME)+ " " + RTRIM(SRA->RA_PRISOBR)+" "+ RTRIM(SRA->RA_SECSOBR))+" "+SRA->RA_TPCIC+" "+SRA->RA_CIC,oArial08,596,005,,,0)
    
	
	oPrinter:EndPage()
	
	cPict3 := "@E 99,999,999.99"  // Restauro o valor original de cPict3, declarado na funcao R030Imp.
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fEnvPDFEmail³ Autor ³ Cesar Pera         ³ Data ³25/03/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Prepara o envio do email com o PDF Anexado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fEnvPDFEmail()

Local nI			:= 0
Local cSubject	:= "STR0196"		//" Demosntrativo de Pagamento "
Local cMsg			:= ""
Local cPathFile	:= "" 
Local cMsgErr1	:= ""	//Erro envio
Local cMsgErr2	:= ""	//Sem email cadastrado
Local cMsgErr3	:= ""	//Opção não envia email habilitada

Private cEmailDP		:= NIL
Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL
	
	// Busca parametros 
	cMailConta	:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer	:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
	cMailSenha	:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	cEmailDP	:=If(cEmailDP == NIL,GETMV("MV_GPEMAIL"),cEmailDP)					//Email do responsável de Depto Pessoal
	
	// Verifica se existe o SMTP Server 
	lVal:= .t.
	If 	Empty(cMailServer)
		Help("El servidor SMTP no esta cnfigurado ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		lVal:= .f.
	EndIf
	
	// Verifica se existe a CONTA 
	If 	Empty(cMailConta)
		Help("La cuenta de e-mail no esta configurada ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		lVal:= .f.
	EndIf
	
	// Verifica se existe a Senha
	If 	Empty(cMailSenha)
		Help("La contraseña del email no esta configurada ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		lVal:= .f.
	EndIf
	if !lVal
		Return (.F.)
	endif
	For nI := 1 To Len(aEmail)
		cPathFile	:= "spool\"+aEmail[nI,2]+aEmail[nI,3]+aEmail[nI,4]+aEmail[nI,5]+"RecPag"

		If aEmail[nI,1,3]
			If ! Empty(AllTrim(aEmail[nI,1,2]))
				cSubject	:= "STR0196" + " - " + MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)
				
				cMsg := STR0193+chr(13)+ "  " + aEmail[nI,1,1]+","+chr(10)	//"Sr.(a)"  
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += "STR0194"+" "+MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)+chr(13)+chr(10) //"Segue em anexo o seu demonstrativo referente a:" Maio/2015
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += "STR0195"+chr(13)+chr(10)  //"Atenciosamente,"				
				
				// Envia e-mail p/funcionario 
				If !GPEMail(cSubject,cMsg,aEmail[nI,1,2],{cPathFile+".pdf"})
					//Falha no envio
					cMsgErr1	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
				EndIf				
			Else
				//Sem Email cadastrado
				cMsgErr2	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
			EndIf
		Else
			//Marcado para não receber o email
			cMsgErr3	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
		EndIf
		
		If File(cPathFile+".pdf")
			fErase(cPathFile+".pdf")
		EndIf
		
		If File(cPathFile+".rel")
			fErase(cPathFile+".rel")
		EndIf
	Next nI
	
	If ! Empty(cEmailDP)
		If ! Empty(cMsgErr1) .OR. ! Empty(cMsgErr2)  .OR. ! Empty(cMsgErr2)
			cSubject	:= "STR0201" //"Erros ocorridos durante o envio dos demonstrativos de pagamento"	
			cMsg := STR0193+"," + chr(13) + chr(10)	//"Sr.(a)"  
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			cMsg += "STR0197" + chr(13) + chr(10) //"Ocorreram alguns erros durante o envio de demonstrativo de pagamento por email, veja a relação abaixo:
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			If ! Empty(cMsgErr1)
				cMsg += "- "+ "STR0198" +chr(13)+chr(10)	//- Erro durante o envio da mensagem				
				cMsg += cMsgErr1 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr2)
				cMsg += "- "+ "STR0199" +chr(13)+chr(10)	//- Falta de endereço de email cadastrado para o envio:
				cMsg += cMsgErr2 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr3)
				cMsg += "- "+ STR0200 +chr(13)+chr(10)	//- Marcado a opção de não receber email no caastro do funcionário:
				cMsg += cMsgErr3 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			cMsg += "STR0195"+chr(13)+chr(10)  //"Atenciosamente,"
			
			GPEMail(cSubject,cMsg,cEmailDP)
		EndIf
	EndIf 
Return Nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ limpArqPdf  ³ Autor ³ Cesar Perea  	    ³ Data ³25/03/2019³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpar os arquivos PDF que são gerados pelo schedule       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function limpArqPdf()
Local cPath	:= "\spool\"
	AEVAL(DIRECTORY(cPath+"*RecPag.pdf"), { |aFile| FERASE(cPath+aFile[1]) })	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fQuery() ³ Autor ³ Cristian Franco       ³ Data ³ 10.02.20  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Muestra los mensajes de los parametros                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±             
±±³Sintaxe   ³ fQuery()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fQuery(cMsg)
Local cQuery   := ''
Local cAliasRCC := GetNextAlias()
Local cConteudo := ''

cQuery  += "SELECT "
	If 	AllTrim(Upper(TCGetDB())) $ "MSSQL"
		cQuery  +=  "SUBSTRING(RCC_CONTEU,2,30) CAMPO"
	Else
		cQuery  +=  "SUBSTR(RCC_CONTEU,2,30) CAMPO"
	EndIf
cQuery  += " FROM " + RetSqlName( 'RCC' )
cQuery  += " WHERE RCC_CODIGO='S001' "
cQuery  += " AND D_E_L_E_T_=' ' "
cQuery  += " AND RCC_FILIAL = '" + xFilial("RCC") + "' "	
If !Empty(cMsg)		
	If 	AllTrim(Upper(TCGetDB())) $ "MSSQL"
		cQuery  += " AND  SUBSTRING(RCC_CONTEU,01,1)  = '"+cMsg+"' "
		cQuery  += " AND  SUBSTRING(RCC_CONTEU,32,5) = '"+cProcesso+"' "
		cQuery  += " AND  SUBSTRING(RCC_CONTEU,37,3) = '"+cRoteiro+"' "
		cQuery  += " AND  SUBSTRING(RCC_CONTEU,40,6) = '"+cPeriodo+"' "
		cQuery  += " AND  SUBSTRING(RCC_CONTEU,46,2) = '"+Semana+"' "
	Else
		cQuery  += " AND  SUBSTR(RCC_CONTEU,01,1) = '"+cMsg+"' "
		cQuery  += " AND  SUBSTR(RCC_CONTEU,32,5) = '"+cProcesso+"' "
		cQuery  += " AND  SUBSTR(RCC_CONTEU,37,3) = '"+cRoteiro+"' "
		cQuery  += " AND  SUBSTR(RCC_CONTEU,40,6) = '"+cPeriodo+"' "
		cQuery  += " AND  SUBSTR(RCC_CONTEU,46,2) = '"+Semana+"' "
	EndIf	
EndIf

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery), cAliasRCC, .T., .T.)
dbSelectArea( cAliasRCC)


While (cAliasRCC)->(!EOF())
	cConteudo := (cAliasRCC)->CAMPO
	(cAliasRCC)->(dbSkip())	
EndDo
(cAliasRCC)->(dbCloseArea())

return (cConteudo)
