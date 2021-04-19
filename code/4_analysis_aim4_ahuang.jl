# load packages
using CSV;
using DataFrames;
using FreqTables;
using StatsBase;

# setup filepaths
path_source = string(@__DIR__,"\\..\\source");
path_dev = string(@__DIR__,"\\..\\dev");
path_output = string(@__DIR__,"\\..\\output");

# read in cleaned combined VAERS file
df = CSV.read(joinpath(path_dev,"19-21VAERSCOMB_clean.csv"), DataFrame);

# Convert SYMPTOMS strings back to arrays of strings
a = fill([], size(df,1));

for rownumber in 1:size(df, 1)
    str_symptoms = df[rownumber,:SYMPTOMS]
    str_index_start = findfirst(isequal('['), str_symptoms)+2
    str_index_end = findfirst(isequal(']'), str_symptoms)-2
    a[rownumber] = split(df[rownumber,:SYMPTOMS][str_index_start:str_index_end], "\", \"")
end;

df.SYMPTOMS = a;

# Define functions for analysis
function get_freqtable(df, vax_name_str, symptom_str)
    test = select(df, ["VAX_NAME", "SYMPTOMS"])
    # Create dummy variable for vax_name
    test.VAX_IND = (test.VAX_NAME .== vax_name_str)
    # Create dummy variable for symptom
    test.SYMPTOM_IND = zeros(size(test, 1))
    for rownumber in 1:size(test, 1)
        if symptom_str in test[rownumber,:SYMPTOMS]
            test[rownumber,:SYMPTOM_IND] = 1
        end
    end
    
    # Create frequency table
    tbl = freqtable(test, :VAX_IND, :SYMPTOM_IND)
    return tbl
end;

function get_PRR(tbl)
    # Calculate PRR
    a = tbl[2,2]
    b = tbl[2,1]
    c = tbl[1,2]
    d = tbl[1,1]
    PRR = (a/(a+b))/(c/(c+d))
    
    return PRR
end;

# AIM 4 - Stratified analysis by age group
# Create the following age bins, following RI eligibility groups
# 16 to 39
df.AGE_16to39 = (df.AGE_YRS .>= 16) .& (df.AGE_YRS .<= 39);

# 40 to 49
df.AGE_40to49 = (df.AGE_YRS .>= 40) .& (df.AGE_YRS .<= 49);

# 50 to 59
df.AGE_50to59 = (df.AGE_YRS .>= 50) .& (df.AGE_YRS .<= 59);

# 60 to 64
df.AGE_60to64 = (df.AGE_YRS .>= 60) .& (df.AGE_YRS .<= 64);

# 65 to 74
df.AGE_65to74 = (df.AGE_YRS .>= 65) .& (df.AGE_YRS .<= 74);

# 75+
df.AGE_75ovr = (df.AGE_YRS .>= 75);

# Create PRRs for SERIOUS_EVENT, stratified by COVID vax, stratified by AGE GROUP
AGE_GROUP = ["16 to 39", "40 to 49", "50 to 59", "60 to 64", "65 to 74", "75+", "All (16 to 75+)"];

# Pfizer
COVID19_PFIZER_PRR = zeros(0);
push!(COVID19_PFIZER_PRR, get_PRR(freqtable(df[df.AGE_16to39,:], :COVID19_PFIZER, :SERIOUS_EVENT)));
push!(COVID19_PFIZER_PRR, get_PRR(freqtable(df[df.AGE_40to49,:], :COVID19_PFIZER, :SERIOUS_EVENT)));
push!(COVID19_PFIZER_PRR, get_PRR(freqtable(df[df.AGE_50to59,:], :COVID19_PFIZER, :SERIOUS_EVENT)));
push!(COVID19_PFIZER_PRR, get_PRR(freqtable(df[df.AGE_60to64,:], :COVID19_PFIZER, :SERIOUS_EVENT)));
push!(COVID19_PFIZER_PRR, get_PRR(freqtable(df[df.AGE_65to74,:], :COVID19_PFIZER, :SERIOUS_EVENT)));
push!(COVID19_PFIZER_PRR, get_PRR(freqtable(df[df.AGE_75ovr,:], :COVID19_PFIZER, :SERIOUS_EVENT)));
push!(COVID19_PFIZER_PRR, get_PRR(freqtable(df, :COVID19_PFIZER, :SERIOUS_EVENT)));

# Moderna
COVID19_MODERNA_PRR = zeros(0);
push!(COVID19_MODERNA_PRR, get_PRR(freqtable(df[df.AGE_16to39,:], :COVID19_MODERNA, :SERIOUS_EVENT)));
push!(COVID19_MODERNA_PRR, get_PRR(freqtable(df[df.AGE_40to49,:], :COVID19_MODERNA, :SERIOUS_EVENT)));
push!(COVID19_MODERNA_PRR, get_PRR(freqtable(df[df.AGE_50to59,:], :COVID19_MODERNA, :SERIOUS_EVENT)));
push!(COVID19_MODERNA_PRR, get_PRR(freqtable(df[df.AGE_60to64,:], :COVID19_MODERNA, :SERIOUS_EVENT)));
push!(COVID19_MODERNA_PRR, get_PRR(freqtable(df[df.AGE_65to74,:], :COVID19_MODERNA, :SERIOUS_EVENT)));
push!(COVID19_MODERNA_PRR, get_PRR(freqtable(df[df.AGE_75ovr,:], :COVID19_MODERNA, :SERIOUS_EVENT)));
push!(COVID19_MODERNA_PRR, get_PRR(freqtable(df, :COVID19_MODERNA, :SERIOUS_EVENT)));

# Janssen
COVID19_JANSSEN_PRR = zeros(0);
push!(COVID19_JANSSEN_PRR, get_PRR(freqtable(df[df.AGE_16to39,:], :COVID19_JANSSEN, :SERIOUS_EVENT)));
push!(COVID19_JANSSEN_PRR, get_PRR(freqtable(df[df.AGE_40to49,:], :COVID19_JANSSEN, :SERIOUS_EVENT)));
push!(COVID19_JANSSEN_PRR, get_PRR(freqtable(df[df.AGE_50to59,:], :COVID19_JANSSEN, :SERIOUS_EVENT)));
push!(COVID19_JANSSEN_PRR, get_PRR(freqtable(df[df.AGE_60to64,:], :COVID19_JANSSEN, :SERIOUS_EVENT)));
push!(COVID19_JANSSEN_PRR, get_PRR(freqtable(df[df.AGE_65to74,:], :COVID19_JANSSEN, :SERIOUS_EVENT)));
push!(COVID19_JANSSEN_PRR, get_PRR(freqtable(df[df.AGE_75ovr,:], :COVID19_JANSSEN, :SERIOUS_EVENT)));
push!(COVID19_JANSSEN_PRR, get_PRR(freqtable(df, :COVID19_JANSSEN, :SERIOUS_EVENT)));

tbl_aim4 = hcat(AGE_GROUP, COVID19_PFIZER_PRR, COVID19_MODERNA_PRR, COVID19_JANSSEN_PRR)
df_aim4 = DataFrame(tbl_aim4, Symbol.(["AGE GROUP", "PFIZER-BIONTECH", "MODERNA", "JANSSEN"]))

# write to output folder
CSV.write(joinpath(path_output,"aim4.csv"), df_aim4);