#Include "Protheus.ch"
#Include "FWCommand.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ M_CONSPEC³ Autor ³ Thiago                ³ Data ³ 26/10/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Consulta Detalhada de Peças.					 		       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Oficina                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M_CONSPEC(cOrcam)

Local bBkF2
Local bBkF3
Local bBkF4
Local bBkF5
Local bBkF6
Local bBkF7
Local bBkF8
Local bBkF9
Local bBkF10
Local bBkF11
Local bBkF12

Private cCodPro := space(TamSx3("B1_COD")[1])
Private cCodFab := space(TamSx3("B1_CODITE")[1])
//Private cNomFab := space(TamSx3("A2_NREDUZ")[1])
Private cNomFab := space(TamSx3("B1_FABRIC")[1])
//Private cNomencla := space(TamSx3("BM_DESC")[1])
Private cNomencla := space(TamSx3("B1_DESC")[1])
Private cFamilia  := space(TamSx3("X5_DESCRI")[1])
Private cClasse   := space(TamSx3("X5_DESCRI")[1])
Private cSClasse  := space(TamSx3("X5_DESCRI")[1])
Private cModelo   := space(TamSx3("VV2_DESMOD")[1])
Private cAno      := space(4)
Private cMarca    := space(TamSx3("VE1_DESMAR")[1])
Private aKit    := {}
Private cSair     := "0"
Private aItens  := {{.f.,"","","","",0,"0","","",0,0,0}}
Private cFamBkp := ""
Private cFabBkp := ""
Private cCFabBkp:= ""
Private cNomBkp := ""
Private cClaBkp := ""
Private cSClaBkp:= ""
Private cModBkp := ""
Private cMarBkp := ""
Private cAplBkp := ""
Private cCliBkp := ""
Private cVeiBkp := ""
Private cKit      := space(10)
Private nVlrD  := 0
Private nPercD := 0
Private cCliente  := space(TamSx3("A1_NOME")[1])
Private cVeiculo := space(TamSx3("VV1_CHASSI")[1])
Private cGrupo    := space(4)
//Private cAplic    := space(30)
Private nQtdIte := 0
Private cFoco := "0"
Private clistbox := 0
Private cMdaFoco := 0
Private aDescricao := {""}
Private nQtdI := 1
Private cModVei := ""
if Type("cAnoOld") == "U"
	Private cAnoOld := ""
Endif
if Type("cModOld") == "U"
	Private cModOld   := space(TamSx3("VV2_DESMOD")[1])
Endif
if Type("cMarcOld") == "U"
	Private cMarcOld  := space(TamSx3("VE1_DESMAR")[1])
Endif
Default cOrcam  := "0"

if cOrcam == "1"
   if Empty(M->VS1_TIPORC) .or. Empty(M->VS1_CLIFAT)
      MsgStop("Orçamento ainda não digitado , Verifique!")
      Return(.f.)
   Endif
Endif

// Removendo warning de compilacao
If .f.
	FS_EXPORTAR()
	FS_SAIRTELA()
	FS_QUANT()
EndIf

bBkF2  := SetKey(VK_F2 )
bBkF3  := SetKey(VK_F3 )
bBkF4  := SetKey(VK_F4 )
bBkF5  := SetKey(VK_F5 )
bBkF6  := SetKey(VK_F6 )
bBkF7  := SetKey(VK_F7 )
bBkF8  := SetKey(VK_F8 )
bBkF9  := SetKey(VK_F9 )
bBkF10 := SetKey(VK_F10)
bBkF11 := SetKey(VK_F11)
bBkF12 := SetKey(VK_F12)

//SETKEY(VK_F7 ,{|| FS_LIMPATELA() })
//SETKEY(VK_F10,{|| FS_FILTRO(cCodPro,"3",cOrcam) })

FS_CONSULTA("","",cOrcam)

SetKey( VK_F2  , bBkF2  )
SetKey( VK_F3  , bBkF3  )
SetKey( VK_F4  , bBkF4  )
SetKey( VK_F5  , bBkF5  )
SetKey( VK_F6  , bBkF6  )
SetKey( VK_F7  , bBkF7  )
SetKey( VK_F8  , bBkF8  )
SetKey( VK_F9  , bBkF9  )
SetKey( VK_F10 , bBkF10 )
SetKey( VK_F11 , bBkF11 )
SetKey( VK_F12 , bBkF12 )


Return(.t.)

Static Function FS_CONSULTA(cCod,cOpcao,cOrcam)

Local aObjects := {} , aPosObj := {} , aPosObjApon := {} , aInfo := {}//
Local aSizeAut := MsAdvSize(.F.)  // Tamanho Maximo da Janela (.t.=TOOLBAR,.f.=SEM TOOLBAR)
Local nCntFor := 0
Local cX := ""
Private cMsg      := ""
Private cMsg1     := ""
Private cLogoEmpr := GetNewPar("MV_DIRFTGC","") + "ologoconsultapeca.PNG"
Private aPedPen := {{"","","",0,0,0}}
Private cCodbar    := space(TamSx3("B1_CODBAR")[1])
Private nVlrDesc := 0
Private nVlrBrut := 0
Private nVlrLiq := 0
Private nPercDesc := 0
Private cDescPgto   := space(TamSx3("E4_DESCRI")[1])
Private cCond    := space(TamSx3("E4_CODIGO")[1])
Private nListbox := 1
Private o_Verm   := LoadBitmap( GetResources() , "BR_VERMELHO" )
Private o_Verd   := LoadBitmap( GetResources() , "BR_VERDE" )
Private aVetMem  := {{"","","",0,0,0,0,0}}
Private lFecha   := .t.

SetAtalhos(1,cOrcam)
aObjects := {}

AAdd( aObjects, { 000, 65 , .T. , .F. } )//cabecalho
AAdd( aObjects, { 000, 500 , .T. , .T. } )//listbox
AAdd( aObjects, { 000, 070 , .T. , .F. } )//listbox
AAdd( aObjects, { 000, 030 , .T. , .F. } )//listbox

aInfo := {aSizeAut[1] , aSizeAut[2] , aSizeAut[3] , aSizeAut[4] , 2 , 2 }
aPos  := MsObjSize (aInfo, aObjects,.F.)

nVlrDesc := 0
nVlrLiq := 0
nPercDesc := 0
DEFINE MSDIALOG oDlg1 TITLE "Consulta Detalhada de Peças" From aSizeAut[7],000 TO aSizeAut[6],aSizeAut[5] of oMainWnd PIXEL STYLE DS_MODALFRAME
oDlg1:lEscClose := .F.

// Bitmap do Logotipo
If File(cLogoEmpr)
	TBitmap():New( 003 , 003 , 300 ,  080 ,,cLogoEmpr,.T.,oDlg1,,,.T.,.F.,,,.F.,,.T.,,.F.)
EndIf


@ aPos[2,1],aPos[2,2]  LISTBOX oLbitem FIELDS HEADER "","Cód.Produto","Cód.Fabricante","Nome Fabricante","%Desconto","Vlr Desconto","Vlr Líquido","Aplicação" COLSIZES 20,40,35,60,40,40,40,250 SIZE aPos[2,4]-2,aPos[2,3]-aPos[2,1] OF Odlg1 PIXEL ;
	ON CHANGE (FS_LIMPAVLR(aItens[oLbitem:nAt,02],oLbitem:nAt)) .AND. (  FS_VALLIN(aItens[oLbitem:nAt,02],"2")) ;
	ON DBLCLICK (FS_TELADES());
	VALID MUDACPO()

oLbitem:SetArray(aItens)
oLbitem:bLine := { || { IIf(aItens[oLbitem:nAt,01],o_Verd,o_Verm),;
						aItens[oLbitem:nAt,02],;
						aItens[oLbitem:nAt,03],;
						aItens[oLbitem:nAt,04],;
 						transform(aItens[oLbitem:nAt,10],"@E 999.99")+"%",;
 						transform(aItens[oLbitem:nAt,11],"@E 999,999,999.99"),;
 						transform(aItens[oLbitem:nAt,12],"@E 999,999,999.99"),;
 						aItens[oLbitem:nAt,5]}}
 						
oLbitem:bGotFocus   := {|| nListbox := 1,FS_FILPREC(oLbitem:nAt,"1",aItens[oLbitem:nAt,02])}

//		@ aPos[2,1],aPos[2,4]-50 MSGET oX VAR cX SIZE 65,8 OF oDlg1 PIXEL COLOR CLR_BLUE
//		oX:bGotFocus   := {|| oVlrDesc:Setfocus()}

@ aPos[1,1],(aPos[1,4]/2)+52 TO aPos[1,1]+066,aPos[1,4] LABEL ("Descontos") OF oDlg1 PIXEL // Cor: Linha 1

@ aPos[1,1]+11,(aPos[1,4]/2)+55 SAY "Condição Pagamento: " OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+11,(aPos[1,4]/2)+110 MSGET oCond VAR cCond VALID FS_CONDPGTO(cCond) F3 "SE4" PICTURE "@!" SIZE 40,8 OF oDlg1 PIXEL COLOR CLR_BLUE

@ aPos[1,1]+11,(aPos[1,4]/2)+177 SAY cDescPgto OF oDlg1   PIXEL COLOR CLR_BLUE

@ aPos[1,1]+23,(aPos[1,4]/2)+55 SAY "Valor Bruto: " OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+23,(aPos[1,4]/2)+110 MSGET oVlrBrut VAR nVlrBrut PICTURE "@E 999,999.99" SIZE 65,8 OF oDlg1 PIXEL COLOR CLR_BLUE When .f.

@ aPos[1,1]+35,(aPos[1,4]/2)+55 SAY "Valor de Desconto: " OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+35,(aPos[1,4]/2)+110 MSGET oVlrDesc VAR nVlrDesc VALID if(clistbox==1,FS_VALLIN(aItens[oLbitem:nAt,02],"1"),FS_VALLIN(aPedPen[oLbox1:nAt,01],"1")) .and. FS_GRADES("1") PICTURE "@E 999,999.99" SIZE 65,8 OF oDlg1 PIXEL COLOR CLR_BLUE

//@ aPos[1,1]+47,aPos[1,4]-240 SAY "% de Desconto: " OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+35,(aPos[1,4]/2)+177 MSGET oVlrPerc VAR nPercDesc VALID if(clistbox==1,FS_VALLIN(aItens[oLbitem:nAt,02],"2"),FS_VALLIN(aPedPen[oLbox1:nAt,01],"2")) .and. FS_GRADES("2") PICTURE "@E 999.99"+"%" SIZE 40,8 OF oDlg1 PIXEL COLOR CLR_BLUE

@ aPos[1,1]+47,(aPos[1,4]/2)+55 SAY "Valor Líquido: " OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+47,(aPos[1,4]/2)+110 MSGET oVlrLiq VAR nVlrLiq VALID FS_POSICIONA() PICTURE "@E 999,999.99" SIZE 65,8 OF oDlg1 PIXEL COLOR CLR_BLUE when .f.

@ aPos[4,1]+10,aPos[4,2]+018 SAY "Cód.Barra Fab." OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[4,1]+10,aPos[4,2]+068 MSGET oCodBar VAR cCodbar Valid FS_CODBARRA(cOrcam) PICTURE "@!" SIZE 150,8 OF oDlg1 PIXEL COLOR CLR_BLUE

@ aPos[3,1],aPos[3,2] SAY "Similares / Pedidos Pendentes" OF oDlg1   PIXEL COLOR CLR_RED
@ aPos[3,1]+08,aPos[3,2] LISTBOX oLbox1 FIELDS HEADER "Cód.Produto","Cód.Fabricante","Nome Fabricante","Quantidade","Preço","Quant.Comprada" ;
	COLSIZES 40,40,60,30,45,40 SIZE (aPos[3,4]/2)-20,aPos[3,3]-aPos[3,1] OF Odlg1 PIXEL ;
	ON CHANGE (FS_LIMPAVLR(aPedPen[oLbox1:nAt,01],oLbox1:nAt));
	ON DBLCLICK (FS_FILPREC(oLbox1:nAt,"1",aPedPen[oLbox1:nAt,02]));
	VALID MUDACPO1()

oLbox1:SetArray(aPedPen)
oLbox1:bLine := { || { aPedPen[oLbox1:nAt,01],;
						aPedPen[oLbox1:nAt,02],;
						aPedPen[oLbox1:nAt,03],;
						FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,04],"@E 99999")),;
						FG_AlinVlrs(transform(aPedPen[oLbox1:nAt,05],"@E 999,999.99")),;
						FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,06],"@E 99999"))}}
oLbox1:bGotFocus   := {|| nListbox := 2,FS_FILPREC(oLbox1:nAt,"1",aPedPen[oLbox1:nAt,02])}


@ aPos[3,1]+08,(aPos[3,4]/2)-16 GET oMsg VAR cMsg OF oDlg1 MEMO SIZE ((aPos[3,4]-2)/4)+20,aPos[3,3]-aPos[3,1] PIXEL READONLY MEMO FONT (TFont():New('Courier New',0,-10,.T.,.T.))
@ aPos[3,1]+08,(aPos[3,4]-((aPos[3,4]-2)/4)) GET oMsg1 VAR cMsg1 OF oDlg1 MEMO SIZE ((aPos[3,4]-2)/4),aPos[3,3]-aPos[3,1]  PIXEL READONLY MEMO FONT (TFont():New('Courier New',0,-10,.T.,.T.))

@ aPos[4,1]+10,aPos[4,2]+018 SAY "Cód.Barra Fab." OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[4,1]+10,aPos[4,2]+068 MSGET oCodBar VAR cCodbar Valid FS_CODBARRA(cOrcam) PICTURE "@!" SIZE 150,8 OF oDlg1 PIXEL COLOR CLR_BLUE

//@ aPos[4,1]+21,aPos[4,2]+40 SAY "Enter- Atualiza dados     Alt+C / Alt+F4 Calculadora"+space(15)+"F2-Consulta          F3-Aplicação          F4-Seleciona Item          F5-Similares          F6-Foto/Vídeo     F7-Limpar     F8-Item Selecionado          F11-Finaliza        F12-Sair" OF oDlg1   PIXEL COLOR CLR_BLUE
@ aPos[4,1]+21,aPos[4,2]+010 SAY "Enter=Atualiza dados    Alt+C=Calculadora"+space(15)+"F2=Consulta       F4=Seleciona Item       F5=Similares       F6=Foto/Vídeo     F7=Limpar     F8=Item Selecionado      F11=Finaliza     F12=Sair" OF oDlg1   PIXEL COLOR CLR_BLUE

oLbitem:SetFocus()

ACTIVATE MSDIALOG oDlg1 CENTER ON INIT iif(lFecha,MONTATELA(cOrcam),.f.)


Return(.t.)

/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Função    |OC009ITEREL | Autor |  Luis Delorme         | Data | 12/12/12 |##
##+----------+------------+-------+-----------------------+------+----------+##
##|Descrição | Preenche os itens relacionados na listbox                    |##
##+----------+--------------------------------------------------------------+##
##| Uso      | Veiculos                                                     |##
##+----------+--------------------------------------------------------------+##
###############################################################################
===============================================================================
*/
Static Function OC009ITEREL(cPesq,cProdut)
Local nCntFor
Local i := 0
Local cCodSB1 := ""
Local cGrupoVal := ""
Local cCodIteVal := ""
Local cForPad := GetNewPar("MV_FMLPECA",'"      "')
Local cAliasSB2   := "SQLSB2"
Private cForVal  := ""
aItensRel := {}
aPedPen := {{"","","",0,0,0}}
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProdut)
cGrupoVal  := SB1->B1_GRUPO
cCodIteVal := SB1->B1_CODITE
cForVal    := &cForPad

