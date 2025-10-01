// ษออออออออหออออออออป
// บ Versao บ 9      บ
// ศออออออออสออออออออผ

#Include "FWCOMMAND.CH"
#Include "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M_LCPCJD บ Autor ณ Manoel Filho       บ Data ณ  11/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Lucratividade de Pe็as                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ John Deere                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M_LCPCJD()
Local cB1_COD := ParamIXB[1] // Codigo do Produto
Private cCadastro   := "Simula็ใo de Venda de Pe็as"
//
Private aNewBot   := {{"IMPRESSAO"   ,{|| FS_Imprime() },"Impressใo/Excel"},;
{"IMPRESSAO"   ,{|| FS_Limpa(.t.) },"Limpar"}}
Default cB1_COD := ""
//
FS_SIMULA(cB1_COD)
//
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FS_SIMULAบ Autor ณ Manoel Filho       บ Data ณ  11/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Simulacao da Lucratividade da Oficina                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FS_SIMULA(cB1_COD)
//Local cProd     := ""
//Local ni        := 0
Local lOk       := .f.
//Local cQuery    := ""
//Local cQAlias   := "SQLVAI"
Local aObjects  := {} , aPos := {} , aInfo := {}
Local aSizeHalf := MsAdvSize(.t.)  // Tamanho Maximo da Janela (.t.=TOOLBAR,.f.=SEM TOOLBAR)
//
//Local aFilAtu    := FWArrFilAtu()
Local aSM0       := FS_Filiais()
Local cBkpFilAnt := cFilAnt
//
Private cGruFor := "04" // Grupo de Formulas que podem ser utilizadas nos orcamentos
//
Private aLCPCJD := {}
Private aParam  := {space(4),space(6),space(2),0,0,0,0,0,0,0,0,space(8),Space(2),Space(254),Ctod('')}
Private aProdut := {}
Private oVerd   := LoadBitmap( GetResources() , "BR_VERDE" )  // Selecionado
Private oVerm   := LoadBitmap( GetResources() , "BR_VERMELHO" ) // Nao Selecionado
//
Private cDesOpe := " "
Private nValAcr := 0
Private nValAcF := 0
Private nValPec := 0
Private nValTot := 0
Private nValCus := 0
Private nQtdPec := 0
Private nPerDes := 0
Private nValDes := 0
Private nImpost := 0
Private nImpICM := 0
Private nImpPIS := 0
Private nImpCOF := 0
Private nImpSOL := 0
Private nRessar := 0
Private nResICM := 0
Private nResSOL := 0
Private nDesOpe := 0
Private nCusFin := 0
//
Private nPercTot  := 0
Private nPercTotL := 0
//
Private cCodCli := ""
Private cCodLoj := ""
Private cNomCli := ""
Private cVended := ""
Private cNomVen := ""
Private cCondPg := ""
Private cDesFpg := ""
Private cForCus := ""
Private cDesFCu := ""
Private cForVda := ""
Private cDesFVd := ""
Private cCodPec := ""
Private cDesPec := ""
Private cCodTes := ""
Private cTipOpe := ""
//
Private bRefresh := { || .t. }                  // Variavel necessaria ao MAFISREF
//
Private lPriVez := .t.
//
Default cB1_COD := ""
//
aCols   := {}
aHeader := {}
aAdd(aHeader,{"1","C6_COD","@!",TamSx3("B1_COD")[1],TamSx3("B1_COD")[2],"","","C","TRB",""})
aAdd(aHeader,{"2","C6_QUANT","@!",TamSx3("D2_QUANT")[1],TamSx3("D2_QUANT")[2],"","","N","TRB",""})
aAdd(aHeader,{"3","C6_PRCVEN","@!",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","","N","TRB",""})
aAdd(aHeader,{"5","C6_VALMERC","@!",TamSx3("D2_PRCVEN")[1],TamSx3("D2_PRCVEN")[2],"","","N","TRB",""})
aAdd(aHeader,{"6","C6_DESCON","@!",TamSx3("D2_DESCON")[1],TamSx3("D2_DESCON")[2],"","","N","TRB",""})
aAdd(aHeader,{"7","C6_CODTES","@!",TamSx3("D2_TES")[1],TamSx3("D2_TES")[2],"","","C","TRB",""})
//
aInfo := { aSizeHalf[ 1 ], aSizeHalf[ 2 ],aSizeHalf[ 3 ] ,aSizeHalf[ 4 ], 3, 3 } // Tamanho total da tela
// Configura os tamanhos dos objetos
AAdd( aObjects, { 0 ,   0 , .T. , .T. } ) // Parametros / Produtivos
//AAdd( aObjects, { 0 ,   0 , .T. , .T. } ) // Totais
aPos := MsObjSize( aInfo, aObjects )
//
DbSelectArea("SA1")
//
FS_Limpa(.f.)
//
M->VS1_TIPORC := "1"
M->VS1_CLIFAT := ""
cFilSim :=  aSM0[ Ascan (aSM0 , { |x| left(x,len(cFilAnt)) == cFilAnt } ) ]
//
SETKEY(VK_F4,{|| LCPCKEYF4() })
//
DEFINE MSDIALOG oLCPCJD TITLE "Simula็ใo da Lucratividade de Pe็as" FROM aSizeHalf[7],0 TO aSizeHalf[6],aSizeHalf[5] OF oMainWnd PIXEL
oLCPCJD:lEscClose := .F.

oTPanelPar := TScrollBox():New( oLCPCJD , aPos[1,1] , aPos[1,2] , aPos[1,3] - aPos[1,1], 195, .t. , , .t. ) // aPos[1,4] - aPos[1,2]

@ 005,005 SAY "Filial" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 004,080  COMBOBOX oFilSim VAR cFilSim ITEMS aSM0 VALID Fs_ValidFil() SIZE 100,1 PIXEL OF OTPanelPar

@ 018,005 SAY "Cliente" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 017,080 MSGET oCodCli VAR cCodCli PICTURE "@!" F3 "SA1" VALID ( ( FG_Seek("SA1","cCodCli",1,.f.).and. FS_Valid() )) SIZE 40,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 017,130 MSGET oCodLoj VAR cCodLoj PICTURE "@!" VALID ( ( FG_Seek("SA1","cCodCli+cCodLoj",1,.f.) .and. FS_Valid() )) SIZE 20,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 030,080 MSGET oNomCli VAR cNomCli PICTURE "@!" SIZE 100,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 044,005 SAY "Vendedor" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 043,080 MSGET oVended VAR cVended PICTURE "@!" F3 "SA3" VALID Fs_Valid() SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 056,080 MSGET oNomVen VAR cNomVen PICTURE "@!" SIZE 100,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 070,005 SAY "Cond.Pagto" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 069,080 MSGET oCondPg VAR cCondPg PICTURE "@!" F3 "SE4" VALID Fs_Valid() SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 082,080 MSGET oDesFPg VAR cDesFPg PICTURE "@!" SIZE 100,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 096,005 SAY "C๓digo da Pe็a" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 095,080 MSGET oCodPec VAR cCodPec PICTURE "@!" F3 "SB1" VALID(FG_Seek("SB1","cCodPec") .and. FS_VALID()) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 108,080 MSGET oDesPec VAR cDesPec PICTURE "@!" SIZE 100,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 122,005 SAY "Tipo de Custo" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 121,080 MSGET oForCus VAR cForCus PICTURE "@!" F3 "VEG" VALID(FG_STRZERO("cForCus",6).and.FG_Seek("VEG","cForCus").and.VEG->VEG_GRUFOR==cGruFor .and. FS_Valid()) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 134,080 MSGET oDesFCu VAR cDesFCu PICTURE "@!" SIZE 100,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 148,005 SAY "Formula Venda" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 147,080 MSGET oForVda VAR cForVda PICTURE "@!" F3 "VEG" VALID(FG_STRZERO("cForVda",6).and.FG_Seek("VEG","cForVda").and.VEG->VEG_GRUFOR==cGruFor .and. FS_Valid()) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 160,080 MSGET oDesFVd VAR cDesFVd PICTURE "@!" SIZE 100,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 174,005 SAY "Tipo de Opera็ใo" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 173,080 MSGET oTipOpe VAR cTipOpe PICTURE "@!" F3 "DJ" VALID(FS_Valid()) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON
@ 186,080 MSGET oDesOpe VAR cDesOpe PICTURE "@!" SIZE 100,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 200,005 SAY "C๓digo do Tes" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 199,080 MSGET oCodTes VAR cCodTes PICTURE "@!" F3 "SF4" VALID(FS_Valid()) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ 213,005 SAY "Valor de Venda" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 212,080 MSGET oValPec VAR nValPec PICTURE "@E 999,999,999.99" VALID ( nValPec>=0 .and. FS_VALID() ) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ 226,005 SAY "Quantidade" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 225,080 MSGET oQtdPec VAR nQtdPec PICTURE "@E 99999.99" VALID ( nQtdPec>0 .and. FS_VALID() ) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ 239,005 SAY "Valor Total" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 238,080 MSGET oVlrTot VAR nValTot PICTURE "@E 999,999,999.99" SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON When .f.

@ 252,005 SAY "% de Desconto" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 251,080 MSGET oPerDes VAR nPerDes PICTURE "@E 999.99" VALID ( nPerDes>=0 .and. FS_VALID() ) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ 265,005 SAY "Valor do Desconto" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 264,080 MSGET oValDes VAR nValDes PICTURE "@E 999,999,999.99" VALID ( nValDes>=0 .and. FS_VALID() ) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ 278,005 SAY "Valor de Acr้scimo" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 277,080 MSGET oValAcr VAR nValAcr PICTURE "@E 999,999,999.99" VALID ( nValAcr>=0 .and. FS_VALID() ) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ 291,005 SAY "Despesas Operacionais" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 290,080 MSGET oDesOpe VAR nDesOpe PICTURE "@E 999,999,999.99" VALID ( nDesOpe>=0 .and. FS_VALID() ) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ 304,005 SAY "Custo Financeiro" OF oTPanelPar PIXEL COLOR CLR_BLACK
@ 303,080 MSGET oCusFin VAR nCusFin PICTURE "@E 999,999,999.99" VALID ( nCusFin>=0 .and. FS_VALID() ) SIZE 65,1 OF oTPanelPar PIXEL COLOR CLR_BLACK HASBUTTON

@ aPos[1,1],200 LISTBOX oLboxLC FIELDS HEADER "Simula็ใo da Lucratividade de Pe็as","Valor","%" COLSIZES 150,50,40            SIZE aPos[1,4]-201,aPos[1,3]-aPos[1,1] OF oLCPCJD PIXEL
oLboxLC:SetArray(aLCPCJD)
oLboxLC:bLine := { || { aLCPCJD[oLboxLC:nAt,1] ,;
FG_AlinVlrs(Transform(aLCPCJD[oLboxLC:nAt,02],"@E 9,999,999.99")) ,;
FG_AlinVlrs(Transform((aLCPCJD[oLboxLC:nAt,02]/nPercTot)*100,"@E 9999.99")+" %") }}

If !Empty(cB1_COD)
	cCodPec := cB1_COD
	__ReadVar := "cCodPec"
	FS_VALID()
EndIf
//


ACTIVATE MSDIALOG oLCPCJD ON INIT (EnchoiceBar(oLCPCJD,{|| IIf(.t.,( lOk := .t. , oLCPCJD:End() ) , lOk := .f. ) },{ || oLCPCJD:End()},,aNewBot))

cFilAnt := cBkpFilAnt

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FS_VALID บ Autor ณ Manoel             บ Data ณ  13/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao dos Parametros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FS_VALID()
Local lReproc := .f.
Local cEstEmp := GetMv("MV_ESTADO") // Estado da Empresa/Filial
Local cQuery  := ""
Local cSQLAlSD1 := "SQLSD1"

n := 1

If ReadVar() == "CCODCLI"
	DBSelectArea("SA1")
	DBSetOrder(1)
	If !DBSeek(xFilial("SA1")+cCodCli)
		Return .f.
	Endif
	cNomCli := SA1->A1_NREDUZ
	oNomCli:Refresh()
Endif

If ReadVar() == "CCODLOJ"
	DBSelectArea("SA1")
	DBSetOrder(1)
	If !DBSeek(xFilial("SA1")+cCodCli+cCodLoj)
		return .f.
	Else // Inicia o Fiscal
		If !MaFisFound('NF')
			MaFisIni(SA1->A1_COD,SA1->A1_LOJA,'C','N',SA1->A1_TIPO,MaFisRelImp("OF110",{"VS1","VS3"}))
		Else // se o fiscal esta ok apenas atualiza o cliente
			MaFisRef("NF_CODCLIFOR",,cCodCli)
			MaFisRef("NF_LOJA",,cCodLoj)
			lReproc := .t.
		Endif
	Endif
	M->VS1_CLIFAT := cCodCli
	cNomCli := SA1->A1_NREDUZ
	oNomCli:Refresh()
Endif

aCols := {{cCodPec,nQtdPec,nValPec, nValPec, nValDes,SB1->B1_TS}}

If ReadVar() == "CCODPEC" .or. (lReproc .And. !Empty(cCodPec))
	DbselectArea("SB1")
	DbsetOrder(1)
	If DbSeek(xFilial("SB1")+cCodPec)
		cDesPec := Alltrim(SB1->B1_GRUPO)+"-"+Alltrim(SB1->B1_CODITE)+" - "+Alltrim(SB1->B1_DESC)
		If Empty(cCodTes)
			cCodTes := SB1->B1_TS
		Endif
		If MaFisFound('NF')
			MaFisRef("IT_PRODUTO","VS300",SB1->B1_COD)
			MaFisRef("IT_TES","VS300",cCodTes)
			If nQtdPec > 0
				lReproc := .t.
			Endif
		EndIf
	Endif
Endif

If ReadVar() == "CTIPOPE" .or. (lReproc .And. !Empty(cTipOpe))
	If ! ExistCpo("SX5","DJ"+cTipOpe) .and. !Empty(cTipOpe)
		Return .f.
	Else
		cDesOpe := SX5->X5_DESCRI
		oDesOpe:Refresh()
		cCodtes := MaTesInt(2,cTipOpe,cCodCli,cCodLoj,"C",SB1->B1_COD)
		MaFisRef("IT_TES","VS300",cCodTes)
	Endif
	If nQtdPec > 0
		lReproc := .t.
	Endif
Endif

If ReadVar() == "CCODTES"
	If !ExistCpo("SF4",cCodTes)
		Return .f.
	Else
		MaFisRef("IT_TES","VS300",cCodTes)
		If nQtdPec > 0
			lReproc := .t.
		Endif
	Endif
Endif

If ReadVar() == "CFORCUS" .or. (lReproc .And. !Empty(cForCus))
	nValCus := FG_VALPEC(" ","cForCus",SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)
	If nQtdPec > 0
		lReproc := .t.
	Endif
	DbSelectArea("VEG")
	DbSetOrder(2)
	DbSeek(xFilial("VEG")+cGruFor+cForCus)
	cDesFCu := VEG->VEG_DESCRI
	oDesFCu:Refresh()
Endif
If ReadVar() == "CFORVDA" .or. (lReproc .And. !Empty(cForVda))
	nValPec := FG_VALPEC(" ","cForVda",SB1->B1_GRUPO,SB1->B1_CODITE,,.f.,.t.)
	If nQtdPec > 0
		lReproc := .t.
	Endif
	DbSelectArea("VEG")
	DbSetOrder(2)
	DbSeek(xFilial("VEG")+cGruFor+cForVda)
	cDesFVd := VEG->VEG_DESCRI
	oDesFVd:Refresh()
Endif

If ReadVar() == "NQTDPEC"
	MaFisRef("IT_QUANT","VS300",nQtdPec)
	lReproc := .t.
Endif

If ReadVar() == "NPERDES" .or. (lReproc .And. nQtdPec > 0)
	nValDes := (nValPec*(nPerDes/100)) * nQtdPec
	MaFisRef("IT_DESCONTO","VS300",nValDes)
Endif

If ReadVar() == "NVALDES" .or. (lReproc .And. nQtdPec > 0)
	nPerDes := ((nValDes/nQtdPec)/nValPec)*100
	MaFisRef("IT_DESCONTO","VS300",nValDes)
Endif

If ReadVar() == "NVALACR" .or. (lReproc .And. nQtdPec > 0)
	MaFisRef("NF_DESPESA",,nValAcr)
Endif

If ReadVar() == "CVENDED"
	DBSelectArea("SA3")
	DBSetOrder(1)
	DBSeek(xFilial("SA3")+cVended)
	cNomVen := SA3->A3_NOME
	oNomVen:Refresh()
Endif

If ReadVar() == "CCONDPG"
	DBSelectArea("SE4")
	DBSetOrder(1)
	DBSeek(xFilial("SE4")+cCondPg)
	cDesFPg := SE4->E4_COND
	oDesFPg:Refresh()
Endif

nValTot := 0
nImpICM := 0
nImpPIS := 0
nImpCOF := 0
nImpSOL := 0
If !Empty(cCodCli) .and. !Empty(cCodLoj) .and. !lPriVez .and. !Empty(cCodPec)
	MaFisRef("IT_PRCUNI","VS300",nValPec)
	nValTot := (MaFisRet(n,"IT_PRCUNI")*MaFisRet(n,"IT_QUANT")) //nQtdPec * nValPec
	MaFisRef("IT_VALMERC","VS300",nValTot)
	nImpICM := MaFisRet(n,"IT_VALICM")
	nImpPIS := MaFisRet(n,"IT_VALPS2")
	nImpCOF := MaFisRet(n,"IT_VALCF2")
	If  SF4->F4_SITTRIB  == "10" .or. SF4->F4_SITTRIB == "30" .or. SF4->F4_SITTRIB == "70"
		nImpSOL := MaFisRet(n,"IT_VALSOL")
	Endif
Endif
nImpost := ( nImpICM + nImpPIS + nImpCOF + nImpSOL )

nResICM := 0
nResSOL := 0
If ( nImpICM + nImpSOL ) > 0 // Houve Icms ST/OP na venda
	If cEstEmp <> SA1->A1_EST // Estado da Empresa/Filial esta diferente do Cliente
		If cEstEmp $ GetNewPar("MV_MIL0025","")+GetNewPar("MV_MIL0042","") // Estado da Empresa/Filial esta entre os Estados com Ressarcimentos
			cQuery := "SELECT SD1.D1_ICMSRET , SD1.D1_VALICM , SD1.D1_QUANT FROM "+RetSQLName("SD1")+" SD1 "
			cQuery += "JOIN "+RetSQLName("SF4")+" SF4 ON ( SF4.F4_FILIAL='"+xFilial("SF4")+"' AND SF4.F4_CODIGO=SD1.D1_TES AND ( SF4.F4_OPEMOV='01' OR SF4.F4_OPEMOV='03' ) AND SF4.D_E_L_E_T_=' ' ) "
			cQuery += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D1_COD='"+SB1->B1_COD+"' AND SD1.D1_DTDIGIT<='"+dtos(dDataBase)+"' AND SD1.D1_ICMSRET > 0 AND SD1.D_E_L_E_T_=' ' "
			cQuery += "ORDER BY SD1.D1_DTDIGIT DESC "
			dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cSQLAlSD1, .F., .T. )
			If !(cSQLAlSD1)->(Eof())
				nResICM := ( ( (cSQLAlSD1)->( D1_VALICM )  / (cSQLAlSD1)->( D1_QUANT ) ) * nQtdPec ) // ICMS OP (Ressar)
				nResSOL := ( ( (cSQLAlSD1)->( D1_ICMSRET ) / (cSQLAlSD1)->( D1_QUANT ) ) * nQtdPec ) // ICMS ST (Ressar)
			EndIf
			(cSQLAlSD1)->(dbCloseArea())
			DbSelectArea("SB1")
		EndIf
	EndIf
EndIf
nRessar := ( nResICM + nResSOL )

nValAcF := nValTot * (SE4->E4_ACRSFIN/100)

aLCPCJD[01,2]  := ( nValTot + nValAcr + nValAcF + nImpSOL) - nValDes
aLCPCJD[02,2]  := ( nValTot )
aLCPCJD[03,2]  := ( nValAcF )
aLCPCJD[04,2]  := ( nValAcr )
aLCPCJD[05,2]  := ( nValDes )
aLCPCJD[06,2]  := ( aLCPCJD[02,2] + aLCPCJD[04,2] - aLCPCJD[05,2] ) // Valor dos produtos + Acr้scimo - Desconto
aLCPCJD[07,2]  := ( nImpost )
aLCPCJD[08,2]  := ( nImpICM )
aLCPCJD[09,2]  := ( nImpPIS )
aLCPCJD[10,2]  := ( nImpCOF )
aLCPCJD[11,2]  := ( nImpSOL )
aLCPCJD[12,2]  := ( nRessar )
aLCPCJD[13,2]  := ( nResICM )
aLCPCJD[14,2]  := ( nResSOL )
aLCPCJD[15,2]  := ( aLCPCJD[01,2] + nRessar - aLCPCJD[07,2] )
aLCPCJD[16,2]  := ( nQtdPec * nValCus )
aLCPCJD[17,2]  := ( aLCPCJD[15,2] - aLCPCJD[16,2] )
aLCPCJD[18,2]  := ( nDesOpe )
aLCPCJD[19,2]  := ( aLCPCJD[17,2] * (SA3->A3_COMIS/100) )
aLCPCJD[20,2]  := ( aLCPCJD[17,2] - aLCPCJD[18,2] - aLCPCJD[19,2] )
aLCPCJD[21,2]  := ( nCusFin )
aLCPCJD[22,2]  := ( aLCPCJD[20,2] - aLCPCJD[21,2] )
aLCPCJD[23,2]  := ( aLCPCJD[20,2] - aLCPCJD[21,2] )

nPercTot  := ( aLCPCJD[01,2] )  // Percentual 100% - Bruto
nPercTotL := ( aLCPCJD[15,2] )  // Percentual 100% - Liquido

oLboxLC:nAt := 1
oLboxLC:SetArray(aLCPCJD)
oLboxLC:bLine := { || { aLCPCJD[oLboxLC:nAt,1] ,;
FG_AlinVlrs(Transform(aLCPCJD[oLboxLC:nAt,02],"@E 9,999,999.99")) ,;
FG_AlinVlrs(Transform((aLCPCJD[oLboxLC:nAt,02]/If(oLboxLC:nAt==23,nPercTotL,nPercTot))*100,"@E 9999.99")+" %") }}
oLboxLC:Refresh()

If MaFisFound('NF')
	lPriVez := .f.
EndIf

Return(.t.)

/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Funcao    | FS_Filiais | Autor |  Manoel             | Data | 13/09/13 |##
##+----------+------------+-------+-----------------------+------+----------+##
##|Descricao | Retorna as Filiais da Empresa                                |##
##+----------+--------------------------------------------------------------+##
##|Uso       | Veiculos                                                     |##
##+----------+--------------------------------------------------------------+##
###############################################################################
===============================================================================
*/
Static Function FS_Filiais()
Local nCntFor := 0
Local aSM0_1  := FWLoadSM0()
Local aSM0_2  := {}

For nCntFor := 1 to Len(aSM0_1)
	If aSM0_1[nCntFor,SM0_GRPEMP] == cEmpAnt
		aadd(aSM0_2,aSM0_1[nCntFor,SM0_CODFIL]+" - "+aSM0_1[nCntFor,SM0_NOMRED])
	Endif
Next

Return(aSM0_2)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FS_VALID บ Autor ณ Manoel             บ Data ณ  13/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao dos Parametros                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FS_VALIDFil()

If cFilAnt <> Left(cFilSim,Len(cFilAnt))
	cFilAnt := Left(cFilSim,Len(cFilAnt))
	Fs_Reproc() // reprocessa valores
	__ReadVar := "CFILSIM"
Endif

return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFS_REPROC บ Autor ณ Manoel             บ Data ณ  13/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ reprocessa Valores                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FS_REPROC()

If MaFisFound('NF')
	__ReadVar := "CCODLOJ"
	Fs_Valid()
	__ReadVar := "CCODPEC"
	Fs_Valid()
	__ReadVar := "CCODTES"
	Fs_Valid()
	__ReadVar := "CTIPOPE"
	Fs_Valid()
	__ReadVar := "NPERDES"
	Fs_Valid()
	__ReadVar := "NVALDES"
	Fs_Valid()
	__ReadVar := "NQTDPEC"
	Fs_Valid()
	__ReadVar := "NVALACR"
	Fs_Valid()
	__ReadVar := "CCONDPG"
	Fs_Valid()
Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFS_IMPRIME บ Autor ณ Manoel             บ Data ณ  13/09/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Impressใo                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FS_Imprime()

Local nCntFor := 0
Local aIntCab := {}
Local aIntIte := {}

aAdd(aIntCab,{"Descri็ao","C",85,"@!"})
aAdd(aIntCab,{"Valor","N",55,"@E 9,999,999.99"})
aAdd(aIntCab,{"Percentual","N",25,"@E 9999.99"})

for nCntFor := 1 to Len(aLCPCJD)
	aAdd(aIntIte,{aLCPCJD[nCntFor,1],aLCPCJD[nCntFor,2],(aLCPCJD[nCntFor,2]/aLCPCJD[If(nCntFor==23,15,1),2])*100})
Next

FGX_VISINT("M_LCPCJD" , "Pe็a - "+SB1->B1_GRUPO+" - "+SB1->B1_CODITE+" - "+SB1->B1_DESC , aIntCab , aIntIte , .t. )

return

/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Fun็ใo    |LCPCKEYF4   | Autor |  Manoel Filho         | Data | 17/09/13 |##
##+----------+------------+-------+-----------------------+------+----------+##
##|Descri็ใo | Chamada da tecla de atalho <F4>. Executa comandos dependen-  |##
##|          | do do campo selecionado ( ReadVar() ).                       |##
##+----------+--------------------------------------------------------------+##
###############################################################################
===============================================================================
*/
Static Function LCPCKEYF4()
Local lRetorno := .f.
//
if readvar() $ "CCODPEC"
	DBSelectArea("SB1")
	DBSetOrder(1)
	if DBSeek(xFilial("SB1")+cCodPec)
		lRetorno := OFIXC001(SB1->B1_COD)
	else
		lRetorno := OFIXC001(CCODPEC)
	endif
endif
SETKEY(VK_F4,{|| LCPCKEYF4() })
if lRetorno
	cCodPec := SB1->B1_COD
endif

Return


/*
===============================================================================
###############################################################################
##+----------+------------+-------+-----------------------+------+----------+##
##|Fun็ใo    |FS_Limpa    | Autor |  Manoel               | Data | 18/09/13 |##
##+----------+------------+-------+-----------------------+------+----------+##
##|Descri็ใo | Limpa conteudo das variaveis de tela e do Mapa       |##
##+----------+--------------------------------------------------------------+##
###############################################################################
===============================================================================
*/
Static Function FS_Limpa(lRefresh)
//
aLCPCJD := {}
//
aadd(aLCPCJD,{"Valor Bruto da Venda",0})                 // 01
aadd(aLCPCJD,{"Valor Total dos Produtos",0})             // 02
aadd(aLCPCJD,{"Valor de Acr้scimos Financeiros",0})      // 03
aadd(aLCPCJD,{"Valor de Acr้scimos",0})                  // 04
aadd(aLCPCJD,{"Valor de Desconto",0})                    // 05
aadd(aLCPCJD,{"Valor venda com Desconto",0})             // 06
aadd(aLCPCJD,{"Valor de Impostos",0})                    // 07
aadd(aLCPCJD,{"   - ICMS OP",0})                         // 08
aadd(aLCPCJD,{"   - PIS",0})                             // 09
aadd(aLCPCJD,{"   - COFINS",0})                          // 10
aadd(aLCPCJD,{"   - ICMS ST",0})                         // 11
aadd(aLCPCJD,{"Ressarcimento",0})                        // 12
aadd(aLCPCJD,{"   - ICMS OP",0})                         // 13
aadd(aLCPCJD,{"   - ICMS ST",0})                         // 14
aadd(aLCPCJD,{"Valor Lํquido da Venda",0})               // 15
aadd(aLCPCJD,{"Custo da Pe็a",0})                        // 16
aadd(aLCPCJD,{"Lucro Bruto",0})                          // 17
aadd(aLCPCJD,{"Despesas Operacionais",0})                // 18
aadd(aLCPCJD,{"Comissใo Vendedor",0})                    // 19
aadd(aLCPCJD,{"Lucro Operacional",0})                    // 20
aadd(aLCPCJD,{"Custo Financeiro",0})                     // 21
aadd(aLCPCJD,{"Resultado Final",0})                      // 22
aadd(aLCPCJD,{"Resultado Final Liquido",0})              // 23
//
cDesOpe := " "
nValAcr := 0
nValAcF := 0
nValPec := 0
nValTot := 0
nValCus := 0
nQtdPec := 0
nPerDes := 0
nValDes := 0
nImpost := 0
nImpICM := 0
nImpPIS := 0
nImpCOF := 0
nImpSOL := 0
nRessar := 0
nResICM := 0
nResSOL := 0
nDesOpe := 0
nCusFin := 0
//
nPercTot := 0
//
cCodCli := Space(TamSx3("A1_COD")[1])
cCodLoj := Space(TamSx3("A1_LOJA")[1])
cNomCli := Space(TamSx3("A1_NREDUZ")[1])
cVended := Space(TamSx3("A3_COD")[1])
cNomVen := Space(TamSx3("A3_NOME")[1])
cCondPg := Space(TamSx3("E4_CODIGO")[1])
cDesFpg := Space(TamSx3("E4_COND")[1])
cForCus := Space(TamSx3("VS3_FORMUL")[1])
cDesFCu := Space(TamSx3("VEG_DESCRI")[1])
cForVda := Space(TamSx3("VS3_FORMUL")[1])
cDesFVd := Space(TamSx3("VEG_DESCRI")[1])
cCodPec := Space(TamSx3("B1_COD")[1])
cDesPec := Space(TamSx3("B1_DESC")[1])
cCodTes := Space(TamSx3("F4_CODIGO")[1])
cTipOpe := Space(TamSx3("VVA_OPER")[1])
//
If lRefresh
	//
	oLboxLC:Refresh()
	//
EndIf
//
Return
