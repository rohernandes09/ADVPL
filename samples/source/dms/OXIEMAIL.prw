// …ÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕÕª
// ∫ Versao ∫  4     ∫
// »ÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕÕº

#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥OXIEMAIL     ≥ Autor ≥ Thiago             ≥ Data ≥ 15/06/11 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Envia E-mail do orcamento.						          ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
User Function OXIEMAIL()
Local nRecSM0 := SM0->(Recno())
Local lOk := .f., lSendOK := .f.
Local cError := ""
Local nCount := 0   
Private cEmail   := ""
Private cCliente := ""    
Private cAssunto := ""
Private cMensagem := ""
SetPrvt("cTamanho,Limite,aOrdem,cTitulo,nLastKey,aReturn,cTitulo")
SetPrvt("cTamanho,cNomProg,cNomeRel,nLastKey,Limite,aOrdem,cAlias")
SetPrvt("cDesc1,cDesc2,cDesc3,lHabil,nOpca,nTipo,aPosGru,Inclui")
SetPrvt("cMarca,cObserv")
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+VS1->VS1_CLIFAT+VS1->VS1_LOJA)
cCliente := SA1->A1_NOME
cEmail := SA1->A1_EMAIL+space(30)
cAssunto := "Orcamento "+VS1->VS1_NUMORC+space(15)   
cMarca   := "   "


DEFINE MSDIALOG oDlg1 FROM 000,000 TO 015,040 TITLE "Envio de Email" OF oMainWnd

@ 012,006 SAY   "Cliente"  SIZE 50,08 OF oDlg1 PIXEL COLOR CLR_BLUE
@ 012,050 MSGET oCliente  VAR cCliente  PICTURE "@!" SIZE 100,08 OF oDlg1 PIXEL when .f.
@ 026,006 SAY   "Enviar para:"  SIZE 100,08 OF oDlg1 PIXEL COLOR CLR_BLUE
@ 026,050 MSGET oEmail  VAR cEmail  PICTURE "@!" SIZE 100,08 OF oDlg1 PIXEL
@ 039,006 SAY   "Assunto:"  SIZE 100,08 OF oDlg1 PIXEL COLOR CLR_BLUE
@ 039,050 MSGET oAssunto  VAR cAssunto  PICTURE "@!" SIZE 100,08 OF oDlg1 PIXEL
@ 052,006 SAY   "Mensagem:"  SIZE 100,08 OF oDlg1 PIXEL COLOR CLR_BLUE
@ 052,050 GET oMensagem VAR cMensagem OF oDlg1 MEMO SIZE 100,041 PIXEL
@ 100,067 BUTTON oOK PROMPT OemToAnsi(" <<< Enviar >>> ") OF oDlg1 SIZE 55,10 PIXEL  ACTION (FS_ENVIAR()) 

ACTIVATE MSDIALOG oDlg1 CENTER //ON INIT EnchoiceBar(oDlg, {|| if(FS_OK(),(oDlg:End(),nOpca := 1),.f.) } , {|| oDlg:End(),nOpca := 2})

Return(.t.)           

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥FS_ENVIAR    ≥ Autor ≥ Thiago             ≥ Data ≥ 15/09/11 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao ≥ Envia E-mail 									          ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function FS_ENVIAR()
//Local nRecSM0 := SM0->(Recno())
Local lOk := .f., lSendOK := .f.
Local cError := ""
//Local nCount := 0
Local cMailConta := GETMV("MV_EMCONTA") // Usuario/e-mail de envio
Local cMailServer:= GETMV("MV_RELSERV") // Server de envio
Local cMailSenha := GETMV("MV_EMSENHA") // Senha e-mail de envio
Local lAutentica := GetMv("MV_RELAUTH",,.f.)          // Determina se o Servidor de E-mail necessita de Autenticacao
Local cUserAut   := Alltrim(GetMv("MV_RELAUSR",," ")) // Usuario para Autenticacao no Servidor de E-mail
Local cPassAut   := Alltrim(GetMv("MV_RELAPSW",," ")) // Senha para Autenticacao no Servidor de E-mail
Private cTitulo  := cAssunto 
Private cMsg := ""
cPerg := "ORCAMT"
ValidPerg()
cNomeEmp := SM0->M0_NOMECOM
cEndeEmp := SM0->M0_ENDENT
cNomeCid := "  Cidade: " + SM0->M0_CIDENT
cEstaEmp := SM0->M0_ESTENT
cCep_Emp := SM0->M0_CEPENT
cFoneEmp := "  -  FONE: " + SM0->M0_TEL
cFax_Emp := "FAX:  " + SM0->M0_FAX
cCNPJEmp := transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
cInscEmp := SM0->M0_INSC
cCodMun  := SM0->M0_CODMUN
Pergunte(cPerg,.f.)

