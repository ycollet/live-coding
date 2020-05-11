{ DynKlank.ar(`[[800, MouseX.kr(900, 1071), 1353, MouseY.kr(1400, 1723)], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;

{ SinOsc.ar(MouseX.kr(150, 600, 1).poll, 0, 0.1) }.play;

{SinOsc.ar(MouseX.kr(300,3000).poll*Perlin3.kr(*{Line.kr(330, 1000, 3,doneAction: Done.freeSelf)}))}.play;

(
var an;

t = TempoClock.default;
t.tempo = 4;

SynthDef(\Sine, { |freq = 440, out = 0|
    var sig;
	sig = SinOsc.ar(freq,0,Line.kr(0.1,0,MouseX.kr(1,10),doneAction:2));
    Out.ar(out, sig ! 2)
}).add;

an = Pwhite(300.0, 1600.0, inf);
Pbind(\instrument, \Sine, \freq, an).play(t);
)


// Funny drum
(
{
	a=Impulse;
	tanh(a.kr(8).lag*Crackle.ar(LFSaw.kr(3).abs.lag*1.8)+GVerb.ar([a.kr(2)+a.kr(4,0.5)].lag*Blip.ar(4.9,7,0.4)!2,1,1)*5)
}.play;
)
