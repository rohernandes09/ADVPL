#INCLUDE "CERTRMUN.CH"      
#INCLUDE "Protheus.ch"      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CERTRMUN  ºAutor  ³Ana Paula Nascimentoº Data ³ 25/05/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Certificado de Retencion Municipal                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPROGRAMADOR³ DATA   ³ BOPS    ³  MOTIVO DA ALTERACAO                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRaul Ortiz ³30/03/17³MMI-4938 ³Se incorpora funcionalidad para la Ley  º±±
±±º           ³        ³         ³General de Sociedades                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CERTRMUN()

Local aCertImp  := PARAMIXB[1]
Local cCodAss   := PARAMIXB[2]
Local lIncPa    := PARAMIXB[3]
Local aNfs	:= {}
Local cChave
Local cTitulo	:= STR0001
Local oPrint  
Local aDados := {}      
Local lExiste := .F.
Local nValRet := 0 
Local nTotRet := 0  
Local aRets := {}   
Local nX := 0
Local cImposto:=aCertImp[2] 
Local nValMerc := 0
Local nValImp := 0  
Local cFornece:=""
Local cLoja:=""
Local dEmisCert
Local cCert := ""
Local cAliq:= ""
Local cNumOp:= ""
Local cDescCon := ""
Local cConceito := ""
Local nValOP := 0
Local nBsImpo:= 0
Local nRetMes := 0
Local nRetAnt:= 0
Local cTitCabec1 := ""
Local cTitCabec2 := ""
Local cTitCabec3 := ""
Local aOP := {}
Local nI, nJ
Local cTipo := ""
Local cMunicip := ""

Default lIncPa := .F.

oPrint	:= TMSPrinter():New( cTitulo )
oPrint:SetPortrait() //Retrato
//oPrint:SetLandscape() //Paisagem


DbSelectArea("SFE")
DbSetOrder(9)
DbSeek(xFilial("SFE")+aCertImp[1]+aCertImp[2])
cFornece:=SFE->FE_FORNECE
cLoja:=SFE->FE_LOJA
dEmisCert:=SFE->FE_EMISSAO 
cNumOp:= SFE->FE_ORDPAGO
nAliq:= SFE->FE_ALIQ  
cCert := SFE->FE_NROCERT 

SX5->(DbSeek(xFilial()+"12"+SFE->FE_EST))
cJurid:=Alltrim(X5Descri())
	
While SFE->(!EOF() ).and. (xFilial("SFE")+aCertImp[1]+aCertImp[2]) ==(SFE->FE_FILIAL+SFE->FE_NROCERT+SFE->FE_TIPO)
	If cFornece == SFE->FE_FORNECE .AND. cLoja == SFE->FE_LOJA
		nTotRet += SFE->FE_RETENC 
		Aadd(aRets,{SFE->FE_NFISCAL,SFE->FE_SERIE,SFE->FE_RETENC, SFE->FE_PARCELA, "", 0, 0})	
		Aadd(aOP , {SFE->FE_ALIQ, SFE->FE_RETENC, ""})
	Endif
	SFE->(DBSKIP())
EndDo    


DbSelectArea("SEK")
DbSetOrder(1)
DbSeek(xFilial("SEK")+cNumOp)
While SEK->(!EOF() ) .AND. (xFilial("SEK")+ cNumOp + cFornece+cLoja) == (SEK->EK_FILIAL+SEK->EK_ORDPAGO+SEK->EK_FORNECE+SEK->EK_LOJA)
	If SEK->EK_TIPODOC == "CP"
		nValOP := SEK->EK_VALOR 
	ElseIF 	SEK->EK_TIPODOC $ "TB|PA"	
       nPos:=AScan(aRets,{|x| x[1]== SEK->EK_NUM .And. x[2]==SEK->EK_PREFIXO .And. x[4]==SEK->EK_PARCELA})

       If nPos > 0	       
	       aRets[nPos][5] := SEK->EK_TIPO	
	   ElseIf SEK->EK_TIPODOC $ "PA"  	       
  	       aRets[1][5] := SEK->EK_TIPO	
	   EndIf    
	EndIf
	SEK->(DBSKIP())
