CREATE TABLE DATA_SRC (
  Authors TEXT,
  Title TEXT,
  Year DOUBLE,
  Journal TEXT,
  Vol TEXT,
  Start_Page TEXT,
  End_Page TEXT,
  DataSrc_ID TEXT,
)
CREATE TABLE DATSRCLN (
  NDB_No TEXT,
  Nutr_No TEXT,
  DataSrc_ID TEXT,
)
CREATE TABLE FOOD_DES (
  NDB_No TEXT,
  FdGrp_Cd TEXT,
  Long_Desc TEXT,
)
CREATE TABLE ISFL_DAT (
  NDB_No TEXT,
  Nutr_No TEXT,
  Isfl_Val DOUBLE,
  SD DOUBLE,
  n DOUBLE,
  Min DOUBLE,
  Max DOUBLE,
  CC TEXT,
  DataSrc_ID TEXT,
)
CREATE TABLE NUTR_DEF (
  Nutr_no TEXT,
  NutrDesc TEXT,
  Unit TEXT,
)
CREATE TABLE SYBN_DTL (
  NDB_No TEXT,
  Nutr_No TEXT,
  DataSrc_ID DOUBLE,
  FoodNo TEXT,
  Food_Detail_Desc TEXT,
  Nutr_Val DOUBLE,
  Std_Dev DOUBLE,
  Num_Data_Pts DOUBLE,
  Sam Hand_Rtg DOUBLE,
  AnalMeth_Rtg DOUBLE,
  SampPlan_Rtg DOUBLE,
  AnalQC_Rtg DOUBLE,
  NumSamp_QC DOUBLE,
  CC TEXT,
)
