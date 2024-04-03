import numpy as np
import pandas as pd

df = pd.read_csv("legislativas2024_pre.csv",sep=";",decimal=",",header=None)

ddf = pd.DataFrame()
ddf['Distrito/R.A.'] = df[0]
ddf['Município'] = df[1]
ddf['Freguesia'] = df[2]
ddf['Inscritos'] = np.array([int(a.replace(".","")) for a in list(df[3])])

for party in ["PS", "PPD/PSD.CDS-PP.PPM", "CH", "IL", "B.E.", "PCP-PEV", "L", "PAN",
              "ADN", "PPD/PSD.CDS-PP", "R.I.R.", "JPP", "PCTP/MRPP", "ND", "VP", "E",
              "MPT.A", "PTP", "NC", "PPM"]:
    ddf[party] = pd.concat((df[i+2][df[i]==party] for i in np.arange(4,60,3) if len(df[i+2][df[i]==party])!=0),join="inner")
    ddf[party] = np.array([int(a.replace(".","")) if type(a)==str else a for a in ddf[party]])
    ddf[party] = ddf[party].astype('Int64')

ddf["Brancos"] = pd.concat((df[i+2][df[i]=="EMBRANCO"] for i in np.arange(4,60,3) if len(df[i+2][df[i]=="EMBRANCO"])!=0),join="inner")
ddf["Brancos"] = np.array([int(a.replace(".","")) if type(a)==str else a for a in ddf["Brancos"]])
ddf["Brancos"] = ddf["Brancos"].astype('Int64')

ddf["Nulos"] = pd.concat((df[i+2][df[i]=="NULOS"] for i in np.arange(4,60,3) if len(df[i+2][df[i]=="NULOS"])!=0),join="inner")
ddf["Nulos"] = np.array([int(a.replace(".","")) if type(a)==str else a for a in ddf["Nulos"]])
ddf["Nulos"] = ddf["Nulos"].astype('Int64')

ddf.to_csv("legislativas2024.csv")