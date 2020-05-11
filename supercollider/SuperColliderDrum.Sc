// (thor magnusson) (2006)

// An instrumentalist inside a synthdef.

(
SynthDef(\drummer, { arg out=0, tempo=4;
	var snare, base, hihat;
	tempo = Impulse.ar(tempo); // for a drunk drummer replace Impulse with Dust !!!

	snare = WhiteNoise.ar(Decay2.ar(PulseDivider.ar(tempo, 4, [0, 1, 2, 3]), 0.005, 0.5));
	base  =	SinOsc.ar(Line.ar(120, 60, 1), 0, Decay2.ar(PulseDivider.ar(tempo, 4, 0), 0.005, 0.5));
	hihat =	HPF.ar(WhiteNoise.ar(1), 10000) * Decay2.ar(PulseDivider.ar(tempo, 4, 0), 0.005, 0.5);

	Out.ar(out,(snare + base + hihat) * 0.4 ! 2)
}).add;
)

a = Synth(\drummer);
a.set(\tempo, 4);
a.set(\tempo, 18);
a.set(\tempo, 180); // check the CPU! no increase.
a.free;


(
SynthDef(\drums, {|out = 0, bassLevel = 0 , snareLevel = 0, hatLevel = 0, tomLevel = 0, pan1 = 0, pan2 = 0, pan3 = 0, pan4 = 0|

  var env1, env2, env3, env4, bass, snare, hat, tom, bassOut, snareOut, hatOut, tomOut, mixer;
  env1 = EnvGen.kr(Env.perc(0.001, 0.2, 1, -4), 1, doneAction:2);
  env2 = EnvGen.kr(Env.perc(0.001, 0.5, 1, -1), 1, doneAction:2);
  env3 = EnvGen.kr(Env.perc(0.002, 0.3, 1, -2), 1, doneAction:2);
  env4 = EnvGen.kr(Env.perc(0.001, 0.1, 1, -5), 1, doneAction:2);

  bass = SinOsc.ar(80) + Crackle.ar(1, 0.5);
  bassOut = Pan2.ar(bass*env1, pan1, bassLevel);

  snare = SinOsc.ar(120) - WhiteNoise.ar(0.5, 0.5);
  snareOut = Pan2.ar(snare*env4, pan2, snareLevel);

  hat = Klank.ar(`[ [ 6563, 9875 ],
                    [ 0.6, 0.5 ],
                    [ 0.002, 0.003] ], PinkNoise.ar(1));
  hatOut = Pan2.ar(hat*env3, pan2, hatLevel);

  tom = SinOsc.ar(440);
  tomOut = Pan2.ar(tom*env4, pan4, tomLevel);

  mixer = Mix.new([bassOut, snareOut, hatOut, tomOut]);

  Out.ar(out, mixer);
}).store

(
  var a = Pseq ([1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]);
  var b = Pseq ([0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0]);
  var c = Pseq ([0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
  var d = Pseq ([0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1]);

  p = Pbind(\instrument, \drums, \dur, 0.12,
\bassLevel, Pseq ([a], inf),
\snareLevel, Pseq ([b], inf),
\hatLevel, Pseq ([c], inf),
\tomLevel, Pseq ([d], inf)).play;
)

(
  var a = Pseq ([1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]);
  var b = Pseq ([0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0]);
  var c = Pseq ([0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0]);
  var d = Pseq ([0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1]);
  var e = Pseq ([0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1]);

  p = Pbind(\instrument, \drums, \dur, 0.12, \bassLevel, Pseq ([a], inf), \snareLevel, Pseq ([b, e], inf), \hatLevel, Pseq ([c], inf), \tomLevel, Pseq ([d], inf)).play;
)

p.stop;