//######################################################################
//# Passa os campos para a funcao que retorna o array dos relacionados #
//######################################################################
	aIteRel1 := FG_ITEREL("",cGrupoVal,cCodIteVal,"cForVal")
	For nCntFor := 1 to Len(aIteRel1)
	    if Empty(aIteRel1[nCntFor,1]+aIteRel1[nCntFor,2])
	       Loop
	    Endif
		DBSelectArea("SBM")
		DBSeek(xFilial("SBM")+aIteRel1[nCntFor,1])
		DbSelectArea("VE1")
		DBSetOrder(1)
		DBSeek(xFilial("VE1")+SBM->BM_CODMAR)
		DBSelectArea("SB1")
		DBSetOrder(7)
		DBSeek(xFilial("SB1")+aIteRel1[nCntFor,1]+aIteRel1[nCntFor,2])
		DBSelectArea("SB2")
		DBSetOrder(1)
		DBSeek(xFilial("SB2")+SB1->B1_COD)
		if !Empty(aIteRel1[nCntFor,1]+aIteRel1[nCntFor,2])
			cCodSB1 := SB1->B1_COD
		Else
			cCodSB1 := ""
		Endif

	    if Len(aItensRel) == 1 .and. Empty(aItensRel[1,1])
   		   aItensRel := {}
    	Endif
//	    Aadd(aItensRel,{SB1->B1_COD,aIteRel1[nCntFor,1],aIteRel1[nCntFor,2],aIteRel1[nCntFor,3],"",SB2->B2_QATU,.f.})
		if Empty(aPedPen[1,1])
		   aPedPen := {}
		Endif
	    Aadd(aPedPen,{SB1->B1_COD,SB1->B1_CODITE,SB1->B1_PROC,SB2->B2_QATU,FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.),0})
	next
	//
	If ( ExistBlock("OX001IRL") )
		aIteRel1 := ExecBlock("OX001IRL",.f.,.f.,{aIteRel1})
	EndIf
	//
//	aIteRel1 := {{"","","",0,0,"","",""}}
//
If len(aIteRel1) <= 0
	aIteRel1 := {{"","","",0,0,"","",""}}
EndIf
if cPesq == "2"
   oLbox1:SetArray(aPedPen)
   oLbox1:bLine := { || { aPedPen[oLbox1:nAt,01],;
						   aPedPen[oLbox1:nAt,02],;
						   aPedPen[oLbox1:nAt,03],;
						   FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,04],"@E 99999")),;
						   FG_AlinVlrs(transform(aPedPen[oLbox1:nAt,05],"@E 999,999.99")),;
						   FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,06],"@E 99999"))}}
   oLbox1:Refresh()
Endif
Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | FS_FILPREC  |Autor  ³ Thiago             ³ Data ³ 12/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Chama ponto de entrada para listagem dos valores.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Venda Balcao                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_FILPREC(nLin,cOpc,cProd)
Local i := 0
Local nCont := 0
Local cAliasSB2 := "SQLSB2"
Local aFilAtu   := FWArrFilAtu()
Local aSM0      := FWAllFilial( aFilAtu[3] , aFilAtu[4] , aFilAtu[1] , .f. )
Local cBkpFilAnt:= cFilAnt
Local cDadosProd:= SuperGetMV("MV_ARQPROD",.F.,"SB1") 

if cOpc <> "3"
	DbSelectArea("VAI")
	Dbsetorder(4)
	DbSeek(xFilial("VAI")+__cUserID)
Endif
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+cProd)

dbSelectArea("SB5")
dbSetOrder(1)
dbSeek(xFilial("SB5")+SB1->B1_COD)
dbSelectArea("VEG")
dbSetOrder(2)
dbSeek(xFilial("VEG")+"04")

lRet := .t.
cMsg1 := "Tabela de Preços"+CHR(10)+CHR(13)


Do while !EOF() .and. VEG->VEG_FILIAL == xFilial("VEG") .and. VEG->VEG_GRUFOR == "04"
    if VAI->VAI_TIPTEC <> "1"
        cFormul := FS_FORMULA()
	    if VEG->VEG_CODIGO <> &(cFormul)
	       dbSelectArea("VEG")
	       dbSkip()
	       Loop
	    Endif
	Endif
	if Empty(VEG->VEG_GRUPOS)
		lRet := .t.
	Else
		lRet := .f.
		For i:=1 to 25
			if Empty(Substr(VEG->VEG_GRUPOS,(i*4)-3,4))
				Exit
			Else
				if cGrupo == Substr(VEG->VEG_GRUPOS,(i*4)-3,4)
					lRet := .t.
					Exit
				Endif
			Endif
		Next
	Endif
	nRecNoVEG := VEG->(recno())
	if lRet  
		wVar := VEG->VEG_FORMUL
		cMsg1 += VEG->VEG_DESCRI+" "+Transform(FG_FORMULA(VEG->VEG_CODIGO),"@E 9,999,999.99")+CHR(10)+CHR(13)
	Endif
	//
	dbSelectArea("VEG")
	dbSetOrder(2)
	DbGoto(nRecNoVEG)
	dbSkip()
Enddo

cMsg := "Itens em Outras Filiais"+CHR(10)+CHR(13)+CHR(10)+CHR(13)

For nCont := 1 to Len(aSM0)

	cFilAnt := aSM0[nCont]
	aFilAtu   := FWArrFilAtu()

    If cDadosProd == "SBZ" .and. SBZ->(FieldPos("BZ_LOCALI2")) > 0
		cQuery := "SELECT DISTINCT SB2.B2_FILIAL,SB2.B2_QATU,SBZ.BZ_LOCALI2 "
    Else
		cQuery := "SELECT DISTINCT SB2.B2_FILIAL,SB2.B2_QATU,SB5.B5_LOCALI2 "
	Endif

	cQuery += "FROM "
	cQuery += RetSqlName( "SB2" ) + " SB2 "
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SB2.B2_COD AND SB1.D_E_L_E_T_=' ' "
    If cDadosProd == "SBZ" .and. SBZ->(FieldPos("BZ_LOCALI2")) > 0
		cQuery += " LEFT JOIN "+RetSqlName("SBZ")+" SBZ ON SBZ.BZ_FILIAL = '"+xFilial("SBZ")+"' AND SBZ.BZ_COD = SB2.B2_COD AND SB2.B2_LOCAL = SBZ.BZ_LOCPAD AND SBZ.D_E_L_E_T_=' ' "
	Else
		cQuery += " LEFT JOIN "+RetSqlName("SB5")+" SB5 ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' AND SB5.B5_COD = SB2.B2_COD AND SB5.D_E_L_E_T_=' ' "
	Endif
	cQuery += "WHERE "
	cQuery += "SB2.B2_COD = '"+cProd+"' AND SB2.B2_LOCAL = SB1.B1_LOCPAD AND SB2.B2_FILIAL = '"+Alltrim(cFilAnt)+"' AND "
	cQuery += "SB2.D_E_L_E_T_=' '"

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB2, .T., .T. )
	lAchou := .f.
	cLocaliz := ""
	Do While !( cAliasSB2 )->( Eof() )

	    If cDadosProd == "SBZ" .and. SBZ->(FieldPos("BZ_LOCALI2")) > 0
		    if !Empty(( cAliasSB2 )->BZ_LOCALI2)
	    	   cLocaliz := ( cAliasSB2 )->BZ_LOCALI2
		    Else
		       cLocaliz := "Inexistente"
	    	Endif
	    Else
		    if !Empty(( cAliasSB2 )->B5_LOCALI2)
	    	   cLocaliz := ( cAliasSB2 )->B5_LOCALI2
		    Else
		       cLocaliz := "Inexistente"
	    	Endif
    	Endif
	    cMsg += aFilAtu[SM0_FILIAL]+" - "+Transform(( cAliasSB2 )->B2_QATU,"@E 99999")+space(2)+"Local: "+cLocaliz+CHR(10)+CHR(13)
	    lAchou := .t.

		dbSelectArea(cAliasSB2)
		( cAliasSB2 )->(dbSkip())
	Enddo
	(cAliasSB2)->(dbCloseArea())

	if !lAchou
		cMsg += aFilAtu[SM0_FILIAL]+" - "+Transform(0,"@E 99999")+CHR(10)+CHR(13)
	Endif
Next
cFilAnt := cBkpFilAnt
if cOpc == "1"
	oMsg:Refresh()
	oMsg1:Refresh()
Endif

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    | FS_TELARESU |Autor  ³ Thiago            ³ Data ³ 12/12/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Chamada da tela de resultado.					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Venda Balcao                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_TELARESU(cOpcao)
Local cAliasSB1 := "SQLSB1"
Local lAchouP   := .t.
Private cFocus  := 0
aDescricao := {""}

if cSair == "1"
   Return(.t.)
Endif
if cOpcao == "1"
	if Alltrim(cFabBkp) == Alltrim(cNomFab)
       Return(.t.)
    Endif
    if Empty(cNomFab)
       Return(.t.)
    Endif
/*
	cQuery := "SELECT DISTINCT SA2.A2_NREDUZ "
	cQuery += "FROM "
	cQuery += RetSqlName( "SA2" ) + " SA2 "
	cQuery += "WHERE "
	cQuery += "SA2.A2_FILIAL='"+ xFilial("SA2")+ "' AND "+FG_CONVSQL("SUBS")+"(SA2.A2_COD,1,1) = 'F' AND SA2.A2_NREDUZ = '"+Alltrim(cNomFab)+"' AND "
	cQuery += "SA2.D_E_L_E_T_=' ' ORDER BY SA2.A2_NREDUZ "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SA2.A2_NREDUZ "
		cQuery += "FROM "
		cQuery += RetSqlName( "SA2" ) + " SA2 "
		cQuery += "WHERE "
		cQuery += "SA2.A2_FILIAL='"+ xFilial("SA2")+ "' AND "+FG_CONVSQL("SUBS")+"(SA2.A2_COD,1,1) = 'F' AND SA2.A2_NREDUZ LIKE '"+Alltrim(cNomFab)+"%' AND "
		cQuery += "SA2.D_E_L_E_T_=' ' ORDER BY SA2.A2_NREDUZ "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	Endif
*/
	cQuery := "SELECT DISTINCT SB1.B1_FABRIC "
	cQuery += "FROM "
	cQuery += RetSqlName( "SB1" ) + " SB1 "
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+ xFilial("SB1")+ "' AND SB1.B1_FABRIC = '"+Alltrim(cNomFab)+"' AND "
	cQuery += "SB1.D_E_L_E_T_=' ' ORDER BY SB1.B1_FABRIC "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SB1.B1_FABRIC "
		cQuery += "FROM "
		cQuery += RetSqlName( "SB1" ) + " SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL='"+ xFilial("SB1")+ "' AND SB1.B1_FABRIC LIKE '"+Alltrim(cNomFab)+"%' AND "
		cQuery += "SB1.D_E_L_E_T_=' ' ORDER BY SB1.B1_FABRIC "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	Endif
Elseif cOpcao == "2"
	if Alltrim(cNomBkp) == Alltrim(cNomencla)
       Return(.t.)
    Endif
    if Empty(cNomencla)
       Return(.t.)
    Endif
/*	cQuery := "SELECT DISTINCT SBM.BM_DESC "
	cQuery += "FROM "
	cQuery += RetSqlName( "SBM" ) + " SBM "
	cQuery += "WHERE "
	cQuery += "SBM.BM_FILIAL='"+ xFilial("SBM")+ "' AND SBM.BM_DESC = '"+Alltrim(cNomencla)+"' AND "
	cQuery += "SBM.D_E_L_E_T_=' ' ORDER BY SBM.BM_DESC "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SBM.BM_DESC "
		cQuery += "FROM "
		cQuery += RetSqlName( "SBM" ) + " SBM "
		cQuery += "WHERE "
		cQuery += "SBM.BM_FILIAL='"+ xFilial("SBM")+ "' AND SBM.BM_DESC LIKE '"+Alltrim(cNomencla)+"%' AND "
		cQuery += "SBM.D_E_L_E_T_=' ' ORDER BY SBM.BM_DESC "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	Endif
*/
	cQuery := "SELECT DISTINCT SB1.B1_DESC "
	cQuery += "FROM "
	cQuery += RetSqlName( "SB1" ) + " SB1 "
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+ xFilial("SB1")+ "' AND SB1.B1_DESC = '"+Alltrim(cNomencla)+"' AND "
	cQuery += "SB1.D_E_L_E_T_=' ' ORDER BY SB1.B1_DESC "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SB1.B1_DESC "
		cQuery += "FROM "
		cQuery += RetSqlName( "SB1" ) + " SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL='"+ xFilial("SB1")+ "' AND SB1.B1_DESC LIKE '"+Alltrim(cNomencla)+"%' AND "
		cQuery += "SB1.D_E_L_E_T_=' ' ORDER BY SB1.B1_DESC "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	Endif
Elseif cOpcao == "3"
	if Alltrim(cClaBkp) == Alltrim(cClasse)
       Return(.t.)
    Endif
    if Empty(cClasse)
       Return(.t.)
    Endif
	cQuery := "SELECT DISTINCT SX5.X5_DESCRI "
	cQuery += "FROM "
	cQuery += RetSqlName( "SX5" ) + " SX5 "
	cQuery += "WHERE "
	cQuery += "SX5.X5_FILIAL='"+ xFilial("SX5")+ "' AND SX5.X5_TABELA = 'V8' AND  UPPER(SX5.X5_DESCRI) = '"+Alltrim(cClasse)+"' AND "
	cQuery += "SX5.D_E_L_E_T_=' ' ORDER BY SX5.X5_DESCRI "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SX5.X5_DESCRI "
		cQuery += "FROM "
		cQuery += RetSqlName( "SX5" ) + " SX5 "
		cQuery += "WHERE "
		cQuery += "SX5.X5_FILIAL='"+ xFilial("SX5")+ "' AND SX5.X5_TABELA = 'V8' AND  UPPER(SX5.X5_DESCRI) LIKE '"+Alltrim(cClasse)+"%' AND "
		cQuery += "SX5.D_E_L_E_T_=' ' ORDER BY SX5.X5_DESCRI "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    Endif
Elseif cOpcao == "4"
	if Alltrim(cModBkp) == Alltrim(cModelo)
       Return(.t.)
    Endif
    if Empty(cModelo)
       Return(.t.)
    Endif
	cQuery := "SELECT DISTINCT VV2.VV2_DESMOD,VV2.VV2_MODVEI,VE1.VE1_DESMAR "
	cQuery += "FROM "
	cQuery += RetSqlName( "VV2" ) + " VV2 "
	cQuery += " INNER JOIN " + RetSQLName("VE1") + " VE1 ON VE1_FILIAL = '" + xFilial("VE1") + "' AND VE1_CODMAR = VV2_CODMAR AND VE1.D_E_L_E_T_ = ' '"
	cQuery += "WHERE "
	cQuery += "VV2.VV2_FILIAL='"+ xFilial("VV2")+ "' AND (VV2.VV2_MODVEI = '"+Alltrim(cModelo)+"' OR VV2.VV2_DESMOD = '"+Alltrim(cModelo)+"') AND "
	cQuery += "VV2.D_E_L_E_T_=' ' ORDER BY VV2.VV2_DESMOD "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT VV2.VV2_DESMOD,VV2.VV2_MODVEI,VE1.VE1_DESMAR "
		cQuery += "FROM "
		cQuery += RetSqlName( "VV2" ) + " VV2 "
		cQuery += " INNER JOIN " + RetSQLName("VE1") + " VE1 ON VE1_FILIAL = '" + xFilial("VE1") + "' AND VE1_CODMAR = VV2_CODMAR AND VE1.D_E_L_E_T_ = ' '"
		cQuery += "WHERE "
		cQuery += "VV2.VV2_FILIAL='"+ xFilial("VV2")+ "' AND (VV2.VV2_MODVEI = '"+Alltrim(cModelo)+"' OR VV2.VV2_DESMOD LIKE '"+Alltrim(cModelo)+"%') AND "
		cQuery += "VV2.D_E_L_E_T_=' ' ORDER BY VV2.VV2_DESMOD "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	Else
		cModVei := ( cAliasSB1 )->VV2_MODVEI
		cMarBkp := cMarca := ( cAliasSB1 )->VE1_DESMAR
	Endif
