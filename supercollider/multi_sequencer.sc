(
var w, status, limit, buttons, controls = [], one_button, data, synths, one_synth, synths_generator,
density_one = 1/4, density_many = 1/10, type_distribution = [0.85, 0.15], // tweak it to get more or less dense pattern grid
task, resolution, direction, pos = 0, step = 1, border = 1, dims = [16,16]; // tweak dims to change size of grid
w = Window("rand-n-step+", Rect(50,250,dims[0]*22+10+250,dims[1]*22+60)).acceptsMouseOver_(true); // window init
status = StaticText(w, Rect(5, w.bounds.height - 20, w.bounds.width, 20));
limit = { ReplaceOut.ar(0, Limiter.ar(In.ar(0,2))) }.play( addAction:\addToTail ); // limiter
data = Array2D(dims[1],dims[0]); // prepare data
// and buttons
one_button = { | b, density = 0.1 |
	b.valueAction = 0; // reset
	density.coin.if({ b.valueAction = [1,2].wchoose(type_distribution) }); // tweak it
};
synths = Array.fill(dims[1], { () });
buttons = Array.fill(dims[1], { |l|
	controls = controls.add([ // control buttons
		Button( w, Rect( 10 + (22*dims[0]), 35 + (22*l), 20, 20) ).states_([['m'],['u']]).action_({ |b| // mute / unmute
			synths[l].gate = b.value.booleanValue.not.binaryValue;
		}).mouseOverAction_({ status.string = 'mute/unmute' }),
		Button( w, Rect( 10 + (22*(dims[0]+1)), 35 + (22*l), 20, 20) ).states_([['p']]).action_({ // dice pattern line
			buttons[l].do({ |b| one_button.(b, density_one) }); // tweak it
		}).mouseOverAction_({ status.string = 'randomize pattern' }),
		Button( w, Rect( 10 + (22*(dims[0]+2)), 35 + (22*l), 20, 20) ).states_([['s']]).action_({ // dice one synth
			synths[l] = one_synth.(l);
		}).mouseOverAction_({ status.string = 'randomize synth' }),
		Slider( w, Rect( 10 + (22*(dims[0]+3)), 35 + (22*l), 60, 20) ).action_({ |b| // synth amp
			synths[l].amp = b.value.linexp(0,1,1/16,16);
		}).mouseOverAction_({ status.string = 'tweak synth amp' }),
		Slider( w, Rect( 10 + (22*(dims[0]+3)+60), 35 + (22*l), 60, 20) ).action_({ |b| // synth stretch
			synths[l].stretch = b.value.linexp(0,1,1/8,8);
		}).mouseOverAction_({ status.string = 'tweak synth stretch' }),
		Slider( w, Rect( 10 + (22*(dims[0]+3)+120), 35 + (22*l), 60, 20) ).action_({ |b| // synth pan
			synths[l].pan = b.value.linlin(0,1,-1,1);
		}).mouseOverAction_({ |b| status.string = 'tweak synth pan ' })
	]);
	Array.fill(dims[0], { |i| // grid
		Button( w, Rect( 5 + (22*i), 35 + (22*l), 20, 20) ).states_([ ['-'], ['+'], ['%'] ]).action_({
			|b| data[l,i] = b.value
		}).mouseOverAction_({ status.string = '"%" makes sound with 0.5 probability' });
	});
});
// synth gen functions and initialization
one_synth = { |i| // tweak this function to (generate and) return other synthdef names
	var name = 'rstp'++i, pan = -1.0.rand2;
	SynthDef(name, { |index = 0, amp = 1, stretch = 1, pan = 0| // args: horizontal position in grid, amplitude and stretch correction, pan
		var sig = Pan2.ar( // tweak sig to get different sound texture
			PMOsc.ar(80.exprand(10000), 1.exprand(200), 1.exprand(20)),
			pan,
			EnvGen.kr(Env(Array.rand(4, 0, 0.05.rrand(0.4)).add(0), Array.rand(3, 0.1, 1.2).add(0.1), 5.rand2), levelScale: amp, timeScale: stretch, doneAction: 2)
		);
		Out.ar(0, sig);
	}).add;
	controls[i][3].valueAction_(1.explin(1/16,16,0,1));
	controls[i][4].valueAction_(1.explin(1/8,8,0,1));
	controls[i][0].valueAction_(0);
	controls[i][5].valueAction_(pan.linlin(-1,1,0,1));
	(name: name, gate: 1, amp: 1, stretch: 1, pan: pan);
};
synths_generator = { Array.fill(dims[1], { |i| synths[i] = one_synth.(i) } ) };
synths_generator.();
// step task
task = Task({
	inf.do({
		pos = (pos + step).mod(dims[0]);
		dims[1].do({ |l|
			(buttons[l] @@ pos).font_(Font("sans", 20));
			(buttons[l] @@ (pos-step)).font_(Font("sans", 14));
			synths[l].gate.booleanValue.if({
				var args = [index: pos, amp: synths[l].amp, stretch: synths[l].stretch * TempoClock.tempo.reciprocal * resolution.reciprocal, pan: synths[l].pan ];
				switch( data[l,pos],
					1, { Synth(synths[l].name, args) },
					2, { 0.5.coin.if({ Synth(synths[l].name, args) }) }
				);
			});
		});
		switch( pos,
			0,             { (border == -1 && step == -1).if({ direction.valueAction = 0 }) },
			(dims[0] - 1), { (border == -1 && step ==  1).if({ direction.valueAction = 1 }) }
		);
		(TempoClock.default.tempo.reciprocal / resolution).yield;
	});
}, AppClock).play(quant:[0]);
// app buttons
Button(w, Rect(5,5, w.bounds.width - 10 / 7, 20)).states_([['reset']]).action_({ |b|
	synths_generator.();
	buttons.flat.do({ |b| one_button.(b, 0) }); // tweak it
}).mouseOverAction_({ status.string = 'reset everything' });
Button(w, Rect(w.bounds.width - 10 / 7 * 1 + 5, 5, w.bounds.width - 10 / 6, 20)).states_([['lucky?']]).action_({ |b| // lazy patterns
	buttons.flat.do({ |b| one_button.(b, density_many) }); // tweak it
}).mouseOverAction_({ status.string = 'create random pattern grid' });
Button(w, Rect(w.bounds.width - 10 / 7 * 2 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['noisy?']]).action_({ |b|
	synths_generator.();
}).mouseOverAction_({ status.string = 'randomize all synths' });
Button(w, Rect(w.bounds.width - 10 / 7 * 3 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['pause'],['play']]).action_({ |b|
	b.value.booleanValue.if({ task.pause }, { task.resume(quant:[0]) });
}).mouseOverAction_({ status.string = 'play/pause' });
direction = Button(w, Rect(w.bounds.width - 10 / 7 * 4 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['r-t-l'],['l-t-r']]).action_({ |b|
	b.value.booleanValue.if({ step = -1 }, { step = 1 });
}).mouseOverAction_({ status.string = 'change playing direction' });
Button(w, Rect(w.bounds.width - 10 / 7 * 5 + 5, 5, w.bounds.width - 10 / 7, 20)).states_([['fold'],['wrap']]).action_({ |b|
	b.value.booleanValue.if({ border = -1 }, { border = 1 });
}).mouseOverAction_({ status.string = 'behavior on the grid border' });
Slider(w, Rect(w.bounds.width - 10 / 7 * 6 + 5, 5, w.bounds.width - 10 / 7, 20)).action_({ |b|
	resolution = b.value.linlin(0, 1, 1, 8).quantize(1, 1);
	status.string = 'resolution: ' ++ resolution;
}).valueAction_(4.linlin(1,8,0,1)).mouseOverAction_({ status.string = 'change grid resulution' });
// show
w.front.onClose = { task.stop; limit.free };
status.string_('hello, point something to get hint, hopefully..');
)