setprc(0,0)
lin := 1
cCompac := "CHR(15)"
cNormal := "CHR(18)"
Pag := 1       
cOrdem  := mv_par01
nTotPec  := nTotSer  := 0
nTotCAI  := 0       
cMarca   := VS1->VS1_CODMAR

nUltKil := 0

if VS1->VS1_KILOME != 0
	nUltKil := VS1->VS1_KILOME
else
	nUltKil := FG_UltKil(VV1->VV1_CHAINT)
endif        

If !Empty(cEmail)
	// Cabecalho
	cMsg+= "<table border=0 width=80%><tr>"
	If !Empty( GetNewPar("MV_ENDLOGO","") )
		cMsg+= "<td width=20%><img src='" + GetNewPar("MV_ENDLOGO","") + "'></td>"
	EndIf
	cMsg+= "<td align=center width=80%><font size=3 face='verdana,arial' Color=#0000cc><b>"
	cMsg+= SM0->M0_NOMECOM+"<br></font></b><font size=1 face='verdana,arial' Color=black>"
	cMsg+= SM0->M0_ENDENT+"<br>"
	cMsg+= SM0->M0_CIDENT+" - "+SM0->M0_ESTENT+"<br>"
	cMsg+= "Fone"+": "+SM0->M0_TEL+"</font></td></tr></table><hr width=80%>" // Fone
	cMsg+= "<font size=1 face='verdana,arial' Color=black><b>"+cMensagem+"<br><br></font><font size=3 face='verdana,arial' Color=black><b>"+cTitulo+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+&cCompac+"<br><br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([=],132)+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"ORCAMENTO No. "+VS1->VS1_NUMORC+"                           PECAS e SERVICOS                     Emissao: " + DtoC(dDataBase) + "  Hora: " + time()  + "   Pag: " + StrZero(Pag,5)+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([=],132)+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Emitente: " + cNomeEmp + " - CNPJ " + cCNPJEmp + " - IE " + CInscEmp+cFoneEmp+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Endereco: " + cEndeEmp+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>CEP " + transform(cCep_Emp,"@R 99999-999") +  "   -   " + cNomeCid + " - " + cEstaEmp +"  -  "+cFax_Emp+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([-],132)+"<br></font>"
	SA3->(DbSetOrder(1))
	SA3->(dbgotop())
	SA3->(DbSeek(xFilial("SA3")+VS1->VS1_CODVEN))
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Data do Orcamento....: " + DTOC(VS1->VS1_DATORC)+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Validade do Orcamento.: " + DTOC(VS1->VS1_DATVAL) +"     Tipo de Tempo..:"+VS1->VS1_TIPTEM+" - "+VOI->VOI_DESTTE+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Vendedor: " + VS1->VS1_CODVEN + " - " + left(SA3->A3_NREDUZ,15)+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Validade do Orcamento.: " + DTOC(VS1->VS1_DATVAL) + "            Vendedor: " + VS1->VS1_CODVEN + " - " + left(SA3->A3_NREDUZ,15)+"<br><br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([-],132)+"<br><br></font>"
	cCGCCPF1  := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
	cCGCPro   := cCGCCPF1 + space(18-len(cCGCCPF1))
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Cliente.: " + VS1->VS1_CLIFAT + " - " + left(SA1->A1_NOME,40) + "   CNPJ/CPF: " + cCGCPro+"<br><br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Endereco: " + left(SA1->A1_END,40)+"</font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+" Cidade : " + SA1->A1_MUN+ " - " +SA1->A1_EST+"<br></font>"
	VAM->( DbSeek( xFilial("VAM") + SA1->A1_IBGE ) )
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Telefone: (" + VAM->VAM_DDD + ") " + Alltrim(SA1->A1_TEL)+"</font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Fax: (" + VAM->VAM_DDD + ") " + Alltrim(SA1->A1_FAX)+"<br></font>"
	
	if VS1->VS1_TIPORC == "2"
		cCombus := Padr(X3CBOXDESC("VV1_COMVEI",VV1->VV1_COMVEI),15," ")
		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+ repl([-],132)+"<br></font>"
		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Dados do Veiculo - Chassi: " + VV1->VV1_CHASSI + "                  Placa: " + VV1->VV1_PLAVEI + "      Cor: " + VV1->VV1_CORVEI + " - " + VVC->VVC_DESCRI+"<br></font>"
		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>                   Modelo: " + left(VV1->VV1_MODVEI,20) + "-" + left(VV2->VV2_DESMOD,15) + "       Fab/Mod: " + left(VV1->VV1_FABMOD,4)+"/"+right(VV1->VV1_FABMOD,4) + "     Km: " + strzero(nUltKil,8) + "  Comb: " + cCombus +"<br></font>"
    Endif
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([-],132)+"<br><br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Atendendo solicitacao de V.Sa.(s), temos a satisfacao de fornecer a relacao de pecas e servicos necessarios"+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"para o veiculo acima especificado. Estimativa de orcamento sujeito a alteracao apos desmontagem."+"<br><br></font>"
	// Detalhes
	FS_DETALHE()
	FS_RODAPE()
	cMsg+= "</b>"

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥Envia e-mail do Evento 003                                              ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ  
	If !Empty(cMailConta) .And. !Empty(cMailServer) .And. !Empty(cMailSenha)
		// Conecta uma vez com o servidor de e-mails
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
		If lOk
			lOk := .f.
			If lAutentica
				If !MailAuth(cUserAut,cPassAut)
					MsgStop("Erro no envio de e-mail","Atencao") // Erro no envio de e-mail / Atencao
					DISCONNECT SMTP SERVER
				Else
					lOk := .t.
				EndIf
			Else
				lOk := .t.
			EndIf
			If lOk
				// Envia e-mail com os dados necessarios
				SEND MAIL FROM cMailConta to Alltrim(cEmail) SUBJECT (cTitulo) BODY cMsg FORMAT TEXT RESULT lSendOk
				If !lSendOk
					//Erro no Envio do e-mail
					GET MAIL ERROR cError
					MsgStop(cError,"Erro no envio de e-mail") // Erro no envio de e-mail
				EndIf
				// Desconecta com o servidor de e-mails
				DISCONNECT SMTP SERVER
			EndIf
		Else
			MsgStop(OemToAnsi("Nao foi possivel conectar no servidor de e-mail"+" "+chr(13)+chr(10)+cMailServer),"AtenÁ„o") // Nao foi possivel conectar no servidor de e-mail / Atencao
		EndIf
	EndIf 
	
	
