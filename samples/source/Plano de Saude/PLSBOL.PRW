
  #INCLUDE "PlsR580.ch"
#include "PROTHEUS.CH"
#include "PLSMGER.CH"

#DEFINE RESETLIN nLinha := 550

Static objCENFUNLGP := CENFUNLGP():New()
/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбдддддддддбдддддддбддддддддддддддддддддддддбддддддбддддддддддд©╠╠
╠╠ЁFuncao    Ё PLSR580 Ё Autor Ё Rafael M. Qudrotti     Ё Data Ё 03.02.04  Ё╠╠
╠╠цддддддддддедддддддддадддддддаддддддддддддддддддддддддаддддддаддддддддддд╢╠╠
╠╠ЁDescricao Ё Impressao do boleto bancario SIGAPLS						   Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё PLSR580                                                     Ё╠╠
╠╠цддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso      Ё Advanced Protheus                                           Ё╠╠
╠╠цддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Alteracoes desde sua construcao inicial                                Ё╠╠
╠╠здддддддддддеддддддддддбддддддддддддддддддддддддддддддддддддддддддддддддд©╠╠
╠╠ЁAlteracoes Ё Data     ЁMotivo                                           Ё╠╠
╠╠цдддддддддддеддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRafael     Ё03/02/2004ЁAlteracao de Lay out da emissao de boletos.      Ё╠╠
╠╠ЁMarchette  Ё 		 Ё- Header - Dados da empresa e dados ANS          Ё╠╠
╠╠ЁQuadrotti  Ё 		 Ё- Extrato- Impressao de dependentes e meses em   Ё╠╠
╠╠Ё           Ё 		 Ёatraso.                                          Ё╠╠
╠╠Ё           Ё 		 Ё- Extrato- Inclusao da observacao no extrato.    Ё╠╠
╠╠Ё           Ё 		 Ё- Ficha de Comp. - Correcao do codigo de barras  Ё╠╠
╠╠Ё           Ё 		 Ё- Ficha de Comp. - Alteracao de textos de instru-Ё╠╠
╠╠Ё           Ё 		 Ёcoes/responsabilidade do cedente.                Ё╠╠
╠╠юдддддддддддаддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
/*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define nome da funcao                                                    Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
User Function PLSBOL()
					
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define variaveis padroes para todos os relatorios...                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cmv_par01, cmv_par02, cmv_par03, cmv_par04, cmv_par05, cmv_par06, cmv_par07, cmv_par08, cmv_par09, cmv_par10
Local cmv_par11, cmv_par12, cmv_par13, cmv_par14, cmv_par15, cmv_par16, cmv_par17, cmv_par18, cmv_par19, cmv_par20

PRIVATE nQtdLin     := 60
PRIVATE cTamanho    := "G"
PRIVATE cTitulo     := STR0001 //"Emissao dos boletos de cobranca"
PRIVATE cDesc1      := STR0002 //"Emissao dos boletos de cobranca de acordo com os parametros selecionados."
PRIVATE cDesc2      := ""
PRIVATE cDesc3      := ""
PRIVATE cAlias      := "SE1"
PRIVATE cPerg       := "PLR580"
PRIVATE cRel        := "PLSR580"
PRIVATE nli         := 80
PRIVATE m_pag       := 1
PRIVATE lCompres    := .F.
PRIVATE lDicion     := .F.
PRIVATE lFiltro     := .T.
PRIVATE lCrystal    := .F.
PRIVATE aOrderns    := {}
PRIVATE aReturn     := { "", 1,"", 1, 1, 1, "",1 }
PRIVATE lAbortPrint := .F.

if len(paramixb) == 20
	cmv_par01 := paramixb[1]
	cmv_par02 := paramixb[2]
	cmv_par03 := paramixb[3]
	cmv_par04 := paramixb[4]
	cmv_par05 := paramixb[5]
	cmv_par06 := paramixb[6]
	cmv_par07 := paramixb[7]
	cmv_par08 := paramixb[8]
	cmv_par09 := paramixb[9]
	cmv_par10 := paramixb[10]
	cmv_par11 := paramixb[11]
	cmv_par12 := paramixb[12]
	cmv_par13 := paramixb[13]
	cmv_par14 := paramixb[14]
	cmv_par15 := paramixb[15]
	cmv_par16 := paramixb[16]
	cmv_par17 := paramixb[17]
	cmv_par18 := paramixb[18]
	cmv_par19 := paramixb[19]
	cmv_par29 := paramixb[20]
endif

//-- LGPD ----------
if !objCENFUNLGP:getPermPessoais()
	objCENFUNLGP:msgNoPermissions()
	Return
Endif
//------------------

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Testa ambiente do relatorio somente top...                               Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If ! PLSRelTop()
	Return .F.
Endif
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Chama SetPrint (padrao)                                                  Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If cmv_par01 # Nil
	cPerg := ""
	mv_par01 := cmv_par01
	mv_par02 := cmv_par02
	mv_par03 := cmv_par03
	mv_par04 := cmv_par04
	mv_par05 := cmv_par05
	mv_par06 := cmv_par06
	mv_par07 := cmv_par07
	mv_par08 := cmv_par08
	mv_par09 := cmv_par09
	mv_par10 := cmv_par10
	mv_par11 := cmv_par11
	mv_par12 := cmv_par12
	mv_par13 := cmv_par13
	mv_par14 := cmv_par14
	mv_par15 := cmv_par15
	mv_par16 := cmv_par16
	mv_par17 := cmv_par17
	mv_par18 := cmv_par18
	mv_par19 := cmv_par19	
	mv_par20 := cmv_par20
Else
	Pergunte(cPerg,.F.)
Endif

cRel := SetPrint(	cAlias		,cRel		,cPerg		,@cTitulo	,;
					cDesc1		,cDesc2		,cDesc3		,lDicion	,;
					aOrderns	,lCompres	,cTamanho	,{}			,;
					lFiltro		,lCrystal)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se foi cancelada a operacao (padrao)                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nLastKey  == 27
	Return
Endif
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         				Ё
//Ё mv_par01 // Cliente de                                       				Ё
//Ё mv_par02 // Loja ate                                        				Ё
//Ё mv_par03 // Cliente ate                                      				Ё
//Ё mv_par04 // Loja                                            				Ё
//Ё mv_par05 // Operadora de                                     				Ё
//Ё mv_par06 // Operadora ate                                    				Ё
//Ё mv_par07 // Empresa de                                       				Ё
//Ё mv_par08 // Empresa ate                                      				Ё
//Ё mv_par09 // Contrato de                                      				Ё
//Ё mv_par10 // Contrato ate                                     				Ё
//Ё mv_par11 // Sub-Contrato de                                  				Ё
//Ё mv_par12 // Sub-Contrato ate                                                Ё
//Ё mv_par13 // Matricula De                                       				Ё
//Ё mv_par14 // Matricula Ate                                                   Ё
//Ё mv_par15 // Mes de                                          				Ё
//Ё mv_par16 // Ano de                                           				Ё
//Ё mv_par17 // Mes Ate                                         				Ё
//Ё mv_par18 // Ano Ate                                          				Ё
//Ё mv_par19 // Detalha Cobranca - Por Usuario/Por Tipo Cobranca                Ё
//Ё mv_par20 // Gera lancamento de segunda via de boleta...                     Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Configura impressora (padrao)                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
SetDefault(aReturn,cAlias)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Emite relat╒rio                                                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
MsAguarde({|| R580Imp() }, cTitulo, "", .T.)

MS_FLUSH()             // Libera fila de relatorios em spool

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Fim da rotina                                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Return

/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠здддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma   Ё R580Imp  Ё Autor Ё Rafael M. Quadrotti   Ё Data Ё 14.06.02 Ё╠╠
╠╠цдддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao  Ё Imprime detalhe do relatorio...                            Ё╠╠
╠╠юдддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
/*/
Static Function R580Imp()
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define variaveis...                                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL cSQL			:= ""							// Select deste relatorio
LOCAL cSE1Name 		:= SE1->(RetSQLName("SE1"))	// Retorna o nome do alias no TOP
Local cPrefixo 		:= ""							// Prefixo do titulo
Local cTitulo 		:= ""							// Titulo
Local cParcela 		:= ""							// Parcela do titulo
Local cTipo 		:= ""							// E1_TIPO
Local aDadosEmp		:= {}							// Array com os dados da empresa.
Local aDadosTit		:= {}							// Array com os dados do titulo			
Local aDadosBanco   := {}							// Array com os dados do banco
Local aDatSacado	:= {}							// Array com os dados do Sacado.
Local CB_RN_NN  	:= {}							// Array com as informacoes do Nosso Numero, Codigo de Barras, e Linha digitavel.
Local aBmp			:= { "" }						// Vetor para Bmp.
Local cOperadora    := BX4->(PLSINTPAD())			// Retorna a operadora do usuario.
Local aBfq			:= {}
Local aDependentes	:= {}							// Array com os dependentes do sacado.
Local aOpenMonth	:= {}							// Array com os meses em aberto.
Local aObservacoes  := {}							// Array com as observacoes do extrato.
Local aMsgCorpo 	:= {}							// Array com as observacoes do corpo do boleto.
Local aMsgBoleto    := {}							// Array com as mensagens do boleto.
Local nPos			:= 0							// Variavel auxiliar para ascan.
Local cCart		    := ""							// Carteira do titulo
Local cSA6Key		:= ""							// Chave de pesquisa do SA6 Cadastro de bancos,
LOCAL lUnimeds      := IF(AllTrim(GETNEWPAR("MV_PLSUNI","1"))=="1",.T.,.F.) // Retorna se operadora e UNIMED ou nao!
LOCAL aUsrVlr   	:= {}
LOCAL lPLR580MSG := ExistBlock("PLR580MSGO")
LOCAL lPLR580MSB := ExistBlock("PLR580MSGB")
LOCAL lPLR580MSC := ExistBlock("PLR580MSGC")

//Variaveis totalizadoras...
Private _nQtdInscr 	:= 0
Private _nQtdMens	:= 0
Private _nQtdOpc	:= 0

oPrint:= TMSPrinter():New( STR0003 ) //"Boleto Laser"

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVerifica se as configuracoes de impressora foram definidas para Ё
//Ёque o objeto possa ser trabalhado.                              Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If !(oPrint:IsPrinterActive())
     Aviso(STR0041,STR0042,{"OK"})   //"Impressora"###"As configuraГУes da impressora nЦo foram encontradas. Por favor, verifique as configuraГУes para utilizar este relatСrio. "
     oPrint:Setup()
     Return (.F.)
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Ordena arquivos envolvidos...                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
SE1->(DbSetOrder(01))
BBT->(dbSetorder(07))
BM1->(DbSetOrder(04))
BA1->(DbSetOrder(02))
BA0->(DbSetorder(01))
BI3->(DbSetorder(01))

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta query...                                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cSQL := "SELECT * FROM "+cSE1Name+" WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND "
cSQL += 	"E1_CLIENTE + E1_LOJA >= '"+mv_par01+mv_par02+"' AND "
cSQL += 	"E1_CLIENTE + E1_LOJA <= '"+mv_par03+mv_par04+"' AND "
cSQL += 	"E1_CODINT >= '"+mv_par05+"' AND E1_CODINT <= '"+mv_par06+"' AND "
cSQL += 	"E1_CODEMP >= '"+mv_par07+"' AND E1_CODEMP <= '"+mv_par08+"' AND "
cSQL += 	"E1_CONEMP >= '"+mv_par09+"' AND E1_CONEMP <= '"+mv_par10+"' AND "
cSQL += 	"E1_SUBCON >= '"+mv_par11+"' AND E1_SUBCON <= '"+mv_par12+"' AND "
cSQL += 	"E1_MATRIC >= '"+mv_par13+"' AND E1_MATRIC <= '"+mv_par14+"' AND "
cSQL += 	"E1_ANOBASE + E1_MESBASE >= '"+mv_par16+mv_par15+"' AND "
cSQL += 	"E1_ANOBASE + E1_MESBASE <= '"+mv_par18+mv_par17+"' AND E1_SALDO > 0 AND "
cSQL += 	"E1_PARCELA <> '" + StrZero(0, Len(SE1->E1_PARCELA)) + "' AND " 
cSQL += 	"E1_SITUACA <> '0' AND "

