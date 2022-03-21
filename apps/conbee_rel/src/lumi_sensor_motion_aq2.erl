%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description :  
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(lumi_sensor_motion_aq2).    
     
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-define(ModelId,"lumi.sensor.motion.aq2").
-define(Type,"sensors").
%% --------------------------------------------------------------------



%% External exports
-export([
	 is_presence/1
	]). 


%% ====================================================================
%% External functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------

is_presence(Name)->
    {ok,List}=lib_conbee:device(?Type,Name),
    [IsPresence]=[maps:get(<<"presence">>,StateMap)||{_Name,_NumId,_ModelId,StateMap}<-List,
					   lists:member( <<"presence">>,maps:keys(StateMap))],
    IsPresence.