Elseif cOpcao == "5"
	if Alltrim(cMarBkp) == Alltrim(cMarca)
       Return(.t.)
    Endif
    if Empty(cMarca)
       Return(.t.)
    Endif
	cQuery := "SELECT DISTINCT VE1.VE1_DESMAR "
	cQuery += "FROM "
	cQuery += RetSqlName( "VE1" ) + " VE1 "
	cQuery += "WHERE "
	cQuery += "VE1.VE1_FILIAL='"+ xFilial("VE1")+ "' AND (VE1.VE1_CODMAR = '"+Alltrim(cMarca)+"' OR VE1.VE1_DESMAR = '"+Alltrim(cMarca)+"') AND "
	cQuery += "VE1.D_E_L_E_T_=' ' ORDER BY VE1.VE1_DESMAR "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT VE1.VE1_DESMAR "
		cQuery += "FROM "
		cQuery += RetSqlName( "VE1" ) + " VE1 "
		cQuery += "WHERE "
		cQuery += "VE1.VE1_FILIAL='"+ xFilial("VE1")+ "' AND (VE1.VE1_CODMAR = '"+Alltrim(cMarca)+"' OR VE1.VE1_DESMAR LIKE '"+Alltrim(cMarca)+"%') AND "
		cQuery += "VE1.D_E_L_E_T_=' ' ORDER BY VE1.VE1_DESMAR "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	Endif
Elseif cOpcao == "8"
	if Alltrim(cFamBkp) == Alltrim(cFamilia)
       Return(.t.)
    Endif
    if Empty(cFamilia)
       Return(.t.)
    Endif
	cQuery := "SELECT DISTINCT SX5.X5_DESCRI "
	cQuery += "FROM "
	cQuery += RetSqlName( "SX5" ) + " SX5 "
	cQuery += "WHERE "
	cQuery += "SX5.X5_FILIAL='"+ xFilial("SX5")+ "' AND SX5.X5_TABELA = 'V7' AND  UPPER(SX5.X5_DESCRI) = '"+Alltrim(cFamilia)+"' AND "
	cQuery += "SX5.D_E_L_E_T_=' ' ORDER BY SX5.X5_DESCRI "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SX5.X5_DESCRI "
		cQuery += "FROM "
		cQuery += RetSqlName( "SX5" ) + " SX5 "
		cQuery += "WHERE "
		cQuery += "SX5.X5_FILIAL='"+ xFilial("SX5")+ "' AND SX5.X5_TABELA = 'V7' AND  UPPER(SX5.X5_DESCRI) LIKE '"+Alltrim(cFamilia)+"%' AND "
		cQuery += "SX5.D_E_L_E_T_=' ' ORDER BY SX5.X5_DESCRI "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    Endif
Elseif cOpcao == "9"
	if Alltrim(cSClaBkp) == Alltrim(cSClasse)
       Return(.t.)
    Endif
    if Empty(cSClasse)
       Return(.t.)
    Endif
	cQuery := "SELECT DISTINCT SX5.X5_DESCRI "
	cQuery += "FROM "
	cQuery += RetSqlName( "SX5" ) + " SX5 "
	cQuery += "WHERE "
	cQuery += "SX5.X5_FILIAL='"+ xFilial("SX5")+ "' AND SX5.X5_TABELA = 'V9' AND  UPPER(SX5.X5_DESCRI) = '"+Alltrim(cSClasse)+"' AND "
	cQuery += "SX5.D_E_L_E_T_=' ' ORDER BY SX5.X5_DESCRI "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SX5.X5_DESCRI "
		cQuery += "FROM "
		cQuery += RetSqlName( "SX5" ) + " SX5 "
		cQuery += "WHERE "
		cQuery += "SX5.X5_FILIAL='"+ xFilial("SX5")+ "' AND SX5.X5_TABELA = 'V9' AND  UPPER(SX5.X5_DESCRI) LIKE '"+Alltrim(cSClasse)+"%' AND "
		cQuery += "SX5.D_E_L_E_T_=' ' ORDER BY SX5.X5_DESCRI "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    Endif

/*Elseif cOpcao == "6"
	if Alltrim(cAplBkp) == Alltrim(cAplic)
       Return(.t.)
    Endif
    if Empty(cAplic)
       Return(.t.)
    Endif

	cQuery := "SELECT DISTINCT SB1.B1_DESC "
    If SB1->(FieldPos("B1_DESC2")) > 0
		cQuery += ",SB1.B1_DESC2 "
	Endif
	cQuery += "FROM "
	cQuery += RetSqlName( "SB1" ) + " SB1 "
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+ xFilial("SB1")+ "' AND "
	If SB1->(FieldPos("B1_DESC2")) > 0
		cQuery += "(SB1.B1_DESC = '"+Alltrim(cAplic)+"' OR SB1.B1_DESC2 = '"+Alltrim(cAplic)+"') AND "
	Else
		cQuery += "SB1.B1_DESC = '"+Alltrim(cAplic)+"' AND "
    Endif
	cQuery += "SB1.D_E_L_E_T_=' ' ORDER BY SB1.B1_DESC "
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
    if ( cAliasSB1 )->( Eof())
        lAchouP := .f.
        (cAliasSB1)->(dbCloseArea())
		dbSelectArea("SB1")
		cQuery := "SELECT DISTINCT SB1.B1_DESC "
	    If SB1->(FieldPos("B1_DESC2")) > 0
			cQuery += ",SB1.B1_DESC2 "
		Endif
		cQuery += "FROM "
		cQuery += RetSqlName( "SB1" ) + " SB1 "
		cQuery += "WHERE "
		cQuery += "SB1.B1_FILIAL='"+ xFilial("SB1")+ "' AND "
		If SB1->(FieldPos("B1_DESC2")) > 0
			cQuery += "(SB1.B1_DESC LIKE '"+Alltrim(cAplic)+"%' OR SB1.B1_DESC2 LIKE '"+Alltrim(cAplic)+"%') AND "
		Else
			cQuery += "SB1.B1_DESC LIKE '"+Alltrim(cAplic)+"%' AND "
	    Endif
		cQuery += "SB1.D_E_L_E_T_=' ' ORDER BY SB1.B1_DESC "
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	Endif
*/
Endif
//dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )

if !lAchouP
	Do While !( cAliasSB1 )->( Eof() )

	   if Empty(aDescricao[1])
    	  aDescricao := {}
	   Endif
	   if cOpcao == "1"
		   Aadd(aDescricao,{( cAliasSB1 )->B1_FABRIC})
	   Elseif cOpcao == "2"
		   Aadd(aDescricao,{( cAliasSB1 )->B1_DESC})
	   Elseif cOpcao == "3"
		   Aadd(aDescricao,{( cAliasSB1 )->X5_DESCRI})
	   Elseif cOpcao == "4"
		   Aadd(aDescricao,{( cAliasSB1 )->VV2_DESMOD,( cAliasSB1 )->VV2_MODVEI,( cAliasSB1 )->VE1_DESMAR})
	   Elseif cOpcao == "5"
		   Aadd(aDescricao,{( cAliasSB1 )->VE1_DESMAR})
//	   Elseif cOpcao == "6"
//	       If SB1->(FieldPos("B1_DESC2")) > 0
//		      Aadd(aDescricao,{( cAliasSB1 )->B1_DESC+( cAliasSB1 )->B1_DESC2})
//	       Else
//		      Aadd(aDescricao,{( cAliasSB1 )->B1_DESC})
//	       Endif
	   Elseif cOpcao == "7"
		   Aadd(aDescricao,{( cAliasSB1 )->B1_PROC})
	   Elseif cOpcao == "8"
		   Aadd(aDescricao,{( cAliasSB1 )->X5_DESCRI})
	   Elseif cOpcao == "9"
		   Aadd(aDescricao,{( cAliasSB1 )->X5_DESCRI})
	   Endif
	   dbSelectArea(cAliasSB1)
	   ( cAliasSB1 )->(dbSkip())

	Enddo

	if len(aDescricao) == 1 .and. Empty(aDescricao[1])
	   MsgStop("Não há itens para esta pesquisa!")
	//   Return(.f.)
	Else

		If Len(aDescricao) == 1
			FS_VALCPOS(aDescricao[1,1], cOpcao)
		Else

			DEFINE MSDIALOG oDlg2 TITLE "" From 20,115 to 44,160 of oMainWnd

			@ 001,001  LISTBOX oLbox2 FIELDS HEADER "" COLSIZES 180 SIZE 178,180 OF Odlg2 PIXEL ON DBLCLICK ( FS_VALCPOS(aDescricao[oLbox2:nAt,1],cOpcao) , oDlg2:End() )
			oLbox2:SetArray(aDescricao)
			oLbox2:bLine := { || { aDescricao[oLbox2:nAt,01]}}

			ACTIVATE MSDIALOG oDlg2
		EndIf
	Endif
	if cFocus == 0
		if cOpcao == "1"
	       oNomFab:SetFocus()
		Elseif cOpcao == "2"
	       oNomencla:SetFocus()
		Elseif cOpcao == "3"
	       oClasse:SetFocus()
		Elseif cOpcao == "4"
	       oModelo:SetFocus()
		Elseif cOpcao == "5"
	       oMarca:SetFocus()
//		Elseif cOpcao == "6"
//	       oAplic:SetFocus()
		Elseif cOpcao == "7"
	       oCodFab:SetFocus()
		Elseif cOpcao == "8"
	       oFamilia:SetFocus()
		Elseif cOpcao == "9"
	       oSClasse:SetFocus()
	    Endif
	Endif
Endif
(cAliasSB1)->(dbCloseArea())
dbSelectArea("SB1")

return

Static Function FS_VALCPOS(cCod,cOpcao)
cFocus := 1
if cOpcao == "1"
	cNomFab := cCod
	cFabBkp := cCod
Elseif cOpcao == "2"
    cNomencla := cCod
	cNomBkp := cCod
Elseif cOpcao == "3"
    cClasse := cCod
	cClaBkp := cCod
Elseif cOpcao == "4"
    cModelo := cCod
	cModBkp := cCod
    nPos := Ascan(aDescricao,{|x| Alltrim(x[1]) == Alltrim(cModelo)})
    cModVei := aDescricao[nPos,2]
    cMarca  := aDescricao[nPos,3]
    cMarBkp := aDescricao[nPos,3]
Elseif cOpcao == "5"
    cMarca := cCod
	cMarBkp := cCod
//Elseif cOpcao == "6"
//    cAplic := cCod
//	cAplBkp := cCod
Elseif cOpcao == "8"
    cFamilia := cCod
	cFamBkp := cCod
Elseif cOpcao == "9"
    cSClasse := cCod
	cSClaBkp := cCod
Else
	cCodFab := cCod
	cCFabBkp := cCod
Endif
Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ FS_KIT ³ Autor ³ Thiago                  ³ Data ³ 13/12/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Verifica KIT.								 		       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Oficina                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_KIT(cOrcam,cGrupo,cCodigo,cOpcao)

Default cGrupo := ""
Default cCodigo := ""
Private lJaPerg := .t. 		// Variavel necessaria ao OFIOC040

//dbSelectArea("SB1")
//dbSetOrder(1)
//dbSeek(xFilial("SB1")+Alltrim(cChave))
aKit := OFIOC040(cGrupo,cCodigo)
if Len(aKit) > 0
	FS_FILTRO(,cOpcao,cOrcam)
	FS_MARKA(.t.)
Else
   if Len(aItens) > 0
      aItens[oLbitem:nAt,8] := ""
   Endif
Endif
Return(.t.)

Static Function FS_QUANT(cOrcam)

Local nOpca := 0
Private lAchou := .f.


SetAtalhos(0) // Limpa Todos os Atalhos

if nListbox == 1
	if Len(aItens) > 0
	   if !aItens[oLbitem:nAt,1]
	        dbSelectArea("SB1")
	        dbSetOrder(1)
	        dbSeek(xFilial("SB1")+aItens[oLbitem:nAt,2])
    	    dbSelectArea("SB2")
        	dbSetOrder(1)
    	    dbSeek(xFilial("SB2")+aItens[oLbitem:nAt,2])
		    FS_KIT(cOrcam,SB1->B1_GRUPO,SB1->B1_CODITE,"11")
        	lAchou := .t.
			if Len(aKit) == 0
				nQtdIte := 0
				DEFINE MSDIALOG oAltReg TITLE "Quantidade" From 5,08 to 08,30 of oMainWnd
				@ 006,017 MSGET oQtdIte VAR nQtdIte PICTURE "@E 99999.9999" VALID FS_MARKA(.f.) SIZE 50,08 OF oAltReg PIXEL COLOR CLR_BLUE
				@ 040,007 BUTTON oX PROMPT OemToAnsi("") OF oAltReg SIZE 01,01 PIXEL ACTION oAltReg:End()
				ACTIVATE MSDIALOG oAltReg CENTER
			Endif
		Else
			FS_MARKA(.f.)
		Endif
	Endif
	oLbitem:SetFocus()
Else
    dbSelectArea("SB1")
    dbSetOrder(1)
    dbSeek(xFilial("SB1")+aPedPen[oLbox1:nAt,01])
   	nAchou := Ascan(aItens,{|x| Alltrim(x[2]) == Alltrim(SB1->B1_COD)})
   	if nAchou == 0
	    dbSelectArea("SB1")
	    dbSetOrder(1)
	    dbSeek(xFilial("SB1")+SB1->B1_COD)
        dbSelectArea("SB2")
       	dbSetOrder(1)
        dbSeek(xFilial("SB2")+SB1->B1_COD)
       	lAchou := .t.
	    FS_KIT(cOrcam,SB1->B1_GRUPO,SB1->B1_CODITE,"11")

		if Len(aKit) == 0
			nQtdIte := 0
			DEFINE MSDIALOG oAltReg TITLE "Quantidade" From 5,08 to 08,30 of oMainWnd
			@ 006,017 MSGET oQtdIte VAR nQtdIte PICTURE "@E 999,999.9999" VALID FS_MARKA(.f.) SIZE 50,08 OF oAltReg PIXEL COLOR CLR_BLUE
			@ 040,007 BUTTON oXa PROMPT OemToAnsi("") OF oAltReg SIZE 01,01 PIXEL ACTION (nOpca := 1,oAltReg:End())
			ACTIVATE MSDIALOG oAltReg CENTER
        Endif

    	oLbitem:Refresh()
    Else
       MsgInfo("Produto ja foi incluído, verifique!")
    Endif
   oLbox1:SetFocus()
Endif

SetAtalhos(1,cOrcam)

Return(.t.)

