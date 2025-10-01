#INCLUDE "CALCULOSDI.CH"

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������Ŀ��
���Fun��o    �CalculoSDI� Autor � Tatiane Matias        � Data �08/11/2007     ���
������������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula Salario Diario Integrado                                ���
������������������������������������������������������������������������������Ĵ��
���Sintaxe   |< Vide Parametros Formais >                   			       ���
������������������������������������������������������������������������������Ĵ��
���Uso       � GPEA010,CSAM010                                                 ���
������������������������������������������������������������������������������Ĵ��
���			ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.			       ���
������������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS      �  Motivo da Alteracao                     ���
������������������������������������������������������������������������������Ĵ��
���Natie       �30/06/08�xxxxxx     �Atualiza objeto da transferencia          ��� 
���Ademar Jr.  �21/10/08�154308     �-Verifica se alguns campos irao estourar  ��� 
���            �        �           �antes de grava-los no SRA.                ���  
���Claudinei S.�10/05/12�TEZBTJ     �Alterada CalculoSDI para atualizacao de   ��� 
���            �        �           �todos os campos salariais no CSAM010 MEX. ��� 
���Jonathan Glz�27/11/15�PCREQ-7943 �Localizacion GPE CHI p/v12                ���
���            �        �           �Se agrega la funcion stSueldo(), la cual  ���
���            �        �           �permite actualizar el campo RA_ANTEAUM con���
���            �        �           �el valor que tenia RA_SALARIO cuando haya ���
���            �        �           �una modificacion al salario.              ���
���Alf. Medrano�07/09/16�PDR_SER_MI002-8�Merge de 12.1.13                      ���
���Alf. Medrano�27/10/18�DMINA-4237 �Se considera dejar en ceros para los rein-���
���            �        �           �gresos el campo RA_PARVAR                 ���
�������������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function CalculoSDI()

Local lRetorno  := .T.      
Local cPeriodo  := ""
Local cNumPagto := ""
Local nModSal   := 0
Local dDesp		:= CTOD("//")

Local NAUX01 := GetValType('N')
Local NAUX02 := GetValType('N')
Local NAUX03 := getValType('N')
Local NAUX04 := GetValType('N')
Local NAUX05 := GetValType('N')
Local NAUX06 := GetValType('N')

//������������������������������������������������������������Ŀ
//�Quando chamada vem  da transferencia, deve atualizar o      �
//�objeto                                                      �
//��������������������������������������������������������������*/
Local lTransfer	:= ( Type("nOpcaoa180")  <> "U" .and. nOpcaoa180 = 4  ) 
Local nPosSalmes	:= 0
Local nPosSalDiaa	:= 0
Local nPosSaHhora	:= 0
Local nPosSalInta	:= 0
Local nPosSalIvca	:= 0
Local nPosSalInsa	:= 0 
Local nPosSaldia 	:= 0
Local nPosSalHor	:= 0
Local nPosParfij	:= 0
Local nPosSalIns	:= 0
Local nPosSAlint	:= 0
Local nPosSAlivc	:= 0
Local lCsa			:= .F.
Local lExploded := .F.	//# Indica se houve estouro de campo
Local cAuxiliar := ""
Local NSALDIA       := 0
Local NSALMES       := 0
Local NSALHORA      := 0
	
Begin Sequence

     IF ( AbortProc() )

          Break

     EndIF
    