Else          
   MsgInfo("Email deve ser informado!")
   Return(.f.)
EndIf      

oDlg1:End()     

Return(.t.)

Static Function FS_DETALHE()

Local bCampo := { |nCPO| Field(nCPO) }
Local i := 0
CCusMed := 1
nSemEstoque := 0
nMenEstoque := 0
cSeqSer := mv_par03
cTpoPad := if(mv_par02==1,"S","N")

SetPrvt("nSubTot,cGrupo,aStru,cTipSer,nSaldo")

nSubtot := 0
nTotDesS := nTotDesP := 0
nTotGSer := 0
nTGSer   := 0

if VS1->VS1_TIPORC == "2"
	
	aStru := {}
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("VS4")
	Do While !Eof() .And. x3_arquivo == "VS4"
		if x3_context # "V"
			Aadd(aStru,{x3_campo,x3_tipo,x3_tamanho,x3_decimal})
		Endif
		DbSkip()
	EndDo
	
	oObjTempTable := OFDMSTempTable():New()
	oObjTempTable:cAlias := "TRB"
	oObjTempTable:aVetCampos := aStru
	If cSeqSer == 2
		oObjTempTable:AddIndex(, {"VS4_FILIAL","VS4_NUMORC","VS4_TIPSER","VS4_GRUSER","VS4_CODSER"} )
	Else
		oObjTempTable:AddIndex(, {"VS4_FILIAL","VS4_NUMORC","VS4_SEQUEN"} )
	EndIf
	oObjTempTable:CreateTable(.f.)
	
	DbSelectArea("VS4")
	DbSeek(xFilial("VS4")+VS1->VS1_NUMORC)
	Do While !Eof() .and. VS4->VS4_NUMORC == VS1->VS1_NUMORC .and. VS4->VS4_FILIAL == xFilial("VS4")
		DbSelectArea("TRB")
		RecLock("TRB",.T.)
		For i := 1 to FCOUNT()
			cCpo := aStru[i,1]
			TRB->&(cCpo) := VS4->&(cCpo)
		Next
		MsUnlock()
		DbSelectArea("VS4")
		DbSkip()
	EndDo
	
	DbSelectArea("TRB")
	DbGotop()
	