Static Function FS_MARKA(lKit)
Local i := 0
Local y := 0
if lKit
    For i := 1 to Len(aKit)
		if Len(aItens) > 0
	   	  dbSelectArea("SB1")
	   	  dbSetOrder(7)
	   	  dbSeek(xFilial("SB1")+aKit[i,1]+aKit[i,2])
	   	   nPosItens := Ascan(aItens,{|x| x[2] == SB1->B1_COD})
  	       if nPosItens > 0
	  	       aItens[nPosItens,1] := .t.
			   if Empty(aVetMem[1,1])
			      aVetMem := {}
			   Endif
			   cFormul := FS_FORMULA()
			   nQtdIte := aKit[i,4]
		   	   nPosVet := Ascan(aVetMem,{|x| x[1] == aItens[nPosItens,2]})
		   	   if nPosVet == 0
				   Aadd(aVetMem,{aItens[nPosItens,2],aItens[nPosItens,3],aItens[nPosItens,4],nQtdIte,FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.),nPercDesc,nVlrDesc,(FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)-nVlrDesc)*nQtdIte})
	 		   Endif
		   Endif
	   Else
		   cFormul := FS_FORMULA()
	   	   Aadd(aItens,{.f.,SB1->B1_COD,SB1->B1_CODITE,SB1->B1_FABRIC,substr(SB1->B1_DESC,1,100),nQtdI,"0","","",0,0,FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)})
		   nQtdI += 1
	       nLin := Len(aItens)
		   if aItens[nLin,1]
		      aItens[nLin,1] := .f.
		   	  nAchou := Ascan(aVetMem,{|x| x[1] == aItens[nLin,2]})
		      if nAchou > 0
			   	  aDel(aVetMem,nAchou)
				  aSize(aVetMem,Len(aVetMem)-1)
				  if Len(aVetMem) == 0
				     aVetMem  := {{"","","",0,0,0,0,0}}
				  Endif
		  	  Endif
		   Else
		      aItens[nLin,1] := .t.
		   	  dbSelectArea("SB1")
		   	  dbSetOrder(1)
		   	  dbSeek(xFilial("SB1")+aItens[nLin,2])
		   	  if Empty(aVetMem[1,1])
		   	     aVetMem := {}
		   	  Endif
  		   	   nPosVet := Ascan(aVetMem,{|x| x[1] == aItens[nLin,2]})
		   	   if nPosVet == 0
				  Aadd(aVetMem,{aItens[nLin,2],aItens[nLin,3],aItens[nLin,4],nQtdIte,FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.),nPercDesc,nVlrDesc,nVlrLiq*nQtdIte})
  			   Endif
		   Endif
		Endif
	Next
	oLbitem:SetArray(aItens)
	oLbitem:bLine := { || { IIf(aItens[oLbitem:nAt,01],o_Verd,o_Verm),;
							aItens[oLbitem:nAt,02],;
							aItens[oLbitem:nAt,03],;
							aItens[oLbitem:nAt,04],;
	 						transform(aItens[oLbitem:nAt,10],"@E 999.99")+"%",;
 							transform(aItens[oLbitem:nAt,11],"@E 999,999,999.99"),;
	 						transform(aItens[oLbitem:nAt,12],"@E 999,999,999.99"),;
 							aItens[oLbitem:nAt,5]}}
    oLbitem:Refresh()
Else
	if nQtdIte == 0
	   MsgStop("Quantidade não foi informada, verifique!")
	   Return(.f.)
	Endif

	if Len(aItens) > 0
	   if nListbox == 1
	       if aItens[oLbitem:nAt,8] <> ""
			   if MsgYesNo("Este item é mandatório para o kit. Ao removê-lo, todos os itens do kit serão desmarcados. Deseja continuar?","Atenção")
			       lx := aItens[oLbitem:nAt,1]
			       For y := 1 to Len(aItens)
			          dbSelectArea("SB1")
			          dbSetOrder(1)
			          dbSeek(xFilial("SB1")+aItens[y,2])
			          if aItens[y,9] == "1"
				          if lx == aItens[y,1]
						      if aItens[y,1]
						      	  aItens[y,1] := .f.
							   	  nAchou := Ascan(aVetMem,{|x| x[1] == aItens[y,2]})
							      if nAchou > 0
								   	  aDel(aVetMem,nAchou)
									  aSize(aVetMem,Len(aVetMem)-1)
									  if Len(aVetMem) == 0
									     aVetMem  := {{"","","",0,0,0,0,0}}
									  Endif
							  	  Endif
							   Else
				    			  aItens[y,1] := .t.
					   			  dbSelectArea("SB1")
						   		  dbSetOrder(1)
		   						  dbSeek(xFilial("SB1")+aItens[y,2])
						   		  if Empty(aVetMem[1,1])
					   			     aVetMem := {}
							   	  Endif
			  					  cFormul := FS_FORMULA()
					  		   	   nPosVet := Ascan(aVetMem,{|x| x[1] == aItens[y,2]})
							   	   if nPosVet == 0
									  Aadd(aVetMem,{aItens[y,2],aItens[y,3],aItens[y,4],nQtdIte,FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.),nPercDesc,nVlrDesc,nVlrLiq*nQtdIte})
								   Endif
							  Endif
		   	  			  Endif
		   	  		   Endif
			       Next
			    Endif
		   Else
		      if aItens[oLbitem:nAt,1]
		      	  aItens[oLbitem:nAt,1] := .f.
			   	  nAchou := Ascan(aVetMem,{|x| x[1] == aItens[oLbitem:nAt,2]})
			      if nAchou > 0
				   	  aDel(aVetMem,nAchou)
					  aSize(aVetMem,Len(aVetMem)-1)
					  if Len(aVetMem) == 0
					     aVetMem  := {{"","","",0,0,0,0,0}}
					  Endif
			  	  Endif
			   Else
			      aItens[oLbitem:nAt,1] := .t.
			   	  dbSelectArea("SB1")
			   	  dbSetOrder(1)
	   			  dbSeek(xFilial("SB1")+aItens[oLbitem:nAt,2])
			   	  if Empty(aVetMem[1,1])
			   	     aVetMem := {}
			   	  Endif
	   			  cFormul := FS_FORMULA()
	  		   	  nPosVet := Ascan(aVetMem,{|x| x[1] == aItens[oLbitem:nAt,2]})
	    	   	  if nPosVet == 0
					  Aadd(aVetMem,{aItens[oLbitem:nAt,2],aItens[oLbitem:nAt,3],aItens[oLbitem:nAt,4],nQtdIte,FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.),nPercDesc,nVlrDesc,nVlrLiq*nQtdIte})
				  Endif
			  Endif
		   Endif
	   Else
 		   cFormul := FS_FORMULA()
	   	   Aadd(aItens,{.f.,SB1->B1_COD,SB1->B1_CODITE,SB1->B1_FABRIC,substr(SB1->B1_DESC,1,100),nQtdI,"0","","",0,0,FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)})
		   nQtdI += 1
	       nLin := Len(aItens)
		   if aItens[nLin,1]
		      aItens[nLin,1] := .f.
		   	  nAchou := Ascan(aVetMem,{|x| x[1] == aItens[nLin,2]})
		      if nAchou > 0
			   	  aDel(aVetMem,nAchou)
				  aSize(aVetMem,Len(aVetMem)-1)
				  if Len(aVetMem) == 0
				     aVetMem  := {{"","","",0,0,0,0,0}}
				  Endif
		  	  Endif
		   Else
		      aItens[nLin,1] := .t.
		   	  dbSelectArea("SB1")
		   	  dbSetOrder(1)
		   	  dbSeek(xFilial("SB1")+aItens[nLin,2])
		   	  if Empty(aVetMem[1,1])
		   	     aVetMem := {}
		   	  Endif
  		   	  nPosVet := Ascan(aVetMem,{|x| x[1] == aItens[nLin,2]})
    	   	  if nPosVet == 0
				  Aadd(aVetMem,{aItens[nLin,2],aItens[nLin,3],aItens[nLin,4],nQtdIte,FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.),nPercDesc,nVlrDesc,nVlrLiq*nQtdIte})
			  Endif
		   Endif
	   Endif
	Endif
Endif
if !lKit
	if lAchou
		oAltReg:End()
	Endif
Endif
Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ FS_APLICACAO ³ Autor ³ Thiago  	        ³ Data ³ 13/12/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Aplicacao da peca.	   						 		       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Oficina                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//Static Function FS_APLICACAO()
//Local cAplicacao := ""
//
//if nListbox == 1
//
//	SetKey(VK_F3,Nil)
//
//	if !Empty(aItens[oLbitem:nAt,2])
//		dbSelectArea("SB1")
//		dbSetOrder(1)
//		dbSeek(xFilial("SB1")+aItens[oLbitem:nAt,2])
//
//	   If SB1->(FieldPos("B1_DESC2")) > 0
//      	  cAplicacao := Alltrim(SB1->B1_DESC)+" "+SB1->B1_DESC2
//       Else
//      	  cAplicacao := Alltrim(SB1->B1_DESC)
//       Endif
//	Else
//		cAplicacao := ""
//	Endif
//	DEFINE MSDIALOG oDlg8 FROM 000,000 TO 020,070 TITLE "Aplicacao da peca" OF oMainWnd
//
//	DEFINE SBUTTON FROM 125,240 TYPE 1 ACTION oDlg8:End() ENABLE OF oDlg8
//
//	@ 008,010 GET oMsg2 VAR cAplicacao OF oDlg8 MEMO SIZE 258,110 PIXEL READONLY MEMO FONT (TFont():New('Courier New',0,-13,.T.,.T.))
//
//
//	ACTIVATE MSDIALOG oDlg8 CENTER
//
//	SETKEY(VK_F3,{|| FS_APLICACAO() })
//
//Endif
//
//Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ FS_FOTO ³ Autor ³ Thiago      	        ³ Data ³ 14/12/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Exibe foto/video.	   						 		       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Oficina                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_FOTO()

SetKey(VK_F6,Nil)
if Len(aItens) <> 0
	OFIXC003(aItens[oLbitem:nAt,2])
Endif
SETKEY(VK_F6,{|| FS_FOTO() })

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ FS_CODBAR ³ Autor ³ Thiago               ³ Data ³ 14/12/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Pesquisa por codigo de barra.				 		       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Oficina                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_CODBARRA(cOrcam)
Local cQAlSB1 := "SQLSB1"

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+aItens[oLbitem:nAt,02])
nVlrLiq := FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)-nVlrDesc
If !Empty(cCodbar)
	cQuery := "SELECT SB1.B1_CODBAR FROM "+RetSqlName("SB1")+" SB1 WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_CODBAR='"+cCodBar+"' AND SB1.D_E_L_E_T_=' '"
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cQAlSB1, .F., .T. )

    if Empty(( cQAlSB1 )->B1_CODBAR)
       MsgStop("Produto não encontrado!")
		oCodBar:SetFocus()
	   (cQAlSB1)->(dbCloseArea())
		dbSelectArea("SB1")
    Else
		oLbitem:SetFocus()
    	(cQAlSB1)->(dbCloseArea())
		dbSelectArea("SB1")
       FS_FILTRO(cCodPro,"4",cOrcam)
    Endif

	cFoco := "0"
Else
	oLbitem:SetFocus()
	cFoco := "0"
    Return(.t.)
Endif

//OC009PREPEC("",Alltrim(cCodbar))
//FS_PESQUISAR()
//oGetPCons:oBrowse:Refresh()
cCodbar := space(TamSx3("B1_CODBAR")[1])
dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+aItens[oLbitem:nAt,2])
if cListbox == 2
	nVlrDesc := 0
	nPercDesc := 0
	nVlrLiq := FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)-nVlrDesc
Endif
Return(.t.)

Static Function FS_MEMORIA()
Local i := 0

if Len(aVetMem) == 1 .and. Empty(aVetMem[1,1])
   MsgStop("Não há produto selecionado!")
   Return(.f.)
Endif
DEFINE MSDIALOG oDlg5 TITLE "" From 9,0 to 40,105 of oMainWnd STYLE DS_MODALFRAME

oDlg5:lEscClose := .F.

SetKey(VK_F8,Nil)
SETKEY(VK_F8,{|| FS_FECHATELA() })

@ 001,001  LISTBOX oLbox5 FIELDS HEADER "Cód.Produto","Cód.Fabricante","Nome do Fabricante","Quantidade","Preço","%Desconto","Vlr do Desconto","Valor Total" COLSIZES 40,40,100,35,45,45,45,45 SIZE 413,210 OF oDlg5 PIXEL
oLbox5:SetArray(aVetMem)
oLbox5:bLine := { || { aVetMem[oLbox5:nAt,01],;
                       aVetMem[oLbox5:nAt,02],;
                       aVetMem[oLbox5:nAt,03],;
                       transform(aVetMem[oLbox5:nAt,04],"99999"),;
                       transform(aVetMem[oLbox5:nAt,05],"@E 999,999.99"),;
                       transform(aVetMem[oLbox5:nAt,06],"@E 999.99")+"%",;
                       transform(aVetMem[oLbox5:nAt,07],"@E 999,999.99"),;
                       transform(aVetMem[oLbox5:nAt,08],"@E 9,999,999.99")}}

nTotPec  := 0
nTotDesc := 0
nTotLiq  := 0
For i:= 1 to Len(aVetMem)
    nTotPec  += aVetMem[i,5]
    nTotDesc += aVetMem[i,7]
    nTotLiq  += aVetMem[i,8]
Next

@ 220,010 SAY "F8-Volta " OF oDlg5   PIXEL COLOR CLR_RED
@ 220,080 SAY "Total Peças:     " OF oDlg5   PIXEL
@ 220,120 SAY transform(nTotPec,"@E 9,999,999.99") OF oDlg5   PIXEL COLOR CLR_RED
@ 220,0180 SAY "Total Descontos: " OF oDlg5   PIXEL
@ 220,0230 SAY transform(nTotDesc,"@E 9,999,999.99") OF oDlg5   PIXEL COLOR CLR_RED
@ 220,0280 SAY "Total Líquido:  " OF oDlg5   PIXEL
@ 220,0320 SAY transform(nTotLiq,"@E 9,999,999.99") OF oDlg5   PIXEL COLOR CLR_RED

ACTIVATE MSDIALOG oDlg5 CENTER

Return(.t.)

Static Function FS_FECHATELA()
SetKey(VK_F8,Nil)
SETKEY(VK_F8,{|| FS_MEMORIA() })
oDlg5:End()
Return(.t.)

Static Function FS_PARAM(cOrcam,lZera)

Default lZera := .f.

cSair := "0"
nVlrDesc := 0
nPercDesc := 0
nVlrLiq := 0

FS_LIMPAPECA(lZera,cOrcam)

oLbox1:Refresh()
oMsg:Refresh()
oMsg1:Refresh()
oLbitem:Refresh()

MONTATELA(cOrcam)


Return(.t.)

Static Function MONTATELA(cOrcam)

Local aObjects := {} , aPosObj := {} , aPosObjApon := {} , aInfo := {}//
Local aSizeAut := MsAdvSize(.F.)  // Tamanho Maximo da Janela (.t.=TOOLBAR,.f.=SEM TOOLBAR)
Local nCntFor := 0
cCliente  := space(TamSx3("A1_NOME")[1])

SetAtalhos(0)	// Limpa
SetAtalhos(2,cOrcam)	// Configura para a tela de parametros

//aItens := {{.f.,"","","",""}}
//aPedPen := {{"","","",0,0,0}}
//cCodbar    := space(TamSx3("B1_CODBAR")[1])
//nVlrDesc := 0
//nVlrLiq := 0
//nPercDesc := 0
cCodPro := space(TamSx3("B1_COD")[1])
aObjects := {}
cCodFab := space(TamSx3("B1_CODITE")[1])
//cNomFab := space(TamSx3("A2_NREDUZ")[1])
cNomFab := space(TamSx3("B1_FABRIC")[1])
//cNomencla := space(TamSx3("BM_DESC")[1])
cNomencla := space(TamSx3("B1_DESC")[1])
cFamilia   := space(TamSx3("X5_DESCRI")[1])
cClasse   := space(TamSx3("X5_DESCRI")[1])
cSClasse   := space(TamSx3("X5_DESCRI")[1])
//cModelo   := space(TamSx3("VV2_DESMOD")[1])
//cAno      := space(4)
//cMarca    := space(TamSx3("VE1_DESMAR")[1])
cKit      := space(10)
cGrupo    := space(4)
cVeiculo  := space(TamSx3("VV1_CHASSI")[1])
cAno      := cAnoOld
cMarca    := cMarcOld
cModelo   := cModOld
//cAplic    := space(30)
AAdd( aObjects, { 000, 149 , .T. , .F. } )//cabecalho
// Fator de reducao 80%
for nCntFor := 1 to Len(aSizeAut)
	aSizeAut[nCntFor] := INT(aSizeAut[nCntFor] * 0.5)
