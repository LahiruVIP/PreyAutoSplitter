//by LahiruVIP
//load remover by ShiningFace
state("Prey" , "1.0.0.0")
{
	//get area names
	string32 areaName1 : 0x02416EC0, 0x4;
	string32 areaName2 : 0x02BF3D08, 0x100, 0x418, 0x5A8, 0x8, 0x10, 0x40;
	//get loading status
	bool isLoading : 0x2433B13;
	bool isLoadingMain : 0x28CBDD0;
	byte isLoadingTextures : 0x24C08F6;
	byte isInCutscene : "bink2w64.dll", 0x57580;
	byte menuMode : 0x241C8A8, 0x1E60, 0x258;
}

init
{
	//if the timer is in real time, ask if the user want to change it to game time
	if ((settings["timerPopup"]) && timer.CurrentTimingMethod == TimingMethod.RealTime)
	{        
		var timingMessage = MessageBox.Show
		("This game uses Loadless (Game Time) as the main timing method.\n"+
		"LiveSplit is currently set to show RTA (Real Time).\n"+
		"Would you like to set the timing method to Game Time?",
		"Prey (2017) | LiveSplit",
		MessageBoxButtons.YesNo,MessageBoxIcon.Question);
	
		if (timingMessage == DialogResult.Yes) 
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
	
	if (settings["betaPopup"])
	{
		var betaMessage = MessageBox.Show
		("IMPORTANT: auto splitter is in Beta.\n"+
		"Bugs can still be present",
		"Prey (2017) | LiveSplit",
		MessageBoxButtons.OK);	
	}
	
	if ((settings["splitPopup"]) && timer.Run.CategoryName != "Any%")
	{	
		var timingMessage = MessageBox.Show
		("Auto Splitting fuctionality is currently only available for Any%.\n"+
		"Another category is selected, therefore splitting must be performed manually.",
		"Prey (2017) | LiveSplit",
		MessageBoxButtons.OK);
	}
	print("[AutoSplitter] INIT");
}


start
{
	//start the run
	if (current.menuMode == 1 && old.menuMode == 2 && current.areaName1 == "apartment" && current.areaName2.Contains("/simulationlabs"))
	{
		return true;
		vars.endsplit = false;
	}	
}


reset
{
	if ( old.menuMode == 1 && current.menuMode == 2 &&   current.isInCutscene == 0 &&  current.areaName1 == "apartment" && current.areaName2.Contains("/simulationlabs"))
	{
		return true;	
	}
	
}

startup
{
	//promt for game time
	settings.Add("timerPopup", true, "Prompt to use Loadless on startup");
	//promt for beta stage of auto splitter
	settings.Add("betaPopup", true, "Prompt to inform that the Autosplitter is in Beta");
	//promt for any% only
	settings.Add("splitPopup", true, "Inform that Auto Splitting does not work outside of Any%");
	//parent for any%
	settings.Add("any%", true, "Any%");
	//parent for leave the station
	settings.Add("Leave_the_Station", true, "Leave the Station");
	
	//area names for any%
    vars.autoSplitsAny = new Tuple<string,string>[]{
        Tuple.Create("Lobby"        ,"/lobby"     						),
        Tuple.Create("Life Support" ,"lifesupport"     					),
        Tuple.Create("Cargo Bay"    ,"cargobay"							),
        Tuple.Create("G.U.T.S. 1"   ,"zerog_utilitytunnels"    		  	),
		Tuple.Create("Arboretum"    ,"arboretum"    		  			),
		Tuple.Create("G.U.T.S. 2"   ,"zerog_utilitytunnels"    		 	),
		Tuple.Create("Psychotronics","psychotronics"    				),
		Tuple.Create("G.U.T.S. 3" 	,"zerog_utilitytunnels"    		  	),
		Tuple.Create("Arboretum" 	,"arboretum"    		  			),
		Tuple.Create("Bridge" 		,"bridge"    						),
	};
	
	//area names for leave the station
    vars.autoSplitsLeaveStation = new Tuple<string,string>[]{
        Tuple.Create("Lobby"        ,"/lobby"     ),
        Tuple.Create("Life Support" ,"ng/lifesupport"     ),
        Tuple.Create("Cargo Bay"    ,"dlc01/conservatory/conservatory_p"),
        Tuple.Create("G.U.T.S."   ,"zerog_utilitytunnels"    		  ),
		Tuple.Create("Arboretum"    ,"/arboretum"    		  ),

	};	
	
	
	//create custom splits for any% setting
	int i = 0;
	foreach(var autoSplitAny in vars.autoSplitsAny){
		settings.Add("autosplit_Any_"+i.ToString(),true,"Split on entering \""+autoSplitAny.Item1+"\"", "any%");

		++i;
	}
	settings.Add("autosplit_end_any",true,"Split on run end", "any%");




/* 	int i2 = 0;
	foreach(var autoSplitLeaveStation in vars.autoSplitsLeaveStation){
		settings.Add("autosplit_Leave_Station_"+i2.ToString(),true,"Split on entering \""+autoSplitLeaveStation.Item1+"\"", "Leave_the_Station");

		++i;
	}
	settings.Add("autosplit_end_leavestation",true,"Split on run end", "Leave_the_Station");


	vars.autoSplitIndex = -1; */
	
	//needed to prevent end split loop
	
	vars.endsplit = false;
	
	print("[AutoSplitter] STARTUP");

}

split
{
	//check if the category is any%
	if (timer.Run.CategoryName == "Any%"){		 
		//check the any custom settings and split if true
		//old.areaName2 refers to the previous area new.areaName2 refers to the area the games is loading
		
		if (settings["autosplit_Any_0"] && old.areaName2.Contains("simulationlabs") && current.areaName2.Contains("lobby")){
			return true;		
		}
		else if (settings["autosplit_Any_1"] && old.areaName2.Contains("lobby") && current.areaName2.Contains("lifesupport")){
			return true;		
		}
		else if (settings["autosplit_Any_2"] && old.areaName2.Contains("lifesupport") && current.areaName2.Contains("cargobay")){
			return true;		
		}
		else if (settings["autosplit_Any_3"] && old.areaName2.Contains("cargobay") && current.areaName2.Contains("zerog_utilitytunnels")){
			return true;		
		}
		else if (settings["autosplit_Any_4"] && old.areaName2.Contains("zerog_utilitytunnels") && current.areaName2.Contains("/arboretum")){
			return true;		
		}
		else if (settings["autosplit_Any_5"] && old.areaName2.Contains("/arboretum") && current.areaName2.Contains("zerog_utilitytunnels")){
			return true;		
		}
		else if (settings["autosplit_Any_6"] && old.areaName2.Contains("zerog_utilitytunnels") && current.areaName2.Contains("psychotronics")){
			return true;		
		}
		else if (settings["autosplit_Any_7"] && old.areaName2.Contains("psychotronics") && current.areaName2.Contains("zerog_utilitytunnels")){
			return true;		
		}
		else if (settings["autosplit_Any_8"] && old.areaName2.Contains("zerog_utilitytunnels") && current.areaName2.Contains("arboretum")){
			return true;		
		}
		else if (settings["autosplit_Any_9"] && old.areaName2.Contains("arboretum") && current.areaName2.Contains("bridge")){
			return true;		
		}
		else if (settings["autosplit_end_any"] && current.areaName2.Contains("bridge") /* && current.areaName1 == "Bridge" */ && current.isInCutscene == 1 && vars.endsplit == false){
			vars.endsplit = true;
			return true;
			
		}
	}

	// if the category is leave the station use the default splitting method
	else if (timer.Run.CategoryName == "Leave the Station" && current.areaName2 != old.areaName2){
		print(current.areaName1);
		print(old.areaName1);
		print(current.areaName2);
		print(old.areaName2);
		return true;
	}
	
	
}

isLoading
{
	//check if the game is loading
	return
	current.isLoading ||
	current.isLoadingMain ||
	current.isLoadingTextures == 1 ||
	current.menuMode == 2;	
}