fx_version 'cerulean'
game 'gta5'

name "oc-lumberjack"
description "Simple Lumberjack (standalone, no job) with target + ox_inventory"
author "Taketora"
version "1.0.0"

lua54 'yes'

shared_scripts {
	'config.lua'
}

client_scripts {
	'client/cl_lumberjack.lua'
}

server_scripts {
	'server/sv_lumberjack.lua'
}

dependencies {
	'ox_inventory'
}
