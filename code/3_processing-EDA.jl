# setup filepaths
path_source = string(@__DIR__,"\\..\\source");
path_dev = string(@__DIR__,"\\..\\dev");

# LOAD IN PACKAGES AND DATA
using DataFrames, CSV, Plots, StatsPlots, StatsBase, Missings
df = DataFrame(CSV.read(joinpath(path_dev,"19-21VAERSCOMB.csv"), DataFrame));

# Filter dataset to reports with non-missing Age > 16
df = df[(.!ismissing.(df.AGE_YRS)) .& (df.AGE_YRS .>= 16), :] #filter age >= 16
first(df, 10)

#labeling of events as serious or non-serious
a = (df.DIED .== "Y") .| (df.L_THREAT .== "Y") .| (df.HOSPITAL .== "Y") .| (df.X_STAY .== "Y") .| (df.DISABLE .== "Y") .| (df.BIRTH_DEFECT .== "Y")
df.SERIOUS_EVENT = replace(a, missing => 0)
show(names(df))

colnames = ["VAERS_ID", "RECVDATE", "AGE_YRS", "VAX_NAME", "VAX_TYPE", "VAX_MANU", "SYMPTOMS", "SERIOUS_EVENT"]
df_cleaned = select(df, colnames)

# write to dev
CSV.write(joinpath(path_dev,"19-21VAERSCOMB_clean.csv"), df_cleaned);