//�������������������������������������������������������������Ŀ
//�Se for chamado pelo reajuste por tabela salarial e for Mexico�
//�seta as variaveis de memoria                                 �
//���������������������������������������������������������������*/
	If IsInCallStack("CSAM010") .AND. cPaisLoc == "MEX"
	
		lCsa := .T.
		
		SETMEMVAR("RA_CVEZON" ,SRA->RA_CVEZON,.T.)
		SETMEMVAR("RA_PROCES" ,SRA->RA_PROCES,.T.)
		SETMEMVAR("RA_DTREC"  ,SRA->RA_DTREC,.T.)
		SETMEMVAR("RA_FECREI" ,SRA->RA_FECREI,.T.)
		SETMEMVAR("RA_ADMISSA",SRA->RA_ADMISSA,.T.)
		SETMEMVAR("RA_SALARIO",nNovoSal,.T.)
		SETMEMVAR("RA_CATFUNC",SRA->RA_CATFUNC,.T.)  
		SETMEMVAR("RA_SALMES" ,nNovoSal,.T.)
		SETMEMVAR("RA_SALMESA",SRA->RA_SALARIO,.T.) 
		
	EndIf

    NAUX01:=FPOSTAB("S006","A","=",4)

    NSALMINDF := IF (NAUX01>0, FTABELA("S006",NAUX01,5), 0)

    NAUX01:=FPOSTAB("S006",GETMEMVAR("RA_CVEZON"),"=",4)

    NSALMIN := IF (NAUX01>0, FTABELA("S006",NAUX01,5), 0)

    NTOPEINTE:=NSALMINDF*25

	dbSelectArea("RCJ")
	dbSetOrder(1)
	RCJ->( dbSeek( xFilial("RCJ") + GETMEMVAR("RA_PROCES") ) )
                           
	fGetLastPer(@cPeriodo, @cNumPagto, GETMEMVAR("RA_PROCES"), fGetRotOrdinar(),.F.,.T.)
	dbSelectArea("RCH")
	dbSetOrder(4)
	RCH->( dbSeek( xFilial("RCH") + GETMEMVAR("RA_PROCES") + fGetRotOrdinar() + cPeriodo + cNumPagto) )

    NTOPEIVCV:=NSALMINDF*RCJ->RCJ_TIVCV

    DFECHA01:=GETMEMVAR("RA_DTREC")

    IF ( EMPTY(DFECHA01)==.F. )

        DFECHA04:=DFECHA01

    EndIF

    DFECHA02:=GETMEMVAR("RA_FECREI")

    IF (( EMPTY(DFECHA01)==.T. ).AND.( EMPTY(DFECHA02)==.F. ))

        DFECHA04:=DFECHA02

    EndIF

    DFECHA03:=GETMEMVAR("RA_ADMISSA")

    IF (( EMPTY(DFECHA01)==.T. ).AND.( EMPTY(DFECHA02)==.T. ))

        DFECHA04:=DFECHA03

    EndIF

    DFECHAANI:=CTOD(STRZERO(DAY(DFECHA04)) + "/" + STRZERO(MONTH(DFECHA04)) + "/" + RCH->RCH_ANO)

    IF ( STR(YEAR(DFECHA04),4)==RCH->RCH_ANO )

        DFECHAANI:=CTOD(STRZERO( DAY(DFECHA04), 2)  + "/" + STRZERO( MONTH(DFECHA04), 2) + "/" +STRZERO(  VAL( RCH->RCH_ANO )+ 1 , 4) )

    EndIF

    NANTIGTOT:=((RCH->RCH_DTFIM - DFECHA04) + 1) / 365

    IF ( NMODSAL==0 )

        NMODSAL:=1

        IF ( TYPE("INCLUI")=="U" )

            INCLUI:=.F.

        EndIF

        IF ( !INCLUI ) .or. lTransfer 

            SETMEMVAR("RA_SALMESA",SRA->RA_SALMES)

            SETMEMVAR("RA_SALDIAA",SRA->RA_SALDIA)

            SETMEMVAR("RA_SALHORA",SRA->RA_SALHOR)

            SETMEMVAR("RA_SALINTA",SRA->RA_SALINT)

            SETMEMVAR("RA_SALIVCA",SRA->RA_SALIVC)

            SETMEMVAR("RA_SALINSA",SRA->RA_SALINS)
             
			 If  GETMEMVAR("RA_CATFUNC") == SRA->RA_CATFUNC
				 SETMEMVAR("RA_CATFUNC",SRA->RA_CATFUNC)
			 Endif
		
            If lTransfer 
            	nPosSalmes	:= GDfieldPos("RA_SALMESA",oGetSRA2:aHeader ) 
				nPosSalDiaa	:= GDfieldPos("RA_SALDIAA",oGetSRA2:aHeader ) 
				nPosSaHhora	:= GDfieldPos("RA_SALHORA",oGetSRA2:aHeader ) 
				nPosSalInta	:= GDfieldPos("RA_SALINTA",oGetSRA2:aHeader ) 
				nPosSalIvca	:= GDfieldPos("RA_SALIVCA",oGetSRA2:aHeader ) 
				nPosSalInsa	:= GDfieldPos("RA_SALINSA",oGetSRA2:aHeader )
				If nPosSalmes	> 0 
	       			oGetSRA2:aCols[oGetSRA2:nAt , nPosSalmes ]  := SRA->RA_SALMES
	       		Endif 	
	       		If nPosSalDiaa > 0 
	       			oGetSRA2:aCols[oGetSRA2:nAt , nPosSalDiaa ] := SRA->RA_SALDIA
	       		Endif 	
				If nPosSaHhora	> 0 
	       			oGetSRA2:aCols[oGetSRA2:nAt , nPosSaHhora ] := SRA->RA_SALHOR
	       		Endif 
	       		If 	nPosSalInta > 0 
       				oGetSRA2:aCols[oGetSRA2:nAt , nPosSalInta ] := SRA->RA_SALINT
       			Endif 	
				If  nPosSalIvca  > 0    				
	       			oGetSRA2:aCols[oGetSRA2:nAt , nPosSalIvca ] := SRA->RA_SALIVC
				Endif 
				If nPosSalInsa > 0 	       			
    	   			oGetSRA2:aCols[oGetSRA2:nAt , nPosSalInsa ] := SRA->RA_SALINS 
    	   		Endif     	   			
            Endif 
        EndIF
    EndIF

    IF ( GETMEMVAR("RA_CATFUNC")$"A*C*E*I*M*P" )

        NSALMES:=GETMEMVAR("RA_SALARIO")

        NSALDIA:=NSALMES/RCJ->RCJ_FACCON

        NSALHORA:=NSALDIA/8

    EndIF

    IF ( GETMEMVAR("RA_CATFUNC")$"D*S*T" )

        NSALDIA:=GETMEMVAR("RA_SALARIO")

        NSALMES:=NSALDIA*RCJ->RCJ_FACCON

        NSALHORA:=NSALDIA/8

    EndIF

    IF ( GETMEMVAR("RA_CATFUNC")$"H*G" )

        NSALHORA:=GETMEMVAR("RA_SALARIO")

        NSALDIA:=NSALHORA*8

        NSALMES:=NSALDIA*RCJ->RCJ_FACCON

    EndIF

    IF ( (NSALDIA < NSALMIN) .AND. (NSALDIA<>0) )

        NSALDIA:=NSALMIN

        NSALMES:=NSALDIA * RCJ->RCJ_FACCON

        NSALHORA:=NSALDIA / 8

    EndIF
			
    //# Verifica se alguns campos irao estourar no calculo
    If !PictureIsExploded("RA_SALDIA",NSALDIA)
    	SETMEMVAR("RA_SALDIA",NSALDIA)
    Else
    	lExploded := .T.
    	cAuxiliar := Alltrim(GetSx3Cache("RA_SALDIA","X3_TITSPA")) + " / "
    EndIf

    If !PictureIsExploded("RA_SALMES",NSALMES)
	    SETMEMVAR("RA_SALMES",NSALMES)
    Else
    	lExploded := .T.
    	cAuxiliar += Alltrim(GetSx3Cache("RA_SALMES","X3_TITSPA")) + " / "
    EndIf

    If !PictureIsExploded("RA_SALHOR",NSALHORA)
	    SETMEMVAR("RA_SALHOR",NSALHORA)
    Else
    	lExploded := .T.
    	cAuxiliar += Alltrim(GetSx3Cache("RA_SALHOR","X3_TITSPA"))
    EndIf
    
    If lExploded
    	lRetorno  := .F.
    	/*
    	MsgAlert( "Devido ao valor digitado ser muito grande, o(s) campo(s) "+cAuxiliar+" estouraram. Favor digitar um valor menor.",;
			  	  "ATEN��O !!!")
		*/
    	MsgAlert( OEMTOANSI(STR0002)+cAuxiliar+OEMTOANSI(STR0003),;
			  	  OEMTOANSI(STR0001) )
    EndIf
    
    NAUX01:=FPOSTAB("S008",GETMEMVAR("RA_PROCES"), "=", 4, NANTIGTOT, "<=", 5)

     If cPaisLoc $ "MEX" .And. !Empty(GETMEMVAR("RA_FECREI"))
    	DBSelectArea("SRA")
    	DBSetOrder(1)//RA_FILIAL + RA_MAT
    	If SRA->(MsSeek(xFilial("SRA") + GETMEMVAR("RA_MAT")))
    		dDesp := SRA->RA_DEMISSAO
    		If !Empty(dDesp)
    			NAUX06 := 0
    			SETMEMVAR("RA_PARVAR",NAUX06)
		    EndIf
    	EndIf
    EndIf
    IF ( NSALDIA<>0 )

        NAUX05:=(IF (NAUX01>0, FTABELA("S008",NAUX01,7), 0) * NSALDIA)

        SETMEMVAR("RA_PARFIJ",NAUX05)

        NAUX02:=NAUX05+GETMEMVAR("RA_PARVAR")

    EndIF
    
	If lTransfer
		nPosSaldia 	:= GDfieldPos("RA_SALDIA",oGetSRA2:aHeader )
		nPosSalmes	:= GDfieldPos("RA_SALMES",oGetSRA2:aHeader )
		nPosSalHor	:= GDfieldPos("RA_SALHOR",oGetSRA2:aHeader )
		nPosParfij	:= GDfieldPos("RA_PARFIJ",oGetSRA2:aHeader )
		If nPosSaldia >0 
			oGetSRA2:aCols[oGetSRA2:nAt , nPosSaldia ]  := NSALDIA
		Endif 	
		If nPosSalmes >0 
			oGetSRA2:aCols[oGetSRA2:nAt , nPosSalmes ]  := NSALMES
		Endif 	
		If nPosSalHor > 0 
			oGetSRA2:aCols[oGetSRA2:nAt , nPosSalHor ]  := NSALHORA
		Endif 	
		If 	nPosParfij > 0 
			oGetSRA2:aCols[oGetSRA2:nAt , nPosParfij ]  := NAUX05
		Endif 	
	Endif 
	
    IF ( NSALDIA==0 )

        NAUX02:=IF (GETMEMVAR("RA_PARVAR") == 0, GETMEMVAR("RCJ_SDIVIN"), GETMEMVAR("RA_PARVAR"))

    EndIF
  
	SETMEMVAR("RA_SALINS",NAUX02)

    NAUX03:=IF (NAUX02<=NTOPEINTE,NAUX02,NTOPEINTE)

    SETMEMVAR("RA_SALINT",NAUX03)

    NAUX04:=IF (NAUX03 <= NTOPEIVCV, NAUX03, NTOPEIVCV)

    SETMEMVAR("RA_SALIVC",NAUX04)

	If lTransfer 
	
		nPosSalIns	:= GDfieldPos("RA_SALINS",oGetSRA2:aHeader )
		nPosSAlint	:= GDfieldPos("RA_SALINT",oGetSRA2:aHeader )
		nPosSAlivc	:= GDfieldPos("RA_SALIVC",oGetSRA2:aHeader )
		If nPosSalIns >0 
			oGetSRA2:aCols[oGetSRA2:nAt , nPosSalIns ]  := NAUX02
		Endif 	
		If nPosSAlint >0 
			oGetSRA2:aCols[oGetSRA2:nAt , nPosSAlint ]  := NAUX03
		Endif 	
		If nPosSAlivc >0 
			oGetSRA2:aCols[oGetSRA2:nAt , nPosSAlivc ]  := NAUX04 
		Endif 	
		
		oGetSRA2:Refresh()
	Endif 

	If lCsa = .T.
		nNsaldia  := NSALDIA
		nNsaldiaa := SRA->RA_SALDIA
		nNsalmes  := NSALMES
		nNsalmesa := SRA->RA_SALMES
		nNsalhor  := NSALHORA
		nNsalhora := SRA->RA_SALHOR
		nNsalint  := NAUX03   
	    nNsalinta := SRA->RA_SALINT
	    nNsalivc  := NAUX04
		nNsalivca := SRA->RA_SALIVC
		nNsalins  := NAUX02
		nNsalinsa := SRA->RA_SALINS
		nNparvar  := SRA->RA_PARVAR
		nNparfij  := NAUX05
	Endif

End Sequence

Return lRetorno

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � stSueldo � Autor � Jonathan Gonzalez     � Data �03/03/2015���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cuando haya una modificacion al salario, actualiza el campo���
���          � RA_ANTEAUM con el valor que tenia RA_SALARIO.              ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   | stSueldo(nOpc)                                             ���
�������������������������������������������������������������������������Ĵ��
���Uso       � GPEA010 - RA_SALARIO (VALID)                               ���
�������������������������������������������������������������������������Ĵ��
���			    ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.		    ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao 					    ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user function stSueldo(nOpc)
	Local aArea	:= GetArea()
	Local cFilSRA	:= xFilial("SRA")
	Private nSalario

		If cPaisLoc == "CHI"
			If nOpc == 4
				dbSelectArea('SRA')
				SRA->(dbSetOrder(1)) //FILIAL + Matricula
				If SRA->(dbseek(cFilSRA + GETMEMVAR("RA_MAT")))
					nSalario := SRA->RA_SALARIO
				EndIf
				SRA->(dbCloseArea())

				If nSalario <> GETMEMVAR("RA_SALARIO")
					SETMEMVAR("RA_ANTEAUM",nSalario,.T.)
				EndIF
			EndIf
		EndIf

	RestArea(aArea)
return .T.
