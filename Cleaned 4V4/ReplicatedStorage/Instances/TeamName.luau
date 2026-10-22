local team_name = {}
local team_names = {}
team_names.Argentina = "Argentina"
team_names.Munich = "Munich"
team_names.Dortmund = "Dortmund"
team_names.Brazil = "Brazil"
team_names.ParisSaints = "Paris"
team_names.ManchesterU = "Manchester Utd."
team_names.Barcelona = "Barcelona"
team_names.InterMiami = "Inter Miami"
team_names.Japan = "Japan"
team_names.Italy = "Italy"
team_names.Croatia = "Croatia"
team_names.Morocco = "Morocco"
team_names.Canada = "Canada"
team_names.Portugal = "Portugal"
team_names.Mexico = "Mexico"
team_names.Netherlands = "Netherlands"
team_names.RealMadrid = "Real Madrid"
team_names.LiverpoolFC = "Liverpool FC"
team_names.SeattleSoundersFC = "Sounders FC"
team_names.JuventusFC = "Juventus FC"
team_names.Newcastle = "Newcastle Utd."
team_names.ManchesterCity = "Man. City"
team_names.Germany = "Germany"
team_names.England = "England"
team_names.Arsenal = "Arsenal"
team_names.InterMilan = "Inter Milan"
team_names.USA = "USA"
team_names.Chelsea = "Chelsea"
team_names.Napoli = "Napoli"
team_names.France = "France"
team_names.Uruguay = "Uruguay"
team_names.Roma = "Roma"
team_names.Lazio = "Lazio"
team_names.SouthKorea = "South Korea"
team_names.VascoDaGama = "Vasco da Gama"
team_names.Ajax = "AFC Ajax"
team_names.Atletico = "Atletico Madrid"
team_names.Leverkusen = "B04 Leverkusen"
team_names.Wales = "Wales"
team_names.Fiorentina = "Fiorentina"
team_names.Spurs = "Tottenham Hotspurs"
team_names.ACMilan = "AC Milan"
team_names.Belgium = "Belgium"
team_names.Spain = "Spain"
team_names.Scotland = "Scotland"
team_names.Poland = "Poland"
team_names.Sweden = "Sweden"
team_names.Bosnia = "Bosnia & Herzegovina"
team_names.Denmark = "Denmark"
team_names.Romania = "Romania"
team_names.Switzerland = "Switzerland"
local club_teams = {
    "Munich",
    "Dortmund",
    "ParisSaints",
    "ManchesterU",
    "Barcelona",
    "InterMiami",
    "RealMadrid",
    "LiverpoolFC",
    "SeattleSoundersFC",
    "JuventusFC",
    "Newcastle",
    "ManchesterCity",
    "Chelsea",
    "Napoli",
    "Roma",
    "Lazio",
    "VascoDaGama",
    "Ajax",
    "Atletico",
    "Leverkusen",
    "Fiorentina",
    "ACMilan",
    "Spurs",
    "InterMilan",
    "Arsenal",
}
local country_teams = {
    "Argentina",
    "Brazil",
    "Japan",
    "Italy",
    "Croatia",
    "Morocco",
    "Canada",
    "Portugal",
    "Mexico",
    "Netherlands",
    "Uruguay",
    "France",
    "Germany",
    "Wales",
    "SouthKorea",
    "USA",
    "England",
    "Belgium",
    "Spain",
    "Scotland",
    "Poland",
    "Bosnia",
    "Sweden",
    "Switzerland",
    "Denmark",
    "Romania",
}
local full_names = {}
full_names.Argentina = "ARGENTINA"
full_names.Munich = "F.C. BAYERN"
full_names.Dortmund = "BORUSSIA DORTMUND"
full_names.Brazil = "BRAZIL"
full_names.ParisSaints = "P.S.G"
full_names.ManchesterU = "MANCHESTER UNITED"
full_names.Barcelona = "F.C. BARCELONA"
full_names.InterMiami = "INTER MIAMI"
full_names.Japan = "JAPAN"
full_names.Italy = "ITALY"
full_names.Croatia = "CROATIA"
full_names.Morocco = "MOROCCO"
full_names.Canada = "CANADA"
full_names.Portugal = "PORTUGAL"
full_names.Mexico = "MEXICO"
full_names.Netherlands = "NETHERLANDS"
full_names.RealMadrid = "REAL MADRID"
full_names.LiverpoolFC = "LIVERPOOL F.C."
full_names.SeattleSoundersFC = "SEATTLE SOUNDERS F.C."
full_names.JuventusFC = "JUVENTUS F.C."
full_names.Newcastle = "NEWCASTLE UNITED"
full_names.ManchesterCity = "MANCHESTER CITY"
full_names.Germany = "GERMANY"
full_names.England = "ENGLAND"
full_names.Arsenal = "ARSENAL F.C."
full_names.InterMilan = "INTER MILAN"
full_names.USA = "USA"
full_names.Chelsea = "CHELSEA F.C."
full_names.Napoli = "F.C. NAPOLI"
full_names.France = "FRANCE"
full_names.Uruguay = "URUGUAY"
full_names.Roma = "ROMANIA"
full_names.Lazio = "LAZIO"
full_names.SouthKorea = "SOUTH KOREA"
full_names.VascoDaGama = "CR VASCO DA GAMA"
full_names.Ajax = "A.F.C. AJAX"
full_names.Atletico = "ATLETICO MADRID"
full_names.Leverkusen = "BAYER 04 LEVERKUSEN"
full_names.Wales = "WALES"
full_names.Fiorentina = "A.C.F. FIORENTINA"
full_names.Spurs = "TOTTENHAM HOTSPURS"
full_names.ACMilan = "A.C. MILAN"
full_names.Belgium = "BELGIUM"
full_names.Spain = "SPAIN"
full_names.Scotland = "SCOTLAND"
full_names.Poland = "POLAND"
full_names.Sweden = "SWEDEN"
full_names.Bosnia = "BOSNIA AND HERZEGOVINA"
full_names.Denmark = "DENMARK"
full_names.Romania = "ROMANIA"
full_names.Switzerland = "SWITZERLAND"
local team_colors = {}
team_colors.Argentina = BrickColor.new("Cyan")
team_colors.Munich = BrickColor.new("Dusty Rose")
team_colors.Dortmund = BrickColor.new("Bright yellow")
team_colors.Brazil = BrickColor.new("Dark green")
team_colors.ParisSaints = BrickColor.new("Dark blue")
team_colors.ManchesterU = BrickColor.new("Bright red")
team_colors.Barcelona = BrickColor.new("Deep blue")
team_colors.InterMiami = BrickColor.new("Carnation pink")
team_colors.Japan = BrickColor.new("Navy blue")
team_colors.Italy = BrickColor.new("Lapis")
team_colors.Croatia = BrickColor.new("Pastel Blue")
team_colors.Morocco = BrickColor.new("Crimson")
team_colors.Canada = BrickColor.new("Ghost grey")
team_colors.Portugal = BrickColor.new("Bright red")
team_colors.Mexico = BrickColor.new("Black")
team_colors.Netherlands = BrickColor.new("Neon orange")
team_colors.RealMadrid = BrickColor.new("Ghost grey")
team_colors.LiverpoolFC = BrickColor.new("Black")
team_colors.SeattleSoundersFC = BrickColor.new("Bright green")
team_colors.JuventusFC = BrickColor.new("Really black")
team_colors.Newcastle = BrickColor.new("Smoky grey")
team_colors.ManchesterCity = BrickColor.new("Electric blue")
team_colors.Germany = BrickColor.new("Maroon")
team_colors.Arsenal = BrickColor.new("Really red")
team_colors.InterMilan = BrickColor.new("Navy blue")
team_colors.USA = BrickColor.new("Deep blue")
team_colors.Chelsea = BrickColor.new("Lapis")
team_colors.Napoli = BrickColor.new("Steel blue")
team_colors.France = BrickColor.new("Dark blue")
team_colors.Uruguay = BrickColor.new("Medium blue")
team_colors.Roma = BrickColor.new("Persimmon")
team_colors.Lazio = BrickColor.new("Medium blue")
team_colors.England = BrickColor.new("Fossil")
team_colors.SouthKorea = BrickColor.new("Mid gray")
team_colors.VascoDaGama = BrickColor.new("Mid gray")
team_colors.Ajax = BrickColor.new("Salmon")
team_colors.Atletico = BrickColor.new("Crimson")
team_colors.Leverkusen = BrickColor.new("Cocoa")
team_colors.Wales = BrickColor.new("Sea green")
team_colors.Fiorentina = BrickColor.new("Royal purple")
team_colors.Spurs = BrickColor.new("Quill grey")
team_colors.ACMilan = BrickColor.new("Maroon")
team_colors.Belgium = BrickColor.new("Deep orange")
team_colors.Spain = BrickColor.new("Bright orange")
team_colors.Scotland = BrickColor.new("Electric blue")
team_colors.Poland = BrickColor.new("Terra Cotta")
team_colors.Sweden = BrickColor.new("Storm blue")
team_colors.Bosnia = BrickColor.new("Dark indigo")
team_colors.Denmark = BrickColor.new("Really red")
team_colors.Romania = BrickColor.new("Bright yellow")
team_colors.Switzerland = BrickColor.new("Persimmon")
local white_teams = {
    "England",
    "SouthKorea",
    "Japan",
    "USA",
    "Spurs",
    "RealMadrid",
    "VascoDaGama",
    "Germany",
    "Argentina",
    "Lazio",
    "Newcastle",
    "JuventusFC",
}
local red_teams = {
    "Morocco",
    "Canada",
    "ManchesterU",
    "Munich",
    "Spain",
    "Belgium",
    "Atletico",
    "Roma",
    "Arsenal",
    "Poland",
    "Switzerland",
    "Denmark",
    "Portugal",
}
local blue_teams = { "InterMilan", "Barcelona", "Napoli", "Chelsea", "Fiorentina", "ParisSaints", "Bosnia" }
local dark_gray_teams = {
    "Croatia",
    "Mexico",
    "LiverpoolFC",
    "InterMiami",
    "Ajax",
    "Leverkusen",
    "Wales",
    "ACMilan",
    "Newcastle",
    "JuventusFC",
    "France",
}
local yellow_teams = { "Brazil", "Romania", "Sweden" }
team_name.worldSevenTitle = {
    SonicGenerations246 = "SEBI\196\140AN",
    xAbruptum = "SOLEIL",
    kaitoudono = "TEIERI ANRI",
    xmanr0cks = "SLING",
    Dee7055 = "DEE",
    redslaer1493 = "THE DIBBLER",
    k44k4o = "SEREN",
    magikk3 = "MAGIKK",
    sep1ku = "IMONPC",
}
team_name.clubTeams = club_teams
team_name.countryTeams = country_teams
team_name.fullNames = full_names
team_name.teamColors = team_colors
team_name.teamNames = team_names
team_name.whiteTeams = white_teams
team_name.redTeams = red_teams
team_name.blueTeams = blue_teams
team_name.darkGrayTeams = dark_gray_teams
team_name.YellowTeams = yellow_teams

return team_name
