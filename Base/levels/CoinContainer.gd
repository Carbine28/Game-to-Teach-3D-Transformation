extends Spatial

signal coin_added
var _player
var _player_coin_container 

func _ready():
	_player = owner.get_node("Player")
	_player_coin_container = _player.get_node("CoinComponent")
	
func _on_Coin_Obtained():
	_player_coin_container.add_coin()
	