next
aInfo := {aSizeAut[1] , aSizeAut[2] , aSizeAut[3] , aSizeAut[4] , 2 , 2 }
aPos  := MsObjSize (aInfo, aObjects,.F.)
oLbitem:SetFocus()

DEFINE MSDIALOG oDlgCon TITLE "Consulta de peças" From 014,000 TO 455,532 of oMainWnd PIXEL STYLE DS_MODALFRAME
oDlgCon:lEscClose := .F.

@ aPos[1,1]+008,aPos[1,2]+015 SAY "Cliente: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+008,aPos[1,2]+069 MSGET oCliente VAR cCliente VALID FS_POSSA1() PICTURE "@!" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+023,aPos[1,2]+015 SAY "Cód.Produto: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+023,aPos[1,2]+069 MSGET oCodPro VAR cCodPro VALID iif(!Empty(cCodPro), FS_CODPRO(cCodPro,"11",cOrcam),.t.) PICTURE "@!" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+038,aPos[1,2]+015 SAY "Cód.Fabricante: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+038,aPos[1,2]+069 MSGET oCodFab VAR cCodFab  PICTURE "@!" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+053,aPos[1,2]+015 SAY "Nome Fabricante: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+053,aPos[1,2]+069 MSGET oNomFab VAR cNomFab VALID FS_TELARESU("1") PICTURE "@!" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+068,aPos[1,2]+015 SAY "Nomenclatura: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+068,aPos[1,2]+069 MSGET oNomencla VAR cNomencla VALID FS_TELARESU("2") PICTURE "@!" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

//@ aPos[1,1]+74,aPos[1,2]+020 SAY STR0013 OF oDlgCon   PIXEL COLOR CLR_BLUE
//@ aPos[1,1]+74,aPos[1,2]+074 MSGET oFamilia VAR cFamilia Valid FS_FAMILIA() PICTURE "@!" F3 "V7" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+083,aPos[1,2]+015 SAY "Familia: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+083,aPos[1,2]+069 MSGET oFamilia VAR cFamilia PICTURE "@!" VALID FS_TELARESU("8") SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+098,aPos[1,2]+015 SAY "Classe do Produto: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+098,aPos[1,2]+069 MSGET oClasse VAR cClasse PICTURE "@!" VALID FS_TELARESU("3") SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+113,aPos[1,2]+015 SAY "SubClasse Produto: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+113,aPos[1,2]+069 MSGET oSClasse VAR cSClasse PICTURE "@!" VALID FS_TELARESU("9") SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+128,aPos[1,2]+015 SAY "Veículo: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+128,aPos[1,2]+069 MSGET oVeiculo VAR cVeiculo VALID FS_VALVEI() PICTURE "@!" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+143,aPos[1,2]+015 SAY "Modelo: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+143,aPos[1,2]+069 MSGET oModelo VAR cModelo PICTURE "@!" VALID FS_TELARESU("4") SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+158,aPos[1,2]+015 SAY "Ano: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+158,aPos[1,2]+069 MSGET oAno VAR cAno PICTURE "@!" SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE

@ aPos[1,1]+173,aPos[1,2]+015 SAY "Marca: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+173,aPos[1,2]+069 MSGET oMarca VAR cMarca PICTURE "@!" VALID FS_TELARESU("5") WHEN Empty(cModelo) SIZE 150,8 OF oDlgCon PIXEL COLOR CLR_BLUE


@ aPos[1,1]+188,aPos[1,2]+015 SAY "Kit: " OF oDlgCon   PIXEL COLOR CLR_BLUE
@ aPos[1,1]+188,aPos[1,2]+069 BUTTON oKit  PROMPT "..." OF oDlgCon SIZE 20,08 PIXEL ACTION ( FS_KIT(cOrcam,,,"10") )

//@ aPos[1,1]+150,aPos[1,2]+115 SAY "Aplicação" OF oDlgCon   PIXEL COLOR CLR_BLUE
//@ aPos[1,1]+165,aPos[1,2]+015 MSGET oAplic VAR cAplic VALID iif(!Empty(cAplic),FS_TELARESU("6"),.t.) PICTURE "@!" SIZE 205,8 OF oDlgCon PIXEL COLOR CLR_BLUE


@ aPos[1,1]+205,aPos[1,2]+075 SAY "F2-Sai          F7-Limpa          F10-Consulta" OF oDlgCon   PIXEL COLOR CLR_RED


ACTIVATE MSDIALOG oDlgCon CENTER


Return(.t.)

Static Function FS_LIMPATELA()
cCodPro := space(TamSx3("B1_COD")[1])
cCodFab := space(TamSx3("B1_CODITE")[1])
//cNomFab := space(TamSx3("A2_NREDUZ")[1])
cNomFab := space(TamSx3("B1_FABRIC")[1])
//cNomencla := space(TamSx3("BM_DESC")[1])
cNomencla := space(TamSx3("B1_DESC")[1])
cFamilial := space(TamSx3("X5_DESCRI")[1])
cClasse   := space(TamSx3("X5_DESCRI")[1])
cSClasse  := space(TamSx3("X5_DESCRI")[1])
cModelo   := space(TamSx3("VV2_DESMOD")[1])
cAno      := space(4)
cMarca    := space(TamSx3("VE1_DESMAR")[1])
cCliente  := space(TamSx3("A1_NOME")[1])     
cCliBkp   := cCliente
cVeiculo := space(TamSx3("VV1_CHASSI")[1])
cVeiBkp   := cVeiculo
cKit      := space(10)
cGrupo    := space(4)
//cAplic    := space(30)
Return(.t.)


Static Function FS_SAIRTELA(cOrcam)

SetAtalhos(0)	// Limpa atalhos
SetAtalhos(1,cOrcam)	// Seta atalhos para tela principal


cSair    := "1"
cFabBkp  := ""
cNomBkp  := ""
cFamBkp  := ""
cClaBkp  := ""
cSClaBkp := ""
cModBkp  := ""
cMarBkp  := ""
cAnoOld  := cAno
cMarcOld := cMarca
cModOld  := cModelo
oDlgCon:End()

Return(.t.)

Static Function FS_VALLIN(cProduto,nOp)

cFormul := FS_FORMULA()


    if Empty(cProduto)
       Return(.t.)
    Endif   
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProduto)
    nValPec := FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)
	if nOp == "1"
	    if nValPec <> 0
			nValItem := FtDescItem( nValPec,;			//ExpN1: Preco de lista aplicado o desconto de cabecalho
			nValPec,; 			//ExpN2: Preco de Venda
			1,;				//ExpN3: Quantidade vendida
			nValPec,;			//ExpN4: Valor Total (do item)
			@nPercDesc,;           	//ExpN5: Percentual de desconto
			@nVlrDesc,;			//ExpN6: Valor do desconto
			@nVlrDesc,;			//ExpN7: Valor do desconto original
			2)	//ExpN8: Tipo de Desconto (1 % OU 2 R$)
		Endif
	    if nValPec <> 0
			nVlrLiq := nValItem
		Else
			nVlrLiq := 0
		Endif
		if nVlrDesc > 0
//		    oVlrLiq:SetFocus()
		Endif
	Elseif nOp == "2"
	    if nValPec <> 0
			nValItem := FtDescItem( nValPec,;			//ExpN1: Preco de lista aplicado o desconto de cabecalho
			nValPec,; 			//ExpN2: Preco de Venda
			1,;				//ExpN3: Quantidade vendida
			nValPec,;			//ExpN4: Valor Total (do item)
			@nPercDesc,;           	//ExpN5: Percentual de desconto
			@nVlrDesc,;			//ExpN6: Valor do desconto
			@nVlrDesc,;			//ExpN7: Valor do desconto original
			1)	//ExpN8: Tipo de Desconto (1 % OU 2 R$)
		Endif
	    if nValPec <> 0
			nVlrLiq := nValItem
		Else
			nVlrLiq := 0
		Endif
		if nPercDesc == 0
//	   	    oVlrLiq:SetFocus()
	   	Endif
	Else
//		nPercDesc := 0
//		nVlrDesc  := 0
	 	nVlrLiq := FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)-nVlrDesc
	Endif











nVlrBrut := FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)
oVlrDesc:Refresh()
oVlrPerc:Refresh()
oVlrLiq:Refresh()
oVlrBrut:Refresh()
Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ FS_EXPORTAR ³ Autor ³ Thiago             ³ Data ³ 17/12/12  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao³ Exporta itens da consulta para orçamento.	 		       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Oficina                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_EXPORTAR(cOrcam)
Local i := 0
Local nCntFor := 0
Local nCntFor2 := 0
Local nCntFor3 := 0
Local nPrv1 := 0    
Local cTpOrc := "         "
Local cAuxFilial
Private nVerParFat := 1   

aTpOrc := {"Orçamento Balcao","Orçamento Oficina"}  
DEFINE MSDIALOG oDlgOrc TITLE OemtoAnsi("Desconto do item") FROM  08.1,10.6 TO 12.4,43.3 OF oMainWnd
			
@ 004,005 SAY "Tp.Orçamento: " OF oDlgOrc   PIXEL COLOR CLR_BLUE
@ 004,050 MSCOMBOBOX oTpOrc VAR cTpOrc SIZE 70,33 ITEMS aTpOrc OF oDlgOrc PIXEL


DEFINE SBUTTON FROM 020,050 TYPE 1 ACTION oDlgOrc:End() ENABLE OF oDlgOrc
			
ACTIVATE MSDIALOG oDlgOrc CENTER

if Type("M->VS1_GETKEY") <> "U"
	if !Empty(cVeiculo) .and. !Empty(M->VS1_GETKEY)
		if Alltrim(cVeiculo) <> M->VS1_GETKEY
		   MsgInfo("Item não pode ser exportado pois ja existe itens no orçamento aplicado em outro veículo.")
		   Return(.f.)
		Endif
	Endif                         
Endif
if !Empty(cCliente)
	dbSelectArea("SA1")
	dbSetOrder(2)
	dbSeek(xFilial("SA1")+Alltrim(cCliente))
	if Type("M->VS1_CLIFAT") <> "U"
		if !Empty(M->VS1_CLIFAT) .and. !Empty(M->VS1_LOJA) 
			if Alltrim(SA1->A1_COD)+Alltrim(SA1->A1_LOJA) <> M->VS1_CLIFAT+M->VS1_LOJA
			   If !MsgYesNo("Cliente aplicado esta diferente do informado no orçamento, Deseja continuar e atualizar orçamento?.")
			      Return(.f.)
			   Endif   
			Endif
		Endif
	Endif
Endif
cAnoOld  := cAno
cModOld  := cModelo
cMarcOld := cMarca
if Empty(aVetMem[1,1])
   MsgStop("Não há peças selecionadas para exportação!")
   Return(.f.)
Endif
cBkpFilial := cFilAnt
If cOrcam <> "1"
	cAuxFilial := FWPesqSM0("M0_CODFIL",cEmpAnt)
	If Empty(cAuxFilial)
		Return(.f.)
	EndIf
	cFilant := cAuxFilial
Endif
For i:= 1 to Len(aVetMem)
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aVetMem[i,1])
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+aVetMem[i,1])
	nSdoPecB2 := 0
	While !eof() .and. xFilial("SB2")+SB1->B1_COD == SB2->B2_FILIAL+SB2->B2_COD
		nSdoPecB2 += SB2->B2_QATU
		dbSkip()
	Enddo
	DbSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD)
	If Round(aVetMem[i,5],2) < Round(SB2->B2_CM1,2) .and. nSdoPecB2 > 0
		MsgStop("Valor de Venda do Produto é menor que o Custo Medio da Mercadoria!"+CHR(10)+CHR(13)+" Produto: "+SB1->B1_GRUPO+" - "+SB1->B1_CODITE)
	   Return(.f.)
	Endif
Next
if cOrcam <> "1"
	cNumOrc := GetSXENum("VS1","VS1_NUMORC")
	dbSelectArea("VS1")
	Reclock("VS1",.t.)
	VS1->VS1_FILIAL := xFilial("VS1")
	VS1->VS1_NUMORC := cNumOrc
	VS1->VS1_DATORC := dDataBase
	VS1->VS1_STATUS := "0"
	VS1->VS1_DATVAL := dDataBase+GetNewPar("MV_DTLIMIT",0)
	if cTpOrc == "Orçamento Oficina"
		VS1->VS1_TIPORC := "2"
	Else
		VS1->VS1_TIPORC := "1"
	Endif	
 	VS1->VS1_FORPAG := cCond
	cFormul := FS_FORMULA()
	VS1->VS1_FORMUL := &(cFormul)   
	if cTpOrc == "Orçamento Oficina"
	    VV1->(dbSetOrder(2))
	    VV1->(dbSeek(xFilial("VV1")+Alltrim(cVeiculo)))
		VS1->VS1_CHAINT := VV1->VV1_CHAINT
	Endif
	if !Empty(cCliente)
		dbSelectArea("SA1")
		dbSetOrder(2)
		dbSeek(xFilial("SA1")+Alltrim(cCliente))
		VS1->VS1_CLIFAT := SA1->A1_COD
		VS1->VS1_LOJA   := SA1->A1_LOJA
    Endif
	dbSelectArea("VAI")
	DBSetOrder(4)
	dbSeek(xFilial("VAI")+__cUserID)
	VS1->VS1_CODVEN := VAI->VAI_CODVEN
	If VAI->VAI_TIPVEN $ "1/3" // Varejo
		VS1->VS1_TIPVEN := "1" //VAREJO
	ElseIf VAI->VAI_TIPVEN == "2" // Atacado
		VS1->VS1_TIPVEN := "2" //ATACADO
	EndIf
	MsUnlock()
	If ExistFunc("OA3700011_Grava_DTHR_Status_Orcamento")
		OA3700011_Grava_DTHR_Status_Orcamento( VS1->VS1_NUMORC , VS1->VS1_STATUS , "Consulta Detalhada de Peças" ) // Grava Data/Hora na Mudança de Status do Orçamento
	EndIf
	nSeq := 1
	For i:= 1 to Len(aVetMem)
		dbSelectArea("VS3")
		Reclock("VS3",.t.)
		VS3->VS3_FILIAL := xFilial("VS3")
		VS3->VS3_NUMORC := cNumOrc
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aVetMem[i,1])
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+aVetMem[i,1])
		VS3->VS3_SEQUEN := strzero(nSeq,3)
		VS3->VS3_GRUITE := SB1->B1_GRUPO
		VS3->VS3_CODITE := SB1->B1_CODITE
		VS3->VS3_QTDITE := aVetMem[i,4]
		cCodTes := FM_PRODSBZ(SB1->B1_COD,"SB1->B1_TS")
		VS3->VS3_CODTES := cCodTes
		VS3->VS3_LOCAL := SB1->B1_LOCPAD
		VS3->VS3_FORMUL := VS1->VS1_FORMUL
		VS3->VS3_VALPEC := aVetMem[i,5]*aVetMem[i,4]


		nPrv1 := FM_PRODSBZ(SB1->B1_COD,"SB1->B1_PRV1")

		nValItem := FtDescItem( nPrv1,;			//ExpN1: Preco de lista aplicado o desconto de cabecalho
								nPrv1,; 		//ExpN2: Preco de Venda
								1,;				//ExpN3: Quantidade vendida
								nPrv1,;			//ExpN4: Valor Total (do item)
								@nPercDesc,;	//ExpN5: Percentual de desconto
								@nVlrDesc,;		//ExpN6: Valor do desconto
								@nVlrDesc,;		//ExpN7: Valor do desconto original
								2)	//ExpN8: Tipo de Desconto (1 % OU 2 R$)

		VS3->VS3_VALTOT := aVetMem[i,8]
		VS3->VS3_VALDES := aVetMem[i,7]
		VS3->VS3_PERDES := aVetMem[i,6]
		if GetNewPar("MV_MIL0002","0") == "1"
			if VS3->(FieldPos("VS3_PECKIT")) > 0
		   	   nPosKit := Ascan(aKit,{|x| x[1]+x[2] == SB1->B1_GRUPO+ SB1->B1_CODITE})
	           if nPosKit > 0
		           dbSelectArea("VE8")
    		       dbSetOrder(1)
        		   dbSeek(xFilial("VE8")+aKit[nPosKit,7]+SB1->B1_GRUPO+SB1->B1_CODITE)
				   if VE8->VE8_TIPO == "1"
						VS3->VS3_PECKIT := "1"
				   Else
				   	   VS3->VS3_PECKIT := "0"
				   Endif
				Else
			   	   VS3->VS3_PECKIT := "0"
				Endif
			Endif
		Endif
		MsUnlock()
		nSeq += 1
	Next
	ConfirmSX8()

	dbSelectArea("VS1")

	// Limpa todos os Atalhos ...
	SetAtalhos(0)
	oDlg1:End()
	OFIXX001(,,,4)
	cFilAnt := cBkpFilial
	aVetMem := {{"","","",0,0,0,0,0}}