EndDo  

If !lIncPa     
	For nX:=1 to Len(aRets)
		If !Empty(aRets[nX][5])
			cTipo := aRets[nX][5]
		Else
			aRets[nX][5] := cTipo	
		EndIf
		IF aRets[nX][5] $ MV_CPNEG+"/"+MVPAGANT
			DbSelectArea("SF2")
			DbSetOrder(1)
			DbSeek(xFilial("SF2")+aRets[nX][1]+aRets[nX][2]+cFornece+cLoja+cTipo)
			nValMerc:= SF2->F2_VALMERC
			nValImp:= SF2->F2_VALIMP1+SF2->F2_VALIMP2+SF2->F2_VALIMP3+SF2->F2_VALIMP4+SF2->F2_VALIMP5	
		Else
			DbSelectArea("SF1")
			DbSetOrder(1)
			DbSeek(xFilial("SF1")+aRets[nX][1]+aRets[nX][2]+cFornece+cLoja+cTipo)
			nValMerc:= SF1->F1_VALMERC
			nValImp:= SF1->F1_VALIMP1+SF1->F1_VALIMP2+SF1->F1_VALIMP3+SF1->F1_VALIMP4+SF1->F1_VALIMP5	
			//nPos:=AScan(aRets,{|x| x[1]== SF1->F1_DOC .And. x[2]==SF1->F1_SERIE .And. x[4]==aRets[nX][4]})
			//if nPos > 0
				//aRets[nPos][6] := nValMerc
				//aRets[nPos][7] := nValImp
			//else
				aRets[nX][6] := nValMerc
				aRets[nX][7] := nValImp
			//endif			
		EndIF
	Next nX
EndIf	

dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial("SA2") + cFornece + cLoja)
	cMunicip := SA2->A2_RET_MUN
	
For nI := 1 To Len(aOP)
	For nJ := 1 To Len(aCertImp[4])
		If aOP[nI][2] == aCertImp[4][nJ][3]  
			SFF->(dbSetOrder(5))
			SFF->(dbSeek(xFilial("SFF") + aCertImp[4][nJ][2] + aCertImp[4][nJ][4]))
			While SFF->(!EOF() ) .AND. SFF->FF_FILIAL+SFF->FF_IMPOSTO+SFF->FF_CFO_C == xFilial("SFF")+ aCertImp[4][nJ][2] + aCertImp[4][nJ][4]
				If SFF->FF_RET_MUN == cMunicip //SA2->A2_RET_MUN 
					aOP[nI][3] := SFF->FF_CONCEPT
					cDescCon := SFF->FF_CONCEPT
				EndIf
				SFF->(dbSkip())
			EndDo  
		EndIf
	Next
	If Empty(aOP[nI][3])
		aOP[nI][3] := cDescCon
	EndIf
Next



PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,nAliq,cCert,nTotRet,nValOP,aRets,cCodAss,cDescCon,cImposto,lIncPa,cJurid, aOP)//, aNfs,cCert,cSerieC )
oPrint:Preview()


Return

Static Function PrintPag( oPrint,cFornece,cLoja,dEmisCert,cNumOp,nAliq,cCert,nTotRet,nValOP,aRets,cCodAss,cDescCon,cImposto,lIncPa,cJurid, aOP)// , aNfs,cCert,cSerieC)


Local oFont1	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)// Fonte o Titulo Negrito
Local oFont2	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)// Fonte do Sub-Titulo
Local oFont3	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)// Fonte o Titulo Negrito
Local oFont4	:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)// Fonte do Sub-Titulo
Local nI
Local cStartPath := GetSrvProfString( "Startpath", "" )
Local nLn := 0
Local nLin := 0
               