Endif

//Pecas

DbSelectArea("VS3")
DbGotop()
DbSetOrder(1)
if cOrdem == 2
	DbSetOrder(2)
Endif

if DbSeek(xFilial("VS3")+VS1->VS1_NUMORC)  


	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+&cCompac+" "+"<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>******** PECAS ********<br></font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([=],132)+"<br></font><pre>"
	cMsg+= "<table witdh='800' border=1>"
	If cCusMed = 2
		cMsg+= "<tr><td></font><font size=1 face='verdana,arial' Color=black><b>"+"Seq </td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Grup</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+If(MV_PAR05#1," Codigo"+space(23),space(29))+"</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Descricao</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Local</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Qtde</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Vl Unitar</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>%Desct</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Vl Descto</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Valor Total</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Custo Med<br></font></td></tr>"
	else
    	cMsg+= "<tr><td></font><font size=1 face='verdana,arial' Color=black><b>"+"Seq </td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Grup</td>"
		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+If(MV_PAR05#1," Codigo"+space(23),space(29))+"</td>"
    	cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Descricao</td>"
    	cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Local</td>"
    	cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Qtde</td>"
    	cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Vl Unitar</td>"
    	cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>%Desct</td>"
    	cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Vl Descto</td>"
    	cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Valor Total"+"<br></font></td></tr>"
	endif
////////	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([=],132)+"<br></font>"
	
	DbSelectArea("SB1")
	DbSetOrder(7)
	DbSelectArea("SB5")
	DbSelectArea("VS3")
	
	cGrupo := VS3->VS3_GRUITE
	nSeq	 := 0
	
	cGrp    := VS3->VS3_GRUITE
	nQtdIte := 0
	nPerDes := 0
	nTotDes := 0
	nTotGer := 0
	aVetCai := {}
	Do While !EOF() .and. VS3->VS3_NUMORC == VS1->VS1_NUMORC .AND. VS3->VS3_FILIAL == xFilial("VS3")
		
		DbSelectArea("SB1")
		DbGotop()
		DbSeek(xFilial("SB1")+VS3->VS3_GRUITE+VS3->VS3_CODITE)
		
		DbSelectArea("SB5")
		DbGotop()
		DbSeek(xFilial("SB5")+SB1->B1_COD)
		
		DbSelectArea("SBM")
		DbGotop()
		DbSeek(xFilial("SBM")+VS3->VS3_GRUITE)
		
		DbSelectArea("SB2")
		DbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
		nSaldo := SaldoSB2()
		
		DbSelectArea("VS3")
		
		if cOrdem == 2
			if cGrp <> VS3->VS3_GRUITE
				cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Total "+cGrp+"........................................................:"+"</font>"
				cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nQtdIte,"@E 99999")+"</font>"
				cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nPerDes,"999.99")+"</font>"
				cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nTotDes,"@E 99,999.99")+"</font>"
				cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nTotGer,"@E 9999,999.99")+"<br><br></font>"
				nQtdIte := 0
				nPerDes := 0
				nTotDes := 0
				nTotGer := 0
			Endif
		Endif
		nSeq++
		cMsg+= "<tr><td></font><font size=1 face='verdana,arial' Color=black><b>"+strzero(nSeq,3)+"</td><td width='10'></font><font size=1 face='verdana,arial' Color=black><b>"+" "+VS3->VS3_GRUITE+"</font></td>"
		If MV_PAR05 # 1
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+VS3->VS3_CODITE+"</font></td>"
		EndIf    
   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+left(SB1->B1_DESC,25)+"</font></td>"
   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+" "+Alltrim(FM_PRODSBZ(SB1->B1_COD,"SB5->B5_LOCALI2"))+"</font></td>"

   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(VS3->VS3_QTDITE,"@E 99999")+"</font></td>"
		if nSaldo <= 0
			nSemEstoque++
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+"**"+"</font></td>"
		elseif nSaldo < VS3->VS3_QTDITE
			nMenEstoque++
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+"*"+"</font></td>"
		Endif
   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(VS3->VS3_VALPEC,"@E 99999,999.99")+"</font></td>"

   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(VS3->VS3_PERDES,"999.99")+"</font></td>"

   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(VS3->VS3_VALDES,"@E 99,999.99")+"</font></td>"

   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(VS3->VS3_VALTOT,"@E 9999,999.99")+"</font></td>"
		
		If cCusMed = 2
	   		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(SB2->B2_CM1,"@E 99,999.99")+"</font></td></tr>"
		Else        
