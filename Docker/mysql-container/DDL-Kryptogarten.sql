-- ***************************************************
-- SCRIPT DE CRIAÇÃO DA BASE DE DADOS KRYPTOGARTEN 
-- DDL 
-- VERSAO 1.0 
-- ***************************************************

DROP DATABASE IF EXISTS KRYPTOGARTEN; 
CREATE DATABASE KRYPTOGARTEN; 
USE KRYPTOGARTEN; 

-- ###### TABELAS TRADICIONAIS ######

-- *** Tabelas de estado ***

-- Estado do pedido
-- Dominio: aberto, pendente, em tratamento, atendido, cancelado, finalizado
CREATE TABLE EST_PED(
	CD_EST_PED INT auto_increment NOT NULL, 
    TX_DESC_EST_PED CHAR(20) NOT NULL, 
    PRIMARY KEY(CD_EST_PED)
);

-- *** Tabelas de tipo *** 

-- Tipo de telefone
-- Dominio: principal, empresarial, pessoal, celular, fax
CREATE TABLE TP_TEL(
	CD_TP_TEL INT auto_increment NOT NULL, 
    TX_DESC_TP_TEL CHAR(20) NOT NULL, 
    PRIMARY KEY(CD_TP_TEL)
);

-- Tipo de email
-- Dominio: principal, empresarial, pessoal
CREATE TABLE TP_EML(
	CD_TP_EML INT auto_increment NOT NULL, 
    TX_DESC_TP_EML CHAR(20) NOT NULL, 
    PRIMARY KEY(CD_TP_EML)
); 

-- Tipo de endereço 
-- Domínio: principal, sede, sucursal, pessoal 
CREATE TABLE TP_END(
	CD_TP_END INT auto_increment NOT NULL, 
    TX_DESC_TP_END CHAR(20) NOT NULL, 
    PRIMARY KEY(CD_TP_END)
); 

-- Tipo de reprensentante
-- Dominio: presidente, administrador, financeiro, tecnico, suporte
CREATE TABLE TP_REP(
	CD_TP_REP INT auto_increment NOT NULL, 
    TX_DESC_TP_REP CHAR(20) NOT NULL, 
    PRIMARY KEY(CD_TP_REP)
); 

-- ###### TABELAS PRINCIPAIS ###### 

CREATE TABLE PAIS (
	CD_PAIS CHAR(2) NOT NULL, 
    TX_NM_PAIS VARCHAR(60) NOT NULL, 
    PRIMARY KEY (CD_PAIS)
); 

CREATE TABLE PROV(
    SG_PROV CHAR(2) NOT NULL,
    CD_PAIS CHAR(2), 
    TX_NM_PROV CHAR(32) NOT NULL, 
    PRIMARY KEY (SG_PROV, CD_PAIS)
);

CREATE TABLE PEDIDO(
	CLIENT_ID CHAR(10) NOT NULL,
    TIMESTAMP_PEDIDO VARCHAR(26) NOT NULL,
	SCHEMA_K CHAR(80) NOT NULL, 
    SCHEMA_ID CHAR(10) NOT NULL,
    QTD_DEMANDADA INT NOT NULL, 
    PRIMARY KEY (CLIENT_ID, TIMESTAMP_PEDIDO)
); 

CREATE TABLE KRYPTOCODE (
	CLIENT_ID VARCHAR(10) NOT NULL,  
	TIMESTAMP_PEDIDO VARCHAR(26) NOT NULL,  
    NR_SEQ_KRYPTOCODE INT NOT NULL,
	KRYPTOCODE VARCHAR(1024) NOT NULL,  
    KRYPTOCODE_VALIDADO bool NOT NULL default false,
	PRIMARY KEY (CLIENT_ID, TIMESTAMP_PEDIDO, NR_SEQ_KRYPTOCODE) 
); 

CREATE TABLE EMPRESA(
	EMP_ID INT auto_increment NOT NULL, 
    TX_NM_EMP CHAR(64) NOT NULL, 
    TX_CNPJ_EMP CHAR(16), 
    CD_SUCC CHAR(10), 
    TX_EML_EMP CHAR(64), 
    PRIMARY KEY(EMP_ID)
); 

CREATE TABLE PES(
	CD_PES INT auto_increment NOT NULL, 
    TX_FM_TRT CHAR(5), 
    TX_NM_PES CHAR(64), 
    TX_SNM_PES CHAR(64), 
    DT_NASC_PES DATE, 
    IN_SEX_PES CHAR(1), 
    PRIMARY KEY(CD_PES)
); 

-- 
-- SUBJECT AREA: 
-- CERTIFICADO DIGITAL 
-- 

-- Autoridade Certificadora 
CREATE TABLE AUTD_CTFD(
    CD_AUTD_CTFR CHAR(8) NOT NULL, 
    NM_AUTD_CTFR CHAR(128) NOT NULL, 
    PRIMARY KEY(CD_AUTD_CTFR)
); 

