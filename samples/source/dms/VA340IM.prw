// �����������������ͻ
// � Versao �  10    �
// �����������������ͼ
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "PROTHEUS.CH"

#define OLECREATELINK  400
#define OLECLOSELINK   401
#define OLEOPENFILE    403
#define OLESAVEASFILE  405
#define OLECLOSEFILE   406
#define OLESETPROPERTY 412
#define OLEWDVISIBLE   "206"
#define WDFORMATTEXT   "2" 
#define WDFORMATPDF    "17" // Formato PDF

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � VA340IM  � Autor �  Thiago               � Data � 25/06/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESS�O PESSOA F�SICA/JURIDICA - PRODUTOR/N�O PRODUTOR   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
*/
User Function VA340IM()

Local aParamBox := {}
Local aLojas    := {}
Local cCod      := ParamIxb[1]
Local cLoj      := ""
Local cAliasSA1 := "SQLSA1"

Private lAdjustToLegacy := .F.
Private lDisableSetup  := .T.
Private oPrinter   
Private cAliasVMS := "SQLVMS" 
Private cAliasVMI := "SQLVMI" 
Private cAliasVMH := "SQLVMH" 
Private aRet      := {}
Private cAliasVMJ := "SQLVMJ" 
Private cAliasVC3 := "SQLVC3" 
Private cAliasVP6 := "SQLVP6" 
Private CALIASVMR := "SQLVMR" 
Private CALIASVMD := "SQLVMD" 
Private CALIASVMF := "SQLVMF" 
Private CALIASVMN := "SQLVMN" 
Private CALIASVMV := "SQLVMV" 
Private cAliasVMK := "SQLVMK"    
Private cAliasVML := "SQLVML"    
Private CALIASVMW := "SQLVMW" 
Private CALIASVMM := "SQLVMM" 
Private CALIASVMT := "SQLVMT" 
Private CALIASVMQ := "SQLVMQ" 
//Private CALIASVMU := "SQLVMU"
Private cAliasSF2 := "SQLSF2"
Private aOutRen   := {}   
Private aRefBan   := {}   
Private aDepen    := {}   
Private aCompr    := {}
Private aFornec   := {}
Private aImoveis  := {}                      
Private aImoveisU := {}                      
Private aImoveisA := {}                      
Private aSuiClu   := {}                      
Private aProducao := {}                      
Private aVeiculos := {}  
Private aVeiculoV := {}  
Private aFil      := {}  
Private aAvi�rios := {}  
Private aMaqAgri  := {}  
Private aPartEmp  := {}     
Private aComprom  := {} 
Private aReceitas := {} 
Private aPresSrv  := {} 
Private aLeitera  := {} 
Private aOutEsp   := {} 
Private aIntegr   := {} 
Private aCorte    := {} 
Private dDat := ctod("     ")
Private aCulturas := {} 
Private aImplem   := {} 
Private cRenda    := ""  
Private cEstCiv   := ""
Private cRegime   := ""  
Private cMorada   := ""
Private y := 0 
//
Private oVerdana9 := TFont():New( 'Verdana' , 6 , 10 , , .F. , , , , .T. , .F. )
Private oVerdanaN := TFont():New( 'Verdana' , 7 , 11 , , .T. , , , , .T. , .F. )
//
Private l_PATRIM   := .f. // Patrimonio
Private l_IMVRURA  := .f. // Imoveis Rurais
Private l_IMVURBA  := .f. // Imoveis Urbanos
Private l_IMOARRE  := .f. // Imoveis Arrendados / Comodato
Private l_BENFINS  := .f. // Benfeitorias / Instalacoes
Private l_MAQAGRI  := .f. // Maquinas Agricolas
Private l_IMPOUT   := .f. // Implementos / Outros
Private l_VEICULO  := .f. // Veiculos
Private l_PARTEMP  := .f. // Participa��es em Empresas 
Private l_RECDESP  := .f. // Receitas / Despesas
Private l_CULAGRI  := .f. // Culturas Agricolas
Private l_PRODUCAO := .f. // Produ��o
Private l_PECUARIA := .f. // Pecu�ria
Private l_PRESTSRV := .f. // Presta��o de Servi�os
//
cQuery := "SELECT DISTINCT SA1.A1_LOJA FROM  "+RetSqlName( "SA1" ) + " SA1 "
cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = '"+cCod+"' AND SA1.D_E_L_E_T_ = ' '"

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSA1, .T., .T. )

Do While !( cAliasSA1 )->( Eof() )
	aadd(aLojas,A1_LOJA) 

	dbSelectArea(cAliasSA1)
	( cAliasSA1 )->(dbSkip())
	
Enddo
( cAliasSA1 )->( dbCloseArea() )

If len(aLojas) > 1
	AADD(aParamBox,{2,"Loja","",aLojas,35,"!Empty(MV_PAR01)",.t.}) // Loja
	If ParamBox(aParamBox,"Filiais",@aRet,,,,,,,,.f.) 
    	cLoj := aRet[1]
 	EndIf
ElseIf len(aLojas) == 1
   	cLoj := aLojas[1]
EndIf
If !empty(cLoj)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+cCod+cLoj)      
	//dDat := ctod("     ")
	dDat := dDataBase
	aParamBox := {}
	AADD(aParamBox,{1,"Data Base",dDat,"@D","!Empty(MV_PAR01)","",,50,.f.}) // Data
	AADD(aParamBox,{5,"Patrimonio",                        .t.,150,"",.f.})
	AADD(aParamBox,{5,"Imoveis Rurais",                    .t.,150,"",.f.})
	AADD(aParamBox,{5,"Imoveis Urbanos",                   .t.,150,"",.f.})
	AADD(aParamBox,{5,"Imoveis Arrendados / Comodato",     .t.,150,"",.f.})
	AADD(aParamBox,{5,"Benfeitorias / Instalacoes",        .t.,150,"",.f.})
	AADD(aParamBox,{5,"Maquinas Agricolas",                .t.,150,"",.f.})
	AADD(aParamBox,{5,"Implementos / Outros",              .t.,150,"",.f.})
	AADD(aParamBox,{5,"Veiculos",                          .t.,150,"",.f.})
	AADD(aParamBox,{5,"Participa��es em Empresas ",        .t.,150,"",.f.})
	AADD(aParamBox,{5,"Receitas / Despesas",               .t.,150,"",.f.})
	AADD(aParamBox,{5,"Culturas Agricolas",                .t.,150,"",.f.})
	AADD(aParamBox,{5,"Produ��o",                          .t.,150,"",.f.})
	AADD(aParamBox,{5,"Pecu�ria",                          .t.,150,"",.f.})
	AADD(aParamBox,{5,"Presta��o de Servi�os",             .t.,150,"",.f.})
	if ParamBox(aParamBox,"",@aRet,,,,,,,,.T.) 
		l_PATRIM   := aRet[02] // Patrimonio
		l_IMVRURA  := aRet[03] // Imoveis Rurais
		l_IMVURBA  := aRet[04] // Imoveis Urbanos
		l_IMOARRE  := aRet[05] // Imoveis Arrendados / Comodato
		l_BENFINS  := aRet[06] // Benfeitorias / Instalacoes
		l_MAQAGRI  := aRet[07] // Maquinas Agricolas
		l_IMPOUT   := aRet[08] // Implementos / Outros
		l_VEICULO  := aRet[09] // Veiculos
		l_PARTEMP  := aRet[10] // Participa��es em Empresas 
		l_RECDESP  := aRet[11] // Receitas / Despesas
		l_CULAGRI  := aRet[12] // Culturas Agricolas
		l_PRODUCAO := aRet[13] // Produ��o
		l_PECUARIA := aRet[14] // Pecu�ria
		l_PRESTSRV := aRet[15] // Presta��o de Servi�os
		//
	    if Len(Alltrim(SA1->A1_CGC)) > 12
			FS_INICPJ(cCod)    // inicio do relatorio pessoa juridica
		Else	
			FS_INICPF(cCod)     // inicio do relatorio pessoa fisica
		Endif	
		FS_IMPFISJUR(cCod)  // meio do relatorio pessoa fisica e juridica
		FS_FIMPFJ(cCod)     // fim do relatorio pessoa fisica e juridica
		oPrinter:EndPage()
		oPrinter:Setup()
		if oPrinter:nModalResult == PD_OK
			oPrinter:Preview()
		Else
			oPrinter:Cancel()
		EndIf
		//
	Endif	 
	