///	aVetMem  := {{"","","",0,0,0,0,0}}
    aItens  := {{.f.,"","","","",0,"0","","",0,0,0}}
	// Chama as tala de parametros ...
//	FS_PARAM(cOrcam,.t.)
	FS_CONSULTA("","",cOrcam)

Else
    if GetNewPar("MV_VERIORC","OFIXC001") $ "OFIXC008"
		SETKEY(VK_F7,{|| OFIXC008("1") })
	Endif
	if Len(aVetMem) > 0
		lOX001Auto := .t.
		lPrimLinha := .t.
//		if !Empty(oGetPecas:aCols[oGetPecas:nAt,FG_POSVAR("VS3_CODITE","aHeaderP")])
//			// adiciona a linha com os valores default
//			AADD(oGetPecas:aCols,Array(nUsadoPX01+1))
//			oGetPecas:aCols[Len(oGetPecas:aCols),nUsadoPX01+1]:=.F.
//			For nCntFor2:=1 to nUsadoPX01
//				oGetPecas:aCols[Len(oGetPecas:aCols),nCntFor2]:=CriaVar(aHeaderP[nCntFor2,2])
//			Next
//			oGetPecas:nAt := Len(oGetPecas:aCols)
//			n := Len(oGetPecas:aCols)
//		endif
		for nCntFor := 1 to Len(aVetMem)
			// verifica se o item já foi lancado no orcamento
			lAchouUm := .f.
			lAchou := .f.
			for nCntFor2 := 1 to Len(oGetPecas:aCols)
				// pula itens deletados
				if !oGetPecas:aCols[nCntFor2,Len(oGetPecas:aCols[nCntFor2])]
					// se o item já foi lançado no orçamento deve-se apenas alterar a quantidade
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+aVetMem[nCntFor,1])
					if SB1->B1_GRUPO == oGetPecas:aCols[nCntFor2,FG_POSVAR("VS3_GRUITE","aHeaderP")] .and.;
						SB1->B1_CODITE == oGetPecas:aCols[nCntFor2,FG_POSVAR("VS3_CODITE","aHeaderP")]
						lAchou := .t.
						// salva valores da acols para restauração
						nAtual := oGetPecas:nAt
						oGetPecas:nAt := nCntFor2
						n := nCntFor2
						// monta as variáveis de memória
						For nCntFor3:=1 to Len(aHeaderP)
   							&("M->"+aHeaderP[nCntFor3,2]) := oGetPecas:aCols[oGetPecas:nAt,nCntFor3]
						next
						// atualiza quantidade
						M->VS3_QTDITE := aVetMem[nCntFor,4] + oGetPecas:aCols[nCntFor2,FG_POSVAR("VS3_QTDITE","aHeaderP")]
						// executa o fieldok com os valores posicionados
						__ReadVar := "M->VS3_QTDITE"
						OX001FPOK(.f.)
						// restaura a posição anterior da acols
						oGetPecas:nAt := nAtual
						n := nAtual
						lAchouUm := .t.
						exit
					endif
				endif
			next
			if !lAchou
				if !Empty(oGetPecas:aCols[oGetPecas:nAt,FG_POSVAR("VS3_CODITE","aHeaderP")])
					// adiciona a linha com os valores default
				AADD(oGetPecas:aCols,Array(nUsadoPX01+1))
					oGetPecas:aCols[Len(oGetPecas:aCols),nUsadoPX01+1]:=.F.
					For nCntFor2:=1 to nUsadoPX01
						oGetPecas:aCols[Len(oGetPecas:aCols),nCntFor2]:=CriaVar(aHeaderP[nCntFor2,2])
					Next
					oGetPecas:nAt := Len(oGetPecas:aCols)
					n := Len(oGetPecas:aCols)
				endif
			 Endif
			// se o item sofreu alteração de quantidade (já lançado) faz o loop
			if lAchouUm
				loop
			endif
			// quando o item é lançado pela primeira vez ele deve ocupar o lugar do item atual (kit)
			// caso contrário deve-se criar uma nova linha
			if !lPrimLinha
			    if !Empty(oGetPecas:aCols[oGetPecas:nAt,FG_POSVAR("VS3_CODITE","aHeaderP")])
					// adiciona a linha com os valores default
					AADD(oGetPecas:aCols,Array(nUsadoPX01+1))
					oGetPecas:aCols[Len(oGetPecas:aCols),nUsadoPX01+1]:=.F.
					For nCntFor2:=1 to nUsadoPX01
						oGetPecas:aCols[Len(oGetPecas:aCols),nCntFor2]:=CriaVar(aHeaderP[nCntFor2,2])
					Next
					oGetPecas:nAt := Len(oGetPecas:aCols)
					n := Len(oGetPecas:aCols)
				Endif
			endif
			// monta o vetor com os itens necessários

			aVetCmp := {}
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+aVetMem[nCntFor,1])
			aAdd(aVetCmp,{"VS3_GRUITE",SB1->B1_GRUPO,M->VS3_GRUITE} )
			aAdd(aVetCmp,{"VS3_CODITE",SB1->B1_CODITE,M->VS3_CODITE} )
			aAdd(aVetCmp,{"VS3_FORMUL",M->VS1_FORMUL,       M->VS1_FORMUL} )
//			aAdd(aVetCmp,{"VS3_PERDES",aVetMem[nCntFor,6],  M->VS3_PERDES} )
 //			aAdd(aVetCmp,{"VS3_VALDES",aVetMem[nCntFor,7],  M->VS3_VALDES} )
//			aAdd(aVetCmp,{"VS3_QTDITE",aVetMem[nCntFor,4],  M->VS3_QTDITE} )
//			aAdd(aVetCmp,{"VS3_VALPEC",aVetMem[nCntFor,8],  M->VS3_VALPEC} )
			cCodTes := FM_PRODSBZ(SB1->B1_COD,"SB1->B1_TS")
			if M->VS1_TIPORC == "2"
				DBSelectArea("SB1")
				DBSetOrder(1)
				DBSeek(xFilial("SB1")+aVetMem[nCntFor,1])
				DBSetOrder(1)
				DBSelectArea("VOI")
				DBSetOrder(1)
				DBSeek(xFilial("VOI")+M->VS1_TIPTEM)
				if !Empty(VOI->VOI_CODOPE)
					cTesCmp :=  MaTesInt(2,VOI->VOI_CODOPE,M->VS1_CLIFAT,M->VS1_LOJA,"C",SB1->B1_COD)
					aAdd(aVetCmp,{"VS3_CODTES",cTesCmp,M->VS3_CODTES} )
				Else
					aAdd(aVetCmp,{"VS3_CODTES",cCodTes,M->VS3_CODTES} )
				endif
				M->VS1_GETKEY := cVeiculo
				M->VS1_CLIFAT := SA1->A1_COD
				M->VS1_LOJA   := SA1->A1_LOJA
			else
				M->VS1_CLIFAT := SA1->A1_COD
				M->VS1_LOJA   := SA1->A1_LOJA
				aAdd(aVetCmp,{"VS3_CODTES",cCodTes,M->VS3_CODTES} )
			endif
			aAdd(aVetCmp,{"VS3_QTDITE",aVetMem[nCntFor,4],M->VS3_QTDITE} )
			aAdd(aVetCmp,{"VS3_PERDES",aVetMem[nCntFor,6],M->VS3_PERDES} )
			aAdd(aVetCmp,{"VS3_VALDES",aVetMem[nCntFor,7],M->VS3_VALDES} )
//			aAdd(aVetCmp,{"VS3_PERDES",(1-(((aItensKit[nCntFor,6]*nValKit)/100)/aItensKit[nCntFor,5]))*100,M->VS3_PERDES} )
			RegToMemory("VS3",.t.)
			// faz o laço para cada item, preenchendo os valores e chamando o FieldOk
			for nCntFor2 := 1 to Len(aVetCmp)
				&("M->"+aVetCmp[nCntFor2,1] ) := aVetCmp[nCntFor2,2]
				__ReadVar := "M->"+aVetCmp[nCntFor2,1]
				if !OX001FPOK(.f.)
					// se o fieldok retornar falso deve-se restaurar a linha anterior (primeira linha) ou exluir a linha (demais linhas)
					if !lPrimLinha
						aSize(oGetPecas:aCols,Len(oGetPecas:aCols)-1)
						For nCntFor3:=1 to Len(aHeaderP)
							&("M->"+aHeaderP[nCntFor3,2]) := oGetPecas:aCols[Len(oGetPecas:aCols),nCntFor3]
						next
					else
						M->VS3_GRUITE := aVetCmp[1,3]
						M->VS3_CODITE := aVetCmp[2,3]
						M->VS3_CODTES := aVetCmp[3,3]
						M->VS3_QTDITE := aVetCmp[4,3]
					endif
					oGetPecas:nAt := Len(oGetPecas:aCols)
					exit
				endif
			next
			lPrimLinha := .f.
		next
		M->VS1_CHASSI := cVeiculo
		// caso ainda esteja na primeira linha significa que todas os itens já estavam no orçamento ou nenhum item deu certo
//		if lPrimLinha .and. Len(oGetPecas:aCols) > 0
//			aSize(oGetPecas:aCols,Len(oGetPecas:aCols)-1)
//		endif
		// zera o aItensKit e atualiza os valores de tela e acols
//		aItensKit := {}
		oGetPecas:nAt := Len(oGetPecas:aCols)
		n := oGetPecas:nAt
		lOX001Auto := .f.
		OX001ATUF1()
		oGetPecas:oBrowse:refresh()
		oDlg1:End()
		return .t.
	Endif
Endif

Return(.t.)

//Static Function FS_SENHA()
//Local cUsuario := space(20)
//Local cSenha   := space(10)

//DEFINE MSDIALOG oDlg6 TITLE "" From 9,0 to 18,25 of oMainWnd

//@ 010,007 SAY "Usuário: " OF oDlg6   PIXEL COLOR CLR_BLUE
//@ 010,030 MSGET oUsuario VAR cUsuario PICTURE "@!" SIZE 60,8 OF oDlg6 PIXEL COLOR CLR_BLUE

//@ 025,007 SAY "Senha: " OF oDlg6   PIXEL COLOR CLR_BLUE
//@ 025,030 MSGET oSenha VAR cSenha PICTURE "@!" SIZE 60,8 OF oDlg6 PIXEL COLOR CLR_BLUE

//DEFINE SBUTTON FROM 050,25 TYPE 1 ACTION oDlg6:End() ENABLE OF oDlg6
//DEFINE SBUTTON FROM 050,55 TYPE 2 ACTION oDlg6:End() ENABLE OF oDlg6

//ACTIVATE MSDIALOG oDlg6 CENTER

//Return(.t.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FS_SENHA  ºAutor  ³Manoel              º Data ³  28/11/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o usuario pode importar orcamento com peca na   º±±
±±º          ³garantia                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Oficina                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FS_SENHA(nLin)

Local cSSenha   := Substr(cUsuario,1,15)
Local OGetSenha
Local oDlgSenha
Local lRet      := .f.
Local cSenhaSup := Space(15)
Local cBitMap   := "LOGIN"
cAutGar := Space(15)

DEFINE DIALOG oDlgSenha TITLE OemToAnsi("Visualizar Tabela de Preços") FROM 20, 20 TO 225,310 PIXEL // Autorizacao de superior

@ 0, 0 BITMAP oBmp RESNAME cBitMap oF oDlgSenha SIZE 50,140 NOBORDER WHEN .F. PIXEL

@ 10,55 SAY OemToAnsi("Usuario")	PIXEL						                   // Caixa Atual
@ 20,55 MSGET cAutGar PIXEL SIZE 80,08

@ 50,55 SAY OemToAnsi("Senha") PIXEL                                          // Senha Superior
@ 60,55 MSGET oGetSenha VAR cSenhaSup PASSWORD PIXEL SIZE 40,08 VALID FS_VALSENHA(cSenhaSup)

DEFINE SBUTTON FROM 85,75  TYPE 1 ACTION If(FS_VALUSUARIO(cSenhaSup,nLin),(lRet := .t.,oDlgSenha:End()),.f.) ENABLE OF oDlgSenha
DEFINE SBUTTON FROM 85,105 TYPE 2 ACTION oDlgSenha:End() ENABLE OF oDlgSenha

ACTIVATE MSDIALOG oDlgSenha CENTERED

// Restaura usuario de login.
PswOrder(3)
PswSeek(cSSenha)

Return(lRet)

Static Function FS_VALSENHA(cSenhax)

// Senha
PswOrder(3)

if !Empty(cSenhax)
	If PswSeek(cSenhax)

	   cUsu_Aut_Gar := PswRet(1)[1][2]
	   cAutGar := PswRet(1)[1][2]

	   Return(.t.)

	EndIf
Endif
Help("  ",1,"NOSENHA")

Return(.f.)


Static Function FS_VALUSUARIO(cSenhax ,nLin)

dbSelectArea("VAI")
dbSetOrder(3)
if dbSeek(xFilial("VAI")+Alltrim(cAutGar))
   if VAI->VAI_TIPTEC == "1"

		FS_FILPREC(nLin,"3",aItens[oLbitem:nAt,02])
		SetKey(VK_F9,Nil)
		SETKEY(VK_F9,{|| FS_ATUASENHA(nLin) })
     	Return( .t. )

   Else

		MsgStop("Usuario nao autorizado")
		Return( .f. )

   Endif
Else

	MsgStop("Usuario nao autorizado")
	Return( .f. )

Endif

Return(.t.)

Static Function FS_ATUASENHA(nLin)
FS_FILPREC(nLin,"1",aItens[oLbitem:nAt,02])
SetKey(VK_F9,Nil)
SETKEY(VK_F9,{|| FS_SENHA(oLbitem:nAt) })
Return(.t.)

Static Function FS_FECHA()
if !MsgYesNo("Deseja sair da tela de consulta de peças?")
    Return(.f.)
Endif
oDlg1:End()
SetKey(VK_F12,Nil)
Return(.t.)

Static Function FS_MUDAFOCO()

if cFoco == "0"
   cFoco := "1"
   oLbox1:SetFocus()
Else
   cFoco := "0"
	oLbitem:SetFocus()
Endif
if nListbox == 1
	FS_FILPREC(oLbitem:nAt,"1",aItens[oLbitem:nAt,02])
Else
	FS_FILPREC(oLbox1:nAt,"1",aPedPen[oLbox1:nAt,01])