//	  		cMsg+= "<td><br></td></tr>"
		endif

		nTotPec  := nTotPec  + VS3->VS3_VALTOT
		nTotCAI  := nTotCAI  + VS3->VS3_VALTOT
		nTotDesP := nTotDesP + VS3->VS3_VALDES
		
		if cOrdem == 2
			nSubTot := nSubTot + VS3->VS3_VALTOT
		Endif
		
		nQtdIte += VS3->VS3_QTDITE
		nPerDes += VS3->VS3_PERDES
		nTotDes += VS3->VS3_VALDES
		nTotGer += VS3->VS3_VALTOT
		cGrp    := VS3->VS3_GRUITE

		DbSelectArea("VS3")
		DbSkip()
		
	EndDo 
	cMsg += "</table>"
	if mv_par01 == 1	
		asort(aVetCai,,,{|x,y| x[15] < y[15]})
	elseif mv_par01 == 2
		asort(aVetCai,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
	else
		asort(aVetCai,,,{|x,y| x[3]+x[1]+x[2] < y[3]+y[1]+y[2]})
	endif
	cCai := ""
	
	if cOrdem == 2
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Total "+cGrp+"........................................................:"+"</font>"
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nQtdIte,"@E 99999")+"</font>"
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nPerDes,"999.99")+"</font>"
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nTotDes,"@E 99,999.99")+"</font>"
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nTotGer,"@E 9999,999.99")+"<br></font>"
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([-],132)+"<br></font>"
	EndIf
	
	
	if nTotDesP > 0
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Desconto em Pecas.....:"+"</font>"
   		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nTotDesP,"@E 9999,999.99")+"<br></font>"
	endif
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Subtotal de Pecas........:"+"</font>"
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nTotPec,"@E 9999,999.99")+"<br><br></font></pre>"
	
Endif

