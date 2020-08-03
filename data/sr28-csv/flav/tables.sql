CREATE TABLE DATA_SRC (
  DataSrc_ID TEXT,
  Authors TEXT,
  Title TEXT,
  Jorunal TEXT,
  Year TEXT,
  Volume TEXT,
  Issue TEXT,
  Start_Page TEXT,
  Emd_Page TEXT,
)
CREATE TABLE DATSRCLN (
  NDB_No TEXT,
  Nutr_no TEXT,
  DataSrc_ID TEXT,
)
CREATE TABLE FD_GROUP (
  FdGrp_CD TEXT,
  FdGrp_Desc TEXT,
)
CREATE TABLE FLAV_DAT (
  NDB_No TEXT,
  Nutr_no TEXT,
  Flav_Val DOUBLE,
  SE DOUBLE,
  n INT,
  Min DOUBLE,
  Max DOUBLE,
  CC TEXT,
)
CREATE TABLE FLAV_IND (
  NDB_No TEXT,
  DataSrc ID TEXT,
  Food No TEXT,
  FoodIndiv_Desc TEXT,
  Method TEXT,
  Cmpd_Name TEXT,
  Rptd CmpdVal DOUBLE,
  Rptd_Std Dev TEXT,
  Num_Data_Pts DOUBLE,
  LT TEXT,
  Rptd_Units TEXT,
  Fresh Dry_Wt TEXT,
  Quant_Std TEXT,
  Conv_Factor_G DOUBLE,
  Conv_Factor_M TEXT,
  Conv_Factor_SpGr DOUBLE,
  Cmpd_Val DOUBLE,
  Cmpt_StdDev TEXT,
)
CREATE TABLE FOOD_DES (
  NDB_No TEXT,
  FdGrp_Cd TEXT,
  Long_Desc TEXT,
  SciName TEXT,
)
CREATE TABLE NUTR_DEF (
  Nutr_no TEXT,
  Nutrient name TEXT,
  Flav_Class TEXT,
  Tagname TEXT,
  Unit TEXT,
)

