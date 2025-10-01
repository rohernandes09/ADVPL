#INCLUDE "ctbr171U.ch"
#Include "PROTHEUS.Ch"

// 17/08/2009 -- Filial com mais de 2 caracteres

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR171 ³ Autor ³ Paulo Augusto          ³ Data ³ 17.10.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Livro de Inventario e Balanco             	 		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR171()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR171U()

Local aSetOfBook
Local aCtbMoeda	 := {}
LOCAL cDesc 	 := OemToAnsi(STR0001)	 //"Este programa ira imprimir o Livro de Inventario e Balancos."
LOCAL wnrel
LOCAL cString	 := "CT1"
Local titulo 	 := OemToAnsi(STR0002) 	 //"Livro de Inventario e Balancete"
Local lRet		 := .T.

PRIVATE Tamanho	 :="G"
PRIVATE nLastKey := 0
PRIVATE cPerg	 := "CTR171"
PRIVATE aReturn  := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha	 := {}
PRIVATE nomeProg := "CTBR171"

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li 	  := 80
m_pag := 1

Pergunte("CTR171",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						³
//³ mv_par01			// Data Inicial                  		³
//³ mv_par02			// Data Final                        	³
//³ mv_par03			// Conta Inicial                        ³
//³ mv_par04			// Conta Final  						³
//³ mv_par05			// Imprime Contas: Sintet/Analit/Ambas  ³
//³ mv_par06			// Set Of Books				    		³
//³ mv_par07			// Saldos Zerados?			     		³
//³ mv_par08			// Moeda?          			     		³	
//³ mv_par09			// Pagina Inicial  		     		    ³
//³ mv_par10			// Saldos? Reais / Orcados	/Gerenciais ³
//³ mv_par11			// Filtra Segmento?					    		³
//³ mv_par12			// Conteudo Inicial Segmento?		   		³
//³ mv_par13			// Conteudo Final Segmento?		    		³
//³ mv_par14			// Conteudo Contido em?				    		³
//³ mv_par15			// Imprimir Codigo? Normal / Reduzido  	³
//³ mv_par16			// Divide por ?                   			³
//³ mv_par17			// Imprimir Ate o segmento?			   	³
//³ mv_par18			// Posicao Ant. L/P? Sim / Nao         	³
//³ mv_par19			// Data Lucros/Perdas?         				³
//³ mv_par20			// Ramo da Empresa?         					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel	:= "CTBR171"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc,,,.F.,"",,Tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ct171Valid(mv_par06)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(mv_par06)
Endif

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par08)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If !lRet
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR171Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR171IMP ³ Autor ³ Paulo Augusto         ³ Data ³ 17.10.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Livro de Inventario e balanco         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ CTR171Imp(lEnd,wnRel,cString,aSetOfBook,aCtbMoeda)		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpA1   - Matriz ref. Config. Relatorio                    ³±±
±±³          ³ ExpA2   - Matriz ref. a moeda                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR171Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)

LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 220
Local cabec1   		:= STR0005 //" |  CODIGO DA CONTA                                   |   D  E  S  C  R  I  C  A  O               |   SALDO ANTERIOR    |  DEBITO PERIODO  |  CREDITO PERIODO  |   SALDO DEVEDOR   |   SALDO CREDOR    |  SALDO ACUMULADO  |"
Local cabec2   		:= " "                                                                                                                                            
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local lFirstPage	:= .T.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cSegAte   	:= mv_par17
Local nDigitAte		:= 0
Local dDataFim 		:= mv_par02
Local lImpRes		:= Iif(mv_par15 == 1,.F.,.T.)	
Local lImpAntLP		:= Iif(mv_par18 == 1,.T.,.F.)
Local dDataLP		:= mv_par19
Local l132			:= .F.
Local nDivide		:= mv_par16
Local lImpSint		:= Iif(mv_par05=1 .Or. mv_par05 ==3,.T.,.F.)
Local lVlrZerado	:= Iif(mv_par07==1,.T.,.F.)
Local n    
Local nSalDeb		:=0
Local nSaldo		:=0
Local nSalCrd		:=0
Local nSalAcum 		:=0
Local nSalAnt 		:=0
Local aCustomText:={}
Local nTam:= 220
Local cDescCGC:= ""
Local aAreaAtual:= GetArea()
Local aAreaSx3:=Sx3->(GetArea())

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("A2_CGC")
cDescCGC:= Alltrim(X3Titulo()) + " :"
SX3->(RestArea(aAreaSx3))
RestArea(aAreaAtual)
cDescMoeda 	:= aCtbMoeda[2]
nDecimais 	:= DecimalCTB(aSetOfBook,mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo:=	STR0006 //"Livro de Inventario e Balanco "


Titulo += 	DTOC(mv_par01) + OemToAnsi(STR0007) + Dtoc(mv_par02) + ; //" ATE "
				OemToAnsi(STR0008) + cDescMoeda //" EM "

If mv_par10 > "1"
	Titulo += " (" + Tabela("SL", mv_par10, .F.) + ")"
EndIf
  
m_pag := mv_par09
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao					     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
				CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				mv_par01,mv_par02,"CT7","",mv_par03,mv_par04,,,,,,,mv_par08,;
				mv_par10,aSetOfBook,mv_par11,mv_par12,mv_par13,mv_par14,;
				l132,.T.,,,lImpAntLP,dDataLP, nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7])},;				
				OemToAnsi(OemToAnsi(STR0009)),;   //"Criando Arquivo Tempor rio..."
				OemToAnsi(STR0002))  			 //"Livro de Inventario e Balancete"

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	nDigitAte := CtbRelDig(cSegAte,cMascara) 	
EndIf		

dbSelectArea("cArqTmp")
//dbSetOrder(1)
dbGoTop()

SetRegua(RecCount())

cGrupo := GRUPO

While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi(STR0010)    //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf mv_par05 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf
	
	If mv_par07 == 2						// Saldos Zerados nao serao impressos
		If (Abs(SALDOANT)+Abs(SALDOATU)+Abs(SALDODEB)+Abs(SALDOCRD)) == 0
			dbSkip()
			Loop
		EndIf
	EndIf

	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
		
	************************* ROTINA DE IMPRESSAO *************************

	IF li > 58 
		
		If SM0->(Eof())
			SM0->(MsSeek(cEmpAnt+cFilAnt,.T.))
		Endif                                                      
		aCustomText:={	"__LOGOEMP__",;
	  	Pad("SIGA /"+NomeProg+"/v."+cVersao ,nTam)+  padl(RptHora+" "+time() +"  " + RptEmiss+ " " + Dtoc(dDataBase),ntam),; 
   	 	" ",Left(Pad(STR0011 + AllTrim(SM0->M0_NOMECOM),nTam),nTam-Len(RptFolha+" "+ TRANSFORM(m_pag,'999999')+ "  "))+; //"Razao Social: "
	  	RptFolha+" "+ TRANSFORM(m_pag,'999999')+ "  ",;
   	 Alltrim(cDescCGC) + Transform(Alltrim(SM0->M0_CGC),alltrim(SX3->X3_PICTURE)) ,; //"RUT: "
		STR0013 + mv_par20 , STR0014 + AllTrim(SM0->M0_ENDCOB), Padc(AllTrim(Titulo),nTam) } //"Ramo: "###"Direcao:"
        Cabec(Titulo,Cabec1,cabec2,nomeprog,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),;
		GetMv("MV_NORM")), aCustomText )

	End

	@ li,000 PSAY "|"
	If lImpRes .And. cArqTmp->TIPOCONTA == '2'	//Se imprime codigo reduzido da conta e a conta eh analititca	
		EntidadeCTB(CTARES,li,02,51,.F.,cMascara,cSeparador)
	Else	//Se Imprime Cod. Normal ou eh sintetica.
		EntidadeCTB(CONTA,li,02,51,.F.,cMascara,cSeparador)
	Endif
	@ li,054 PSAY "|"
	@ li,056 PSAY Substr(DESCCTA,1,40)
	@ li,098 PSAY "|"
	
	ValorCTB(SALDOANT,li,100,17,nDecimais,.T.,cPicture,TIPOCONTA)
	@ li,119 PSAY "|"
	ValorCTB(SALDODEB,li,120,17,nDecimais,.F.,cPicture,TIPOCONTA)
	@ li,139 PSAY "|"
	ValorCTB(SALDOCRD,li,140,17,nDecimais,.F.,cPicture,TIPOCONTA)
	@ li,159 PSAY "|"
	nSaldo:=  SALDOCRD - SALDODEB
	
	If nSaldo <0 
		ValorCTB(nSaldo,li,160,17,nDecimais,.F.,cPicture,TIPOCONTA)
		@ li,179 PSAY "|"
		ValorCTB(0,li,180,17,nDecimais,.F.,cPicture,TIPOCONTA)
		
	
	Elseif nSaldo > 0
		ValorCTB(0,li,160,17,nDecimais,.F.,cPicture,TIPOCONTA)
		@ li,179 PSAY "|"
		ValorCTB(nSaldo,li,180,17,nDecimais,.F.,cPicture,TIPOCONTA)
		
	Else
		ValorCTB(0,li,160,17,nDecimais,.F.,cPicture,TIPOCONTA)
		@ li,179 PSAY "|"
		ValorCTB(0,li,180,17,nDecimais,.F.,cPicture,TIPOCONTA)
	
	EndIf	
	
	@ li,199 PSAY "|"
	ValorCTB(SALDOATU,li,200,17,nDecimais,.T.,cPicture,TIPOCONTA)
	@li,220 PSAY "|"	
	
	li++

	************************* FIM   DA  IMPRESSAO *************************

	If mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"
			If NIVEL1              
			    nSalAcum +=SALDOATU
				nSalAnt += SALDOANT
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
				nSalDeb+= Iif(nSaldo <0 ,nSaldo,0)
			    nSalCrd+=Iif(nSaldo >0 ,nSaldo,0)

			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
			    nSalAcum +=SALDOATU
				nSalAnt += SALDOANT
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD 
				nSalDeb+= Iif(nSaldo <0 ,nSaldo,0)
			    nSalCrd+=Iif(nSaldo >0 ,nSaldo,0) 
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
				EndIf
			EndIf
		Endif	    	
	EndIf

	dbSkip()