-- Ambiente de execucao do sistema 
-- Dominio: DES - Desenvolvimento, HOM - Homologacao, PRD - Producao
CREATE TABLE AMB_EXE_SIS(
    SG_AMB_EXE_SIS CHAR(3) NOT NULL, 
    TX_AMB_EXE_SIS CHAR(32) NOT NULL, 
    PRIMARY KEY(SG_AMB_EXE_SIS)
); 

-- Estado do certificado digital
-- Dominio: SOL - Solicitado, EMT - Emitido, VIG - Vigente, EXP -Expirado, RVG - Revogado
CREATE TABLE EST_CTFD_DGTL(
    CD_EST_CTFD_DGTL CHAR(3) NOT NULL, 
    TX_EST_CTFD_DGTL CHAR(16) NOT NULL, 
    PRIMARY KEY(CD_EST_CTFD_DGTL)
);

-- Finalidade do certificado digital 
-- Dominio: Código indicativo da finalidade a que se destina o certificado digital. 
-- Ex.: Assinatura (ex.: 'A1', ..., 'A4'), Sigilo (ex.: 'S1', ..., 'S4'), etc
CREATE TABLE FNLD_CTFD_DGTL(
    CD_FNLD_CTFD_DGTL CHAR(2) NOT NULL, 
    TX_FNLD_CTFD_DGTL CHAR(16) NOT NULL, 
    PRIMARY KEY(CD_FNLD_CTFD_DGTL)
);

-- Identificador da cadeia de certificacao 
-- Código indicativo da raiz da Cadeia de Confiança do certificado digital.
-- Ex.: 'INT'=PKI Interna Kryptogarten, 'FAR'=PKI Farmacos, 'COS'=PKI Cosmeticos, etc.
CREATE TABLE IDFR_CAD_CTFC(
    CD_IDFR_CAD_CTFC INTEGER AUTO_INCREMENT NOT NULL, 
    SG_IDFR_CAD_CTFC CHAR(3) NOT NULL, 
    TX_IDFR_CAD_CTFC CHAR(64) NOT NULL, 
    TX_VRS_IDFR_CAD_CTFC CHAR(10) NOT NULL, 
    SG_AMB_EXE_SIS CHAR(3) NOT NULL, 
    PRIMARY KEY(CD_IDFR_CAD_CTFC)
);

-- Listas de Certificados Revogados - LCR 
CREATE TABLE LCR(
    CD_AUTD_CTFR CHAR(8) NOT NULL, 
    CD_SEQ_LCR INTEGER NOT NULL, 
    TX_URL_LCR CHAR(255) NOT NULL, 
    PRIMARY KEY(CD_AUTD_CTFR, CD_SEQ_LCR)
); 

-- Natureza do titular do certificado digital
-- Código indicativo da natureza do detentor/usuário do certificado digital. 
-- Ex.: 'PF'=pessoa física, 'PJ'=pessoa jurídica, 'SR'=servidor (computador), 'AC'=autoridade certificadora, 'CLI'=Cliente, etc.
CREATE TABLE NTZ_TITR_CTFD_DGTL(
    CD_NTZ_TITR_CTFD_DGTL CHAR(3) NOT NULL, 
    TX_NTZ_TITR_CTFD_DGTL CHAR(32) NOT NULL
);


-- Tabela principal de certificado digital. 
CREATE TABLE CTFD_DGTL(
    CD_AUTD_CTFR CHAR(8) NOT NULL, 
    CD_NR_SRE_CTFD_DGTL CHAR(64) NOT NULL, 
    CD_CLI_TITR_CTFD_DGTL CHAR(20) NULL, 
    NM_DTTR_CTFD_DGTL CHAR(64) NOT NULL, 
    TX_FQDN_DDTR_CTFD_DGTL CHAR(255) NOT NULL,
    TS_EMS_CTFD_DGTL TIMESTAMP NOT NULL, 
    TS_EXP_CTFD_DGTL TIMESTAMP NOT NULL, 
    TS_RVG_CTFD_DGTL TIMESTAMP NULL, 
    CD_EST_CTFD_DGTL CHAR(3) NOT NULL DEFAULT 'SOL', 
    TS_EST_CTFD_DGTL TIMESTAMP NOT NULL, 
    CD_IDFR_CAD_CTFC INTEGER NOT NULL, 
    CD_FNLD_CTFD_DGTL CHAR(2) NOT NULL DEFAULT 'A1', 
    CD_NTZ_TITR_CTFD_DGTL CHAR(3) NOT NULL, 
    TX_CTFD_DGTL VARCHAR(4096),
    PRIMARY KEY(CD_AUTD_CTFR, CD_NR_SRE_CTFD_DGTL)
	-- , FOREIGN KEY(CD_PES) REFERENCES PESSOA(CD_PES)
    -- , FOREIGN KEY(CD_EST_CTFD_DGTL) REFERENCES EST_CTFD_DGTL(CD_EST_CTFD_DGTL)
);

