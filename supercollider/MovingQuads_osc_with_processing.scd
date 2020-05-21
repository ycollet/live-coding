// First, start processing and start MovingQuads.pde script.
// Be careful, the port 8060 must be available and accessible.

b = NetAddr.new("127.0.0.1", 8060);

// Test modifying the color of one quad
b.sendMsg("/processing/Q1", 255, 255, 255)

// Definition of a simple synth 
(
SynthDef("SynthSin", { |freq=440, out|
    Out.ar(out,
        SinOsc.ar(freq, 0, 0.2) * Line.kr(1, 0, 1, doneAction: Done.freeSelf)
    )
}).add;
)

// Test the synth
a = Synth("SynthSin", [\freq, 230]);

(
r = Routine({
	// Define sequence of Rgb colors by group of quads
	var p1c1 = Pseq([255, 0,   0],   inf);
	var p1c2 = Pseq([0,   255, 0],   inf);
	var p1c3 = Pseq([0,   0,   255], inf);
	var p2c1 = Pseq([255, 0,   255, 127], inf);
	var p2c2 = Pseq([0,   255, 0,   0],   inf);
	var p2c3 = Pseq([0,   0,   255, 127], inf);
	var p3c1 = Pseq([255, 0,   255, 127, 0],   inf);
	var p3c2 = Pseq([0,   255, 0,   0,   127], inf);
	var p3c3 = Pseq([0,   0,   255, 127, 127], inf);
	var p4c1 = Pseq([255, 0,   255, 127, 0  , 255], inf);
	var p4c2 = Pseq([0,   255, 0,   0,   127, 255], inf);
	var p4c3 = Pseq([0,   0,   255, 127, 127, 255], inf);

	var q1c1 = p1c1.asStream;
	var q1c2 = p1c2.asStream;
	var q1c3 = p1c3.asStream;
	var q5c1 = p1c1.asStream;
	var q5c2 = p1c2.asStream;
	var q5c3 = p1c3.asStream;
	var q9c1 = p1c1.asStream;
	var q9c2 = p1c2.asStream;
	var q9c3 = p1c3.asStream;

	var q2c1 = p2c1.asStream;
	var q2c2 = p2c2.asStream;
	var q2c3 = p2c3.asStream;
	var q4c1 = p2c1.asStream;
	var q4c2 = p2c2.asStream;
	var q4c3 = p2c3.asStream;

	var q3c1 = p3c1.asStream;
	var q3c2 = p3c2.asStream;
	var q3c3 = p3c3.asStream;
	var q7c1 = p3c1.asStream;
	var q7c2 = p3c2.asStream;
	var q7c3 = p3c3.asStream;

	var q6c1 = p4c1.asStream;
	var q6c2 = p4c2.asStream;
	var q6c3 = p4c3.asStream;
	var q8c1 = p4c1.asStream;
	var q8c2 = p4c2.asStream;
	var q8c3 = p4c3.asStream;

	loop({
		// Send the colors to various quads on processing
		b.sendMsg("/processing/Q1", q1c1.value, q1c2.value, q1c3.value);
		b.sendMsg("/processing/Q2", q2c1.value, q2c2.value, q2c3.value);
		b.sendMsg("/processing/Q3", q3c1.value, q3c2.value, q3c3.value);
		b.sendMsg("/processing/Q4", q4c1.value, q4c2.value, q4c3.value);
		b.sendMsg("/processing/Q5", q5c1.value, q5c2.value, q5c3.value);
		b.sendMsg("/processing/Q6", q6c1.value, q6c2.value, q6c3.value);
		b.sendMsg("/processing/Q7", q7c1.value, q7c2.value, q7c3.value);
		b.sendMsg("/processing/Q8", q8c1.value, q8c2.value, q8c3.value);
		b.sendMsg("/processing/Q9", q9c1.value, q9c2.value, q9c3.value);

		// Wait for 1 second
		1.yield;

		// Get next values and store the values to reuse for sound generation
		~n1c1 = q1c1.next; ~n1c2 = q1c2.next; ~n1c3 = q1c3.next;
		~n2c1 = q2c1.next; ~n2c2 = q2c2.next; ~n2c3 = q2c3.next;
		~n3c1 = q3c1.next; ~n3c2 = q3c2.next; ~n3c3 = q3c3.next;
		~n4c1 = q4c1.next; ~n4c2 = q4c2.next; ~n4c3 = q4c3.next;
		~n5c1 = q5c1.next; ~n5c2 = q5c2.next; ~n5c3 = q5c3.next;
		~n6c1 = q6c1.next; ~n6c2 = q6c2.next; ~n6c3 = q6c3.next;
		~n7c1 = q7c1.next; ~n7c2 = q7c2.next; ~n7c3 = q7c3.next;
		~n8c1 = q8c1.next; ~n8c2 = q8c2.next; ~n8c3 = q8c3.next;
		~n9c1 = q9c1.next; ~n9c2 = q9c2.next; ~n9c3 = q9c3.next;

		if (~n1c1 != 0) {
			a = Synth("SynthSin", [\freq, 130]);
		};

		if (~n2c1 != 0) {
			a = Synth("SynthSin", [\freq, 230]);
		};

		if (~n3c1 != 0) {
			a = Synth("SynthSin", [\freq, 330]);
		};

		if (~n6c1 != 0) {
			a = Synth("SynthSin", [\freq, 430]);
		};
	});
});
)

// Evaluate periodically the routine
TempoClock.default.sched(0, r);

r.next;
r.stop;

// To test modifying the color of one quad
b.sendMsg("/processing/Q1", ~q1c1.value, ~q1c2.value, ~q1c3.value);
~q1c1.next; ~q1c2.next; ~q1c3.next;