If ! Empty(aReturn[7])
	cSQL += PLSParSQL(aReturn[7]) + " AND "
Endif
cSQL += cSE1Name+".D_E_L_E_T_ = '' "
cSQL += "ORDER BY " + SE1->(IndexKey())

PLSQuery(cSQL,"R580Imp")

If R580Imp->(Eof())
	R580Imp->(DbCloseArea())
	Help("",1,"RECNO")
	Return
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Inicio da impressao dos detalhes...                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova pАgina

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Exibe mensagem...                                                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
MsProcTxt(PLSTR0001)//#include "PLSMGER.CH"

//зддддддддддддддддддддд©
//ЁBusca Bmp da empresa.Ё// Logo
//юддддддддддддддддддддды
If File("lgrl" +FWGrpCompany()+FWCodFil()+ ".Bmp")
	aBMP := { "lgrl" +FWCompany()+FWCodFil()+ ".Bmp" }
	
ElseIf File("lgrl" +FWCompany()+ ".Bmp")
	aBMP := { "lgrl" +FWCompany()+ ".Bmp" }
	
Endif

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Posiciona a operadora padrao...                                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
BA0->(DbSeek(xFilial("BA0") + cOperadora))

//здддддддддддддддддддддддддддддддддддддддддд©
//ЁInicia laco para a impressao  dos boletos.Ё
//юдддддддддддддддддддддддддддддддддддддддддды
While ! R580Imp->(Eof())
	aCobranca	:= {}
	cPrefixo 	:= R580Imp->E1_PREFIXO
	cTitulo 	:= R580Imp->E1_NUM
	cParcela 	:= R580Imp->E1_PARCELA
	cTipo 		:= R580Imp->E1_TIPO
		                                      
	//здддддддддддддддддддддддддддддддддддддддддд©
	//ЁPosiciona tabelas envolvidas...           Ё
	//юдддддддддддддддддддддддддддддддддддддддддды		                                                                 
	SE1->( dbGoto(R580Imp->R_E_C_N_O_) )
	BBT->( DbSeek(xFilial("BBT") + cPrefixo + cTitulo + cParcela + cTipo))	
	BG9->( DbSeek(xFilial("BG9") + BBT->BBT_CODOPE + BBT->BBT_CODEMP ))
	BA3->( DbSeek(xFilial("BA3") + BM1->BM1_CODINT + BM1->BM1_CODEMP + BM1->BM1_MATRIC))
	BI3->( DbSeek(xFilial("BI3") + BA3->BA3_CODPLA + BA3->BA3_VERSAO) )
	SA1->( DbSeek(xFilial("SA1") + R580Imp->E1_CLIENTE + R580Imp->E1_LOJA))
	                                                                          
	aDependentes := {}
	
	//з--------------------------------------------------------------------------©
	//| Gera lancamento para o faturamento de segunda via de boleto...           |
	//ю--------------------------------------------------------------------------ы
	If mv_par20 == 2
		PLSUPT2BOL(BM1->(BM1_CODINT+BM1_CODEMP+BM1_MATRIC),dDataBase,1)
	Endif

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁSeleciona os BM1 envolvidos na fatura...             Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды	             
	cFiltro := "SELECT * FROM "+RetSqlName("BM1")+" WHERE "
	cFiltro += "BM1_PREFIX = '"+cPrefixo+"' 	AND "
	cFiltro += "BM1_NUMTIT = '"+cTitulo +"' 	AND "	
	cFiltro += "BM1_PARCEL = '"+cParcela+"'     AND "
	cFiltro += "BM1_TIPTIT = '"+cTipo+"'		AND "
	cFiltro += "D_E_L_E_T_ <> '*' "
	cFiltro += "Order by BM1_CODEMP, BM1_CONEMP, BM1_VERCON, BM1_SUBCON, BM1_VERSUB,BM1_CODEVE, BM1_IDAINI, BM1_IDAFIN "
	PlsQuery(cFiltro, "TRB2")
		
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁEm caso de pessoa juridica, nao emite os dependentes.Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If BG9->BG9_TIPO  == '1' //Pessoa Fisica
		//здддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁBusca de dependentes para impressao dos dados.Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддды
		DbSelectArea("BA1")
		If DbSeek(xFilial("BA1") + TRB2->BM1_CODINT + TRB2->BM1_CODEMP + TRB2->BM1_MATRIC)
			
			While 	(!EOF() .And.;
				xFilial("BA1")  == BA1->BA1_FILIAL .And.;
				BA1->BA1_CODINT == TRB2->BM1_CODINT .And.;
				BA1->BA1_CODEMP == TRB2->BM1_CODEMP .And.;
				BA1->BA1_MATRIC == TRB2->BM1_MATRIC)
				
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁIdentifica os usuarios que fazem parte do titulo posicionado. Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If 	BG9->BG9_TIPO == "1" .And. (SubStr(DtoS(BA1->BA1_DATINC),1,6) <= R580Imp->E1_ANOBASE+R580Imp->E1_MESBASE) .and. ;
					(Empty(BA1->BA1_MOTBLO))
					
					Aadd(aDependentes, {BA1->BA1_TIPREG,BA1->BA1_NOMUSR})
				EndIf
				
				DbSkip()
			End
		EndIf
	EndIf
	DbSelectArea("R580Imp")
	
	//зддддддддддддддддддддддддддддддддддддд©
	//ЁRetorna os meses em aberto do sacado.Ё
	//юддддддддддддддддддддддддддддддддддддды
	aOpenMonth:=PLR580MES(R580Imp->E1_CLIENTE,R580Imp->E1_LOJA,R580Imp->E1_MESBASE,R580Imp->E1_ANOBASE, cTipo)
	
	aUsrVlr := {}
					
	TRB2->( dbGotop() )
	While 	!TRB2->(Eof()) 
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Padrao de boletos para UNIMED...                             Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		If lUnimeds .and. BG9->BG9_TIPO == '2'
			If (Alltrim(BA3->BA3_MODPAG) == '1' .and. mv_par19 <> 3) .or. Alltrim(BA3->BA3_MODPAG) <> '1'
				If (nPos := Ascan(aCobranca, {|x| x[1] = TRB2->BM1_CODTIP .and. x[4] == TRB2->BM1_ATOCOO })) > 0
					aCobranca[nPos][3] += TRB2->BM1_VALOR
				Else
					Aadd(aCobranca, { TRB2->BM1_CODTIP, TRB2->BM1_DESTIP, TRB2->BM1_VALOR, TRB2->BM1_ATOCOO})
				Endif
			
				If TRB2->BM1_CODTIP == '101'
					_nQtdMens ++           
				
				Elseif TRB2->BM1_CODTIP == '103'
					_nQtdInscr++
											
				Endif
			Else
				aAcumula 	:= {}
				cNumCon		:= TRB2->BM1_CONEMP
				cVerCon		:= TRB2->BM1_VERCON
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Alimenta array com as faixas etarias...                                  Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				// Quebra do contrato...
				If !Empty(TRB2->BM1_CONEMP)
					Aadd(aCobranca, {'01',"Contrato ->   "+TRB2->BM1_CONEMP+" / Versao -> "+TRB2->BM1_VERCON} )
				Endif
				While !TRB2->( Eof() ) .and. TRB2->BM1_CONEMP == cNumCon .and. TRB2->BM1_VERCON == cVerCon
					//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					//Ё Quebra do sub contrato...                                                Ё
					//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
					If !Empty(TRB2->BM1_SUBCON)
						Aadd(aCobranca, {'02', "Sub Contrato ->         "+TRB2->BM1_SUBCON+" / Versao -> "+TRB2->BM1_VERSUB+;
									" - "+Posicione("BQC",1,xFilial("BQC")+;
									TRB2->BM1_CODINT+TRB2->BM1_CODEMP+;
									TRB2->BM1_CONEMP+TRB2->BM1_VERCON+;
									TRB2->BM1_SUBCON+TRB2->BM1_VERSUB,;
									"BQC_DESCRI")} )
					Endif
						
					cSubCon		:= TRB2->BM1_SUBCON
					cVerSub		:= TRB2->BM1_VERSUB
					While !TRB2->( Eof() ) .and. TRB2->BM1_CONEMP == cNumCon .and. TRB2->BM1_VERCON == cVerCon .and. ;
						   TRB2->BM1_SUBCON == cSubCon .and. TRB2->BM1_VERSUB == cVerSub
							    
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Quebra do produto...                                                     Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
						If TRB2->BM1_CODTIP $ '101,102'
							Aadd(aCobranca, {'03', "Produto ->                    "+Alltrim(TRB2->BM1_CODEVE)+" / Versao -> "+TRB2->BM1_VERCON+;
							" - "+Posicione("BI3",1,xFilial("BI3")+TRB2->BM1_CODINT+Substr(TRB2->BM1_CODEVE,1,4),"BI3_DESCRI")} )
							                                                                          
						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Taxa de adesao...                                                        Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды							
						Elseif TRB2->BM1_CODTIP $ '103'
							Aadd(aCobranca, {'04', "Taxa de Incricao ->"} )

						//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
						//Ё Outros... Custo operacional, cartao, deb/cred, agravo...                 Ё
						//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды						
						Else
							Aadd(aCobranca, {'04', TRB2->BM1_DESTIP + " -> "} )
							
						Endif

						cCodEve		:= TRB2->BM1_CODEVE
						While !TRB2->( Eof() ) .and. TRB2->BM1_CONEMP == cNumCon .and. TRB2->BM1_VERCON == cVerCon .and. ;
							   TRB2->BM1_SUBCON == cSubCon .and. TRB2->BM1_VERSUB == cVerSub .and. ;
							   TRB2->BM1_CODEVE == cCodEve
								              
							//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
							//Ё Lancamentos por faixa etaria tem tratamento separado...                  Ё
							//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
							If TRB2->BM1_CODTIP $ '101,102,103'
								If (nPos := Ascan(aCobranca, {| x |	 x[1] == '05' .and. x[3] == TRB2->BM1_VALOR  .and.;
									x[06] == TRB2->BM1_CODINT .and. x[07] == TRB2->BM1_CODEMP .and.;
									x[08] == TRB2->BM1_CONEMP .and. x[09] == TRB2->BM1_VERCON .and.;
									x[10] == TRB2->BM1_SUBCON .and. x[11] == TRB2->BM1_VERSUB .and.;
									x[04] == TRB2->BM1_IDAINI .and. x[05] == TRB2->BM1_IDAFIN })) == 0
							                                                           
									//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//Ё Obtem os valores de faixas, opcional e taxa de adesao, para o resumo final...  |
									//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
									If TRB2->BM1_CODTIP == '101'
										_nQtdMens  += TRB2->BM1_VALOR
										
									Elseif TRB2->BM1_CODTIP == '102'
										_nQtdOpc   += TRB2->BM1_VALOR
									
									Elseif TRB2->BM1_CODTIP == '103'
										_nQtdInscr += TRB2->BM1_VALOR
									
									Endif                                                                               
									
									//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
									//Ё Alimenta o array para impressao dos lancamentos por faixa etaria...            |
									//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
									Aadd(aCobranca, {'05', 1, TRB2->BM1_VALOR, TRB2->BM1_IDAINI, TRB2->BM1_IDAFIN,;
															  TRB2->BM1_CODINT, TRB2->BM1_CODEMP, TRB2->BM1_CONEMP,;
															  TRB2->BM1_VERCON, TRB2->BM1_SUBCON, TRB2->BM1_VERSUB,;
															  TRB2->BM1_CODTIP, TRB2->BM1_DESTIP})
								Else
									aCobranca[nPos][2] += 1
									
								Endif
							Else
								//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
								//Ё Alimenta o array para impressa do resumo final...                              |
								//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды							
								If (nPos := Ascan(aCobranca, {| x |	 x[1] == '06' .and. x[12] == TRB2->BM1_CODTIP})) == 0
									Aadd(aCobranca, {'05', 1, TRB2->BM1_VALOR, TRB2->BM1_IDAINI, TRB2->BM1_IDAFIN,;
															  TRB2->BM1_CODINT, TRB2->BM1_CODEMP, TRB2->BM1_CONEMP,;
															  TRB2->BM1_VERCON, TRB2->BM1_SUBCON, TRB2->BM1_VERSUB,;
															  TRB2->BM1_CODTIP, TRB2->BM1_DESTIP})
							  	Endif
							Endif
								
							TRB2->( dbSkip() )
						Enddo
					Enddo
				Enddo
			Endif
			
		Else
			If mv_par19 == 1 .And. TRB2->BM1_LTOTAL = "0"
				
				//bops melhoria tulio
				nPos := Ascan(aUsrVlr,{|x| x[1] == TRB2->BM1_MATUSU })
				If nPos == 0
					aadd(aUsrVlr,{TRB2->BM1_MATUSU,TRB2->BM1_VALOR,TRB2->BM1_NOMUSR})
				Else
					aUsrVlr[nPos,2] +=TRB2->BM1_VALOR
				Endif     
				
			ElseIf (mv_par19 == 2 .or. mv_par19 == 3 ).And. TRB2->BM1_LTOTAL = "0"
				
				If (nPos := Ascan(aCobranca, {|x| x[1] = TRB2->BM1_CODTIP})) > 0
					aCobranca[nPos][3] += TRB2->BM1_VALOR
				Else
					Aadd(aCobranca, { TRB2->BM1_CODTIP, TRB2->BM1_DESTIP, TRB2->BM1_VALOR})
				Endif
			Endif
		Endif
		TRB2->(DbSkip())
	Enddo
	
	For nPos := 1 To Len(aUsrVlr)
		Aadd(aCobranca, Trans(aUsrVlr[nPos,1], __cPictUsr + ".!") + " - " +;
						AllTrim(aUsrVlr[nPos,3])+;
						"- R$ " +;
						Trans(aUsrVlr[nPos,2], "@E 99,999.99"))
	Next
	
	aBfq := RetornaBfq(R580Imp->E1_CODINT, "199")

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁSomente para pessoa juridica de cooperativas medicas...          Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !(lUnimeds .and. BG9->BG9_TIPO == '2')
		If R580Imp->E1_IRRF > 0
			Aadd(aCobranca, aBfq[1]+" - "+aBfq[3]+"  -  R$ "+Transform(R580Imp->E1_IRRF,"@E 99,999,999.99") )
		Endif
    Endif
    
	aDadosEmp	:= {	BA0->BA0_NOMINT                                                           	,; //Nome da Empresa
						BA0->BA0_END                                                              	,; //EndereГo
						AllTrim(BA0->BA0_BAIRRO)+", "+AllTrim(BA0->BA0_CIDADE)+", "+BA0->BA0_EST 	,; //Complemento
						"CEP: "+Subs(BA0->BA0_CEP,1,5)+"-"+Subs(BA0->BA0_CEP,6,3)             		,; //CEP
						"PABX/FAX: "+BA0->BA0_TELEF1                                           		,; //Telefones
						"CNPJ.: "+Subs(BA0->BA0_CGC,1,2)+"."+Subs(BA0->BA0_CGC,3,3)+"."+;
						Subs(BA0->BA0_CGC,6,3)+"/"+Subs(BA0->BA0_CGC,9,4)+"-"+;
						Subs(BA0->BA0_CGC,13,2)                                                    	,; //CGC
						STR0043 + BA0->BA0_SUSEP }  //I.E //"ANS : "
	
	//здддддддддддддддддддддддддддддддддддддддддд©
	//ЁCarrega mensagens de observacao...        |
	//юдддддддддддддддддддддддддддддддддддддддддды
	If lPLR580MSG
		aObservacoes := ExecBlock("PLR580MSGO",.f.,.f.)
	Else
		aObservacoes := PLR580TEXT(2					,R580Imp->E1_CODINT	,R580Imp->E1_CODEMP,R580Imp->E1_CONEMP	,;
						R580Imp->E1_SUBCON	,R580Imp->E1_MATRIC ,R580Imp->E1_ANOBASE+R580Imp->E1_MESBASE)
	Endif

	//здддддддддддддддддддддддддддддддддддддддддд©
	//ЁCarrega mensagens do boleto...   		 |
	//юдддддддддддддддддддддддддддддддддддддддддды	                          
	If lPLR580MSB
		aMsgBoleto := ExecBlock("PLR580MSGB",.f.,.f.)
	Else
		aMsgBoleto   := PLR580TEXT(1					,R580Imp->E1_CODINT	,R580Imp->E1_CODEMP,R580Imp->E1_CONEMP	,;
						R580Imp->E1_SUBCON	,R580Imp->E1_MATRIC ,R580Imp->E1_ANOBASE+R580Imp->E1_MESBASE)
	Endif
	   
	//здддддддддддддддддддддддддддддддддддддддддд©
	//ЁCarrega mensagens do boleto...   		 |
	//юдддддддддддддддддддддддддддддддддддддддддды
	If lPLR580MSC
		aMsgCorpo	 := ExecBlock("PLR580MSGC",.f.,.f.)
	Else
		aMsgCorpo    := PLR580TEXT(	5					,R580Imp->E1_CODINT	,R580Imp->E1_CODEMP	,R580Imp->E1_CONEMP	,;
						R580Imp->E1_SUBCON	,R580Imp->E1_MATRIC 	,R580Imp->E1_ANOBASE+R580Imp->E1_MESBASE,;
						Alltrim(BA3->BA3_MODPAG),BG9->BG9_TIPO)	
	Endif				
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁCaso nao exita o banco e agencia no SE1 busca informacoes do SEA.Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If ((Empty(R580Imp->E1_PORTADO) .OR. Empty(R580Imp->E1_AGEDEP)) .AND. !Empty(R580Imp->E1_NUMBOR) )
		SEA->(DbSeek(xFilial("SEA")+R580Imp->E1_NUMBOR+ cPrefixo + cTitulo + cParcela + cTipo      ))
		cSA6Key:=SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON
	ElseIf !Empty(R580Imp->E1_PORTADO) .AND. !Empty(R580Imp->E1_AGEDEP)
		cSA6Key:=R580Imp->E1_PORTADO+R580Imp->E1_AGEDEP+R580Imp->E1_CONTA
	EndIf
	
	//зддддддддддддддддддддддддддд©
	//ЁDados para codigo de barrasЁ
	//юддддддддддддддддддддддддддды
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial()+cSA6Key,.T.)
	
	DbSelectArea("R580Imp")
	aDadosBanco  := {	SA6->A6_COD                                        	,;  //Numero do Banco
						SA6->A6_NREDUZ                                     	,;  //Nome do Banco
						SA6->A6_AGENCIA				                       	,;  //Agencia
						Subs(SA6->A6_NUMCON,1,AT("-",SA6->A6_NUMCON)-1)		,; 	//Conta Corrente
						Subs(SA6->A6_NUMCON,AT("-",SA6->A6_NUMCON)+1)  		}   //DМgito da conta corrente
	
	If Subs(aDadosBanco[1],1,3) == '001' //Banco do Brasil
		cCart := '18'
	ElseIf Subs(aDadosBanco[1],1,3) == '104' //CEF
		cCart := '82'
	EndIf
	
	CB_RN_NN    := 	Ret_cBarra(	Subs(aDadosBanco[1],1,3),;
								aDadosBanco[3],;
								aDadosBanco[4],;
								aDadosBanco[5],;
								Strzero(Val(Alltrim(R580Imp->E1_NUM)),6)+StrZERO(Val(Alltrim(R580Imp->E1_PARCELA)),2),;
								R580Imp->E1_SALDO - R580Imp->E1_IRRF,;
								R580Imp->E1_PREFIXO,;
								R580Imp->E1_NUM,;
								R580Imp->E1_PARCELA,;
								R580Imp->E1_TIPO,;
								cCart)
	
	//здддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁTestar o retorno do rdmake de layout do boletoЁ
	//юдддддддддддддддддддддддддддддддддддддддддддддды
	If Empty(CB_RN_NN)
		If !MsgYesNo(STR0045) //"Deseja continuar ?"
			R580Imp->(DbCloseArea())
			TRB2->( dbCloseArea() )
			Return NIL
		Else
			R580Imp->(DbSkip())
			Loop
		EndIf
	EndIf
	
	//зддддддддддддддд©
	//ЁDados do TituloЁ
	//юддддддддддддддды
	aDadosTit   :=  {	AllTrim(E1_NUM)+AllTrim(E1_PARCELA),; 	//Numero do tМtulo
						E1_EMISSAO,;             				//Data da emissЦo do tМtulo
						dDataBase,;             				//Data da emissЦo do boleto
						E1_VENCTO,;             				//Data do vencimento
						E1_SALDO - E1_IRRF,;					//Valor do tМtulo
						CB_RN_NN[3] }							//Nosso numero (Ver fСrmula para calculo)
						
	//зддддддддддддддд©
	//ЁDados Sacado   Ё
	//юддддддддддддддды
	aDatSacado   := {	AllTrim(SA1->A1_NOME)                            ,;      //RazЦo Social
						AllTrim(SA1->A1_COD )                            ,;      //CСdigo
						AllTrim(SA1->A1_END )+"-"+SA1->A1_BAIRRO         ,;      //EndereГo
						AllTrim(SA1->A1_MUN )                            ,;      //Cidade
						SA1->A1_EST                                      ,;      //Estado
						Transform(SA1->A1_CEP,"@R 99999-999")            }       //CEP

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁSomente para pessoa juridica de cooperativas medicas...          Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	        	
	If lUnimeds .and. BG9->BG9_TIPO == '2'
		R580Graf02(	aCobranca	,E1_SDDECRE		,E1_SDACRES	,oPrint			,;
					aBMP		,aDadosEmp		,aDadosTit	,aDadosBanco	,;
					aDatSacado	,aMsgBoleto		,CB_RN_NN	,aOpenMonth		,;
					aDependentes,aObservacoes	,cCart, BG9->BG9_TIPO, lUnimeds, aMsgCorpo )
		
	Else
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁPara demais ocasioes...                                          Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	        	
		R580Graf01(	aCobranca	,E1_SDDECRE		,E1_SDACRES	,oPrint			,;
					aBMP		,aDadosEmp		,aDadosTit	,aDadosBanco	,;
					aDatSacado	,aMsgBoleto		,CB_RN_NN	,aOpenMonth		,;
					aDependentes,aObservacoes	,cCart)
		
	Endif
	TRB2->( dbCloseArea() )
	R580Imp->(DbSkip())
