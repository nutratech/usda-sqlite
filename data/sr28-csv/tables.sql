CREATE TABLE DATA_SRC (
  DataSrc_ID TEXT,
  Authors TEXT,
  Title TEXT,
  Year TEXT,
  Journal TEXT,
  Vol_City TEXT,
  Issue_State TEXT,
  Start_Page TEXT,
  End_Page TEXT,
)
CREATE TABLE DATSRCLN (
  NDB_No TEXT,
  Nutr_No TEXT,
  DataSrc_ID TEXT,
)
CREATE TABLE DERIV_CD (
  Deriv_Cd TEXT,
  Deriv_Desc TEXT,
)
CREATE TABLE FD_GROUP (
  FdGrp_Cd TEXT,
  FdGrp_desc TEXT,
)
CREATE TABLE FOOD_DES (
  NDB_No TEXT,
  FdGrp_Cd TEXT,
  Long_Desc TEXT,
  Shrt_Desc TEXT,
  Com_Name TEXT,
  ManufacName TEXT,
  Survey TEXT,
  Ref_Desc TEXT,
  Refuse INT,
  Sci_Name TEXT,
  N_FActor FLOAT,
  Pro_Factor_ FLOAT,
  Fat_Factor_ FLOAT,
  CHO_Factor FLOAT,
)
CREATE TABLE FOOTNOTE (
  NDB_No TEXT,
  Footnt_No TEXT,
  Footnt_Typ TEXT,
  Nutr_No TEXT,
  Footnt_Txt TEXT,
)
CREATE TABLE LANGDESC (
  Factor TEXT,
  Description TEXT,
)
CREATE TABLE LANGUAL (
  NDB_No TEXT,
  Factor TEXT,
)
CREATE TABLE NUT_DATA (
  NDB_No TEXT,
  Nutr_No TEXT,
  Nutr_Val DOUBLE,
  Num_Data_Pts INT,
  Std_Error DOUBLE,
  Src_Cd TEXT,
  Deriv_Cd TEXT,
  Ref_NDB_No TEXT,
  Add_Nutr_Mark TEXT,
  Num_Studies LONG,
  Min DOUBLE,
  Max DOUBLE,
  DF LONG,
  Low_EB DOUBLE,
  Up_EB DOUBLE,
  Stat_Cmt TEXT,
  AddMod_Date TEXT,
)
CREATE TABLE NUTR_DEF (
  Nutr_no TEXT,
  Units TEXT,
  Tagname TEXT,
  NutrDesc TEXT,
  Num_Dec TEXT,
  SR_Order LONG,
)
CREATE TABLE SRC_CD (
  Src_Cd TEXT,
  SrcCd_Desc TEXT,
)
CREATE TABLE WEIGHT (
  NDB_No TEXT,
  Seq TEXT,
  Amount FLOAT,
  Msre_Desc TEXT,
  Gm_Wgt DOUBLE,
  Num_Data_pts LONG,
  Std_Dev DOUBLE,
)

