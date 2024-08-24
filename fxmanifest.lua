fx_version 'cerulean'
author 'Marttins | MT Scripts'
description 'Most incredible FiveM elevator script'
lua54 'yes'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    '@qbx_core/modules/lib.lua',
    '@qbx_core/modules/playerdata.lua',
    'client.lua'
}

ui_page 'web/build/index.html'

files {
    'locales/*',

	'web/build/index.html',
	'web/build/**/*',
    'web/assets/**/*',
}