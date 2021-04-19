# load packages
using CSV;
using DataFrames;
using StatsBase;

# setup filepaths
path_source = string(@__DIR__,"\\..\\source");
path_dev = string(@__DIR__,"\\..\\dev");

df_symp_appended = CSV.read(joinpath(path_dev,"19-21VAERSSYMPTOMS.csv"), DataFrame);

# Each row in VAERSSYMPTOMS.csv is limited to 5 MedDRA symptom terms 
# This means VAERS reports with > 5 symptoms will have multiple rows
# Collapse the 5 MedDRA symptom columns so that we have a single column containing an array of symptoms for each row

test = copy(df_symp_appended);

# rows with 1 symptom
test1 = filter(row -> any(ismissing, row[names(test)[4:5]]), test);
test1[!,:SYMPTOMS] = map(collect, zip(test1[!,:SYMPTOM1]));
select!(test1, [:VAERS_ID, :SYMPTOMS])

# rows with 2 symptoms
test2 = filter(row -> !any(ismissing, row[names(test)[2:5]]) && any(ismissing, row[names(test)[6:7]]), test)
test2[!,:SYMPTOMS] = map(collect, zip(test2[!,:SYMPTOM1], 
                                      test2[!,:SYMPTOM2]));
select!(test2, [:VAERS_ID, :SYMPTOMS])

# rows with 3 symptoms
test3 = filter(row -> !any(ismissing, row[names(test)[2:7]]) && any(ismissing, row[names(test)[8:9]]), test)
test3[!,:SYMPTOMS] = map(collect, zip(test3[!,:SYMPTOM1], 
                                      test3[!,:SYMPTOM2], 
                                      test3[!,:SYMPTOM3]));
select!(test3, [:VAERS_ID, :SYMPTOMS])

# rows with 4 symptoms
test4 = filter(row -> !any(ismissing, row[names(test)[2:9]]) && any(ismissing, row[names(test)[10:11]]), test)
test4[!,:SYMPTOMS] = map(collect, zip(test4[!,:SYMPTOM1], 
                                      test4[!,:SYMPTOM2], 
                                      test4[!,:SYMPTOM3], 
                                      test4[!,:SYMPTOM4]));
select!(test4, [:VAERS_ID, :SYMPTOMS])

# rows with 5 symptoms (no missing symptoms)
test5 = filter(row -> !any(ismissing, row[names(test)[2:11]]), test);
test5[!,:SYMPTOMS] = map(collect, zip(test5[!,:SYMPTOM1], 
                                      test5[!,:SYMPTOM2], 
                                      test5[!,:SYMPTOM3], 
                                      test5[!,:SYMPTOM4], 
                                      test5[!,:SYMPTOM5]));
select!(test5, [:VAERS_ID, :SYMPTOMS]);

# append and sort
test = reduce(vcat, [test1, test2, test3, test4, test5]);
sort!(test, :VAERS_ID);

# Collapse the rows so that we get a dict of symptoms for each VAERS_ID
# Step 1: Create the dict 
vaers_id_to_symptoms_dict = Dict{Int, Set{String}}()
# Step 2: Populate the keys (VAERS_ID) of the dict
for rownumber in 1:size(test, 1)
    vaers_id = test[rownumber, :VAERS_ID]
    if !haskey(vaers_id_to_symptoms_dict, vaers_id)
        # this is the set where we will store all of the symptoms for this VAERS ID
        vaers_id_to_symptoms_dict[vaers_id] = Set{String}()
    end
end
# Step 3: Populate the values (SYMPTOMS) of the dict
for rownumber in 1:size(test, 1)
    vaers_id = test[rownumber, :VAERS_ID]
    symptoms = test[rownumber, :SYMPTOMS]
    for symptom in symptoms 
        push!(vaers_id_to_symptoms_dict[vaers_id], symptom)
    end
end

# write to dev
CSV.write(joinpath(path_dev,"19-21VAERSSYMPTOMS_dev.csv"), vaers_id_to_symptoms_dict);