Endif	
if nListbox == 1
	nAchou := Ascan(aVetMem,{|x| Alltrim(x[2]) == Alltrim(aItens[oLbitem:nAt,02])})
    if nAchou > 0
		nVlrDesc := aVetMem[nAchou,7]
		nPercDesc := aVetMem[nAchou,6]
	Else
		nVlrDesc := 0
		nPercDesc := 0
	Endif
	if Len(aItens) == 1 .and. Empty(aItens[1,2])
		nVlrLiq := 0
	Else
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aItens[oLbitem:nAt,02])
		nVlrLiq := FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)-nVlrDesc
	Endif
    oLbitem:SetArray(aItens)
	oLbitem:bLine := { || { IIf(aItens[oLbitem:nAt,01],o_Verd,o_Verm),;
							aItens[oLbitem:nAt,02],;
							aItens[oLbitem:nAt,03],;
							aItens[oLbitem:nAt,04],;
	 						transform(aItens[oLbitem:nAt,10],"@E 999.99")+"%",;
 							transform(aItens[oLbitem:nAt,11],"@E 999,999,999.99"),;
	 						transform(aItens[oLbitem:nAt,12],"@E 999,999,999.99"),;
 							aItens[oLbitem:nAt,5]}}
    oLbitem:Refresh()
Else
	nVlrDesc := 0
	nPercDesc := 0
	if !Empty(aPedPen[oLbox1:nAt,01])
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aPedPen[oLbox1:nAt,01])
		nVlrLiq := FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)-nVlrDesc
	Else
		nVlrLiq := 0
	Endif
    oLbox1:SetArray(aPedPen)
    oLbox1:bLine := { || { aPedPen[oLbox1:nAt,01],;
    aPedPen[oLbox1:nAt,02],;
    aPedPen[oLbox1:nAt,03],;
    FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,04],"@E 99999")),;
    FG_AlinVlrs(transform(aPedPen[oLbox1:nAt,05],"@E 999,999.99")),;
    FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,06],"@E 99999"))}}
    oLbox1:Refresh()
Endif
oMsg:Refresh()
oMsg1:Refresh()
Return(.t.)

Static Function FS_LIMPAVLR(cProduto,nLin)



	nAchou := Ascan(aVetMem,{|x| Alltrim(x[1]) == Alltrim(cProduto)})
    if nAchou > 0
		nVlrDesc := aVetMem[nAchou,7]
		nPercDesc := aVetMem[nAchou,6]
	Endif
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+cProduto)
	if Len(aItens) == 1 .and. Empty(aItens[1,2])
		nVlrLiq := 0
	Else
		nVlrLiq := FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)-nVlrDesc
	Endif
	oVlrDesc:Refresh()
	oVlrPerc:Refresh()
	oVlrLiq:Refresh()

if nListbox == 1
	aPedPen := {{"","","",0,0,0}}
	oLbox1:SetArray(aPedPen)
	oLbox1:bLine := { || { aPedPen[oLbox1:nAt,01],;
	aPedPen[oLbox1:nAt,02],;
	aPedPen[oLbox1:nAt,03],;
	FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,04],"@E 99999")),;
	FG_AlinVlrs(transform(aPedPen[oLbox1:nAt,05],"@E 999,999.99")),;
	FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,06],"@E 99999"))}}
	oLbox1:Refresh()
Endif
cMsg  := ""
cMsg1 := ""      
if nListbox == 1
	FS_FILPREC(nLin,"1",aItens[nLin,02])
Else
	FS_FILPREC(nLin,"1",aPedPen[oLbox1:nAt,01])
Endif	
oMsg:Refresh()
oMsg1:Refresh() 
if nListbox == 1
	OC009ITEREL("2",aItens[nLin,02])
Endif	
Return(.t.)

Static Function FS_FILTRO(cCod,cOpcao,cOrcam)
FS_GERA(cCod,cOpcao,cOrcam)
Return(.t.)

Static Function FS_GERA(cCod,cOpcao,cOrcam)

Local cAliasSB1 := "SQLSB1"
Local lRet := .t.
Local i := 0

Local cX5Familia
Local cX5Classe
Local cX5SubCla
Local cAuxCodMar
Local cAuxCodMod

cAnoOld  := cAno
cMarcOld := cMarca
cModOld  := cModelo

ProcRegua(8)
IncProc("Finalizando arquivo!")
IncProc("Finalizando arquivo!")
 IncProc("Finalizando arquivo!")
IncProc("Finalizando arquivo!")

lAchouIt := .f.
if (cOpcao == "10" .or. cOpcao == "11") .and. Len(aKit) > 0
   For i := 1 to Len(aKit)
		if Empty(aItens[1,2])
		   aItens := {}
		Endif
		dbSelectArea("SB1")
		dbSetOrder(7)
		dbSeek(xFilial("SB1")+aKit[i,1]+aKit[i,2])
		nAchou := Ascan(aItens,{|x| Alltrim(x[2]) == Alltrim(SB1->B1_COD)})
		if nAchou > 0
		   if aItens[nAchou,7] == "0"
		      aItens[nAchou,7] := "1"
		   Endif
		   if aItens[nAchou,9] == ""
		      aItens[nAchou,9] := "1"
		   Endif
		   if GetNewPar("MV_MIL0002","0") == "1"
	           dbSelectArea("VE8")
    	       dbSetOrder(1)
        	   dbSeek(xFilial("VE8")+aKit[i,7]+SB1->B1_GRUPO+SB1->B1_CODITE)
	           if VE8->VE8_TIPO == "1"
			      aItens[nAchou,8] := aKit[i,7]
			   Endif
           Endif
		Endif
		lAchouIt := .t.
		if nAchou > 0
			Loop
		Endif
		if GetNewPar("MV_MIL0002","0") == "1"
           dbSelectArea("VE8")
           dbSetOrder(1)
           dbSeek(xFilial("VE8")+aKit[i,7]+SB1->B1_GRUPO+SB1->B1_CODITE)
           if VE8->VE8_TIPO == "1"
	    	   Aadd(aItens,{.f.,SB1->B1_COD,aKit[i,2],SB1->B1_FABRIC,SB1->B1_DESC,nQtdI,"1",aKit[i,7],"1",0,0,FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)})
	       Else
	    	   Aadd(aItens,{.f.,SB1->B1_COD,aKit[i,2],SB1->B1_FABRIC,SB1->B1_DESC,nQtdI,"1","","1",0,0,FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)})
	       Endif
	    Else
			Aadd(aItens,{.f.,SB1->B1_COD,aKit[i,2],SB1->B1_FABRIC,SB1->B1_DESC,nQtdI,"0","","",0,0,FG_VALPEC(,GETMV("MV_FMLPECA"),SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)})
	    Endif
		nQtdI += 1
	Next
Else
	if Empty(cCod) .and. Empty(cCodFab) .and. Empty(cNomFab) .and. Empty(cNomencla) .and. Empty(cFamilia) .and. Empty(cClasse) .and. Empty(cSClasse) .and. Empty(cModelo) .and. Empty(cAno) .and. Empty(cMarca) .and. Empty(cKit) .and. Empty(cCodBar)
	   Return(.t.)
	Endif

	If !Empty(cFamilia)
		cX5Familia := FM_SQL("SELECT X5_CHAVE FROM " + RetSQLName("SX5") + " WHERE X5_FILIAL = '" + xFilial("SX5") + "' AND X5_TABELA = 'V7' AND X5_DESCRI = '" + cFamilia + "' AND D_E_L_E_T_ = ' '")
	EndIf
	If !Empty(cClasse)
		cX5Classe := FM_SQL("SELECT X5_CHAVE FROM " + RetSQLName("SX5") + " WHERE X5_FILIAL = '" + xFilial("SX5") + "' AND X5_TABELA = 'V8' AND X5_DESCRI = '" + cClasse + "' AND D_E_L_E_T_ = ' '")
	EndIf
	If !Empty(cSClasse)
		cX5SubCla := FM_SQL("SELECT X5_CHAVE FROM " + RetSQLName("SX5") + " WHERE X5_FILIAL = '" + xFilial("SX5") + "' AND X5_TABELA = 'V9' AND X5_DESCRI = '" + cSClasse + "' AND D_E_L_E_T_ = ' '")
	EndIf

	if !Empty(cMarca)
		cAuxCodMar := FM_SQL("SELECT VE1_CODMAR FROM "+RetSqlName("VE1")+" VE1 WHERE VE1.VE1_FILIAL = '" + xFilial("VE1") + "' AND VE1.VE1_DESMAR = '"+cMarca+"' AND VE1.D_E_L_E_T_ = ' ' ")
	Endif

	cQuery := "SELECT DISTINCT SB1.B1_COD,SB1.B1_CODITE,SB1.B1_PROC,SB1.B1_GRUPO,SB1.B1_DESC, SB1.B1_FABRIC "
	If SB1->(FieldPos("B1_DESC2")) > 0
		cQuery += ",SB1.B1_DESC2 "
	Endif
	cQuery += "FROM "
	cQuery += RetSqlName( "SB1" ) + " SB1 "
	If SB1->(FieldPos("B1_FORALI")) > 0
		cQuery += " LEFT JOIN "+RetSqlName("SB2")+" SB2 ON SB2.B2_FILIAL = '" + xFilial("SB2") + "' AND SB2.B2_COD = SB1.B1_COD AND SB2.D_E_L_E_T_ = ' ' "
	Endif
	if !Empty(cFamilia) .or. !Empty(cClasse) .or. !Empty(cSClasse) .or. !Empty(cModelo) .or. !Empty(cAno)
		cQuery += " INNER JOIN "+RetSqlName("VE3")+" VE3 ON VE3.VE3_FILIAL = '" + xFilial("VE3") + "'"
		cQuery +=   " AND VE3.VE3_GRUITE = SB1.B1_GRUPO "
		cQuery +=   " AND VE3.VE3_CODITE = SB1.B1_CODITE AND "
		if !Empty(cAuxCodMar)
			cQuery += "VE3.VE3_CODMAR = '" + cAuxCodMar + "' AND "
		endif
		if !Empty(cModelo)
		    dbSelectArea("VV2")
		    dbSetOrder(6)
		    dbSeek(xFilial("VV2")+Alltrim(cModelo))
		    cModVei := VV2->VV2_MODVEI
			cQuery += "VE3.VE3_MODVEI = '" + cModVei + "' AND "
		Endif
		if !Empty(cFamilia)
			cQuery += "VE3.VE3_FAMILI = '" + cX5Familia + "' AND "
		Endif
		if !Empty(cClasse)
			cQuery += "VE3.VE3_CLASSE = '" + cX5Classe + "' AND "
		Endif
		if !Empty(cSClasse)
			cQuery += "VE3.VE3_SUBCLA = '" + cX5SubCla + "' AND "
		Endif
		if !Empty(cAno)
			cQuery += " VE3.VE3_ANOINI <= '"+Alltrim(cAno)+"' AND VE3.VE3_ANOFIN >= '"+Alltrim(cAno)+"' AND "
		Endif
		cQuery += "VE3.D_E_L_E_T_ = ' ' "
	Endif
	cQuery += "WHERE "
	cQuery += "SB1.B1_FILIAL='"+ xFilial("SB1")+ "' AND SB1.B1_COD <> ' ' AND "
	if !Empty(cCodFab)
		cQuery += "SB1.B1_CODITE = '"+cCodFab+"' AND "
	Endif
	if !Empty(cNomencla)
		cQuery += "SB1.B1_DESC = '"+cNomencla+"' AND "
	Endif
	if !Empty(cNomFab)
		cQuery += "SB1.B1_FABRIC = '"+cNomFab+"' AND "
	Endif
	if cOpcao == "1"
		if !Empty(cCod)
			cQuery += "SB1.B1_COD = '"+cCod+"' AND "
		Endif
	Elseif cOpcao == "3"
		if !Empty(cCodPro)
			cQuery += "SB1.B1_COD = '"+cCodPro+"' AND "
		Endif
	Elseif cOpcao == "4"
		if !Empty(cCodbar)
			cQuery += "SB1.B1_CODBAR = '"+cCodbar+"' AND "
		Endif
	Endif
	If SB1->(FieldPos("B1_FORALI")) > 0
		cQuery += "((SB1.B1_FORALI = 'S' AND SB2.B2_QATU > 0) OR (SB1.B1_FORALI <> 'S')) AND "
	Endif
	if !Empty(cNomFab)
		cQuery += "SB1.B1_FABRIC = '"+cNomFab+"' AND "
	Endif
	cQuery += "SB1.D_E_L_E_T_=' '"
	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSB1, .T., .T. )
	IncProc("Finalizando arquivo!")
	IncProc("Finalizando arquivo!")
	Do While !( cAliasSB1 )->( Eof() )

		if Empty(aItens[1,2])
		   aItens := {}
		Endif
		nAchou := Ascan(aItens,{|x| Alltrim(x[2]) == Alltrim(( cAliasSB1 )->B1_COD)})
		lAchouIt := .t.
		if nAchou > 0
			dbSelectArea(cAliasSB1)
				( cAliasSB1 )->(dbSkip())
			Loop
		Endif
		Aadd(aItens,{.f.,( cAliasSB1 )->B1_COD,( cAliasSB1 )->B1_CODITE,( cAliasSB1 )->B1_FABRIC,( cAliasSB1 )->B1_DESC,nQtdI,"0","","",0,0,FG_VALPEC(,GETMV("MV_FMLPECA"),( cAliasSB1 )->B1_GRUPO,( cAliasSB1 )->B1_CODITE,,.f.,.t.)})
		cGrupo := ( cAliasSB1 )->B1_GRUPO

		nQtdI += 1

		dbSelectArea(cAliasSB1)
		( cAliasSB1 )->(dbSkip())

	Enddo
	(cAliasSB1)->(dbCloseArea())
Endif

IncProc("Finalizando arquivo")
IncProc("Finalizando arquivo!")
Asort(aItens,,,{|x,y| x[6] > y[6] } )
oLbitem:nAt := 1
FS_VALLIN(aItens[oLbitem:nAt,02],"0")       
FS_FILPREC(1,"1",aItens[oLbitem:nAt,02])
OC009ITEREL("2",aItens[oLbitem:nAt,02])
//if cOpcao <> "10" .and. cOpcao <> "11"
//	(cAliasSB1)->(dbCloseArea())
//Endif
dbSelectArea("SB1")
if Len(aItens) == 1 .and. Empty(aItens[1,2]) .or. !lAchouIt
   MsgStop("Não há itens para esta pesquisa!")
   lRet := .f.
   if cOpcao == "3"
	   Return(.f.)
	Endif
Endif

oLbitem:SetArray(aItens)
oLbitem:bLine := { || { IIf(aItens[oLbitem:nAt,01],o_Verd,o_Verm),;
						aItens[oLbitem:nAt,02],;
						aItens[oLbitem:nAt,03],;
						aItens[oLbitem:nAt,04],;
 						transform(aItens[oLbitem:nAt,10],"@E 999.99")+"%",;
 						transform(aItens[oLbitem:nAt,11],"@E 999,999,999.99"),;
 						transform(aItens[oLbitem:nAt,12],"@E 999,999,999.99"),;
 						aItens[oLbitem:nAt,5]}}
oLbitem:Refresh()
oLbitem:bGotFocus   := {|| nListbox := 1}

if cOpcao <> "11"
	if Empty(cCodBar)
		oDlgCon:End()
	Endif
Endif
if !lRet
	FS_PARAM(cOrcam)
Endif

cFabBkp := ""
cFamBkp := ""
cNomBkp := ""
cClaBkp := ""
cSClaBkp := ""
cModBkp := ""
cMarBkp := ""

SetAtalhos(0)
SetAtalhos(1,cOrcam)

Return(.t.)









Static Function MUDACPO()
clistbox := 1
Return(.t.)








