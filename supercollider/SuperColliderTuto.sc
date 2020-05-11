{WhiteNoise.ar(0.1)!2}.scope

{LPF.ar(WhiteNoise.ar(0.1),1000)!2}.scope

{LPF.ar(WhiteNoise.ar(0.1),Line.kr(10000,1000,10))!2}.scope //listen for ten seconds at least to hear the full effect

{Resonz.ar(LFNoise0.ar(400),1000,0.01)!2}.scope

{Resonz.ar(LFNoise0.ar(400),Line.kr(10000,1000,10),Line.kr(1,0.01,10))!2}.scope

(
{
  var source = LFNoise0.ar(400);
  var line   = Line.kr(10000,1000,10);
  var filter = Resonz.ar(source,line,0.1); //the filtered output is the input source filtered by Resonz with a line control for the resonant frequency
  filter!2 // last thing is returned from function in curly brackets, i.e. this is the final sound we hear
}.scope;
)

{Pan2.ar(WhiteNoise.ar(0.1), MouseX.kr(-1,1))}.scope

{Mix(SinOsc.ar([400,660],0,0.1))}.scope //a two channel signal put through Mix turns into mono

{Pan2.ar(Mix(SinOsc.ar([400,660],0,0.1)),MouseX.kr(-1,1))}.scope //a two channel signal put through Mix turns into mono

(
{
	var n = 10;
	var wave = Mix.fill(10,{|i|
    	var mult= ((-1)**i)*(0.5/((i+1)));
    	SinOsc.ar(440*(i+1))*mult
    });
	Pan2.ar(wave/n,0.0); //stereo, panned centre
}.scope;
)

{Mix(SinOsc.ar(500*[0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1],0,0.1*[0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope //bell spectra, different volumes for partials

(
  var n = 10;
  {Mix(SinOsc.ar(250*(1..n),0,1/n))}.scope;
)

{SinOsc.ar(mul:0.5)}.scope
{SinOsc.ar(mul:MouseY.kr(1.0,0.1))}.scope		//demo of amplitude scaling
{SinOsc.ar(mul:MouseX.kr(0.1,1.0), add:MouseY.kr(0.9,-0.9))}.scope

(
{
	//cutoff values need to be sensible frequencies in Hz; here sine output turned from -1 to 1 into 2000+-1700
	var cutoff = 	SinOsc.ar(MouseY.kr(1.0,10.0),mul:MouseX.kr(0.0,1700.0), add:2000.0);
	//var cutoff = SinOsc.ar(1)*1700.0 + 2000.0;  //same thing
	LPF.ar(WhiteNoise.ar,freq:cutoff);
}.scope
)

{SinOsc.ar(440, mul: -20.dbamp)}.scope   //use dBs! The conversion calculation is done just once at the initialisation of the UGen

a = {SinOsc.ar(440)*0.1}.play
a.run(false) //turn off synthesis (saving CPU) without freeing the Synth
a.run //restore (defaults to a.run(true)
a.free //stop it explicitly: note that I didn't need to use the 'stop all' cmd+. or alt+. key command, and can individual kill specific Synths this way

a = {arg freq=440; SinOsc.ar(freq)*0.1}.play
a.set(\freq,330) //change frequency!

a = {arg freq=440, amp=0.1; SinOsc.ar(freq)*amp}.play
a.set(\freq,rrand(220,440), \amp, rrand(0.05,0.2)) //change frequency and amplitude randomly within a uniform range; run this line multiple times

(
{
  var carrfreq  = MouseX.kr(440,5000,'exponential');
  var modfreq   = MouseY.kr(1,5000,'exponential');
  var carrier   = SinOsc.ar(carrfreq,0,0.5);
  var modulator = SinOsc.ar(modfreq,0,0.5);

  carrier*modulator;
}.scope
)

(
{
  var carrfreq  = MouseX.kr(440,5000,'exponential');
  var modfreq   = MouseY.kr(1,5000,'exponential');
  var carrier   = SinOsc.ar(carrfreq,0,0.5);
  var modulator = SinOsc.ar(modfreq,0,0.25, 0.25);

  carrier*modulator;
}.scope
)

(
var w, carrfreqslider, modfreqslider, moddepthslider, synth;

w = Window("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth = {arg carrfreq=440, modfreq=1, moddepth=0.01;
SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)),0,0.25)
}.scope;

carrfreqslider= EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {|ez|  synth.set(\carrfreq, ez.value)});

w.view.decorator.nextLine;

modfreqslider= EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {|ez|  synth.set(\modfreq, ez.value)});