SX5->(DbSeek(xFilial()+"12"+SA2->A2_EST))
cProvForn:=Alltrim(X5Descri())

cTitCabec1 := STR0002 + cProvForn
cTitCabec2:= STR0025
cTitCabec3:= STR0003 + cCert

cObserv:=STR0028 + " " + MesExtenso(Month(dEmisCert)) + " "+STR0029 +" "+ Alltrim(Str(Year(dEmisCert)))
SX5->(DbSeek(xFilial()+"12"+SM0->M0_ESTENT))
cProvEmp:=Alltrim(X5Descri())

oPrint:StartPage()

oPrint:Box(0150,0100,0400,2400)  
oPrint:Say(0180,0900,cTitCabec1,oFont1)// Tit. Cabeçalho
oPrint:Say(0230,1100,cTitCabec2,oFont1)// Tit. Cabeçalho
oPrint:Say(0280,0875,cTitCabec3,oFont1)

//oPrint:Say(0180,1840,"Emissão:",oFont1)// Data de emissão 
oPrint:Say(0180,1995,Dtoc(dEmisCert),oFont1)// Data de emissão 

oPrint:box(0400,0100,0650,2400) // Dados do agente retentor

oPrint:Say(0415,0130,STR0004,oFont1)

oPrint:Say(0480,0130,STR0005,oFont2) 
oPrint:Say(0480,0320,transf(SM0->M0_CGC,pesqpict("SA2","A2_CGC")),oFont2)

oPrint:Say(0530,0130,STR0006,oFont2) 
oPrint:Say(0530,0420,SM0->M0_NOMECOM,oFont2)
                                             
oPrint:Say(0580,0130,STR0007,oFont2) 
oPrint:Say(0580,0320,SM0->M0_ENDENT,oFont2)

oPrint:Say(0415,1050,STR0008,oFont2) 
oPrint:Say(0415,1340,cProvEmp,oFont1)

// Dados do Fornecedor

oPrint:box(0650,0100,0940,2400) 

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2") + cFornece+cLoja)  
cNome:=SA2->A2_NOME
cCUITForn:=Transf(SA2->A2_CGC,pesqpict("SA2","A2_CGC")) // Numero CUIT do cliente 
cEnd := SA2->A2_END  
nNumIb := SA2->A2_NROIB

/*
Box(nRow,nCol,nBottom,nRight,oPen)
Desenha uma caixa, utilizando as especificações do objeto TPen
nRow		Linha no qual inicia o desenho da caixa
nCol		Coluna no qual inicia o desenho da caixa
nBottom	Linha no qual finaliza o desenho da caixa
nRight		Coluna no qual finaliza o desenho da caixa
*/
                                            
oPrint:Say(0665,0130,STR0009,oFont1)  
oPrint:Say(0725,0130,STR0010,oFont2)  
oPrint:Say(0725,0350,cNome,oFont2)  

oPrint:Say(0775,0130,STR0011,oFont2)
oPrint:Say(0775,0350,cEnd,oFont2) 

oPrint:Say(0825,0130,STR0012,oFont2) 
oPrint:Say(0825,0350,cProvForn,oFont2) 

oPrint:Say(0880,0130,STR0005,oFont2) 
oPrint:Say(0880,0350,cCUITForn,oFont2) 		


oPrint:Say(0955,0140,STR0014,oFont2) // Ordem de pago
oPrint:box(0940,0100,1020,0450) // Ordem de pago 	

oPrint:Say(0955,0490,STR0015,oFont2) // Tot. Ordem Pago
oPrint:box(0940,0450,1020,0900)// Tot. Ordem Pago
                                    
oPrint:Say(0955,0920,STR0026,oFont2) // Base Imponible
oPrint:box(0940,0900,1020,1190) // Base Imponible	                                    
                                    
oPrint:Say(0955,1220,STR0016,oFont2) // Retençaõ Mes
oPrint:box(0940,1190,1020,1500) // ret mes	                                            

