-- ***************************************************
-- SCRIPT DE MANIPULACAO DE DADOS KRYPTOGARTEN 
-- DML
-- VERSAO 1.0 
-- ***************************************************

-- Insert de países de atuacao da Kryptogarten 
INSERT INTO PAIS(CD_PAIS, TX_NM_PAIS) VALUES('BR', 'Brasil'); 
INSERT INTO PAIS(CD_PAIS, TX_NM_PAIS) VALUES('CA', 'Canada'); 
INSERT INTO PAIS(CD_PAIS, TX_NM_PAIS) VALUES('US', 'United States'); 

-- Insert estados do pedido 
INSERT INTO EST_PED(TX_DESC_EST_PED) VALUES ('Aberto');
INSERT INTO EST_PED(TX_DESC_EST_PED) VALUES ('Pendente');
INSERT INTO EST_PED(TX_DESC_EST_PED) VALUES ('Em tratamento');
INSERT INTO EST_PED(TX_DESC_EST_PED) VALUES ('Atendido');
INSERT INTO EST_PED(TX_DESC_EST_PED) VALUES ('Cancelado');
INSERT INTO EST_PED(TX_DESC_EST_PED) VALUES ('Finalizado');

-- Insert tipo de email 
INSERT INTO TP_EML(TX_DESC_TP_EML) VALUES ('Principal'); 
INSERT INTO TP_EML(TX_DESC_TP_EML) VALUES ('Empresarial'); 
INSERT INTO TP_EML(TX_DESC_TP_EML) VALUES ('Pessoal'); 


-- Insert tipo endereco 
INSERT INTO TP_END(TX_DESC_TP_END) VALUES ('Principal'); 
INSERT INTO TP_END(TX_DESC_TP_END) VALUES ('Sede'); 
INSERT INTO TP_END(TX_DESC_TP_END) VALUES ('Sucursal'); 
INSERT INTO TP_END(TX_DESC_TP_END) VALUES ('Pessoal'); 

-- Insert tipo representante
INSERT INTO TP_REP(TX_DESC_TP_REP) VALUES ('Presidente'); 
INSERT INTO TP_REP(TX_DESC_TP_REP) VALUES ('Administrador'); 
INSERT INTO TP_REP(TX_DESC_TP_REP) VALUES ('Financeiro'); 
INSERT INTO TP_REP(TX_DESC_TP_REP) VALUES ('Técnico'); 
INSERT INTO TP_REP(TX_DESC_TP_REP) VALUES ('Suporte'); 

-- Insert tipo telefone
INSERT INTO TP_TEL(TX_DESC_TP_TEL) VALUES ('Principal'); 
INSERT INTO TP_TEL(TX_DESC_TP_TEL) VALUES ('Empresarial'); 
INSERT INTO TP_TEL(TX_DESC_TP_TEL) VALUES ('Pessoal'); 
INSERT INTO TP_TEL(TX_DESC_TP_TEL) VALUES ('Celular'); 
INSERT INTO TP_TEL(TX_DESC_TP_TEL) VALUES ('Fax'); 

