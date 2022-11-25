Config = {}

Config.Locale = 'en'

-- Set your server player limit
Config.limit = 48

Config.Translations = {
    ['en'] = {
        ['no_perms'] = 'You have to be admin to execute this command!',
        ['updated_default'] = 'Updated your scoreboard to the default theme!',
        ['saved_custom'] = 'You saved your custom color theme!',
        ['event_uploaded'] = 'Event uploaded successfully!',
        ['event_removed'] = 'Event removed successfully!',
    },
    ['es'] = {
        ['no_perms'] = '¡Debes de ser admin para usar este comando!',
        ['updated_default'] = '¡Has actualizado al tema predeterminado!',
        ['saved_custom'] = '¡Has guardado tu tema!',
        ['event_uploaded'] = '¡Has subido el evento!',
        ['event_removed'] = '¡Has eliminado el evento!',
    },
}

Config.Notification = function(action)
    TriggerEvent('QBCore:Notify', Config.Translations[Config.Locale][action])
end

Config.Business = {
    ['LSPD'] = {
        Job = 'police',
        Description = 'To protect and to serve.',
        Status = {
            Service = {'Available', 'Busy', 'Out of service'},
            Defcons = {'Defcon 1', 'Defcon 2', 'Defcon 3', 'Defcon 4', 'Defcon 5'},
        }
    },
    ['LSMD'] = {
        Job = 'ambulance',
        Description = 'Dedicated to safing lifes.',
        Status = {
            Service = {'Available', 'Busy', 'Out of service'},
            Defcons = {'Ambulances', 'In Hospital', 'None'},
        }
    },
    ['LSC'] = {
        Job = 'mechanic',
        Description = 'Modify your vehicles as your liking.',
        Status = {
            Service = {'Available', 'Busy', 'Out of service'},
            Tunning = {'In LS', 'In PT', 'In SS'},
        }
    },
    ['VANILLA'] = {
        Job = 'vanilla',
        Description = 'Get rid of your stress 😁.',
        Status = {
            Service = {'Oppened', 'Closed'},
            Prices = {'Discount', '20$'},
        }
    },
    ['BAHAMAS'] = {
        Job = 'bahamas',
        Description = 'Have some fun with our parties.',
        Status = {
            Service = {'Oppened', 'Closed'},
            Days = {'24/7', '24/5'},
        }
    },
    ['TEQUILA-LA'] = {
        Job = 'tequilala',
        Description = 'Leave your problems at one side.',
        Status = {
            Service = {'Oppened', 'Closed'},
            Days = {'24/7', '24/5'},
        }
    },
    ['AIRPORT'] = {
        Job = 'pilot',
        Description = 'Travel with us around the world.',
        Status = {
            Service = {'Oppened', 'Closed'},
            Status = {'Operative', 'Accident'},
        }
    },
    ['CONCESSIONAIRE'] = {
        Job = 'vehicle_seller',
        Description = 'Car lover? Come with us.',
        Status = {
            Service = {'Oppened', 'Closed'},
            Status = {'DISCOUNTS', 'NORMAL'},
        }
    },
}