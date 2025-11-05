fx_version 'cerulean'
game 'gta5'

name "oc-lumberjack"
description "Simple Lumberjack (standalone, no job) with target + multi-inventory support (ox/qb/qs/codem)"
author "Taketora"
version "2.0.0"

lua54 'yes'

shared_scripts {
	'config.lua'
}

server_scripts {
	'server/sv_lumberjack.lua'
}

client_scripts {
	'client/cl_lumberjack.lua'
}

dependencies {
	-- Optional: depends on your Config.Inventory setting
	-- 'ox_inventory',
	-- 'qb-inventory',
	-- 'qs-inventory',
	-- 'codem-inventory',
}