-- Insert provincia 
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('ON','Ontario','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('QC','Quebec','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('NS','Nova Scotia','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('NB','New Brunswick','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('MB','Manitoba','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('BC','British Columbia','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('PE','Prince Edward Island','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('SK','Saskatchewan','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('AB','Alberta','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('NL','Newfoundland and Labrador','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('NT','Northwestern Territories','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('YT','Yukon','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('NU','Nunavut','CA');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('AC','Acre','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('AL','Alagoas','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('AP','Amapá','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('AM','Amazonas','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('BA','Bahia','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('CE','Ceará','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('DF','Distrito Federal','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('ES','Espírito Santo','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('GO','Goiás','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('MA','Maranhão','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('MT','Mato Grosso','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('MS','Mato Grosso do Sul','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('MG','Minas Gerais','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('PA','Pará','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('PB','Paraíba','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('PR','Paraná','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('PE','Pernambuco','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('PI','Piauí','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('RJ','Rio de Janeiro','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('RN','Rio Grande do Norte','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('RS','Rio Grande do Sul','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('RO','Rondônia','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('RR','Roraima','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('SC','Santa Cararina','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('SP','São Paulo','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('SE','Sergipe','BR');
INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('TO','Tocantins','BR');
-- INSERT INTO PROV(SG_PROV, TX_NM_PROV, CD_PAIS) VALUES('','','');

-- Insert Ambiente de execucao do sistema 
INSERT INTO AMB_EXE_SIS(SG_AMB_EXE_SIS, TX_AMB_EXE_SIS) VALUES ('DES', 'Desenvolvimento'); 
INSERT INTO AMB_EXE_SIS(SG_AMB_EXE_SIS, TX_AMB_EXE_SIS) VALUES ('HOM', 'Homologação'); 
INSERT INTO AMB_EXE_SIS(SG_AMB_EXE_SIS, TX_AMB_EXE_SIS) VALUES ('PRD', 'Produção'); 

-- Insert Estado do certificado digital
INSERT INTO EST_CTFD_DGTL(CD_EST_CTFD_DGTL, TX_EST_CTFD_DGTL) VALUES('SOL','Solicitado'); 
INSERT INTO EST_CTFD_DGTL(CD_EST_CTFD_DGTL, TX_EST_CTFD_DGTL) VALUES('EMT','Emitido'); 
INSERT INTO EST_CTFD_DGTL(CD_EST_CTFD_DGTL, TX_EST_CTFD_DGTL) VALUES('VIG','Vigente'); 
INSERT INTO EST_CTFD_DGTL(CD_EST_CTFD_DGTL, TX_EST_CTFD_DGTL) VALUES('EXP','Expirado'); 
INSERT INTO EST_CTFD_DGTL(CD_EST_CTFD_DGTL, TX_EST_CTFD_DGTL) VALUES('RVG','Revogado'); 

-- Insert Finalidade do certificado digital
INSERT INTO FNLD_CTFD_DGTL(CD_FNLD_CTFD_DGTL, TX_FNLD_CTFD_DGTL) VALUES ('A1', 'Assinatura');
INSERT INTO FNLD_CTFD_DGTL(CD_FNLD_CTFD_DGTL, TX_FNLD_CTFD_DGTL) VALUES ('S1', 'Sigilo');

-- Insert Identificador da Cadeia de Certificacao 
INSERT INTO IDFR_CAD_CTFC
    (SG_IDFR_CAD_CTFC, TX_IDFR_CAD_CTFC, TX_VRS_IDFR_CAD_CTFC, SG_AMB_EXE_SIS) VALUES 
    ('INT', 'PKI Interna Kryptogarten', '1', 'DES'); 
INSERT INTO IDFR_CAD_CTFC
    (SG_IDFR_CAD_CTFC, TX_IDFR_CAD_CTFC, TX_VRS_IDFR_CAD_CTFC, SG_AMB_EXE_SIS) VALUES 
    ('FAR', 'PKI Farmacos', '1', 'DES'); 
INSERT INTO IDFR_CAD_CTFC
    (SG_IDFR_CAD_CTFC, TX_IDFR_CAD_CTFC, TX_VRS_IDFR_CAD_CTFC, SG_AMB_EXE_SIS) VALUES 
    ('COS', 'PKI Cosméticos', '1', 'DES'); 

-- Insert Natureza do titular do certificado digital 
INSERT INTO NTZ_TITR_CTFD_DGTL(CD_NTZ_TITR_CTFD_DGTL, TX_NTZ_TITR_CTFD_DGTL) VALUES ('CLI', 'Cliente');
INSERT INTO NTZ_TITR_CTFD_DGTL(CD_NTZ_TITR_CTFD_DGTL, TX_NTZ_TITR_CTFD_DGTL) VALUES ('PF',  'Pessoa Física');
INSERT INTO NTZ_TITR_CTFD_DGTL(CD_NTZ_TITR_CTFD_DGTL, TX_NTZ_TITR_CTFD_DGTL) VALUES ('PJ',  'Pessoa jurídica');
INSERT INTO NTZ_TITR_CTFD_DGTL(CD_NTZ_TITR_CTFD_DGTL, TX_NTZ_TITR_CTFD_DGTL) VALUES ('SR',  'Servidor');
INSERT INTO NTZ_TITR_CTFD_DGTL(CD_NTZ_TITR_CTFD_DGTL, TX_NTZ_TITR_CTFD_DGTL) VALUES ('AC',  'Autodidade Certificadora');
