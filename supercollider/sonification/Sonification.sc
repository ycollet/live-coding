~csv=CSVFileReader.readInterpret("./wa_weather_1944_till_2016.csv",startRow:1).postcs;
~data = List.new();

(
~csv.size.do({arg index;
	var value = ~csv.at(index).at(5);
	if (value != nil, {~data.add(value)})
});
)

~data.postln;

(
SynthDef("data0", {|amp=4, freq=400, pan=0, gate=1|
	var src, env, env2;
	env = EnvGen.kr(Env.asr(0.01, 0.1, 0.1), gate);
	src=SinOsc.ar(freq);
	src=Pan2.ar(src, pan);
	Out.ar(0, src*env*amp);
}).add;
)

Synth("data0");

(
~sonification = Task({|i|
	~data0 = Synth(\data0, [
		\freq, ~data.at(0)]);

	inf.do({arg i;
		postf("Value at index %: %\n", i, ~data.at(i)*10);
		Synth(\data0, [
		\freq, ~data.at(i)*10]);
		0.5.wait;
	})
});
)

s.record(path:"/tmp/audio.wav", duration:300);
~sonification.start;
