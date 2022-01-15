local Translations = {
    error = {
        not_online = 'Player not online',
        wrong_format = 'Incorrect format',
        missing_args = 'Not every argument has been entered (x, y, z)',
        missing_args2 = 'All arguments must be filled out!',
        no_access = 'No access to this command',
        company_too_poor = 'Your employer is broke',
        item_not_exist = 'Item does not exist',
        too_heavy = 'Inventory too full',
        no_skill = 'This skill doesn\'t exist'
    },
    success = {},
    info = {
        received_paycheck = 'You received your paycheck of $%{value}',
        job_info = 'Job: %{value} | Grade: %{value2} | Duty: %{value3}',
        gang_info = 'Gang: %{value} | Grade: %{value2}',
        on_duty = 'You are now on duty!',
        off_duty = 'You are now off duty!',
        level_info = 'Your level is %{value} in the skill: %{value2}',
        xp_info = 'You have %{value}xp in the skill: %{value2}',
        xp_removed = 'Player has been stripped of some xp',
        xp_added = 'Player has been granted some generous xp'
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
