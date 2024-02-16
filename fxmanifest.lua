fx_version 'bodacious'
game 'gta5'

author 'seriously'
description 'Drift Score'
version '0.1'

client_script "client.lua"

server_script "server.lua"
files {
	'stats.xml',
}

data_file 'MP_STATS_DISPLAY_LIST_FILE' 'stats.xml'