w.view.decorator.nextLine;

moddepthslider= EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {|ez|  synth.set(\moddepth, ez.value)});

w.front;
)

(
{
  var modfreq  = MouseX.kr(1,440, 'exponential');
  var modindex = MouseY.kr(0.0,10.0);

  SinOsc.ar(SinOsc.ar(modfreq,0,modfreq*modindex, 440),0,0.25)

}.scope
)

//more complicated sound combining AM, FM, chorusing and time-variation from Line and XLine

(
{
Mix(
	Resonz.ar(//The Resonz filter has arguments input, freq, rq=bandwidth/centre frequency
		Saw.ar([440,443,437] + SinOsc.ar(100,0,100)), //frequency modulated sawtooth wave with chorusing
		XLine.kr(10000,10,10), //vary filter bandwidth over time
		Line.kr(1,0.05, 10), //vary filter rq over time
		mul: LFSaw.kr(Line.kr(3,17,3),0,0.5,0.5)*Line.kr(1,0,10)  //AM
	)
)
}.scope
)

//run me first to load the soundfiles
(
  b=Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");
)

//now me!
(
{
  var modfreq   = MouseX.kr(1,4400, 'exponential');
  var modindex  = MouseY.kr(0.0,10.0,'linear');
  var modulator = SinOsc.kr(modfreq,0,modfreq*modindex, 440);

  PlayBuf.ar(1,b, BufRateScale.kr(b)* (modulator/440), 1, 0, 1)
}.scope;
)

//richer bell patch
(
  var spectrum = [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1];
  var amplitudes= [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1];
  var numpartials = spectrum.size;
  var modfreqs1 = Array.rand(numpartials, 1, 5.0); //vibrato rates from 1 to 5 Hz
  var modfreqs2 = Array.rand(numpartials, 0.1, 3.0); //tremolo rates from 0.1 to 3 Hz
  var decaytimes = Array.fill(numpartials,{|i|  rrand(2.5,2.5+(5*(1.0-(i/numpartials))))}); //decay from 2.5 to 7.5 seconds, lower partials longer decay
{
Mix.fill(spectrum.size, {arg i;
	var freq = (spectrum[i]+(SinOsc.kr(modfreqs1[i],0,0.005)))*500;
	var amp  = 0.1* Line.kr(1,0,decaytimes[i])*(SinOsc.ar(modfreqs2[i],0,0.1,0.9)* amplitudes[i]);
	Pan2.ar(SinOsc.ar(freq, 0, amp),1.0.rand2)});
}.scope
)

{SinOsc.ar(440,0,Line.kr(0.1,0,1,doneAction:2))}.scope		//doneAction:2 causes the Synth to be terminated once the line generator gets to the end of its line

Env([1,0,1],[1,1]).plot  //This makes an Envelope with three control points, at y positions given by the first array, and separated in x by the values in the second (see the Env help file). The curve drawn out should actually look like a letter envelope!

Env([0,1,0],[1.0,0.5]).plot  //one second 0 to 1 then half a second 1 to 0
Env.linen(0.03,0.5,0.1).plot  //linen has attackTime, sustainTime, releaseTime, level, curve
Env.adsr(0.01, 0.5, 0.5, 0.1, 1.0, 0).plot  //attackTime, decayTime, sustainLevel, releaseTime, peakLevel, curve
//note that the sustain portion is not shown in time; this particular envelope type deals with variable hold times, and the hold is missed out in the plot
Env.perc(0.05,0.5,1.0,0).plot //arguments attackTime, releaseTime, level, curve: good for percussive hit envelopes

{EnvGen.ar(Env([1,0],[1.0]))}.scope
{SinOsc.ar(440,0,0.1)*EnvGen.kr(Env([1,0],[1.0]))}.scope

(
{
	Saw.ar(
		EnvGen.kr(Env([10000,20],[0.5])),  //frequency input
		EnvGen.kr(Env([0.1,0],[2.0]))      //amplitude input
	)
}.play
)

//FM sound
(
{
SinOsc.ar(
	SinOsc.ar(10,0,10,440),
	0.0,
	EnvGen.kr(Env([0.5,0.0],[1.0]), doneAction:2)   //doneAction:2 appears again, the deallocation operation
	)
}.scope
)