//Servicos

aTipoSer := {}
aVetSer  := {}
if VS1->VS1_TIPORC == "2" //.and. TRB->(DbSeek(xFilial("TRB")+VS1->VS1_NUMORC))
	
	DbSelectArea("TRB")
	DbGotop()
	if reccount() > 0
		
		
		cMsg+= "</font><table width='250' border=1><font size=1 face='verdana,arial' Color=black><b>"+&cCompac+" "+"<br></font>"
		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"******** SERVICOS ********"+"<br></font>"
//		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([=],132)+"<br></font><pre>"
		
		if cTpoPad == "N"
    		cMsg+= "<tr><td></font><font size=1 face='verdana,arial' Color=black><b>"+"Grupo</td>"
    		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+If(MV_PAR05#1," Codigo                      ",Space(29))+"</td>"
    		cMsg+= "<td width = '100'></font><font size=1 face='verdana,arial' Color=black><b>Descricao                      </td>"
    		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Tipo        </td>"
    		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Vlr Servico </td>"
    		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>%Desct </td>"
    		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Valor Descto  </td>"
    		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Tot Servico</td>"
    		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b><br></font></td></tr>"
		Else
     		cMsg+= "<tr><td></font><font size=1 face='verdana,arial' Color=black><b>"+"Grupo"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>"+If(MV_PAR05#1," Codigo                      ",Space(29))+"</td>"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Descricao                      </td>"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Tipo </td>"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>TpPad  </td>"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Vlr Servico </td>"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>%Desct </td>"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Valor Descto  </td>"
     		cMsg+= "<td></font><font size=1 face='verdana,arial' Color=black><b>Tot Servico<br></font></td></tr>"
		Endif
//		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([=],132)+"<br></font>"
		
		DbSelectArea("SB1")
		DbSetOrder(7)
		DbSelectArea("TRB")
		
		nSubTot := 0
		cTipSer := TRB->VS4_TIPSER
		Do While !EOF() .and. TRB->VS4_NUMORC == VS1->VS1_NUMORC
			
			DbSelectArea("VO6")
			DbSetOrder(2)
			DbGotop()
			DbSeek(xFilial("VO6")+FG_MARSRV(cMarca,TRB->VS4_CODSER)+TRB->VS4_CODSER)
			
			DbSelectArea("VOK")
			DbSetOrder(1)
			DbGotop()
			DbSeek(xFilial("VS4")+TRB->VS4_TIPSER)
			
			DbSelectArea("VOS")
			DbSetOrder(1)
			DbSeek(xFilial("VOS")+cMarca+TRB->VS4_GRUSER)
			
			DbSelectArea("TRB")
			
			cMsg+= "<tr><td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+TRB->VS4_GRUSER+"</font></td>"
			cMsg+= "<td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+TRB->VS4_CODSER+"</font></td>"
			cMsg+= "<td width='100'></font><font size=1 face='verdana,arial' Color=black><b>"+VO6->VO6_DESSER+"</font></td>"
			cMsg+= "<td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+TRB->VS4_TIPSER+"</font></td>"
			if cTpoPad == "S"
				cMsg+= "<td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(TRB->VS4_TEMPAD,"@R 99:99")+"</font></td>"
			Endif
			cMsg+= "<td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(TRB->VS4_VALSER,"@E 999,999.99")+"</font></td>"
			cMsg+= "<td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(TRB->VS4_PERDES,"999.99")+"</font></td>"
			cMsg+= "<td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(TRB->VS4_VALDES,"@E 9,999,999.99")+"</font></td>"
			cMsg+= "<td width='30'></font><font size=1 face='verdana,arial' Color=black><b>"+Transform(TRB->VS4_VALTOT,"@E 9999,999.99")+"<br><br></font></td></tr>"
			
			nTotSer  := nTotSer  + TRB->VS4_VALTOT
			nTotDesS := nTotDesS + TRB->VS4_VALDES
			
			if cSeqSer == 2
				nSubTot := nSubTot + TRB->VS4_VALTOT
			Endif

			DbSelectArea("TRB")
			DbSkip()
			
		EndDo
		asort(aVetSer,,,{|x,y| x[1]+x[2] < y[1]+y[2]})
		cSer := ""

		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+repl([-],132)+"<br></font></table>"
		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Subtotal de Servicos.....:"+"</font>"
		cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+Transform(nTotSer,"@E 9999,999.99")+"<br><br><br></font></pre>"
	endif
Endif

if VS1->VS1_TIPORC == "2"
	
	DbSelectArea("TRB")
	oObjTempTable:CloseTable()
endif

if nSemEstoque > 0
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"OBS: OS ITENS ASSINALADOS COM '**' AO LADO DA QUANTIDADE ESTAO COM SALDO ZERO NO MOMENTO "+"</font>"
Endif

if nMenEstoque > 0
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"OBS: OS ITENS ASSINALADOS COM '* ' AO LADO DA QUANTIDADE ESTAO INSUFICIENTES NO MOMENTO"+"</font>"
Endif

cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+&cCompac+" "+"<br><br></font>"

Return


////////////////////
Static Function FS_RODAPE()

cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+"Observacao:"+"</font>"
cKeyAce := VS1->VS1_OBSMEM + [001]

DbSelectArea("SYP")
DbSetOrder(1)
FG_SEEK("SYP","cKeyAce",1,.f.)

do while xFilial("SYP")+VS1->VS1_OBSMEM == SYP->YP_FILIAL+SYP->YP_CHAVE .and. !eof()
	
	nPos := AT("\13\10",SYP->YP_TEXTO)
	if nPos > 0
		nPos-=1
	Else
		nPos := Len(SYP->YP_TEXTO)
	Endif
	cObserv := Substr(SYP->YP_TEXTO,1,nPos)
	
	cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>"+cObserv+"<br><br><br></font>"
	SYP->(DbSkip())
	
enddo

nTotal := nTotPec + nTotSer

// Daniele - 27/09/2006 - Inclusao do numero da Ordem de Servico
cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Ordem de Servico: " + VS1->VS1_NUMOSV+"<br><br></font>"

cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>*****  T O T A I S  *****<br></font>"

cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Pecas....: " + Transform(nTotPec,"@E 999,999,999.99")+"<br></font>"
cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Servicos.: " + Transform(nTotSer,"@E 999,999,999.99")+"<br></font>"
cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Orcamento: " + Transform(nTotal,"@E 999,999,999.99") + "    Cond.Pagto.: " + VS1->VS1_FORPAG + "-" + SE4->E4_DESCRI+"<br><br></font>"

cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>A U T O R I Z O ( A M O S )   O   F A T U R A M E N T O   D E S T E   O R C A M E N T O .<br><br></font>"
cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Local:________________________________________, Data:________/__________________/________<br><br></font>"
cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>CARIMBO<br><br><br></font>"
cMsg+= "</font><font size=1 face='verdana,arial' Color=black><b>Ass.:_________________________________________<br></font>"


Return


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫FunáÑo    ≥VALIDPERG ∫ Autor ≥ AP5 IDE            ∫ Data ≥  13/07/01   ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function ValidPerg

local _sAlias := Alias()
local aRegs := {}
local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := left(cPerg+space(15),len(X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Ordem Seq/Codigo","",""   ,"mv_ch1","N",1,0,0,"C","","mv_par1","Sequencia","","","","","Codigo","","","","","CAI (Scania)","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Imprime Tempo Padrao","","","mv_ch2","N",1,0,0,"C","","mv_par2","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Ordem Seq/Tipo Serv","","","mv_ch3","N",1,0,0,"C","","mv_par3","Sequencia","","","","","Tipo de Servico","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Imprime Custo Medio","","","mv_ch4","N",1,0,0,"C","","mv_par4","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Imprime Cod do Item","","","mv_ch5","N",1,0,0,"C","","mv_par5","Nao","","","","","Sim","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