oPrint:Say(0955,1530,STR0017,oFont2) // Diferença de retenção
oPrint:box(0940,1500,1020,2400) // Diferença de retenção                                       
              
nLn := 1020
nLin := 1035
For nI := 1 To Len(aOP)
	oPrint:box(nLn,0100,nLn+90,0450) 
	oPrint:Say(nLin,0120,cNumOp,oFont2) // Ordem de pagp 	
	
	oPrint:box(nLn,0450,nLn+90,0900) 	
	oPrint:Say(nLin,0460,Transform(nValOp, "@E 999,999,999.99"),oFont2) // Ordem de pagp 	
		
	oPrint:box(nLn,0900,nLn+90,1190)                                                            
	oPrint:Say(nLin,0940,Transform(aOP[nI][1], "@E 999.99")+"%",oFont2)  //Conceito			
	
	oPrint:box(nLn,1190,nLn+90,1500) 
	oPrint:Say(nLin,1185,Transform(aOP[nI][2], "@E 999,999,999.99"),oFont2)  //Conceito		
	
	oPrint:box(nLn,1500,nLn+90,2400)  
	oPrint:Say(nLin,1600,SubStr(aOP[nI][3],1,60),oFont2)  //Conceito
	
	nLin += 90
	nLn += 90			
Next                               
oPrint:box(nLn,0100,nLn+90,2400)
oPrint:Say(nLin,0115,STR0027,oFont1) // "Referencia

nLin += 90
nLn += 90

oPrint:Say(nLin,0115,STR0018,oFont2) // Tipo
oPrint:box(nLn,0100,nLn+90,0300)

oPrint:Say(nLin,0315,STR0019,oFont2) // Tipo
oPrint:box(nLn,0300,nLn+90,0950)

oPrint:Say(nLin,0965,STR0020,oFont2) // Tipo
oPrint:box(nLn,0950,nLn+90,1300)            
                                           
oPrint:Say(nLin,1315,STR0021,oFont2) // Tipo
oPrint:box(nLn,1300,nLn+90,1650)

oPrint:Say(nLin,1665,STR0022,oFont2) // Tipo
oPrint:box(nLn,1650,nLn+90,2050)

oPrint:Say(nLin,2065,STR0023,oFont2) // Tipo
oPrint:box(nLn,2050,nLn+90,2400)

nLin += 90
nLn += 90

If !lIncPa
For nI:= 1 To Len(aRets)

	oPrint:box(nLn,0100,nLn+90,0300) // Tipo Doc						
 	oPrint:box(nLn,0300,nLn+90,0950) // numero e serie
 	oPrint:box(nLn,0950,nLn+90,1300)  // emissao
 	oPrint:box(nLn,1300,nLn+90,1650)  //base
 	oPrint:box(nLn,1650,nLn+90,2050) //aliq
 	oPrint:box(nLn,2050,nLn+90,2400)  //percepcao

	oPrint:Say( nLin,0125,aRets[nI,5],oFont2) // Serie
	oPrint:Say( nLin,0315,aRets[nI,2],oFont2) // Numero da nota fiscal 
	oPrint:Say( nLin,0390,aRets[nI,1],oFont2) // Data emissão NF
	oPrint:Say( nLin,1000,aRets[nI,4],oFont2) // Data emissão NF
	oPrint:Say( nLin,1315,Transform(aRets[nI,6],"@E 999,999,999.99"),oFont2)	// aliquota
	oPrint:Say( nLin,1665,Transform(aRets[nI,7], "@E 999,999,999.99"),oFont2) // valor da percepção
	oPrint:Say( nLin,2065,Transform((aRets[nI,3]), "@E 999,999,999.99"),oFont2)   // Total recebido

    nLn += 90
    nLin += 90
Next
EndIf		
	       
