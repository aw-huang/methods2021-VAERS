# load packages
using CSV;
using DataFrames;

# setup filepaths
path_source = string(@__DIR__,"\\..\\source");
path_dev = string(@__DIR__,"\\..\\dev");

# merge files
df_data_appended = CSV.read(joinpath(path_dev,"19-21VAERSDATA.csv"), DataFrame);
df_vax_appended = CSV.read(joinpath(path_dev,"19-21VAERSVAX.csv"), DataFrame);
df_symp_appended = CSV.read(joinpath(path_dev,"19-21VAERSSYMPTOMS_dev.csv"), DataFrame);

# rename colnames of df_symp_appended
colnames = ["VAERS_ID", "SYMPTOMS"];
rename!(df_symp_appended, colnames)

# merge (left-join) VAERS data, vaccine files
print(size(df_data_appended));
print(size(df_vax_appended));
df_merged = leftjoin(df_data_appended, df_vax_appended, on = :VAERS_ID)
print(size(df_merged));

# merge (left-join) VAERS data + vax, symptoms files
print(size(df_merged));
print(size(df_symp_appended));
df_merged = leftjoin(df_merged, df_symp_appended, on = :VAERS_ID)
print(size(df_merged));

# write to dev
CSV.write(joinpath(path_dev,"19-21VAERSCOMB.csv"), df_merged);