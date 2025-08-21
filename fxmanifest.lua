fx_version 'cerulean'
game 'gta5'

author 'Team Low-Dev'
description 'Vehicle Rental System'
version '1.0.0'

shared_scripts {
	'config.lua',
	'locales.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'server.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/app.js'
}

lua54 'yes'
