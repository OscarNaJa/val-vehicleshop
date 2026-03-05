shared_script "@bt_defender/module/shared.lua"



fx_version 'adamant'
games {'gta5' }

client_scripts {
	'config.lua',
	'config-notify.lua',
	'core/client.lua',
	'core/utils.lua',
	'function/function_client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'core/server.lua',
	'function/function_server.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/style.css',
	'html/js/*.js',
	'html/img/*.png',
	
}
lua54 'yes'