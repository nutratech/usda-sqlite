CREATE TABLE DATA_SRC (
  DataSrc_ID TEXT,
  Authors TEXT,
  Title TEXT,
  Year DOUBLE,
  Jounral TEXT,
  Vol DOUBLE,
  Issue DOUBLE,
  Start_Page TEXT,
  End_Page TEXT,
)
CREATE TABLE DATSRCLN (
  NDB_No TEXT,
  Nutr_No TEXT,
  DataSrc_ID TEXT,
)
CREATE TABLE FD_GROUP (
  FdGrp_CD TEXT,
  FdGrp_Desc TEXT,
)
CREATE TABLE FOOD_DES (
  NDB No TEXT,
  FdGrp_Cd TEXT,
  Long_Desc TEXT,
  SciName TEXT,
)
CREATE TABLE NUTR_DEF (
  Nutr_No TEXT,
  Units TEXT,
  Tagname TEXT,
  NutrDesc TEXT,
  Num_Dec TEXT,
  SR_Order INT,
)
CREATE TABLE PA_DAT (
  NDB No TEXT,
  Nutr_No TEXT,
  Flav_Val DOUBLE,
  SD DOUBLE,
  N DOUBLE,
  Min DOUBLE,
  Max DOUBLE,
  CC TEXT,
)

