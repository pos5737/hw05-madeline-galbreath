#Attach tidyverse packages
library(tidyverse)

#Read Manifesto Project dataset, assign it to "df"
df <- read_csv("data/raw/manifesto_project.csv")

#Glimpse the dataframe
glimpse(df)

#Remove columns of peripheral relevance to data: eg columns concerning data and coding processes or columns lacking values for nearly all countries)
df2 = subset(df, select = -c(coderid, manual, coderyear, testresult, testeditsim, presvote, datasetorigin, corpusversion, total, datasetversion, id_perm))

#Confirm that removal succeeded
glimpse(df2)

#Remove columns that are extremely lacking in information/results
df3 = subset(df2, select = -c(per1011, per1012, per1013, per1014, per1015, per1016, per1021, per1022, per1023, per1024, per1025, per1026, per1031, per1032, per1033, per2021, per2022, per2023, per2041, per3011, per3051, per3052, per3053, per3054, per3055, per4011, per4012, per4013, per4014, per4121, per4122, per4123, per4124, per4131, per4132, per5021, per5031, per5041, per5061, per6011, per6012, per6013, per6014, per6061, per6071, per6072, per6081, per7051, per7052, per7061, per7062, per103_1, per103_2, per201_1, per202_2, per202_3, per202_4, per305_1, per305_2, per305_3, per305_4, per305_5, per305_6, per416_1, per416_2, per601_1, per601_2, per605_1, per605_2, per606_1, per606_2, per607_1, per607_2, per607_3, per608_1, per608_2, per608_3, per703_1, per703_2))

#Again, confirm that removal succeeded
glimpse(df3)

#Remove columns that were missed in the previous removal
df4 = subset(df3, select = -c(voteest, per2031, per2032, per2033, per201_2, per202_1, per602_1, per602_2))

#Rename variables to clear snake_case versions
df5 <- rename(df4, country_name = countryname,
              oecd_member = oecdmember,
              eu_member = eumember,
              election_date = edate,
              party_name = partyname,
              party_abbrev = partyabbrev,
              party_fam = parfam,
              percent_vote = pervote,
              absol_seats = absseat,
              total_seats = totseats,
              prog_type = progtype,
              percent_uncoded = peruncod,
              bonds_positive = per101,
              bonds_negative = per102,
              anti_imperialism = per103,
              milit_positive = per104,
              milit_negative = per105,
              peace = per106,
              intl_positive = per107,
              ec_eu_positive = per108,
              intl_negative = per109,
              ec_eu_negative = per110,
              freedom_hr = per201,
              demcoracy = per202,
              constit_positive = per203,
              constit_negative = per204,
              decentralize = per301,
              centralize = per302,
              gvmt_efficiency = per303,
              corruption = per304,
              polit_authority = per305,
              free_market = per401,
              incentives = per402,
              regulation = per403,
              econ_planning = per404,
              state_collab = per405,
              protect_positive = per406,
              protect_negative = per407,
              econ_goals = per408,
              demand_side = per409,
              econ_growth = per410,
              infrastruct_tech = per411,
              controlled_econ = per412,
              nationalization = per413,
              econ_orthodoxy = per414,
              marxism = per415,
              anti_growth = per416,
              environ = per501,
              culture = per502,
              equality = per503,
              welfare_state = per504,
              welfare_less = per505,
              education = per506,
              education_less = per507,
              nation_positive = per601,
              nation_negative = per602,
              moralism = per603,
              moralism_negative = per604,
              law_and_order = per605,
              civic_mind = per606,
              multiculture = per607,
              multiculture_negative = per608,
              labor_positive = per701,
              labor_negative = per702,
              agriculture = per703,
              white_collar = per704,
              marginalized_general = per705,
              demographic_groups = per706,
              axis_position = rile,
              plan_eco = planeco,
              mark_eco = markeco,
              int_peace = intpeace)

#Remove more missed columns
df6 = subset(df5, select = -c(date))
              
#See the new data frame
glimpse(df6)

#Attempt to convert election_date dates into YYYY-MM-DD form
df7 <- mutate(df6, election_date = str_replace(election_date,
                                   pattern= "\\b(?<day>\\d{1,2})/(?<month>\\d{1,2})/(?<year>\\d{2,4})\\b",
                                   replacement= "\\${year}-\\${month}-\\${day}"))

#Convert inconvenient number codes to strings
df8 <- mutate(df7, across("oecd_member", str_replace, "10", "Member"),
              across("oecd_member", str_replace, "0", "Non-member"),
              across("eu_member", str_replace, "20", "Applicant"),
              across("eu_member", str_replace, "10", "Member"),
              across("eu_member", str_replace, "0", "Non-member"),
              across("party_fam", str_replace, "999", "NA"),
              across("party_fam", str_replace, "98", "Diverse"),
              across("party_fam", str_replace, "95", "Special Issue"),
              across("party_fam", str_replace, "90", "Ethnic and Regional"),
              across("party_fam", str_replace, "80", "Agrarian"),
              across("party_fam", str_replace, "70", "Nationalist"),
              across("party_fam", str_replace, "60", "Conservative"),
              across("party_fam", str_replace, "50", "Religious Democratic"),
              across("party_fam", str_replace, "40", "Liberal"),
              across("party_fam", str_replace, "30", "Social Democratic"),
              across("party_fam", str_replace, "20", "Leftist"),
              across("party_fam", str_replace, "10", "Ecological"))

#Glimpse once more
glimpse(df8)

#One Last Missed Removal
df9 = subset(df8, select = -c(prog_type))

#Correct typo
df10 <- rename(df9, democracy = demcoracy)

#Remove stray slashes in election_date
df11 <- mutate(df10, election_date = str_replace_all(election_date, pattern = "\\\\", replacement = ""))

#Final glimpse
glimpse(df11)

#Save the tidier dataset as .rds and .csv files
write_rds(df11,
          "data/manifesto_tidy.rds")
write_csv(df11,
          "data/manifesto_tidy.csv")