EndDO

IF li != 80 .And. !lEnd
	
	@li,000 PSAY REPLICATE("-",limite)
	li++
	@li,000 PSAY "|"
	@li,060 PSAY OemToAnsi(STR0015)  		 //"T O T A I S  D O  P E R I O D O:"
	@li,098 PSAY "|"
	ValorCTB(nSalant,li,100,17,nDecimais,.T.,cPicture)
	@li,119 PSAY "|"
	ValorCTB(nTotDeb,li,120,17,nDecimais,.F.,cPicture)
	@li,139 PSAY "|"
	ValorCTB(nTotCrd,li,140,17,nDecimais,.F.,cPicture)			
	@li,159 PSAY "|"
	ValorCTB(nSalDeb,li,160,17,nDecimais,.F.,cPicture)
	@li,179 PSAY "|"
	ValorCTB(nSalCrd,li,180,17,nDecimais,.F.,cPicture)
	@li,199 PSAY "|"
	ValorCTB(nSalAcum,li,200,17,nDecimais,.T.,cPicture)
	@li,220 PSAY "|"
	li++
	@li,000 PSAY REPLICATE("-",limite)
	li++
	@li,000 PSAY " "
	roda(cbcont,cbtxt,"M")
	Set Filter To
EndIF

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CT171Valid³ Autor ³ Paulo Augusto         ³ Data ³ 17.10.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Perguntas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ct171Valid(cSetOfBook)                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Expc1 = Codigo do Set of Book                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ct171Valid(cSetOfBook)
Local aSaveArea:= GetArea()
Local lRet		:= .T.	

If !Empty(cSetOfBook)
	dbSelectArea("CTN")
	dbSetOrder(1)
	If !dbSeek(xfilial()+cSetOfBook)
		aSetOfBook := ("","",0,"","")
		Help(" ",1,"NOSETOF")
		lRet := .F.
	EndIf
EndIf
	
RestArea(aSaveArea)

Return lRet
