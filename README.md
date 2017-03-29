# Gmod-CarBan


# Features

Ban/Unban players from using vehicles on your server using chat commands.
ULX Support
Bans persisted upon rejoining server
Lua API


# API

Ban a player from using vehicles
Player:vehicleBan()

Unban a player from using vehicles
Player:vehicleUnban()

Returns a boolean determining if a player can carban or not
Player:canVehicleBan()

Returns a boolean determining if a player is banned from vehicles or not
Player:isVehicleBanned()


# ULX Permissions

ulx_carban -> Ability to ban players from using cars
ulx_uncarban -> Ability to unban players from using cars