EndIf
Return(.t.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_INICPF    �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � inicio do relatorio pessoa fisica                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_INICPF(cCod)           
Local i := 0 
Local cAliasVMF := "SQLVMF"  
//
CSTARTPATH := GETPVPROFSTRING(GETENVSERVER(),'StartPath','ERROR',GETADV97())
CSTARTPATH += IF(RIGHT(CSTARTPATH,1) <> '\','\','')
CSTARTPATH = '\spool\'
//
oPrinter := FWMSPrinter():New('VA340IM'+__cUserId+"1", IMP_PDF, lAdjustToLegacy,CSTARTPATH , lDisableSetup)
oPrinter:SetPortrait()                                                                                                  
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(0,0,0,0)
oPrinter:cPathPDF := CSTARTPATH
    
dbSelectArea("VME")
dbSetOrder(1)
dbSeek(xFilial("VME")+cCod)
dbSelectArea("VMX")
dbSetOrder(1)
dbSeek(xFilial("VMX")+cCod)
dbSelectArea("VAM")
dbSetOrder(2)
dbSeek(xFilial("VAM")+Alltrim(SA1->A1_MUN))
dbSelectArea("VMF")
dbSetOrder(1)
dbSeek(xFilial("VMF")+cCod)

if VME->VME_ESTCIV == "0"
	cEstCiv := "Solteiro"
Elseif VME->VME_ESTCIV == "1"
	cEstCiv := "Casado"
Elseif VME->VME_ESTCIV == "2"
	cEstCiv := "Separado Judicialmente"
Elseif VME->VME_ESTCIV == "3"
	cEstCiv := "Divorciado"
Elseif VME->VME_ESTCIV == "4"
	cEstCiv := "Viuvo"
Else
	cEstCiv := ""
Endif

if VME->VME_REGIME == "0"
	cRegime := "Nenhum"
Elseif VME->VME_REGIME == "1"
	cRegime := "Comunhao Universao de Bens"
Elseif VME->VME_REGIME == "2"
	cRegime := "Comunhao Parcial de Bens"
Elseif VME->VME_REGIME == "3"
	cRegime := "Separacao Total de Bens"
Elseif VME->VME_REGIME == "4"
	cRegime := "Uniao estavel"
Else
	cRegime := ""
Endif                           

if VME->VME_MORADA == "0"
	cMorada := "Alugada"
Elseif VME->VME_MORADA == "1"
	cMorada := "Propria"
Else
	cMorada := "Outras"
Endif

If SA1->(FieldPos("A1_XTIPO")) # 0
	cTipo := SA1->A1_XTIPO
Else
	cTipo := SA1->A1_TIPO
Endif	
if cTipo <> "L" // Campo provisorio, o correto � A1_TIPO , porem esta com problema no fiscal , ao ser corrigido o problema vai ser alterado novamente.
	aPPA := {;
	{1,0,0,8.2,1,'C','@!',"BASE DE DADOS DE PESSOA F�SICA - N�O PRODUTOR RURAL"}}
Else
	aPPA := {;
	{1,0,0,8.2,1,'C','@!',"BASE DE DADOS DE PESSOA F�SICA - PRODUTOR RURAL"}}
Endif	

// Dependentes
cQuery := "SELECT VMD_CODSEQ, VMD_NOME, VMD_SEXO, VMD_DTNASC, VMD_RELACA "
cQuery += "FROM "
cQuery += RetSqlName( "VMD" ) + " VMD " 
cQuery += "WHERE " 
cQuery += "VMD.VMD_FILIAL='"+ xFilial("VMD")+ "' AND VMD.VMD_CODCLI = '"+cCod+"' AND "
cQuery += "VMD.D_E_L_E_T_=' '"                                             
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMD, .T., .T. )

Do While !( cAliasVMD )->( Eof() )
   
   Aadd(aDepen, { ( cAliasVMD )->VMD_CODSEQ, ( cAliasVMD )->VMD_NOME, ( cAliasVMD )->VMD_SEXO , x3cBoxDesc("VMD_SEXO",( cAliasVMD )->VMD_SEXO), ( cAliasVMD )->VMD_DTNASC, ( cAliasVMD )->VMD_RELACA, x3cBoxDesc("VMD_RELACA",( cAliasVMD )->VMD_RELACA) } )
   ( cAliasVMD )->(dbSkip())
   
Enddo
( cAliasVMD )->( dbCloseArea() )
//

oPrinter:StartPage()
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
aPPA := {;
{2,1,0,2,1,'C','@!',"Identifica��o"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
aPPA := {;
{3,2,0,5,1,'C','@!',"Nome (Completo): "+SA1->A1_NOME},;
{3,2,5,3.2,1,'C','@!',"CPF: "+SA1->A1_CGC},;
{4,3,0,4,1,'C','@!',"Nome do pai: "+VME->VME_NOMPAI},{4,3,4,4.2,1,'C','@!',"Nome da m�e: "+VME->VME_NOMMAE}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
aPPA := {;
	{3,4,0,2,2,'C','@!',"Doc. de Identidade RG N�:"+CHR(13) + CHR(10)+SA1->A1_PFISICA},;
	{4,4,2,1,2,'C','@!',"Dt.emiss�o:"+CHR(13) + CHR(10)+transform(IIf(SA1->(FieldPos("A1_MDTEXRG"))>0,SA1->A1_MDTEXRG,CtoD("")),"@D")},;
	{4,4,3,1,2,'C','@!',"�rg�o Exp:"+CHR(13) + CHR(10)+IIf(SA1->(FieldPos("A1_MORGEXP"))>0,SA1->A1_MORGEXP,"")}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
aPPA := {;
{3,4,4,1,2,'C','@!',"UF: "+VME->VME_UF},{3,4,5,3.2,2,'C','@!',"Natural de (Munic�pio/UF): "+VME->VME_NATURA},;
{3,6,0,2,2,'C','@!',"Nacionalidade: "+VME->VME_NACION},{3,6,2,2,2,'C','@!',"Data Nascimento: "+transform(SA1->A1_DTNASC,"@D")},{3,6,4,2,2,'C','@!',"N�.Dependentes: "+AllTrim(Str(Len(aDepen)))},{3,6,6,2.2,2,'C','@!',"Estado Civil: "+cEstCiv},;
{3,8,0,4,1,'C','@!',"Regime de Uni�o: "+cRegime},{3,8,4,4.2,1,'C','@!',"Inscri��o Rural: "+SA1->A1_INSCRUR},{3,9,0,4,1,'C','@!',"Atividade Principal: "+VMX->VMX_DESCRI },{3,9,4,4.2,1,'C','@!',"Data de in�cio na atividade agropecu�ria: "+transform(VMX->VMX_DATINI,"@D")},;
{3,10,0,4,1,'C','@!',"Moradia: "+cMorada},{3,10,4,4.2,1,'C','@!',"Tempo de resid�ncia na regi�o(meses ou anos): "+transform(VME->VME_TMPMOR,"99")}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
aPPA := {;
  {3,11,0,2,2,'C','@!',"Tipo (Rua, Av., Fazenda, Rodovia, etc.): "},;
  {3,11,2,3.5,2,'C','@!',"Logradouro: "+SA1->A1_END},;
  {3,11,5.5,1.5,2,'C','@!',"Complemento: "+SA1->A1_COMPLEM},;
  {3,11,7.0,1.2,2,'C','@!',"Bairro: "+SA1->A1_BAIRRO}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
aPPA := {;
	{3,13,0,3,1,'C','@!',"Munic�pio/UF: "+Alltrim(VAM->VAM_DESCID)+"/"+VAM->VAM_ESTADO},;
	{3,13,3,1,1,'C','@!',"CEP: "+SA1->A1_CEP},;
	{3,13,4,2,1,'C','@!',"Fone: "+VAM->VAM_DDD+" "+SA1->A1_TEL},;
	{3,13,6,2.2,1,'C','@!',"Celular: "+IIf(SA1->(FieldPos("A1_MCELULA"))>0,SA1->A1_MCELULA,"")},;     
	{3,14,0,8.2,1,'C','@!',"Inscri��o Estadual: "+SA1->A1_INSCR}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

aPPA := {;
{3,15,0,8.2,4,'C','@!',"Endere�o de Correspond�ncia:"+CHR(13) + CHR(10)+"MARCAR COM 'X' DENTRO DO QUADRO SE DESEJA RECEBER AS CORRESPOND�NCIAS NO ENDERE�O DO CONCESSION�RIO J. DEERE"+CHR(13) + CHR(10)+"OBS: Caso o cliente receba a correspond�ncia em Ag. do Correio, informar o CEP, endere�o da ag�ncia, e a CAIXA POSTAL do cliente."}}    
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
           
aPPA := {;
{3,19,0,3,2,'C','@!',"Tipo (Rua, Fazenda, Av., Ag�ncia do Correio, etc.): "},{3,19,3,3,2,'C','@!',"Logradouro:"+SA1->A1_END},{3,19,6,2.2,2,'C','@!',"N�:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
aPPA := {;
{3,21,0,2,1,'C','@!',"Complemento: "},{3,21,2,2,1,'C','@!',"Bairro: "+SA1->A1_BAIRRO},{3,21,4,2,1,'C','@!',"CEP: "+SA1->A1_CEP},{3,21,6,2.2,1,'C','@!',"Caixa Postal: "+SA1->A1_CXPOSTA},;
{3,22,0,3,1,'C','@!',"Munic�pio/UF: "+VAM->VAM_DESCID+VAM->VAM_ESTADO},{3,22,3,2,1,'C','@!',"Fone: "+VAM->VAM_DDD+SA1->A1_TEL},{3,22,5,3.2,1,'C','@!',"E-mail: "+SA1->A1_EMAIL},;
{3,23,0,8.2,1,'C','@!',"Inscri��o Estadual: "+SA1->A1_INSCR}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

cQuery := "SELECT VMF.VMF_EMPREG,VMF.VMF_CARGO,VMF.VMF_ENDEMP,VMF.VMF_NUMERO,VMF.VMF_COMPLE,VMF.VMF_UF,VMF.VMF_BAIRRO,VMF.VMF_CIDADE,VMF.VMF_CEP,VMF.VMF_CXPOST,VMF.VMF_TELEFO,VMF.VMF_RAMAL,VMF.VMF_DATADM,VMF.VMF_REMUNE "
cQuery += "FROM "
cQuery += RetSqlName( "VMF" ) + " VMF " 
cQuery += "WHERE " 
cQuery += "VMF.VMF_FILIAL='"+ xFilial("VMF")+ "' AND VMF.VMF_CODCLI = '"+cCod+"' AND "
cQuery += "VMF.D_E_L_E_T_=' '"                                             
dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMF, .T., .T. )

if !( cAliasVMF )->( Eof() )
	aPPA := {;
	{3,24,0,8.2,1,'C','@!',"DADOS PROFISSIONAIS:"}}  
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
Endif	
y:= 25
Do While !( cAliasVMF )->( Eof() )

	if y > 35
		FS_RUBRICA(3,1)
	Endif
	aPPA := {;
	{3,y,0,5,1,'C','@!',"Empregador/Profiss�o Liberal: "+( cAliasVMF )->VMF_EMPREG},{3,y,5,3.2,1,'C','@!',"Cargo: "+( cAliasVMF )->VMF_CARGO},;
	{3,y+1,0,3,1,'C','@!',"Endere�o Comercial (Rua, Av., etc.): "},{3,y+1,3,2,1,'C','@!',"Logradouro: "+( cAliasVMF )->VMF_ENDEMP},{3,y+1,5,1,1,'C','@!',"N� "+transform(( cAliasVMF )->VMF_NUMERO,"@E 9999")},{3,y+1,6,2.2,1,'C','@!',"Complemento: "+( cAliasVMF )->VMF_COMPLE},;
	{3,y+2,0,2,1,'C','@!',"Bairro: "+( cAliasVMF )->VMF_BAIRRO},{3,y+2,2,2,1,'C','@!',"Munic�pio/UF: "+( cAliasVMF )->VMF_CIDADE+( cAliasVMF )->VMF_UF},{3,y+2,4,2,1,'C','@!',"CEP: "+( cAliasVMF )->VMF_CEP},{3,y+2,6,2.2,1,'C','@!',"Caixa Postal: "+( cAliasVMF )->VMF_CXPOST}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	aPPA := {;
	{3,y+3,0,2,2,'C','@!',"Fone: "+( cAliasVMF )->VMF_TELEFO},{3,y+3,2,2,2,'C','@!',"Ramal: "+transform(( cAliasVMF )->VMF_RAMAL,"@E 99999")},{3,y+3,4,1,2,'C','@!',"Data Admiss�o: "+transform(stod(( cAliasVMF )->VMF_DATADM),"@D")},{3,y+3,5,3.2,2,'C','@!',"Remunera��o Mensal (R$): "+transform(( cAliasVMF )->VMF_REMUNE,"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	( cAliasVMF )->(dbSkip()) 
	y+=5
	
Enddo
( cAliasVMF )->( dbCloseArea() )

/////////////
y:= y+1

if y > 35          
	FS_RUBRICA(3,1)
Endif	

aPPA := {;
{3,y,0,8.2,1,'C','@!',"Outras Rendas Recebidas (Especificar)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
y:= y+1
if y > 35          
	FS_RUBRICA(3,1)
Endif	
aPPA := {;
{3,y,0,3,2,'C','@!',"Nome da Fonte Pagadora."},;
{3,y,3,2,2,'C','@!',"CNPJ/CPF"},;
{3,y,5,3.2,2,'C','@!',"Especificar Valor Recebido no ano (R$, sacas, outros)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )

// Outras rendas
cQuery := "SELECT VMS.VMS_NOME,VMS.VMS_CGC,VMS.VMS_RECANO "
cQuery += "FROM "
cQuery += RetSqlName( "VMS" ) + " VMS " 
cQuery += "WHERE " 
cQuery += "VMS.VMS_FILIAL='"+ xFilial("VMS")+ "' AND VMS.VMS_CODCLI = '"+cCod+"' AND "
cQuery += "VMS.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMS, .T., .T. )

Do While !( cAliasVMS )->( Eof() )
   
   Aadd(aOutRen,{( cAliasVMS )->VMS_NOME,( cAliasVMS )->VMS_CGC,( cAliasVMS )->VMS_RECANO})

   dbSelectArea(cAliasVMS)
   ( cAliasVMS )->(dbSkip())
   
Enddo
( cAliasVMS )->( dbCloseArea() )
y += 2   
aPPA := {}
For i := 1 to Len(aOutRen)

	if y > 35
		FS_RUBRICA(3,1)
	Endif	
	aPPA := {;
	{3,y,0,3,1,'C','@!',Alltrim(str(i))+"- "+aOutRen[i,1]},{3,y,3,2,1,'C','@!',aOutRen[i,2]},{3,y,5,3.2,1,'C','@!',transform(aOutRen[i,3],"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next   

dbSelectArea("VMG")
dbSetOrder(1)
dbSeek(xFilial("VMG")+cCod)

if VMG->VMG_RENDA == "0"
	cRenda := "0 a 5.000"
Elseif VMG->VMG_RENDA == "1"
	cRenda := "5.001 a 10.000"
Elseif VMG->VMG_RENDA == "2"
	cRenda := "10.001 a 20.000"
Elseif VMG->VMG_RENDA == "3"
	cRenda := "20.001 a 30.000"
Elseif VMG->VMG_RENDA == "4"
	cRenda := "30.001 a 50.000"
Elseif VMG->VMG_RENDA == "5"
	cRenda := "50.001 a 200.000"
Elseif VMG->VMG_RENDA == "6"
	cRenda := "acima de 200.001" 
Else
	cRenda := ""
Endif

if VMG->VMG_ESTCIV == "0"
	cEstCiv := "Solteiro"
Elseif VMG->VMG_ESTCIV == "1"
	cEstCiv := "Casado"
Elseif VMG->VMG_ESTCIV == "2"
	cEstCiv := "Separado Judicialmente"
Elseif VMG->VMG_ESTCIV == "3"
	cEstCiv := "Divorciado"
Elseif VMG->VMG_ESTCIV == "4"
	cEstCiv := "Viuvo"
Else
	cEstCiv := ""
Endif
i:=0
if y > 35          
	FS_RUBRICA(3,1)
Endif	
aPPA := {;
{3,y,0,8.2,1,'C','@!',"C�NJUGE OU COMPANHEIRO(A):"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y > 35          
	FS_RUBRICA(3,1)
Endif	
y+=1
aPPA := {;
{3,y,0,5,2,'C','@!',"Nome (Completo - Conforme Certid�o de Casamento): "+CHR(13)+CHR(10)+VMG->VMG_NOME},;
{3,y,5,3.2,2,'C','@!',"CPF: "+VMG->VMG_CPF}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y > 35          
	FS_RUBRICA(3,1)
Endif	
y+=1
aPPA := {;
{3,y,0,4,1,'C','@!',"Nome do Pai: "+VMG->VMG_NOMPAI},;
{3,y,4,4.2,1,'C','@!',"Nome da M�e: "+VMG->VMG_NOMMAE}}
//{3,y+1,0,4,1,'C','@!',"Nome (Completo - Conforme Certid�o de Casamento): "+VMG->VMG_NOME},{3,y+1,4,4.2,1,'C','@!',"CPF: "+VMG->VMG_CPF},;
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
if y > 35          
	FS_RUBRICA(3,1)
Endif	
y+=1
aPPA := {;
{3,y,0,2,2,'C','@!',"Documento de Identidade  RG N�: "+VMG->VMG_RG},;
{3,y,2,1,2,'C','@!',"Dt.emiss�o: "+transform(VMG->VMG_EMISSA,"@D")},;
{3,y,3,1,2,'C','@!',"�rg�o Exp: "+VMG->VMG_ORGEXP},;
{3,y,4,1,2,'C','@!',"UF: "+VMG->VMG_UF},;
{3,y,5,3.2,2,'C','@!',"Natural de (Munic�pio/UF): "+VMG->VMG_NATURA}}

nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
   
if y > 35          
	FS_RUBRICA(3,1)
Endif	
y+=2
aPPA := {;
	{3,y,0,2,2,'C','@!',"Nacionalidade: "+CHR(13) + CHR(10)+VMG->VMG_NACION},;
	{3,y,2,1.5,2,'C','@!',"Data Nascimento: "+CHR(13) + CHR(10)+transform(VMG->VMG_DTNASC,"@D")},;
	{3,y,3.5,2,2,'C','@!',"Estado Civil: "+CHR(13) + CHR(10)+cEstCiv},;
	{3,y,5.5,2.7,2,'C','@!',"Regime Uni�o: "+CHR(13) + CHR(10)+cRegime}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
y+=2
aPPA := {;
	{3,y,0,2,2,'C','@!',"Atividade Principal: "+Posicione("SX5",1, xFilial("SX5")+"T3"+VMG->VMG_ATIVID,"SX5->X5_DESCRI")},;
	{3,y,2,2,2,'C','@!',"Empregador: "+VMG->VMG_EMPREG},;
	{3,y,4,3,2,'C','@!',"Remunera��o Mensal(R$): "+cRenda},;
	{3,y,7,1.2,2,'C','@!',"Dt Admiss�o: "+CHR(13)+CHR(10)+transform(VMG->VMG_DATADM,"@D")}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
y+=2
// Dependentes 
aPPA := {;
{3,y,0,8.2,1,'C','@!',"DEPENDENTES: "}}
y+=1
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
aPPA := {;
	{3,y,0,5,1,'C','@!',"Nome"},;
	{3,y,5,1,1,'C','@!',"Rela��o"},;
	{3,y,6,1,1,'C','@!',"Sexo"},;
	{3,y,7,1.2,1,'C','@!',"Dt. Nasc."}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
aPPA := {}
For i := 1 to Len(aDepen)
	if y > 35
		FS_RUBRICA(3,1)
	Endif	
	aPPA := {;
		{3,y,0,5,1,'C','@!',aDepen[i,2]},;
		{3,y,5,1,1,'C','@!',aDepen[i,7]},;
		{3,y,6,1,1,'C','@!',aDepen[i,4]},;
		{3,y,7,1.2,1,'C','@!',transform(stod(aDepen[i,5]),"@D") }}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next
//

aPPA := {;
{3,y,0,8.2,1,'C','@!',"REFER�NCIAS BANC�RIAS: "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )

Y++
aPPA := {;
	{3,y,0,2,1,'C','@!',"Banco"},;
	{3,y,2,1,1,'C','@!',"Cliente desde"},;
	{3,y,3,1,1,'C','@!',"Ag�ncia"},;
	{3,y,4,2,1,'C','@!',"Munic�pio/UF"},;
	{3,y,6,2.2,1,'C','@!',"Fone"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )


// Referencias Bancarias
cQuery := "SELECT VMI.VMI_CODBCO,VMI.VMI_NOME,VMI.VMI_DATCAD,VMI.VMI_CODAGE,VMI.VMI_NOMAGE,VMI.VMI_CIDADE,VMI.VMI_UF,VMI.VMI_TELEFO "
cQuery += "FROM "
cQuery += RetSqlName( "VMI" ) + " VMI " 
cQuery += "WHERE " 
cQuery += "VMI.VMI_FILIAL='"+ xFilial("VMI")+ "' AND VMI.VMI_CODCLI = '"+cCod+"' AND "
cQuery += "VMI.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMI, .T., .T. )

Do While !( cAliasVMI )->( Eof() )
   
   Aadd(aRefBan,{( cAliasVMI )->VMI_CODBCO,( cAliasVMI )->VMI_NOME,( cAliasVMI )->VMI_DATCAD,( cAliasVMI )->VMI_CODAGE,( cAliasVMI )->VMI_NOMAGE,( cAliasVMI )->VMI_CIDADE,( cAliasVMI )->VMI_UF,( cAliasVMI )->VMI_TELEFO})

   dbSelectArea(cAliasVMI)
   ( cAliasVMI )->(dbSkip())
   
Enddo
( cAliasVMI )->( dbCloseArea() )
Y++
aPPA := {}
For i := 1 to Len(aRefBan)
	if y > 35
		FS_RUBRICA(3,1)
	Endif	
	aPPA := {;
	{3,y,0,2,1,'C','@!',aRefBan[i,1]+" "+aRefBan[i,2]},{3,y,2,1,1,'C','@!',transform(stod(aRefBan[i,3]),"@D")},{3,y,3,1,1,'C','@!',aRefBan[i,4]+" "+aRefBan[i,5]},{3,y,4,2,1,'C','@!',Alltrim(aRefBan[i,6])+" "+aRefBan[i,7]},{3,y,6,2.2,1,'C','@!',aRefBan[i,8]}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next             

////////////////////////////////////     
aPPA := {;
{3,y,0,8.2,1,'C','@!',"PRINCIPAIS FORNECEDORES:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+1 >= 35
	FS_RUBRICA(3,1)
Endif 
aPPA := {;
{3,y+1,0,3,1,'C','@!',"Nome da Empresa:"},{3,y+1,3,3,1,'C','@!',"Munic�pio / UF:"},{3,y+1,6,2.2,1,'C','@!',"Fone: DDD: N�: "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
y := y + 2
if y >= 35
	FS_RUBRICA(3,1)
Endif      

// PRINCIPAIS FORNECEDORES:
cQuery := "SELECT VMH.VMH_ESTABE,VMH.VMH_CIDADE,VMH.VMH_TELEFO "
cQuery += "FROM "
cQuery += RetSqlName( "VMH" ) + " VMH " 
cQuery += "WHERE " 
cQuery += "VMH.VMH_FILIAL='"+ xFilial("VMH")+ "' AND VMH.VMH_CODCLI = '"+cCod+"' AND VMH.VMH_REFERE = '1' AND "
cQuery += "VMH.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMH, .T., .T. )
   
Do While !( cAliasVMH )->( Eof() )
   
   Aadd(aFornec,{( cAliasVMH )->VMH_ESTABE,( cAliasVMH )->VMH_CIDADE,( cAliasVMH )->VMH_TELEFO})

   dbSelectArea(cAliasVMH)
   ( cAliasVMH )->(dbSkip())
   
Enddo
( cAliasVMH )->( dbCloseArea() )
For i := 1 to Len(aFornec)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif                                
	aPPA := {;                        
	{3,y,0,3,1,'C','@!',aFornec[i,1]},;
	{3,y,3,3,1,'C','@!',aFornec[i,2]},;
	{3,y,6,2.2,1,'C','@!',aFornec[i,3]}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  
////////////////////////////////////     

aPPA := {;
{3,y,0,8.2,1,'C','@!',"PRINCIPAIS COMPRADORES / CLIENTES: "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
aPPA := {;
{3,y+1,0,2,1,'C','@!',"Nome da Empresa"},{3,y+1,2,1,1,'C','@!',"Munic�pio/UF"},{3,y+1,3,1,1,'C','@!',"Fone"},{3,y+1,4,2,1,'C','@!',"Produtos"},{3,y+1,6,2.2,1,'C','@!',"% Sobre Receita"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

// Principais Compradores / Clientes:   
cQuery := "SELECT VMH.VMH_ESTABE,VMH.VMH_CIDADE,VMH.VMH_TELEFO,VMH.VMH_PRODUT,VMH.VMH_PERREC "
cQuery += "FROM "
cQuery += RetSqlName( "VMH" ) + " VMH " 
cQuery += "WHERE " 
cQuery += "VMH.VMH_FILIAL='"+ xFilial("VMH")+ "' AND VMH.VMH_CODCLI = '"+cCod+"' AND VMH.VMH_REFERE = '0' AND "
cQuery += "VMH.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMH, .T., .T. )

Do While !( cAliasVMH )->( Eof() )
   
   Aadd(aCompr,{( cAliasVMH )->VMH_ESTABE,( cAliasVMH )->VMH_CIDADE,( cAliasVMH )->VMH_TELEFO,( cAliasVMH )->VMH_PRODUT,( cAliasVMH )->VMH_PERREC})

   dbSelectArea(cAliasVMH)
   ( cAliasVMH )->(dbSkip())
   
Enddo
( cAliasVMH )->( dbCloseArea() )
y := y+2
aPPA := {}
For i := 1 to Len(aCompr)

	if y > 35
		FS_RUBRICA(3,1)
	Endif
	aPPA := {;
	{3,y,0,2,1,'C','@!',aCompr[i,1]},{3,y,2,1,1,'C','@!',aCompr[i,2]},{3,y,3,1,1,'C','@!',aCompr[i,3]},{3,y,4,2,1,'C','@!',aCompr[i,4]},{3,y,6,2.2,1,'C','@!',transform(aCompr[i,5],"@E 999.99")+"%"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  


Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_INICPJ    �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � inicio do relatorio pessoa juridica                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_INICPJ(cCod)

Local cAliasSA1 := "SQLSA1"
Local cAliasVMI := "SQLVMI"
Local cAliasVMH := "SQLVMH"
Local cAliasVMZ := "SQLVMZ"
Local cAliasVMP := "SQLVMP"
Local i := 0  
Local aSocio    := {} 
Local aColig    := {} 
Local aRefBan   := {} 
Local aFornec   := {} 
Local aProdSrv  := {} 
Local aComprad  := {} 
Local cTipAti   := Space(TamSx3("VMX_DESCRI")[1])

//
CSTARTPATH := GETPVPROFSTRING(GETENVSERVER(),'StartPath','ERROR',GETADV97())
CSTARTPATH += IF(RIGHT(CSTARTPATH,1) <> '\','\','')
CSTARTPATH = '\spool\'
//
oPrinter := FWMSPrinter():New('VA340IM', IMP_PDF, lAdjustToLegacy,CSTARTPATH , lDisableSetup)
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(0,0,0,0)
oPrinter:cPathPDF := CSTARTPATH
    
dbSelectArea("VME")
dbSetOrder(1)
dbSeek(xFilial("VME")+cCod)
dbSelectArea("VMX")
dbSetOrder(1)
dbSeek(xFilial("VMX")+cCod)
While !Eof() .and. xFilial("VMX") == VMX->VMX_FILIAL .and. cCod == VMX->VMX_CODCLI

   if VMX_TIPATI == "0"
	   cTipAti := VMX->VMX_DESCRI
	   Exit
   Endif	   
      
   dbSelectArea("VMX")
   dbSkip()
Enddo  
dbSelectArea("VAM")
dbSetOrder(2)
dbSeek(xFilial("VAM")+Alltrim(SA1->A1_MUN))
dbSelectArea("VMF")
dbSetOrder(1)
dbSeek(xFilial("VMF")+cCod)

if VME->VME_ESTCIV == "0"
	cEstCiv := "Solteiro"
Elseif VME->VME_ESTCIV == "1"
	cEstCiv := "Casado"
Elseif VME->VME_ESTCIV == "2"
	cEstCiv := "Separado Judicialmente"
Elseif VME->VME_ESTCIV == "3"
	cEstCiv := "Divorciado"
Elseif VME->VME_ESTCIV == "4"
	cEstCiv := "Viuvo"
Else
	cEstCiv := ""
Endif

if VME->VME_REGIME == "0"
	cRegime := "Nenhum"
Elseif VME->VME_REGIME == "1"
	cRegime := "Comunhao Universao de Bens"
Elseif VME->VME_REGIME == "2"
	cRegime := "Comunhao Parcial de Bens"
Elseif VME->VME_REGIME == "3"
	cRegime := "Separacao Total de Bens"
Elseif VME->VME_REGIME == "4"
	cRegime := "Uniao estavel"
Else
	cRegime := ""
Endif                           

if VME->VME_MORADA == "0"
	cMorada := "Alugada"
Elseif VME->VME_MORADA == "1"
	cMorada := "Propria"
Else
	cMorada := "Outras"
Endif
    

aPPA := {;
{1,0,0,8.2,1,'C','@!',"BASE DE DADOS DE PESSOA JUR�DICA"}}
oPrinter:StartPage()
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
aPPA := {;
{2,1,0,2,1,'C','@!',"Identifica��o"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
aPPA := {;
{3,2,0,8.2,1,'C','@!',"Nome Fantasia: "+SA1->A1_NREDUZ},;
{3,3,0,2,2,'C','@!',"CNPJ: "+SA1->A1_CGC},{3,3,2,2,2,'C','@!',"Data Funda��o: "+transform(SA1->A1_DTNASC,"@D")},{3,3,4,3,2,'C','@!',"N� de Registro na Junta Comercial: "+transform(IIf(SA1->(FieldPos("A1_MNRJCOM"))>0,SA1->A1_MNRJCOM,0),"99999")},{3,3,7,1.2,2,'C','@!',"Data de registro: "+transform(IIf(SA1->(FieldPos("A1_MDRJCOM"))>0,SA1->A1_MDRJCOM,CtoD("")),"@D")},;
{3,5,0,8.2,1,'C','@!',"Descri��o da Atividade Econ�mica Principal: "+cTipAti},;
{3,6,0,8.2,1,'C','@!',"Endere�o Sede:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

aPPA := {;
{3,7,0,4,2,'C','@!',"Tipo: (Rua, Av., Fazenda, Rodovia,"},{3,7,4,2,2,'C','@!',"Logradouro: "+SA1->A1_END},{3,7,6,1,2,'C','@!',"Fone (DDD / N�): "+VAM->VAM_DDD+" - "+SA1->A1_TEL},{3,7,7,1.2,2,'C','@!',"FAX (DDD / N�): "+VAM->VAM_DDD+" "+SA1->A1_FAX}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )

aPPA := {;
{3,9,0,8.2,1,'C','@!',"Endere�o de Correspond�ncia:"},;
{3,10,0,8.2,1,'C','@!',"MARCAR COM 'X' DENTRO DO QUADRO SE DESEJA RECEBER AS CORRESPOND�NCIAS NO ENDERE�O DO CONCESSION�RIO J. DEERE"},;             
{3,11,0,8.2,1,'C','@!',"OBS: Caso o cliente receba a correspond�ncia em Ag. do Correio, informar o CEP, endere�o da ag�ncia, e a CAIXA POSTAL do "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
aPPA := {;
{3,12,0,4,2,'C','@!',"Tipo (Rua, Fazenda, Av., Ag�ncia do Correio, etc.):"},{3,12,4,3,2,'C','@!',"Logradouro: "+SA1->A1_END},{3,12,7,1.2,2,'C','@!',"N�:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )

aPPA := {;
{3,14,0,2,1,'C','@!',"Complemento:"},{3,14,2,2,1,'C','@!',"Bairro: "+SA1->A1_BAIRRO},{3,14,4,2,1,'C','@!',"CEP: "+SA1->A1_CEP},{3,14,6,2.2,1,'C','@!',"Caixa Postal: "+SA1->A1_CXPOSTA},;
{3,15,0,4,1,'C','@!',"Munic�pio/UF: "+VAM->VAM_DESCID+" "+VAM->VAM_ESTADO},{3,15,4,2,1,'C','@!',"Fone: "+VAM->VAM_DDD+" "+SA1->A1_TEL},{3,15,6,2.2,1,'C','@!',"E-mail: "+SA1->A1_EMAIL},;
{3,16,0,8.2,1,'C','@!',"Site: "+IIf(SA1->(FieldPos("A1_MSITE"))>0,SA1->A1_MSITE,"")},;
{3,17,0,8.2,1,'C','@!',"Sucessora de: "+IIf(SA1->(FieldPos("A1_MSUCDE"))>0,SA1->A1_MSUCDE,"")}}

nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

aPPA := {;
{3,18,0,2,1,'C','@!',"Filiais:"},{3,18,2,2,1,'C','@!',"CNPJ"},{3,18,4,4.2,1,'C','@!',"Localiza��o: (Munic�pio / UF)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

// Filiais: 
cQuery := "SELECT SA1.A1_LOJA,SA1.A1_CGC,VAM.VAM_DESCID,VAM.VAM_ESTADO "
cQuery += "FROM "
cQuery += RetSqlName( "SA1" ) + " SA1 " 
cQuery += "LEFT JOIN "+RetSqlName("VAM")+" VAM ON (VAM.VAM_FILIAL='"+xFilial("VAM")+"' AND SA1.A1_MUN = VAM.VAM_DESCID AND VAM.D_E_L_E_T_=' ') "
cQuery += "WHERE " 
cQuery += "SA1.A1_FILIAL='"+ xFilial("SA1")+ "' AND SA1.A1_COD = '"+cCod+"' AND "+IIf(SA1->(FieldPos("A1_MTIPCLI"))>0,"SA1.A1_MTIPCLI = '2' AND ","")
cQuery += "SA1.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSA1, .T., .T. )
        
Do While !( cAliasSA1 )->( Eof() )
   
   Aadd(aFil,{( cAliasSA1 )->A1_LOJA,( cAliasSA1 )->A1_CGC,( cAliasSA1 )->VAM_DESCID,( cAliasSA1 )->VAM_ESTADO})

   dbSelectArea(cAliasSA1)
   ( cAliasSA1 )->(dbSkip())
   
Enddo
( cAliasSA1 )->( dbCloseArea() )
y := y+19
aPPA := {}
cEspec  := ""
For i := 1 to Len(aFil)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif

	aPPA := {;                        
	{3,y,0,2,1,'C','@!',aFil[i,1]},{3,y,2,2,1,'C','@!',aFil[i,2]},{3,y,4,4.2,1,'C','@!',aFil[i,3]+" - "+aFil[i,4]}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  
aPPA := {;
{3,y,0,2,1,'C','@!',"GRUPO EMPRESARIAL: "+IIf(SA1->(FieldPos("A1_MGRUEMP"))>0,SA1->A1_MGRUEMP,"")}}
if y >= 35
	FS_RUBRICA(3,1)
Endif 

nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

// Socios e Administradores 
cQuery := "SELECT VMZ.VMZ_CAPITA,VMZ.VMZ_NOME,VMZ.VMZ_PPACAP,VMZ.VMZ_CARGO,VMZ.VMZ_CGC,VMZ.VMZ_FINMAN "
cQuery += "FROM "
cQuery += RetSqlName( "VMZ" ) + " VMZ " 
cQuery += "WHERE " 
cQuery += "VMZ.VMZ_FILIAL='"+ xFilial("VMZ")+ "' AND VMZ.VMZ_CODCLI = '"+cCod+"' AND "
cQuery += "VMZ.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMZ, .T., .T. )
   
nCapita := 0        
Do While !( cAliasVMZ )->( Eof() )
   
   Aadd(aSocio,{( cAliasVMZ )->VMZ_NOME,( cAliasVMZ )->VMZ_PPACAP,( cAliasVMZ )->VMZ_CARGO,( cAliasVMZ )->VMZ_CGC,( cAliasVMZ )->VMZ_FINMAN})
   nCapita += ( cAliasVMZ )->VMZ_CAPITA

   dbSelectArea(cAliasVMZ)
   ( cAliasVMZ )->(dbSkip())
   
Enddo
( cAliasVMZ )->( dbCloseArea() )

aPPA := {;
{3,y+1,0,4,1,'C','@!',"S�CIOS E ADMINISTRADORES"},{3,y+1,4,4.2,1,'C','@!',"Capital (Valor Atual) R$: "+transform(nCapita,"@E 999,999,999.99")}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 >= 35
	FS_RUBRICA(4,1)
Endif 
aPPA := {;
{3,y+2,0,2,3,'C','@!',"Nome"},{3,y+2,2,1,3,'C','@!',"Participa��o No Capital (%)"},{3,y+2,3,1,3,'C','@!',"Cargo"},{3,y+2,4,2,3,'C','@!',"CPF:"},{3,y+2,6,2.2,3,'C','@!',"Data Final do mandato dos Administradores (dd/mm/aa)"}}
if y+5 >= 35
	FS_RUBRICA(6,1)
Endif 

nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

y := y+3
aPPA := {}
cEspec  := ""
For i := 1 to Len(aSocio)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif 

	aPPA := {;                        
	{3,y+2,0,2,1,'C','@!',aSocio[i,1]},{3,y+2,2,1,1,'C','@!',transform(aSocio[i,2],"@E 999.99")},{3,y+2,3,1,1,'C','@!',aSocio[i,3]},{3,y+2,4,2,1,'C','@!',aSocio[i,4]},{3,y+2,6,2.2,1,'C','@!',aSocio[i,5]}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  
y := y+2
aPPA := {;
{3,y,0,8.2,1,'C','@!',"COLIGADAS/CONTROLADAS"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+1 >= 35
	FS_RUBRICA(3,1)
Endif 
aPPA := {;
{3,y+1,0,2,1,'C','@!',"Raz�o Social"},{3,y+1,2,2,1,'C','@!',"CNPJ"},{3,y+1,4,2,1,'C','@!',"Patrim�nio L�quido"},{3,y+1,6,2.2,1,'C','@!',"Participa��o (%)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
if y+1 >= 35
	FS_RUBRICA(3,1)
Endif      

// COLIGADAS/CONTROLADAS
cQuery := "SELECT VMR.VMR_NOME,VMR.VMR_CNPJ,VMR.VMR_PATLIQ,VMR.VMR_PPACAP "
cQuery += "FROM "
cQuery += RetSqlName( "VMR" ) + " VMR " 
cQuery += "WHERE " 
cQuery += "VMR.VMR_FILIAL='"+ xFilial("VMR")+ "' AND VMR.VMR_CODCLI = '"+cCod+"' AND "
cQuery += "VMR.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMR, .T., .T. )
   
Do While !( cAliasVMR )->( Eof() )
   
   Aadd(aColig,{( cAliasVMR )->VMR_NOME,( cAliasVMR )->VMR_CNPJ,( cAliasVMR )->VMR_PATLIQ,( cAliasVMR )->VMR_PPACAP})

   dbSelectArea(cAliasVMR)
   ( cAliasVMR )->(dbSkip())
   
Enddo
( cAliasVMR )->( dbCloseArea() )

For i := 1 to Len(aColig)

	if y+2 >= 35
		FS_RUBRICA(5,1)
	Endif 

	aPPA := {;                        
	{3,y+2,0,2,1,'C','@!',aColig[i,1]},{3,y+2,2,2,1,'C','@!',aColig[i,2]},{3,y+2,4,2,1,'C','@!',transform(aColig[i,3],"@E 999,999,999.99")},{3,y+2,6,2.2,1,'C','@!',transform(aColig[i,4],"@E 999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  
aPPA := {;
{3,y+2,0,8.2,1,'C','@!',"REFER�NCIAS BANC�RIAS"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 >= 35
	FS_RUBRICA(5,1)
Endif 
aPPA := {;
{3,y+3,0,2,2,'C','@!',"Banco:"},{3,y+3,2,1,2,'C','@!',"Cliente desde(m�s/ano):"},{3,y+3,3,2,2,'C','@!',"Ag�ncia (Nome / N� ag�ncia):"},{3,y+3,5,2,2,'C','@!',"Munic�pio / UF:"},{3,y+3,7,1.2,2,'C','@!',"Fone: DDD: N�: "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
y += 5
if y >= 35
	FS_RUBRICA(3,1)
Endif      

// REFERENCIAS BANCARIAS
cQuery := "SELECT VMI.VMI_CODBCO,VMI.VMI_NOME,VMI.VMI_DATCAD,VMI.VMI_CODAGE,VMI.VMI_NOMAGE,VMI.VMI_CIDADE,VMI.VMI_UF,VMI.VMI_TELEFO "
cQuery += "FROM "
cQuery += RetSqlName( "VMI" ) + " VMI " 
cQuery += "WHERE " 
cQuery += "VMI.VMI_FILIAL='"+ xFilial("VMI")+ "' AND VMI.VMI_CODCLI = '"+cCod+"' AND "
cQuery += "VMI.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMI, .T., .T. )
   
Do While !( cAliasVMI )->( Eof() )
   
   Aadd(aRefBan,{( cAliasVMI )->VMI_CODBCO,( cAliasVMI )->VMI_NOME,( cAliasVMI )->VMI_DATCAD,( cAliasVMI )->VMI_CODAGE,( cAliasVMI )->VMI_NOMAGE,( cAliasVMI )->VMI_CIDADE,( cAliasVMI )->VMI_UF,( cAliasVMI )->VMI_TELEFO})

   dbSelectArea(cAliasVMI)
   ( cAliasVMI )->(dbSkip())
   
Enddo
( cAliasVMI )->( dbCloseArea() )
For i := 1 to Len(aRefBan)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif                                
	cMes := Alltrim(strzero(month(stod(aRefBan[i,3])),2))
	cAno := Alltrim(str(year(stod(aRefBan[i,3]))))

	aPPA := {;                        
	{3,y,0,2,1,'C','@!',aRefBan[i,1]+" "+aRefBan[i,2]},{3,y,2,1,1,'C','@!',cMes+"/"+cAno},{3,y,3,2,1,'C','@!',aRefBan[i,4]+"/"+aRefBan[i,5]},{3,y,5,2,1,'C','@!',Alltrim(aRefBan[i,6])+"/"+aRefBan[i,7]},{3,y,7,1.2,1,'C','@!',aRefBan[i,8]}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  

aPPA := {;
{3,y,0,8.2,1,'C','@!',"PRINCIPAIS FORNECEDORES:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+1 >= 35
	FS_RUBRICA(3,1)
Endif 
aPPA := {;
{3,y+1,0,3,1,'C','@!',"Nome da Empresa:"},{3,y+1,3,3,1,'C','@!',"Munic�pio / UF:"},{3,y+1,6,2.2,1,'C','@!',"Fone: DDD: N�: "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
y := y + 2
if y >= 35
	FS_RUBRICA(3,1)
Endif      

// PRINCIPAIS FORNECEDORES:
cQuery := "SELECT VMH.VMH_ESTABE,VMH.VMH_CIDADE,VMH.VMH_TELEFO "
cQuery += "FROM "
cQuery += RetSqlName( "VMH" ) + " VMH " 
cQuery += "WHERE " 
cQuery += "VMH.VMH_FILIAL='"+ xFilial("VMH")+ "' AND VMH.VMH_CODCLI = '"+cCod+"' AND VMH.VMH_REFERE = '1' AND "
cQuery += "VMH.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMH, .T., .T. )
   
Do While !( cAliasVMH )->( Eof() )
   
   Aadd(aFornec,{( cAliasVMH )->VMH_ESTABE,( cAliasVMH )->VMH_CIDADE,( cAliasVMH )->VMH_TELEFO})

   dbSelectArea(cAliasVMH)
   ( cAliasVMH )->(dbSkip())
   
Enddo
( cAliasVMH )->( dbCloseArea() )
For i := 1 to Len(aFornec)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif                                
	aPPA := {;                        
	{3,y,0,3,1,'C','@!',aFornec[i,1]},{3,y,3,3,1,'C','@!',aFornec[i,2]},{3,y,6,2.2,1,'C','@!',aFornec[i,3]}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  

aPPA := {;
{3,y,0,8.2,1,'C','@!',"PRINCIPAIS COMPRADORES / CLIENTES:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+3 >= 35
	FS_RUBRICA(5,1)
Endif 
aPPA := {;
{3,y+1,0,3,2,'C','@!',"Nome da Empresa:"},{3,y+1,3,1.5,2,'C','@!',"Munic�pio / UF:"},{3,y+1,4.5,1,2,'C','@!',"Fone: DDD: N�:"},{3,y+1,5.5,2,2,'C','@!',"Produtos:"},{3,y+1,7.5,0.7,2,'C','@!',"% sobre a Receita: "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
y += 3
if y >= 35
	FS_RUBRICA(3,1)
Endif      

// PRINCIPAIS COMPRADORES / CLIENTES:
cQuery := "SELECT VMH.VMH_ESTABE,VMH.VMH_CIDADE,VMH.VMH_TELEFO,VMH.VMH_PRODUT,VMH.VMH_PERREC "
cQuery += "FROM "
cQuery += RetSqlName( "VMH" ) + " VMH " 
cQuery += "WHERE " 
cQuery += "VMH.VMH_FILIAL='"+ xFilial("VMH")+ "' AND VMH.VMH_CODCLI = '"+cCod+"' AND VMH.VMH_REFERE = '0' AND "
cQuery += "VMH.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMH, .T., .T. )
   
Do While !( cAliasVMH )->( Eof() )
   
   Aadd(aComprad,{( cAliasVMH )->VMH_ESTABE,( cAliasVMH )->VMH_CIDADE,( cAliasVMH )->VMH_TELEFO,( cAliasVMH )->VMH_PRODUT,( cAliasVMH )->VMH_PERREC})

   dbSelectArea(cAliasVMH)
   ( cAliasVMH )->(dbSkip())
   
Enddo
( cAliasVMH )->( dbCloseArea() )
For i := 1 to Len(aComprad)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif                                
	aPPA := {;                        
	{3,y,0,3,1,'C','@!',aComprad[i,1]},{3,y,3,1.5,1,'C','@!',aComprad[i,2]},{3,y,4.5,1,1,'C','@!',aComprad[i,3]},{3,y,5.5,2,1,'C','@!',aComprad[i,4]},{3,y,7.5,0.7,1,'C','@!',transform(aComprad[i,5],"@E 999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  

aPPA := {;
{3,y,0,8.2,1,'C','@!',"PRINCIPAIS PRODUTOS / SERVI�OS:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+3 >= 35
	FS_RUBRICA(5,1)
Endif 
aPPA := {;
{3,y+1,0,5,1,'C','@!',"Produto/Servi�o"},{3,y+1,5,3.2,1,'C','@!',"Percentual Sobre o Faturamento (%)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
y += 1
if y+2 >= 35
	FS_RUBRICA(4,1)
Endif      

// PRINCIPAIS PRODUTOS / SERVI�OS:
cQuery := "SELECT VMP.VMP_DESPRS,VMP.VMP_PERFAT "
cQuery += "FROM "
cQuery += RetSqlName( "VMP" ) + " VMP " 
cQuery += "WHERE " 
//cQuery += "VMP.VMP_FILIAL='"+ xFilial("VMP")+ "' AND VMP.VMP_ANO = '"+cAno+"' AND VMP.VMP_CODCLI = '"+cCod+"' AND "
cQuery += "VMP.VMP_FILIAL='"+ xFilial("VMP")+ "' AND VMP.VMP_CODCLI = '"+cCod+"' AND "
cQuery += "VMP.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMP, .T., .T. )
   
Do While !( cAliasVMP )->( Eof() )
   
   Aadd(aProdSrv,{( cAliasVMP )->VMP_DESPRS,( cAliasVMP )->VMP_PERFAT})

   dbSelectArea(cAliasVMP)
   ( cAliasVMP )->(dbSkip())
   
Enddo
( cAliasVMP )->( dbCloseArea() )

For i := 1 to Len(aProdSrv)

	if y+2 >= 35
		FS_RUBRICA(3,1)
	Endif                                
	aPPA := {;                        
	{3,y+1,0,5,1,'C','@!',aProdSrv[i,1]},{3,y+1,5,3.2,1,'C','@!',transform(aProdSrv[i,2],"@E 999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  
    
y := y + 1

Return(.t.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_FIMPFJ    �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �  finaliza��o do relatorio pessoa fisica e juridica         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function FS_FIMPFJ(cCod)
Local i := 0

aPPA := {;
{3,y,0,8.2,1,'C','@!',"ENDIVIDAMENTO" }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y > 35
	FS_RUBRICA(3,0)
Endif
aPPA := {;
{3,y+1,0,8.2,3,'C','@!',"Nos  quadros  abaixo  informar:  custeio  banc�rio  /  custeio  junto  a  fornecedores  /  adiantamentos  /  aquisi��o de equipamentos / aquisi��o de ve�culos / aquisi��o de im�veis rurais e urbanos / PESA / Securitiza��o / Investimento de Infra estrutura (silos, armaz�ns,  etc)  / Empr�stimos pessoais (cheque especial, cr�dito direto a consumidor,etc) e outros."}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+1 > 35
	FS_RUBRICA(4,0)
Endif
aPPA := {;
{3,y+5,0,8.2,1,'C','@!',"COMPROMISSOS COM BANCOS / FINANCEIRAS / FORNECEDORES / COMPRADORES / COOPERATIVAS:" }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+5 > 35
	FS_RUBRICA(8,0)
Endif
aPPA := {;
{3,y+6,0,2,2,'C','@!',"Nome do Credor"},;
{3,y+6,2,1,2,'C','@!',"Modalidade (Finame, Custeio, Investimento, Insumos)"},;
{3,y+6,3,1,2,'C','@!',"Saldo Devedor Atual (R$)"},;
{3,y+6,4,1,2,'C','@!',"N� de parcelas restantes"},;
{3,y+6,5,1,2,'C','@!',"Valor da parcela (R$, sacas, outras unidades)"},;
{3,y+6,6,1,2,'C','@!',"Vencimento final (m�s/ano)"},;
{3,y+6,7,1.2,2,'C','@!',"Garantia (aval, hipoteca,etc)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+6 > 35
	FS_RUBRICA(9,0)
Endif

// COMPROMISSOS COM BANCOS / FINANCEIRAS / FORNECEDORES / COMPRADORES / COOPERATIVAS: 
cQuery := "SELECT VMN.VMN_NOMCRE,VMN.VMN_MODEND,VMN.VMN_SDODEV,VMN.VMN_PARRES,VMN.VMN_VALPAR,VMN.VMN_VENDIV,VMN.VMN_GARANT "
cQuery += "FROM "
cQuery += RetSqlName( "VMN" ) + " VMN " 
cQuery += "WHERE " 
cQuery += "VMN.VMN_FILIAL='"+ xFilial("VMN")+ "' AND VMN.VMN_CODCLI = '"+cCod+"' AND "
cQuery += "VMN.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMN, .T., .T. )

Do While !( cAliasVMN )->( Eof() )
   
   Aadd(aComprom,{( cAliasVMN )->VMN_NOMCRE,( cAliasVMN )->VMN_MODEND,( cAliasVMN )->VMN_SDODEV,( cAliasVMN )->VMN_PARRES,( cAliasVMN )->VMN_VALPAR,( cAliasVMN )->VMN_VENDIV,( cAliasVMN )->VMN_GARANT})

   dbSelectArea(cAliasVMN)
   ( cAliasVMN )->(dbSkip())
   
Enddo
( cAliasVMN )->( dbCloseArea() )
y := y+8
aPPA := {}
For i := 1 to Len(aComprom)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
    cDia := substr(dtoc(stod(aComprom[i,6])),1,2)
    cMes := substr(dtoc(stod(aComprom[i,6])),4,2)
    cAno := substr(dtoc(stod(aComprom[i,6])),7,4) 
    cDta := cDia+"/"+cMes+"/"+cAno

	aPPA := {;
	{3,y,0,2,1,'C','@!',aComprom[i,1]},{3,y,2,1,1,'C','@!',aComprom[i,2]},{3,y,3,1,1,'C','@!',transform(aComprom[i,3],"@E 999,999,999.99")},{3,y,4,1,1,'C','@!',transform(aComprom[i,4],"@E 99999")},{3,y,5,1,1,'C','@!',transform(aComprom[i,5],"@E 999,999,999.99")},;
	{3,y,6,1,1,'C','@!',cDta},{3,y,7,1.2,1,'C','@!',aComprom[i,7]}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  
aPPA := {;
{3,y+1,0,8.2,1,'C','@!',"OUTRAS INFORMA��ES RELEVANTES:" }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+1 > 35
	FS_RUBRICA(4,0)
Endif
dbSelectArea("VMU")
dbSetOrder(1)
dbSeek(xFilial("VMU")+cCod)

aPPA := {;
{3,y+2,0,8.2,8,'C','@!',CHR(13)+CHR(10)+VMU->VMU_IREOBS }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+2 > 35
	FS_RUBRICA(11,0)
Endif


dbSelectArea("VMU")
dbSetOrder(1)
dbSeek(xFilial("VMU")+cCod)
aSM0 := FWArrFilAtu(cEmpAnt,cFilAnt) // Filial Origem (Filial logada)
nBkpFil := SM0->(Recno())     
dbSelectArea("SM0")
dbSetOrder(1)
DbSeek(aSM0[1]+aSM0[2])
cCidEnt := SM0->M0_CIDENT
SM0->(DBGoto(nBkpFil))

FS_RUBRICA(11,0)

aPPA := {;
{3,y,0,8.2,1,'C','@!',"TERMO DE AUTORIZA��O/DECLARA��O" }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
cTexto := "1�) As declara��es contidas neste instrumento tem por finalidade estabelecer relacionamento"+;
" com o Banco John Deere S.A. e com os demais bancos com os quais esse mant�m conv�nio, visando a concess�o,"+;
" a   exclusivo crit�rio das institui��es financeiras, de financiamento(s) de equipamento(s) agr�colas."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
"2�) Pelo presente, o CLIENTE  declara expressamente que tem conhecimento de que a an�lise para concess�o do cr�dito ora pleiteado"+;
" poder� ser realizada em conjunto pelo Banco John Deere S.A. e  pelas  Institui��es Financeiras com as quais o primeiro mant�m conv�nio"+;
" operacional, e que, por esse motivo, pelo presente instrumento o CLIENTE autoriza expressamente, em car�ter irrevog�vel e irretrat�vel,"+;
"  o Banco John Deere S.A. e as referidas Institui��es Financeiras, a compartilhar, bem como a  consultar e fornecer informa��es cadastrais,"+;
" compreendendo as aqui prestadas e as relativas a  opera��es de cr�dito que forem efetivadas, inclu�do o registro de eventuais inadimplementos,"+;
" junto a bancos de dados p�blicos e privados, ao SCR - Sistema de Informa��es de Cr�dito do Banco Central do Brasil, � SERASA, a entidades"+;
" de prote��o ao cr�dito e as outras fontes do mercado, estendendo-se a presente autoriza��o a informa��es relativas a pessoas jur�dicas de"+;
" que o CLIENTE participe no capital social como s�cio-quotista. O CLIENTE autoriza ainda, o Banco John Deere S.A. e as referidas Institui��es"+;
" Financeiras a compartilhar tais informa��es com suas empresas controladoras, controladas, coligadas e relacionadas, bem como com os"+;
" concession�rios John Deere participantes da comercializa��o de bens financiados atrav�s de opera��es em que o CLIENTE figure como creditado"+;
" ou garante. Sobre as mesmas informa��es as empresas dever�o manter sigilo absoluto."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"3�)O CLIENTE declara,"+;
" sob as penas da Lei, que: a) - os dados cadastrais apresentados e os documentos de suporte s�o verdadeiros e que n�o h� qualquer outra informa��o"+;
" ou documento, que n�o tenha sido comunicada e/ou entregue, que possa influenciar a an�lise de cr�dito pelo Banco John Deere S.A. e pelas"+;
" referidas Institui��es Financeiras, ou que possa afetar negativamente a execu��o da opera��o e/ou a normalidade de seu relacionamento com os"+;
" aludidos bancos, ou, ainda, importar em descumprimento de quaisquer determina��es legais e/ou regulamentares, inclusive daquelas previstas na"+;
" Lei e Circular a seguir referidas; b) - est� ciente de que, - por for�a da Lei 9.613/1998 (que disp�e sobre os crimes de 'lavagem' de dinheiro"+;
" ou oculta��o de bens, direitos e valores, e sobre a preven��o da utiliza��o do sistema financeiro para os il�citos nela previstos), bem como da"+;
" Circular 3.461/2009, do Banco Central (que consolida as regras sobre os procedimentos a serem adotados na preven��o e combate �s atividades"+;
" relacionadas com  os crimes previstos na referida Lei e com o financiamento ao terrorismo - Decreto 5.640/2005), -  as institui��es financeiras"+;
" devem manter registros e controles, procedendo as comunica��es �s autoridades competentes, de que tratam as referidas Lei e Circular, inclusive"+;
" para o fim de registro de cliente no Conselho de Controle de Atividades Financeiras (COAF); c) -  tendo ci�ncia de que as informa��es , ora"+;
"  prestadas,  destinam-se  inclusive  ao  atendimento  de  exig�ncias  legais  e/ou  regulamentares,  compromete-se  a  mant�-las atualizadas. bem"+;
" com a, se for o caso, complement�-las, alcan�ando tempestivamente as informa��es e documentos que, para tanto, se fizerem necess�rios."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
"4�) Pessoas Politicamente expostas: "+VMU->VMU_POLEXP+space(115)+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Conforme  Circular  3.461/2009  do  Banco  Central,"+;
"  consideram-se 'Pessoas  Politicamente  Expostas'  os  agentes  p�blicos  que desempenham ou tenham desempenhado, nos �ltimos cinco"+;
" anos, no Brasil ou em pa�ses, territ�rios e depend�ncias estrangeiros, cargos, empregos ou fun��es p�blicas relevantes,  assim como"+;
" seus  representantes,  familiares  e  outras  pessoas  de seu relacionamento pr�ximo."+VMU->VMU_POLEXP+CHR(13)+CHR(10)+CHR(13)+CHR(10)

aPPA := {;
{3,y+1,0,8.2,38,'C','@!',cTexto}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )

cTexto1 := "Declaro para os devidos fins, que de acordo com a Circular 3.461/2009 do BACEN considerado uma pessoa politicamente exposta."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
"Motivo: "+VMU->VMU_MOTOBS+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Local "+cCidEnt+"     Data "+transform(ddatabase,"@D")+space(90)+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
"Assinatura do cliente:____________________________________________"+space(80)

aPPA := {;
{3,y+40,0,2,1,'C','@!',"Assinatura:________________"}}
 nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
y := 0                  
oPrinter:StartPage()
aPPA := {;
{3,y+1,0,8.2,15,'C','@!',cTexto1}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )


if SA1->A1_LC > 1
   cLC := "Sim"
Else
   cLC := "N�o"
Endif   

cQuery := "SELECT SF2.F2_VALBRUT "
cQuery += "FROM "
cQuery += RetSqlName( "SF2" ) + " SF2 " 
cQuery += "WHERE " 
cQuery += "SF2.F2_FILIAL='"+ xFilial("SF2")+ "' AND SF2.F2_CLIENTE = '"+cCod+"' AND "
cQuery += "SF2.D_E_L_E_T_=' ' ORDER BY SF2.F2_EMISSAO DESC "                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSF2, .T., .T. )


aPPA := {;                       
{3,y+16,0,8.2,1,'C','@!',"PARECER DO CONCESSIONARIO SOBRE O CLIENTE" }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
aPPA := {;                       
{3,y+17,0,4,1,'C','@!',"Nome do Cliente (Completo): "+SA1->A1_NOME},{3,y+17,4,4.2,1,'C','@!',"CPF: "+SA1->A1_CGC},;
{3,y+18,0,3,1,'C','@!',"� Cliente?: "+x3cBoxDesc("VMU_ECLIEN",VMU->VMU_ECLIEN)},{3,y+18,3,2,1,'C','@!',"Conceito: "+VMU->VMU_CONCEI},{3,y+18,5,3.2,1,'C','@!',"Paga Pontualmente? "+VMU->VMU_PAGPON},;
{3,y+19,0,2,1,'C','@!',"Cliente possui limite de cr�dito "+cLC},{3,y+19,2,2,1,'C','@!',"Qual valor? R$ "+transform(SA1->A1_LC,"@E 999,999,999.99")},{3,y+19,4,4.2,1,'C','@!',"O produtor � cliente do concession�rio h� quanto tempo?: "+transform((dDatabase - IIf(SA1->(FieldPos("A1_MDATCAD"))>0,SA1->A1_MDATCAD,CtoD("")) ),"999999")+" dias" },;
{3,y+20,0,8.2,1,'C','@!',"N�mero de Anos de experi�ncia na agricultura: "+x3cBoxdesc("VMU_EXPAGR",VMU->VMU_EXPAGR)},;
{3,y+21,0,2,2,'C','@!',"Data da 1� Compra: "+transform(VMU->VMU_DTPRCP,"@D")},{3,y+21,2,2,2,'C','@!',"Data da �ltima Compra: "+transform(SA1->A1_ULTCOM,"@D")},{3,y+21,4,2,2,'C','@!',"Valor da �ltima compra: R$ "+transform(( cAliasSF2 )->F2_VALBRUT,"@E 999,999,999.99")},{3,y+21,6,2.2,2,'C','@!',"Prazo:"},;
{3,y+23,0,8.2,1,'C','@!',"Incluir no quadro abaixo parecer do concession�rio sobre o cliente:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
aPPA := {;                       
{3,y+24,0,8.2,6,'C','@!',VMU->VMU_PCOOBS}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
aPPA := {;                       
{3,y+31,0,8.2,13,'C','@!',CHR(13)+CHR(10)+CHR(13)+CHR(10)+"Dever� constar identifica��o e assinatura do respons�vel pela concess�o."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
"NOME  E ASSINATURA DO(S) RESPONS�VEL(EIS) NO CONCESSION�RIO PELA VERIFICA��O DAS  INFORMA��ES PRESTADAS E CONFER�NCIA DOS DOCUMENTOS)"+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
"DATA "+transform(dDatabase,"@D")+space(132)+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"NOME "+space(141)+CHR(13)+CHR(10)+CHR(13)+CHR(10)+"ASSINATURA:__________________________________"+space(100)}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )

( cAliasSF2 )->( dbCloseArea() )

Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_IMPFISJUR �Autor  �                 � Data �  01/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.     �  Impressao do Relatorio conforme sele��o na Parambox       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function FS_IMPFISJUR(cCod)

If l_PATRIM
	FS_PATRIM(cCod)   // Patrimonio
Endif
If l_IMVRURA
	FS_IMVRURA(cCod)  // Imoveis Rurais
Endif
If l_IMVURBA
	FS_IMVURBA(cCod)  // Imoveis Urbanos
Endif
If l_IMOARRE
	FS_IMOARRE(cCod)  // Imoveis Arrendados / Comodato
Endif
If l_BENFINS
	FS_BENFINS(cCod)  // Benfeitorias / Instalacoes
Endif
If l_MAQAGRI
	FS_MAQAGRI(cCod)  // Maquinas Agricolas
Endif
If l_IMPOUT
	FS_IMPOUT(cCod)	  // Implementos / Outros
Endif
If l_VEICULO
	FS_VEICULO(cCod)  // Veiculos
Endif
If l_PARTEMP
	FS_PARTEMP(cCod)  // Participa��es em Empresas 
Endif
If l_RECDESP
	FS_RECDESP(cCod)  // Receitas / Despesas
Endif
If l_CULAGRI
	FS_CULAGRI(cCod)  // Culturas Agricolas
Endif
If l_PRODUCAO
	FS_PRODUCAO(cCod) // Produ��o
Endif
If l_PECUARIA
	FS_PECUARIA(cCod) // Pecu�ria
Endif
If l_PRESTSRV
	FS_PRESTSRV(cCod) // Presta��o de Servi�os
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa � FS_IMOARRE �Autor � � Data � 25/06/13 ���
�������������������������������������������������������������������������͹��
���Desc. � Imoveis Arrendados / Comodato ���
��� � ���
�������������������������������������������������������������������������͹��
���Uso � Ficha Cadastral ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_IMOARRE(cCod)
	Local i := 0 

	if y > 35
		FS_RUBRICA(6,1)
	Endif

	aPPA := {;
	{3,y,0,8.2,1,'C','@!',"IM�VEIS ARRENDADOS/COMODATO (Relacionar todos e anexar os contratos):"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
	y++

	aPPA := {;
	{3,y,0,2,3,'C','@!',"Munic�pio/UF"},{3,y,2,1,3,'C','@!',"�rea Arrendada (ha)"},{3,y,3,1,3,'C','@!',"�rea Explorada (ha)"},{3,y,4,1.5,3,'C','@!',"Nome do Propriet�rio"},{3,y,5.5,1,3,'C','@!',"Vencimento Final do Arrendamento (dd/mm/aaaa)"},;
	{3,y,6.5,1.7,3,'C','@!',"Custo Anual (Especificar: sacas de soja, R$, arrobas de boi, % da produ��o)"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 3

	// Imoveis Arrendados/Comodato
	cQuery := "SELECT VP6.VP6_CARTOR,VP6.VP6_AREA,VP6.VP6_ARCULT,VP6.VP6_PROPRI,VP6.VP6_VENCTO,VP6.VP6_CUSARR "
	cQuery += "FROM "
	cQuery += RetSqlName( "VP6" ) + " VP6 " 
	cQuery += "WHERE " 
	cQuery += "VP6.VP6_FILIAL='" + xFilial("VP6") + "' AND VP6.VP6_CODCLI = '" + cCod + "' AND VP6.VP6_TIPIMO = '0' AND "
	cQuery += "VP6.D_E_L_E_T_=' '" 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVP6, .T., .T. )

	Do While !( cAliasVP6 )->( Eof() )

		Aadd(aImoveisA,{	( cAliasVP6 )->VP6_CARTOR,;
		( cAliasVP6 )->VP6_AREA,;
		( cAliasVP6 )->VP6_ARCULT,;
		( cAliasVP6 )->VP6_PROPRI,;
		( cAliasVP6 )->VP6_VENCTO,;
		( cAliasVP6 )->VP6_CUSARR})

		dbSelectArea(cAliasVP6)
		( cAliasVP6 )->(dbSkip())
	Enddo
	( cAliasVP6 )->( dbCloseArea() )

	aPPA := {}
	nAreaArr := 0
	nAreaExp := 0
	For i := 1 to Len(aImoveisA)

		if y > 35
			FS_RUBRICA(1,1)
		Endif

		aPPA := {;
		{3,y,0,2,1,'C','@!',aImoveisA[i,1]},{3,y,2,1,1,'C','@!',transform(aImoveisA[i,2],"@E 9,999.99")},{3,y,3,1,1,'C','@!',transform(aImoveisA[i,3],"@E 9,999.99")},{3,y,4,1.5,1,'C','@!',aImoveisA[i,4]},{3,y,5.5,1,1,'C','@!',transform(stod(aImoveisA[i,5]),"@D")},;
		{3,y,6.5,1.7,1,'C','@!',transform(aImoveisA[i,6],"@E 999,999,999.99")}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

		nAreaArr += aImoveisA[i,2]
		nAreaExp += aImoveisA[i,3]
		y += 8

	Next 

	aPPA := {;
	{3,y,0,2,1,'C','@!',"TOTAL"},{3,y,2,1,1,'C','@!',transform(nAreaArr,"@E 9,999.99")},{3,y,3,1,1,'C','@!',transform(nAreaExp,"@E 9,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

	y++

Return(.t.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa � FS_BENFINS �Autor � � Data � 25/06/13 ���
�������������������������������������������������������������������������͹��
���Desc. � Benfeitorias / Instalacoes ���
��� � ���
�������������������������������������������������������������������������͹��
���Uso � Ficha Cadastral ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_BENFINS(cCod)
	Local i := 0 
	Local aBenfe := {}
	Local aArmaz := {}

	if y + 3 > 35
		FS_RUBRICA(1,1)
	Endif	 

	aPPA := {;
	{3,y,0,8.2,1,'C','@!',"BENFEITORIAS / INSTALA��ES:"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
	y++

	// BENFEITORIAS / INSTALA��ES:
	cQuery := "SELECT VMV.VMV_TIPINS,VMV.VMV_VALMER,VMV.VMV_CAPACI,VMV.VMV_PRODUT "
	cQuery += "FROM "
	cQuery += RetSqlName( "VMV" ) + " VMV " 
	cQuery += "WHERE " 
	cQuery += "VMV.VMV_FILIAL='" + xFilial("VMV") + "' AND VMV.VMV_CODCLI = '" + cCod + "' AND "
	cQuery += "VMV.D_E_L_E_T_=' '" 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMV, .T., .T. )

	Do While !( cAliasVMV )->( Eof() )

		if Alltrim(( cAliasVMV )->VMV_TIPINS) $ GetNewPar("MV_MIL0008","")
			Aadd(aArmaz,{( cAliasVMV )->VMV_VALMER,( cAliasVMV )->VMV_CAPACI,( cAliasVMV )->VMV_PRODUT})
		Endif
		if Alltrim(( cAliasVMV )->VMV_TIPINS) $ GetNewPar("MV_MIL0009","")
			Aadd(aBenfe,{( cAliasVMV )->VMV_VALMER,( cAliasVMV )->VMV_CAPACI,( cAliasVMV )->VMV_PRODUT})
		Endif
		dbSelectArea(cAliasVMV)
		( cAliasVMV )->(dbSkip())

	Enddo
	( cAliasVMV )->( dbCloseArea() )
	if Len(aArmaz) > 0 
		cArm := "Sim"
	Else
		cArm := "N�o"
	Endif 

	aPPA := {{3,y,0,8.2,1,'C','@!',"* Possui infra-estrutura de armazenagem? " + cArm}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

	For i := 1 to Len(aArmaz)
		if y + 3 > 35
			FS_RUBRICA(1,1)
		Endif
		aPPA := {; 
		{3,y,0,8.2,1,'C','@!',"Valor de Mercado: R$ Est�: " + transform(aArmaz[i,1],"@E 999,999,999.99") + " Capacidade: " + transform(aArmaz[i,2],"@E 999,999,999.99") + " sacas/toneladas de " + aArmaz[i,3]}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
		y += 3
	Next 

	if Len(aBenfe) > 0 
		cBenf := "Sim"
	Else
		cBenf := "N�o"
	Endif 

	if y + 2 > 35
		FS_RUBRICA(1,1)
	Endif

	aPPA := {{3,y,0,8.2,1,'C','@!',"* Possui usinas de beneficiamento e ou estufas? " + cBenf}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

	For i := 1 to Len(aBenfe)
		if y > 35
			FS_RUBRICA(1,1)
		Endif
		aPPA := {; 
		{3,y,0,8.2,1,'C','@!',"Valor de Mercado: R$ Est�: " + transform(aBenfe[i,1],"@E 999,999,999.99") + " Capacidade: " + transform(aBenfe[i,2],"@E 999,999,999.99") + " sacas/toneladas de " + aBenfe[i,3]}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
		y++
	Next 

	if y + 3 > 35
		FS_RUBRICA(1,1)
	Endif

	aPPA := {{3,y,0,8.2,1,'C','@!',"Descrever: avi�rios, pocilgas, piv�s, etc. "}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

	aPPA := {;
	{3,y,0,6,1,'C','@!',"Descri��o Sum�ria - Outras instala��es relevantes"},{3,y,6,2.2,1,'C','@!',"Valor de Mercado"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

	// Descrever: avi�rios, pocilgas, piv�s, etc
	cQuery := "SELECT VMW.VMW_DESCRI,VMW.VMW_VALMER "
	cQuery += "FROM "
	cQuery += RetSqlName( "VMW" ) + " VMW " 
	cQuery += "WHERE " 
	cQuery += "VMW.VMW_FILIAL='" + xFilial("VMW") + "' AND VMW.VMW_CODCLI = '" + cCod + "' AND "
	cQuery += "VMW.D_E_L_E_T_=' '" 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMW, .T., .T. )

	Do While !( cAliasVMW )->( Eof() )
		Aadd(aAvi�rios,{( cAliasVMW )->VMW_DESCRI,( cAliasVMW )->VMW_VALMER})

		dbSelectArea(cAliasVMW)
		( cAliasVMW )->(dbSkip())
	Enddo
	( cAliasVMW )->( dbCloseArea() )
	aPPA := {}
	For i := 1 to Len(aAvi�rios)

		if y > 35
			FS_RUBRICA(1,1)
		Endif
		aPPA := {;
		{3,y,0,6,1,'C','@!',aAvi�rios[i,1]},{3,y,6,2.2,1,'C','@!',transform(aAvi�rios[i,2],"@E 999,999,999.99")}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
		y++
	Next
	y++ 

Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa � FS_MAQAGRI �Autor � � Data � 25/06/13 ���
�������������������������������������������������������������������������͹��
���Desc. � ���
��� � ���
�������������������������������������������������������������������������͹��
���Uso � Ficha Cadastral ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_MAQAGRI(cCod)
	Local i := 0 
	Local _qtd := 0
	Local nQtdFro := 0

	if y + 4 > 35
		FS_RUBRICA(1,1)
	Endif

	aPPA := {{3,y,0,8.2,1,'C','@!',"M�QUINAS AGR�COLAS (Colheitadeira, Trator, Plantadeira, Pulverizador Automotriz):"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
	y++

	aPPA := {;
	{3,y,0.0,1.7,2,'C','@!',"Bem (CA, TR, PL, PM)"},;
	{3,y,1.7,0.5,2,'C','@!',"Marca"},;
	{3,y,2.2,1.0,2,'C','@!',"Modelo"},;
	{3,y,3.2,0.7,2,'C','@!',"Ano"},;
	{3,y,3.9,1.5,2,'C','@!',"Chassi"},;
	{3,y,5.4,1.0,2,'C','@!',"Participa��o do cliente(%)"},;
	{3,y,6.4,0.7,2,'C','@!',"L/O"},;
	{3,y,7.1,1.1,2,'C','@!',"Valor de Mercado (R$)"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 2

	// M�QUINAS AGR�COLAS (Colheitadeira, Trator, Plantadeira, Pulverizador Automotriz):
	cQuery := "SELECT VC3.VC3_CODMAR,VC3.VC3_MODVEI,VC3.VC3_FABMOD,VC3.VC3_PERPAR,VC3.VC3_SITUAC,VC3.VC3_VALMER,VC3.VC3_QTDFRO,VV2.VV2_DESMOD, VC3.VC3_CHASSI "
	cQuery += "FROM "
	cQuery += RetSqlName( "VC3" ) + " VC3 " 
	cQuery += "LEFT JOIN " + RetSqlName("VV2") + " VV2 ON (VV2.VV2_FILIAL='" + xFilial("VV2") + "' AND VV2.VV2_CODMAR = VC3.VC3_CODMAR AND VV2.VV2_MODVEI = VC3.VC3_MODVEI AND VV2.D_E_L_E_T_=' ') "
	cQuery += "WHERE " 
	cQuery += "VC3.VC3_FILIAL='" + xFilial("VC3") + "' AND VC3.VC3_CODCLI = '" + cCod + "' AND VC3.VC3_TIPO = '1' AND "
	cQuery += "VC3.D_E_L_E_T_=' '" 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVC3, .T., .T. )

	Do While !( cAliasVC3 )->( Eof() )
		nQtdFro := ( cAliasVC3 )->VC3_QTDFRO 
		if nQtdFro > 0 
			For _qtd := 1 to nQtdFro
				Aadd(aMaqAgri,{( cAliasVC3 )->VC3_CODMAR,( cAliasVC3 )->VC3_MODVEI,( cAliasVC3 )->VC3_FABMOD,( cAliasVC3 )->VC3_PERPAR,( cAliasVC3 )->VC3_SITUAC,( cAliasVC3 )->VC3_VALMER,( cAliasVC3 )->VV2_DESMOD,( cAliasVC3 )->VC3_CHASSI})
			Next
		Else
			Aadd(aMaqAgri,{( cAliasVC3 )->VC3_CODMAR,( cAliasVC3 )->VC3_MODVEI,( cAliasVC3 )->VC3_FABMOD,( cAliasVC3 )->VC3_PERPAR,( cAliasVC3 )->VC3_SITUAC,( cAliasVC3 )->VC3_VALMER,( cAliasVC3 )->VV2_DESMOD,( cAliasVC3 )->VC3_CHASSI})
		Endif 
		dbSelectArea(cAliasVC3)
		( cAliasVC3 )->(dbSkip())

	Enddo
	( cAliasVC3 )->( dbCloseArea() )

	aPPA := {} 
	cSituac := ""
	For i := 1 to Len(aMaqAgri)

		if y > 35
			FS_RUBRICA(1,1)
		Endif
		if aMaqAgri[i,5] == "0"
			cSituac := "Livre"
		Elseif aMaqAgri[i,5] == "1" 
			cSituac := "Onerado"
		Else
			cSituac := ""
		Endif 

		aPPA := {;
		{3,y,0.0,1.7,2,'C','@!',AllTrim(aMaqAgri[i,7])},;
		{3,y,1.7,0.5,2,'C','@!',aMaqAgri[i,1]},;
		{3,y,2.2,1.0,2,'C','@!',aMaqAgri[i,2]},;
		{3,y,3.2,0.7,2,'C','@!',aMaqAgri[i,3]},;
		{3,y,3.9,1.5,2,'C','@!',aMaqAgri[i,8]},;
		{3,y,5.4,1.0,2,'C','@!',transform(aMaqAgri[i,4],"@E 999.99")},;
		{3,y,6.4,0.7,2,'C','@!',cSituac},;
		{3,y,7.1,1.1,2,'C','@!',transform(aMaqAgri[i,6],"@E 999,999,999.99")}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18, "Top" )

		y += 2
	Next
	y++ 
Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_IMPOUT    �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     � Implementos / Outros                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_IMPOUT(cCod)
Local i := 0    
Local nQtdFro := 0 
Local _qtd := 0

aPPA := {;
{3,y,0,8.2,1,'C','@!',"IMPLEMENTOS / OUTROS (relacionar apenas os de valores expressivos):"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y > 35
	FS_RUBRICA(3,0)
Endif
aPPA := {;
{3,y+1,0,6,1,'C','@!',"Descri��o Sum�ria"},{3,y+1,6,2.2,1,'C','@!',"Valor de Mercado (R$)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
if y > 35
	FS_RUBRICA(4,0)
Endif

// IMPLEMENTOS / OUTROS (relacionar apenas os de valores expressivos): 
cQuery := "SELECT VC3.VC3_MODVEI,VC3.VC3_VALMER,VC3.VC3_QTDFRO,VV2.VV2_DESMOD "
cQuery += "FROM "
cQuery += RetSqlName( "VC3" ) + " VC3 " 
cQuery += "LEFT JOIN "+RetSqlName("VV2")+" VV2 ON (VV2.VV2_FILIAL='"+xFilial("VV2")+"' AND VV2.VV2_CODMAR = VC3.VC3_CODMAR AND VV2.VV2_MODVEI = VC3.VC3_MODVEI AND VV2.D_E_L_E_T_=' ') "
cQuery += "WHERE " 
cQuery += "VC3.VC3_FILIAL='"+ xFilial("VC3")+ "' AND VC3.VC3_CODCLI = '"+cCod+"' AND VC3.VC3_TIPO = '0' AND "
cQuery += "VC3.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVC3, .T., .T. )

Do While !( cAliasVC3 )->( Eof() )
 
   nQtdFro :=  ( cAliasVC3 )->VC3_QTDFRO  
   if nQtdFro > 0 
	   For _qtd := 1 to nQtdFro
		   Aadd(aImplem,{( cAliasVC3 )->VC3_MODVEI,( cAliasVC3 )->VC3_VALMER,( cAliasVC3 )->VV2_DESMOD})
       Next
   Else
	   Aadd(aImplem,{( cAliasVC3 )->VC3_MODVEI,( cAliasVC3 )->VC3_VALMER,( cAliasVC3 )->VV2_DESMOD})
   Endif    
   dbSelectArea(cAliasVC3)
   ( cAliasVC3 )->(dbSkip())
   
Enddo
( cAliasVC3 )->( dbCloseArea() )
aPPA := {}     
For i := 1 to Len(aImplem)

	if y > 35
		FS_RUBRICA(4,1)
	Endif
	aPPA := {;
	{3,y+2,0,6,1,'C','@!',aImplem[i,1]+" "+aImplem[i,3]},{3,y+2,6,2.2,1,'C','@!',transform(aImplem[i,2],"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )

	y += 1

Next                  
 
Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_VEICULO   �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_VEICULO(cCod)
Local i := 0  
Local nQtdFro := 0 
Local _qtd := 0     

// Veiculos
cQuery := "SELECT VC3.VC3_CODMAR,VC3.VC3_MODVEI,VC3.VC3_FABMOD,VC3.VC3_SITUAC,VC3.VC3_VALMER,VC3.VC3_PLAVEI,VC3.VC3_TIPO,VC3.VC3_QTDFRO "
cQuery += "FROM "
cQuery += RetSqlName( "VC3" ) + " VC3 " 
cQuery += "WHERE " 
cQuery += "VC3.VC3_FILIAL='"+ xFilial("VC3")+ "' AND VC3.VC3_CODCLI = '"+cCod+"' AND "
cQuery += "VC3.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVC3, .T., .T. )

Do While !( cAliasVC3 )->( Eof() )
                 
   nQtdFro :=  ( cAliasVC3 )->VC3_QTDFRO  
   if nQtdFro > 0 
	   For _qtd := 1 to nQtdFro
			If ( cAliasVC3 )->VC3_TIPO == "2" //Veiculos
			   Aadd(aVeiculoV,{( cAliasVC3 )->VC3_CODMAR,( cAliasVC3 )->VC3_MODVEI,( cAliasVC3 )->VC3_FABMOD,( cAliasVC3 )->VC3_SITUAC,( cAliasVC3 )->VC3_VALMER,( cAliasVC3 )->VC3_PLAVEI})
			Endif
       Next
   Else
		If ( cAliasVC3 )->VC3_TIPO == "2" //Veiculos
		   Aadd(aVeiculoV,{( cAliasVC3 )->VC3_CODMAR,( cAliasVC3 )->VC3_MODVEI,( cAliasVC3 )->VC3_FABMOD,( cAliasVC3 )->VC3_SITUAC,( cAliasVC3 )->VC3_VALMER,( cAliasVC3 )->VC3_PLAVEI})
		Endif
   Endif    
   dbSelectArea(cAliasVC3)
   ( cAliasVC3 )->(dbSkip())
   
Enddo
( cAliasVC3 )->( dbCloseArea() )

If Len(aVeiculoV) > 0
	aPPA := {;
	{3,y,0,8.2,1,'C','@!',"VE�CULOS: "}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
	if y > 35
		FS_RUBRICA(3,0)
	Endif
	aPPA := {;
	{3,y+1,0,1,1,'C','@!',"Marca"},{3,y+1,1,2,1,'C','@!',"Modelo"},{3,y+1,3,1,1,'C','@!',"Ano"},{3,y+1,4,1,1,'C','@!',"Placa"},{3,y+1,5,2,1,'C','@!',"L/O"},;
	{3,y+1,7,1.2,1,'C','@!',"Valor de Mercado"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	if y+1 > 35
		FS_RUBRICA(4,0)
	Endif
	
	y := y+2
	aPPA := {}
	For i := 1 to Len(aVeiculoV)
	
		aPPA := {;
		{3,y,0,1,1,'C','@!',aVeiculoV[i,1]},{3,y,1,2,1,'C','@!',aVeiculoV[i,2]},{3,y,3,1,1,'C','@!',substr(aVeiculoV[i,3],1,4)+"/"+substr(aVeiculoV[i,3],5,4)},{3,y,4,1,1,'C','@!',aVeiculoV[i,4]},{3,y,5,2,1,'C','@!',aVeiculoV[i,6]},;
		{3,y,7,1.2,1,'C','@!',transform(aVeiculoV[i,5],"@E 999,999,999.99")}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
		y += 1
		if y > 35
			FS_RUBRICA(3,1)
		Endif
	
	Next                  
Endif

Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_PARTEMP   �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_PARTEMP(cCod)
Local i := 0   
y+=1
aPPA := {;
{3,y,0,8.2,1,'C','@!',"PARTICIPA��ES EM EMPRESAS:" }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y > 35
	FS_RUBRICA(3,0)
Endif
aPPA := {;
{3,y+1,0,2,2,'C','@!',"Raz�o Social:"},{3,y+1,2,1,2,'C','@!',"CNPJ:"},{3,y+1,3,1,2,'C','@!',"Patrim�nio L�quido (R$):"},{3,y+1,4,1,2,'C','@!',"Descri��o do ramo de atividade:"},{3,y+1,5,1,2,'C','@!',"Data funda��o(dd/mm/aaaa):"},;
{3,y+1,6,1,2,'C','@!',"Faturamento anual (R$):"},{3,y+1,7,1.2,2,'C','@!',"Participa��o na empresa(%): "}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top")
if y+1 > 35
	FS_RUBRICA(4,0)
Endif

// Participa��es em empresas
cQuery := "SELECT VMR.VMR_NOME,VMR.VMR_CNPJ,VMR.VMR_PATLIQ,VMR.VMR_ATIVID,VMR.VMR_DATFUN,VMR.VMR_FATANU,VMR.VMR_PPACAP "
cQuery += "FROM "
cQuery += RetSqlName( "VMR" ) + " VMR " 
cQuery += "WHERE " 
cQuery += "VMR.VMR_FILIAL='"+ xFilial("VMR")+ "' AND VMR.VMR_CODCLI = '"+cCod+"' AND "
cQuery += "VMR.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMR, .T., .T. )

Do While !( cAliasVMR )->( Eof() )
   
   Aadd(aPartEmp,{( cAliasVMR )->VMR_NOME,( cAliasVMR )->VMR_CNPJ,( cAliasVMR )->VMR_PATLIQ,( cAliasVMR )->VMR_ATIVID,( cAliasVMR )->VMR_DATFUN,( cAliasVMR )->VMR_FATANU,( cAliasVMR )->VMR_PPACAP})

   dbSelectArea(cAliasVMR)
   ( cAliasVMR )->(dbSkip())
   
Enddo
( cAliasVMR )->( dbCloseArea() )
y := y+3
aPPA := {}
For i := 1 to Len(aPartEmp)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	aPPA := {;
	{3,y,0,2,1,'C','@!',aPartEmp[i,1]},{3,y,2,1,1,'C','@!',aPartEmp[i,2]},{3,y,3,1,1,'C','@!',transform(aPartEmp[i,3],"@E 999,999,999.99")},{3,y,4,1,1,'C','@!',aPartEmp[i,4]},{3,y,5,1,1,'C','@!',transform(stod(aPartEmp[i,5]),"@D")},;
	{3,y,6,1,1,'C','@!',transform(aPartEmp[i,6],"@E 999,999,999.99")},{3,y,7,1.2,1,'C','@!',transform(aPartEmp[i,7],"@E 999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1

Next                  

Return(.t.)




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_RECDESP   �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_RECDESP(cCod)
Local i := 0 

aPPA := {;
{3,y,0,8.2,1,'C','@!',"RECEITAS E DESPESAS DA ATIVIDADE"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+3 > 35
	FS_RUBRICA(3,0)
Endif

aPPA := {;
{3,y+1,0,8.2,1,'C','@!'," Regime de Explora��o da Atividade "}}

nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
if y+3 > 35
	FS_RUBRICA(4,0)
Endif

aPPA := {;
{3,y+2,0,8.2,1,'C','@!'," Obs: No caso de Parceria/Condom�nio indicar os dados de todos os Participantes " }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
if y > 35
	FS_RUBRICA(5,0)
Endif

aPPA := {;
{3,y+3,0,3,1,'C','@!',"NOME" },{3,y+3,3,2,1,'C','@!',"CPF/" },{3,y+3,5,2,1,'C','@!',"Regime Explora��o" },{3,y+3,7,1.2,1,'C','@!',"% DE PARTICIPA��O" }}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
if y+4 > 35
	FS_RUBRICA(5,0)
Endif

// RECEITAS E DESPESAS DA ATIVIDADE
cQuery := "SELECT VMM.VMM_PARTIC,VMM.VMM_CGC,VMM.VMM_PERPAR,VMM.VMM_REGEXP "
cQuery += "FROM "
cQuery += RetSqlName( "VMM" ) + " VMM " 
cQuery += "WHERE " 
cQuery += "VMM.VMM_FILIAL='"+ xFilial("VMM")+ "' AND VMM.VMM_CODCLI = '"+cCod+"' AND "
cQuery += "VMM.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMM, .T., .T. )

Do While !( cAliasVMM )->( Eof() )
   
   Aadd(aReceitas,{( cAliasVMM )->VMM_PARTIC,( cAliasVMM )->VMM_CGC,( cAliasVMM )->VMM_PERPAR,X3CBOXDESC("VMM_REGEXP",( cAliasVMM )->VMM_REGEXP)})

   dbSelectArea(cAliasVMM)
   ( cAliasVMM )->(dbSkip())
   
Enddo
( cAliasVMM )->( dbCloseArea() )
y := y+4
aPPA := {}
For i := 1 to Len(aReceitas)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	aPPA := {;
	{3,y,0,3,1,'C','@!',aReceitas[i,1] },{3,y,3,2,1,'C','@!',aReceitas[i,2] },{3,y,5,2,1,'C','@!',aReceitas[i,4]},{3,y,7,1.2,1,'C','@!',transform(aReceitas[i,3],"@E 999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y += 1
Next                  

M_RENAGR := 0 // Receita Agropecu�ria Bruta - RAB
M_OUTREN := 0 // Outras Receitas
M_RANOPB := 0 // Receita Operacional Bruta - ROB
M_INTEG   := 0

//cAno := Alltrim(str(year(ddatabase)-1))
cAno := Alltrim(str(year(aRet[1])))

cQuery := "SELECT VMK.VMK_PRODUC,VMK.VMK_VUNIVD " 
cQuery += "FROM "
cQuery += RetSqlName( "VMK" ) + " VMK " 
cQuery += "WHERE " 
cQuery += "VMK.VMK_FILIAL='"+ xFilial("VMK")+ "' AND VMK.VMK_ANO = '"+cAno+"' AND VMK.VMK_CODCLI = '"+SA1->A1_COD+"' AND "
cQuery += "VMK.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMK, .T., .T. )

Do While !( cAliasVMK )->( Eof() )
                             
    M_RENAGR += ( ( cAliasVMK )->VMK_PRODUC * ( cAliasVMK )->VMK_VUNIVD)

    dbSelectArea(cAliasVMK)
    ( cAliasVMK )->(dbSkip())
    
Enddo    
( cAliasVMK )->( dbCloseArea() )

cQuery := "SELECT VML.VML_ANIVDA,VML.VML_PRMDVD,VML.VML_ESPECI,VML.VML_OUTREC,VML.VML_QTDMAT,VML.VML_QTDLTD,VML.VML_PMDLIT,VML.VML_VACLAC "
cQuery += "FROM "
cQuery += RetSqlName( "VML" ) + " VML " 
cQuery += "WHERE " 
cQuery += "VML.VML_FILIAL='"+ xFilial("VML")+ "' AND VML.VML_ANO = '"+cAno+"' AND VML.VML_CODCLI = '"+SA1->A1_COD+"' AND "
cQuery += "VML.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVML, .T., .T. )

Do While !( cAliasVML )->( Eof() )
                             

    if ( cAliasVML )->VML_ESPECI <> "1"
	    M_RENAGR += ( (( cAliasVML )->VML_ANIVDA * ( cAliasVML )->VML_PRMDVD) + ( cAliasVML )->VML_OUTREC )
	Else
	    M_RENAGR += ( cAliasVML )->VML_VACLAC * ( cAliasVML )->VML_QTDLTD * 360 * ( cAliasVML )->VML_PMDLIT
	Endif    

//    M_RENAGR += ( (( cAliasVML )->VML_ANIVDA * ( cAliasVML )->VML_PRMDVD) + ( cAliasVML )->VML_OUTREC )

    dbSelectArea(cAliasVML)
    ( cAliasVML )->(dbSkip())
    
Enddo    
( cAliasVML )->( dbCloseArea() )


cQuery := "SELECT VMT.VMT_VALLIQ,VMT.VMT_QTDANI "
cQuery += "FROM "
cQuery += RetSqlName( "VMT" ) + " VMT " 
cQuery += "WHERE " 
cQuery += "VMT.VMT_FILIAL='"+ xFilial("VMT")+ "' AND VMT.VMT_CODCLI = '"+SA1->A1_COD+"' AND "
cQuery += "VMT.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMT, .T., .T. )

Do While !( cAliasVMT )->( Eof() )
                             
    M_RENAGR += ( cAliasVMT )->VMT_VALLIQ

    dbSelectArea(cAliasVMT)
    ( cAliasVMT )->(dbSkip())
    
Enddo    
( cAliasVMT )->( dbCloseArea() )


cQuery := "SELECT VMS.VMS_RECANO "
cQuery += "FROM "
cQuery += RetSqlName( "VMS" ) + " VMS " 
cQuery += "WHERE " 
cQuery += "VMS.VMS_FILIAL='"+ xFilial("VMS")+ "' AND VMS.VMS_ANO = '"+cAno+"' AND VMS.VMS_CODCLI = '"+SA1->A1_COD+"' AND "
cQuery += "VMS.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMS, .T., .T. )

Do While !( cAliasVMS )->( Eof() )
                             
    M_OUTREN += (( cAliasVMS )->VMS_RECANO)

    dbSelectArea(cAliasVMS)
    ( cAliasVMS )->(dbSkip())
    
Enddo    
( cAliasVMS )->( dbCloseArea() )

cQuery := "SELECT VMQ.VMQ_RECTTA " 
cQuery += "FROM "
cQuery += RetSqlName( "VMQ" ) + " VMQ " 
cQuery += "WHERE " 
cQuery += "VMQ.VMQ_FILIAL='"+ xFilial("VMQ")+ "' AND VMQ.VMQ_CODCLI = '"+SA1->A1_COD+"' AND "
cQuery += "VMQ.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMQ, .T., .T. )

Do While !( cAliasVMQ )->( Eof() )
                             
    M_OUTREN += ( cAliasVMQ )->VMQ_RECTTA

    dbSelectArea(cAliasVMQ)
    ( cAliasVMQ )->(dbSkip())
    
Enddo    
( cAliasVMQ )->( dbCloseArea() )

        
//M_RANOPB := M_RENAGR + M_OUTREN
M_RANOPB := M_RENAGR + M_OUTREN 

aPPA := {;
{3,y,0,8.2,3,'C','@!',"* Renda Agropecu�ria Bruta (RAB): R$ "+transform(M_RENAGR,"@E 999,999,999.99")+CHR(13)+CHR(10)+;
                      "* Outras Rendas (especificar):    R$ "+transform(M_OUTREN,"@E 999,999,999.99")+CHR(13)+CHR(10)+;
					  "* Renda Operacional Bruta  (ROB): R$ "+transform(M_RANOPB,"@E 999,999,999.99")}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y > 35
	FS_RUBRICA(3,0)
Endif

aPPA := {;
{3,y+4,0,8.2,2,'C','@!',"OBS: RAB e ROB se referem �s receitas auferidas no ano anterior"+CHR(13)+CHR(10)+"Quando estiver iniciando na atividade informar RAB projetada para a 1� safra."}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+4 > 35
	FS_RUBRICA(7,0)
Endif

Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_CULAGRI   �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_CULAGRI(cCod)
Local i := 0

aPPA := {;
{3,y+6,0,8.2,2,'C','@!',"CULTURAS AGR�COLAS (pr�xima safra):"+CHR(13)+CHR(10)+"Obs: Em caso de condom�nio/parceria, dever� ser considerado o total das �reas cultivadas por todos os participantes."}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top",oVerdanaN )
if y+8 > 35
	FS_RUBRICA(9,0)
Endif

aPPA := {;
{3,y+8,0,1,3,'C','@!',"Cultura"},{3,y+8,1,1,3,'C','@!',"�rea cultivada(ha)"},{3,y+8,2,1,3,'C','@!',"Regi�o"},{3,y+8,3,2,3,'C','@!',"Produ��o/Unidade (sacas, kg, caixas, ton., arrobas)"},{3,y+8,5,1,3,'C','@!',"Per�odo de Plantio (M�s/Ano)"},{3,y+8,6,1,3,'C','@!',"Per�odo de Colheita"},{3,y+8,7,1.2,3,'C','@!',"Custo Previsto (R$/ha ou sacas/ha)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
y := y+11
if y > 35
	FS_RUBRICA(14,0)
Endif

cDia := substr(dtoc(dDat),1,2)
cMes := substr(dtoc(dDat),4,2)
cAno :=  Alltrim(str(val(substr(dtoc(dDat),7,4))+1))
dData := ctod(cDia+"/"+cMes+"/"+cAno)

// CULTURAS AGR�COLAS 
cQuery := "SELECT VMK.VMK_CODCUL,VMK.VMK_ARECUL,VMK.VMK_PRODUC,VMK.VMK_UNIDAD,VMK.VMK_INIPLA,VMK.VMK_FIMPLA,VMK.VMK_INICOL,VMK.VMK_FIMCOL,VMK.VMK_CUSPRV,VMK.VMK_PAISEQ, VMK.VMK_CODCLI "
cQuery += "FROM "
cQuery += RetSqlName( "VMK" ) + " VMK " 
cQuery += "WHERE "       
cQuery += "VMK.VMK_FILIAL='"+ xFilial("VMK")+ "' AND VMK.VMK_CODCLI = '"+cCod+"' AND VMK.VMK_FIMCOL >= '"+dtos(dDat)+"' AND VMK.VMK_FIMCOL <=  '"+dtos(dData)+"' AND  VMK.D_E_L_E_T_=' '"

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMK, .T., .T. )
        
Do While !( cAliasVMK )->( Eof() )

   VMJ->(DbSeek(xFilial("VMJ")+( cAliasVMK )->VMK_CODCLI+( cAliasVMK )->VMK_PAISEQ))
   VX5->(DbSeek(xFilial("VX5")+"003"+( cAliasVMK )->VMK_CODCUL))
   Aadd(aCulturas,{( cAliasVMK )->VMK_CODCUL,VX5->(&(IIf(FindFunction("OA5600011_Campo_Idioma"),OA5600011_Campo_Idioma(),"VX5_DESCRI"))),( cAliasVMK )->VMK_ARECUL,VMJ->VMJ_DESREG,( cAliasVMK )->VMK_PRODUC,( cAliasVMK )->VMK_UNIDAD,( cAliasVMK )->VMK_INIPLA,( cAliasVMK )->VMK_FIMPLA,( cAliasVMK )->VMK_INICOL,( cAliasVMK )->VMK_FIMCOL,( cAliasVMK )->VMK_CUSPRV})

   dbSelectArea(cAliasVMK)
   ( cAliasVMK )->(dbSkip())
   
Enddo
( cAliasVMK )->( dbCloseArea() )

aPPA := {}
For i := 1 to Len(aCulturas)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	dIniPla := Alltrim(strzero(month(stod(aCulturas[i,7])),2))+"/"+Alltrim(str(year(stod(aCulturas[i,7]))))
	dFinPla := Alltrim(strzero(month(stod(aCulturas[i,8])),2))+"/"+Alltrim(str(year(stod(aCulturas[i,8]))))
	dIniCol := Alltrim(strzero(month(stod(aCulturas[i,9])),2))+"/"+Alltrim(str(year(stod(aCulturas[i,9]))))
	dFinCol := Alltrim(strzero(month(stod(aCulturas[i,10])),2))+"/"+Alltrim(str(year(stod(aCulturas[i,10]))))
//			{3,y,0,1,3,'C','@!',aCulturas[i,1]+" "+aCulturas[i,2]},;
	aPPA := {;                        
			{3,y,0,1,3,'C','@!',aCulturas[i,2]},;
			{3,y,1,1,3,'C','@!',transform(aCulturas[i,3],"@E 9,999.99")},;
			{3,y,2,1,3,'C','@!',aCulturas[i,4]},;
			{3,y,3,2,3,'C','@!',transform(aCulturas[i,5],"@E 999,999.99")+"/"+aCulturas[i,6]},;
			{3,y,5,1,3,'C','@!',"("+dIniPla+") a ("+dFinPla+")"},;
			{3,y,6,1,3,'C','@!',"("+dIniCol+") a ("+dFinCol+")"},;
			{3,y,7,1.2,3,'C','@!',transform(aCulturas[i,11],"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 3

Next                  

Return(.t.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_PRODUCAO  �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_PRODUCAO(cCod)
Local i := 0 

aPPA := {;
{3,y+1,0,8.2,1,'C','@!',"PRODU��O DOS �LTIMOS TR�S ANOS/SAFRAS:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 > 35
	FS_RUBRICA(4,0)
Endif

aPPA := {;
{3,y+2,0,1,3,'C','@!',"Ano/Safra (ano plantio/ano colheita)"},{3,y+2,1,1,3,'C','@!',"Cultura"},{3,y+2,2,1,3,'C','@!',"�rea cultivada(ha)"},{3,y+2,3,2,3,'C','@!',"Produ��o/Unidade (sacas, kg, caixas, ton, arrobas)"},{3,y+2,5,1,3,'C','@!',"Pre�o M�dio Recebido por unidade(R$)"},{3,y+2,6,1,3,'C','@!',"Custo Efetivo (R$/h� ou sacas/h�)"},{3,y+2,7,1.2,3,'C','@!',"Estoque livre para  venda (sacas/@)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+4 > 35
	FS_RUBRICA(5,0)
Endif

// PRODU��O DOS �LTIMOS TR�S ANOS/SAFRAS:  
cQuery := "SELECT VMK.VMK_FIMPLA,VMK.VMK_FIMCOL,VMK.VMK_CODCUL," + IIf(FindFunction("OA5600011_Campo_Idioma"),OA5600011_Campo_Idioma(),"VX5_DESCRI") + " AS DESCRI " + ",VMK.VMK_ARECUL,VMK.VMK_PRODUC,VMK.VMK_UNIDAD,VMK.VMK_VUNIVD,VMK.VMK_CUSPRV,VMK.VMK_ESTOQU "
cQuery += "FROM "
cQuery += RetSqlName( "VMK" ) + " VMK " 
cQuery += "LEFT JOIN "+RetSqlName("VX5")+" VX5 ON (VX5.VX5_FILIAL='"+xFilial("VX5")+"' AND VX5.VX5_CHAVE = '003' AND VX5.VX5_CODIGO = VMK.VMK_CODCUL AND  VX5.D_E_L_E_T_=' ') "
cQuery += "WHERE " 
cQuery += "VMK.VMK_FILIAL='"+ xFilial("VMK")+ "' AND VMK.VMK_CODCLI = '"+cCod+"' AND VMK.VMK_FIMCOL < '"+dtos(dDat)+"' AND "
cQuery += "VMK.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMK, .T., .T. )
        
Do While !( cAliasVMK )->( Eof() )
   
   Aadd(aProducao,{( cAliasVMK )->VMK_FIMPLA,( cAliasVMK )->VMK_FIMCOL,( cAliasVMK )->VMK_CODCUL,( cAliasVMK )->DESCRI,( cAliasVMK )->VMK_ARECUL,( cAliasVMK )->VMK_PRODUC,( cAliasVMK )->VMK_UNIDAD,( cAliasVMK )->VMK_VUNIVD,( cAliasVMK )->VMK_CUSPRV,( cAliasVMK )->VMK_ESTOQU})

   dbSelectArea(cAliasVMK)
   ( cAliasVMK )->(dbSkip())
   
Enddo
( cAliasVMK )->( dbCloseArea() )
y := y+3
aPPA := {}
For i := 1 to Len(aProducao)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	dAnoPla := Alltrim(str(year(stod(aProducao[i,1]))))
	dAnoCol := Alltrim(str(year(stod(aProducao[i,2]))))
	aPPA := {;                        
	{3,y+2,0,1,3,'C','@!',dAnoPla+" a "+dAnoCol},;
	{3,y+2,1,1,3,'C','@!',aProducao[i,4]},;
	{3,y+2,2,1,3,'C','@!',transform(aProducao[i,5],"@E 999,999,999.99")},;
	{3,y+2,3,2,3,'C','@!',alltrim(str(aproducao[i,6]))+"/"+aProducao[i,7]},;
	{3,y+2,5,1,3,'C','@!',transform(aProducao[i,8],"@E 99,999.99")},;
	{3,y+2,6,1,3,'C','@!',transform(aProducao[i,9],"@E 999,999,999.99")},;
	{3,y+2,7,1.2,3,'C','@!',transform(aProducao[i,10],"@E 999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 1

Next                  

Return(.t.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_PECUARIA  �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_PECUARIA(cCod)
Local i := 0 

y := y + 3	
aPPA := {;
{3,y+1,0,8.2,1,'C','@!',"PECUARIA"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )

if y+2 > 35
	FS_RUBRICA(4,0)
Endif
y := y + 1	
aPPA := {;
{3,y+1,0,8.2,1,'C','@!',"DE CORTE:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 > 35
	FS_RUBRICA(4,0)
Endif
aPPA := {;
{3,y+2,0,1,2,'C','@!',"N� total cabe�as no rebanho"},;
{3,y+2,1,2,2,'C','@!',"Sistema de Cria��o"},;
{3,y+2,3,1,2,'C','@!',"N� de cabe�as vendidas /ano"},;
{3,y+2,4,2,2,'C','@!',"Peso m�dio/cabe�a vendida  (kg)"},;
{3,y+2,6,1,2,'C','@!',"Pre�o de venda por Kg (R$)"},;
{3,y+2,7,1.2,2,'C','@!',"Custo Anual/cabe�a (R$)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+4 > 35
	FS_RUBRICA(5,0)
Endif
// DE CORTE: 
cQuery := "SELECT VML.VML_QTDANI,VML.VML_SISCRI,VML.VML_ANIVDA,VML.VML_PMDCAB,VML.VML_PRVDKG,VML.VML_CUSANO "
cQuery += "FROM "
cQuery += RetSqlName( "VML" ) + " VML " 
cQuery += "WHERE " 
cQuery += "VML.VML_FILIAL='"+ xFilial("VML")+ "' AND VML.VML_CODCLI = '"+cCod+"' AND VML.VML_ESPECI = '0' AND VML.VML_ANO = '"+Alltrim(str(year(aRet[1])))+"' AND " //VML.VML_INTEGR = '0' AND "
cQuery += "VML.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVML, .T., .T. )
        
Do While !( cAliasVML )->( Eof() )
   
   Aadd(aCorte,{( cAliasVML )->VML_QTDANI,( cAliasVML )->VML_SISCRI,( cAliasVML )->VML_ANIVDA,( cAliasVML )->VML_PMDCAB,( cAliasVML )->VML_PRVDKG,( cAliasVML )->VML_CUSANO})

   dbSelectArea(cAliasVML)
   ( cAliasVML )->(dbSkip())
   
Enddo
( cAliasVML )->( dbCloseArea() )
y := y+4
aPPA := {}
cCorte := ""
For i := 1 to Len(aCorte)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	if aCorte[i,2] == "1"
	   cCorte := "Confinamento"
	Elseif aCorte[i,2] == "2"
	   cCorte := "Extensivo"
    Endif   
	aPPA := {;                        
	{3,y,0,1,2,'C','@!',transform(aCorte[i,1],"@E 99999")},{3,y,1,2,2,'C','@!',cCorte},{3,y,3,1,2,'C','@!',transform(aCorte[i,3],"@E 99999")},{3,y,4,2,2,'C','@!',transform(aCorte[i,4],"@E 9,999.99")},{3,y,6,1,2,'C','@!',transform(aCorte[i,5],"@E 9,999.99")},{3,y,7,1.2,2,'C','@!',transform(aCorte[i,6],"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 1

Next                  

aPPA := {;
{3,y+1,0,8.2,1,'C','@!',"LEITEIRA:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 > 35
	FS_RUBRICA(4,0)
Endif
aPPA := {;
{3,y+2,0,1,2,'C','@!',"Ra�a do animal"},{3,y+2,1,2,2,'C','@!',"N� total cabe�as no rebanho"},{3,y+2,3,1,2,'C','@!',"N� de vacas em lacta��o"},{3,y+2,4,2,2,'C','@!',"Quantidade de litros/cabe�a/dia"},{3,y+2,6,1,2,'C','@!',"Pre�o de venda/litro(R$)"},{3,y+2,7,1.2,2,'C','@!',"Custo de Produ��o/litro (R$)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+2 > 35
	FS_RUBRICA(6,0)
Endif
//  LEITEIRA: 
cQuery := "SELECT VML.VML_RACA,VML.VML_QTDANI,VML.VML_VACLAC,VML.VML_QTDLTD,VML.VML_PMDLIT,VML.VML_CUSPRO "
cQuery += "FROM "
cQuery += RetSqlName( "VML" ) + " VML " 
cQuery += "WHERE " 
cQuery += "VML.VML_FILIAL='"+ xFilial("VML")+ "' AND VML.VML_CODCLI = '"+cCod+"' AND VML.VML_ESPECI = '1' AND VML.VML_ANO = '"+Alltrim(str(year(aRet[1])))+"' AND " //VML.VML_INTEGR = '0' AND "
cQuery += "VML.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVML, .T., .T. )
        
Do While !( cAliasVML )->( Eof() )
   
   Aadd(aLeitera,{( cAliasVML )->VML_RACA,( cAliasVML )->VML_QTDANI,( cAliasVML )->VML_VACLAC,( cAliasVML )->VML_QTDLTD,( cAliasVML )->VML_PMDLIT,( cAliasVML )->VML_CUSPRO})

   dbSelectArea(cAliasVML)
   ( cAliasVML )->(dbSkip())
   
Enddo
( cAliasVML )->( dbCloseArea() )
y := y+4
aPPA := {}
cCorte := ""
For i := 1 to Len(aLeitera)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	aPPA := {;                        
	{3,y,0,1,2,'C','@!',aLeitera[i,1]},{3,y,1,2,2,'C','@!',transform(aLeitera[i,2],"@E 99999")},{3,y,3,1,2,'C','@!',transform(aLeitera[i,3],"@E 99999")},{3,y,4,2,2,'C','@!',transform(aLeitera[i,4],"@E 999")},{3,y,6,1,2,'C','@!',transform(aLeitera[i,5],"@E 99.99")},{3,y,7,1.2,2,'C','@!',transform(aLeitera[i,6],"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 1

Next                  

aPPA := {;
{3,y+1,0,8.2,1,'C','@!',"SUINOCULTURA:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 > 35
	FS_RUBRICA(4,0)
Endif
aPPA := {;
{3,y+2,0,1,3,'C','@!',"N� total cabe�as no rebanho"},{3,y+2,1,1,3,'C','@!',"N� de Matrizes"},{3,y+2,2,1,3,'C','@!',"Valor Unit�rio das Matrizes (R$)"},{3,y+2,3,1,3,'C','@!',"N� de cabe�as vendidas /ano"},{3,y+2,4,1,3,'C','@!',"Peso m�dio cabe�a vendida (Kg)"},{3,y+2,5,1,3,'C','@!',"Pre�o de venda por Kg (R$)"},{3,y+2,6,1.3,3,'C','@!',"Custo Anual/ cabe�a (R$)"},{3,y+2,7.3,0.9,3,'C','@!',"Integra��o (sim/n�o)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+3 > 35
	FS_RUBRICA(8,0)
Endif
//  SUINOCULTURA: 
cQuery := "SELECT VML.VML_QTDANI,VML.VML_QTDMAT,VML.VML_VUNMAT,VML.VML_ANIVDA,VML.VML_PMDCAB,VML.VML_PRVDKG,VML.VML_CUSANO,VML.VML_QTDANI,VML.VML_INTEGR "
cQuery += "FROM "
cQuery += RetSqlName( "VML" ) + " VML " 
cQuery += "WHERE " 
cQuery += "VML.VML_FILIAL='"+ xFilial("VML")+ "' AND VML.VML_CODCLI = '"+cCod+"' AND VML.VML_ESPECI = '2' AND VML.VML_ANO = '"+Alltrim(str(year(aRet[1])))+"' AND VML.VML_INTEGR = '0' AND "
cQuery += "VML.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVML, .T., .T. )

Do While !( cAliasVML )->( Eof() )
   
   Aadd(aSuiClu,{( cAliasVML )->VML_QTDANI,( cAliasVML )->VML_QTDMAT,( cAliasVML )->VML_VUNMAT,( cAliasVML )->VML_ANIVDA,( cAliasVML )->VML_PMDCAB,( cAliasVML )->VML_PRVDKG,( cAliasVML )->VML_CUSANO,( cAliasVML )->VML_QTDANI,( cAliasVML )->VML_INTEGR})

   dbSelectArea(cAliasVML)
   ( cAliasVML )->(dbSkip())
   
Enddo
( cAliasVML )->( dbCloseArea() )
y := y+5
aPPA := {}
cSuiClu := ""    

For i := 1 to Len(aSuiClu)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	if aSuiClu[i,9] == "1"
	   cSuiClu := "Sim"
	Elseif aSuiClu[i,9] == "2"
	   cSuiClu := "N�o"
    Endif   
	aPPA := {;                        
	{3,y,0,1,2,'C','@!',transform(aSuiClu[i,1],"@E 99999")},{3,y,1,1,2,'C','@!',transform(aSuiClu[i,2],"@E 99999")},{3,y,2,1,2,'C','@!',transform(aSuiClu[i,3],"@E 999,999,999.99")},{3,y,3,1,2,'C','@!',transform(aSuiClu[i,4],"@E 99999")},{3,y,4,1,2,'C','@!',transform(aSuiClu[i,5],"@E 9,999.99")},{3,y,5,1,2,'C','@!',transform(aSuiClu[i,6],"@E 9,999.99")},{3,y,6,1.3,2,'C','@!',transform(aSuiClu[i,7],"@E 999,999,999.99")+"/ "+transform(aSuiClu[i,8],"@E 99999")},{3,y,7.3,0.9,2,'C','@!',cSuiClu}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 1

Next                  

aPPA := {;
{3,y+1,0,8.2,1,'C','@!'," OUTRAS ESPECIES:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 > 35
	FS_RUBRICA(4,0)
Endif
aPPA := {;
{3,y+2,0,1,3,'C','@!',"Esp�cie (avicultura, outros)"},{3,y+2,1,1,3,'C','@!',"N� total de animais"},{3,y+2,2,1,3,'C','@!',"N� de animais vendidos/ano"},{3,y+2,3,1,3,'C','@!',"Peso Padr�o(kg)"},{3,y+2,4,1,3,'C','@!',"Pre�o m�dio de venda dos animais (R$)"},{3,y+2,5,2,3,'C','@!',"Custo de produ��o anual (R$)"},{3,y+2,7,1.2,3,'C','@!',"Integra��o (sim/n�o)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+5 > 35
	FS_RUBRICA(7,0)
Endif

//  OUTRAS ESPECIES: 
cQuery := "SELECT VML.VML_ESPECI,VML.VML_QTDANI,VML.VML_ANIVDA,VML.VML_PMDCAB,VML.VML_PRMDVD,VML.VML_CUSANO,VML.VML_INTEGR "
cQuery += "FROM "
cQuery += RetSqlName( "VML" ) + " VML " 
cQuery += "WHERE " 
cQuery += "VML.VML_FILIAL='"+ xFilial("VML")+ "' AND VML.VML_CODCLI = '"+cCod+"' AND NOT VML.VML_ESPECI IN ('0','1','2') AND VML.VML_ANO = '"+Alltrim(str(year(aRet[1])))+"' AND "//VML.VML_INTEGR = '0' AND "
cQuery += "VML.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVML, .T., .T. )
        
Do While !( cAliasVML )->( Eof() )
   
   Aadd(aOutEsp,{( cAliasVML )->VML_ESPECI,( cAliasVML )->VML_QTDANI,( cAliasVML )->VML_ANIVDA,( cAliasVML )->VML_PMDCAB,( cAliasVML )->VML_PRMDVD,( cAliasVML )->VML_CUSANO,( cAliasVML )->VML_INTEGR})

   dbSelectArea(cAliasVML)
   ( cAliasVML )->(dbSkip())
   
Enddo
( cAliasVML )->( dbCloseArea() )
y := y+5
aPPA := {}
cOutEsp := ""    
cEspec  := ""
For i := 1 to Len(aOutEsp)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif
	if aOutEsp[i,1] == "0"
	   cOutEsp := "Corte"
	Elseif aOutEsp[i,1] == "1"
	   cOutEsp := "Leite"
	Elseif aOutEsp[i,1] == "2"
	   cOutEsp := "Suino"
	Elseif aOutEsp[i,1] == "3"
	   cOutEsp := "Aves"
	Elseif aOutEsp[i,1] == "4"
	   cOutEsp := "Equinos"
	Elseif aOutEsp[i,1] == "5"
	   cOutEsp := "Ovinos"
	Elseif aOutEsp[i,1] == "6"
	   cOutEsp := "Caprinos"
	Elseif aOutEsp[i,1] == "7"
	   cOutEsp := "Bufalinos"
	Elseif aOutEsp[i,1] == "8"
	   cOutEsp := "Peixes"
	Elseif aOutEsp[i,1] == "8"
	   cOutEsp := "outros"
    Endif   

	if aOutEsp[i,7] == "1"
	   cEspec := "Sim"
	Elseif aOutEsp[i,7] == "2"
	   cEspec := "N�o"
    Endif   

	aPPA := {;                        
	{3,y,0,1,1,'C','@!',cOutEsp},{3,y,1,1,1,'C','@!',transform(aOutEsp[i,2],"@E 99999")},{3,y,2,1,1,'C','@!',transform(aOutEsp[i,3],"@E 99999")},{3,y,3,1,1,'C','@!',transform(aOutEsp[i,4],"@E 9,999.99")},{3,y,4,1,1,'C','@!',transform(aOutEsp[i,5],"@E 999,999,999.99")},{3,y,5,2,1,'C','@!',transform(aOutEsp[i,6],"@E 999,999,999.99")},{3,y,7,1.2,1,'C','@!',cEspec}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 1

Next

aPPA := {;
{3,y,0,8.2,1,'C','@!'," INTEGRA��O:"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+1 > 35
	FS_RUBRICA(3,0)
Endif
aPPA := {;
{3,y+1,0,2,2,'C','@!',"Empresa Contratante"},{3,y+1,2,2,2,'C','@!',"Esp�cie animal"},{3,y+1,4,2,2,'C','@!',"Qtde de animais entregue por ano"},{3,y+1,6,2.2,2,'C','@!',"Valor L�quido Recebido (R$)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+2 > 35
	FS_RUBRICA(4,0)
Endif

// INTEGRA��O: : 
cQuery := "SELECT VMT.VMT_CONTRA,VMT.VMT_ESPECI,VMT.VMT_QTDANI,VMT.VMT_VALLIQ "
cQuery += "FROM "
cQuery += RetSqlName( "VMT" ) + " VMT " 
cQuery += "WHERE " 
cQuery += "VMT.VMT_FILIAL='"+ xFilial("VMT")+ "' AND VMT.VMT_CODCLI = '"+cCod+"' AND "
cQuery += "VMT.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMT, .T., .T. )
        
Do While !( cAliasVMT )->( Eof() )
   
   Aadd(aIntegr,{( cAliasVMT )->VMT_CONTRA,( cAliasVMT )->VMT_ESPECI,( cAliasVMT )->VMT_QTDANI,( cAliasVMT )->VMT_VALLIQ})

   dbSelectArea(cAliasVMT)
   ( cAliasVMT )->(dbSkip())
   
Enddo
( cAliasVMT )->( dbCloseArea() )
y := y+3
aPPA := {}
cEspec  := ""
For i := 1 to Len(aIntegr)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif

	if aIntegr[i,2] == "1"
	   cEspec := "Sim"
	Elseif aIntegr[i,2] == "2"
	   cEspec := "N�o"
    Endif   

	aPPA := {;                        
	{3,y,0,2,1,'C','@!',aIntegr[i,1]},;
	{3,y,2,2,1,'C','@!',cEspec},;
	{3,y,4,2,1,'C','@!',transform(aIntegr[i,3],"@E 999999")},;
	{3,y,6,2.2,1,'C','@!',transform(aIntegr[i,4],"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 1

Next                  

Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_PRESTSRV  �Autor  �                 � Data �  25/06/13  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_PRESTSRV(cCod)
Local i := 0

aPPA := {;
{3,y+1,0,8.2,1,'C','@!',"PRESTA��O DE SERVI�OS"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
if y+2 > 35
	FS_RUBRICA(3,0)
Endif
aPPA := {;
{3,y+2,0,2,2,'C','@!',"Nome do Contratante"},;
{3,y+2,2,1,2,'C','@!',"Tipo de Servi�o"},;
{3,y+2,3,1,2,'C','@!',"�rea (ha)"},;
{3,y+2,4,1,2,'C','@!',"Qtde. Horas Trabalhadas"},;
{3,y+2,5,1,2,'C','@!',"Regi�o (Munic�pio/UF)"},;
{3,y+2,6,1,2,'C','@!',"Receita Total Anual (R$, sacas, outras)"},;
{3,y+2,7,1.2,2,'C','@!',"Custo Anual(R$)"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
if y+6 > 35
	FS_RUBRICA(6,0)
Endif

cQuery := "SELECT VMQ.VMQ_NOMCON,VMP.VMP_TIPPRS,VMQ.VMQ_AREA,VMQ.VMQ_HORAS,VMQ.VMQ_CIDADE,VMQ.VMQ_RECTTA,VMQ.VMQ_CUSTTA "
cQuery += "FROM "
cQuery += RetSqlName( "VMQ" ) + " VMQ " 
cQuery += "INNER JOIN "+RetSqlName("VMP")+" VMP ON (VMP.VMP_FILIAL='"+xFilial("VMP")+"' AND VMP.VMP_CODCLI = VMQ.VMQ_CODCLI AND VMQ.VMQ_PAISEQ = VMP.VMP_CODSEQ AND VMP.D_E_L_E_T_=' ') "
cQuery += "WHERE " 
cQuery += "VMQ.VMQ_FILIAL='"+ xFilial("VMQ")+ "' AND VMQ.VMQ_CODCLI = '"+cCod+"' AND "
cQuery += "VMQ.D_E_L_E_T_=' '"                                             

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMQ, .T., .T. )
        
Do While !( cAliasVMQ )->( Eof() )
   
   Aadd(aPresSrv,{( cAliasVMQ )->VMQ_NOMCON,( cAliasVMQ )->VMP_TIPPRS,( cAliasVMQ )->VMQ_AREA,( cAliasVMQ )->VMQ_HORAS,( cAliasVMQ )->VMQ_CIDADE,( cAliasVMQ )->VMQ_RECTTA,( cAliasVMQ )->VMQ_CUSTTA})

   dbSelectArea(cAliasVMQ)
   ( cAliasVMQ )->(dbSkip())
   
Enddo
( cAliasVMQ )->( dbCloseArea() )
y := y+4
aPPA := {}
cEspec  := ""
For i := 1 to Len(aPresSrv)

	if y >= 35
		FS_RUBRICA(3,1)
	Endif

	if aPresSrv[i,2] == "1"
	   cEspec := "Sim"
	Elseif aPresSrv[i,2] == "2"
	   cEspec := "N�o"
    Endif   

	aPPA := {;                        
	{3,y,0,2,1,'C','@!',aPresSrv[i,1]},{3,y,2,1,1,'C','@!',cEspec},{3,y,3,1,1,'C','@!',transform(aPresSrv[i,3],"@E 9,999.99")},{3,y,4,1,1,'C','@!',transform(aPresSrv[i,4],"@E 999999:99")},{3,y,5,1,1,'C','@!',aPresSrv[i,5]},{3,y,6,1,1,'C','@!',transform(aPresSrv[i,6],"@E 999,999,999.99")},{3,y,7,1.2,1,'C','@!',transform(aPresSrv[i,7],"@E 999,999,999.99")}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 1

Next                  

Return(.t.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_PATRIM    �Autor  �                 � Data �  01/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_PATRIM(cCod)

	cQuery := "SELECT SUM(VMJ_AREPRO) AS AREPRO,SUM(VMJ_AREARR) AS AREARR "
	cQuery += "FROM "
	cQuery += RetSqlName( "VMJ" ) + " VMJ "
	cQuery += "WHERE "
	cQuery += "VMJ.VMJ_FILIAL='" + xFilial("VMJ") + "' AND VMJ.VMJ_CODCLI = '" + cCod + "' AND "
	cQuery += "VMJ.D_E_L_E_T_=' '" 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVMJ, .T., .T. )

	if y + 2 > 35
		FS_RUBRICA(1,1)
	Endif

	aPPA := {{3,y,0,8.2,1,'C','@!',"PATRIM�NIO"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
	y++

	aPPA := {;
	{3,y,0,8.2,1,'C','@!',"Total de ha pr�prios: " + transform(( cAliasVMJ )->AREPRO,"@E 999,999,999.99") + " Total de ha arrendados: " + transform(( cAliasVMJ )->AREARR,"@E 999,999,999.99")}}
	( cAliasVMJ )->( dbCloseArea() )
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_IMVRURA   �Autor  �                 � Data �  01/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_IMVRURA(cCod)
	Local i	

	// Imoveis Rurais
	cQuery := "SELECT VP6.VP6_DESBEM,VP6.VP6_AREA,VP6.VP6_ARCULT,VP6.VP6_ARPAST,VP6.VP6_TITPRO,VP6.VP6_MATRIC,VP6.VP6_CARTOR,VP6.VP6_SITUAC,VP6.VP6_FAVORE,VP6.VP6_VALBEM "
	cQuery += "FROM "
	cQuery += RetSqlName( "VP6" ) + " VP6 " 
	cQuery += "WHERE " 
	cQuery += "VP6.VP6_FILIAL='" + xFilial("VP6") + "' AND VP6.VP6_CODCLI = '" + cCod + "' AND VP6.VP6_TIPIMO = '1' AND "
	cQuery += "VP6.D_E_L_E_T_=' '" 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVP6, .T., .T. )

	cSituac := ""
	Do While !( cAliasVP6 )->( Eof() )

		if ( cAliasVP6 )->VP6_SITUAC == "0"
			cSituac := "Arrendado"
		Elseif ( cAliasVP6 )->VP6_SITUAC == "1"
			cSituac := "Livre"
		Elseif ( cAliasVP6 )->VP6_SITUAC == "2"
			cSituac := "Onerado"
		Else
			cSituac := ""
		Endif 

		Aadd(aImoveis,	{AllTrim(( cAliasVP6 )->VP6_DESBEM),;
		( cAliasVP6 )->VP6_AREA,;
		( cAliasVP6 )->VP6_ARCULT,;
		( cAliasVP6 )->VP6_ARPAST,; 
		AllTrim(( cAliasVP6 )->VP6_TITPRO),;
		AllTrim(( cAliasVP6 )->VP6_MATRIC),;
		AllTrim(( cAliasVP6 )->VP6_CARTOR),;
		cSituac,;
		AllTrim(( cAliasVP6 )->VP6_FAVORE),;
		( cAliasVP6 )->VP6_VALBEM})

		dbSelectArea(cAliasVP6)
		( cAliasVP6 )->(dbSkip())

	Enddo
	( cAliasVP6 )->( dbCloseArea() )

	if y + 7 > 35
		FS_RUBRICA(1,1)
	Endif

	aPPA := {{3,y,0,8.2,1,'C','@!',"IM�VEIS RURAIS:"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
	y++

	aPPA := {{3,y,0,8.2,1,'C','@!',"T�tulo de Propriedade: escritura, posse, cess�o de direitos, com contrato de compra e venda, formal de partilha, etc."}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

	aPPA := {;
	{3,y,0.0,1.0,3,'C','@!',"Descri��o (Faz., Sitio)"},;
	{3,y,1.0,0.6,3,'C','@!',"�rea Total (ha, alq.)"},;
	{3,y,1.6,0.6,3,'C','@!',"�rea Culti- vada (ha)"},;
	{3,y,2.2,0.6,3,'C','@!',"�rea de Pastagem (ha)"},;
	{3,y,3.4,1.0,3,'C','@!',"* T�tulo de propriedade"},;
	{3,y,4.4,0.6,3,'C','@!',"N� das Matr�culas"},;
	{3,y,5.0,1.0,3,'C','@!',"Localiza��o (Munic�pio/UF)"},;
	{3,y,6.0,0.5,3,'C','@!',"L/O"},;
	{3,y,6.5,0.7,3,'C','@!',"Favorecido"},;
	{3,y,7.2,1.0,3,'C','@!',"Valor de Mercado (R$)"};
	}

	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,"Top" )
	y += 3

	aPPA := {}
	For i := 1 to Len(aImoveis)
		if y > 35
			FS_RUBRICA(1,1)
		Endif
		aPPA := {;
		{3,y,0.0,1.0,2,'C','@!',aImoveis[i,1]},;
		{3,y,1.0,0.6,2,'C','@!',transform(aImoveis[i,2],"@E 999,999.99")},;
		{3,y,1.6,0.6,2,'C','@!',transform(aImoveis[i,3],"@E 999,999.99")},;
		{3,y,2.2,0.6,2,'C','@!',transform(aImoveis[i,4],"@E 999,999.99")},;
		{3,y,3.4,1.0,2,'C','@!',aImoveis[i,5]},;
		{3,y,4.4,0.6,2,'C','@!',aImoveis[i,6]},;
		{3,y,5.0,1.0,2,'C','@!',aImoveis[i,7]},;
		{3,y,6.0,0.5,2,'C','@!',aImoveis[i,8]},;
		{3,y,6.5,0.7,2,'C','@!',aImoveis[i,9]},;
		{3,y,7.2,1.0,2,'C','@!',transform(aImoveis[i,10],"@E 999,999,999.99")}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18, "Top" )
		y += 2
	Next
	y++

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_IMVURBA   �Autor  �                 � Data �  01/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_IMVURBA(cCod)
	Local i	

	// Imoveis Urbanos
	cQuery := "SELECT VP6.VP6_DESBEM,VP6.VP6_AREA,VP6.VP6_MATRIC,VP6.VP6_CARTOR,VP6.VP6_SITUAC,VP6.VP6_FAVORE,VP6.VP6_VALBEM "
	cQuery += "FROM "
	cQuery += RetSqlName( "VP6" ) + " VP6 " 
	cQuery += "WHERE " 
	cQuery += "VP6.VP6_FILIAL='" + xFilial("VP6") + "' AND VP6.VP6_CODCLI = '" + cCod + "' AND VP6.VP6_TIPIMO = '2' AND "
	cQuery += "VP6.D_E_L_E_T_=' '" 

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasVP6, .T., .T. )

	Do While !( cAliasVP6 )->( Eof() )
		if ( cAliasVP6 )->VP6_SITUAC == "0"
			cSituac := "Arrendado"
		Elseif ( cAliasVP6 )->VP6_SITUAC == "1"
			cSituac := "Livre"
		Elseif ( cAliasVP6 )->VP6_SITUAC == "2"
			cSituac := "Onerado"
		Else
			cSituac := ""
		Endif 

		Aadd(aImoveisU,{;
		AllTrim(( cAliasVP6 )->VP6_DESBEM),;
		( cAliasVP6 )->VP6_AREA,;
		( cAliasVP6 )->VP6_MATRIC,;
		AllTrim(( cAliasVP6 )->VP6_CARTOR),;
		cSituac,;
		AllTrim(( cAliasVP6 )->VP6_FAVORE),;
		( cAliasVP6 )->VP6_VALBEM})

		dbSelectArea(cAliasVP6)
		( cAliasVP6 )->(dbSkip())
	Enddo
	( cAliasVP6 )->( dbCloseArea() )

	if y + 5 > 35
		FS_RUBRICA(1,1)
	Endif

	aPPA := {{3,y,0,8.2,1,'C','@!',"IM�VEIS URBANOS:"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18,,oVerdanaN )
	y++

	aPPA := {{3,y,0,8.2,1,'C','@!',"No quadro abaixo relacionar apenas os im�veis escriturados no nome do cliente, comprovados pela matr�cula:"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
	y++

	aPPA := {;
	{3,y,0,1.5,2,'C','@!',"Descri��o(Terreno, casa, "},;
	{3,y,1.5,1,2,'C','@!',"�rea Total(m2)"},;
	{3,y,2.5,1,2,'C','@!',"N� das Matr�culas"},;
	{3,y,3.5,1.5,2,'C','@!',"Cart�rio de Registro(Munic�pio/UF)"},;
	{3,y,5,1,2,'C','@!',"L/O"},;
	{3,y,6,1,2,'C','@!',"Favorecido"},;
	{3,y,7,1.2,2,'C','@!',"Valor de Mercado (R$)"}}
	nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18, "Top" )
	y += 2


	aPPA := {}
	For i := 1 to Len(aImoveisU)
		if y > 35
			FS_RUBRICA(1,1)
		Endif
		aPPA := {;
		{3,y,0,1.5,1,'C','@!',aImoveisU[i,1]},;
		{3,y,1.5,1,1,'C','@!',transform(aImoveisU[i,2],"@E 99,999.99")},;
		{3,y,2.5,1,1,'C','@!',aImoveisU[i,3]},;
		{3,y,3.5,1.5,1,'C','@!',aImoveisU[i,4]},;
		{3,y,5,1,1,'C','@!',aImoveisU[i,5]},;
		{3,y,6,1,1,'C','@!',aImoveisU[i,6]},;
		{3,y,7,1.2,1,'C','@!',transform(aImoveisU[i,7],"@E 999,999,999.99")}}
		nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
		y++
	Next
	y++ 

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FS_RUBRICA   �Autor  �                 � Data �  01/08/18  ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ficha Cadastral                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FS_RUBRICA(nSoma,nIniY)

aPPA := {{3,y+nSoma,0,2,1,'C','@!',"Rubrica:________________"}}
nMax := FGX_MntTab(oPrinter, aPPA, 20, 10,,70,18 )
y := nIniY
oPrinter:StartPage()

Return