Static Function MUDACPO1()
clistbox := 2
if cFoco == "1"
	oVlrDesc:Setfocus()
Endif
cFoco := "0"

Return(.t.)

Static Function FS_POSICIONA()

if clistbox == 2
   oLbox1:SetFocus()
Else
   oLbitem:SetFocus()
Endif

Return(.t.)


Static Function FS_LIMPAPECA(lZera,cOrcam)

Local i := 0

Default lZera := .f.

If lZera
	aItensClo := {{.f.,"","","","",0,"0","","",0,0,0}}
Else
	aItensClo := aClone(aItens)
EndIf
aItens  := {{.f.,"","","","",0,"0","","",0,0,0}}
aPedPen := {{"","","",0,0,0}}

cMsg      := ""
cMsg1     := ""
cCodbar   := space(TamSx3("B1_CODBAR")[1])
nVlrDesc  := 0
nVlrLiq   := 0
nPercDesc := 0
nQtdI     := 1

For i := 1 to Len(aItensClo)
	if aItensClo[i,1]
		if Len(aItens) == 1 .and. Empty(aItens[1,1])
			aItens := {}
		Endif
		Aadd(aItens,{.t.,aItensClo[i,2],aItensClo[i,3],aItensClo[i,4],aItensClo[i,5],nQtdI,aItensClo[i,7],aItensClo[i,8],aItensClo[i,9],aItensClo[i,10],aItensClo[i,11],aItensClo[i,12]})
		nQtdI += 1
	Endif
Next


oLbitem:SetArray(aItens)
oLbitem:bLine := { || { IIf(aItens[oLbitem:nAt,01],o_Verd,o_Verm),;
						aItens[oLbitem:nAt,02],;
						aItens[oLbitem:nAt,03],;
						aItens[oLbitem:nAt,04],;
 						transform(aItens[oLbitem:nAt,10],"@E 999.99")+"%",;
 						transform(aItens[oLbitem:nAt,11],"@E 999,999,999.99"),;
 						transform(aItens[oLbitem:nAt,12],"@E 999,999,999.99"),;
 						aItens[oLbitem:nAt,5]}}
oLbitem:bGotFocus   := {|| nListbox := 1}

oLbox1:SetArray(aPedPen)
oLbox1:bLine := { || { aPedPen[oLbox1:nAt,01],;
						aPedPen[oLbox1:nAt,02],;
						aPedPen[oLbox1:nAt,03],;
						FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,04],"@E 99999")),;
						FG_AlinVlrs(transform(aPedPen[oLbox1:nAt,05],"@E 999,999.99")),;
						FG_AlinVlrs(Transform(aPedPen[oLbox1:nAt,06],"@E 99999"))}}
oLbox1:bGotFocus   := {|| nListbox := 2}


Return(.t.)





// nTela = 0 - Limpa Todos os Atalhos ...
// nTela = 1 - Atalhos da tela principal
// nTela = 2 - Atalhos da tela de parametros do filtro
Static Function SetAtalhos(nTela,cOrcam)

Do Case
Case nTela == 0
	SetKey(VK_F2 ,NIL)
	SetKey(VK_F3 ,NIL)
	SetKey(VK_F4 ,NIL)
	SetKey(VK_F5 ,NIL)
	SetKey(VK_F6 ,NIL)
	SetKey(VK_F7 ,NIL)
	SetKey(VK_F8 ,NIL)
	SetKey(VK_F9 ,NIL)
	SetKey(VK_F10,NIL)
	SetKey(VK_F11,NIL)
	SetKey(VK_F12,NIL)
Case nTela == 1
	SETKEY(VK_F2,  &("{|| FS_PARAM('" + cOrcam + "') }") )
	SETKEY(VK_F4,  &("{|| FS_QUANT('" + cOrcam + "') }") )
	SETKEY(VK_F5,  {|| FS_MUDAFOCO() })
	SETKEY(VK_F6,  {|| FS_FOTO() })
	SETKEY(VK_F7,  {|| FS_LIMPAPECA() })
	SETKEY(VK_F8,  {|| FS_MEMORIA() })
	SETKEY(VK_F9,  {|| FS_SENHA(oLbitem:nAt) })
	SETKEY(VK_F11, &("{|| FS_EXPORTAR('" + cOrcam + "') }") )
	SETKEY(VK_F12, {|| FS_FECHA()})
	SETKEY(K_ALT_C,{ || Calculadora() } )
Case nTela == 2
	SETKEY(VK_F10,&("{|| FS_FILTRO(cCodPro,'3','" + cOrcam + "') }"))
	SETKEY(VK_F2, &("{|| FS_SAIRTELA('" + cOrcam + "') }"))
	SETKEY(VK_F7, {|| FS_LIMPATELA() })
End

Return

Static Function FS_CONDPGTO(cCond)

dbSelectArea("SE4")
dbSetOrder(1)
if dbSeek(xFilial("SE4")+cCond)
   cDescPgto := SE4->E4_DESCRI
Else
   MsgInfo("Não existe registro com este código, verifique!")
   Return(.f.)
Endif

FS_VALLIN(aItens[oLbitem:nAt,02],"0")

Return(.t.)

Static Function FS_FORMULA()
Local cFormul := ""

if SE4->(Fieldpos("E4_FORMVR")) <> 0
	if !Empty(cCond)
		dbSelectArea("VAI")
		DBSetOrder(4)
		dbSeek(xFilial("VAI")+__cUserID)
		dbSelectArea("SE4")
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+cCond)
		if VAI->VAI_TIPVEN $ "1" // Varejo
			if !Empty(SE4->E4_FORMVR)
				cFormul := '"'+SE4->E4_FORMVR+'"'
			Endif
		Elseif VAI->VAI_TIPVEN == "2" // Atacado
			if !Empty(SE4->E4_FORMAT)
				cFormul := '"'+SE4->E4_FORMAT+'"'
			Endif
		Elseif VAI->VAI_TIPVEN == "3" // Todos
			if !Empty(SE4->E4_FORMAT)
				cFormul := '"'+SE4->E4_FORMAT+'"'
		    Endif
			if !Empty(SE4->E4_FORMVR)
				cFormul := '"'+SE4->E4_FORMVR+'"'
		    Endif
		Endif
	Endif
	if Empty(cFormul)
		cFormul := GETMV("MV_FMLPECA")
	Endif
Endif

Return(cFormul)

Static Function FS_CODPRO(cCodPro,cOpcao,cOrcam)

dbSelectArea("SB1")
dbSetOrder(1)
if dbSeek(xFilial("SB1")+cCodPro)
	FS_KIT(cOrcam,SB1->B1_GRUPO,SB1->B1_CODITE,cOpcao)
	if Len(aKit) == 0
	    FS_FILTRO(cCodPro,"1",cOrcam)
	Else
		oDlgCon:End()
	Endif
Else
	MsgStop("Não há itens para esta pesquisa!")
	Return(.f.)
Endif
Return(.t.)

Static function FS_POSSA1()
Private cChassi := cCliente
if !Empty(cCliente)
	if Alltrim(cCliente) <> Alltrim(cCliBkp)
		if FG_POSVEI("cChassi",)
		   dbSelectArea("VV1")
		   dbSetOrder(2)
		   dbSeek(xFilial("VV1")+cChassi)
		   dbSelectArea("VV2")
		   dbSetOrder(1)
		   dbSeek(xFilial("VV2")+VV1->VV1_CODMAR+VV1->VV1_MODVEI)
		   dbSelectArea("SA1")
		   dbSetOrder(1)
		   dbSeek(xFilial("SA1")+VV1->VV1_PROATU+VV1->VV1_LJPATU)
	 	   DbSelectArea("VE1")
		   DBSetOrder(1)
		   DBSeek(xFilial("VE1")+VV1->VV1_CODMAR)
			cModelo  := VV2->VV2_DESMOD
			cVeiculo := VV1->VV1_CHASSI
			cMarca   := VE1->VE1_DESMAR
			cVeiBkp  := VV1->VV1_CHASSI
			cCliente := SA1->A1_NOME
			cAno     := substr(VV1->VV1_FABMOD,5,4)
			cCliBkp  := cCliente
		Else
			MsgInfo("Não existe veículo para este cliente.")
			cModelo  := space(TamSx3("VV2_DESMOD")[1])
			cVeiculo := space(TamSx3("VV1_CHASSI")[1])
			cMarca   := space(TamSx3("VE1_DESMAR")[1])
			cAno     := "    "
		Endif
	Endif
Endif
Return(.t.)


Static Function FS_VALVEI()

   if Alltrim(cVeiculo) <> Alltrim(cVeiBkp)
      if FG_POSVEI("cVeiculo",)
		   dbSelectArea("VV1")
		   dbSetOrder(2)
		   dbSeek(xFilial("VV1")+cVeiculo)
		   dbSelectArea("VV2")
		   dbSetOrder(1)
		   dbSeek(xFilial("VV2")+VV1->VV1_CODMAR+VV1->VV1_MODVEI)
		   dbSelectArea("SA1")
		   dbSetOrder(1)
		   dbSeek(xFilial("SA1")+VV1->VV1_PROATU+VV1->VV1_LJPATU)
	 	   DbSelectArea("VE1")
		   DBSetOrder(1)
		   DBSeek(xFilial("VE1")+VV1->VV1_CODMAR)
			cModelo  := VV2->VV2_DESMOD
			cVeiculo := VV1->VV1_CHASSI
			cMarca   := VE1->VE1_DESMAR
			cVeiBkp  := VV1->VV1_CHASSI
			cCliente := SA1->A1_NOME
			cAno     := substr(VV1->VV1_FABMOD,5,4)
			cCliBkp  := cCliente
		Else
			MsgInfo("Não existe veículo para este cliente.")
			cModelo  := space(TamSx3("VV2_DESMOD")[1])
			cVeiculo := space(TamSx3("VV1_CHASSI")[1])
			cMarca   := space(TamSx3("VE1_DESMAR")[1])
			cAno     := "    "
		Endif
	Endif
Return(.t.)

Static function FS_GRADES(nOpc)
Local y := 0   

if nOpc == "1"
	if aItens[oLbitem:nAt,11] == nVlrDesc
	   Return(.t.)
	Endif   
Endif
if nOpc == "2"
	if aItens[oLbitem:nAt,10] == nPercDesc
		oLbitem:SetFocus()
	   Return(.t.)
	Endif   
Endif
      

//	    if nValPec <> 0
//			nVlrLiq := nValItem
//		Else
//			nVlrLiq := 0
//		Endif
           
For y := 1 to Len(aItens)
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+aItens[y,2])
    cFormul := FS_FORMULA()

	nValPec := FG_VALPEC(,cFormul,SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)
    nPDesc := nPercDesc
    nVDesc := nVlrDesc
    if nOpc == "1"
	    if nValPec <> 0
			nValItem := FtDescItem( nValPec,;			//ExpN1: Preco de lista aplicado o desconto de cabecalho
			nValPec,; 			//ExpN2: Preco de Venda
			1,;				//ExpN3: Quantidade vendida
			nValPec,;			//ExpN4: Valor Total (do item)
			@nPDesc,;           	//ExpN5: Percentual de desconto
			@nVDesc,;			//ExpN6: Valor do desconto
			@nVDesc,;			//ExpN7: Valor do desconto original
			2)	//ExpN8: Tipo de Desconto (1 % OU 2 R$)
		Endif	
    Else
	    if nValPec <> 0
			nValItem := FtDescItem( nValPec,;			//ExpN1: Preco de lista aplicado o desconto de cabecalho
			nValPec,; 			//ExpN2: Preco de Venda
			1,;				//ExpN3: Quantidade vendida
			nValPec,;			//ExpN4: Valor Total (do item)
			@nPDesc,;           	//ExpN5: Percentual de desconto
			@nVDesc,;			//ExpN6: Valor do desconto
			@nVDesc,;			//ExpN7: Valor do desconto original
			1)	//ExpN8: Tipo de Desconto (1 % OU 2 R$)
		Endif
    Endif
	nVlrL := nValItem
    aItens[y,10] := nPDesc
    aItens[y,11] := nVDesc
    aItens[y,12] := nVlrL
	if aItens[y,1]     
		nAchou := Ascan(aVetMem,{|x| Alltrim(x[1]) == Alltrim(aItens[y,2])})
	    aVetMem[nAchou,6] := nPDesc
	    aVetMem[nAchou,7] := nVDesc
	    aVetMem[nAchou,8] := (nVlrL)*aVetMem[nAchou,4]
	Endif	
Next
oLbitem:Refresh()    
if nOpc == "2"
	oLbitem:SetFocus()
Endif	

Return(.t.)


Static Function FS_TELADES()     
nVlrD  := nVlrDesc
nPercD := nPercDesc
           
DEFINE MSDIALOG oDlgLog TITLE OemtoAnsi("Desconto do item") FROM  08.1,10.6 TO 17.4,45.3 OF oMainWnd

nVlr  := nVlrDesc			
nPerc := nPercDesc 
nVLiq := nVlrLiq 
                               
                          
cProdu := aItens[oLbitem:nAt,02]

@ 005,005 SAY "Produto: " OF oDlgLog   PIXEL COLOR CLR_BLUE
@ 005,055 MSGET oProd VAR cProdu  PICTURE "@!" SIZE 65,8 OF oDlgLog PIXEL COLOR CLR_BLUE When .f.

@ 018,005 SAY "Valor de Desconto: " OF oDlgLog   PIXEL COLOR CLR_BLUE
@ 018,055 MSGET oVlrD VAR nVlrDesc VALID FS_VALLIN(aItens[oLbitem:nAt,02],"1")  PICTURE "@E 999,999.99" SIZE 65,8 OF oDlgLog PIXEL COLOR CLR_BLUE

@ 029,005 SAY "% de Desconto: " OF oDlgLog   PIXEL COLOR CLR_BLUE
@ 029,055 MSGET oVlrP VAR nPercDesc VALID FS_VALLIN(aItens[oLbitem:nAt,02],"2") PICTURE "@E 999.99" SIZE 40,8 OF oDlgLog PIXEL COLOR CLR_BLUE

//@ 027,005 SAY "Valor Líquido: " OF oDlgLog   PIXEL COLOR CLR_BLUE
//@ 027,055 MSGET oVlrLiq VAR nVlrLiq VALID FS_POSICIONA() PICTURE "@E 999,999.99" SIZE 65,8 OF oDlgLog PIXEL COLOR CLR_BLUE
			
DEFINE SBUTTON FROM 049,050 TYPE 1 ACTION FS_GRAVA(nPercD,nVlrD) ENABLE OF oDlgLog
DEFINE SBUTTON FROM 049,080 TYPE 2 ACTION FS_CANCELA(nPerc,nVlr,nVLiq) ENABLE OF oDlgLog
			
ACTIVATE MSDIALOG oDlgLog CENTER

Return(.t.)

Static Function FS_GRAVA(nPercD,nVlrD,nOpc)

aItens[oLbitem:nAt,10] := nPercDesc
aItens[oLbitem:nAt,11] := nVlrDesc
aItens[oLbitem:nAt,12] := nVlrLiq
if aItens[oLbitem:nAt,1]     
	nAchou := Ascan(aVetMem,{|x| Alltrim(x[1]) == Alltrim(aItens[oLbitem:nAt,2])})
    aVetMem[nAchou,6] := nPercDesc
    aVetMem[nAchou,7] := nVlrDesc
    aVetMem[nAchou,8] := (nVlrLiq)*aVetMem[nAchou,4]
Endif	
oDlgLog:End()
Return(.t.)

Static Function FS_CANCELA(nPerc,nVlr)

nVlrDesc  := nVlr
nPercDesc := nPerc
nVlrLiq   := nVLiq 

oVlrDesc:Refresh()
oVlrPerc:Refresh()
oVlrLiq:Refresh()
                
oDlgLog:End()

Return(.t.)