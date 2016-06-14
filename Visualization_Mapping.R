###MAPPING COUNTRY DATA
all_sPDF <- joinCountryData2Map(Bins_Country, joinCode = "ISO3", nameJoinColumn = "ISO3V10")
mapDevice() #create world map shaped window
mapCountryData(all_sPDF, nameColumnToPlot='Country_Count')

###MAPPING SHANGHAI
Shanghai_sPDF <- joinCountryData2Map(R_Shanghai, joinCode = "ISO3", nameJoinColumn = "ISO3V10")
mapDevice() #create world map shaped window
mapCountryData(Shanghai_sPDF, nameColumnToPlot='Country_Count')

###MAPPING WORLD
World_sPDF <- joinCountryData2Map(R_World, joinCode = "ISO3", nameJoinColumn = "ISO3V10")
mapDevice() #create world map shaped window
mapCountryData(World_sPDF, nameColumnToPlot='Country_Count')

###MAPPING IMES
Times_sPDF <- joinCountryData2Map(R_Times, joinCode = "ISO3", nameJoinColumn = "ISO3V10")
mapDevice() #create world map shaped window
mapCountryData(Times_sPDF, nameColumnToPlot='Country_Count')