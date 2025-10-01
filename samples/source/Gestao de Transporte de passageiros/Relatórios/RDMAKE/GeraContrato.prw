#Include 'Protheus.ch'

/*/{Protheus.doc} GeraDoc()
    (Função criada para geração de contrato)
    @type  User Function
    @author Silas.Gomes
    @since 05/10/2023
    /*/
User Function GeraDoc()

    Local aParc     as array
    Local cCpfCnpj  as character
    Local cData     as character
    Local cHTMLDt   as character
    Local cPathhmtl as character
    Local cArqhtml  as character
    Local cHTMLSrc  as character
    Local cItinerar as character
    Local cPath     as character
    Local cVigencia as character
    Local cPreConv  as character
    Local cPreExtra as character
    Local lRet      as logical
    Local lCliente  as logical
    Local nTotProd  as numeric
    Local oHTMLBody as object

    aParc     := {}
    cCpfCnpj  := ""
    cData     := ""
    cFile     := ""
    cHTMLDt   := ""
    cPathhmtl := Alltrim(SuperGetMv( "MV_DIRDOC", .F., "\HTML\" ) )
    cArqhtml  := ""
    cHTMLSrc  := ""
    cItinerar := ""
    cPath     := ""
    cVigencia := ""
    cPreConv  := ""
    cPreExtra := ""
    lRet      := .T.
    lCliente  := .T.
    nTotProd  := 0
    oHTMLBody := Nil

    cData += cValToChar(Day(dDataBase))
    cData += " de "
    cData += MesExtenso(dDataBase)
    cData += " de "
    cData += cValToChar(Year(dDataBase))

    If FWIsInCallStack('G600REL')

        cArqhtml   := Alltrim(SuperGetMv( "MV_MODCON", .F., "ViagensEspec.html" )  )
        cHTMLSrc   := cPathhmtl + cArqhtml      

        If !Empty(G6R->G6R_SA1COD)
	    	SA1->(DbSetOrder(1))
	    	SA1->(DbSeek(xFilial("SA1")+G6R->G6R_SA1COD+G6R->G6R_SA1LOJ))
	    	lCliente := .T.
	    Else
	    	SUS->(DbSetOrder(1))
	    	SUS->(DbSeek(xFilial("SUS")+G6R->G6R_SUSCOD+G6R->G6R_SUSLOJ))
	    	lCliente := .F.
	    Endif

        If lCliente
	    	cCpfCnpj := AllTrim(SA1->A1_CGC)
	    Else
	    	cCpfCnpj := AllTrim(SUS->US_CGC)
	    Endif

        nTotProd := G6R->G6R_VALACO

        If File(cHTMLSrc)

            oHTMLBody:= TWFHTML():New(cHTMLSrc)

            //Cabeçalho -> Info. Contrato
            oHTMLBody:ValByName('nrVia'		        , "1ª") 
            oHTMLBody:ValByName('nrcontrato'		, G6R->G6R_CODIGO)

            //Cabeçalho -> Contratrante
            oHTMLBody:ValByName('nomecontratante'	, AllTrim(If(lCliente,SA1->A1_NOME,SUS->US_NOME)))
            oHTMLBody:ValByName('Endcontratante'	, AllTrim(If(lCliente,SA1->A1_END,SUS->US_END)))
            oHTMLBody:ValByName('Cidadecontratante'	, AllTrim(If(lCliente,SA1->A1_MUN,SUS->US_MUN)))
            oHTMLBody:ValByName('Telcontratante'	, AllTrim(If(lCliente,SA1->A1_TEL,SUS->US_TEL)))
            oHTMLBody:ValByName('IEContratante'		, AllTrim(If(lCliente,SA1->A1_INSCR,SUS->US_INSCR)))
            oHTMLBody:ValByName('CPFCNPJContrate'	, cCpfCnpj)
            oHTMLBody:ValByName('Bairrocontratante'	, AllTrim((lCliente,SA1->A1_BAIRRO,SUS->US_BAIRRO)))
            oHTMLBody:ValByName('UFcontratante'		, AllTrim((lCliente,SA1->A1_EST,SUS->US_EST)))
            oHTMLBody:ValByName('RGcontratante'		, AllTrim((lCliente,SA1->A1_RG,'')))

            //Cabeçalho -> Contratada
            oHTMLBody:ValByName('nomecontratada'	, AllTrim(SM0->M0_NOMECOM))
            oHTMLBody:ValByName('Endcontratada'		, AllTrim(SM0->M0_ENDCOB))
            oHTMLBody:ValByName('Cidadecontratada'	, AllTrim(SM0->M0_CIDCOB))
            oHTMLBody:ValByName('IEcontratada'		, AllTrim(SM0->M0_INSC))
            oHTMLBody:ValByName('CFOPcontratada'	, AllTrim(Posicione('SF4',1,xFilial("SF4")+G6R->G6R_TES,"F4_CF")))
            oHTMLBody:ValByName('Bairrocontratada'	, AllTrim(SM0->M0_BAIRCOB))
            oHTMLBody:ValByName('CNPJcontratada'	, AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99" )))

            cItinerar := AllTrim(Posicione('GI1',1,xFilial('GI1')+G6R->G6R_LOCORI,"GI1_DESCRI")) + ;
	    				    " - " + ;
	    				    AllTrim(Posicione('GI1',1,xFilial('GI1')+G6R->G6R_LOCDES,"GI1_DESCRI"))

            aParc := Condicao( nTotProd,G6R->G6R_CONDPG, , )

            //Corpo -> Contrato
            oHTMLBody:ValByName('agencia'		    , AllTrim(SM0->M0_CIDCOB))
            oHTMLBody:ValByName('QtdeCarro'		    , AllTrim(G6R->G6R_QUANT))
            oHTMLBody:ValByName('QtdePassageiros'   , AllTrim(G6R->G6R_POLTR))
            oHTMLBody:ValByName('horaini'           , AllTrim(Transform(G6R->G6R_HRIDA, PesqPict("G6R","G6R_HRIDA"))))
            oHTMLBody:ValByName('dataini'           , AllTrim(G6R->G6R_DTIDA))
            oHTMLBody:ValByName('itinerario'        , AllTrim(cItinerar))
            oHTMLBody:ValByName('localembraque'     , AllTrim(G6R->G6R_ENDEMB))
            oHTMLBody:ValByName('horafim'           , AllTrim(Transform(G6R->G6R_HRVLTA, PesqPict("G6R","G6R_HRVLTA"))))
            oHTMLBody:ValByName('datafim'           , AllTrim(G6R->G6R_DTVLTA))
            oHTMLBody:ValByName('disponibilidade'   , AllTrim(If(G6R->G6R_DISPVE <> "1","Sim","Não")))
            oHTMLBody:ValByName('valor'             , AllTrim(Transform(nTotProd, PesqPict("G6R", "G6R_VALACO"))+ " ("+Extenso(nTotProd)+" )"))
            oHTMLBody:ValByName('kmrodados'         , AllTrim(Transform(G6R->G6R_KMCONT, PesqPict("G6R","G6R_KMCONT"))))
            oHTMLBody:ValByName('kmexcedente'       , AllTrim(Transform(G6R->G6R_KMEXCE, PesqPict("GIP","GIP_KMEXCE"))))

            If Len(aParc) > 0
                oHTMLBody:ValByName('condpag'       , AllTrim(Str( Len(aParc) ) + "X"))
            Else
                oHTMLBody:ValByName('condpag'       , "")
            EndIf

            oHTMLBody:ValByName('contrat'           , AllTrim(If(G6R->G6R_DESPPG == '1', "CONTRATADA","CONTRATANTE")))
            oHTMLBody:ValByName('refeicao'          , AllTrim(If(G6R->G6R_REFEIC,"X","")))
            oHTMLBody:ValByName('pernoite'          , AllTrim(If(G6R->G6R_PERNOI,"X","")))
            oHTMLBody:ValByName('estacionamento'    , AllTrim(If(G6R->G6R_ESTACI,"X","")))

            If !Empty(G6R->G6R_OBSERV)
                oHTMLBody:ValByName('claususaadicional'         , "DÉCIMA QUARTA: ")
                oHTMLBody:ValByName('conteudoclaususaadicional' , AllTrim(G6R->G6R_OBSERV))
            Else
                oHTMLBody:ValByName('claususaadicional'         , "")
                oHTMLBody:ValByName('conteudoclaususaadicional' , "")
            EndIf

            oHTMLBody:ValByName('data'              , cData)

            cPath := cGetFile( "Diretório"+"|*.*" ,"Procurar" ,0, ,.T. ,GETF_LOCALHARD+GETF_RETDIRECTORY ,.T.,)
            cFile := "CONTRATO_LOCACAO_VEICULOS_" + FWTimeStamp(1) + ".htm"

            cHTMLDt := cPath + cFile

            oHTMLBody:SaveFile(cHTMLDt)
	        lRet:= !Empty( MtHTML2Str(cHTMLDt) )

        Else

            MsgStop("Arquivo não encontrado","Verifique os parametros MV_DIRDOC e MV_MODCON") 	
            lRet:= .F.

        EndIf

    Else

        cArqhtml   := Alltrim(SuperGetMv( "MV_MODFRT", .F., "FretamentoContinuo.html" )  )
        cHTMLSrc   := cPathhmtl + cArqhtml

        If !Empty(GY0->GY0_CLIENT)
            SA1->(DbSetOrder(1))
            SA1->(DbSeek(xFilial("SA1") + GY0->GY0_CLIENT + GY0->GY0_LOJACL))
            lClient := .T.
        Else
            SUS->(DbSetOrder(1))
	    	SUS->(DbSeek(xFilial("SUS") + GY0->GY0_CLIENT + GY0->GY0_LOJACL))
	    	lCliente := .F.
        EndIf

        If lCliente
	    	cCpfCnpj := AllTrim(SA1->A1_CGC)
	    Else
	    	cCpfCnpj := AllTrim(SUS->US_CGC)
	    EndIf

        If File(cHTMLSrc)

            oHTMLBody:= TWFHTML():New(cHTMLSrc)

            //Cabeçalho -> Info. Contrato
            oHTMLBody:ValByName('nrVia'		        , "1ª") 
            oHTMLBody:ValByName('nrcontrato'		, GY0->GY0_NUMERO)

            //Cabeçalho -> Contratrante
            oHTMLBody:ValByName('nomecontratante'	, AllTrim(If(lCliente,SA1->A1_NOME,SUS->US_NOME)))
            oHTMLBody:ValByName('Endcontratante'	, AllTrim(If(lCliente,SA1->A1_END,SUS->US_END)))
            oHTMLBody:ValByName('Cidadecontratante'	, AllTrim(If(lCliente,SA1->A1_MUN,SUS->US_MUN)))
            oHTMLBody:ValByName('Telcontratante'	, AllTrim(If(lCliente,SA1->A1_TEL,SUS->US_TEL)))
            oHTMLBody:ValByName('IEContratante'		, AllTrim(If(lCliente,SA1->A1_INSCR,SUS->US_INSCR)))
            oHTMLBody:ValByName('CPFCNPJContrate'	, cCpfCnpj)
            oHTMLBody:ValByName('Bairrocontratante'	, AllTrim((lCliente,SA1->A1_BAIRRO,SUS->US_BAIRRO)))
            oHTMLBody:ValByName('UFcontratante'		, AllTrim((lCliente,SA1->A1_EST,SUS->US_EST)))
            oHTMLBody:ValByName('RGcontratante'		, AllTrim((lCliente,SA1->A1_RG,'')))

            //Cabeçalho -> Contratada
            oHTMLBody:ValByName('nomecontratada'	, AllTrim(SM0->M0_NOMECOM))
            oHTMLBody:ValByName('Endcontratada'		, AllTrim(SM0->M0_ENDCOB))
            oHTMLBody:ValByName('Cidadecontratada'	, AllTrim(SM0->M0_CIDCOB))
            oHTMLBody:ValByName('IEcontratada'		, AllTrim(SM0->M0_INSC))
            oHTMLBody:ValByName('Bairrocontratada'	, AllTrim(SM0->M0_BAIRCOB))
            oHTMLBody:ValByName('CNPJcontratada'	, AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99" )))

            cVigencia := AllTrim(Str(GY0->GY0_VIGE)) + ' ' +;
					GTPXCBOX('GY0_UNVIGE', Val(GY0->GY0_UNVIGE))

            cPreConv  := GTPXCBOX('GYD_PRECON', Val(GYD->GYD_PRECON))
            cPreExtra := GTPXCBOX('GYD_PREEXT', Val(GYD->GYD_PREEXT))
            
            //Corpo -> Contrato            
            oHTMLBody:ValByName('QtdeCarro'		    , AllTrim(GYD->GYD_NUMCAR))
            oHTMLBody:ValByName('QtdePassageiros'   , AllTrim(""))
            oHTMLBody:ValByName('prazoContrato'     , cVigencia)
            oHTMLBody:ValByName('dataInicioVigencia', AllTrim(GY0->GY0_DTINIC))
            oHTMLBody:ValByName('valor'             , AllTrim(GYD->GYD_VLRTOT))
            oHTMLBody:ValByName('precoConvencional' , cPreConv)
            oHTMLBody:ValByName('valorExtra'        , AllTrim(GYD->GYD_VLREXT))
            oHTMLBody:ValByName('precoExtra'        , cPreExtra)
            oHTMLBody:ValByName('cidade'            , AllTrim(SM0->M0_CIDCOB))

            oHTMLBody:ValByName('data'              , cData)

            cPath := cGetFile( "Diretório"+"|*.*" ,"Procurar" ,0, ,.T. ,GETF_LOCALHARD+GETF_RETDIRECTORY ,.T.,)
            cFile := "CONTRATO_FRETAMENTO_CONTINUO" + FWTimeStamp(1) + ".htm"

            cHTMLDt := cPath + cFile

            oHTMLBody:SaveFile(cHTMLDt)
	        lRet:= !Empty( MtHTML2Str(cHTMLDt) )

        Else
            MsgTop("Arquivo não encontrado", "Verifique os parâmetros MV_DIRDOC e MV_MODFRT")
            lRet:= .F.
        EndIf       

    EndIf        
    
Return lRet
