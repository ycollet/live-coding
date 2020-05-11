(
// Notice that for this shortcut visualisation, we define the filter as a function taking its
//  input as an argument, and returning its output (we don't use In.ar or Out.ar)
{ |casein|
	var delayA = CombC.ar(casein, 0.00077, 0.00077, 0.1);
	var delayB = CombC.ar(delayA, 0.00088, 0.00088, 0.1);
	var bands = BPF.ar(delayB, [1243, 287, 431], 1/12).sum;
	var son = bands.clip2(0.3);

	// Mouse to the LEFT means flat filter (no change), to the RIGHT means full bakelite
	XFade2.ar(casein, son, MouseX.kr(-1,1));

}.scopeResponse
)

// A tweaked version of the phonebell synthdef, to take an on/off from outside, and incorporate the striker
(
SynthDef(\dsaf_phonebell2, { |gate=1, freq=465, strength=1, decay=3, amp=1|
	var trigs, striker, son;
	trigs = Impulse.ar(14) * gate;
	striker = WhiteNoise.ar(EnvGen.ar(Env.perc(0.0000001, 0.01), trigs));
	son = Klank.ar(`[
		// frequency ratios
		[0.501, 1, 0.7,   2.002, 3, 9.6,   2.49, 11, 2.571,  3.05, 6.242, 12.49, 13, 16, 24],
		// amps
		[0.002,0.02,0.001, 0.008,0.02,0.004, 0.02,0.04,0.02, 0.005,0.05,0.05, 0.02, 0.03, 0.04],
		// ring times - "stutter" duplicates each entry threefold
		[1.2, 0.9, 0.25, 0.14, 0.07].stutter(3)
		]
	, striker, freq, 0, decay);
	Out.ar(0, Pan2.ar(son * amp));
}).add
)

// We could launch the patch all at once, but let's do it bit-by-bit so we understand what's going on

// Here we start the phone bells constantly ringing. We put them in a group for convenience
~bellgroup = Group.new(s);
~bell1 = Synth(\dsaf_phonebell2, [\freq, 650], ~bellgroup);
~bell2 = Synth(\dsaf_phonebell2, [\freq, 653], ~bellgroup);

// Now we add the bakelite
y = Synth(\dsaf_phonecase1, [\mix, -0.65], target: ~bellgroup, addAction: \addAfter);

// OK, shush for now
~bellgroup.set(\gate, 0);

// Now let's turn them on and off in a telephone-like pattern.
// This could be done using a synth, but let's use a (client-side) pattern:
p = Pbind(\type, \set, \id, ~bellgroup.nodeID, \args, [\gate], \gate, Pseq([1,0], inf), \dur, 2).play
p.stop