oPrint:box(nLn,0100,nLn+200,2400) 
oPrint:Say( nLin+20,125,cObserv,oFont2) 
oPrint:box(nLn+200,0100,nLn+650,2400)  
  
DbSelectArea("FIZ")
DbSetOrder(1)
DbSeek(xFilial("FIZ")+cCodAss)

oPrint:Say( nLin+265,0120,FIZ->FIZ_NOME,oFont2) 
oPrint:Say( nLin+310,0120,FIZ->FIZ_CARGO,oFont2) 		


oPrint:SayBitmap(nLin+290,1600,cStartPath + AllTrim(FIZ->FIZ_BITMAP)+ ".JPG") // imagem da assinatura	

oPrint:Line(nLin+410,1600,nLin+410,2230)
oPrint:Say( nLin+430,1850,STR0024,oFont2)

DbSelectArea("SX6")
DbSetOrder(1)
If SX6->(DbSeek(FWCODFIL()+"MV_FCHINSC"))
	oPrint:Say ( nLin+680, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+680, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )	
ElseIf SX6->(DbSeek(Space(Len(SX6->X6_FIL))+"MV_FCHINSC"))
	oPrint:Say ( nLin+680, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+680, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )	
EndIf
If SX6->(DbSeek(FWCODFIL()+"MV_NROINSC"))
	oPrint:Say ( nLin+705, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+705, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )
ElseIf SX6->(DbSeek(Space(Len(SX6->X6_FIL))+"MV_NROINSC"))
	oPrint:Say ( nLin+705, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+705, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )	
EndIf
If SX6->(DbSeek(FWCODFIL()+"MV_LIBINSC"))
	oPrint:Say ( nLin+730, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+730, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )
ElseIf SX6->(DbSeek(Space(Len(SX6->X6_FIL))+"MV_LIBINSC"))
	oPrint:Say ( nLin+730, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+730, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )		
EndIf
If SX6->(DbSeek(FWCODFIL()+"MV_TOMINSC"))
	oPrint:Say ( nLin+755, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+755, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )
ElseIf SX6->(DbSeek(Space(Len(SX6->X6_FIL))+"MV_TOMINSC"))
	oPrint:Say ( nLin+755, 0120, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+755, 0420, PadR(SX6->X6_CONTSPA,10,""), oFont4 )		
EndIf
If SX6->(DbSeek(FWCODFIL()+"MV_FOLINSC"))
	oPrint:Say ( nLin+680, 0620, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+680, 0920, PadR(SX6->X6_CONTSPA,10,""), oFont4 )
ElseIf SX6->(DbSeek(Space(Len(SX6->X6_FIL))+"MV_FOLINSC"))
	oPrint:Say ( nLin+680, 0620, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+680, 0920, PadR(SX6->X6_CONTSPA,10,""), oFont4 )		
EndIf
If SX6->(DbSeek(FWCODFIL()+"MV_TPSINSC"))
	oPrint:Say ( nLin+705, 0620, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+705, 0920, PadR(SX6->X6_CONTSPA,25,""), oFont4 )	
ElseIf SX6->(DbSeek(Space(Len(SX6->X6_FIL))+"MV_TPSINSC"))
	oPrint:Say ( nLin+705, 0620, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+705, 0920, PadR(SX6->X6_CONTSPA,25,""), oFont4 )	
EndIf
If SX6->(DbSeek(FWCODFIL()+"MV_VARINSC"))
	oPrint:Say ( nLin+730, 0620, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+730, 0920, PadR(SX6->X6_CONTSPA,50,""), oFont4 )	
ElseIf SX6->(DbSeek(Space(Len(SX6->X6_FIL))+"MV_VARINSC"))
	oPrint:Say ( nLin+730, 0620, PadR(SX6->X6_DSCSPA,30,""), oFont3 )
	oPrint:Say ( nLin+730, 0920, PadR(SX6->X6_CONTSPA,50,""), oFont4 )	
EndIf

oPrint:EndPage()			

Return
