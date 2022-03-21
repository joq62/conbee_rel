%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Created :
%%% Node end point  
%%% Creates and deletes Pods
%%% 
%%% API-kube: Interface 
%%% Pod consits beams from all services, app and app and sup erl.
%%% The setup of envs is
%%% -------------------------------------------------------------------
-module(basic_eunit).   
 
-export([start/0]).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
-include_lib("kernel/include/logger.hrl").
%% --------------------------------------------------------------------
%% Function: available_hosts()
%% Description: Based on hosts.config file checks which hosts are avaible
%% Returns: List({HostId,Ip,SshPort,Uid,Pwd}
%% --------------------------------------------------------------------


start()->
    ok=application:start(conbee_rel),
    pong=conbee:ping(),
    application:ensure_all_started(gun),
    io:format("lights ~p~n",[lib_conbee:all_info("lights")]),
    io:format("sensors ~p~n",[lib_conbee:all_info("sensors")]),
    tradfri_ww_test(),
    tradfri_control_outlet(),
    sensors_test(),
 
   % loop(), 
 
   % t2(),

   % init:stop(),
    ok.
sensors_test()->
    io:format("temp ~p~n",[lumi_weather:temp("temp_indoor")]),
    io:format("humidity ~p~n",[lumi_weather:humidity("temp_indoor")]),
    io:format("pressure ~p~n",[lumi_weather:pressure("temp_indoor")]),

    io:format("is_open ~p~n",[lumi_sensor_magnet_aq2:is_open("door_main_entrance")]),
    io:format("is_presence ~p~n",[lumi_sensor_motion_aq2:is_presence("presence_hall")]),
    ok.

tradfri_control_outlet()->
     true=tradfri_control_outlet:reachable("lamp_hall"),
    io:format("is_on ~p~n",[tradfri_control_outlet:is_on("lamp_hall")]),
    tradfri_control_outlet:set("lamp_hall","on"),
    timer:sleep(2000),
    tradfri_control_outlet:set("lamp_hall","off"),   
    ok.


  
tradfri_ww_test()->
    true=tradfri_bulb_e27_ww_806lm:reachable("outdoor_lamp"),
    io:format("is_on ~p~n",[tradfri_bulb_e27_ww_806lm:is_on("outdoor_lamp")]),
    io:format("bri ~p~n",[tradfri_bulb_e27_ww_806lm:get_bri("outdoor_lamp")]),
    tradfri_bulb_e27_ww_806lm:set("outdoor_lamp","on"),
    timer:sleep(2000),
     io:format("set_bri ~p~n",[tradfri_bulb_e27_ww_806lm:set_bri("outdoor_lamp",200)]),
    
    timer:sleep(3000),
    io:format("set_bri ~p~n",[tradfri_bulb_e27_ww_806lm:set_bri("outdoor_lamp",2)]),
    timer:sleep(3000),
    tradfri_bulb_e27_ww_806lm:set("outdoor_lamp","off"),   
    ok.


t1_test()->
    io:format("lights ~p~n",[lib_conbee:all_info("lights")]),
    io:format("sensors ~p~n",[lib_conbee:all_info("sensors")]),
    
    {ok,{"TRADFRI bulb E27 CWS 806lm","6",
	 _}}=lib_conbee:device("lights","TRADFRI bulb E27 CWS 806lm"),
    {error,[eexists,"sensors","TRADFRI bulb E27 CWS 806lm"]}=lib_conbee:device("sensors","TRADFRI bulb E27 CWS 806lm"),
    ok.




loop()->
    read_test(),
    set_test(),
    timer:sleep(2000),
    loop().




% 21B8A3D920

set_test()->
    % set light on/off
    io:format("set_test ~p~n",[glurk]),
    io:format("set 3 ON ~p~n",[lights:set_state("3","on")]),
    io:format("set 4 ON ~p~n",[lights:set_state("4","on")]),
    io:format("set 5 ON ~p~n",[lights:set_state("5","on")]),
    io:format("set 6 ON ~p~n",[lights:set_state("6","on")]),
    timer:sleep(4000),
    io:format("set 5 OFF ~p~n",[lights:set_state("5","off")]),
    io:format("set 4 OFF ~p~n",[lights:set_state("4","off")]),
    io:format("set 3 OFF ~p~n",[lights:set_state("3","off")]),
    io:format("set 6 OFF ~p~n",[lights:set_state("6","off")]),
  %  ok=lights:set_state("4","on"),
  %  ok=lights:set_state("5","on"),
  %  timer:sleep(2000),
  %  gl=lights:set_state("5","off"),
    
    ok.
    


rec()->
    receive
	Msg->
	    case Msg of
		{gun_up,_,http}->
		    io:format("Msg ~p~n",[{?MODULE,?LINE,Msg}]),
		    rec();
		{gun_response,_,_,nofin,200,_}->
		    io:format("Msg ~p~n",[{?MODULE,?LINE,Msg}]),
		    rec();
		_ ->
		    io:format("Msg ~p~n",[{?MODULE,?LINE,Msg}]),
		    rec()
	    end
    end.
			    
t2()->
    % http://172.17.0.2:80/api/9FC8DF92DC/lights/2/state    
    % {"on":true}
    ok.
t0_test()->
    
    ok.
curl_test()->
    Link="172.17.0.2",
    Cmd = "curl -s GET \"" ++ Link ++ "\"",
    Output = os:cmd(Cmd),
    io:format("Output ~p~n",[{Output,?MODULE,?LINE}]),
    Output.

read_test()->
    inets:start(),
    {ok, {{Version, 200, ReasonPhrase}, Headers, Body}} =
      httpc:request(get,{"https://phoscon.de/discover",[]},[],[{body_format,binary}]),
    %gl=Body,
    Map=jsx:decode(Body,[]),
 %   io:format("Map ~p~n",[Map]),
    
    io:format("************~p ****************~n",[time()]),
   % init:stop(),
   % timer:sleep(3000),
    Info=sensors:get_info(),  
 %   Info=sensors:get_info("192.168.0.100",8080,"/api/0BDFAC94EE/sensors"),     
%    io:format("Info ~p~n",[Info]),
    Sensors=[{Type,Id,Key,Value}||[{name,Name},{id,Id},{type,Type},{status,{Key,Value}}]<-Info],
    Sorted=lists:keysort(2,Sensors),
    [io:format("~p~n",[Sensor])||Sensor<-Sorted],
    io:format("----------------------------------------------~n"),
%  glurk=Raw=conbee:sensors_raw(),    
 %   io:format("Raw ~p~n",[Raw]),
%    io:format("indoor_temp_1 ~p~n",[Raw]),
    
%-------- lights
    LightInfo=lights:get_info(),    
 
%    io:format("Info ~p~n",[Info]),
    Lights=[{Type,Id,Key,Value}||[{name,Name},{id,Id},{type,Type},{status,{Key,Value}}]<-LightInfo],
    SortedLights=lists:keysort(2,Lights),
    [io:format("~p~n",[Light])||Light<-SortedLights],
    io:format("----------------------------------------------~n"),
 
    io:format("temp_main_house  ~p~n",[varmdo_mm:temp_main_house()]),
    io:format("door_main  ~p~n",[varmdo_mm:door_main()]),
    io:format("presence_hall ~p~n",[varmdo_mm:presence_hall()]),
    ok.

   % timer:sleep(10*1000),
   % pass_0().
    


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------



%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% -------------------------------------------------------------------
