extends EventBase
class_name PlaySE

var se_path: String

func initialise(se: String) -> PlaySE:
	se_path = se
	# print("PLAY SE: %s" % se_path)
	return self


# この関数はサウンドを再生するためのAudioStreamPlayerノードを生成します
func run():
	print("Running PLAY SE: %s" % se_path)
	
	# AudioStreamPlayerノードのインスタンスを作成
	var sound_player = AudioStreamPlayer.new()

	# 作成したノードをシーンに追加
	get_parent().add_child(sound_player)

	# サウンドファイルをロード
	var sound = load(se_path)

	# サウンドをAudioStreamPlayerに設定
	sound_player.stream = sound

	# サウンドの再生
	sound_player.play()

	# サウンドの再生が終了したら、ノードを削除する
	sound_player.connect("finished", sound_player.queue_free)
	
	_clean_up()
	
	# TODO: Add _cleanup() in EventBase, and connect signals to it to clear all objects
	# created by an Event after it finishes running.
	# You cannot do queue_free() directly because that would also delete all child nodes before they run, e.g., sound_player
	# You also cannot delete event after it finishes running, in case it gets requeued by JumpToLabelEvent
	# After an event finishes, it should delete everything it created, but not itself
	# このイベントノードを削除する
	# sound_player.connect("finished", queue_free)
