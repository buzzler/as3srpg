import buzzler.core.BzCamera;
import buzzler.core.BzScene;
import buzzler.core.BzViewport;
import buzzler.data.BzRectangle;
import buzzler.data.BzRotation;
import buzzler.data.display.BzElement;
import buzzler.system.ai.BzStateMachine;

import controller.DataCenter;
import controller.InputListener;

import datas.Block;
import datas.Collection;
import datas.Level;
import datas.Paths;
import datas.Profile;
import datas.objects.*;

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.getDefinitionByName;

import mx.collections.ArrayCollection;

import states.GSLoadProfile;

private	var _fsm:BzStateMachine;

public	function getFSM():BzStateMachine
{
	return _fsm;
}

private	function onEnterFrame(event:Event):void
{
	_fsm.update();
}

private	function onInit():void
{
	BzRock;
	BzGrass;
	BzBox;
	BzDummy;
	BzPlayer;
	UnitFighter;
	
	_fsm = new BzStateMachine(this);
	_fsm.changeState( new GSLoadProfile() );
	this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
}

/**
 *	for admin
 */
[Bindable]
private	var _types:ArrayCollection = new ArrayCollection(["BzPlayer","BzRock","BzGrass", "BzBox"]);

private	function onClickLeft():void
{
	var dcenter:DataCenter = DataCenter.getInstance();
	var add:BzRotation = new BzRotation(90);
	var rot:BzRotation = dcenter.level.camera.getBzRotation();
	
	dcenter.level.camera.setBzRotation( rot.add(add).getValue() );
}

private	function onClickRight():void
{
	var dcenter:DataCenter = DataCenter.getInstance();
	var add:BzRotation = new BzRotation(-90);
	var rot:BzRotation = dcenter.level.camera.getBzRotation();
	
	dcenter.level.camera.setBzRotation( rot.add(add).getValue() );
}

private	function onClickCreate():void
{
	var x:int = parseInt( this.adminX.text );
	var y:int = parseInt( this.adminY.text );
	var z:int = parseInt( this.adminZ.text );

	var name:String = this.adminTypes.selectedItem as String;
	var id:String = name + (Math.random()*9999999).toFixed();
	
	var BlockClass:Class = flash.utils.getDefinitionByName("datas.objects."+name) as Class;
	var element:BzElement = new BlockClass(id, x,y,z);	
	var dcenter:DataCenter = DataCenter.getInstance();
	dcenter.level.scene.addBzElement(element);
}

private	function onClickSave():void
{
	var dcenter:DataCenter = DataCenter.getInstance();
	var xml:XML = Level.generateFromLevel(dcenter.level);
	trace(xml);
}