class_name BubbleMicrophone
extends AudioStreamPlayer
const MAX_SAMPLES: int = 10
const MIN_DB: int = 80
var record_bus_index: int
var record_effect: AudioEffectRecord
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance
var volume_samples : Array[float] = []
const SAMPLE_SIZE = 1024

func _ready() -> void:
	print("Devices ", AudioServer.get_input_device_list())
	AudioServer.input_device = "MacBook Pro Microphone (94)"
	record_bus_index = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	spectrum_analyzer = AudioServer.get_bus_effect_instance(record_bus_index, 1)
	record_effect.set_recording_active(true)

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg

func _process(delta: float) -> void:
	var audio : float = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0))
	volume_samples.push_front(audio)
	if volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()
	var sample_avg = average_array(volume_samples)
	
	#print('%sdb' % round(linear_to_db(sample_avg)))
	var magnitude = spectrum_analyzer.get_magnitude_for_frequency_range(0, 200).length()
	
	var energy = clamp((MIN_DB + linear_to_db(magnitude))/MIN_DB, 0, 1)
	#print("Energy", energy)
	#print("freq", get_high_frequency_ratio())

func get_high_frequency_ratio() -> float:
	var high_freq = 0.0
	var total = 0.0
	
	for i in range(SAMPLE_SIZE):
		var freq = float(i) / SAMPLE_SIZE
		var mag = spectrum_analyzer.get_magnitude_for_frequency_range(freq, freq + 0.1).length()
		
		if freq > 0.5:  # Consider upper half of frequency range as "high"
			high_freq += mag
		total += mag
			
	return high_freq / total if total > 0 else 0.0

func start_recording() -> void:
	record_effect.set_recording_active(true)
	
func end_recording() -> void:
	record_effect.set_recording_active(false)
	
	
	
