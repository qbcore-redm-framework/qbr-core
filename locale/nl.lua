local Translations = {
    error = {
        not_online = 'Speler is niet online',
        wrong_format = 'Onjuiste opmaak',
        missing_args = 'Niet elk argument is ingevuld (x, y, z)',
        missing_args2 = 'Alle argumenten moeten worden ingevuld!',
        no_access = 'Geen toegang tot dit commando',
        company_too_poor = 'Je werkgever is arm',
        item_not_exist = 'Item bestaat niet',
        too_heavy = 'Inventaris is te vol',
        no_skill = 'Deze vaardigheid bestaat niet'
    },
    success = {},
    info = {
        received_paycheck = 'Je hebt je salaris van $%{value} ontvangen',
        job_info = 'Baan: %{value} | Rang: %{value2} | In dienst: %{value3}',
        gang_info = 'Gang: %{value} | Rang: %{value2}',
        on_duty = 'Je bent nu in dienst!',
        off_duty = 'Je bent nu uit dienst!',
        level_info = 'Jouw level is %{value} in de vaardigheid: %{value2}',
        xp_info = 'Je hebt %{value}xp in de vaardigheid: %{value2}',
        xp_removed = 'Persoon is ontdaan van een beetje xp',
        xp_added = 'Persoon heeft een beetje xp bij gekregen'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