End

//з--------------------------------------------------------------------©
//| Fecha arquivo...                                                   |
//ю--------------------------------------------------------------------ы
R580Imp->(DbCloseArea())
//з--------------------------------------------------------------------------©
//| Libera impressao                                                         |
//ю--------------------------------------------------------------------------ы
oPrint:EndPage()     // Finaliza a pАgina
oPrint:Preview()     // Visualiza antes de imprimir

//з--------------------------------------------------------------------------©
//| Fim do Relat╒rio                                                         |
//ю--------------------------------------------------------------------------ы
Return


/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠здддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma   Ё R580Graf Ё Autor Ё Rafael M. Quadrotti   Ё Data Ё 08.10.03 Ё╠╠
╠╠цдддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao  Ё Imprime Boleto em modo texto                               Ё╠╠
╠╠здддддддддддеддддддддддбддддддддддддддддддддддддддддддддддддддддддддддддд©╠╠
╠╠ЁAlteracoes Ё Data     ЁMotivo                                           Ё╠╠
╠╠цдддддддддддеддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRafael     Ё03/02/2004ЁAlteracao de Lay out da emissao de boletos.      Ё╠╠
╠╠ЁMarchette  Ё 		 Ё- Header - Dados da empresa e dados ANS          Ё╠╠
╠╠ЁQuadrotti  Ё 		 Ё- Extrato- Impressao de dependentes e meses em   Ё╠╠
╠╠Ё           Ё 		 Ёatraso.                                          Ё╠╠
╠╠Ё           Ё 		 Ё- Extrato- Inclusao da observacao no extrato.    Ё╠╠
╠╠Ё           Ё 		 Ё- Ficha de Comp. - Correcao do codigo de barras  Ё╠╠
╠╠Ё           Ё 		 Ё- Ficha de Comp. - Alteracao de textos de instru-Ё╠╠
╠╠Ё           Ё 		 Ёcoes/responsabilidade do cedente.                Ё╠╠
╠╠юдддддддддддаддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
/*/

Static Function R580Graf01(	aCobranca	,nAbatim	,nAcrescim	,oPrint		,;
							aBMP		,aDadosEmp	,aDadosTit	,aDadosBanco,;
							aDatSacado	,aMsgBoleto	,CB_RN_NN	,aOpenMonth	,;
							aDependentes,aObservacoes,cCart)
							
Local oFont8	// --©
Local oFont10	// 	 |
Local oFont11n	// 	 |
Local oFont13n	// 	 |
Local oFont15n	// 	 ц- Fontes para impressao do relatorio grafico.
Local oFont16	// 	 |
Local oFont16n	// 	 |
Local oFont21	// --ы
Local i := 0    // Contador
Local aCoords1 	:= {2000,1900,2100,2300}
Local aCoords2 	:= {2270,1900,2340,2300}
Local oBrush
Local aBitmap 	:= aClone(aBmp)		// Array com os bmps para impressao
Local nLinha	:= 0				// Contador para linha
Local nLinCob 	:= 0				// Contador para linha
Local nMosCob 	:= 0				// Contador para for
Local cPrn		:= ""				// String com informacoes de cobranca para impresao
Local nCobra 	:= 0				// Contador para cobranca
Local nColuna   := 0				// Contador para coluna. 

// 19 linha de extrato duplo.
Local aLinhas	:= { 750, 800, 850, 900, 950, 1000, 1050, 1000, 1100, 1150, 1200, 1250 ,1300 ,1350 ,1400 ,1450 ,1500 ,1550 ,1600 }
Local nContLn	:= 0				// Controle de linhas para impressao de dependentes.
Local nI		:= 0				// Contador do laco para impressao de dependentes.
Local nMsg      := 0    			// Contador para as mensagens
Local cMoeda	:= "9"  			// Moeda do boleto.

//ParБmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont21 := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

oPrint:StartPage()   // Inicia uma nova pАgina

oPrint:Say  (050	,500	,aDadosEmp[1]	,oFont11n)
oPrint:Say  (090	,500	,aDadosEmp[2] 	,oFont8 )
oPrint:Say  (125	,500	,aDadosEmp[3] 	,oFont8 )
oPrint:Say  (160	,500	,aDadosEmp[4] 	,oFont8 )
oPrint:Say  (195	,500	,aDadosEmp[5] 	,oFont8 )
oPrint:Say  (230	,500	,aDadosEmp[6] 	,oFont8 )

//здддддддддд©
//ЁBmp da ANSЁ
//юдддддддддды
If File(SuperGetMv("MV_PLSLANS", .F., "ANS.BMP"))
	oPrint:SayBitmap (050 ,1825,SuperGetMv("MV_PLSLANS", .F., "ANS.BMP"),470 ,150)
Else
	oPrint:Say  (225,500,aDadosEmp[7] ,oFont10)
Endif
oPrint:Say  (250,1780,STR0044 + R580Imp->E1_MESBASE+" / "+R580Imp->E1_ANOBASE ,oFont10) //"MЙs de competЙncia: "

// Linhas do extrato.
oPrint:SayBitmap (50 ,100,aBitMap[1],250 ,200 )
oPrint:Box  (300,100,1852,2300)
oPrint:Line (400,0100,400,2300)
oPrint:Line (700,0100,700,2300)
oPrint:Line (300,0400,400,0400)
oPrint:Line (300,0800,400,0800)
oPrint:Line (300,1150,700,1150)
oPrint:Line (300,1500,400,1500)
oPrint:Line (300,1900,700,1900)

oPrint:Line  (1902,100,1902,2300)// Tracejado para destaque do boleto.

oPrint:Line (1625,100,1625,2300)// Limite para observacao
oPrint:Line (600,1150,1625,1150)// Linha central

nLinCob := 1
nCobra 	:= 1
For nLinha := nLinCob To nLinCob + 12
	nColuna := 115
	For nMosCob := 1 To 2
		If nCobra <= Len(aCobranca)
			If mv_par19 == 2 .or. mv_par19 == 3
				If Valtype(aCobranca[nCobra]) == 'A'
					cPrn := AllTrim(aCobranca[nCobra][1]) + " - " +;
							AllTrim(aCobranca[nCobra][2]) + " - R$ " +;
							Trans(aCobranca[nCobra][3], "@E 99,999.99")
				Else
					cPrn := Alltrim(aCobranca[nCobra])
				Endif
			Else                                      
				cPrn := Alltrim(aCobranca[nCobra])

			Endif
			oPrint:Say (aLinhas[nLinha],nColuna ,cPrn,oFont8 )
			If nColuna = 115
				nColuna := 1165
			Endif
		Else
		Endif
		nCobra ++
	Next
Next

//здддддддддддддддддддддддддддд©
//ЁEmissao dos dados do sacado.Ё
//юдддддддддддддддддддддддддддды
oPrint:Say  (400,105 ,STR0004                  ,oFont8 ) //"Dados do Sacado"
oPrint:Say  (470,115 ,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont10)
oPrint:Say  (505,115 ,aDatSacado[3]                      ,oFont10)
oPrint:Say  (540,115 ,aDatSacado[4]                      ,oFont10)
oPrint:Say  (540,500 ,aDatSacado[5]+"   "+aDatSacado[6]  ,oFont10)

//informacoes dos UsuАrios/dependentes
oPrint:Say  (400,1155 ,STR0005+Iif(BG9->BG9_TIPO == '1',(" ("+R580Imp->E1_CODINT+"."+R580Imp->E1_CODEMP+"."+R580Imp->E1_MATRIC+")"),"") ,oFont8 ) //"UsuАrios"

nContLn := 455
For nI := 1 To Len(aDependentes)
	If nI == 1
		oPrint:Say  (nContLn,1165 ,aDependentes[nI,1]+" - "+Alltrim(aDependentes[nI,2])+STR0006		      ,oFont8) //" (Titular)"
	Else
		oPrint:Say  (nContLn,1165 ,aDependentes[nI,1]+" - "+aDependentes[nI,2]			      ,oFont8)
	EndIf
	nContLn+=25
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁEmite somente os 5 primeiros dependentes devido ao espaco no boleto.Ё
	//ЁFoi utilizado for e estrutura de array para facilitar a customizacaoЁ
	//Ёpara impressao de mais dependentes.								   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If  nI > 9
		Exit
	EndIf
Next nI


//здддддддддддддддддддддддддддд©
//Ёmeses em aberto.			   Ё
//юдддддддддддддддддддддддддддды
oPrint:Say  (400,1905 ,STR0007                  ,oFont8 ) //"Meses em aberto"
nContLn := 455
nColuna := 1905
For nI := 1 To Len(aOpenMonth)
	oPrint:Say  (nContLn,nColuna ,aOPenMonth[nI] ,oFont8)
	nContLn+=25
	
	//Alterna as colunas
	If nColuna == 1905
		nColuna := 1955
	ElseIf nColuna == 1955
		nColuna := 1905
	EndIf
	
	If nI > 18
		Exit
	EndIf
Next nI

oPrint:Say  (300,105,STR0008                   ,oFont8 ) //"Vencimento"
oPrint:Say  (345,205,DTOC(aDadosTit[4])             ,oFont10)

oPrint:Say  (300,405,STR0009                     ,oFont8 ) //"Valor R$"
oPrint:Say  (345,505,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (300,805,STR0010             ,oFont8 ) //"Data de EmissЦo"
oPrint:Say  (345,905,DTOC(aDadosTit[3])             ,oFont10)

oPrint:Say  (300,1155,STR0011            ,oFont8 ) //"Nro.do Documento"
oPrint:Say  (345,1255,aDadosTit[1]                  ,oFont10)

oPrint:Say  (300,1505,STR0012      ,oFont8 ) //"AgЙncia/CСdigo Cedente"
oPrint:Say  (345,1555,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (300,1905,STR0013                ,oFont8 ) //"Nosso NЗmero"
oPrint:Say  (345,1950,aDadosTit[6]                  ,oFont10)

nMsg:=1650
oPrint:Say  (1625,105,STR0014                ,oFont8 ) //"ObservaГЦo"
For nI := 1 To len(aObservacoes)
	oPrint:Say  (nMsg,105,aObservacoes[nI]        ,oFont8 )
	nMsg+=30
	If nI > 5
		Exit
	EndIf
Next nI

oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)

oPrint:Line (2000,100,2000,2300)
oPrint:Line (2000,550,1920,550 )
oPrint:Line (2000,770,1920,770 )
oPrint:Say  (1934,100,Substr(aDadosBanco[2],1,13),oFont16 )
oPrint:Say  (1912,567,aDadosBanco[1]+"-"+cMoeda,oFont21 )
oPrint:Say  (1934,790,CB_RN_NN[2],oFont13n)

oPrint:Line (2100,100,2100,2300 )
oPrint:Line (2200,100,2200,2300 )
oPrint:Line (2270,100,2270,2300 )
oPrint:Line (2340,100,2340,2300 )

oPrint:Line (2200,500,2340,500)
oPrint:Line (2270,750,2340,750)
oPrint:Line (2200,1000,2340,1000)
oPrint:Line (2200,1350,2270,1350)
oPrint:Line (2200,1550,2340,1550)

oPrint:Say  (2000,100 ,STR0015                             ,oFont8) //"Local de Pagamento"
oPrint:Say  (2040,100 ,STR0016        ,oFont10) //"Qualquer banco atИ a data do vencimento"

oPrint:Say  (2000,1910,STR0008                                     ,oFont8) //"Vencimento"
oPrint:Say  (2040,2010,DTOC(aDadosTit[4])                               ,oFont10)

oPrint:Say  (2100,100 ,STR0017                                        ,oFont8) //"Cedente"
oPrint:Say  (2140,100 ,aDadosEmp[1]                                     ,oFont10)

oPrint:Say  (2100,1910,STR0012                         ,oFont8) //"AgЙncia/CСdigo Cedente"
oPrint:Say  (2140,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2200,100 ,STR0018                              ,oFont8) //"Data do Documento"
oPrint:Say  (2230,100 ,DTOC(aDadosTit[3])                               ,oFont10)

oPrint:Say  (2200,505 ,STR0019                                  ,oFont8) //"Nro.Documento"
oPrint:Say  (2230,605 ,aDadosTit[1]                                     ,oFont10)

oPrint:Say  (2200,1005,STR0020                                   ,oFont8) //"EspИcie Doc."

oPrint:Say  (2200,1355,STR0021                                         ,oFont8) //"Aceite"
oPrint:Say  (2230,1455,"N"                                             ,oFont10)

oPrint:Say  (2200,1555,STR0022                          ,oFont8) //"Data do Processamento"
oPrint:Say  (2230,1655,DTOC(aDadosTit[2])                               ,oFont10)

oPrint:Say  (2200,1910,STR0013                                   ,oFont8) //"Nosso NЗmero"
oPrint:Say  (2230,2010,aDadosTit[6]                                     ,oFont10)

oPrint:Say  (2270,100 ,STR0023                                   ,oFont8) //"Uso do Banco"

oPrint:Say  (2270,505 ,STR0024                                       ,oFont8) //"Carteira"
oPrint:Say  (2300,555 ,cCart                                   ,oFont10)

oPrint:Say  (2270,755 ,STR0025                                        ,oFont8) //"EspИcie"
oPrint:Say  (2300,805 ,STR0026                                             ,oFont10) //"R$"

oPrint:Say  (2270,1005,STR0027                                     ,oFont8) //"Quantidade"
oPrint:Say  (2270,1555,STR0028                                          ,oFont8) //"Valor"

oPrint:Say  (2270,1910,STR0029                          ,oFont8) //"(=)Valor do Documento"
oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (2340,100 ,STR0030,oFont8) //"InstruГУes/Texto de responsabilidade do cedente"

nMsg:=2390
For nI := 1 To len(aMsgBoleto)
	oPrint:Say  (nMsg,120,aMsgBoleto[nI]                ,oFont10 )
	nMsg+=50
	If nI > 6
		Exit
	EndIf
Next nI

oPrint:Say  (2340,1910,STR0031                         ,oFont8) //"(-)Desconto/Abatimento"
oPrint:Say  (2370,2010,AllTrim(Transform(nAbatim,"@ZE 999,999,999.99")),oFont10)

oPrint:Say  (2410,1910,STR0032                             ,oFont8) //"(-)Outras DeduГУes"
oPrint:Say  (2480,1910,STR0033                                  ,oFont8) //"(+)Mora/Multa"
oPrint:Say  (2550,1910,STR0034                           ,oFont8) //"(+)Outros AcrИscimos"
oPrint:Say  (2580,2010,AllTrim(Transform(nAcrescim,"@ZE 999,999,999.99")),oFont10)
oPrint:Say  (2620,1910,STR0035                               ,oFont8) //"(-)Valor Cobrado"

oPrint:Say  (2690,100 ,STR0036                                         ,oFont8) //"Sacado"
oPrint:Say  (2720,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2773,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (2826,400 ,aDatSacado[4]+" - "+aDatSacado[5]                ,oFont10)
oPrint:Say  (2879,400 ,aDatSacado[6]                                    ,oFont10)

oPrint:Say  (2895,100 ,STR0037                               ,oFont8) //"Sacador/Avalista"
oPrint:Say  (2935,1500,STR0038                        ,oFont8) //"AutenticaГЦo MecБnica -"
oPrint:Say  (2935,1850,STR0039                           ,oFont10) //"Ficha de CompensaГЦo"

oPrint:Line (2000,1900,2690,1900 )
oPrint:Line (2410,1900,2410,2300 )
oPrint:Line (2480,1900,2480,2300 )
oPrint:Line (2550,1900,2550,2300 )
oPrint:Line (2620,1900,2620,2300 )
oPrint:Line (2690,100 ,2690,2300 )

oPrint:Line (2930,100,2930,2300  )
//MSBAR(CB_RN_NN[2] ,26,1.5,CB_RN_NN[1],oPrint,.F.,,,,1.2,,,,.F.)
//MSBAR("INT25",26,1.5,CB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.2,Nil,Nil,"A",.F.) 


MSBAR3("INT25",21.5,1,CB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.2,Nil,Nil,"A",.F.)


oPrint:EndPage() // Finaliza a pАgina

Return Nil
          
/*/
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠здддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma   ЁR580Graf02Ё Autor ЁGeraldo Felix Junior...Ё Data Ё 13.07.04 Ё╠╠
╠╠цдддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescricao  Ё Imprime Boleto em modo grafico padrao Cooperativa...       Ё╠╠
╠╠здддддддддддеддддддддддбддддддддддддддддддддддддддддддддддддддддддддддддд©╠╠
╠╠ЁAlteracoes Ё Data     ЁMotivo                                           Ё╠╠
╠╠цдддддддддддеддддддддддеддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁRafael     Ё03/02/2004ЁAlteracao de Lay out da emissao de boletos.      Ё╠╠
╠╠ЁMarchette  Ё 		 Ё- Header - Dados da empresa e dados ANS          Ё╠╠
╠╠ЁQuadrotti  Ё 		 Ё- Extrato- Impressao de dependentes e meses em   Ё╠╠
╠╠Ё           Ё 		 Ёatraso.                                          Ё╠╠
╠╠Ё           Ё 		 Ё- Extrato- Inclusao da observacao no extrato.    Ё╠╠
╠╠Ё           Ё 		 Ё- Ficha de Comp. - Correcao do codigo de barras  Ё╠╠
╠╠Ё           Ё 		 Ё- Ficha de Comp. - Alteracao de textos de instru-Ё╠╠
╠╠Ё           Ё 		 Ёcoes/responsabilidade do cedente.                Ё╠╠
╠╠юдддддддддддаддддддддддаддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
/*/

Static Function R580Graf02(	aCobranca	,nAbatim	,nAcrescim	,oPrint		,;
							aBMP		,aDadosEmp	,aDadosTit	,aDadosBanco,;
							aDatSacado	,aMsgBoleto	,CB_RN_NN	,aOpenMonth	,;
							aDependentes,aObservacoes,cCart, cTipoUS, lUnimeds, aMsgCorpo )
							
Local oFont8	// --©
Local oFont10	// 	 |
Local oFont11n	// 	 |
Local oFont13n	// 	 |
Local oFont15n	// 	 ц- Fontes para impressao do relatorio grafico.
Local oFont16	// 	 |
Local oFont16n	// 	 |
Local oFont21	// --ы

Local bPrn1

Local cPrn1		:= ""				// String com informacoes de cobranca para impresao
Local cPrn2		:= ""				// String com informacoes de cobranca para impresao


Local nLinha	:= 0				// Linha impressa
LOCAL nColuna	:= 1				// Contador para colunas
LOCAL nLimCol	:= 0				// Limite de linhas por coluna do boleto!
LOCAL nLinCon	:= 0				// Contador de linhas
LOCAL nControl 	:= 0				// Controle de linhas impressas no corpo do boleto
LOCAL nContAux	:= 0 				// Controle de linhas impressas no corpo do boleto		

Local i 		:= 0    			// Contador
Local nMosCob 	:= 0				// Contador para for
Local nCobra 	:= 0				// Contador para cobranca
Local nTotSm	:= 0				// Valor total do Ato cooperado principal (servico medico)
Local nTotSa	:= 0				// Valor total do Ato cooperado Acessorio (servico acessorio)
Local nI		:= 0				// Contador do laco para impressao de dependentes.
Local nMsg      := 0    			// Contador para as mensagens
LOCAL nResto	:= 0

local nColVal   := 2050				// Variaveis com as posicoes de impressao
Local nColCon	:= 170				// Variavel com as posicao de impressao do contrato
Local nColSub	:= 115				// Variavel com as posicao de impressao do sub contrato
Local nColPro	:= 170				// Variavel com as posicao de impressao do Produto
Local nColFai	:= 240				// Variavel com as posicao de impressao da Faixa
local nColDes   := 115 				// Variaveis com as posicoes de impressao 
local nColVal1  := 2050				// Variaveis com as posicoes de impressao
Local nColCon1	:= 1255				// Variavel com as posicao de impressao do contrato
Local nColSub1	:= 1200				// Variavel com as posicao de impressao do sub contrato
Local nColPro1	:= 1255				// Variavel com as posicao de impressao do Produto
Local nColFai1	:= 1350				// Variavel com as posicao de impressao da Faixa

LOCAL nClRes1	:= 115
LOCAL nClRes2	:= 600
LOCAL nClRes3	:= 750

LOCAL nClRes11	:= 1200
LOCAL nClRes22	:= 1685
LOCAL nClRes33	:= 1835

// 19 linha de extrato duplo.
Local aLinhas	:= { 750, 800, 850, 900, 950, 1000, 1050, 1000, 1100, 1150, 1200, 1250 ,1300 ,1350 ,1400 ,1450 ,1500 ,1550 ,1600 }
Local aBitmap 	:= aClone(aBmp)		// Array com os bmps para impressao
LOCAL aResumo   := {}

LOCAL lPulaLinha:= .F.
LOCAL lDividePag:= .F.
Local nCnt		:= 0
                        
// Variaveis totalizadoras...
Private _nMensalidade 	:= 0
Private _nOpcionais 	:= 0
Private _nInscricao 	:= 0
Private _nTamanho		:= 0

//ParБmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7n := TFont():New("Arial",9,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont21 := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁMonta o resumos do boleto e calcula tamanho real do array p/ impressao...  |
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

For nCnt := 1 To Len(aCobranca)
	
	If aCobranca[nCnt][1] $ '05,06'
		If (nPos := Ascan(aResumo, {|x| x[1] == aCobranca[nCnt][12] } ) ) == 0
			Aadd(aResumo,{ aCobranca[nCnt][12], aCobranca[nCnt][13], aCobranca[nCnt][2], aCobranca[nCnt][3] })
		Else
			aResumo[nPos][3] +=  aCobranca[nCnt][2]
			aResumo[nPos][4] +=  (aCobranca[nCnt][2] * aCobranca[nCnt][3])
		Endif
	
	    If aCobranca[nCnt][1] == '05'
			_nTamanho++
		Endif
	Endif
Next

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁImprime todo esquema de cabecalho do boleto...                   Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
_nTamanho += ( Len(aMsgCorpo) + Len(aResumo) )

R580CabGrf02(oPrint, oFont8, oFont10, oFont11n, aDadosTit, aDatSacado,  aDadosBanco, aDadosEmp, aBitMap, aDependentes, aOpenMonth, aCobranca, _nTamanho)


//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDefine o limite de linhas por coluna para a primeira pagina do   Ё
//Ёboleto de acorado com a quantidade de informacao a ser impressa. Ё
//ЁA definicao de tamanho para as demais pagina sera feita durante aЁ
//Ёimpressao do mesmo...                                            Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If _nTamanho > 50
	nLimCol := 3108
Else
	nLimCol := 1512
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁCorpo do boleto...                                               Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RESETLIN	// Reset linha
If (Alltrim(BA3->BA3_MODPAG) == '1' .and. mv_par19 <> 3) .or. Alltrim(BA3->BA3_MODPAG) <> '1'
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁTitulos do quadro da boleta...                                   Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	
	oPrint:Say (525,109  ,STR0051				,oFont8 )   // "Descricao"
	oPrint:Say (525,1909 ,STR0009				,oFont8 )	// "Valor R$"

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁImprime os itens do Ato Cooperado principal...(Servicos medicos) Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	For nCnt := 1 To  Len(aCobranca)
		If aCobranca[nCnt][1] == "101"
			_nMensalidade += aCobranca[nCnt][3]
			
		Elseif aCobranca[nCnt][1] == "102"
			_nOpcionais   += aCobranca[nCnt][3]
			
		Elseif aCobranca[nCnt][1] == "103"
			_nInscricao   += aCobranca[nCnt][3]
			
		Endif
		
		If aCobranca[nCnt][4] <> '1'
			Loop
		Endif
		cPrn1 := AllTrim(aCobranca[nCnt][1]) + " - " +AllTrim(aCobranca[nCnt][2])
		cPrn2 := " R$ " + Trans(aCobranca[nCnt][3], "@E 99,999.99")
		
		oPrint:Say (nLinha,nColDes ,cPrn1,oFont8 )  // Descricao do Servico
		oPrint:Say (nLinha,nColVal ,cPrn2,oFont8 )  // Valor do Servico
		
		nLinha += 45
		
		nTotSm += aCobranca[nCnt][3]		
	Next
	If nTotSm > 0
		oPrint:Say (nLinha,nColDes ,"----------------> TOTAL ATO COOPERATIVO PRINCIPAL",oFont10 )  // Texto totalizador
		
		cPrn2 := " R$ " + Trans(nTotSm, "@E 99,999.99")
		oPrint:Say (nLinha,nColVal ,cPrn2,oFont10 )
		
		If nTotSm > 0
			nLinha += 80
		Endif
	Endif
	
	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁImprime os itens do Ato Cooperado Acessorio...(Servico Acessorio)      Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	For nCnt := 1 To  Len(aCobranca)
		If !(aCobranca[nCnt][4] $ '0, ')
			Loop
		Endif
		cPrn1 := AllTrim(aCobranca[nCnt][1]) + " - " +AllTrim(aCobranca[nCnt][2])
		cPrn2 := " R$ " + Trans(aCobranca[nCnt][3], "@E 99,999.99")
	
		oPrint:Say (nLinha,nColDes ,cPrn1,oFont8 )  // Descricao do Servico
		oPrint:Say (nLinha,nColVal ,cPrn2,oFont8 )  // Valor do Servico
	
		nLinha += 45
	
		nTotSa += aCobranca[nCnt][3]
	Next               
	If nTotSa > 0
		oPrint:Say (nLinha,nColDes ,"----------------> TOTAL ATO COOPERATIVO ACESSORIO",oFont10 )  // Texto totallizador

		cPrn2 := " R$ " + Trans(nTotSa, "@E 99,999.99")
		oPrint:Say (nLinha,nColVal ,cPrn2,oFont10 )			
	Endif	
	                                	
Else
	For nCnt := 1 To Len(aCobranca)
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Variavel que controla aquantidade de itens do array que ja foram impressas  |
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
		nContAux ++

		If nLinha > nLimCol 
						
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Redefine a coluna a ser impressa...                                   Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
			If nColuna == 1
				nColuna := 2
			Else
				nColuna := 1

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё O nResto indicara se sera necessario mais uma pagina para impressao   Ё
				//Ё extrato do boleto, quando nResto for menor que 58, esta sera a ultima Ё			
				//Ё pagina...                                                             Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
				nResto := (_nTamanho-nContAux)                  
				                           
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁRedefine o limite de linhas por coluna do boleto...              Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды				            
				If nResto > 50
					nLimCol := 3108
				Else
					nLimCol := 1512
				Endif
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Finaliza a pАgina...          										  Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
				oPrint:EndPage() 
			
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Houve mudanca de pagina, imprimi cabecalho na nova pagina...          Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
				R580CabGrf02(oPrint, oFont8, oFont10, oFont11n, aDadosTit, aDatSacado,  aDadosBanco, ;
						 aDadosEmp, aBitMap, aDependentes, aOpenMonth, aCobranca, nResto)
				
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Linha inicial...                                                      Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды					
			RESETLIN
		Endif

		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁImprime contrato...                                              Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	        		
		If aCobranca[nCnt][1]=='01'  
			oPrint:Say (nLinha,Iif(nColuna==1, nColCon, nColCon1) ,aCobranca[nCnt][2],oFont8 )  
			nLinha += 38
		Endif
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁImprime sub contrato...                                          Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	        		
		If aCobranca[nCnt][1]=='02'  
			oPrint:Say (nLinha,Iif(nColuna==1, nColSub, nColSub1) ,aCobranca[nCnt][2],oFont8 )  
			nLinha += 38
		Endif		
                                      
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁImprime Produto ou a taxa de adesao...                           Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды	        		
		If aCobranca[nCnt][1]=='03' .or. aCobranca[nCnt][1]=='04'
			oPrint:Say (nLinha,Iif(nColuna==1, nColPro, nColPro1) ,aCobranca[nCnt][2],oFont8 )  
			nLinha += 38
		Endif                                                                                           
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//ЁImprime o detalhamento por faixa etaria...                       Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		                     
		If aCobranca[nCnt][1] == '05'
			For i := nCnt To Len(aCobranca) 
				If aCobranca[i][1] <> '05'
					nLinha += 10
					nCnt := (i-1)
					Exit
				Endif
				                     
				If aCobranca[i][12] $ '101,102,103' 
					oPrint:Say (nLinha,Iif(nColuna==1, nColFai, nColFai1),"Faixa de "+StrZero(aCobranca[i][4],3)+" a "+;
									StrZero(aCobranca[i][5],3)+"     -   "+;
									Transform(aCobranca[i][2], "@E 999999")+"      x   "+;
									Transform(aCobranca[i][3], "@E 99,999.99")+"      =   "+;
									Transform((aCobranca[i][3]*aCobranca[i][2]),"@E 999,999.99"),oFont7 )
				Endif
				nLinha += 38
				nContAux ++
			Next
			nLinha += 20
		Endif
	Next			

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Imprime resumo da cobranca... Da um salto de linha com 20 pontos...   Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды			                    
	nLinha += 20
	For nCnt := 1 To Len(aResumo)
	
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Valida se a linha ultrapassou o limete por coluna, de acordo com o tamanho da pagina... |
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды			
		If nLinha > nLimCol 
						
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Redefine a coluna a ser impressa...                                   Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
			If nColuna == 1
				nColuna := 2
			Else
				nColuna := 1

				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё O nResto indicara se sera necessario mais uma pagina para impressao   Ё
				//Ё extrato do boleto, quando nResto for menor que 58, esta sera a ultima Ё			
				//Ё pagina...                                                             Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
				nResto := (_nTamanho-nContAux)                  
				                           
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//ЁRedefine o limite de linhas por coluna do boleto...              Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды				            
				If nResto > 50
					nLimCol := 3108
				Else
					nLimCol := 1512
				Endif
				
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Finaliza a pАgina...          										  Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
				oPrint:EndPage() 
			
				//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Houve mudanca de pagina, imprimi cabecalho na nova pagina...          Ё
				//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
				R580CabGrf02(oPrint, oFont8, oFont10, oFont11n, aDadosTit, aDatSacado,  aDadosBanco, ;
						 aDadosEmp, aBitMap, aDependentes, aOpenMonth, aCobranca, nResto)
				
			Endif

			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Linha inicial...                                                      Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды					
			RESETLIN
		Endif	                                                                                        
		
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Imprime a linha do resumo!                                            Ё
		//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды					
		oPrint:Say(nLinha,Iif(nColuna==1, nClRes1, nClRes11),Left(aResumo[nCnt][2],30), oFont7n)		
		oPrint:Say(nLinha,Iif(nColuna==1, nClRes2, nClRes33),"   -   "+Transform(aResumo[nCnt][3], "@E 999999"), oFont7n)
		oPrint:Say(nLinha,Iif(nColuna==1, nClRes3, nClRes55),Transform(aResumo[nCnt][4],"@E 999,999.99"), oFont7n)		

		nLinha += 38
		nContAux ++
				
	Next
	
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁImprime o rodape, mensagens e as demais informacoes sobre o boleto...  |
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
R580RodGrf02(oPrint, aDadosTit, aDatSacado,aDadosBanco, aDadosEmp, aBitMap, aDependentes,aOpenMonth,;
			 aCobranca, nResto, aMsgCorpo, aObservacoes, aMsgBoleto, CB_RN_NN,;
			 cCart, nAbatim, nAcrescim, nLimCol, nLinha, nColuna)

Return()



/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁR580CabGrf02  ╨Autor  ЁGeraldo Felix Junior╨ Data Ё  09/14/04   ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁCabecalho do boleto utilizado no modelo 2 ( Para cooperativas ) ╨╠╠
╠╠╨          Ё                                                                ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP                                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/              
Static Function R580CabGrf02(oPrint, oFont8, oFont10, oFont11n, aDadosTit, aDatSacado,;
						     aDadosBanco, aDadosEmp, aBitMap, aDependentes,aOpenMonth,; 
						     aCobranca, nLinhas)
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDeclara variaveis...                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
local nColDes   := 115 				// Variaveis com as posicoes de impressao 
Local nColCon	:= 170				// Variavel com as posicao de impressao do contrato
Local nColSub	:= 115				// Variavel com as posicao de impressao do sub contrato
Local nColPro	:= 170				// Variavel com as posicao de impressao do Produto
Local nColFai	:= 320				// Variavel com as posicao de impressao da Faixa
Local nContLn	:= 0				// Controle de linhas para impressao de dependentes.

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁInicia uma nova pagina...                                        Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oPrint:StartPage()
                                                      
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁImprime os dados da empresa....                                  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oPrint:Say  (050	,500	,aDadosEmp[1]	,oFont11n)
oPrint:Say  (090	,500	,aDadosEmp[2] 	,oFont8 )
oPrint:Say  (125	,500	,aDadosEmp[3] 	,oFont8 )
oPrint:Say  (160	,500	,aDadosEmp[4] 	,oFont8 )
oPrint:Say  (195	,500	,aDadosEmp[5] 	,oFont8 )
oPrint:Say  (230	,500	,aDadosEmp[6] 	,oFont8 )

//здддддддддд©
//ЁBmp da ANSЁ
//юдддддддддды
If File(SuperGetMv("MV_PLSLANS", .F., "ANS.BMP"))
	oPrint:SayBitmap (050 ,1825,SuperGetMv("MV_PLSLANS", .F., "ANS.BMP"),470 ,150)
Else
	oPrint:Say  (050 ,1825,aDadosEmp[7] ,oFont10)
Endif

oPrint:Say  (250,1780,STR0044 + R580Imp->E1_MESBASE+" / "+R580Imp->E1_ANOBASE ,oFont10) //"MЙs de competЙncia: "

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁLogo do boleto...				                                Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oPrint:SayBitmap (50 ,100,aBitMap[1],250 ,200 )		// 

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁMonta o corpo do boleto! O tamanho pode variar de acordo com a quantidade de linhas a serem impressas!   |
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nLinhas > 50   					// 25 eh o limite de linhas no formato padrao do bolote,
	oPrint:Box  (300,100,3200,2300)	// caso tenha mais linhas que isso, sera gerado um boleto com duas ou mais paginas...
	oPrint:Line (300,1150,3200,1150)
Else
	oPrint:Box  (300,100,1852,2300)
	oPrint:Line (300,1150,Iif(mv_par19==3,1620,400),1150)
Endif                                                                

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁMonta as linhas das caixinhas do cabecalho do boleto...          Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oPrint:Line (400,0100,400,2300)
oPrint:Line (520,0100,520,2300)  // Linha inferior dos dados do sacado!
oPrint:Line (300,0400,400,0400)
oPrint:Line (300,0800,400,0800)
oPrint:Line (300,1500,400,1500)
oPrint:Line (300,1900,Iif(mv_par19==3,400,1620),1900)  // Limite esquerdo do campo "nosso numero"

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDados do cabecalho do boleto...                                  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oPrint:Say  (300,105,STR0008                ,oFont8 ) 	//"Vencimento"
oPrint:Say  (345,205,DTOC(aDadosTit[4])     ,oFont10)

oPrint:Say  (300,405,STR0009                ,oFont8 ) 	//"Valor R$"
oPrint:Say  (345,505,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (300,805,STR0010             	,oFont8 ) 	//"Data de EmissЦo"
oPrint:Say  (345,905,DTOC(aDadosTit[3])     ,oFont10)

oPrint:Say  (300,1155,STR0011            	,oFont8 ) 	//"Nro.do Documento"
oPrint:Say  (345,1255,aDadosTit[1]          ,oFont10)

oPrint:Say  (300,1505,STR0012      			,oFont8 ) 	//"AgЙncia/CСdigo Cedente"
oPrint:Say  (345,1555,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (300,1905,STR0013               ,oFont8 ) 	//"Nosso NЗmero"
oPrint:Say  (345,1950,aDadosTit[6]          ,oFont10)

oPrint:Say  (400,105 ,STR0004                  ,oFont8 ) //"Dados do Sacado"
oPrint:Say  (450,115 ,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont8)

Return()


/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁR580CabGrf02  ╨Autor  ЁGeraldo Felix Junior╨ Data Ё  09/14/04   ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRodape    do boleto utilizado no modelo 2 ( Para cooperativas ) ╨╠╠
╠╠╨          Ё                                                                ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP                                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/              
Static Function R580RodGrf02(oPrint, aDadosTit, aDatSacado,aDadosBanco, aDadosEmp, aBitMap, aDependentes,aOpenMonth,; 
						     aCobranca, nResto, aMsgCorpo, aObservacoes, aMsgBoleto, CB_RN_NN ,cCart,;
						     nAbatim,  nAcrescim, nLimCol, nLinha, nColuna)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁDefine variaveis...                                                        Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local aCoords1 	:= {2000,1900,2100,2300}
Local aCoords2 	:= {2270,1900,2340,2300}   
local nColVal   := 2050				// Variaveis com as posicoes de impressao
Local oBrush          
Local cMoeda	:= "9"  			// Moeda do boleto.
Local nColSub	:= 115				// Variavel com as posicao de impressao do sub contrato
Local nColSub1	:= 1200				// Variavel com as posicao de impressao do sub contrato

Local oFont8	// --©
Local oFont10	// 	 |
Local oFont11n	// 	 |
Local oFont13n	// 	 |
Local oFont15n	// 	 ц- Fontes para impressao do relatorio grafico.
Local oFont16	// 	 |
Local oFont16n	// 	 |
Local oFont21	// --ы
Local nCnt		:= 0
Local nI		:= 0

//ParБmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11n:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13n:= TFont():New("Arial",9,13,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont21 := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)

oBrush := TBrush():New("",4)

If nResto > 50 .or. nLimCol > 3000
	oPrint:EndPage()	// Finaliza pagina para inicializar outra em R580CabGrf02!
	RESETLIN			// Reseta o contador de linha!
	oPrint:EndPage() 	// Finaliza a pАgina!
		
	R580CabGrf02(oPrint, oFont8, oFont10, oFont11n, aDadosTit, aDatSacado,  aDadosBanco, ;
				 aDadosEmp, aBitMap, aDependentes, aOpenMonth, aCobranca, 1)	
Endif
	
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁLimites inferiores do corpo do boleto...                                   Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
oPrint:Line (1902,100,1902,2300)	// Tracejado para destaque do boleto.
oPrint:Line (1625,100,1625,2300)	// Limite para observacao

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁImprime as mensagens do corpo do boleto...                                 Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nLinha += 100
For nCnt := 1 To Len(aMsgCorpo)    
	If ! Empty(aMsgCorpo[nCnt])
   		cPrn1 := "{ ||"+aMsgCorpo[nCnt]+" }"
	   	bPrn1 := &cPrn1
		If nLinha > nLimCol 
						
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё Redefine a coluna a ser impressa...                                   Ё
			//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды		
			If nColuna == 1
				nColuna := 2
			Else
				nColuna := 1
			Endif	   
			RESETLIN
		Endif
		
	   oPrint:Say (nLinha,Iif(nColuna == 1,nColSub,nColSub1) ,Eval(bPrn1),oFont8 )  // Texto totallizador
	   nLinha += 45
	Endif   
Next

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁImprime as observacoes...                                                  Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
nMsg:=1650
oPrint:Say  (1625,105,STR0014               ,oFont8 ) 	//"ObservaГЦo"
For nI := 1 To len(aObservacoes)
	oPrint:Say  (nMsg,105,aObservacoes[nI]  ,oFont8 )
	nMsg+=30
	If nI > 5
		Exit
	EndIf
Next nI

oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)

//здддддддддддддддддддддддддддд©
//ЁEmissao dos dados do sacado.Ё
//юдддддддддддддддддддддддддддды
//oPrint:Say  (1585,1790 		,STR0052                  ,oFont10 ) //"TOTAL"
//oPrint:Say  (1585,nColVal 	," R$ "+Transform((nTotSm+nTotSa),"@E 999,999,999.99"),oFont10 ) 

oPrint:Line (2000,100,2000,2300)
oPrint:Line (2000,550,1920,550 )
oPrint:Line (2000,770,1920,770 )
oPrint:Say  (1934,100,Substr(aDadosBanco[2],1,13),oFont16 )
oPrint:Say  (1912,567,aDadosBanco[1]+"-"+cMoeda,oFont21 )
oPrint:Say  (1934,790,CB_RN_NN[2],oFont13n)

oPrint:Line (2100,100,2100,2300 )
oPrint:Line (2200,100,2200,2300 )
oPrint:Line (2270,100,2270,2300 )
oPrint:Line (2340,100,2340,2300 )

oPrint:Line (2200,500,2340,500)
oPrint:Line (2270,750,2340,750)
oPrint:Line (2200,1000,2340,1000)
oPrint:Line (2200,1350,2270,1350)
oPrint:Line (2200,1550,2340,1550)

oPrint:Say  (2000,100 ,STR0015                             			,oFont8) //"Local de Pagamento"
oPrint:Say  (2040,100 ,STR0016        								,oFont10) //"Qualquer banco atИ a data do vencimento"

oPrint:Say  (2000,1910,STR0008                                     	,oFont8) //"Vencimento"
oPrint:Say  (2040,2010,DTOC(aDadosTit[4])                           ,oFont10)

oPrint:Say  (2100,100 ,STR0017                                      ,oFont8) //"Cedente"
oPrint:Say  (2140,100 ,aDadosEmp[1]                                 ,oFont10)

oPrint:Say  (2100,1910,STR0012                         				,oFont8) //"AgЙncia/CСdigo Cedente"
oPrint:Say  (2140,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)

oPrint:Say  (2200,100 ,STR0018                              		,oFont8) //"Data do Documento"
oPrint:Say  (2230,100 ,DTOC(aDadosTit[3])                           ,oFont10)

oPrint:Say  (2200,505 ,STR0019                                  	,oFont8) //"Nro.Documento"
oPrint:Say  (2230,605 ,aDadosTit[1]                                 ,oFont10)

oPrint:Say  (2200,1005,STR0020                                   	,oFont8) //"EspИcie Doc."

oPrint:Say  (2200,1355,STR0021                                      ,oFont8) //"Aceite"
oPrint:Say  (2230,1455,"N"                                          ,oFont10)

oPrint:Say  (2200,1555,STR0022                          			,oFont8) //"Data do Processamento"
oPrint:Say  (2230,1655,DTOC(aDadosTit[2])                           ,oFont10)

oPrint:Say  (2200,1910,STR0013                                   	,oFont8) //"Nosso NЗmero"
oPrint:Say  (2230,2010,aDadosTit[6]                                 ,oFont10)

oPrint:Say  (2270,100 ,STR0023                                   	,oFont8) //"Uso do Banco"

oPrint:Say  (2270,505 ,STR0024                                      ,oFont8) //"Carteira"
oPrint:Say  (2300,555 ,cCart                                   		,oFont10)

oPrint:Say  (2270,755 ,STR0025                                      ,oFont8) //"EspИcie"
oPrint:Say  (2300,805 ,STR0026                                      ,oFont10) //"R$"

oPrint:Say  (2270,1005,STR0027                                     	,oFont8) //"Quantidade"
oPrint:Say  (2270,1555,STR0028                                      ,oFont8) //"Valor"

oPrint:Say  (2270,1910,STR0029                          			,oFont8) //"(=)Valor do Documento"
oPrint:Say  (2300,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say  (2340,100 ,STR0030,oFont8) //"InstruГУes/Texto de responsabilidade do cedente"

nMsg:=2390
For nI := 1 To len(aMsgBoleto)
	oPrint:Say  (nMsg,120,aMsgBoleto[nI]                			,oFont10 )
	nMsg+=50
	If nI > 6
		Exit
	EndIf
Next nI

oPrint:Say  (2340,1910,STR0031                         				,oFont8) //"(-)Desconto/Abatimento"
oPrint:Say  (2370,2010,AllTrim(Transform(nAbatim,"@ZE 999,999,999.99")),oFont10)

oPrint:Say  (2410,1910,STR0032                             			,oFont8) //"(-)Outras DeduГУes"
oPrint:Say  (2480,1910,STR0033                                  	,oFont8) //"(+)Mora/Multa"
oPrint:Say  (2550,1910,STR0034                           			,oFont8) //"(+)Outros AcrИscimos"
oPrint:Say  (2580,2010,AllTrim(Transform(nAcrescim,"@ZE 999,999,999.99")),oFont10)
oPrint:Say  (2620,1910,STR0035                               		,oFont8) //"(-)Valor Cobrado"

oPrint:Say  (2690,100 ,STR0036                                      ,oFont8) //"Sacado"
oPrint:Say  (2720,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"         ,oFont10)
oPrint:Say  (2773,400 ,aDatSacado[3]                                ,oFont10)
oPrint:Say  (2826,400 ,aDatSacado[4]+" - "+aDatSacado[5]            ,oFont10)
oPrint:Say  (2879,400 ,aDatSacado[6]                                ,oFont10)

oPrint:Say  (2895,100 ,STR0037                               		,oFont8) //"Sacador/Avalista"
oPrint:Say  (2935,1500,STR0038                        				,oFont8) //"AutenticaГЦo MecБnica -"
oPrint:Say  (2935,1850,STR0039                           			,oFont10) //"Ficha de CompensaГЦo"

oPrint:Line (2000,1900,2690,1900 )
oPrint:Line (2410,1900,2410,2300 )
oPrint:Line (2480,1900,2480,2300 )
oPrint:Line (2550,1900,2550,2300 )
oPrint:Line (2620,1900,2620,2300 )
oPrint:Line (2690,100 ,2690,2300 )

oPrint:Line (2930,100,2930,2300  )

MSBAR3("INT25",21.5,1,CB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.2,Nil,Nil,"A",.F.)

oPrint:EndPage() // Finaliza a pАgina

Return(NIL)

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Funcao    ЁPLR580MES ╨Autor  ЁRafael M. Quadrotti ╨ Data Ё  02/04/04   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRetorna os meses em aberto do sacado.                       ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP6                                                        ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function PLR580MES(cCliente,cLoja,cMesBase,cAnoBase,cTipo)
Local aMeses 	:= {} 							//Retorno da funcao.
Local cSQL      := ""							//Query
Local cSE1Name 	:= SE1->(RetSQLName("SE1"))	//retorna o alias no TOP.

SE1->(DbSetOrder(1))

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta query...                                                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cSQL := "SELECT * FROM "+cSE1Name+" WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND "
cSQL += "			E1_CLIENTE + E1_LOJA = '"+cCliente+cLoja+"' AND "
cSQL += "			E1_SALDO > 0 AND "
cSQL += "			E1_PARCELA <> '" + StrZero(0, Len(SE1->E1_PARCELA)) + "' AND "
cSql += "			E1_TIPO = '"+cTipo+"' AND "
cSQL += cSE1Name+".D_E_L_E_T_ = '' "
cSQL += "ORDER BY " + SE1->(IndexKey())

PLSQuery(cSQL,STR0040) //"Meses"

If Meses->(Eof())
	Meses->(DbCloseArea())
	Aadd(aMeses,"")
Else
	While 	!Eof() .And.;
		Meses->E1_CLIENTE == cCliente .And.;
		Meses->E1_LOJA ==	cLoja
		If (E1_MESBASE+E1_ANOBASE < cMesBase+cAnoBase) .and. dTos(E1_VENCTO) < dTos(dDatabase)
			If Ascan(aMeses, E1_MESBASE+"/"+E1_ANOBASE ) == 0
				Aadd(aMeses,E1_MESBASE+"/"+E1_ANOBASE)
			Endif
		EndIf	
		DbSkip()
	End
	Meses->(DbCloseArea())
EndIf
Return (aMeses)


/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Funcao    ЁPLR580TEXT╨Autor  ЁRafael M. Quadrotti ╨ Data Ё  02/04/04   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     ЁRetorna as mensagens para impressao.                        ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨          Ё Esta funcao executa uma selecao em tres tabelas para       ╨╠╠
╠╠╨          Ё encontrar a msg relacionada ao sacado.                     ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP6                                                        ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
Static Function PLR580TEXT(	nTipo	,cCodInt	,cCodEmp,cConEmp,;
							cSubCon	,cMatric	,cBase	,cModPag,;
							cTipoUS	)//cBase = Ano+mes
Local cQuery  	 := ""
Local cNTable1   := "" // Nome da tabela no SQL
Local cNTable2   := "" // Nome da tabela no SQL
Local cNTable3   := "" // Nome da tabela no SQL
Local aMsg		 := {} // Array de mensagens

DbSelectArea("BH1")
DbSetOrder(2)
cNTable1 := RetSqlName("BH1")
cNTable2 := RetSqlName("BA3")
cNTable3 := RetSqlName("BH2")

cQuery := "SELECT BH1.* ,BH2.* ,BA3.BA3_CODPLA,BA3.BA3_FILIAL,BA3.BA3_CODINT,BA3.BA3_CODEMP,BA3.BA3_MATRIC,BA3.BA3_CONEMP,BA3.BA3_VERCON,BA3.BA3_SUBCON,BA3.BA3_VERSUB "
cQuery += "FROM " +cNTable1+ " BH1 , " +cNTable2 +" BA3 , " +cNTable3 +" BH2 "

//BH1
cQuery += "WHERE BH1.BH1_FILIAL='"	+	xFilial("BH1")		+	"'    AND "
cQuery += "		 BH1.BH1_CODINT='"	+	cCodInt				+	"'    AND "
cQuery += "		 BH1.BH1_TIPO='"	+	Transform(nTipo,"9")+	"'    AND "
If !Empty(cCodEmp)
	cQuery += "(('"+cCodEmp +"' BETWEEN BH1.BH1_EMPDE   AND BH1.BH1_EMPATE) OR (BH1.BH1_EMPATE='' AND BH1.BH1_EMPDE='') ) AND "
EndIf
If !Empty(cConEmp)
	cQuery += "(('"+cConEmp +"' BETWEEN BH1.BH1_CONDE   AND BH1.BH1_CONATE)  OR (BH1.BH1_CONATE='' AND BH1.BH1_CONDE='') ) AND "
EndIf
If !Empty(cSubCon)
	cQuery += "(('"+cSuBCon +"' BETWEEN BH1.BH1_SUBDE   AND BH1.BH1_SUBATE)  OR (BH1.BH1_SUBATE='' AND BH1.BH1_SUBDE='') ) AND "
EndIf
If !Empty(cMatric)
	cQuery += "(('"+cMatric +"' BETWEEN BH1.BH1_MATDE   AND BH1.BH1_MATATE)  OR (BH1.BH1_MATATE='' AND BH1.BH1_MATDE='') ) AND "
EndIf
If !Empty(cBase)
	cQuery += "(('"+cBase   +"' BETWEEN BH1.BH1_BASEIN AND BH1.BH1_BASEFI) OR (BH1.BH1_BASEIN='' AND BH1.BH1_BASEFI='') ) AND "
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁExclusivo para cooperativa medica...                                       Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If nTipo == 5  
	cQuery += "(BH1_MODPAG = '"+cModPag+"' OR BH1_MODPAG = '3') AND "
	cQuery += "(BH1_TIPCON = '"+cTipoUS+"' OR BH1_TIPCON = '3') AND "
Endif 

//BA3 PARA ENCONTRAR O PLANO
cQuery += "		 BA3.BA3_FILIAL='"	+	xFilial("BA3")	+	"'    AND "
cQuery += "		 BA3.BA3_CODINT='"	+	cCodInt  		+	"'    AND "
cQuery += "		 BA3.BA3_CODEMP='"	+	cCodEmp  		+	"'    AND "
cQuery += "		 BA3.BA3_MATRIC='"	+	cMatric  		+	"'    AND "
cQuery += "		((BA3.BA3_CODPLA BETWEEN BH1.BH1_PLAINI AND BH1.BH1_PLAFIM) OR (BH1.BH1_PLAINI='' AND BH1.BH1_PLAFIM='') ) AND "

//BH2 MENSAGENS PARA IMPRESSAO
cQuery += "		 BH2.BH2_FILIAL = '"	+	xFilial("BH2")	+	"'    AND "
cQuery += "		 BH2.BH2_CODIGO = BH1.BH1_CODIGO  AND "

cQuery += "		BH1.D_E_L_E_T_<>'*' AND BA3.D_E_L_E_T_<>'*' AND BH2.D_E_L_E_T_<>'*' "
cQuery += "ORDER BY " + BH1->(IndexKey())

PLSQuery(cQuery,"MSG")

If MSG->(Eof())
	MSG->(DbCloseArea())
	Aadd(aMSG,"")
Else
	While 	!Eof()
		If Iif(BH1->(FieldPos("BH1_CONDIC")) > 0 , (Empty(MSG->BH1_CONDIC) .or. (&(MSG->BH1_CONDIC))), .T.)
			Aadd(aMSG,MSG->BH2_MSG01)
		Endif
		DbSkip()
	End
	MSG->(DbCloseArea())
EndIf

Return aMsg


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁRet_cBarraЁ Autor Ё Rafael M. Quadrotti   Ё Data Ё 13/10/03 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё IMPRESSAO DO BOLETO                                        Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё Especifico para Clientes Microsiga                         Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function Ret_cBarra(	cBanco	,cAgencia	,cConta		,cDacCC		,;
							cNroDoc	,nValor		,cPrefixo	,cNumero	,;
							cParcela	,cTipo	,cCart)
Local cMsg      := ""
Local aArea		:= GetArea()
Local aCodBar	:= {}
Local cMoeda	:= "9"

DbSelectArea("SE1")
DbSetOrder(1)
If MsSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela+cTipo)
	If !ExistBlock("RETDADOS")
	   MsgInfo(STR0046)  //"O RDMAKE, RETDADOS, referente ao layout do boleto, nЦo foi encontrado no repositСrio"
	Else
		aCodBar := ExecBlock("RETDADOS",.F.,.F.,{cPrefixo,cNumero,cParcela,cTipo,cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,cCart,cMoeda})
		
	   If Len(aCodBar)=3
	      If Empty(aCodBar[1])
		      cMsg     += STR0047  		//"[1]codigo de barra "
	      EndIf
	      If Empty(aCodBar[2])
		      cMsg     += STR0048  		//"[2]linha digitavel "
	      EndIf
	      If Empty(aCodBar[3])
		      cMsg     += STR0049 		//"[3]nosso numero "
	      EndIf
          If !empty(cMsg)
             MsgInfo(STR0050+cMsg )  	//"Erro no(s) campo(s): "
	         aCodBar	:= {}   
          EndIf
	   EndIf			
	EndIf   
EndIf
RestArea(aArea)
Return aCodBar

