# load packages
using CSV;
using DataFrames;

# setup filepaths
path_source = string(@__DIR__,"\\..\\source");
path_dev = string(@__DIR__,"\\..\\dev");

# read in VAERS files for 2019
df_data19 = CSV.read(joinpath(path_source,"2019VAERSDATA.csv"), DataFrame);
df_symp19 = CSV.read(joinpath(path_source,"2019VAERSSYMPTOMS.csv"), DataFrame);
df_vax19 = CSV.read(joinpath(path_source,"2019VAERSVAX.csv"), DataFrame);
insertcols!(df_data19, 2, :YEAR => "2019");

# read in VAERS files for 2020
df_data20 = CSV.read(joinpath(path_source,"2020VAERSDATA.csv"), DataFrame);
df_symp20 = CSV.read(joinpath(path_source,"2020VAERSSYMPTOMS.csv"), DataFrame);
df_vax20 = CSV.read(joinpath(path_source,"2020VAERSVAX.csv"), DataFrame);
insertcols!(df_data20, 2, :YEAR => "2020");

# read in VAERS files for 2021
df_data21 = CSV.read(joinpath(path_source,"2021VAERSDATA.csv"), DataFrame);
df_symp21 = CSV.read(joinpath(path_source,"2021VAERSSYMPTOMS.csv"), DataFrame);
df_vax21 = CSV.read(joinpath(path_source,"2021VAERSVAX.csv"), DataFrame);
insertcols!(df_data21, 2, :YEAR => "2021");

# append VAERS data files from 2019-2021
print(size(df_data19));
print(size(df_data20));
print(size(df_data21));
df_data_appended = reduce(vcat, [df_data19, df_data20, df_data21]);
print(size(df_data_appended));

# write to dev
CSV.write(joinpath(path_dev,"19-21VAERSDATA.csv"), df_data_appended);

# append VAERS symptoms files from 2019-2021
print(size(df_symp19));
print(size(df_symp20));
print(size(df_symp21));
df_symp_appended = reduce(vcat, [df_symp19, df_symp20, df_symp21]);
print(size(df_symp_appended));

# write to dev
CSV.write(joinpath(path_dev,"19-21VAERSSYMPTOMS.csv"), df_symp_appended);

# append VAERS vaccine files from 2019-2021
print(size(df_vax19));
print(size(df_vax20));
print(size(df_vax21));
df_vax_appended = reduce(vcat, [df_vax19, df_vax20, df_vax21]);
print(size(df_vax_appended));

# write to dev
CSV.write(joinpath(path_dev,"19-21VAERSVAX.csv"), df_vax_appended);